-- Logistics requests, and trade finance enquiries.
--
-- Ship with BUBU was a tab with free-text boxes that saved nothing. A haulage
-- request has a fixed shape — where from, where to, what vehicle, what load,
-- when — so it gets a table of its own rather than being squeezed into the
-- finance enquiry.
--
-- Trade finance joins finance_enquiries as a third kind, because admin should
-- read credit, tax and invoice finance in one queue rather than three.
--
-- Safe to re-run.

begin;

-- ── Logistics ───────────────────────────────────────────────────────────────
create table if not exists public.logistics_requests (
  id            uuid primary key default gen_random_uuid(),
  account_id    uuid not null,
  from_district text,
  to_district   text,
  vehicle_type  text,
  load_desc     text,
  weight_kg     numeric,
  pickup_on     date,
  estimate_ugx  bigint,
  distance_km   integer,
  state         text not null default 'new',
  note          text,
  created_at    timestamptz not null default now(),
  handled_at    timestamptz,
  handled_by    uuid
);

do $$
begin
  if not exists (select 1 from pg_constraint where conname = 'logistics_requests_acct_fk') then
    alter table public.logistics_requests
      add constraint logistics_requests_acct_fk
      foreign key (account_id) references public.accounts(id) on delete cascade;
  end if;
end $$;

create index if not exists logistics_requests_new_idx
  on public.logistics_requests (state, created_at desc);

alter table public.logistics_requests enable row level security;

drop policy if exists lr_read on public.logistics_requests;
create policy lr_read on public.logistics_requests for select using (
  account_id = public.current_account_id() or public.is_admin()
);

drop policy if exists lr_insert on public.logistics_requests;
create policy lr_insert on public.logistics_requests for insert with check (
  account_id = public.current_account_id()
);

-- The caller's own account is used, so a request can never be filed against
-- somebody else's business.
create or replace function public.submit_logistics_request(
  p_from text, p_to text, p_vehicle text, p_load text,
  p_weight numeric, p_pickup date, p_estimate bigint, p_distance integer)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare v_acct uuid; v_id uuid;
begin
  v_acct := current_account_id();
  if v_acct is null then raise exception 'Sign in first'; end if;
  insert into logistics_requests (account_id, from_district, to_district, vehicle_type,
    load_desc, weight_kg, pickup_on, estimate_ugx, distance_km)
  values (v_acct, nullif(trim(coalesce(p_from,'')),''), nullif(trim(coalesce(p_to,'')),''),
    nullif(trim(coalesce(p_vehicle,'')),''), nullif(trim(coalesce(p_load,'')),''),
    p_weight, p_pickup, p_estimate, p_distance)
  returning id into v_id;
  return v_id;
end;
$$;

grant execute on function public.submit_logistics_request(text,text,text,text,numeric,date,bigint,integer)
  to authenticated;

-- Admin's queue: the request plus who asked, so they can pick up the phone.
create or replace function public.admin_logistics_requests()
returns setof jsonb
language sql
stable
security definer
set search_path = public
as $$
  select jsonb_build_object(
    'id', l.id, 'state', l.state, 'created_at', l.created_at,
    'from_district', l.from_district, 'to_district', l.to_district,
    'vehicle_type', l.vehicle_type, 'load_desc', l.load_desc,
    'weight_kg', l.weight_kg, 'pickup_on', l.pickup_on,
    'estimate_ugx', l.estimate_ugx, 'distance_km', l.distance_km,
    'company', a.company, 'role', a.role, 'phone', a.phone,
    'whatsapp_phone', coalesce(a.whatsapp_phone, a.phone),
    'email', a.email, 'district_id', a.district_id, 'business_type', a.business_type)
  from logistics_requests l
  join accounts a on a.id = l.account_id
  where is_admin()
  order by (l.state = 'new') desc, l.created_at desc
  limit 300;
$$;

grant execute on function public.admin_logistics_requests() to authenticated;

create or replace function public.set_logistics_state(p_id uuid, p_state text)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if not is_admin() then raise exception 'Admin account required'; end if;
  update logistics_requests
     set state = case when p_state in ('new','contacted','quoted','closed') then p_state else state end,
         handled_at = now(),
         handled_by = current_account_id()
   where id = p_id;
end;
$$;

grant execute on function public.set_logistics_state(uuid, text) to authenticated;

-- ── Trade finance, as a third kind of finance enquiry ────────────────────────
alter table public.finance_enquiries add column if not exists invoice_amount bigint;
alter table public.finance_enquiries add column if not exists tenor_days integer;
alter table public.finance_enquiries add column if not exists counterparty text;

-- Both of these change shape, and Postgres will not let "create or replace" do
-- that: admin_finance_enquiries returns a different type, and
-- submit_finance_enquiry gains parameters — which would create a SECOND
-- function of the same name rather than replacing the first, leaving PostgREST
-- to choose between them. So every existing version is dropped by name.
do $$
declare r record;
begin
  for r in
    select p.oid::regprocedure as sig
      from pg_proc p
      join pg_namespace n on n.oid = p.pronamespace
     where n.nspname = 'public'
       and p.proname in ('submit_finance_enquiry', 'admin_finance_enquiries')
  loop
    execute 'drop function ' || r.sig || ' cascade';
  end loop;
end $$;

-- Replaces the two-kind version. 'trade_finance' carries an invoice amount and
-- a tenor instead of three years of turnover.
create or replace function public.submit_finance_enquiry(
  p_kind text,
  p_year integer default null,
  p_t1 bigint default null,
  p_t2 bigint default null,
  p_t3 bigint default null,
  p_limit bigint default null,
  p_invoice bigint default null,
  p_tenor integer default null,
  p_counterparty text default null)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare v_acct uuid; v_id uuid;
begin
  if p_kind not in ('credit','tax','trade_finance') then
    raise exception 'unknown enquiry kind';
  end if;
  v_acct := current_account_id();
  if v_acct is null then raise exception 'Sign in first'; end if;
  insert into finance_enquiries (account_id, kind, year_registered,
    turnover_1, turnover_2, turnover_3, indicative_limit,
    invoice_amount, tenor_days, counterparty)
  values (v_acct, p_kind, p_year, p_t1, p_t2, p_t3, p_limit,
    p_invoice, p_tenor, nullif(trim(coalesce(p_counterparty,'')),''))
  returning id into v_id;
  return v_id;
end;
$$;

grant execute on function public.submit_finance_enquiry(text,integer,bigint,bigint,bigint,bigint,bigint,integer,text)
  to authenticated;

-- The admin queue has to return the new columns too.
create or replace function public.admin_finance_enquiries()
returns setof jsonb
language sql
stable
security definer
set search_path = public
as $$
  select jsonb_build_object(
    'id', e.id, 'kind', e.kind, 'state', e.state, 'created_at', e.created_at,
    'year_registered', e.year_registered,
    'turnover_1', e.turnover_1, 'turnover_2', e.turnover_2, 'turnover_3', e.turnover_3,
    'indicative_limit', e.indicative_limit,
    'invoice_amount', e.invoice_amount, 'tenor_days', e.tenor_days,
    'counterparty', e.counterparty,
    'note', e.note,
    'company', a.company, 'role', a.role, 'phone', a.phone,
    'whatsapp_phone', coalesce(a.whatsapp_phone, a.phone),
    'email', a.email, 'district_id', a.district_id, 'business_type', a.business_type)
  from finance_enquiries e
  join accounts a on a.id = e.account_id
  where is_admin()
  order by (e.state = 'new') desc, e.created_at desc
  limit 300;
$$;

grant execute on function public.admin_finance_enquiries() to authenticated;

commit;

notify pgrst, 'reload schema';

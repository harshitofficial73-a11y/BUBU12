-- Credit and tax enquiries. Someone tapping "Yes, I am interested" was shown a
-- thank-you and nothing was stored, so the enquiry reached nobody. This records
-- it and puts it in front of admin.

create table if not exists public.finance_enquiries (
  id            uuid primary key default gen_random_uuid(),
  account_id    uuid not null references accounts(id) on delete cascade,
  kind          text not null check (kind in ('credit', 'tax')),
  -- the figures the trader typed, kept as given
  year_registered  integer,
  turnover_1       bigint,
  turnover_2       bigint,
  turnover_3       bigint,
  -- what the calculator showed them, so admin sees the same number they did
  indicative_limit bigint,
  state         text not null default 'new' check (state in ('new', 'contacted', 'closed')),
  note          text,
  created_at    timestamptz not null default now(),
  handled_at    timestamptz,
  handled_by    uuid references accounts(id)
);

create index if not exists finance_enquiries_state_idx
  on finance_enquiries(state, created_at desc);
create index if not exists finance_enquiries_account_idx
  on finance_enquiries(account_id);

alter table finance_enquiries enable row level security;

drop policy if exists finance_enquiries_own on finance_enquiries;
create policy finance_enquiries_own on finance_enquiries
  for select using (account_id in (select id from my_account_ids()) or is_admin());

drop policy if exists finance_enquiries_insert on finance_enquiries;
create policy finance_enquiries_insert on finance_enquiries
  for insert with check (account_id in (select id from my_account_ids()));

drop policy if exists finance_enquiries_admin_update on finance_enquiries;
create policy finance_enquiries_admin_update on finance_enquiries
  for update using (is_admin());

-- Record one enquiry for the signed-in business.
create or replace function public.submit_finance_enquiry(
  p_kind text,
  p_year integer default null,
  p_t1 bigint default null,
  p_t2 bigint default null,
  p_t3 bigint default null,
  p_limit bigint default null
) returns uuid language plpgsql security definer set search_path=public as $$
declare v_account uuid := current_account_id(); v_id uuid;
begin
  if v_account is null then raise exception 'sign in required'; end if;
  if p_kind not in ('credit', 'tax') then raise exception 'unknown enquiry kind'; end if;
  insert into finance_enquiries(account_id, kind, year_registered,
    turnover_1, turnover_2, turnover_3, indicative_limit)
  values (v_account, p_kind, p_year, p_t1, p_t2, p_t3, p_limit)
  returning id into v_id;
  return v_id;
end $$;
grant execute on function public.submit_finance_enquiry(text,integer,bigint,bigint,bigint,bigint) to authenticated;

-- The admin list, with the business already joined on so the console needs one
-- request rather than one per row.
create or replace function public.admin_finance_enquiries()
returns table(
  id uuid, kind text, state text, created_at timestamptz,
  year_registered integer, turnover_1 bigint, turnover_2 bigint, turnover_3 bigint,
  indicative_limit bigint, note text,
  account_id uuid, company text, trade_name text, role text,
  phone text, whatsapp_phone text, email text, district_id text,
  business_type text, tier text
) language sql stable security definer set search_path=public as $$
  select e.id, e.kind, e.state, e.created_at,
    e.year_registered, e.turnover_1, e.turnover_2, e.turnover_3,
    e.indicative_limit, e.note,
    a.id, a.company, a.trade_name, a.role::text,
    a.phone, a.whatsapp_phone, a.email, a.district_id,
    a.business_type::text, a.tier::text
  from finance_enquiries e
  join accounts a on a.id = e.account_id
  where is_admin()
  order by (e.state = 'new') desc, e.created_at desc;
$$;
grant execute on function public.admin_finance_enquiries() to authenticated;

-- Admin marks an enquiry contacted or closed.
create or replace function public.set_finance_enquiry_state(p_id uuid, p_state text)
returns void language plpgsql security definer set search_path=public as $$
begin
  if not is_admin() then raise exception 'Admin account required'; end if;
  if p_state not in ('new', 'contacted', 'closed') then raise exception 'unknown state'; end if;
  update finance_enquiries
  set state = p_state,
      handled_at = case when p_state = 'new' then null else now() end,
      handled_by = case when p_state = 'new' then null else current_account_id() end
  where id = p_id;
end $$;
grant execute on function public.set_finance_enquiry_state(uuid,text) to authenticated;

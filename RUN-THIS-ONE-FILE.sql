-- BUBU.Market — everything new since the last deployment set.
-- 24 August 2026
--
-- This is 0031 and 0032 joined into one file so there is a single thing to run.
-- Safe to run more than once: every statement is "create or replace" or
-- "if not exists". Nothing here touches 0021-0030, which you have already run.
--
-- ============================================================
-- PART 1 of 2 — credit and tax enquiries (0031)
-- ============================================================

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


-- ============================================================
-- PART 2 of 2 — public supplier profiles and listings (0032)
-- ============================================================

-- A supplier's public profile: everything a buyer needs to judge them, and no
-- contact details. The phone number stays behind reveal_supplier_contact.
--
-- The existing load_public_supplier_profile refuses anyone who is not a buyer
-- and refuses any supplier who is not yet verified, so a supplier browsing the
-- marketplace and a newly registered seller both hit an error. This one serves
-- any signed-in account and any published supplier, and says plainly whether
-- they are verified rather than hiding them.

create or replace function public.supplier_public_profile(p_supplier uuid)
returns jsonb language plpgsql security definer set search_path=public as $$
declare v_result jsonb;
begin
  if current_account_id() is null then raise exception 'sign in required'; end if;

  select jsonb_build_object(
    'id', a.id,
    'company', a.company,
    'trade_name', a.trade_name,
    'business_type', a.business_type,
    'tier', a.tier,
    'district_id', a.district_id,
    'address', a.address,
    'about', a.about,
    'coverage', a.coverage,
    'nature_of_business', a.nature_of_business,
    'brands', a.brands,
    'staff_count', a.staff_count,
    'turnover', a.turnover,
    'incorporated_on', a.incorporated_on,
    'member_since', a.created_at,
    'verification_state', coalesce(r.overall_state::text, 'unverified'),
    'ursb_verified', (r.ursb_state = 'verified'),
    'tin_verified', (r.tin_state = 'verified'),
    'licence_verified', (r.licence_state = 'verified'),
    'rating', (select round(avg(sr.rating)::numeric, 1) from supplier_reviews sr where sr.supplier_id = a.id),
    'rating_count', (select count(*) from supplier_reviews sr where sr.supplier_id = a.id),
    'categories', coalesce((select jsonb_agg(distinct c.name)
      from account_categories ac join categories c on c.id = ac.category_id
      where ac.account_id = a.id), '[]'::jsonb),
    'products', coalesce((
      select jsonb_agg(jsonb_build_object(
        'id', p.id, 'name', p.name, 'brand', p.brand, 'price', p.price,
        'unit', p.unit, 'moq', p.moq, 'description', p.description,
        'category_id', p.category_id,
        'category_name', pc.name,
        'parent_name', ppc.name,
        'view_count', p.view_count,
        'photos', coalesce((select jsonb_agg(m.storage_path order by m.created_at)
          from media m where m.product_id = p.id and m.kind = 'product' and m.approved), '[]'::jsonb),
        'videos', coalesce((select jsonb_agg(m.storage_path order by m.created_at)
          from media m where m.product_id = p.id and m.kind = 'video'), '[]'::jsonb),
        'brochure', p.document_path
      ) order by p.created_at desc)
      from products p
      left join categories pc on pc.id = p.category_id
      left join categories ppc on ppc.id = pc.parent_id
      where p.supplier_id = a.id and p.status = 'published'), '[]'::jsonb),
    'reviews', coalesce((select jsonb_agg(jsonb_build_object(
        'rating', sr.rating, 'body', sr.body, 'created_at', sr.created_at,
        'buyer', ba.company) order by sr.created_at desc)
      from supplier_reviews sr join accounts ba on ba.id = sr.buyer_id
      where sr.supplier_id = a.id), '[]'::jsonb)
  ) into v_result
  from accounts a
  left join account_registration r on r.account_id = a.id
  where a.id = p_supplier and a.role = 'supplier';

  if v_result is null then raise exception 'Supplier not found'; end if;
  return v_result;
end $$;
grant execute on function public.supplier_public_profile(uuid) to authenticated;

-- Every published listing of one product name, across suppliers, with the seller
-- named but never their number. Buyers compare offers before asking anyone.
create or replace function public.listings_for_product(p_name text)
returns table(
  id uuid, name text, brand text, price bigint, unit text, moq integer,
  description text, view_count integer,
  category_id text, category_name text, parent_name text,
  supplier_id uuid, supplier text, trade_name text, business_type text,
  tier text, district_id text, verification_state text,
  rating numeric, rating_count bigint,
  photos jsonb, videos jsonb, brochure text
) language sql stable security definer set search_path=public as $$
  select p.id, p.name, p.brand, p.price, p.unit, p.moq,
    p.description, p.view_count,
    p.category_id, c.name, pc.name,
    a.id, a.company, a.trade_name, a.business_type::text,
    a.tier::text, a.district_id, coalesce(r.overall_state::text, 'unverified'),
    (select round(avg(sr.rating)::numeric, 1) from supplier_reviews sr where sr.supplier_id = a.id),
    (select count(*) from supplier_reviews sr where sr.supplier_id = a.id),
    coalesce((select jsonb_agg(m.storage_path order by m.created_at)
      from media m where m.product_id = p.id and m.kind = 'product' and m.approved), '[]'::jsonb),
    coalesce((select jsonb_agg(m.storage_path order by m.created_at)
      from media m where m.product_id = p.id and m.kind = 'video'), '[]'::jsonb),
    p.document_path
  from products p
  join accounts a on a.id = p.supplier_id
  left join account_registration r on r.account_id = a.id
  left join categories c on c.id = p.category_id
  left join categories pc on pc.id = c.parent_id
  where p.status = 'published'
    and lower(trim(p.name)) = lower(trim(p_name))
  order by p.price nulls last;
$$;
grant execute on function public.listings_for_product(text) to authenticated, anon;


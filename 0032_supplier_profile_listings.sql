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

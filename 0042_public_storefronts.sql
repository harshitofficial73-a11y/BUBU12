-- Supplier storefronts were invisible unless the supplier was verified.
--
-- load_public_supplier_profile ended with:
--
--   where a.id = p_supplier and a.role = 'supplier'
--     and r.overall_state = 'verified';
--
-- and raised an exception when that found nothing. Every imported supplier is
-- 'pending', so all 65 storefronts failed, the app fell back to placeholders,
-- and a buyer saw "Supplier", no description, no products — plus a hardcoded
-- URSB badge, which made it look verified as well as empty.
--
-- It was inconsistent as well as broken: those suppliers' 485 products are
-- searchable, and tapping any of them led to a dead storefront. Verification
-- is a badge, not a gate on being seen.
--
-- Three changes:
--   1. Any supplier can be viewed. The real verification state is returned so
--      the badge tells the truth instead of always claiming URSB.
--   2. LEFT JOIN on account_registration, so a supplier who has submitted
--      nothing still has a storefront rather than vanishing.
--   3. Any signed-in account may look, not only buyers. A supplier comparing
--      a competitor's storefront no longer gets an error.

create or replace function public.load_public_supplier_profile(p_supplier uuid)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_me     uuid;
  v_result jsonb;
begin
  -- Whoever is asking. Used only to scope their own quotes and conversations;
  -- viewing does not require being a buyer.
  select id into v_me from accounts where auth_user_id = auth.uid();

  select jsonb_build_object(
    'id', a.id,
    'company', a.company,
    'trade_name', a.trade_name,
    'initials', coalesce(a.initials,
      upper(left(regexp_replace(coalesce(a.company, 'S'), '[^A-Za-z]', '', 'g'), 2))),
    'tier', a.tier,
    'business_type', a.business_type,
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
    'rating', a.rating,
    'rating_count', a.rating_count,
    'verification_state', coalesce(r.overall_state::text, 'unverified'),
    'ursb_verified', coalesce(r.ursb_state::text, '') = 'verified',
    'tin_verified', coalesce(r.tin_state::text, '') = 'verified',
    'licence_verified', coalesce(r.licence_state::text, '') = 'verified',
    'credentials', jsonb_build_object(
      'ursb_state', coalesce(r.ursb_state::text, 'unverified'),
      'tin_state', coalesce(r.tin_state::text, 'unverified'),
      'licence_state', coalesce(r.licence_state::text, 'unverified')),
    'categories', coalesce((
      select jsonb_agg(c.name order by c.name)
        from account_categories ac
        join categories c on c.id = ac.category_id
       where ac.account_id = a.id), '[]'::jsonb),
    'banner', (select md.storage_path from media md
                where md.account_id = a.id and md.product_id is null
                  and md.kind = 'company'
                order by md.created_at desc limit 1),
    'products', coalesce((
      select jsonb_agg(jsonb_build_object(
               'id', p.id, 'name', p.name, 'price', p.price, 'unit', p.unit,
               'moq', p.moq, 'brand', p.brand, 'description', p.description,
               'category_id', p.category_id,
               'category_name', (select c2.name from categories c2 where c2.id = p.category_id),
               'view_count', p.view_count,
               'photos', coalesce((select jsonb_agg(m2.storage_path order by m2.created_at)
                                     from media m2
                                    where m2.product_id = p.id and m2.kind = 'product'
                                      and m2.approved), '[]'::jsonb),
               'videos', coalesce((select jsonb_agg(m3.storage_path order by m3.created_at)
                                     from media m3
                                    where m3.product_id = p.id and m3.kind = 'video'), '[]'::jsonb),
               'brochure', (select m4.storage_path from media m4
                             where m4.product_id = p.id and m4.kind = 'product_pdf'
                             order by m4.created_at desc limit 1)
             ) order by p.created_at desc)
        from products p
       where p.supplier_id = a.id and p.status = 'published'), '[]'::jsonb),
    'reviews', coalesce((
      select jsonb_agg(jsonb_build_object('rating', sr.rating, 'body', sr.body,
               'created_at', sr.created_at, 'buyer', ba.company) order by sr.created_at desc)
        from supplier_reviews sr
        join accounts ba on ba.id = sr.buyer_id
       where sr.supplier_id = a.id), '[]'::jsonb),
    'past_quotes', coalesce((
      select jsonb_agg(jsonb_build_object('id', q.id, 'state', q.state,
               'unit_price', q.unit_price, 'lead_time', q.lead_time, 'message', q.message,
               'created_at', q.created_at, 'requirement', rq.title) order by q.created_at desc)
        from quotes q
        join requirements rq on rq.id = q.requirement_id
       where q.supplier_id = a.id and rq.buyer_id = v_me), '[]'::jsonb),
    'conversations', coalesce((
      select jsonb_agg(jsonb_build_object('id', c.id, 'requirement_id', c.requirement_id,
               'last_message_at', c.last_message_at) order by c.created_at desc)
        from conversations c
       where c.supplier_id = a.id and c.buyer_id = v_me), '[]'::jsonb)
  )
    into v_result
    from accounts a
    left join account_registration r on r.account_id = a.id
   where a.id = p_supplier
     and a.role = 'supplier';

  if v_result is null then
    raise exception 'Supplier not found';
  end if;
  return v_result;
end;
$$;

grant execute on function public.load_public_supplier_profile(uuid) to authenticated;

notify pgrst, 'reload schema';

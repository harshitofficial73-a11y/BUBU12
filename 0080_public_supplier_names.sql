-- 0080 · Supplier names on public listings
-- Listings are public, but a guest (or a buyer with no chat yet) may not read an
-- unverified supplier's account, so the app showed "Supplier" instead of the
-- company. This returns ONLY the public trading name, district and business
-- type, and only for suppliers who have at least one live listing. Phone,
-- email and documents stay private.

create or replace function public_supplier_names(p_ids uuid[])
returns table (id uuid, company text, district_id text, business_type text)
language sql stable security definer set search_path = public as $$
  select a.id, coalesce(nullif(a.company, ''), a.trade_name)::text,
         a.district_id::text, a.business_type::text
  from accounts a
  where a.id = any(p_ids)
    and a.role = 'supplier'
    and exists (select 1 from products p where p.supplier_id = a.id and p.status = 'published')
  limit 500;
$$;

grant execute on function public_supplier_names(uuid[]) to anon, authenticated;

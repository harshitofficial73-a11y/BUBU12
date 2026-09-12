-- An admin-only export of every published product with its supplier's contact.
--
-- The page could not show phone numbers because nothing safe returned them:
-- row-level security hides other accounts from an ordinary login, and
-- supplier_public_profile deliberately omits the phone — that omission is what
-- makes lead credits worth paying for, so it should stay.
--
-- But an ADMIN already sees every number in the member console. Withholding
-- them from an admin's own export is not protecting anything; it just means
-- the work gets done in the SQL editor instead.
--
-- So: one function, is_admin() gated. A supplier or buyer calling it gets
-- nothing back, which is the same answer they get everywhere else.
--
-- Safe to re-run.

begin;

do $$
declare r record;
begin
  for r in
    select p.oid::regprocedure as sig
      from pg_proc p
      join pg_namespace n on n.oid = p.pronamespace
     where n.nspname = 'public' and p.proname = 'admin_product_export'
  loop
    execute 'drop function ' || r.sig;
  end loop;
end $$;

create or replace function public.admin_product_export()
returns setof jsonb
language sql
stable
security definer
set search_path = public
as $$
  select jsonb_build_object(
    'supplier', a.company,
    'trade_name', a.trade_name,
    'phone', a.phone,
    'alt_phone', a.alt_phone,
    'whatsapp', coalesce(a.whatsapp_phone, a.phone),
    'email', a.email,
    'district', a.district_id,
    'business_type', a.business_type,
    'tier', a.tier,
    'verification', reg.overall_state,
    'product', p.name,
    'category', c.name,
    'parent_category', pc.name,
    'price', p.price,
    'unit', p.unit,
    'moq', p.moq,
    'brand', p.brand,
    'origin', p.import_source,
    'photos', (select count(*) from media m
                where m.product_id = p.id and m.kind = 'product'),
    'videos', (select count(*) from media m
                where m.product_id = p.id and m.kind = 'video'),
    'listed_on', p.created_at
  )
  from products p
  join accounts a on a.id = p.supplier_id
  left join categories c on c.id = p.category_id
  left join categories pc on pc.id = c.parent_id
  left join account_registration reg on reg.account_id = a.id
  where is_admin()
    and p.status = 'published'
  order by a.company, p.name;
$$;

grant execute on function public.admin_product_export() to authenticated;

commit;

notify pgrst, 'reload schema';

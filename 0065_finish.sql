-- 0065 finish · run after every part. Safe to re-run.
--
-- Why the tiles were empty: when a product's subcategory did not exist at the
-- moment it was inserted, the import left its category blank. Those trades had
-- products, but none were filed under them.

begin;

insert into categories (id, name, parent_id, sort)
select distinct x.s, initcap(replace(split_part(x.s, '--', 2), '-', ' ')), x.m, 300
  from public.import_catmap x
 where x.s is not null
   and exists (select 1 from categories c where c.id = x.m)
on conflict (id) do nothing;

update products p
   set category_id = coalesce(
         (select c.id from categories c where c.id = x.s),
         (select c.id from categories c where c.id = x.m))
  from public.import_catmap x
 where p.name = x.n
   and p.import_source = 'uganda-b2b'
   and p.category_id is null;

update categories c set image_url = x.path
  from (select distinct on (p.category_id) p.category_id as cat, m.storage_path as path
          from products p join media m on m.product_id = p.id and m.kind = 'product'
         order by p.category_id, m.created_at) x
 where c.id = x.cat and coalesce(c.image_url, '') = '';

update categories c set image_url = x.path
  from (select distinct on (k.parent_id) k.parent_id as cat, m.storage_path as path
          from categories k
          join products p on p.category_id = k.id
          join media m on m.product_id = p.id and m.kind = 'product'
         where k.parent_id is not null
         order by k.parent_id, m.created_at) x
 where c.id = x.cat and coalesce(c.image_url, '') = '';

drop table public.import_catmap;

commit;

notify pgrst, 'reload schema';

select c.name,
       (select count(*) from products p join categories k on k.id = p.category_id
         where k.id = c.id or k.parent_id = c.id) as products,
       case when coalesce(c.image_url,'') = '' then 'NO IMAGE' else 'ok' end as image
  from categories c where c.parent_id is null order by 2;

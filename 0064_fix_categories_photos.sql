-- 0064 · Categories back to the 36, category images, photo visibility
-- Safe to re-run.

begin;

-- 1 · Any top-level category that is not one of the 36 becomes a subcategory.
--     If a subcategory with the same name already exists, its products move
--     there and the duplicate is removed. Otherwise it is placed under the main
--     category its suppliers mostly trade in.

do $$
declare c record; v_twin text; v_parent text;
  keep text[] := array['agriculture-produce','agro-inputs-seeds','food-beverage','livestock-feeds','building-construction','cement-aggregates','steel-metal','hardware-tools','roofing-ceilings','electrical-lighting','electronics','solar-power','plumbing-sanitary','paints-finishes','chemicals-industrial','auto-parts','automotive-vehicles-and-commercial-equipment','machinery-and-industrial-equipment','construction-machinery-and-equipment','agriculture-machinery-and-equipment','furniture-fittings','textiles-apparel','cleaning-hygiene','medical-supplies','stationery-printing','packaging','safety-ppe','water-treatment-and-waste-management','office-and-business-supplies','ict-and-telecom-equipment','hospitality-and-catering-supplies','security-and-surveillance','laboratory-and-scientific-equipment','furniture-and-interior-products','packaging-machinery','other-industrial-supplies'];
begin
  for c in select id, name from categories
            where parent_id is null and not (id = any(keep))
  loop
    select s.id into v_twin from categories s
     where s.parent_id is not null and s.id != c.id
       and lower(trim(s.name)) = lower(trim(c.name)) limit 1;

    if v_twin is not null then
      update products set category_id = v_twin where category_id = c.id;
      update categories set parent_id = (select parent_id from categories where id = v_twin)
       where parent_id = c.id;
      delete from account_categories where category_id = c.id;
      delete from categories where id = c.id;
    else
      select coalesce(k.parent_id, k.id) into v_parent
        from products p
        join products o on o.supplier_id = p.supplier_id and o.category_id != c.id
        join categories k on k.id = o.category_id
       where p.category_id = c.id
         and coalesce(k.parent_id, k.id) = any(keep)
       group by 1 order by count(*) desc limit 1;
      update categories set parent_id = coalesce(v_parent, 'other-industrial-supplies')
       where id = c.id;
      -- its own children move up to the chosen main
      update categories set parent_id = coalesce(v_parent, 'other-industrial-supplies')
       where parent_id = c.id;
    end if;
  end loop;
end $$;

-- 2 · Photos: make sure every catalogue photo is approved and marked as a
--     product photo, which is what the app reads.
update media set approved = true, kind = 'product'
 where storage_path like 'catalogue/%' and (approved is not true or kind != 'product');

-- 3 · Category images: any category without one takes a photo from one of its
--     own products.
update categories c set image_url = x.storage_path
  from (
    select distinct on (coalesce(k.parent_id, k.id), k.id) k.id as cat, m.storage_path
      from categories k
      join products p on p.category_id = k.id
      join media m on m.product_id = p.id and m.kind = 'product'
     order by coalesce(k.parent_id, k.id), k.id, m.created_at
  ) x
 where c.id = x.cat and (c.image_url is null or c.image_url = '');

update categories c set image_url = x.storage_path
  from (
    select distinct on (k.parent_id) k.parent_id as cat, m.storage_path
      from categories k
      join products p on p.category_id = k.id
      join media m on m.product_id = p.id and m.kind = 'product'
     where k.parent_id is not null
     order by k.parent_id, m.created_at
  ) x
 where c.id = x.cat and (c.image_url is null or c.image_url = '');

commit;

notify pgrst, 'reload schema';

-- Check — send me this result
select
  (select count(*) from categories where parent_id is null)               as main_categories,
  (select count(*) from categories where parent_id is not null)           as subcategories,
  (select count(*) from media where storage_path like 'catalogue/%')      as catalogue_photos,
  (select public from storage.buckets where id = 'media')                 as media_bucket_public,
  (select storage_path from media where storage_path like 'catalogue/%' limit 1) as sample_path;

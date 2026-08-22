-- Category artwork.
--
-- The `media` bucket is private: every read needs a signed URL, and an
-- anonymous visitor browsing the marketplace cannot mint one. Category images
-- are public by nature, so they get their own public bucket. Writing stays
-- admin-only.

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('public-media', 'public-media', true, 10485760,
  array['image/jpeg','image/png','image/webp','image/avif'])
on conflict (id) do update set
  public = true,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists public_media_read on storage.objects;
create policy public_media_read on storage.objects for select
  using (bucket_id = 'public-media');

drop policy if exists public_media_admin_insert on storage.objects;
create policy public_media_admin_insert on storage.objects for insert to authenticated
  with check (bucket_id = 'public-media' and is_admin());

drop policy if exists public_media_admin_update on storage.objects;
create policy public_media_admin_update on storage.objects for update to authenticated
  using (bucket_id = 'public-media' and is_admin())
  with check (bucket_id = 'public-media');

drop policy if exists public_media_admin_delete on storage.objects;
create policy public_media_admin_delete on storage.objects for delete to authenticated
  using (bucket_id = 'public-media' and is_admin());

-- Admins maintain the taxonomy, including its artwork.
drop policy if exists categories_admin_write on categories;
create policy categories_admin_write on categories for all to authenticated
  using (is_admin()) with check (is_admin());

-- Migration 0010 seeded image_url with paths to files that were never shipped,
-- which is why the directory rendered empty frames. Point the ones we do have
-- at real files and clear the rest so they fall back to a clean placeholder.
update categories set image_url = case id
  when 'building-construction' then 'assets/categories/building-construction.png'
  when 'cement-aggregates'     then 'assets/categories/cement-binders.png'
  when 'medical-supplies'      then 'assets/categories/medical-supplies.png'
  when 'steel-metal'           then 'assets/categories/steel-metal.png'
  when 'roofing-ceilings'      then 'assets/categories/roofing.png'
  else null
end
where image_url is null or image_url like 'assets/categories/%';

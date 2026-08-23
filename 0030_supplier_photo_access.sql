-- Suppliers own their listing photos; admins own category artwork.
--
-- Two things stopped a supplier adding a product photo from a phone.
--
-- 1. Phone cameras. iPhones save photos as HEIC and newer Androids as AVIF,
--    neither of which the media bucket accepted, so the upload was refused
--    before any policy was consulted.
--
-- 2. Visibility. media_read hides a row unless it is approved, owned by the
--    caller, or the caller is an admin. Nothing in the platform ever approves
--    media, so a photo was visible to the supplier who uploaded it and to
--    nobody else — it looked like the upload had silently failed.
--
-- Category artwork is unchanged and stays admin-only: it lives in the separate
-- public-media bucket whose insert policy already requires is_admin().

update storage.buckets
set file_size_limit = 52428800,
    allowed_mime_types = array[
      'image/jpeg','image/png','image/webp','image/gif',
      'image/heic','image/heif','image/avif',
      'application/pdf'
    ]
where id = 'media';

-- A photo attached to a published listing is public, the same as the listing.
-- Everything else stays private to its owner and to admins.
drop policy if exists media_read on media;
create policy media_read on media for select using (
  account_id = current_account_id()
  or is_admin()
  or (
    kind in ('product', 'product_pdf', 'company')
    and (
      product_id is null
      or exists (select 1 from products p
                 where p.id = product_id and p.status = 'published')
    )
  )
);

-- Only the supplier who owns the listing may attach media to it.
drop policy if exists media_write on media;
create policy media_write on media for all
  using (account_id = current_account_id() or is_admin())
  with check (
    (account_id = current_account_id() or is_admin())
    and (
      product_id is null
      or exists (select 1 from products p
                 where p.id = product_id
                   and (p.supplier_id = current_account_id() or is_admin()))
    )
  );

-- Photos already uploaded from a phone are sitting unapproved and invisible.
update media set approved = true
where kind in ('product', 'product_pdf', 'company') and approved is not true;

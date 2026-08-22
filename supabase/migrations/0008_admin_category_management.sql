-- Allow authenticated BUBU administrators to manage the catalogue taxonomy.
-- Public and supplier accounts remain read-only.

drop policy if exists categories_admin_write on categories;
create policy categories_admin_write on categories
for all to authenticated
using (is_admin())
with check (is_admin());

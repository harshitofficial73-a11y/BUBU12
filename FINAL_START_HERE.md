# BUBU.Market — clean installation

1. Create a new Supabase project.
2. If reusing an old BUBU project, empty/delete the `media` bucket in Storage, then run `FINAL_RESET.sql` once. It is destructive. For a brand-new Supabase project, skip the reset.
3. Run `database/FINAL_REBUILD.sql` once in the Supabase SQL Editor.
4. Then run these upgrade files in order: `0017_buyer_profile_retry.sql`, `0018_product_interests.sql`, `0019_quote_chat_supplier_profile.sql`, and `0020_admin_directory_media.sql` from `supabase/migrations/`.
5. In Authentication, enable Email/password and disable Confirm email for this development build. Save the provider settings.
6. Confirm the public Storage bucket named `media` exists.
7. Enter the new project URL and publishable/anon key in `supabase-config.js`.
8. In Authentication -> Users, create `nidhi@bubumarket.com` with password `Bubu@2027` and Auto-confirm enabled. Then run `database/CREATE_NIDHI_ADMIN.sql`.
9. Upload the contents of this package to Netlify/GitHub. `index.html` must remain at repository root.

Default development password policy used by this build: `Bubu@2026`. The Nidhi test admin used `Bubu@2027`; change all production passwords before launch.

Supplier registration requires a district selected from the provided Uganda district list. The UI validates it before creating the Auth account.

The universal development OTP is `079757`. Disable it before production and connect a real SMS/email provider.

## Database order

`FINAL_REBUILD.sql` contains the base schema through migration 0016. Migrations 0017–0020 must be run afterwards in numeric order.

## Profiles

- Buyer: immediate registration/login, marketplace, requirements, Quotes Manager, supplier chats and decisions.
- Supplier: approval, profile/storefront, catalog, media/documents, matched leads, lead credits, quotes and chats.
- Admin: supplier verification, categories/subcategories, plans and members.

Marketplace goods are paid directly between Buyer and Supplier. BUBU payment records are used for plans and paid lead access only.

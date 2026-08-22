# BUBU.Market

Database-backed B2B marketplace for buyers, suppliers, and platform administrators.

## Start here

Read `FINAL_START_HERE.md`, then follow `INSTALLATION_ORDER.txt` exactly. The frontend entry point is the root `index.html`. Netlify publishes the repository root with no build command.

## Included workflows

- Buyer registration without business verification; universal development OTP `079757`; product search; requirements; Products of Interest; Quotes Manager; supplier profiles; notifications and chat.
- Supplier registration and admin approval; company profile and storefront; searchable category/subcategory catalog; product status; image, video, PDF and document uploads; matched leads; lead credits; quotes and chat.
- Admin supplier verification with submitted records and document downloads; tenders; categories/subcategories; plans; member directory; product and category/supplier analytics.
- Star plan: 20 lead credits/month. Industry Leader: 50 lead credits/month. Free-plan paid lead price: UGX 18,000. A purchased lead reveals the buyer contact and opens a conversation.
- Payments are limited to plans and paid lead access. Goods transactions, orders, invoices and escrow are not live workflows.

## Security

`supabase-config.js` in this distributable contains placeholders. Add only the Supabase project URL and publishable/anon key. Never put the service-role key in browser code. Replace all development passwords and the universal OTP before production.

## Production dependencies

Supabase provides PostgreSQL, Auth and Storage. A real OTP service is intentionally not connected; the development code is `079757`. WhatsApp integration is intentionally excluded.

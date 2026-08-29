-- BUBU.Market · Africa2Trust import, part 6 of 6
-- 19 suppliers. Run the parts in order; each one is safe to re-run.
-- READ-ME-FIRST.txt explains the prices and the photographs.
--
--   Abacus Parenteral Drugs Limited (APDL)
--   Kampala Pharmaceutical Industries
--   Euroflex Ltd
--   NICE House of Plastics
--   Sillah Limited
--   MUSA BODY MACHINERY LTD
--   Briande Investments
--   Fine Spinners Uganda Limited
--   TWIGA CHEMICAL INDUSTRIES
--   Shumuk Aluminium Industries Ltd. S.A.I.L
--   Crane Paper Bags Ltd
--   Picfare Industries Ltd
--   Berger Paints (U) Limited
--   African Polysack Industries Ltd
--   Quality Plastics (U) Limited
--   BETINA FASHION WEAR
--   XTREME Bridals
--   Aquva International Ltd
--   IDROID Technologies Limited

begin;

create extension if not exists pgcrypto;
alter table accounts add column if not exists import_source text;
alter table products add column if not exists import_source text;

-- Abacus Parenteral Drugs Limited (APDL) · +256417100700 · 2 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'abacus-parenteral-drugs-limited-apdl@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'abacus-parenteral-drugs-limited-apdl@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256417100700' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'manufacturer', 'free', 'Abacus Parenteral Drugs Limited (APDL)', 'Abacus Parenteral Drugs Limited (APDL)',
      'AP', '+256417100700', null, '+256417100700', 'abacus-parenteral-drugs-limited-apdl@suppliers.bubu.market',
      'Kampala, Uganda, Plot 114, Block 191, Kinga-Mukono, Central, Mukono', 'kampala', 'medical supplies', 'Abacus Parenteral Drugs Limited (APDL) supplies medical supplies from Kampala. 2 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Abacus Parenteral Drugs Limited (APDL) supplies medical supplies from Kampala. 2 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'medical-supplies') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Prod-_14746_69915550.jpg', 'Abacus Parenteral Drugs Limited (APDL) — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Chloramphenicol Eye (purple)';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Chloramphenicol Eye (purple)', 'medical-supplies', 'Abchlor: (Eye drop) Product Name: Chloramphenicol Eye (purple) Dosage Type: Eye drops Category: SVP Package Volume: 10 ml Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 22000, 'box', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14746_69915550.jpg', 'Chloramphenicol Eye (purple)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14746_699151535.jpg', 'Chloramphenicol Eye (purple)', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Glucose Intravenous Infusion B.P';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Glucose Intravenous Infusion B.P', 'medical-supplies', 'D5 Product Name: Glucose Intravenous Infusion B.P Dosage Type: IV Fluid Category: LVP Package Volume: 500/250 ml Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 12000, 'box', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14746_699151535.jpg', 'Glucose Intravenous Infusion B.P', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14746_69915550.jpg', 'Glucose Intravenous Infusion B.P', true);
  end if;
end $$;

-- Kampala Pharmaceutical Industries · +256752285645+256414285645 · 4 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'kampala-pharmaceutical-industries@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'kampala-pharmaceutical-industries@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256752285645+256414285645' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'manufacturer', 'free', 'Kampala Pharmaceutical Industries', 'Kampala Pharmaceutical Industries',
      'KP', '+256752285645+256414285645', null, '+256752285645+256414285645', 'kampala-pharmaceutical-industries@suppliers.bubu.market',
      'M444B, Stretcher Road, Ntinda, Central, Kampala', 'kampala', 'medical supplies', 'Kampala Pharmaceutical Industries supplies medical supplies from Kampala. 4 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Kampala Pharmaceutical Industries supplies medical supplies from Kampala. 4 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'medical-supplies') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Prod-_14737_68719321.jpg', 'Kampala Pharmaceutical Industries — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Amoxikid250';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Amoxikid250', 'medical-supplies', 'Amoxicillin Tablets For Oral Suspension USP 250mg Product: Amoxikid250 Form: Tablets Pack: 10 x 10 Strip Packs, 1 x 10, 2 x 10 Strip Packs Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 12000, 'box', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14737_68719321.jpg', 'Amoxikid250', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14737_687184043.jpg', 'Amoxikid250', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14737_68718174.jpg', 'Amoxikid250', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'AZUCLOX';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'AZUCLOX', 'medical-supplies', 'Ampicillin BP 125mg /Cloxacillin BP 125mg per 5ml Product: Azuclox PFOS Form: PFOS Pack: 100ml Bottle Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 22000, 'box', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14737_687184043.jpg', 'AZUCLOX', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14737_68719321.jpg', 'AZUCLOX', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14737_68718174.jpg', 'AZUCLOX', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'FLUCAP SYRUP';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'FLUCAP SYRUP', 'medical-supplies', 'Chlorpheniramine Maleate BP 1.25mg / Pseudoephedrine HCl BP 10mg / Paracetamol BP 120mg Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 12000, 'box', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14737_68718174.jpg', 'FLUCAP SYRUP', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14737_68719321.jpg', 'FLUCAP SYRUP', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14737_687184043.jpg', 'FLUCAP SYRUP', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'KAM CLOXA';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'KAM CLOXA', 'medical-supplies', 'Cloxacillin BP 125mg per 5ml on reconstitution Product: Kam Cloxa PFOS Form: PFOS Pack: 100ml Bottle Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 22000, 'box', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14737_68719952.jpg', 'KAM CLOXA', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14737_68719321.jpg', 'KAM CLOXA', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14737_687184043.jpg', 'KAM CLOXA', true);
  end if;
end $$;

-- Euroflex Ltd · +25675728610340800386000+256414286103285139 · 1 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'euroflex-ltd@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'euroflex-ltd@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+25675728610340800386000+256414286103285139' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'manufacturer', 'free', 'Euroflex Ltd', 'Euroflex Ltd',
      'EL', '+25675728610340800386000+256414286103285139', null, '+25675728610340800386000+256414286103285139', 'euroflex-ltd@suppliers.bubu.market',
      'Uganda, Plot No 1184, Kinawataka Road , Kireka, Kampala, Kyambogo, Kampala', 'kampala', 'textiles and apparel', 'Euroflex Ltd supplies textiles and apparel from Kampala. 1 line is listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Euroflex Ltd supplies textiles and apparel from Kampala. 1 line is listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'textiles-apparel') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Prod-_940_700124736.jpg', 'Euroflex Ltd — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Luxury Mattresses';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Luxury Mattresses', 'textiles-apparel', 'Luxury Mattresses giving you Plush Comfort and made of Pocketor Bonnel Springs and Premium Plush Fabric and you great value for Money Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 85000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_940_700124736.jpg', 'Luxury Mattresses', true);
  end if;
end $$;

-- NICE House of Plastics · +256752263111+256312263110 · 1 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'nice-house-of-plastics@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'nice-house-of-plastics@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256752263111+256312263110' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'manufacturer', 'free', 'NICE House of Plastics', 'NICE House of Plastics',
      'NH', '+256752263111+256312263110', null, '+256752263111+256312263110', 'nice-house-of-plastics@suppliers.bubu.market',
      'Kampala Uganda, Plot 75 Mulwana Rd, Kampala, Bugolobi, Kampala', 'kampala', 'furniture and fittings', 'NICE House of Plastics supplies furniture and fittings from Kampala. 1 line is listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'NICE House of Plastics supplies furniture and fittings from Kampala. 1 line is listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'furniture-fittings') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Prod-_606_691185925.png', 'NICE House of Plastics — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Crown Chair';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Crown Chair', 'furniture-fittings', 'All our chairs are available in a range of different colours and unique styles to help you complete in any type of look you’re going for. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 18000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_606_691185925.png', 'Crown Chair', true);
  end if;
end $$;

-- Sillah Limited · +256704096273+256751047217 · 12 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'sillah-limited@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'sillah-limited@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256704096273+256751047217' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'trader', 'free', 'Sillah Limited', 'Sillah Limited',
      'SL', '+256704096273+256751047217', null, '+256704096273+256751047217', 'sillah-limited@suppliers.bubu.market',
      'KAMPALA, UGANDA, PLOT 288,BLOCK 5 MULAGO, KAFEERO ZONE ROAD, Central, Kampala', 'kampala', 'furniture and fittings', 'Sillah Limited supplies furniture and fittings from Kampala. 12 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Sillah Limited supplies furniture and fittings from Kampala. 12 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'furniture-fittings') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Prod-_26951_754141143.jpg', 'Sillah Limited — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Camping Tents';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Camping Tents', 'furniture-fittings', 'This type of tent is ideal for: Business Garden Restaurants These tents come in sizes: 2x2m 3x3m 4x4m And More Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 320000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_26951_754141143.jpg', 'Camping Tents', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_26951_754175815.jpg', 'Camping Tents', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_26951_75417276.jpg', 'Camping Tents', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Function Ordinary Tents';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Function Ordinary Tents', 'furniture-fittings', 'This type of tent is ideal for: Busines Garden Restaurants Note: We can make the above tent with either: - 1 Back flap cover wall - 2 Flaps / covers / walls - 3 Flaps / covers/ walls - 4 Flaps / cover / walls Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 320000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_26951_754162032.jpg', 'Function Ordinary Tents', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_26951_754141143.jpg', 'Function Ordinary Tents', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_26951_754175815.jpg', 'Function Ordinary Tents', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Peaked Mongolian Tents';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Peaked Mongolian Tents', 'furniture-fittings', 'This type of tent is ideal for: Business Garden Restaurants Note: We can make the above tent with either: - 1 Back flap cover wall - 2 Flaps / covers / walls - 3 Flaps / covers/ walls - 4 Flaps / cover / walls Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 320000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_26951_7541604.jpg', 'Peaked Mongolian Tents', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_26951_754141143.jpg', 'Peaked Mongolian Tents', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_26951_754175815.jpg', 'Peaked Mongolian Tents', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Straight Mongolian Tents';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Straight Mongolian Tents', 'furniture-fittings', 'This type of tent is ideal for: Business Garden Restaurants Note: We can make the above tent with either: - 1 Back flap cover wall - 2 Flaps / covers / walls - 3 Flaps / covers/ walls - 4 Flaps / cover / wall Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 320000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_26951_75418545.jpg', 'Straight Mongolian Tents', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_26951_754141143.jpg', 'Straight Mongolian Tents', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_26951_754175815.jpg', 'Straight Mongolian Tents', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Ware Houses';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Ware Houses', 'furniture-fittings', 'These tents come in sizes: 2x2m 3x3m 4x4m And Above Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 320000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_26951_754163017.jpg', 'Ware Houses', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_26951_754141143.jpg', 'Ware Houses', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_26951_754175815.jpg', 'Ware Houses', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Home Décor - Car Covers';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Home Décor - Car Covers', 'furniture-fittings', 'Note: We can make the above tent with either: - 1 Back flap cover wall. - 2 Flaps / covers / walls. - 3 Flaps / covers/ walls. - 4 Flaps / cover / walls. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 320000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_26951_754175815.jpg', 'Home Décor - Car Covers', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_26951_754141143.jpg', 'Home Décor - Car Covers', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_26951_75417276.jpg', 'Home Décor - Car Covers', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Home Décor - Car Ports and Shades';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Home Décor - Car Ports and Shades', 'furniture-fittings', 'Note: We can make the above tent with either: - 1 Back flap cover wall. - 2 Flaps / covers / walls. - 3 Flaps / covers/ walls. - 4 Flaps / cover / walls. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 320000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_26951_754165741.jpg', 'Home Décor - Car Ports and Shades', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_26951_754141143.jpg', 'Home Décor - Car Ports and Shades', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_26951_754175815.jpg', 'Home Décor - Car Ports and Shades', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Home Décor - Inside Pole Umbrellas';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Home Décor - Inside Pole Umbrellas', 'furniture-fittings', 'This type of Umbrella is ideal for: Meetings. Gardens. Restaurants. Note: We can make the above in various colours: Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 320000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_26951_754164341.jpg', 'Home Décor - Inside Pole Umbrellas', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_26951_754141143.jpg', 'Home Décor - Inside Pole Umbrellas', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_26951_754175815.jpg', 'Home Décor - Inside Pole Umbrellas', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Home Décor - Outside Pole Umbrellas';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Home Décor - Outside Pole Umbrellas', 'furniture-fittings', 'These type of Umbrella is ideal for: Meetings. Gardens. Restaurants. Note: We can make the above tent with either: - 1 Back flap cover wall. - 2 Flaps / covers / walls. - 3 Flaps / covers/ walls. - 4 Flaps / cover / walls. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 320000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_26951_754171528.jpg', 'Home Décor - Outside Pole Umbrellas', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_26951_754141143.jpg', 'Home Décor - Outside Pole Umbrellas', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_26951_754175815.jpg', 'Home Décor - Outside Pole Umbrellas', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Crown Tents for Churches';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Crown Tents for Churches', 'furniture-fittings', 'These tents come in terms of seating capacity of : 100 200 300 500 1000 And Above Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 320000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_26951_75417491.jpg', 'Crown Tents for Churches', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_26951_754141143.jpg', 'Crown Tents for Churches', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_26951_754175815.jpg', 'Crown Tents for Churches', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Refugee Tents';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Refugee Tents', 'furniture-fittings', 'These tents come in sizes: 2x2m 3x3m 4x4m And Above Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 320000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_26951_754173337.jpg', 'Refugee Tents', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_26951_754141143.jpg', 'Refugee Tents', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_26951_754175815.jpg', 'Refugee Tents', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Seasonal Décor - Car Dress';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Seasonal Décor - Car Dress', 'furniture-fittings', 'Dont let you car get dusty while in parking. Dress it up to protet it from: - Dust. - The sun. - Rain. Note: We can make the above in various colours. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 85000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_26951_75417276.jpg', 'Seasonal Décor - Car Dress', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_26951_754141143.jpg', 'Seasonal Décor - Car Dress', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_26951_754175815.jpg', 'Seasonal Décor - Car Dress', true);
  end if;
end $$;

-- MUSA BODY MACHINERY LTD · +256707888109+256707888101 · 5 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'musa-body-machinery-ltd@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'musa-body-machinery-ltd@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256707888109+256707888101' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'trader', 'free', 'MUSA BODY MACHINERY LTD', 'MUSA BODY MACHINERY LTD',
      'MB', '+256707888109+256707888101', null, '+256707888109+256707888101', 'musa-body-machinery-ltd@suppliers.bubu.market',
      'Kampala, Uganda, Musa Body Building, Plot 1080 Katwe - Mutesa 1 Road, Central, Kampala', 'kampala', 'hardware and tools', 'MUSA BODY MACHINERY LTD supplies hardware and tools from Kampala. 5 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'MUSA BODY MACHINERY LTD supplies hardware and tools from Kampala. 5 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'hardware-tools') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Home-Banner.jpg', 'MUSA BODY MACHINERY LTD — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Apple and Pear Processing Line';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Apple and Pear Processing Line', 'hardware-tools', 'MusaBody Machinery’s professional apple/pear processing machine manufacturer and exporter in Uganda which can provide turnkey solution and technology for apple and pear processing line. Description of Apple/Pear Processing Line Since Uganda ranks the biggest concentrated apple juice producer in the region market, MusaBody Machinery has created a processing segment that provides all of the necessary apple processing machinery for achieving quality products at controlled cost. High quality products and services have positioned MusaBody Machinery as the Ugandan market leader in apple juice processing equipment. MusaBody Machinery’s fruit reception lines are designed to satisfy the most rigorous standards of hygiene in cleaning the raw material. Then highly sophisticated mills ensure optimized mash preparation. Featuring a unique drainage system, the MusaBody Machinery Belt Press with an… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 180000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15008_89471844.jpg', 'Apple and Pear Processing Line', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15008_89463537.jpg', 'Apple and Pear Processing Line', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15008_89473017.jpg', 'Apple and Pear Processing Line', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Dried Vegetable and Fruit Processing Line';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Dried Vegetable and Fruit Processing Line', 'hardware-tools', 'Suitable for apple, pear, peach, apricot, mulberry, banana, tomato and etc, also suitable for root and foliage vegetables, to produce dried production; This processing line combines with washing, elevating, sorting, conveyor machine, dicer, slicer, destoner, blancher, cooler, dehydrator, drier, packager, metal detector, ink jet coder, and canton packaging . With advanced design philosophy, high degree of automation; Main equipments are all made of high quality food grade stainless steel, accords with the hygienic requirements of food processing. Parameters Raw Material Apple, pear, apricot, mulberry, banana, tomato; root & foliage vegetable End production Chips, Dried fruit Capacity 500KG/H-10T/H Package Material Adjustable Volume Adjustable Package Plastic bottle/glass bottle/plastic bag Capacity Adjustable Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 320000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15008_89463537.jpg', 'Dried Vegetable and Fruit Processing Line', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15008_89471844.jpg', 'Dried Vegetable and Fruit Processing Line', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15008_89473017.jpg', 'Dried Vegetable and Fruit Processing Line', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Fruit Wine and Vinegar Beverage Processing Line';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Fruit Wine and Vinegar Beverage Processing Line', 'hardware-tools', 'Suitable for apple, grapes, orange, strawberry, peach processing of berries to generate all kinds of wine and fruit vinegar drink. This production line is mainly composed of Juice pre-treatment processing equipment, seeding tank, alcohol fermentation tank, aging tank, sterilization machine, filter, fruit vinegar fermentation tank, filling machine. This production line design features advanced design idea, high degree of automation; Main equipments are all made of high quality food grade stainless steel, accords with the hygienic requirements of food processing. Features Capacity varies from 3tons/day to 500tons/day. Able to process fruit with similar processing characteristics such as apple, grape, strawberry, orange, hawthorn, strawberries and other fruits Can produce fermented drinks, distillation wine, sparkling wine, and all kinds of fruit vinegar beverage Precise automatic control… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 28000, 'crate', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15008_89473017.jpg', 'Fruit Wine and Vinegar Beverage Processing Line', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15008_89471844.jpg', 'Fruit Wine and Vinegar Beverage Processing Line', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15008_89463537.jpg', 'Fruit Wine and Vinegar Beverage Processing Line', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Mango and Pineapple Juice Processing Plant';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Mango and Pineapple Juice Processing Plant', 'hardware-tools', 'High quality products and services have positioned MusaBody Machinery as the Uganda market leader in mango/pineapple juice processing equipment. Since Uganda ranks the biggest concentrated mango/pineapple juice producer in the regional market, MusaBody Machinery has created a mango/pineapple processing segment that provides all of the necessary processing machinery for achieving quality products at controlled cost. MusaBody Machinery’s fruit reception lines are designed to satisfy the most rigorous standards of hygiene in cleaning the raw material. Then highly sophisticated mills ensure optimized mash preparation. Featuring a unique drainage system, the MusaBody Machinery Belt Press with an optimizing control system gives a maximum yield of top quality juices with very low sediment content. Equipped with ultrafiltration system, membrane filtration systems produce clear and stable… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 25000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15008_89464531.jpg', 'Mango and Pineapple Juice Processing Plant', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15008_89471844.jpg', 'Mango and Pineapple Juice Processing Plant', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15008_89463537.jpg', 'Mango and Pineapple Juice Processing Plant', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Three-Piece Can Packaging Line';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Three-Piece Can Packaging Line', 'hardware-tools', 'Three-piece can is packing can-type container made of foil through crimping and bonding resistance welding process, consisted of can body, can bottom and can top. There is seam in can body; can body is wrap-sealed with can bottom and can top. Commonly used in food, beverage, dry powder, chemical and spray products. Compositions Consists of empty can unpiler, empty can conveyor, turning and washing machine, filling machine, sealing machine, tunnel sterilization cooler, vacuum detection machine, inkjet printer, full can conveyor, packing machine, palletizing machine, control system and a set of filling and packaging line. Capacity Available supply capacity from 3000 bottles/h to 36000 bottles/h. Application Tomato jam, concentrated fruit juice, honey, high concentration and high-viscosity products. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 180000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15008_89461447.jpg', 'Three-Piece Can Packaging Line', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery15008-345061828.jpg', 'Three-Piece Can Packaging Line', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15008_89471844.jpg', 'Three-Piece Can Packaging Line', true);
  end if;
end $$;

-- Briande Investments · +256760307670+256753383788 · 10 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'briande-investments@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'briande-investments@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256760307670+256753383788' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'trader', 'free', 'Briande Investments', 'Briande Investments',
      'BI', '+256760307670+256753383788', null, '+256760307670+256753383788', 'briande-investments@suppliers.bubu.market',
      'Plot 24218, Buggu - Busabala, Wakiso District 300mtrs off Southern Bypass, Wakiso, Kampala, Munyonyo, Kampala', 'kampala', 'industrial chemicals', 'Briande Investments supplies industrial chemicals from Kampala. 10 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Briande Investments supplies industrial chemicals from Kampala. 10 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'chemicals-industrial') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/brian_260608214318532_001.jpg', 'Briande Investments — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'High-Purity Nitrogen Gas';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'High-Purity Nitrogen Gas', 'chemicals-industrial', 'Nitrogen Gas Supply Solutions Briande Investments Ltd supplies high-purity nitrogen gas in both liquid and gaseous forms for industrial, medical, laboratory, manufacturing, food processing, agricultural and commercial applications throughout Uganda and East Africa. The company provides reliable nitrogen supply solutions designed to support productivity, product quality, safety and operational efficiency across a wide range of industries. Nitrogen is one of the most widely used industrial gases due to its inert properties, making it ideal for applications where oxidation, contamination, moisture and unwanted chemical reactions must be prevented. Briande Investments Ltd supplies nitrogen gas to organizations that require dependable gas solutions for manufacturing processes, food preservation, laboratory operations, electronics production, metal fabrication, chemical processing and… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 145000, 'cylinder', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/88589_bria_20260609083116.jpg', 'High-Purity Nitrogen Gas', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/88589_bria_20260609084319.jpg', 'High-Purity Nitrogen Gas', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/88589_bria_20260609084500.jpg', 'High-Purity Nitrogen Gas', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Liquid Nitrogen Supply & Solutions';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Liquid Nitrogen Supply & Solutions', 'chemicals-industrial', 'Liquid Nitrogen Supply Solutions Briande Investments Ltd supplies high-purity Liquid Nitrogen (LN2) for healthcare, fertility clinics, laboratories, pharmaceuticals, food processing, agriculture, metal fabrication, education, research and industrial applications across Uganda and the East African region. Liquid Nitrogen is an ultra-cold cryogenic liquid widely used where extremely low temperatures are required for preservation, freezing, cooling, shrink-fitting, laboratory work and sensitive industrial processes. Briande Investments Ltd provides safe, reliable and professionally managed Liquid Nitrogen supply solutions designed to support customers that require consistent cryogenic performance, purity and dependable delivery. The company supplies Liquid Nitrogen in insulated cryogenic containers, Dewars, cylinders and bulk storage systems depending on customer requirements and… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 3200, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/88589_liqu_20260609091625.jpg', 'Liquid Nitrogen Supply & Solutions', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/88589_liqu_20260609091837.jpg', 'Liquid Nitrogen Supply & Solutions', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/88589_liqu_20260609091905.jpg', 'Liquid Nitrogen Supply & Solutions', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Liquid Oxygen Supply & Solutions';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Liquid Oxygen Supply & Solutions', 'chemicals-industrial', 'Liquid Oxygen Supply Solutions Briande Investments Ltd supplies high-purity Liquid Oxygen (LOX) for hospitals, healthcare facilities, manufacturing industries, laboratories, engineering operations and commercial users across Uganda and East Africa. The company provides dependable liquid oxygen supply solutions designed to support organizations that require continuous, large-volume and cost-effective oxygen availability. Liquid Oxygen is oxygen that has been cooled to cryogenic temperatures and stored in liquid form for efficient transportation, storage and distribution. Because liquid oxygen occupies significantly less space than gaseous oxygen, it is an ideal solution for facilities with high oxygen consumption requirements. Briande Investments Ltd supplies Liquid Oxygen to customers seeking reliable, uninterrupted oxygen availability while maximizing storage efficiency and reducing… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 145000, 'cylinder', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/88589_liqu_20260609100746.jpg', 'Liquid Oxygen Supply & Solutions', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/88589_liqu_20260609100837.jpg', 'Liquid Oxygen Supply & Solutions', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/88589_liqu_20260609100856.jpg', 'Liquid Oxygen Supply & Solutions', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Medical Oxygen Supply & Solutions';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Medical Oxygen Supply & Solutions', 'chemicals-industrial', 'Medical Oxygen Supply Solutions Briande Investments Ltd supplies high-quality Medical Oxygen for hospitals, clinics, health centres, emergency response units, intensive care facilities, maternity centres, medical laboratories and healthcare institutions throughout Uganda and East Africa. The company provides reliable oxygen solutions designed to support patient care, emergency treatment and life-saving medical procedures. Medical Oxygen is one of the most critical healthcare resources used in modern medicine. It is essential for treating respiratory conditions, supporting surgical procedures, providing emergency care and assisting patients who require supplemental oxygen therapy. Briande Investments Ltd helps healthcare providers maintain continuous access to dependable medical oxygen through professionally managed supply solutions tailored to healthcare environments. The company… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 145000, 'cylinder', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/88589_medi_20260610231116.jpg', 'Medical Oxygen Supply & Solutions', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/88589_liqu_20260610231759.jpg', 'Medical Oxygen Supply & Solutions', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/88589_medi_20260610231655.jpg', 'Medical Oxygen Supply & Solutions', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Oxygen Gas Supply & Solutions';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Oxygen Gas Supply & Solutions', 'chemicals-industrial', 'Oxygen Gas Supply Solutions Briande Investments Ltd supplies high-quality Oxygen Gas for medical, industrial, laboratory, manufacturing, welding, fabrication, engineering and commercial applications across Uganda and the East African region. Oxygen Gas is one of the most essential gases used in healthcare, industry and technical operations. Briande Investments Ltd supplies dependable Oxygen Gas solutions for organizations that require safe, consistent and professionally managed gas supply for critical operations, production processes and specialized applications. The company supplies Oxygen Gas in cylinders, bulk systems and customized supply arrangements depending on customer requirements. Briande Investments Ltd serves hospitals, clinics, emergency care units, laboratories, manufacturing facilities, welding workshops, fabrication companies, engineering firms, food processing companies… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 180000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/88589_bria_20260609094046.jpg', 'Oxygen Gas Supply & Solutions', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/88589_bria_20260609094132.jpg', 'Oxygen Gas Supply & Solutions', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/88589_bria_20260609094151.jpg', 'Oxygen Gas Supply & Solutions', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Briande Dewar Tanks';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Briande Dewar Tanks', 'chemicals-industrial', 'Dewar Tanks and Cryogenic Storage Solutions Briande Investments Ltd supplies high-quality Dewar Tanks for the safe storage, transportation and dispensing of Liquid Nitrogen, Liquid Oxygen and other cryogenic gases. The company provides reliable cryogenic storage solutions for hospitals, laboratories, IVF centres, research institutions, manufacturers, food processors, agricultural organizations and industrial facilities throughout Uganda and East Africa. Dewar Tanks, commonly known as cryogenic storage tanks or Dewar vessels, are specially engineered vacuum-insulated containers designed to store liquefied gases at extremely low temperatures. Their advanced insulation technology minimizes heat transfer and evaporation, helping preserve cryogenic liquids for extended periods while maintaining safety and operational efficiency. Dewars are widely used for Liquid Nitrogen and Liquid Oxygen… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 320000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/88589_bria_20260610234121.jpg', 'Briande Dewar Tanks', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/88589_cryo_20260610235158.jpg', 'Briande Dewar Tanks', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/88589_bria_20260609083116.jpg', 'Briande Dewar Tanks', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Cryogenic Cylinder Tanks';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Cryogenic Cylinder Tanks', 'chemicals-industrial', 'Cryogenic Cylinder Tanks Briande Investments Ltd supplies high-performance Cryogenic Cylinder Tanks designed for the safe storage, transportation and dispensing of Liquid Oxygen (LOX), Liquid Nitrogen (LIN), Liquid Argon (LAR) and other cryogenic gases. These advanced storage systems provide an efficient and economical solution for organizations requiring reliable cryogenic liquid supply and distribution. Cryogenic Cylinder Tanks are vacuum-insulated pressure vessels specially engineered to store liquefied gases at extremely low temperatures while minimizing product loss through evaporation. These tanks combine the portability of cylinders with the storage advantages of larger cryogenic systems, making them ideal for hospitals, laboratories, manufacturing facilities, food processors, research institutions and industrial operations. Cryogenic tanks use double-wall insulated construction… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 320000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/88589_cryo_20260610235158.jpg', 'Cryogenic Cylinder Tanks', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/88589_bria_20260610234121.jpg', 'Cryogenic Cylinder Tanks', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/88589_bria_20260609083116.jpg', 'Cryogenic Cylinder Tanks', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'ISO Container Tanks';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'ISO Container Tanks', 'chemicals-industrial', 'ISO Container Tanks Briande Investments Ltd supplies ISO Container Tanks designed for the safe, efficient and compliant transportation of cryogenic liquids across regional and international supply chains. These specialized tanks provide a versatile solution for bulk movement, temporary storage and distribution of industrial and medical gases. ISO Container Tanks are internationally standardized transport vessels engineered to fit seamlessly within global shipping, road transport and rail logistics networks. Their robust design allows cryogenic liquids to be transported safely while maintaining required temperatures and product quality throughout the journey. These tanks provide an efficient solution for organizations involved in large-scale gas production, distribution, healthcare support, manufacturing, food processing and industrial operations. Their compatibility with multiple… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 320000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/88589_iso-_20260611002606.jpg', 'ISO Container Tanks', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/88589_bria_20260610234121.jpg', 'ISO Container Tanks', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/88589_cryo_20260610235158.jpg', 'ISO Container Tanks', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Micro Bulk Tanks';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Micro Bulk Tanks', 'chemicals-industrial', 'Micro Bulk Tanks Briande Investments Ltd supplies high-performance Micro Bulk Tanks for the storage, distribution and management of Liquid Oxygen, Liquid Nitrogen and other cryogenic gases. These advanced cryogenic storage systems provide a cost-effective, safe and reliable alternative to conventional gas cylinder supply, helping organizations maintain uninterrupted access to essential gases while improving operational efficiency. Micro Bulk Tanks are vacuum-insulated cryogenic storage systems designed to store liquefied gases at extremely low temperatures while supplying gas directly to equipment, facilities or production processes. They bridge the gap between traditional gas cylinders and large bulk storage installations, making them an ideal solution for organizations with moderate to high gas consumption requirements. Briande Investments Ltd provides Micro Bulk Tank solutions for… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 320000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/88589_micr_20260611000435.jpg', 'Micro Bulk Tanks', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/88589_bria_20260610234121.jpg', 'Micro Bulk Tanks', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/88589_cryo_20260610235158.jpg', 'Micro Bulk Tanks', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Semi Trailer Tanks';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Semi Trailer Tanks', 'chemicals-industrial', 'Semi Trailer Tanks Briande Investments Ltd supplies Semi Trailer Tanks for the safe transportation and bulk distribution of Liquid Oxygen, Liquid Nitrogen and other cryogenic gases. These mobile cryogenic transport systems are designed for large-volume gas logistics, bulk delivery operations and reliable supply chain support for medical, industrial and commercial customers. Semi Trailer Tanks are specialized cryogenic transport tanks mounted on trailer systems to enable efficient movement of liquefied gases over long distances. They are designed to maintain extremely low temperatures during transportation while preserving product quality, minimizing evaporation losses and supporting safe bulk delivery. Briande Investments Ltd provides Semi Trailer Tank solutions for organizations involved in cryogenic gas transportation, bulk oxygen delivery, liquid nitrogen distribution and industrial… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 320000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/88589_semi_20260611001857.jpg', 'Semi Trailer Tanks', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/88589_bria_20260610234121.jpg', 'Semi Trailer Tanks', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/88589_cryo_20260610235158.jpg', 'Semi Trailer Tanks', true);
  end if;
end $$;

-- Fine Spinners Uganda Limited · +256414342716 · 4 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'fine-spinners-uganda-limited@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'fine-spinners-uganda-limited@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256414342716' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'manufacturer', 'free', 'Fine Spinners Uganda Limited', 'Fine Spinners Uganda Limited',
      'FS', '+256414342716', null, '+256414342716', 'fine-spinners-uganda-limited@suppliers.bubu.market',
      'Kampala, Uganda, Plot 33A-41A Spring Road, Kiswa Zone Bugolobi, Ntinda, Kampala', 'kampala', 'textiles and apparel', 'Fine Spinners Uganda Limited supplies textiles and apparel from Kampala. 4 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Fine Spinners Uganda Limited supplies textiles and apparel from Kampala. 4 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'textiles-apparel') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Prod-_2881_68612247.jpg', 'Fine Spinners Uganda Limited — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Men’s Raglan Polo';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Men’s Raglan Polo', 'textiles-apparel', 'Men’s Raglan Polo 100% Cotton GSM 180 Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 85000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2881_686113815.,.jpg', 'Men’s Raglan Polo', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2881_68612247.jpg', 'Men’s Raglan Polo', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2881_686113815.%2c.jpg', 'Men’s Raglan Polo', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Men''s Crew Neck 3/4" Raglan Sleeve';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Men''s Crew Neck 3/4" Raglan Sleeve', 'textiles-apparel', 'Men''s Crew Neck 3/4" Raglan Sleeve. 100% cotton GSM 160-180 , 12 Colours. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 85000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2881_6861195.png', 'Men''s Crew Neck 3/4" Raglan Sleeve', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2881_68612247.jpg', 'Men''s Crew Neck 3/4" Raglan Sleeve', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2881_686113815.%2c.jpg', 'Men''s Crew Neck 3/4" Raglan Sleeve', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Men''s Pant';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Men''s Pant', 'textiles-apparel', 'Men''s Pant 100% Cotton Fleece GCM 180, 12 Colours. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 85000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2881_686114613.png', 'Men''s Pant', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2881_68612247.jpg', 'Men''s Pant', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2881_686113815.%2c.jpg', 'Men''s Pant', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Ladies Pajama Kit';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Ladies Pajama Kit', 'textiles-apparel', 'Ladies Pajama Kit 100% Cotton, GCM 160, 12 Colours. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 85000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2881_68612247.jpg', 'Ladies Pajama Kit', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2881_686113815.%2c.jpg', 'Ladies Pajama Kit', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2881_6861195.png', 'Ladies Pajama Kit', true);
  end if;
end $$;

-- TWIGA CHEMICAL INDUSTRIES · +2560641257050259811 · 2 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'twiga-chemical-industries@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'twiga-chemical-industries@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+2560641257050259811' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'manufacturer', 'free', 'TWIGA CHEMICAL INDUSTRIES', 'TWIGA CHEMICAL INDUSTRIES',
      'TC', '+2560641257050259811', null, '+2560641257050259811', 'twiga-chemical-industries@suppliers.bubu.market',
      '71, 7th Street, Industrial Area, Central, Kampala', 'kampala', 'industrial chemicals', 'TWIGA CHEMICAL INDUSTRIES supplies industrial chemicals from Kampala. 2 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'TWIGA CHEMICAL INDUSTRIES supplies industrial chemicals from Kampala. 2 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'chemicals-industrial') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Prod-_14736_701121252.jpg', 'TWIGA CHEMICAL INDUSTRIES — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'PALILIA 40SC';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'PALILIA 40SC', 'chemicals-industrial', 'Palilia 40SC is a systemic and selective post-emergence herbicide used to control annual and perennial broad-leaved weeds, grasses and sedges in maize and baby corn. Available Pack Sizes: 20 Litres 5 Litres 1 Litre Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 25000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14736_701121252.jpg', 'PALILIA 40SC', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14736_701122317.jpg', 'PALILIA 40SC', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'TWIGAFAS XTRA';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'TWIGAFAS XTRA', 'chemicals-industrial', 'Twigafas Xtra is a fluke and worm drench for cattle, sheep, and goats. Available Pack Sizes: 1 Litre 500ml 125ml Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 145000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14736_701122317.jpg', 'TWIGAFAS XTRA', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14736_701121252.jpg', 'TWIGAFAS XTRA', true);
  end if;
end $$;

-- Shumuk Aluminium Industries Ltd. S.A.I.L · +256414505974+256414286282 · 1 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'shumuk-aluminium-industries-ltd-s-a-i-l@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'shumuk-aluminium-industries-ltd-s-a-i-l@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256414505974+256414286282' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'manufacturer', 'free', 'Shumuk Aluminium Industries Ltd. S.A.I.L', 'Shumuk Aluminium Industries Ltd. S.A.I.L',
      'SA', '+256414505974+256414286282', null, '+256414505974+256414286282', 'shumuk-aluminium-industries-ltd-s-a-i-l@suppliers.bubu.market',
      'Kampala, Uganda., Plot 24 Mukabya Road, Nakawa Industrial Area, Central, Kampala', 'kampala', 'electronics', 'Shumuk Aluminium Industries Ltd. S.A.I.L supplies electronics from Kampala. 1 line is listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Shumuk Aluminium Industries Ltd. S.A.I.L supplies electronics from Kampala. 1 line is listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'electronics') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Prod-_3149_698181713.jpg', 'Shumuk Aluminium Industries Ltd. S.A.I.L — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Aluminum Doors & Windows';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Aluminum Doors & Windows', 'electronics', 'Aluminium extrusions for making windows, curtain walling, show cases,counters,office partions etc Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 320000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3149_698181713.jpg', 'Aluminum Doors & Windows', true);
  end if;
end $$;

-- Crane Paper Bags Ltd · +256393333379 · 4 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'crane-paper-bags-ltd@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'crane-paper-bags-ltd@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256393333379' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'manufacturer', 'free', 'Crane Paper Bags Ltd', 'Crane Paper Bags Ltd',
      'CP', '+256393333379', null, '+256393333379', 'crane-paper-bags-ltd@suppliers.bubu.market',
      'Bweyogerere Kakajjo, Uganda, Kampala - Uganda, Plot 1, 3 & 5 First street, Bweyogerere Industrial Park Uganda, Industrial Area, Kampala', 'kampala', 'stationery, art and printing', 'Crane Paper Bags Ltd supplies stationery, art and printing from Kampala. 4 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Crane Paper Bags Ltd supplies stationery, art and printing from Kampala. 4 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'stationery-printing') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Prod-_21959_65120253.jpg', 'Crane Paper Bags Ltd — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Paper and pad - Branded paper bags';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Paper and pad - Branded paper bags', 'stationery-printing', 'We provide branded paper bags for fast food outlets, supermarkets, retail outlets and any other type of business. Our branded paper bags come in all sizes. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 22000, 'box', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_21959_65120253.jpg', 'Paper and pad - Branded paper bags', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery21959-3207222611.jpg', 'Paper and pad - Branded paper bags', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery21959-320722370.jpg', 'Paper and pad - Branded paper bags', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Paper and pad - Grocery paper bags';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Paper and pad - Grocery paper bags', 'stationery-printing', 'We make a variety of grocery paper bags that can be used in supermarkets, retail outlets, among others. Our paper bags come in different sized to suite all your needs. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 22000, 'box', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_21959_652201315.jpg', 'Paper and pad - Grocery paper bags', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_21959_65120253.jpg', 'Paper and pad - Grocery paper bags', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_21959_652172133.jpg', 'Paper and pad - Grocery paper bags', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Paper and pad - Milk powder/Open mouth bags';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Paper and pad - Milk powder/Open mouth bags', 'stationery-printing', 'Open mouth sacks are mainly used for filling of powder milk, sugar, flour, animal feeds and granular and loose fill industrial products such as cement, lime and adhesives. We are also able to add liners for milk powder and sugar packing for protection against moisture. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 32000, 'bag', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_21959_652172133.jpg', 'Paper and pad - Milk powder/Open mouth bags', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_21959_65120253.jpg', 'Paper and pad - Milk powder/Open mouth bags', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_21959_652201315.jpg', 'Paper and pad - Milk powder/Open mouth bags', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Paper and pad - Millinery bags';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Paper and pad - Millinery bags', 'stationery-printing', 'Millinery Bags are bags with an open top and a flat bottom made in various grades of paper and can be branded. The are mainly used at point of sale in shops and fast food outlets. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 22000, 'box', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_21959_652195045.jpg', 'Paper and pad - Millinery bags', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_21959_65120253.jpg', 'Paper and pad - Millinery bags', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_21959_652201315.jpg', 'Paper and pad - Millinery bags', true);
  end if;
end $$;

-- Picfare Industries Ltd · +256414230416+256414256356 · 1 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'picfare-industries-ltd@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'picfare-industries-ltd@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256414230416+256414256356' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'manufacturer', 'free', 'Picfare Industries Ltd', 'Picfare Industries Ltd',
      'PI', '+256414230416+256414256356', null, '+256414230416+256414256356', 'picfare-industries-ltd@suppliers.bubu.market',
      'FACTORY: Yusuf Lule Road Njeru Jinja, Uganda, Kampala, Uganda, Marketing: Picfare House Plot No. 37, Jinja Road P.O. Box 9396, Kampala, Ugan', 'kampala', 'stationery, art and printing', 'Picfare Industries Ltd supplies stationery, art and printing from Kampala. 1 line is listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Picfare Industries Ltd supplies stationery, art and printing from Kampala. 1 line is listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'stationery-printing') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Prod-_610_68915446.png', 'Picfare Industries Ltd — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Star Counter Books';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Star Counter Books', 'stationery-printing', 'Star This is the diamond in the counter book range. It is made using the best materials and highest standards ensuring a premium, machine stitched hard cover book is delivered. This product is a must have in your office, or for your student. It is available is 192 pages. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 16000, 'ream', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_610_68915446.png', 'Star Counter Books', true);
  end if;
end $$;

-- Berger Paints (U) Limited · +2564142590625 · 1 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'berger-paints-u-limited@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'berger-paints-u-limited@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+2564142590625' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'manufacturer', 'free', 'Berger Paints (U) Limited', 'Berger Paints (U) Limited',
      'BP', '+2564142590625', null, '+2564142590625', 'berger-paints-u-limited@suppliers.bubu.market',
      'Uganda, Sixth Street, Industrial Area, Kampala, Central, Kampala', 'kampala', 'paints and finishes', 'Berger Paints (U) Limited supplies paints and finishes from Kampala. 1 line is listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Berger Paints (U) Limited supplies paints and finishes from Kampala. 1 line is listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'paints-finishes') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Prod-_3262_700122024.jpg', 'Berger Paints (U) Limited — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Black Bitumastic Paint (Anti Corrosive)';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Black Bitumastic Paint (Anti Corrosive)', 'paints-finishes', 'The theoretical coverage of ROBBIALAC BLACK BITUMASTIC PAINT would be approximately 8 – 10 M²/ liter at a Dry film thickness of 40 A Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 95000, 'bucket', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3262_700122024.jpg', 'Black Bitumastic Paint (Anti Corrosive)', true);
  end if;
end $$;

-- African Polysack Industries Ltd · +256717290587+256700290587+256709015041 · 2 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'african-polysack-industries-ltd@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'african-polysack-industries-ltd@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256717290587+256700290587+256709015041' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'manufacturer', 'free', 'African Polysack Industries Ltd', 'African Polysack Industries Ltd',
      'AP', '+256717290587+256700290587+256709015041', null, '+256717290587+256700290587+256709015041', 'african-polysack-industries-ltd@suppliers.bubu.market',
      'Kampala – Uganda., Block 106, Plot No. 171 – 172 Nvumwa, Kigunga-Seeta, Mukono District, Central, Mukono', 'kampala', 'hardware and tools', 'African Polysack Industries Ltd supplies hardware and tools from Kampala. 2 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'African Polysack Industries Ltd supplies hardware and tools from Kampala. 2 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'hardware-tools') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Prod-_3284_687211646.jpg', 'African Polysack Industries Ltd — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Polypropylene Braided Ropes';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Polypropylene Braided Ropes', 'hardware-tools', 'Polypropylene Braided Ropes Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 180000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3284_687211646.jpg', 'Polypropylene Braided Ropes', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3284_68721049.jpg', 'Polypropylene Braided Ropes', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Woven Polypropylene Bags';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Woven Polypropylene Bags', 'hardware-tools', 'Net Bags for fruits and Vegetables Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 1800, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3284_68721049.jpg', 'Woven Polypropylene Bags', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3284_687211646.jpg', 'Woven Polypropylene Bags', true);
  end if;
end $$;

-- Quality Plastics (U) Limited · +256393348946 · 3 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'quality-plastics-u-limited@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'quality-plastics-u-limited@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256393348946' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'manufacturer', 'free', 'Quality Plastics (U) Limited', 'Quality Plastics (U) Limited',
      'QP', '+256393348946', null, '+256393348946', 'quality-plastics-u-limited@suppliers.bubu.market',
      'Plot #283, Kyagwe, Block 198 Nangwa-Mukono, Central, Kampala', 'kampala', 'hardware and tools', 'Quality Plastics (U) Limited supplies hardware and tools from Kampala. 3 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Quality Plastics (U) Limited supplies hardware and tools from Kampala. 3 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'hardware-tools') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Prod-_3290_69313432.jpg', 'Quality Plastics (U) Limited — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Blown Bottles';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Blown Bottles', 'hardware-tools', 'We produce various coloured bottles suitable for beverages and our quality is certified to the highest standards. We produce that is suitable for your need. We produce wholesale plastic bottles, small plastic bottles, custom plastic bottles, or customized plastic bottle of every type. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 28000, 'crate', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3290_69313432.jpg', 'Blown Bottles', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3290_693125633.png', 'Blown Bottles', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3290_693131019.png', 'Blown Bottles', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Bottle Closures';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Bottle Closures', 'hardware-tools', 'We produce a variety of closure options for your bottles to meet your packaging needs Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 1800, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3290_693125633.png', 'Bottle Closures', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3290_69313432.jpg', 'Bottle Closures', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3290_693131019.png', 'Bottle Closures', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'PP Film';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'PP Film', 'hardware-tools', 'Polypropylene or PP is a low-cost thermoplastic of high clarity, high gloss, and with good tensile strength. PP films are well suited for a broad range of industrial, consumer, and automotive applications. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 1800, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3290_693131019.png', 'PP Film', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3290_69313432.jpg', 'PP Film', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3290_693125633.png', 'PP Film', true);
  end if;
end $$;

-- BETINA FASHION WEAR · +256772516777+25670387635507833036940754811340 · 6 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'betina-fashion-wear@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'betina-fashion-wear@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256772516777+25670387635507833036940754811340' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'trader', 'free', 'BETINA FASHION WEAR', 'BETINA FASHION WEAR',
      'BF', '+256772516777+25670387635507833036940754811340', null, '+256772516777+25670387635507833036940754811340', 'betina-fashion-wear@suppliers.bubu.market',
      'Akamwesi Shopping Mall -Kyebando First Floor Shop no: NW-09, ., Central, Kampala', 'kampala', 'textiles and apparel', 'BETINA FASHION WEAR supplies textiles and apparel from Kampala. 6 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'BETINA FASHION WEAR supplies textiles and apparel from Kampala. 6 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'textiles-apparel') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Prod-_27510_824132616.jpg', 'BETINA FASHION WEAR — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'gmc';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'gmc', 'textiles-apparel', 'Gmc Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 85000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27510_824132616.jpg', 'gmc', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27510_82412474.jpg', 'gmc', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27510_82413042.jpg', 'gmc', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Goms';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Goms', 'textiles-apparel', 'Gomasi Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 85000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27510_82412474.jpg', 'Goms', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27510_824132616.jpg', 'Goms', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27510_82413042.jpg', 'Goms', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'jpo';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'jpo', 'textiles-apparel', 'Jpo Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 85000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27510_82413042.jpg', 'jpo', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27510_824132616.jpg', 'jpo', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27510_82412474.jpg', 'jpo', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Ladies Garments - pl';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Ladies Garments - pl', 'textiles-apparel', 'Pl Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 85000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27510_824132339.jpg', 'Ladies Garments - pl', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27510_824132616.jpg', 'Ladies Garments - pl', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27510_82412474.jpg', 'Ladies Garments - pl', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'wear';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'wear', 'textiles-apparel', 'Gomasi Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 85000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27510_824125151.jpg', 'wear', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27510_824132616.jpg', 'wear', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27510_82412474.jpg', 'wear', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'wear1';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'wear1', 'textiles-apparel', 'Gomasi Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 85000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27510_824125641.jpg', 'wear1', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27510_824132616.jpg', 'wear1', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27510_82412474.jpg', 'wear1', true);
  end if;
end $$;

-- XTREME Bridals · +256772675157+25670467515707726751570704675157 · 4 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'xtreme-bridals@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'xtreme-bridals@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256772675157+25670467515707726751570704675157' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'trader', 'free', 'XTREME Bridals', 'XTREME Bridals',
      'XB', '+256772675157+25670467515707726751570704675157', null, '+256772675157+25670467515707726751570704675157', 'xtreme-bridals@suppliers.bubu.market',
      'Akamwesi Shopping Mall 1st Floor Room CW-10. Along Gayaza Road Kampala - Uganda, ., Central, Kampala', 'kampala', 'textiles and apparel', 'XTREME Bridals supplies textiles and apparel from Kampala. 4 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'XTREME Bridals supplies textiles and apparel from Kampala. 4 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'textiles-apparel') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Prod-_27489_821111559.jpg', 'XTREME Bridals — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'xtreme 5';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'xtreme 5', 'textiles-apparel', 'Wedding gown Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 85000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27489_821111559.jpg', 'xtreme 5', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27489_821112023.jpg', 'xtreme 5', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27489_821112459.jpg', 'xtreme 5', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'xtreme 6';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'xtreme 6', 'textiles-apparel', 'Wedding gown Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 85000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27489_821112023.jpg', 'xtreme 6', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27489_821111559.jpg', 'xtreme 6', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27489_821112459.jpg', 'xtreme 6', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'xtreme 7';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'xtreme 7', 'textiles-apparel', 'Wedding gown Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 85000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27489_821112459.jpg', 'xtreme 7', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27489_821111559.jpg', 'xtreme 7', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27489_821112023.jpg', 'xtreme 7', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'xtreme 8';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'xtreme 8', 'textiles-apparel', 'Wedding gown Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 85000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27489_821113237.jpg', 'xtreme 8', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27489_821111559.jpg', 'xtreme 8', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27489_821112023.jpg', 'xtreme 8', true);
  end if;
end $$;

-- Aquva International Ltd · +25607824737300772507908+256041425617120312262110 · 2 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'aquva-international-ltd@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'aquva-international-ltd@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+25607824737300772507908+256041425617120312262110' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'trader', 'free', 'Aquva International Ltd', 'Aquva International Ltd',
      'AI', '+25607824737300772507908+256041425617120312262110', null, '+25607824737300772507908+256041425617120312262110', 'aquva-international-ltd@suppliers.bubu.market',
      'Factory Address: Plot 37 – 43, Kabira Road, Industrial Area, Kampala, Kampala, Uganda. Shop address: Plot 1, Sure House, Bomba Road , Kampal', 'kampala', 'Trade goods', 'Aquva International Ltd supplies trade goods from Kampala. 2 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Aquva International Ltd supplies trade goods from Kampala. 2 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;


  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Prod-_21092_65415502.jpg', 'Aquva International Ltd — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Boiler Installation Materials';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Boiler Installation Materials', null, 'We keep in stock Glass wool Rolls with Aluminum Foils, Rock Wool Sheets, Rock Wool Pipe Lugging preformed Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 38000, 'length', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_21092_65415502.jpg', 'Boiler Installation Materials', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_21092_654133329.jpg', 'Boiler Installation Materials', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'SKF Bearings';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'SKF Bearings', null, 'Aquva International is one of most vibrant Distributor of SKF Bearings in Uganda. We keep all types of Bearings Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 95000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_21092_654133329.jpg', 'SKF Bearings', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_21092_65415502.jpg', 'SKF Bearings', true);
  end if;
end $$;

-- IDROID Technologies Limited · +256700800000414532463 · 4 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'idroid-technologies-limited@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'idroid-technologies-limited@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256700800000414532463' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'trader', 'free', 'IDROID Technologies Limited', 'IDROID Technologies Limited',
      'IT', '+256700800000414532463', null, '+256700800000414532463', 'idroid-technologies-limited@suppliers.bubu.market',
      '52, Kanjokya, Kamwokya, Kampala', 'kampala', 'Trade goods', 'IDROID Technologies Limited supplies trade goods from Kampala. 4 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'IDROID Technologies Limited supplies trade goods from Kampala. 4 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;


  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/IDROID%20WRIST.jpg', 'IDROID Technologies Limited — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'IDROID FIT.';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'IDROID FIT.', null, 'Tired of handing your big smartphone all the time? Fed up of having to keep an eye on your cell? You need to relax. Get iDROID Wrist to become hassle free and get an exclusive, stylish and graceful look while you are wearing it. iDROID Wrist has proved to be the smartest blue tooth watch solution since its launch as regards a handy alternative to your big screen smartphone. It has got a perfect and professional look with its steel body and soft rubber straps. Now you can just get all your notifications, text messages, email alerts on your smart watch by which you can gauge whether or not a particular message, Multiple features can be found in this outclass android smart watch which many other android wear watches are not readily offering as yet. The basic theme or concept of iDROID Wrist is to provide the handiness as well as readiness with which one can operate one’s smartphone on the… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 95000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/IDROID%20WRIST.jpg', 'IDROID FIT.', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/IDROID+WRIST.jpg', 'IDROID FIT.', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/watch.jpg', 'IDROID FIT.', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'IDROID WRIST';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'IDROID WRIST', null, 'After state-of-the-art smartphones, phablets and tablets iDROID brings you technology you can wear. The iDROIDFIT is wearable technology that you don’t even have to slip in your pocket. It resides on your hand ready for your command. Designed especially for people with fitness goals you can now take your contacts and be connected on your morning sprint or at the gym. The iDROID FIT helps chart calories burnt and calories consumed, it helps schedule workouts, yoga days and mark out times for a quick run on the treadmill. This is a health fitness must have! The fitness accessory of the season! Buy them before they run out of stock! Step Up Your Game iDROIDFIT’s pedometer counts your every step as you take it, measures the distance you’ve run, counts the calories you burn and facilitates reminders so you can keep your head in the game while getting the best fitness results on the go. Stay… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 12000, 'box', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/watch.jpg', 'IDROID WRIST', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/IDROID+WRIST.jpg', 'IDROID WRIST', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/x7.jpg', 'IDROID WRIST', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'IDROID X7 BALR';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'IDROID X7 BALR', null, 'Processor Quad Core Processor 1.3 Ghz RAM 1GB Memory 16GB Extendable upto 64 GB SD Card Display 5.5" TFT - LCD HD 1280*720 pixels Dimensions 153.8*77*8.3mm Camera Selfie 5MP and 8MP Rear Weight 85 Gift Box No Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 420000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/x7.jpg', 'IDROID X7 BALR', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/IDROID+WRIST.jpg', 'IDROID X7 BALR', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/watch.jpg', 'IDROID X7 BALR', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'VR BOX 1';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'VR BOX 1', null, 'VR Box 1 with bluetooth controller is the best selling mobile virtual reality headset. It turns your smart phone to virtual reality viewer for 3D games and 3D movies(split screen ). Pupil Distance (PD) and Focal Distance (FD) both can be adjusted to get the best 3D immersive experience. Pupillary Distance adjustment range: 55mm – 75mm. Myopia less than 600 degree is ok to use it without wearing glasses. Fits for iPhone, Android phones and Windows phones with screen size within 6.0 inch, recommended phone size is 4.7- 6 inch. The max length*width of phone is 154mm*82mm. Fits for: Samsung Galaxy Note 4/Galaxy Note 3/ Galaxy S6 Edge/Galaxy S6/iPhone 6s/iPhone 6/iPhone 6 Plus/iPhone 5c/iPhone 5s/iPhone 5/LG G3/SONY Xperia Z3+/HTC One Max/ Desire 816/One M9/ASUS Zenfone 2 etc. The front cover is easy to be removed . It makes the phone cool while using, and it is great for ventilation for… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 95000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/VR%20BOX.jpg', 'VR BOX 1', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/IDROID+WRIST.jpg', 'VR BOX 1', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/watch.jpg', 'VR BOX 1', true);
  end if;
end $$;

commit;

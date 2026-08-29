-- BUBU.Market · Africa2Trust import, part 1 of 6
-- 4 suppliers. Run the parts in order; each one is safe to re-run.
-- READ-ME-FIRST.txt explains the prices and the photographs.
--
--   Power Products Uganda Ltd
--   Roofings Group
--   Easy Power Co. Ltd
--   Hima Cement Ltd

begin;

create extension if not exists pgcrypto;
alter table accounts add column if not exists import_source text;
alter table products add column if not exists import_source text;

-- Power Products Uganda Ltd · +256758383266+256758383340+256414341174+256392176430 · 4 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'power-products-uganda-ltd@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'power-products-uganda-ltd@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256758383266+256758383340+256414341174+256392176430' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'trader', 'free', 'Power Products Uganda Ltd', 'Power Products Uganda Ltd',
      'PP', '+256758383266+256758383340+256414341174+256392176430', null, '+256758383266+256758383340+256414341174+256392176430', 'power-products-uganda-ltd@suppliers.bubu.market',
      'Plot 103 Rubaga Kabusu Kampala - Masaka Road, Central, Kampala', 'kampala', 'hardware and tools', 'Power Products Uganda Ltd supplies hardware and tools, building materials, electronics from Kampala. 4 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Power Products Uganda Ltd supplies hardware and tools, building materials, electronics from Kampala. 4 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'hardware-tools') on conflict do nothing;
  insert into account_categories (account_id, category_id) values (v_acct, 'building-construction') on conflict do nothing;
  insert into account_categories (account_id, category_id) values (v_acct, 'electronics') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Prod-_9182_692194227.jpg', 'Power Products Uganda Ltd — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Pedrollo Water Pumps';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Pedrollo Water Pumps', 'hardware-tools', 'Pedrollo consists of Centrifugal, Jet, Multistage, Peripheral Turbine, Piston, Self Priming, Solid Handling, Submersible and Variable Speed Pumps.that cover most applications in the domestic, commercial, agricultural and industrial fields. Pedrollo pumps are high quality Italian pumps. MODELS PKM70 PKM60 PKM90 CPM158 CPM 220C CPM 230C CPM190 2CP32/200B 2CP32/200C TOP MULTI 2 Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 850000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_9182_692192640.jpg', 'Pedrollo Water Pumps', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_9182_692194227.jpg', 'Pedrollo Water Pumps', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_9182_692195820.png', 'Pedrollo Water Pumps', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'FAST VERDINI COMPACTOR';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'FAST VERDINI COMPACTOR', 'building-construction', 'Fast Verdini retains a reputation for high quality and reliability of its products. Our plus are: experience, very wide range of products and quality. You should always expect quality work and time saving when you use fastverdini products as they are listed below. All own production is MADE IN ITALY. Technical assistance and spare parts are always available at our show rooms. We sell products that are used in three areas of construction: Concrete finishing Compaction Floor cutting Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 180000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_9182_692194227.jpg', 'FAST VERDINI COMPACTOR', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_9182_692195820.png', 'FAST VERDINI COMPACTOR', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_9182_692192640.jpg', 'FAST VERDINI COMPACTOR', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'LINOSELLA CONCRETE MIXER';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'LINOSELLA CONCRETE MIXER', 'building-construction', 'A concrete mixer is a machine that is used to mix construction additives such as cement, water, sand and gravel. Typically, Linosella Products feature this power-driven device made of Lombardini diesel engine, a chute and a revolving drum. The machine is a basic prerequisite for any construction endeavor be it a small scale or large scale construction project. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 32000, 'bag', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_9182_692195820.png', 'LINOSELLA CONCRETE MIXER', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_9182_692194227.jpg', 'LINOSELLA CONCRETE MIXER', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_9182_692192640.jpg', 'LINOSELLA CONCRETE MIXER', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Telwin Battery Chaergers';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Telwin Battery Chaergers', 'electronics', 'Battery charger for charging free electrolyte batteries (WET) with 12/24V voltage. Protected against overloads and polarity reversal. Equipped with selector for normal or quick (BOOST) charge. Equipped with ammeter. Suit for various cars, vans and light trucks. Display of charging and starting current. Single-phase, portable, charging for lead-acid, battery with 12/24V. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 620000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_9182_692202027.png', 'Telwin Battery Chaergers', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_9182_692194227.jpg', 'Telwin Battery Chaergers', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_9182_692195820.png', 'Telwin Battery Chaergers', true);
  end if;
end $$;

-- Roofings Group · +25603123402072560412009524 · 77 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'roofings-group@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'roofings-group@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+25603123402072560412009524' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'manufacturer', 'free', 'Roofings Group', 'Roofings Group',
      'RG', '+25603123402072560412009524', null, '+25603123402072560412009524', 'roofings-group@suppliers.bubu.market',
      'Kampala, Uganda, Plot 126, Lubowa estate, Entebbe Road, Zzana (EBB Rd), Kampala', 'kampala', 'roofing and ceilings', 'Roofings Group supplies roofing and ceilings, hardware and tools, building materials from Kampala. 77 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Roofings Group supplies roofing and ceilings, hardware and tools, building materials from Kampala. 77 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'roofing-ceilings') on conflict do nothing;
  insert into account_categories (account_id, category_id) values (v_acct, 'hardware-tools') on conflict do nothing;
  insert into account_categories (account_id, category_id) values (v_acct, 'building-construction') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/1-Roofings-Group-Too-Much-Quality.jpg', 'Roofings Group — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'SUPER TILE PLUS';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'SUPER TILE PLUS', 'roofing-ceilings', 'These new unique roof tiles can be utilized for Residential & Commercial Purposes as may be required by construction companies. The sheets are available in the following colours; Black, Chocolate Brown, Brick Red, Maroon, Tile Red, Harvest Gold and Super Green for both glossy and wrinkle finish. Color Options Black Brick Red Chocolate Brown Harvest Gold Super Green Tile Red Texture: Glossy(Smooth Finish) Wrinkle (Rough Finish) Categories: AZED Sheets, Sheets Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 55000, 'sheet', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_59420576.png', 'SUPER TILE PLUS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-315020581.png', 'SUPER TILE PLUS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'SUPER TILE PLUS', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Galvanised Pipes (Threaded & Socketed)';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Galvanised Pipes (Threaded & Socketed)', 'hardware-tools', 'BS 1387 / 85 Light Nominal Bore Size in mm Outside Diameter (O.D) Max. mm (O.D) Min. mm Thickness mm Kg/mtr of Black Tube P/E Kg/mtr of Black Tube T/C Kg/Mtr of Galv.Tube P/E Kg/Mtr of Galv.Tube T/C 15.00 21.4 21 2 0.95 0.96 1 1.01 20.00 26.9 26.4 2.3 1.38 1.39 1.45 1.46 25.00 33.8 33.2 2.6 1.98 2 2.07 2.09 32.00 42.5 41.9 2.6 2.54 2.57 2.65 2.68 40.00 48.4 47.8 2.9 3.23 3.27 3.36 3.4 50.00 60.2 59.6 2.9 4.08 4.15 4.24 4.31 65.00 76 75.2 3.2 5.71 5.83 5.94 6.06 80.00 88.7 87.9 3.2 6.72 6.89 6.98 7.16 100.00 113.9 113 3.6 9.75 10 10.14 10.4 NOTE 1. The tubes in this series are supplied in any lenths from 6.00 (+20F t) to 7.00 (+ 24ft) on request. 2. Threading conforms to ISO/R& recommendation 3. Hydraulic pressure test according to ISO prescription : Bar (700 Ib / sq in) Tolerances on thickness + not limited -8% Tolerances on mass + 10% on each tube + 8% on each tube +_4% per load of 150… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 38000, 'length', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/gal-pipes-2.gif', 'Galvanised Pipes (Threaded & Socketed)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'Galvanised Pipes (Threaded & Socketed)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_597133536.png', 'Galvanised Pipes (Threaded & Socketed)', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'MILD STEEL PLATES';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'MILD STEEL PLATES', 'hardware-tools', 'SIZES: MSP 8*4*0.9MM MSP 8*4*1.2MM MSP 8*4*1.5MM MSP 8*4*1MM MSP 8*4*2.5MM MSP 8*4*2.8MM MSP 8*4*2MM MSP 8*4*4MM MSP 8*4*5MM MSP 8*4*6MM MSP 8*4*7MM Category: Mild steel Hot & cold Plates Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 180000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_594203439.png', 'MILD STEEL PLATES', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3150203543.png', 'MILD STEEL PLATES', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'MILD STEEL PLATES', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'MS Plates';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'MS Plates', 'hardware-tools', 'Technical Specifications for MS Plates Size in Feet Width in mm Length in mm Thickness in mm Weight per PC in kg 8''x4'' 1220 2440 0.8 18.769 8''x4'' 1220 2440 1 23.234 8''x4'' 1220 2440 1.2 28.1 8''x4'' 1220 2440 1.5 35.01 8''x4'' 1220 2440 2 46 8''x4'' 1220 2440 2.5 60 8''x4'' 1220 2440 2.8 65.5 8''x4'' 1220 2440 4 95.25 8''x4'' 1220 2440 6 142.88 8''x4'' 1220 2440 8 190.59 8''x4'' 1220 2440 10 238.14 8''x4'' 1220 2440 12 185.76 8''x4'' 1220 2440 15 375 8''x4'' 1220 2440 20 476 8''x4'' 1220 2440 25 585 MS Plates conform to international quality parameters ST 37.2 as per DIN Spec 171000 and JIS 3193 & 3131 MS Plates between 0.8 to 2.8mm can be supplied in customer specified length Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 180000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/msplate.gif', 'MS Plates', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'MS Plates', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_597133536.png', 'MS Plates', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Rectangular Hollow Section';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Rectangular Hollow Section', 'hardware-tools', 'Technical Specifications for Rectangular Hollow Sections Size a x b (mm) Wall Thickness t (mm) Weight kg/mtr Sectional Area cm2 Moment of inertia 1xx cm4 Moment of inertia 1yy cm4 Radius of Gyration 1xx cm Radius of Gyration 1yy cm Modulus of section Zxx cm3 Modulus of section Zyy cm3 30 x 20 1 0.75 0.96 0.6 1.21 0.82 1.12 1.41 1.08 30 x 20 1.2 0.9 1.14 0.73 1.42 0.8 1.11 1.66 1.27 30 x 20 1.5 1.1 1.4 0.89 1.71 0.79 1.1 2.03 1.54 30 x 20 2 1.43 1.82 1.11 2.16 0.78 1.08 2.59 1.94 30 x 20 2.5 1.74 2.22 1.3 2.55 0.75 1.06 4.25 2.18 30 x 20 3 2.04 2.6 1.45 2.89 0.74 1.05 3.56 2.61 30 x 20 1.2 1.23 1.5 3.32 1.59 1.49 1.03 1.66 1.27 30 x 20 1.5 1.54 1.86 4.04 1.93 1.47 1.01 2.02 1.54 40 x 25 2 1.88 2.44 5.17 2.43 1.45 0.99 2.59 1.94 DIMENSIONAL TOLERANCES Outside Diameter Round Hollow Section Rectangular Hollow Section Outside Diameter As Per Table 1.5 mm or 1.5% Wall thickness Light -8… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 145000, 'length', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/rectangular_hollo.gif', 'Rectangular Hollow Section', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'Rectangular Hollow Section', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_597133536.png', 'Rectangular Hollow Section', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Reinforcement Steel';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Reinforcement Steel', 'hardware-tools', 'HIGH TENSILE Re-BARS/Ribbon BARS Nominal Diameter (mm) Nominal Weight Kg/mtr 5.3 0.21 6 0.223 8 0.395 10 0.617 12 0.888 14 1.21 16 1.58 20 2.5 25 3.95 32 6.31 40 9.86 Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 32000, 'bag', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/reinfornce_stl.jpg', 'Reinforcement Steel', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'Reinforcement Steel', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_597133536.png', 'Reinforcement Steel', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Round Bars';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Round Bars', 'hardware-tools', 'Round Bars Technical Specifications for Round Bars Nominal Diameter Nominal Weight Kg/mtr 5.5 0.1886 6 0.21 7 0.3 8 0.389 10 0.61 12 0.876 Related Products ALUMINIUM CHEQUERED PLATES Roofings Group Their advantage is they are rust free. Aluminium treadplate Category: Trading Items View Details Add to Cart Angles - Hot Rolled Roofings Group Applications of hot rolled angles include: Furniture Doors Racks &amp; Shelves Beds Bicycle Carriers Category: Trading Items View Details Add to Cart Angles -Cold Rolled Roofings Group Applications of cold rolled angles include: Fencing Bracing Furniture Automobile Bodies Category: Trading Items &nbsp; View Details Add to Cart BAMBOO TILE Roofings Group Bamboo tile is coated with Aluminium and Zinc thus withstanding all weather conditions. It is more heat resistant and resistant to rust. It can be utilised for residential and commercial purpose. View… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 62000, 'length', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/round_bar.gif', 'Round Bars', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'Round Bars', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_597133536.png', 'Round Bars', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Round Hollow Sections';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Round Hollow Sections', 'hardware-tools', 'Round Hollow Sections Technical Specifications for Round Hollow Sections Outside Diameter D (mm) Wall Thickness t (mm) Weight kg/mtr Sectional Area cm2 Moment of inertia 1x cm4 Radius of Gyration 1x cm Modulus of Section Z cm3 20 0.8 38 0.48 0.22 0.68 0.22 20 1 0.47 0.6 0.27 0.67 0.27 20 1.2 0.57 0.71 0.31 0.67 0.31 20 15 0.69 0.87 0.38 0.66 0.38 25 2 0.89 1.13 0.46 0.64 0.46 25 0.8 0.48 0.61 0.45 0.86 0.36 25 1 0.59 0.75 0.54 0.85 0.95 25 1.2 0.7 0.9 0.64 0.84 0.51 25 1.5 0.87 1.11 0.77 0.83 0.61 25 2 1.13 1.45 0.96 0.82 0.77 32 0.8 0.62 0.78 0.96 1.1 1.6 32 1 0.77 0.97 1.17 1.1 0.73 32 1.2 0.91 1.16 1.38 1.09 0.86 32 1.5 1.13 1.44 1.68 1.08 1.05 32 2 1.48 1.89 2.13 1.06 1.33 32 2.5 1.82 2.32 2.54 1.05 1.59 42 1.2 1.22 1.55 4.9 1.66 1.51 42 1.5 1.51 1.92 3.99 1.44 1.89 42 2 2.06 5.13 1.42 1.63 3.07 42 3 3.12 3.98 7.62 1.38 3.61 50 1.2 1.44 1.84 5.48 1.73 2.19 50 1.5 1.79 2.29 6.73 1.72… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 145000, 'length', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/round_hollo_sec.jpg', 'Round Hollow Sections', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'Round Hollow Sections', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_597133536.png', 'Round Hollow Sections', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'ALUMINIUM CHEQUERED PLATES';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'ALUMINIUM CHEQUERED PLATES', 'building-construction', 'Their advantage is they are rust free. Aluminium treadplate Category: Trading Items Additional information Available Sizes 8’ x 4’ x 1.5 mm 8’ x 4’ x 2.5 mm 8’ x 4’ x 2.0 mm 8’ x 4’ x 3.0 mm Technical Specifications for Chequered Plates Size in feet Width in mm Length in mm Thickness in mm Weight per PC (Kgs) 8''x4'' 1220 2440 2.9 68.97 8''x4'' 1220 2440 4 96.15 8''x4'' 1220 2440 6 142.86 Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 120000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'ALUMINIUM CHEQUERED PLATES', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-31539640.png', 'ALUMINIUM CHEQUERED PLATES', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-31539653.png', 'ALUMINIUM CHEQUERED PLATES', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Angles - Hot Rolled';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Angles - Hot Rolled', 'building-construction', 'Applications of cold rolled angles include: Furniture Doors Racks & Shelves Beds Bicycle Carriers Category: Trading Items Additional information Size 20*20*3MM*6M 25*25*2.5MM*6M 25*25*3MM*6M 30*30*2.5MM*6M 30*30*2MM*6M 30*30*3MM*6M 40*40*2.5MM*6M 40*40*3MM*6M 40*40*4MM*6M 40*40*5MM*6M 40*40*6MM*6M 40*40*2MM*6M 50*50*3MM*6M 50*50*4MM*6M 50*50*5MM*6M 50*50*6MM*6M 60*60*4MM*6M 60*60*5MM*6M 60*60*6MM*6M 70*70*6MM*6M 70*70*7MM*6M 75*75*6MM*6M 80*80*6MM*6M 80*80*8MM*6M 100*100*6MM*6M 100*100*8MM*6M 100*100*10MM*6M 100*100*12MM*6M Technical Specifications for HR Angles Size a x a (mm) Wall thickness t (mm) Radius (R) Sectional Area (a)cm2 Moment of inertia lx cm4 Moment of inertia ly cm4 Radius of Gyration ix cm Radius of Gyration iy cm Modulus of Section Zx Modulus of Section Zy 20 x 20 2 1.053 1.48 0.397 0.397 1.1 1.1 1.03 1.03 20 x 20 2.5 1.059 1.57 0.401 0.401 1.07 1.07 1.1 1.1 20 x 20 2.8… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 320000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_597133536.png', 'Angles - Hot Rolled', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-315384215.png', 'Angles - Hot Rolled', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-315384228.png', 'Angles - Hot Rolled', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Angles -Cold Rolled';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Angles -Cold Rolled', 'building-construction', 'Applications of cold rolled angles include: Fencing Bracing Furniture Automobile Bodies Category: Trading Items Additional information Size: 20*20*3MM*6M 25*25*2.5MM*6M 25*25*3MM*6M 30*30*2.5MM*6M 30*30*2MM*6M 30*30*3MM*6M 40*40*2.5MM*6M 40*40*3MM*6M 40*40*4MM*6M 40*40*5MM*6M 40*40*6MM*6M 40*40*2MM*6M 50*50*3MM*6M 50*50*4MM*6M 50*50*5MM*6M 50*50*6MM*6M 60*60*4MM*6M 60*60*5MM*6M 60*60*6MM*6M 70*70*6MM*6M 70*70*7MM*6M 75*75*6MM*6M 80*80*6MM*6M 80*80*8MM*6M 100*100*6MM*6M 100*100*8MM*6M 100*100*10MM*6M 100*100*12MM*6M Technical Specifications for CR Angles Size (mm) Wall Thickness t (mm) Radius (R) Sectional Area (a)cm2 Moment of Inertia 1x cm4 Moment of Inertia 1y cm4 Radius of Gyration ix cm Radius of Gyration iy cm Modulus of Section Zx Modulus of Section Zy 20 x 20 2 1.053 1.48 0.397 0.397 1.1 1.1 1.03 1.03 20 x 20 2.5 1.059 1.57 0.401 0.401 1.07 1.07 1.1 1.1 20 x 20 2.8 1.068 1.78… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 320000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_59784116.png', 'Angles -Cold Rolled', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-315384250.png', 'Angles -Cold Rolled', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-31538436.png', 'Angles -Cold Rolled', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Barbed Wire';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Barbed Wire', 'building-construction', 'High quality barbed wire is manufactured by winding the barbs around the wires with a constant pitch and are stranded together. The wire used is Zinc coated (Galvanized Wire). Strength and dimensions conform to JIS 3533 Categories: Galvanised wire products, Wire products Additional information Size G13*20KGS G13*25KGS G14*20KGS G14*25KGS G16*20KGS G16*25KGS Description Weight per Roll in kg Gauge Barb Spacing Barb Gauge Barbed Wire 25 & 20 16 4" 16 Barbed Wire 25 & 20 16 4" 16 Barbed Wire 20 13 4" 13 Barbed Wire 20 14 4" 13 Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 8500, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_59713356.png', 'Barbed Wire', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-315313423.png', 'Barbed Wire', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-315313433.png', 'Barbed Wire', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'BINDING WIRE';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'BINDING WIRE', 'building-construction', 'Applications include: Tying Bars Fencing Agriculture Horticulture Packaging Category: Wire products Additional information Wire Diameter (mm): 1.8, 2.0, 3.0 Weight/ Roll : 25 Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 8500, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_596211549.png', 'BINDING WIRE', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3152211640.png', 'BINDING WIRE', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'BINDING WIRE', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'BORE HOLE CASINGS & SCREENING PIPES';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'BORE HOLE CASINGS & SCREENING PIPES', 'building-construction', 'Roofings Polypipes manufactures Bore Hole Casings and Screening Pipes which are used in bore hole construction. These bore hole casings and screening pipes are a better substitute for iron pipes by providing longer life, easy installation and require no welding. These are ideal for domestic, irrigational, industrial, public and mining wells. They are produced according to DIN4925. Categories: Poly Pipes, PVC - Poly-vinyl Chloride Additional information Outside Diameter 4 Inch 5 Inch 6 Inch Length 2.8m 3m Color Blue Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 38000, 'length', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_594232336.png', 'BORE HOLE CASINGS & SCREENING PIPES', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-315023245.png', 'BORE HOLE CASINGS & SCREENING PIPES', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'BORE HOLE CASINGS & SCREENING PIPES', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'BOTTLE SECTIONS';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'BOTTLE SECTIONS', 'building-construction', 'Applications include: Doors frames Billboards Window Frames Category: Open Profiles Additional information: Size 94*34*1.2MM*6M Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 16000, 'ream', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_596161440.png', 'BOTTLE SECTIONS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3152161514.png', 'BOTTLE SECTIONS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'BOTTLE SECTIONS', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'BULL NOSE';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'BULL NOSE', 'building-construction', 'n order for Roofings to manufacture the correct specification of Bull Nose / Crimped sheets, the customer has to furnish a detailed drawing including the radius and length of the sheets. At present Super V and Super Eco are the only possible profiles for crimping. Applications include canopies for commercial vehicles and artistic design for entertainment centers as well as great finishing on hotels, malls, factories and restaurants. It is also used on ordinary houses, on top of the windows to prevent direct sunlight and rain from entering the house and is used on walkways, car porches and open bar shelters. Categories: AZED Sheets, Sheets Additional information Texture: Glossy (Smooth Finish) Gauge (Thickness) 24 (0.50mm) 26 (0.40mm) 28 (0.32mm) 30 (0.25mm) Color Binzare Yellow Blue, Brick Red Dark Green Harvest Gold Light Green Navy Blue Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 120000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_596112135.png', 'BULL NOSE', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3152112212.png', 'BULL NOSE', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3152112223.png', 'BULL NOSE', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'BVALLEYS';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'BVALLEYS', 'building-construction', 'Roofings offers accessories like gutters, valleys, ridges and flashings all from galvanized and pre-painted material. Categories: AZED Sheets, Sheets Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 48000, 'sheet', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_596121614.png', 'BVALLEYS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3152121644.png', 'BVALLEYS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3152121655.png', 'BVALLEYS', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'C-CHANNELS';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'C-CHANNELS', 'building-construction', 'Applications include: Roller Shutters Machine Base Sliding Windows Sliding Doors Vehicle Bodies Partitition Panels Furniture Can be used as Purlins Industrial Cable Rails Category: Trading Items Additional information Size 76*38*7.1KGM*6M 80*45*8.3KGM*6M 100*50*10.1KGM*6M 120*55*12.059KGM*6M 125*65*12.95KGM*6M 125*65*13.4KGM*6M 140*60*14KGM*6M 140*60*16KGM*6M 150*75*18.6KGM*6M 152*76*17.9KGM*6M Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 145000, 'length', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_59782747.png', 'C-CHANNELS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-315382816.png', 'C-CHANNELS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-315382828.png', 'C-CHANNELS', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'CHAIN LINK';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'CHAIN LINK', 'building-construction', 'Roofings Ltd has galvanised chain link of premium quality and is available in: Heights from 4 ft up to 12ft and in Gauge 10, 12.5, 13, 14 with a standard length of 18 meters. Roofings Ltd has galvanised chain link of premium quality, rust/corrosion free. Apart from the standard sizes, chain link can be manufactured to customer specific heights. Applications include: Fencing Internal Partitions e.g. in Warehouses Categories: Galvanised wire products, Wire products Additional information Thickness: g10, g12.5, g13, g14 Height : 6, 7 Pitch Size: 50×50, 65×65, 75×75 Gauge : 10, 12.5, 13, 14 Length : 18 Chain Link Technical Specification Mesh size in mm Height of Roll in feet Length of Roll in mtrs Gauge Weight per Roll in Kgs 50 x 50 6ft 18 10 80 50 x 50 7ft 18 10 94 70 x 70 6ft 18 10 64.5 70 x 70 7ft 18 10 76 50 x 50 6ft 18 12 60 50 x 50 7ft 18 12 70 75 x 75 6ft 18 12 40 75 x 75 7ft 18 12… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 250000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_596204510.png', 'CHAIN LINK', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3152204547.png', 'CHAIN LINK', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3152204559.png', 'CHAIN LINK', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Channels-Cold Rolled';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Channels-Cold Rolled', 'building-construction', 'Technical Specifications for Channels-Cold Rolled Size (mm) Thickness (t) Weight in Kg/mtr Sectional area cm2 Moment of inertia 1x Moment of inertia 1y Section Modulus Zx Section Modulus Zy Radius of Gyration lx Radius of Gyration ly 25 x 25 1.5 0.9 1.15 1.25 0.79 1 0.48 1.05 0.82 25 x 25 2 1.11 1.41 1.5 0.91 1.18 0.59 1.03 0.81 40 x 25 1.5 0.99 1.26 3.41 0.83 1.71 0.48 1.62 0.8 40 x 25 2 1.29 1.64 4.39 1.08 2.2 0.62 1.6 0.79 40 x 40 1.5 1.34 1.71 5.08 3.01 2.54 1.15 1.7 1.31 Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 120000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/chan_cold1.jpg', 'Channels-Cold Rolled', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'Channels-Cold Rolled', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_597133536.png', 'Channels-Cold Rolled', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'CONDUITS';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'CONDUITS', 'building-construction', 'Roofings Polypipes manufactures conduit pipes from virgin resin which makes them fire resistant in case of an electrical short circuit. These conduits are highly flexible and durable. Conduits are used to protect electrical cables used in residential, commercial and industrial wiring. These pipes conform to UNBA standard US264-2. Categories: Poly Pipes, PVC - Poly-vinyl Chloride Additional information Color: Black Dark Grey Length 4m 6m Outside Diameter 20mm 25mm 32mm 40mm 50mm Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 38000, 'length', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_597122737.png', 'CONDUITS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-315312285.png', 'CONDUITS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'CONDUITS', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'CRC PLATES';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'CRC PLATES', 'building-construction', 'These plates are made from hot rolled coils (HRC) of the highest quality that conforms to international standards and quality parameters. (ST 37.2 as per DN Spec. 17100 and JIS 3193 & 3131). The standard is 8 ft x 4 ft, however for special orders Roofings can cut any length between 0.6 m up to 8 m in bulk. They come in 8 x 4 ft and in stock 0.7 mm, 0.8 mm, 1.0 mm, 1.2 mm, 2.0 mm. The uses are: Control panels Cabinets Wheelbarrows Roller shutters Drums of oil Category: Mild steel Hot & cold Plates Additional information Thickness (mm) - Weight/pc (kg) 0.80 mm – 18.73 kg, 1.00 mm – 23.41 kg 1.20 mm – 28.10 kg, 1.50 mm – 35.12 kg 2.00 mm – 46.83 kg, 3.00 mm – 65.56 kg 4.00 mm – 93.66 kg, 6.00 mm – 140.48 kg 8.00 mm – 187.31 kg, 10.00 mm – 234.14 kg 12.00 mm – 280.97 kg, 15.00 mm – 351.21 kg 20.00 mm – 468.00 kg, 25.00 mm – 585.00 kg Size (ft): 8×4 Length (mm): 2440 Width (mm): 1220 Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 250000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_596164133.png', 'CRC PLATES', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3152164212.png', 'CRC PLATES', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3152164225.png', 'CRC PLATES', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'CRIMPED SHEETS(Bull Nose)';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'CRIMPED SHEETS(Bull Nose)', 'building-construction', 'CRIMPED SHEETS (Bull Nose)CAN BE FORMED IN BOTH GALVANISED AND PRE-PAINTED IRON SHEETS WITH SUPER V AND SUPER ECO PROFILES ONLY Thickness of the sheets should be between 0.27 mm - 0.60 mm Length can range between 2mtrs - 4 mtrs Range of radious - 250mm-600mm We recommend a minimum of 400 mm or more. ADVANTAGES Streamlined appearance from the roof to the cladding Improve the aesthetics of the structures APPLICATION Shopping Malls ; Hospitals; Warehouses ; Hotels; Stadiums; Factories Sheets confirm to the following standards Galvanised sheet -JIS 3302/SGCC; pre-painted sheets - JIS 3312/SGCC Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 48000, 'sheet', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/bull_nose1.jpg', 'CRIMPED SHEETS(Bull Nose)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'CRIMPED SHEETS(Bull Nose)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_597133536.png', 'CRIMPED SHEETS(Bull Nose)', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Door & Window Profiles';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Door & Window Profiles', 'building-construction', 'Door Frame Dmm W1 (mm) W2 (mm) t (mm) h (mm) L (mm) 135 45 35 1.2 46 13 135 45 35 1.6 46 13 135 45 35 2 46 13 Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 120000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/omega-profile.gif', 'Door & Window Profiles', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'Door & Window Profiles', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_597133536.png', 'Door & Window Profiles', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'DOOR FRAMES';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'DOOR FRAMES', 'building-construction', 'Applications include: Door Frames Window Frames Single Door Frames This new profile eliminates the extra free recess in the commonly used door frame thus saving on the material used to manufacture it by 19%, in turn lowering the cost of the final product. Category: Open Profiles Additional information Size 135*45*1.2MM*5.8M 135*45*1.2MM*6M 135*45*1.5MM*5.8 135*45*1.5MM*6M 135*451MM*5.8M 135*45*1MM*6M Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 120000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_59616517.png', 'DOOR FRAMES', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-315216556.png', 'DOOR FRAMES', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-315216621.png', 'DOOR FRAMES', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'DOWN PIPES';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'DOWN PIPES', 'building-construction', 'Roofings Polypipes manufactures high quality down pipes which are used to drain water from gutter. Categories: Poly Pipes, PVC - Poly-vinyl Chloride Additional information: Outside Diameter: 80mm Gauge (Thickness): 1.5mm Length: 6m Color : White Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 38000, 'length', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_59684153.png', 'DOWN PIPES', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-315284228.png', 'DOWN PIPES', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'DOWN PIPES', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'DRAINAGE PIPES';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'DRAINAGE PIPES', 'building-construction', 'Roofings Polypipes manufactures drainage pipes from virgin material which are long lasting (up to 50 years) and easily match with the available drainage fittings. These drainage pipes are made according to the British standard BS5255. They are used for draining non-pressurised water and can also be used as vent pipes on VIP pit latrines. Categories: Poly Pipes, PVC - Poly-vinyl Chloride Additional information Drainage: 32 mm to 200 mm Color : Light Grey Length : 6m Gauge (Thickness) : HG, LG, LLG, MG Outside Diameter :110mm, 160mm, 32mm, 36mm, 43mm, 55mm, 63mm, 82mm Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 38000, 'length', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_59712193.png', 'DRAINAGE PIPES', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3153121926.png', 'DRAINAGE PIPES', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3153121939.png', 'DRAINAGE PIPES', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'EMBOSSED PLATES';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'EMBOSSED PLATES', 'building-construction', 'Category: Trading Items Additional information Thickness (mm): 0.6, 0.7, 0.8, 1, 1.2, 1.5, 2 Width (mm): 1220 Length: 2440 Weight per pc: 14.14, 16.49, 18.85, 23.56, 28.39, 35.48, 46.74 Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 120000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_59617323.png', 'EMBOSSED PLATES', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3152173232.png', 'EMBOSSED PLATES', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3152173246.png', 'EMBOSSED PLATES', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'FACIA BOARDS';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'FACIA BOARDS', 'building-construction', 'Applications include: Window Frames Roof Facia Category: Open Profiles Additional information Size AxB 150×30 – Thickness (1.2 mm) – Weight/pc (13 kg) 150×30 – Thickness (1.5 mm) – Weight/pc (15.5 kg) 190×30 – Thickness (1.2 mm) – Weight/pc (14.3 kg) 190×30 – Thickness (1.5 mm) – Weight/pc (17.3 kg) 200×30 – Thickness (1.2 mm) – Weight/pc (16.0 kg) 200×30 – Thickness (1.5 mm) – Weight/pc (19.5 kg) Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 16000, 'ream', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_596123616.png', 'FACIA BOARDS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3152123646.png', 'FACIA BOARDS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-315212372.png', 'FACIA BOARDS', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'FILLER BLOCKS';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'FILLER BLOCKS', 'building-construction', 'Used to fill the gaps between the ridge and the roofing sheet. Available in Super V and Super Eco profiles. Categories: Accessories, Trading Items Additional information Type: FILLER BLOCKS SUPER ECO FILLER BLOCKS SUPER V(BLACK) FILLER BLOCKS SUPER V (BLACK & WHITE) FILLER BLOCKS SUPER VI(BLACK) Filler Blocks Used to fill the gap between the ridge and the roofing Sheet. Available in Super V and Super Eco Profiles Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 48000, 'sheet', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_597111218.png', 'FILLER BLOCKS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3153111246.png', 'FILLER BLOCKS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3153111257.png', 'FILLER BLOCKS', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'GALVANISED WIRE';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'GALVANISED WIRE', 'building-construction', 'Applications include: Fencing Use on horticultural farm Suspended ceilings Bicycle spokes cable industry Bucket handles Staples Hangers Binding Categories: Galvanised wire products, Wire products Additional information Size G10*25KGS G12.5*25KGS Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 8500, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_596203037.png', 'GALVANISED WIRE', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3152203117.png', 'GALVANISED WIRE', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3152203129.png', 'GALVANISED WIRE', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'GUTTER FITTINGS';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'GUTTER FITTINGS', 'building-construction', 'We have very good gutter fittings. Categories: Accessories, Trading Items Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 120000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_59419848.png', 'GUTTER FITTINGS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-315019914.png', 'GUTTER FITTINGS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'GUTTER FITTINGS', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'GUTTERS';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'GUTTERS', 'building-construction', 'Roofings manufactures rainwater gutters which are flexible, durable and are resistant to the vagaries of weather. The rainwater gutters are used for harvesting and collection of rainwater. They are made from virgin resin. Categories: Poly Pipes, PVC - Poly-vinyl Chloride Additional information Color: White Length: 5.8m Outside Diameter : 127mm Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 120000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_597115426.png', 'GUTTERS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3153115445.png', 'GUTTERS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3153115456.png', 'GUTTERS', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'HDPE FITTINGS';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'HDPE FITTINGS', 'building-construction', 'Categories: Accessories, Trading Items Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 38000, 'length', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_59423852.png', 'HDPE FITTINGS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-315023935.png', 'HDPE FITTINGS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'HDPE FITTINGS', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'HDPE PIPES';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'HDPE PIPES', 'building-construction', 'Roofings Polypipes manufactures HDPE pipes from high quality material grade PE100 that insures excellent product flexibility and strength. These pipes cover long lengths, are easy to install, are resistant to both corrosion and abrasion, are light weight and can last up to 50 years. Roofings HDPE pipes are produced according to DIN8074 and US482:2002. They are used for high pressure water supply, long distance water transportation and also can be used for petroleum transportation. Categories: High Density Polyethylene, Poly Pipes Additional information: Color Black with blue stripes Black with green stripes Black with red stripes Black with yellow stripes Length 100m, 12m, 2.8m, 3m, 4m, 5.8m, 50m, 6m, 9m Pressure Rating (PN) PN10 PN16 PN20 PN25 PN6 Outside Diameter 110mm, 125mm, 140mm, 160mm, 180mm, 200mm, 20mm, 225mm, 250mm, 25mm, 32mm, 40mm, 50mm, 63mm, 75mm, 90mm Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 38000, 'length', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_597124836.png', 'HDPE PIPES', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-315312492.png', 'HDPE PIPES', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'HDPE PIPES', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'I-BEAMS';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'I-BEAMS', 'building-construction', 'Mainly used for structural engineering. Category: Trading Items Additional information Desginations: IPE 80, IPE 100, IPE 120, IPE 140, IPE 160, IPE 180, IPE 200, IPE 220, IPE 240, IPE 270, IPE 330, IPE 360, IPE 320, IPE 400, IPE 450 Dimensions (Height) in mm : 80, 100, 120, 140, 160, 180, 200, 220, 240, 270, 330, 360, 320, 400, 450 Area (mm2: 764, 1030, 1320, 1640, 2010, 2390, 2850, 3340, 3910, 4590, 5380, 6260, 7270, 8450, 9880 Weight (kg) : 6.0, 8.1, 10.4, 12.9, 15.8, 18.8, 22.4, 26.2, 30.7, 36.1, 42.2, 49.1, 57.1, 66.3, 77.6 Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 120000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_59781646.png', 'I-BEAMS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-315381712.png', 'I-BEAMS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-315381725.png', 'I-BEAMS', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'J-BOLTS';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'J-BOLTS', 'building-construction', 'The most commonly used accessory to fix Roofing Sheets. Available sizes are: 110 mm 130 mm 150 mm Categories: Accessories, Trading Items Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 48000, 'sheet', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_59711227.png', 'J-BOLTS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-315311255.png', 'J-BOLTS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'J-BOLTS', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'LOUVERS';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'LOUVERS', 'building-construction', 'Category: Open Profiles Additional information Color: Navy Blue Super Green Tile Red Sizes LOUVERS MS 1.22M*75MM*1.0MM LOUVERS MS 1.22M*75MM*1.2MM Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 55000, 'sheet', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_594222427.png', 'LOUVERS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-315022257.png', 'LOUVERS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'LOUVERS', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'MILD STEEL EXPANDED METAL';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'MILD STEEL EXPANDED METAL', 'building-construction', 'Roofings AZED expanded metal lath is manufactured using high quality AZED sheets with exact gauges ensuring outstanding tensile strength against stress at any angle. Applications: Expanded metal is used for concrete and ceiling reinforcement. Applications include: Residential Slabs Concrete Bridge Columns Soil Conditioning Fabrication Work Retaining Walls Precast Structures Industrial Slabs Fencing For construction works like concrete ceilings, aggregate sieving. Agriculture, for making pig sty and chicken pens, rabbit pens. Industrial application such as machine guards, vehicle bodies. Domestic application such as trays for utensils, ventilations, restaurant chairs. Category: Mild steel Hot & cold Plates Additional information Size 8*4*1.2MM(PTICH1*2) 8*4*1.2MM(PTICH1/2*1) Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 48000, 'sheet', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_596162547.png', 'MILD STEEL EXPANDED METAL', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3152162619.png', 'MILD STEEL EXPANDED METAL', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3152162635.png', 'MILD STEEL EXPANDED METAL', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'MILD STEEL PLATES CHEQUERED';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'MILD STEEL PLATES CHEQUERED', 'building-construction', 'Sizes 8*4*1.6MM 8*4*2.8MM 8*4*2MM 8*4*3MM 8*4*4MM 8*4*5MM 8*4*6MM Category: Mild steel Hot & cold Plates Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 120000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_594201922.png', 'MILD STEEL PLATES CHEQUERED', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3150201956.png', 'MILD STEEL PLATES CHEQUERED', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'MILD STEEL PLATES CHEQUERED', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'MS Flat Bars';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'MS Flat Bars', 'building-construction', 'We have Flat Bars in all services Techical Specification for Flat Bars Size (a) mm Wall Thickness t (mm) Weight in Kg/mtr Weight in kg (6mtr Length) 20 3.5 0.472 2.83 20 4 0.628 3.768 20 6 0.942 5.652 25 3 0.589 3.534 40 3 0.942 5.652 40 4 1.256 7.536 40 6 1.884 11.304 50 3.5 1.374 8.24 50 4 1.57 9.42 50 6 2.355 14.13 Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 62000, 'length', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/flat-bars.gif', 'MS Flat Bars', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'MS Flat Bars', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_597133536.png', 'MS Flat Bars', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'ORDINARY CORRUGATED';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'ORDINARY CORRUGATED', 'building-construction', 'Ordinary Round Corrugation is used for roofing domestic and industrial structures. Another application for this simple but reliable sheet is the fabrication of water tanks. They are available in AZED plain and AZED coloured. Categories: AZED Sheets, Sheets Additional information: Color AZED white Binzare Yellow Blue Brick Red Dark Green Light Green Gauge G32 G30 G28 G26 Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 48000, 'sheet', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_59610531.png', 'ORDINARY CORRUGATED', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3152105335.png', 'ORDINARY CORRUGATED', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3152105351.png', 'ORDINARY CORRUGATED', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'PLAIN SHEETS';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'PLAIN SHEETS', 'building-construction', 'Plain sheets do not go through a forming process and are smooth in finishing and made of the highest quality steel. Plain sheets are used as an undercover material for Clay tile roofs as a better option to using polythene materials. This also makes it cheaper and long lasting. Plain sheets are also used to make suit cases, water filters, ridges, valleys, down pipes, watering cans, etc. Categories: AZED Sheets, Sheets Additional information: Gauge (Thickness) 24 (0.50mm) 26 (0.40mm) 28 (0.32mm) 30 (0.25mm) 32 (0.20mm) Color Blue Brick Red Dark Green Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 55000, 'sheet', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_596113630.png', 'PLAIN SHEETS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3152113658.png', 'PLAIN SHEETS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3152113710.png', 'PLAIN SHEETS', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'PLUMBING PIPES';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'PLUMBING PIPES', 'building-construction', 'Roofings Polypipes manufactures plumbing pipes for cold water transportation. These pipes are durable, easy to install and their threads easily match with GI fittings. These pipes are produced as per the American standard ASTM1785-76. Categories: Poly Pipes, PVC - Poly-vinyl Chloride Additional information Color: Blue Length : 6m Outside Diameter 1 1/2 Inch 1 1/4 Inch 1 Inch 1/2 Inch 2 Inch 3/4 Inch Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 38000, 'length', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_594233141.png', 'PLUMBING PIPES', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3150233219.png', 'PLUMBING PIPES', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'PLUMBING PIPES', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'POLY PROPYLENE RANDOM PIPES';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'POLY PROPYLENE RANDOM PIPES', 'building-construction', 'Roofings Polypipes manufactures Poly Propylene Random Pipes which are used for both hot and cold water transportation. These PPR pipes provide temperature resistance up to 800 degrees celsius. Has no reaction with salts and acids, has excellent heat preservation and energy saving qualities. PPR pipes can be used in industries for movement of fluids, excellent choice in compressed air supply and can also be used in agriculture and swimming pool construction. Categories: Poly Pipes, Poly propylene Random Additional information Length: 20 mm to 250 mm Color: Green Length: 4m Outside Diameter 20mm 25mm 32mm 40mm 50mm Pressure Rating (PN) PN10 PN16 PN20 PN25 Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 38000, 'length', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_59712415.png', 'POLY PROPYLENE RANDOM PIPES', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3153124130.png', 'POLY PROPYLENE RANDOM PIPES', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'POLY PROPYLENE RANDOM PIPES', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'PPR FITTINGS';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'PPR FITTINGS', 'building-construction', 'Categories: Accessories, Trading Items Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 120000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_594224958.png', 'PPR FITTINGS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-315022528.png', 'PPR FITTINGS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'PPR FITTINGS', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'PRESSURE PIPES';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'PRESSURE PIPES', 'building-construction', 'Roofings Polypipes manufactures pressure pipes from diameter 20mm-450mm with pressure ratings of PN 2.5, 4, 6, 10 and 16. Pressure pipes are normally used for water transportation and distribution over long distances. They are manufactured according to the highest quality standards DIN8062 and US264:2001. Our pressure pipes are tested in our fully equipped laboratory to ensure that no failure results in the field. Categories: Poly Pipes, PVC - Poly-vinyl Chloride Additional information Outside Diameter 110mm, 125mm, 140mm, 160mm, 180mm, 200mm, 20mm, 225mm, 250mm, 25mm, 280mm, 315mm, 32mm, 355mm, 400mm, 40mm, 450mm, 50mm, 63mm, 75mm, 90mm Length: 6m Color : Blue Light Grey Pressure Rating (PN) PN10 PN16 PN2.5 PN4 PN6 Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 38000, 'length', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_597113252.png', 'PRESSURE PIPES', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3153113339.png', 'PRESSURE PIPES', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3153113418.png', 'PRESSURE PIPES', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'PVC FASCIA BOARD';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'PVC FASCIA BOARD', 'building-construction', 'Lighter, Recyclable, UV Protected and easy to install. Available in white, 8mm thick and 220mm wide Category: Poly Pipes Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 38000, 'length', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_594121316.png', 'PVC FASCIA BOARD', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-315012153.png', 'PVC FASCIA BOARD', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'PVC FASCIA BOARD', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'PVC FITTINGS';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'PVC FITTINGS', 'building-construction', 'Categories: Accessories, Trading Items Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 38000, 'length', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_59423161.png', 'PVC FITTINGS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3150231628.png', 'PVC FITTINGS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'PVC FITTINGS', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'PVC GUTTER FITTINGS';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'PVC GUTTER FITTINGS', 'building-construction', 'Categories: Accessories, Trading Items Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 38000, 'length', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_59422378.png', 'PVC GUTTER FITTINGS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3150223739.png', 'PVC GUTTER FITTINGS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'PVC GUTTER FITTINGS', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'RAZOR WIRE';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'RAZOR WIRE', 'building-construction', 'Roofings Limited introduced a new product; non-electrified razor wire for security and safety purposes. Roofings is the sole manufacturer of this product in Uganda, made of the highest quality galvanized wire. and and aluminium zinc plums. The Ultra Barb Profile is: Sharper Difficult to cut Rigid The new Ultra Barb profile incorporates: A wide central steel band that provides additional rigidity to the coils Blades which are more substantial and effective 30 mm tip-to-tip and 42 mm Centre-to-Centre Improved product design means less spirals are required for the same performance Roofings can manufacture from 350mm up to 980mm diameter Applications include: security barriers fencing. Categories: Galvanised wire products, Wire products Additional information Diameter (mm): 400, 450, 700 Stretchable Length (m): 10, 8, 7 Number of loops - G24 blade: 54, 44, 48 Number of loops - G26 blade:… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 8500, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_59620242.png', 'RAZOR WIRE', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-315220315.png', 'RAZOR WIRE', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-315220328.png', 'RAZOR WIRE', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'RECTUNGULAR TUBES';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'RECTUNGULAR TUBES', 'building-construction', 'Roofings Ltd tubes are produced by application of tensile forces on steel skelp with the help of high frequency induction welding conforming to JIS G 3444:1993 and US EAS 134:2013. Roofings Ltd is currently equipped with four State – of – the – Art tube mills having installed production capacity of 4,200 metric tonnes per month. has recently installed its fourth tube mill allowing it to produce tubes ranging from 16 mm – 42 mm round and a thickeness ranging from 0.8 mm to 2 mm with the option to produce to customer required length of 12 meters maximum. Finished tubes are strapped in bundles of square, rectangular and hexagonal shapes for stability when stacking or loading onto various modes of transportation. Category: Hollow sections Applications for tubes: Furniture fabrication, chairs, beds and tables, for both domestic and industrial use. Fabrication of Wheelbarrows. Burglar proof… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 180000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_596172255.png', 'RECTUNGULAR TUBES', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3152172322.png', 'RECTUNGULAR TUBES', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3152172334.png', 'RECTUNGULAR TUBES', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'RIDGES';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'RIDGES', 'building-construction', 'Roofings offers accessories like gutters, valleys, ridges and flashings all from galvanized and pre-painted material. Categories: AZED Sheets, Sheets Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 48000, 'sheet', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_59612345.png', 'RIDGES', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-315212415.png', 'RIDGES', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-315212430.png', 'RIDGES', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'ROOFING NAILS';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'ROOFING NAILS', 'building-construction', 'Also known as Umbrella nails, they are used for fixing Roofing Sheet onto timber trusses. Categories: Accessories, Trading Items Additional information Bag Size: 25kg Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 48000, 'sheet', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_597102917.png', 'ROOFING NAILS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3153102954.png', 'ROOFING NAILS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'ROOFING NAILS', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Roofing Sheets - Super Eco';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Roofing Sheets - Super Eco', 'building-construction', 'The Roofings Super Eco is made from pre-painted Aluminum Zinc iron sheets and combines increased longevity with low maintenance costs. Super Eco sheets are suitable for both residential and commercial purposes and provide a classic cladding for industrial structures such as factories, warehouses, malls and hotels. Categories: AZED Sheets, Sheets Additional information Texture Wrinkle (Rough Finish) Color Binzare Yellow Black, Blue Brick Red Chocolate Brown Dark Green Harvest Gold Light Green Tile Red Gauge G30 G28 G26 G24 G22 Roofing Sheets - Super Eco Specifications of Super Eco Gauges Overall Width Cover Width (mm) 30 869 814 28 869 814 26 869 814 24 869 814 22 869 814 ADVANTAGES. Galvanised & PPG Sheets Conform to the following standards 1.Prepainted sheets are first galvanised and then painted 2.Our gauges are exact. 3.savings on wastage due to overlapping and with the cut to length… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 48000, 'sheet', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_596103743.png', 'Roofing Sheets - Super Eco', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3152103815.png', 'Roofing Sheets - Super Eco', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3152103828.png', 'Roofing Sheets - Super Eco', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Roofing Sheets - Super V';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Roofing Sheets - Super V', 'building-construction', 'The Roofings Super V and Super VI Roof Sheets are suitable for commercial structures such as shopping malls, factories and general industrial buildings. They can further be utilized for the construction of structures such as canopies for fuel stations, entertainment centers, bodies for commercial vehicles and composite flooring. The difference between Super V and Super VI is that the net effective coverage of Super V is 700 mm compared to a wider coverage of 830 mm for Super VI. Categories: AZED Sheets, Sheets Additional information: Color Black Blue Brick Red Dark Green Light Green Navy Blue Swan Cream White Gauge G26*0.40MM G24*0.50MM G22*0.60MM Specification of Super V Gauges Overall Width Cover Width (mm) 30 784 700 28 784 700 26 784 700 24 784 700 22 784 700 ADVANTAGES. Galvanised & PPG Sheets Conform to the following standards 1.Prepainted sheets are first galvanised and then… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 48000, 'sheet', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5969649.png', 'Roofing Sheets - Super V', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-31529528.png', 'Roofing Sheets - Super V', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-31529538.png', 'Roofing Sheets - Super V', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Roofing Sheets Round Corrugation';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Roofing Sheets Round Corrugation', 'building-construction', 'Specifications of Round Corrugation Gauges (mm) Overall Width Cover Width (mm) 34 875 762 32 875 762 30 875 762 28 875 762 26 875 762 24 875 762 22 875 762 NOTE : Plain galvanised and prepainted sheets are also available without profiling in the above mentioned thickness/gauges ADVANTAGES. Galvanised & PPG Sheets Conform to the following standards 1. Width before corrugation 1000mm- 11 corrugations - with 76 mm pitch 2. Width before corrugation 914mm -10 corrugations- with 76 mm pitch. 3 Regular sprangled , bright uniform zinc coating.4. Marking is done in both gauges and mm 1. US301 : 1993 2. JIS 3312 - PPG JIS 3316 - Galvanising PLUS * Our galvanised coils are annealed to facilitate roll forming and for increasing galvanisingn longevity. * Coating class Z12 - Z18 - Z21 (depending upon the gauge/thickness) Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 48000, 'sheet', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/round_corr.gif', 'Roofing Sheets Round Corrugation', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'Roofing Sheets Round Corrugation', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_597133536.png', 'Roofing Sheets Round Corrugation', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'ROOFINGS TMX 500 C';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'ROOFINGS TMX 500 C', 'building-construction', 'Roofings TMX 500 C steel is a high-quality version of TMT steel bar so they certainly have inevitable advantages over TMT Bars in terms of excellent characteristics, such as weldability, durability, thermal stability, ductility, and tensility, etc. They not only meet international standards but also are economical and cost-efficient. Category: Reinforcement Steel Rebars Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 62000, 'length', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_594115252.png', 'ROOFINGS TMX 500 C', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3150115624.png', 'ROOFINGS TMX 500 C', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'ROOFINGS TMX 500 C', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'ROUND TUBES';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'ROUND TUBES', 'building-construction', 'Roofings Ltd tubes are produced by application of tensile forces on steel skelp with the help of high frequency induction welding conforming to JIS G 3444:1993 and US EAS 134:2013. Roofings Ltd is currently equipped with four State – of – the – Art tube mills having installed production capacity of 4,200 metric tonnes per month. has recently installed its fourth tube mill allowing it to produce tubes ranging from 16 mm – 42 mm round and a thickeness ranging from 0.8 mm to 2 mm with the option to produce to customer required length of 12 meters maximum. Finished tubes are strapped in bundles of square, rectangular and hexagonal shapes for stability when stacking or loading onto various modes of transportation. Category: Hollow sections Applications for tubes: Furniture fabrication, chairs, beds and tables, for both domestic and industrial use. Fabrication of Wheelbarrows. Burglar proof… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 180000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_596171212.png', 'ROUND TUBES', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3152171244.png', 'ROUND TUBES', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3152171256.png', 'ROUND TUBES', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'RUBBER WASHERS';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'RUBBER WASHERS', 'building-construction', 'They are used together with Umbrella nails when fixing Roofing Sheets onto timber trusses. Categories: Accessories, Trading Items Additional information Color Black Brick Red Dark Green Harvest Gold Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 48000, 'sheet', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979582.png', 'RUBBER WASHERS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-315395826.png', 'RUBBER WASHERS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-315395838.png', 'RUBBER WASHERS', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'SELF TAPPING SCREWS';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'SELF TAPPING SCREWS', 'building-construction', 'A cost effective way of fixing roofing sheets onto the trusses. Available in the following sizes: • 16 mm × 22 mm • 16 mm × 25 mm Categories: Accessories, Trading Items Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 48000, 'sheet', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_59794156.png', 'SELF TAPPING SCREWS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-315394228.png', 'SELF TAPPING SCREWS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-315394245.png', 'SELF TAPPING SCREWS', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'SQUARE TUBES';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'SQUARE TUBES', 'building-construction', 'Roofings Ltd tubes are produced by application of tensile forces on steel skelp with the help of high frequency induction welding conforming to JIS G 3444:1993 and US EAS 134:2013. Roofings Ltd is currently equipped with four State – of – the – Art tube mills having installed production capacity of 4,200 metric tonnes per month. has recently installed its fourth tube mill allowing it to produce tubes ranging from 16 mm – 42 mm round and a thickeness ranging from 0.8 mm to 2 mm with the option to produce to customer required length of 12 meters maximum. Finished tubes are strapped in bundles of square, rectangular and hexagonal shapes for stability when stacking or loading onto various modes of transportation. Category: Hollow sections Applications for tubes: Furniture fabrication, chairs, beds and tables, for both domestic and industrial use. Fabrication of Wheelbarrows. Burglar proof… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 180000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5961706.png', 'SQUARE TUBES', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-315217047.png', 'SQUARE TUBES', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-31521710.png', 'SQUARE TUBES', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'SUPER ECO PLUS';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'SUPER ECO PLUS', 'building-construction', 'Super eco plus stands out as the first wider profile on the east African market with a cover width of 1045mm thus additional of 23% cover compared to super eco cover. Due to their wider cover less sheets are required to be erected thus time & labour cost saving. Description Super eco plus offers client excellent drainage system due to trough depth and width pitch. It has an inter small trough that enhances its strength and increases its spanning capacity thus less purlins cost. The profile provides complete leak proof solution due to capillary curve feature and it is highly aesthetically appealing, as well as highly ideal for budget sensitive projects due to their wider benefits. Categories: AZED Sheets, Sheets Additional information Material Width/MM: 1220 Overall width/MM: 1110 Cover width/MM: 1045 +/- 8 Pitch/MM : 209 Small grooves/MM : 2 spaced 35mm No. of Troughs: 5 Depth of… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 120000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_59421290.png', 'SUPER ECO PLUS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3150212955.png', 'SUPER ECO PLUS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'SUPER ECO PLUS', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'SUPER VI';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'SUPER VI', 'building-construction', 'The Roofings Super V and Super VI Roof Sheets are suitable for commercial structures such as shopping malls, factories and general industrial buildings. They can further be utilized for the construction of structures such as canopies for fuel stations, entertainment centers, bodies for commercial vehicles and composite flooring. The difference between Super V and Super VI is that the net effective coverage of Super V is 700 mm compared to a wider coverage of 830 mm for Super VI. Categories: AZED Sheets, Sheets Additional information Color: Blue Brick Red Dark Green Light Green Navy Blue Swan Cream White Gauge: G26*0.40MM G24*0.50MM G24*0.50MM Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 320000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_59610262.png', 'SUPER VI', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3152102629.png', 'SUPER VI', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3152102643.png', 'SUPER VI', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'SUPER VII';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'SUPER VII', 'building-construction', 'Categories: AZED Sheets, Sheets Additional information Texture: Glossy (Smooth Finish) Wrinkle (Rough Finish) Gauge G26*0.40MM G24*0.50MM G22*0.60MM Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 48000, 'sheet', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_59421117.png', 'SUPER VII', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3150211137.png', 'SUPER VII', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'SUPER VII', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'THICKER MILD STEEL FLATS';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'THICKER MILD STEEL FLATS', 'building-construction', 'Used in metal fabrication especially of: Doors, Windows, Rails, Staircases, Grills, Trench Covers, Burglar Proofs and Safety Guards. Category: Trading Items Additional information: Weght (kg/m): 20, 20, 20, 25, 40, 40, 40, 50, 50, 50 Thickness: 3.0, 4.0, 6.0, 3.0, 3.0, 4.0, 6.0, 3.5, 4.0, 6.0 Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 120000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_59775528.png', 'THICKER MILD STEEL FLATS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-31537560.png', 'THICKER MILD STEEL FLATS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-31538619.png', 'THICKER MILD STEEL FLATS', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'THICKER MILD STEEL PLATES';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'THICKER MILD STEEL PLATES', 'building-construction', 'Applications include: Billboard Faces, Fuel Tanks, Water Tanks / Reservoirs,Trucks / Bus Bodies Wheelbarrows, Doors, Foundation Bases, Furniture, Gates and Fabrication. Category: Trading Items Additional information Size (ft): 8 x 4 Length (mm): 2440 Thickness (mm): 8, 10, 12, 15, 20, 25 Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 95000000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_596212542.png', 'THICKER MILD STEEL PLATES', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3152212615.png', 'THICKER MILD STEEL PLATES', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'THICKER MILD STEEL PLATES', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'TRANSLUCENT SHEETS';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'TRANSLUCENT SHEETS', 'building-construction', 'They come in Ordinary Corrugated, Super V, Super Eco and Super VI. They are colorless. They allow light into the building and have a standard length of 10 feet. Categories: Accessories, Sheets, Trading Items Additional information Gauge G300*3M G450*3M G450*3M G450*3.5M G600*3.5M G450*3M G450*3.5M G450*3M G450*3.5M G450*3M G600*3M Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 48000, 'sheet', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5961019.png', 'TRANSLUCENT SHEETS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-315210138.png', 'TRANSLUCENT SHEETS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-315210216.png', 'TRANSLUCENT SHEETS', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'U / CEILING NAILS';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'U / CEILING NAILS', 'building-construction', 'Used mainly for fencing. Category: Wire products Additional information Wire Diameter (mm): 3.4 Weight / bag (kg) : 50 Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 6500, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_596193110.png', 'U / CEILING NAILS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3152193228.png', 'U / CEILING NAILS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'U / CEILING NAILS', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'WELDED MESH';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'WELDED MESH', 'building-construction', 'Category: Wire products Additional information Width Minimum 600 mm Maximum 2750 mm Wire Diameter 2 -12 mm Line Wire Spacing 25 – 400 mm Gauge G8, G10 Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 8500, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_596181937.png', 'WELDED MESH', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3152182016.png', 'WELDED MESH', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3152182027.png', 'WELDED MESH', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'WELDED WIRE MESH GABION';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'WELDED WIRE MESH GABION', 'building-construction', 'Welded Gabions are made from flexible, lightweight, galvanized steel wire mesh that allows for machine filling, holds the alignment of the face. Welded gabions are faster to erect. This allows them to keep their shape, to be free from bulges and depressions and fit easily against the wall. Welded Gabions are used in many situations including the stabilization of earth movement and erosion, river control, reservoirs, canal refurbishment, landscaping, retaining walls and compound design Category: Wire products Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 8500, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_59419017.png', 'WELDED WIRE MESH GABION', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-31501910.png', 'WELDED WIRE MESH GABION', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'WELDED WIRE MESH GABION', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'WIRE NAILS';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'WIRE NAILS', 'building-construction', 'Applications include: Construction Carpentry & Woodwork Category: Wire products Additional information Sizes (inches): 6.0, 5.0, 4.0, 3.0, 2.5, 2.0, 1.5, 1.0 Weight : 25kg, 50kg Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 6500, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_596175913.png', 'WIRE NAILS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3152175939.png', 'WIRE NAILS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3152175952.png', 'WIRE NAILS', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'WOOD SCREWS';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'WOOD SCREWS', 'building-construction', 'Categories: Accessories, Trading Items Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 120000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_59691659.png', 'WOOD SCREWS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-315291732.png', 'WOOD SCREWS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'WOOD SCREWS', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Z-Purlins';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Z-Purlins', 'building-construction', 'Applications include: Used as Purlins for commercial, industrial and domestic structures. Used as rafters for industrial structures such as factories. Category: Open Profiles Additional information Size AxB (mm) 100×50 115×50 130×50 140×50 150×50 175×65 Technical Specifications for Z-Purlin Size D x B Wall Thickness t (mm) Weight kg/m Moment of inertia 1xx cm4 Moment of inertia 1yy cm4 Radius of Gyration 1xx cm Radius of Gyration 1yy cm Modulus of section Zx cm2 Modulus of section Zy cm2 100 x 50 2 3.54 70.18 33.87 3.83 2.7 13.81 6.8 115 x 50 2 3.78 98.24 33.89 4.47 2.82 17.19 6.8 130 x 50 2 4.02 125.99 33.87 4.94 2.56 19.84 6.8 140 x 50 2 4.17 157.8 33.87 5.4 2.5 22.6 6.8 150 x 50 2 4.33 194.14 33.87 5.85 2.44 25.47 6.8 175 x 65 2 5.19 331.7 63.13 6.97 3.04 37.31 10.1 175 x 65 2.5 6.45 389.51 67.91 6.9 2.88 43.81 10.91 NOTE : Purlins are manufactured from Hot Rolled Steel Can be… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 145000, 'length', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_596122330.png', 'Z-Purlins', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3152122359.png', 'Z-Purlins', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'Z-Purlins', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'BAMBOO TILE';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'BAMBOO TILE', 'roofing-ceilings', 'Bamboo tile is coated with Aluminium and Zinc thus withstanding all weather conditions. It is more heat resistant and resistant to rust. It can be utilised for residential and commercial purpose. Categories: AZED Sheets, Sheets Additional information Color Black Brick Red Chocolate Brown Harvest Gold Super Green Tile Red Thickness 28 (0.32mm) Texture Glossy (Smooth Finish) Wrinkle (Rough Finish) Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 55000, 'sheet', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_59685232.png', 'BAMBOO TILE', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-315285257.png', 'BAMBOO TILE', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_5979545.png', 'BAMBOO TILE', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'ECO TILE';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'ECO TILE', 'roofing-ceilings', 'Roofings has introduced a new texture finish. In a continuous effort to provide new and innovative product solutions to our clients, Roofings has introduced new and superior roof profiles in our product range: in addition to our well known glossy finish, The Roofings Wrinkle Finish in Super Tile and Eco Tile. These new unique roof tiles can be utilized for Residential & Commercial Purposes as may be required by construction companies. The sheets are available in the following colours; Black, Chocolate Brown, Brick Red, Maroon, Tile Red, Harvest Gold and Super Green for both glossy and wrinkle finish. Categories: AZED Sheets, Sheets Additional information Gauge (Thickness) 28 (0.32mm) Color Black Brick Red Chocolate Brown Harvest Gold Super Green Tile Red Texture: Glossy (Smooth Finish) Wrinkle (Rough Finish) Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 55000, 'sheet', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_59611649.png', 'ECO TILE', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-315211730.png', 'ECO TILE', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-315211743.png', 'ECO TILE', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'SUPER TILE';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'SUPER TILE', 'roofing-ceilings', 'Roofings has introduced a new texture finish. In a continuous effort to provide new and innovative product solutions to our clients, Roofings has introduced new and superior roof profiles in our product range: in addition to our well known glossy finish, The Roofings Wrinkle Finish in Super Tile and Eco Tile. These new unique roof tiles can be utilized for Residential & Commercial Purposes as may be required by construction companies. The sheets are available in the following colours; Black, Chocolate Brown, Brick Red, Maroon, Tile Red, Harvest Gold and Super Green for both glossy and wrinkle finish. Categories: AZED Sheets, Sheets Additional information Texture: Glossy (Smooth Finish) Wrinkle (Rough Finish) Color Black Brick Red Chocolate Brown Harvest Gold Super Green Tile Red Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 55000, 'sheet', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_2_596101333.png', 'SUPER TILE', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-315210142.png', 'SUPER TILE', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery2-3152101421.png', 'SUPER TILE', true);
  end if;
end $$;

-- Easy Power Co. Ltd · +256789931735+256392001947 · 6 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'easy-power-co-ltd@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'easy-power-co-ltd@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256789931735+256392001947' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'trader', 'free', 'Easy Power Co. Ltd', 'Easy Power Co. Ltd',
      'EP', '+256789931735+256392001947', null, '+256789931735+256392001947', 'easy-power-co-ltd@suppliers.bubu.market',
      'Prime Complex Building 2nd Floor, Suite 23, Kisaasi Kyanja Road, Kisaasi, Kampala', 'kampala', 'electronics', 'Easy Power Co. Ltd supplies electronics from Kampala. 6 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Easy Power Co. Ltd supplies electronics from Kampala. 6 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'electronics') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Easy-Power-Ltd-Uganda-Security.jpg', 'Easy Power Co. Ltd — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Business Alarm Systems (AL-4108) - Easy Security';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Business Alarm Systems (AL-4108) - Easy Security', 'electronics', 'Features: 1. Compatible with 8 wired and 8 wireless zones 2. Zones controllable by ID card mobile and remote controller 3. Keypad operation, LCD display 4. Easily set alarming telephone, password, time & date, armed zones 5. Panic alarm 6. CMS&GSM optional, support ADEMCO Contact ID 7. Select armed zones separately 8. Integration 9. 36 event log to record the alarming scene 10. Record and play back 11. Remote control 12. Urgent calling 13. Flexible configuring 14. Display Arm delay, alarm delay and alarming time 15. Could work with 12V SLA backup battery 16. Power (12v) output port 17. External accessing to the light 18. Alarm automatically for telephone lines being cut or in error 19. Sound for the door is opened 20. Special functions for remote control Technology Parameter: 1. Power supply: AC: 220V±10% 2. Standby current: ≤56mA (excluding wired accessories) 3. Keypad current: ≤36mA… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 420000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/AL-4108.jpg', 'Business Alarm Systems (AL-4108) - Easy Security', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/AL-630-02HL.jpg', 'Business Alarm Systems (AL-4108) - Easy Security', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/AL-666.jpg', 'Business Alarm Systems (AL-4108) - Easy Security', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Accessories (AL-630-02HL) - Easy Security';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Accessories (AL-630-02HL) - Easy Security', 'electronics', '1. Tilt sensor pout 2. Backlights 3. Two-way LCD 4. Anti-scrapping screen 5. Ultra-small mainframe 6. Arm/disarm 7. Remote cut off engine 8. Anti-robbery, call help 9. Adjust sensitivity 10. Mute alarm 11. Remote start 12. Emergent override Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 145000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/AL-630-02HL.jpg', 'Accessories (AL-630-02HL) - Easy Security', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/AL-666.jpg', 'Accessories (AL-630-02HL) - Easy Security', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/AL-4099.jpg', 'Accessories (AL-630-02HL) - Easy Security', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Accessories (AL-666) - Easy Security';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Accessories (AL-666) - Easy Security', 'electronics', 'Arm/disarm Remote start Remote cut off engine Anti-robbery Mute alarm Sensitivity adjustable Motor locator Code learnin Waterproof Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 420000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/AL-666.jpg', 'Accessories (AL-666) - Easy Security', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/AL-630-02HL.jpg', 'Accessories (AL-666) - Easy Security', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/AL-4099.jpg', 'Accessories (AL-666) - Easy Security', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Business Alarm Systems (AL-4099) - Easy Security';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Business Alarm Systems (AL-4099) - Easy Security', 'electronics', 'Features: 1. Compatible with 8 wired and 16 wireless zones 2. Zones controllable by ID card, mobile and remote controller 4. Auto dial 3 sets phone number when being triggered 5. Keypad operation, LCD display 6. Compatible with door entry system 7. 36 event log to record the alarming scene 8. Dual direction alarm priority / panic alarm 9. Record and record play back 10. Up to 10 accessories per zone be can added. 12. Arm delay, alarm delay & alarming time changeable 13. 24-h zone for smoke, gas and external siren. 14. 12V SLA backup battery (72 hours) and siren 15. CMS&GSM optional, support ADEMCO Contact ID. 16. Advanced American CPU processing circuit. Technology Parameter: 1. Power supply: AC: 185V~245V DC: 12V Current: 1500ma 2. Standby current: ≤65ma 3. Keypad current: ≤38ma 4. Alarming current: <300ma 5. Receiving frequency: 433.92±0.5MHz 6. Preset telephone number: 5 groups 7.… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 420000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/AL-4099.jpg', 'Business Alarm Systems (AL-4099) - Easy Security', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/AL-630-02HL.jpg', 'Business Alarm Systems (AL-4099) - Easy Security', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/AL-666.jpg', 'Business Alarm Systems (AL-4099) - Easy Security', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Home Alarm Systems (AL-2016) - Easy Security.';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Home Alarm Systems (AL-2016) - Easy Security.', 'electronics', 'Features: 1. Arm, disarm, panic alarm, select protective zones independently 2. Automatically dial preset phone numbers when being triggered 3. Remote controlled by mobile phone to arm, disarms, panic alarm, listen to the record and monitors the alarming scene. 4. Advanced American CPU processing circuit 5. Complicated codes (million groups), the repeat-code possibility is 1/10000 comparing with the traditional way 6. CMS&GSM optional, support ADEMCO Contact ID. 7. Interfaces for 24-hour smoke detectors, gas detectors and external sirens 8. Built-in 6*7# backup chargeable batteries 9. Built-in 85 db siren 10. LCD display (2 languages operation screen) 11. 16 wireless and 4 wired protective zones (Up to 5 accessories per wireless zone can be added) 12. Record and record play back 13. 72 pieces event log 14. Time display 15. Arm & disarm time preset-able Technology Parameter: 1. Power… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 420000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/AL-2016.jpg', 'Home Alarm Systems (AL-2016) - Easy Security.', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/17001_al-2_20260326074217.jpg', 'Home Alarm Systems (AL-2016) - Easy Security.', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/AL-630-02HL.jpg', 'Home Alarm Systems (AL-2016) - Easy Security.', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Home Alarm Systems (AL-2016B) - Easy Security';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Home Alarm Systems (AL-2016B) - Easy Security', 'electronics', 'LCD Display, easy operation 80 wireless zones, rolling to learn code. 4 wired zones Wireless transmitting range is more than 180 meters. Billion Code 3groups Alarm CMS phone number, 2groups Network CMS phone number. Available to set each zone to be ON/OFF. Available to set Global Arm or Perimeter Arm? Arm/disarm by remote, 2 groups Auto Arm/Disarm, remote to Arm/Disarm, Arm/Disarm by keypad 72pcs alarm log, showing event detail & date (year, month, day, hour, minute). Available to monitor Local, when alarming. Operating according to the voice prompts. Self-check Function: easy to test & check, for adding new sensor & normal check Freely to modify the password, Emergency Function . Built-in 85dB buzzer, available to connect with EXT siren, backup battery and antenna. Available to select wired/wireless PIR sensor, Door Sensor, Gas/Smoke Detector and so on. 110~220V input 15V output, 15V… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 250000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/AL-2016B.jpg', 'Home Alarm Systems (AL-2016B) - Easy Security', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/AL-630-02HL.jpg', 'Home Alarm Systems (AL-2016B) - Easy Security', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/AL-666.jpg', 'Home Alarm Systems (AL-2016B) - Easy Security', true);
  end if;
end $$;

-- Hima Cement Ltd · +256414258368+256312213200100 · 3 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'hima-cement-ltd@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'hima-cement-ltd@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256414258368+256312213200100' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'manufacturer', 'free', 'Hima Cement Ltd', 'Hima Cement Ltd',
      'HC', '+256414258368+256312213200100', null, '+256414258368+256312213200100', 'hima-cement-ltd@suppliers.bubu.market',
      'Kampala, Uganda, Mirembe Business Centre, 4th Floor Plot 46 Lugogo Bypass, Central, Kampala', 'kampala', 'cement and aggregates', 'Hima Cement Ltd supplies cement and aggregates from Kampala. 3 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Hima Cement Ltd supplies cement and aggregates from Kampala. 3 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'cement-aggregates') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Prod-_3131_687193652.png', 'Hima Cement Ltd — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Hima MultiPurpose';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Hima MultiPurpose', 'cement-aggregates', 'Multi Purpose CEM IV/B-P 32.5N is a Portland Pozzolanic Cement with a wide range of applications in construction like mortar, plastering, domestic concrete, road construction, industrial floors, construction repairs, etc. Its good strength performance makes it suitable for both general purpose and structural concrete applications. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 32000, 'bag', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3131_687193652.png', 'Hima MultiPurpose', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3131_687194919.png', 'Hima MultiPurpose', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3131_68719585.png', 'Hima MultiPurpose', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Hima Powermax';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Hima Powermax', 'cement-aggregates', 'PowerMAX 42,5 is an innovative versatile cement that combines excellent strength, consistent performance at all stages as well as assured long-term durability for concrete applications Powermax is strategically designed as a modern cement that addresses the demands of today''s construction sector for building and structures that will outlast generations to come. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 32000, 'bag', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3131_687194919.png', 'Hima Powermax', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3131_687193652.png', 'Hima Powermax', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3131_68719585.png', 'Hima Powermax', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Hima Powerplus';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Hima Powerplus', 'cement-aggregates', 'PowerPLUS 42,5 N cement is traditionally known as Ordinary Portland Cement. Powerplus cement is utilized very efficiently in medium to large construction projects to optimize performance. These applications require good technical ability, quality control and experience to design concrete mixes. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 32000, 'bag', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3131_68719585.png', 'Hima Powerplus', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3131_687193652.png', 'Hima Powerplus', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3131_687194919.png', 'Hima Powerplus', true);
  end if;
end $$;

commit;

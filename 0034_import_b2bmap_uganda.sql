-- BUBU.Market · supplier import from b2bmap, Uganda set
-- Generated 29 August 2026.
--
-- 8 suppliers, 19 listings, 37 photographs. Run this whole file once in the
-- Supabase SQL editor. It is idempotent: running it twice changes nothing,
-- because every row is keyed on the supplier's phone number or the listing's
-- source URL.
--
-- WHAT THIS DOES NOT DO. It does not touch any existing account, product or
-- category. It creates nothing outside the rows listed below. To undo it, run
-- the DELETE block at the foot of this file.
--
-- The photographs are files in your repo under img/imports/. They must be
-- deployed with the site or the listings will show empty frames.

begin;

create extension if not exists pgcrypto;

-- Marks everything this import creates, so it can be found and removed later.
alter table accounts add column if not exists import_source text;
alter table products add column if not exists import_source text;

-- ─────────────────────────────────────────────── suppliers

-- Accurate Weighing Scales Ltd. · +256775259917 / +2560785462212
-- Merged from two scraped profiles: Accurate Weighing Scales + Accurate Weighing Scales Ltd.
do $$
declare v_user uuid; v_acct uuid;
begin
  -- The login. Created only if this email is new, so a re-run is safe.
  select id into v_user from auth.users where email = 'accurate-weighing-scales-ltd@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'accurate-weighing-scales-ltd@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb,
      jsonb_build_object('person', 'Mr. wamuyi (Sales)'));
  end if;

  -- The trading profile, keyed on the phone number.
  select id into v_acct from accounts where phone = '+256775259917' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, import_source)
    values (v_user, 'supplier', 'trader', 'free', 'Accurate Weighing Scales Ltd.', 'Accurate Weighing Scales Ltd.',
      'AW', '+256775259917', '+2560785462212', '+256775259917', 'accurate-weighing-scales-ltd@suppliers.bubu.market',
      'Wandegeya KCCA Market South Wing, 2nd Floor Room SSF 036', 'kampala', 'Wholesaler', 'platform scales',
      'b2bmap')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user) where id = v_acct;
  end if;

  -- Nothing is verified: no URSB or TIN paper has been seen. Left pending so
  -- these appear in the admin queue rather than claiming a status they lack.
  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;
end $$;

-- Harcros Chemi Limited · +256705193653
do $$
declare v_user uuid; v_acct uuid;
begin
  -- The login. Created only if this email is new, so a re-run is safe.
  select id into v_user from auth.users where email = 'harcros-chemi-limited@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'harcros-chemi-limited@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb,
      jsonb_build_object('person', 'Mr. ALIDDEKI CEDRIC (ASSISTANT SALES MANAGER)'));
  end if;

  -- The trading profile, keyed on the phone number.
  select id into v_acct from accounts where phone = '+256705193653' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, import_source)
    values (v_user, 'supplier', 'trader', 'free', 'Harcros Chemi Limited', 'Harcros Chemi Limited',
      'HC', '+256705193653', null, '+256705193653', 'harcros-chemi-limited@suppliers.bubu.market',
      'KAMPALA', 'wakiso', 'Supplier Exporter Trading', 'Copper Cathodes, Copper Wire Scrap, Copper Blister, Copper Ore, Copper Concentrate, Blister Copper, Copper Sheets, Copper Sludge, Copper Pipes, Copper Strip',
      'b2bmap')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user) where id = v_acct;
  end if;

  -- Nothing is verified: no URSB or TIN paper has been seen. Left pending so
  -- these appear in the admin queue rather than claiming a status they lack.
  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;
end $$;

-- Best Grain Moisture Meters · +256705577823
do $$
declare v_user uuid; v_acct uuid;
begin
  -- The login. Created only if this email is new, so a re-run is safe.
  select id into v_user from auth.users where email = 'best-grain-moisture-meters@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'best-grain-moisture-meters@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb,
      jsonb_build_object('person', 'Mr. Digital Moisture Meters Company Uganda (Sales Manager)'));
  end if;

  -- The trading profile, keyed on the phone number.
  select id into v_acct from accounts where phone = '+256705577823' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, import_source)
    values (v_user, 'supplier', 'trader', 'free', 'Best Grain Moisture Meters', 'Best Grain Moisture Meters',
      'BG', '+256705577823', null, '+256705577823', 'best-grain-moisture-meters@suppliers.bubu.market',
      'Kampala, Uganda', 'kampala', 'Wholesaler', 'Moisture meters',
      'b2bmap')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user) where id = v_acct;
  end if;

  -- Nothing is verified: no URSB or TIN paper has been seen. Left pending so
  -- these appear in the admin queue rather than claiming a status they lack.
  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;
end $$;

-- Weighcom Electrical Services Kampala · +256750614536
-- Merged from two scraped profiles: Weighcom Electrical Services Kampala + Generator Service And Manintenance
do $$
declare v_user uuid; v_acct uuid;
begin
  -- The login. Created only if this email is new, so a re-run is safe.
  select id into v_user from auth.users where email = 'weighcom-electrical-services-kampala@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'weighcom-electrical-services-kampala@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb,
      jsonb_build_object('person', 'Mr. Mohammed (Executive)'));
  end if;

  -- The trading profile, keyed on the phone number.
  select id into v_acct from accounts where phone = '+256750614536' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, import_source)
    values (v_user, 'supplier', 'trader', 'free', 'Weighcom Electrical Services Kampala', 'Weighcom Electrical Services Kampala',
      'WE', '+256750614536', null, '+256750614536', 'weighcom-electrical-services-kampala@suppliers.bubu.market',
      'Kamwokya, Kira road', 'kampala', 'Wholesaler Trading', 'electrical',
      'b2bmap')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user) where id = v_acct;
  end if;

  -- Nothing is verified: no URSB or TIN paper has been seen. Left pending so
  -- these appear in the admin queue rather than claiming a status they lack.
  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;
end $$;

-- Water and Power Equipment Ltd. · +256703894856
do $$
declare v_user uuid; v_acct uuid;
begin
  -- The login. Created only if this email is new, so a re-run is safe.
  select id into v_user from auth.users where email = 'water-and-power-equipment-ltd@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'water-and-power-equipment-ltd@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb,
      jsonb_build_object('person', 'Mr. Gerald Nsimbi (Managing Director)'));
  end if;

  -- The trading profile, keyed on the phone number.
  select id into v_acct from accounts where phone = '+256703894856' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, import_source)
    values (v_user, 'supplier', 'trader', 'free', 'Water and Power Equipment Ltd.', 'Water and Power Equipment Ltd.',
      'WA', '+256703894856', null, '+256703894856', 'water-and-power-equipment-ltd@suppliers.bubu.market',
      'Essteria Building, Plot 19/23, Entebbe Road, Kampala, Uganda', 'kampala', 'Supplier Trading', 'water equipment, power equipment, cleaning machines, high-pressure cleaners hd6/15-4, car washing machines, roof/ paver cleaning machines, scrubbing, floor cleaning machine, vacuum cleaners, solar water systems, water pumps, engines and motors, generators, repair services,',
      'b2bmap')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user) where id = v_acct;
  end if;

  -- Nothing is verified: no URSB or TIN paper has been seen. Left pending so
  -- these appear in the admin queue rather than claiming a status they lack.
  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;
end $$;

-- Voltage Electrical Engineering Company · +256784313767
do $$
declare v_user uuid; v_acct uuid;
begin
  -- The login. Created only if this email is new, so a re-run is safe.
  select id into v_user from auth.users where email = 'voltage-electrical-engineering-company@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'voltage-electrical-engineering-company@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb,
      jsonb_build_object('person', 'Mr. Moha (Operations Manager)'));
  end if;

  -- The trading profile, keyed on the phone number.
  select id into v_acct from accounts where phone = '+256784313767' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, import_source)
    values (v_user, 'supplier', 'trader', 'free', 'Voltage Electrical Engineering Company', 'Voltage Electrical Engineering Company',
      'VE', '+256784313767', null, '+256784313767', 'voltage-electrical-engineering-company@suppliers.bubu.market',
      'Kira road, Kamwokya, Kampala, Uganda', 'kampala', 'Wholesaler Trading', 'Electrical Contractor',
      'b2bmap')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user) where id = v_acct;
  end if;

  -- Nothing is verified: no URSB or TIN paper has been seen. Left pending so
  -- these appear in the admin queue rather than claiming a status they lack.
  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;
end $$;

-- Sourcekey Commodities Impex Ltd · +256394856062
do $$
declare v_user uuid; v_acct uuid;
begin
  -- The login. Created only if this email is new, so a re-run is safe.
  select id into v_user from auth.users where email = 'sourcekey-commodities-impex-ltd@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'sourcekey-commodities-impex-ltd@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb,
      jsonb_build_object('person', 'Mr. Henry Ojok (Marketing and Sales Director)'));
  end if;

  -- The trading profile, keyed on the phone number.
  select id into v_acct from accounts where phone = '+256394856062' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, import_source)
    values (v_user, 'supplier', 'trader', 'free', 'Sourcekey Commodities Impex Ltd', 'Sourcekey Commodities Impex Ltd',
      'SC', '+256394856062', null, '+256394856062', 'sourcekey-commodities-impex-ltd@suppliers.bubu.market',
      'Kampala-Entebbe Road', 'kampala', 'Supplier Exporter Trading', 'Coffee, Cocoa, Fish, Honey, Sugar, Pineapples, Avocados, Mangoes, Passion Fruits, Groundnuts, Seseme Seeds, Soybeans, Sunflower Seeds, Maize, Rice, Vanilla, Ginger, and Many Much More.',
      'b2bmap')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user) where id = v_acct;
  end if;

  -- Nothing is verified: no URSB or TIN paper has been seen. Left pending so
  -- these appear in the admin queue rather than claiming a status they lack.
  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;
end $$;

-- Silver Mercury Ltd · +256786466544
do $$
declare v_user uuid; v_acct uuid;
begin
  -- The login. Created only if this email is new, so a re-run is safe.
  select id into v_user from auth.users where email = 'silver-mercury-ltd@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'silver-mercury-ltd@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb,
      jsonb_build_object('person', 'Mr. Micheal John owando (Director)'));
  end if;

  -- The trading profile, keyed on the phone number.
  select id into v_acct from accounts where phone = '+256786466544' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, import_source)
    values (v_user, 'supplier', 'trader', 'free', 'Silver Mercury Ltd', 'Silver Mercury Ltd',
      'SM', '+256786466544', null, '+256786466544', 'silver-mercury-ltd@suppliers.bubu.market',
      'Mombasa Container Terminal, Pipeline Road, Kipevu, Changamwe P.O. Box 43011 - 80111 Mombasa Kenya. 00254786466544', 'kampala', 'Manufacturer Exporter Supplier', 'Silver mercury, mercury, liquid mercury, liquid silver mercury, Virgin silver mercury',
      'b2bmap')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user) where id = v_acct;
  end if;

  -- Nothing is verified: no URSB or TIN paper has been seen. Left pending so
  -- these appear in the admin queue rather than claiming a status they lack.
  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;
end $$;

-- ─────────────────────────────────────────────── listings

-- Avery mechanical steelyard Platform Weighing Scales
do $$
declare v_acct uuid; v_prod uuid;
begin
  select id into v_acct from accounts where phone = '+256775259917' and role = 'supplier';
  if v_acct is null then raise notice 'supplier missing for avery-steelyard'; return; end if;

  select id into v_prod from products where supplier_id = v_acct and import_source = 'b2bmap:avery-steelyard';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      status, import_source)
    values (v_acct, 'Avery mechanical steelyard Platform Weighing Scales', 'agriculture-produce', 'Accurate Weighing Scales are one of the recognized firms engaged in supplying and distributing Avery Steel Yard Type Mechanical Platform weighing scale. Avery Mechanical Platform Weighing Scale. The Avery Mechanical Platform Weighing Scales can be of capacities 300kg. Avery Steelyard Mechanical (or analog) platform scales don''t require electricity to work. Generally, these scales are supported on each corner by a bearing, which rests on a set of pivots. The pivots are supported by a single understructure device which, in turn, is supported with another lever system.

Heavy-duty mechanical platform scales with cast iron moulded platform. Cast iron rugged wheels. Rectangular column. Three platform sizes for selection Steel protecting rails. Brass arm with kg/lb mass unit. -optional kg mass only 25kg/50lb, 50kg/100lb mass. Big capacity up to 500kg/1000kg. Capacities 500kg, 500kg/lb, 500kg, 500kg/lb, 1000kg, 1000kg/lb',
      2934000, 'unit', 1, 'published', 'b2bmap:avery-steelyard')
    returning id into v_prod;
  end if;

  delete from product_specs where product_id = v_prod;
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Country of Origin', 'United States', 0);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'HS Code', 'Avery', 1);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Category', 'Agro & Agriculture Agribusiness', 2);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Payment Terms', 'cash, bank', 3);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Model Number', 'Avery', 4);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Color', 'Black', 5);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Size', 'Big', 6);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Weight', 'Heavy', 7);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Style', 'Steelyard', 8);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Technology', 'Mechanical', 9);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Standard', 'Accurate', 10);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Grade', 'Avery', 11);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Listed price', 'USD 793 as listed on b2bmap', 12);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'b2bmap.com — not yet confirmed by the supplier', 13);

  delete from media where product_id = v_prod and kind = 'product';
  insert into media (account_id, product_id, kind, storage_path, caption, approved)
    values (v_acct, v_prod, 'product', 'img/imports/avery-steelyard-01.jpg', 'Avery mechanical steelyard Platform Weighing Scales', true);

  insert into account_categories (account_id, category_id)
  values (v_acct, 'agriculture-produce') on conflict do nothing;
end $$;

-- Copper Cathodes and Metal Ores Bulk Supplier
do $$
declare v_acct uuid; v_prod uuid;
begin
  select id into v_acct from accounts where phone = '+256705193653' and role = 'supplier';
  if v_acct is null then raise notice 'supplier missing for copper-cathodes'; return; end if;

  select id into v_prod from products where supplier_id = v_acct and import_source = 'b2bmap:copper-cathodes';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      status, import_source)
    values (v_acct, 'Copper Cathodes and Metal Ores Bulk Supplier', 'steel-metal', 'Copper is a versatile, highly conductive, and corrosion-resistant metal essential for electrical wiring, electronics (PCBs, heat sinks), and plumbing pipes. Due to its malleability, strength, and antimicrobial properties, it is widely used in construction (roofing, gutters), transportation (radiators, brake systems), industrial machinery, and alloy production (brass, bronze).

Harcros Chemi Limited, based in Central, Uganda, operates as a supplier, exporter, and trading company serving international buyers.

Product Name and Specification

1) Copper Ore

2) Copper Concentrate

3) Lead Ore

4) Lead Ore Concentrate

5) Zinc Ore

6) Zinc Concentrate

Size Specification

7) Nickel Concentrate

8) Nickel Matte

9) Nickel Ore',
      33300000, 'tonne', 1000, 'published', 'b2bmap:copper-cathodes')
    returning id into v_prod;
  end if;

  delete from product_specs where product_id = v_prod;
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Brand', 'COPPER cathodes', 0);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Country of Origin', 'Congo', 1);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'HS Code', 'Cu', 2);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Category', 'Minerals & Raw Materials Other Materials', 3);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Payment Terms', 'LC /TT', 4);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Listed price', 'USD 9,000 as listed on b2bmap', 5);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'b2bmap.com — not yet confirmed by the supplier', 6);

  delete from media where product_id = v_prod and kind = 'product';
  insert into media (account_id, product_id, kind, storage_path, caption, approved)
    values (v_acct, v_prod, 'product', 'img/imports/copper-cathodes-01.jpeg', 'Copper Cathodes and Metal Ores Bulk Supplier', true);
  insert into media (account_id, product_id, kind, storage_path, caption, approved)
    values (v_acct, v_prod, 'product', 'img/imports/copper-cathodes-02.jpeg', 'Copper Cathodes and Metal Ores Bulk Supplier', true);

  insert into account_categories (account_id, category_id)
  values (v_acct, 'steel-metal') on conflict do nothing;
end $$;

-- Digital Draminski Cereal Moisture Meters Cup - Accurate Grain Moisture Measurement
do $$
declare v_acct uuid; v_prod uuid;
begin
  select id into v_acct from accounts where phone = '+256705577823' and role = 'supplier';
  if v_acct is null then raise notice 'supplier missing for draminski-cup'; return; end if;

  select id into v_prod from products where supplier_id = v_acct and import_source = 'b2bmap:draminski-cup';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      status, import_source)
    values (v_acct, 'Digital Draminski Cereal Moisture Meters Cup - Accurate Grain Moisture Measurement', 'agriculture-produce', 'We have Digital cereal moisture meters cup type that can measure moisture in grain and cereal used by many farmers in Kampala. Digital Cup type moisture meters are used for precise quick measurement of grain moisture.

We are leading suppliers Digital grain moisture meters in Uganda. We supply high performance Digital moisture meters used in the field to measure moisture content to able to determine when to begin harvesting.

Moisture meters are used for regular moisture measurement during the drying process and while the grain is in storage. Harvesting wetter grains than necessary, it will result in extra drying costs. Digital moisture meters save you from extra drying costs. Some moisture meters come with an in-built grinder.',
      2757000, 'unit', 1, 'published', 'b2bmap:draminski-cup')
    returning id into v_prod;
  end if;

  delete from product_specs where product_id = v_prod;
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Country of Origin', 'United Kingdom', 0);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Category', 'Agro & Agriculture Agribusiness', 1);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Payment Terms', 'Bank. cash,', 2);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Listed price', 'USD 745 as listed on b2bmap', 3);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'b2bmap.com — not yet confirmed by the supplier', 4);

  delete from media where product_id = v_prod and kind = 'product';
  insert into media (account_id, product_id, kind, storage_path, caption, approved)
    values (v_acct, v_prod, 'product', 'img/imports/draminski-cup-01.jpg', 'Digital Draminski Cereal Moisture Meters Cup - Accurate Grain Moisture Measurement', true);

  insert into account_categories (account_id, category_id)
  values (v_acct, 'agriculture-produce') on conflict do nothing;
end $$;

-- Electrical Installation service
do $$
declare v_acct uuid; v_prod uuid;
begin
  select id into v_acct from accounts where phone = '+256750614536' and role = 'supplier';
  if v_acct is null then raise notice 'supplier missing for electrical-install'; return; end if;

  select id into v_prod from products where supplier_id = v_acct and import_source = 'b2bmap:electrical-install';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      status, import_source)
    values (v_acct, 'Electrical Installation service', 'electrical-lighting', 'Specialists in Electrical Controls, industrial and commercial Electrical wiring, panel building, power line construction, generator service and repair, electrical Earthing and Lightning protection, Maintenance & Repair. We are the best electricians in electrical wiring services in Kampala, we are not just convincing you but our company is among the best electrical installations companies in Uganda.',
      1110000, 'job', 1, 'published', 'b2bmap:electrical-install')
    returning id into v_prod;
  end if;

  delete from product_specs where product_id = v_prod;
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Country of Origin', 'Uganda', 0);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Category', 'Business Services Other Materials', 1);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Payment Terms', 'cash', 2);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Listed price', 'USD 300 as listed on b2bmap', 3);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'b2bmap.com — not yet confirmed by the supplier', 4);

  delete from media where product_id = v_prod and kind = 'product';
  insert into media (account_id, product_id, kind, storage_path, caption, approved)
    values (v_acct, v_prod, 'product', 'img/imports/electrical-install-01.jpg', 'Electrical Installation service', true);

  insert into account_categories (account_id, category_id)
  values (v_acct, 'electrical-lighting') on conflict do nothing;
end $$;

-- Industrial Floor Scales Uganda for Warehouses and Factory Use
do $$
declare v_acct uuid; v_prod uuid;
begin
  select id into v_acct from accounts where phone = '+256775259917' and role = 'supplier';
  if v_acct is null then raise notice 'supplier missing for floor-scales'; return; end if;

  select id into v_prod from products where supplier_id = v_acct and import_source = 'b2bmap:floor-scales';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      status, import_source)
    values (v_acct, 'Industrial Floor Scales Uganda for Warehouses and Factory Use', 'hardware-tools', 'Industrial Floor Scales are designed for heavy-duty weighing applications in industrial, warehouse, and manufacturing environments.

Built with high-strength steel platforms and advanced digital load cells, these scales deliver accurate and reliable weight measurements even under rugged working conditions.

Accurate Weighing Scales Ltd supplies, installs, and services a wide range of industrial floor weighing scales across Uganda.

We want to make sure that every client enjoys precision, reliability, and after-sales support they can trust.

Applications

Key Features

Benefits',
      4440000, 'unit', 1, 'published', 'b2bmap:floor-scales')
    returning id into v_prod;
  end if;

  delete from product_specs where product_id = v_prod;
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Brand', 'accurateflr', 0);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Country of Origin', 'Japan', 1);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Category', 'Machinery & Industrial Supplies Electronic Manufacturing Machinery', 2);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Payment Terms', 'Bank', 3);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Model Number', 'accflr', 4);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Color', 'grey', 5);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Size', '1mx1m', 6);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Weight', '1ton', 7);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Style', 'industrial', 8);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Technology', 'digital', 9);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Standard', 'High', 10);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Grade', 'classIII', 11);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Listed price', 'USD 1,200 as listed on b2bmap', 12);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'b2bmap.com — not yet confirmed by the supplier', 13);

  delete from media where product_id = v_prod and kind = 'product';
  insert into media (account_id, product_id, kind, storage_path, caption, approved)
    values (v_acct, v_prod, 'product', 'img/imports/floor-scales-01.jpg', 'Industrial Floor Scales Uganda for Warehouses and Factory Use', true);
  insert into media (account_id, product_id, kind, storage_path, caption, approved)
    values (v_acct, v_prod, 'product', 'img/imports/floor-scales-02.jpg', 'Industrial Floor Scales Uganda for Warehouses and Factory Use', true);
  insert into media (account_id, product_id, kind, storage_path, caption, approved)
    values (v_acct, v_prod, 'product', 'img/imports/floor-scales-03.jpg', 'Industrial Floor Scales Uganda for Warehouses and Factory Use', true);
  insert into media (account_id, product_id, kind, storage_path, caption, approved)
    values (v_acct, v_prod, 'product', 'img/imports/floor-scales-04.jpg', 'Industrial Floor Scales Uganda for Warehouses and Factory Use', true);

  insert into account_categories (account_id, category_id)
  values (v_acct, 'hardware-tools') on conflict do nothing;
end $$;

-- Walk Behind Floor Scrubber Machine with 45L Tank for Sale Uganda
--   Price is a market estimate: the listing said only "Negotiable".
do $$
declare v_acct uuid; v_prod uuid;
begin
  select id into v_acct from accounts where phone = '+256703894856' and role = 'supplier';
  if v_acct is null then raise notice 'supplier missing for floor-scrubber'; return; end if;

  select id into v_prod from products where supplier_id = v_acct and import_source = 'b2bmap:floor-scrubber';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      status, import_source)
    values (v_acct, 'Walk Behind Floor Scrubber Machine with 45L Tank for Sale Uganda', 'cleaning-hygiene', 'The Walk Behind Floor Scrubber Machine is an electric scrubber drier for large-scale floor cleaning. It has a 45-litre dual tank system and 1400W power output.

It covers 1800 sq.m/hr, with 450 mm scrubbing width and 750 mm suction width. It is ideal for commercial and industrial use.

Walk behind electrically operated auto scrubber drier

- Area Coverage: 1800 Sq.m/hr

- Fresh | Dirty Water Tank: 45 Litres

- Scrubbing Width: 450 mm

- Suction Width: 750 mm

- Total Power: 1400 W',
      8140000, 'unit', 1, 'published', 'b2bmap:floor-scrubber')
    returning id into v_prod;
  end if;

  delete from product_specs where product_id = v_prod;
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Brand', 'Floor Cleaning Machine', 0);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Country of Origin', 'India', 1);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'HS Code', 'WPE-0002-2', 2);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Category', 'Machinery & Industrial Supplies Apparel & Fashion Machinery & Tools', 3);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Indicative price', 'USD 2,200 (market estimate, not quoted by the supplier)', 4);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'b2bmap.com — not yet confirmed by the supplier', 5);

  delete from media where product_id = v_prod and kind = 'product';
  insert into media (account_id, product_id, kind, storage_path, caption, approved)
    values (v_acct, v_prod, 'product', 'img/imports/floor-scrubber-01.jpg', 'Walk Behind Floor Scrubber Machine with 45L Tank for Sale Uganda', true);
  insert into media (account_id, product_id, kind, storage_path, caption, approved)
    values (v_acct, v_prod, 'product', 'img/imports/floor-scrubber-02.jpg', 'Walk Behind Floor Scrubber Machine with 45L Tank for Sale Uganda', true);

  insert into account_categories (account_id, category_id)
  values (v_acct, 'cleaning-hygiene') on conflict do nothing;
end $$;

-- Generator Repair and Servicing
do $$
declare v_acct uuid; v_prod uuid;
begin
  select id into v_acct from accounts where phone = '+256750614536' and role = 'supplier';
  if v_acct is null then raise notice 'supplier missing for gen-repair'; return; end if;

  select id into v_prod from products where supplier_id = v_acct and import_source = 'b2bmap:gen-repair';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      status, import_source)
    values (v_acct, 'Generator Repair and Servicing', 'electrical-lighting', 'Weighcom has a broad and deep knowledge in designing electrical systems, installing generators, servicing and repairing three phase generators. Our technicians perform basic care maintenance, such as oil changes and diagnose more complex problems, and plan and execute generator repairs. Generator repair, maintenance and service is very important for business that fully rely or partially rely on diesel generators in case power has gone off.

Our generator technicians inspect, service, maintain, and repair diesel generators that run on petrol and diesel. Three phase generator repair services for generator brands like Volvo, JOHN DEERE, JOHN DEERE, YANMAR, Cummins, Perkins, Kato light, FG Wilson, Caterpillar etc. We are the right people to serve you.',
      733000, 'service', 1, 'published', 'b2bmap:gen-repair')
    returning id into v_prod;
  end if;

  delete from product_specs where product_id = v_prod;
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Country of Origin', 'Uganda', 0);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Category', 'Energy & Power Generators', 1);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Payment Terms', 'Cash, cheque, bank transfer', 2);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Packaging Info', 'Generators', 3);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Delivery Info', 'Any location within Uganda', 4);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Listed price', 'USD 198 as listed on b2bmap', 5);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'b2bmap.com — not yet confirmed by the supplier', 6);

  delete from media where product_id = v_prod and kind = 'product';
  insert into media (account_id, product_id, kind, storage_path, caption, approved)
    values (v_acct, v_prod, 'product', 'img/imports/gen-repair-01.jpg', 'Generator Repair and Servicing', true);

  insert into account_categories (account_id, category_id)
  values (v_acct, 'electrical-lighting') on conflict do nothing;
end $$;

-- Generator Service and Repair
do $$
declare v_acct uuid; v_prod uuid;
begin
  select id into v_acct from accounts where phone = '+256784313767' and role = 'supplier';
  if v_acct is null then raise notice 'supplier missing for gen-service'; return; end if;

  select id into v_prod from products where supplier_id = v_acct and import_source = 'b2bmap:gen-service';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      status, import_source)
    values (v_acct, 'Generator Service and Repair', 'electrical-lighting', 'With huge driven technical excellence, our company is actively providing our clients with the best quality Generator Repair and Services in Kampala Uganda. While rendering this service, our experts use sophisticated tools and machines as par with the specific requirement of our valuable clients.

Generator Maintenance Service • Travel to Customer’s Site • Weighcom to maintain maintenance records per manufacturer requirements • Visual Inspection, Cleaning, Oil Change, Air Filter Change, and Spark Plug Inspection/Replacement • Complete an engine test and inspection during generator operation to verify output voltages and overall performance • Any additional part or services required are extra',
      370000, 'service', 1, 'published', 'b2bmap:gen-service')
    returning id into v_prod;
  end if;

  delete from product_specs where product_id = v_prod;
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Country of Origin', 'Uganda', 0);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Category', 'Electronics & Electrical Generators', 1);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Payment Terms', 'Cash, cheque, bank transfer', 2);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Packaging Info', 'Maintenance', 3);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Delivery Info', 'Any location within Uganda', 4);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Listed price', 'USD 100 as listed on b2bmap', 5);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'b2bmap.com — not yet confirmed by the supplier', 6);

  delete from media where product_id = v_prod and kind = 'product';
  insert into media (account_id, product_id, kind, storage_path, caption, approved)
    values (v_acct, v_prod, 'product', 'img/imports/gen-service-01.jpg', 'Generator Service and Repair', true);

  insert into account_categories (account_id, category_id)
  values (v_acct, 'electrical-lighting') on conflict do nothing;
end $$;

-- Fresh Hass Avocado Wholesale – Best Price Supplier from Uganda
do $$
declare v_acct uuid; v_prod uuid;
begin
  select id into v_acct from accounts where phone = '+256394856062' and role = 'supplier';
  if v_acct is null then raise notice 'supplier missing for hass-avocado'; return; end if;

  select id into v_prod from products where supplier_id = v_acct and import_source = 'b2bmap:hass-avocado';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      status, import_source)
    values (v_acct, 'Fresh Hass Avocado Wholesale – Best Price Supplier from Uganda', 'agriculture-produce', 'Fresh Hass Avocados are globally valued for their creamy texture, rich flavor, and excellent shelf life. Grown in Uganda''s fertile climate, these avocados are harvested at peak ripeness and meet international quality standards.

The product comes in a green color, weighing between 12–15 kg, and belongs to Grade A standard.

Fresh hass avocados available for export from Uganda to Worldwide. Contact Sourcekey Commodities Impex Ltd and get free samples now!

Samples and full load can be delivered to you within only 3 working days by Uganda Airlines or DHL EXPRESS. Bulk orders are welcomed.

We prioritize quality to meet international quality standards.',
      22000, 'box', 100, 'published', 'b2bmap:hass-avocado')
    returning id into v_prod;
  end if;

  delete from product_specs where product_id = v_prod;
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Brand', 'SOURCEKEY', 0);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Country of Origin', 'Uganda', 1);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Category', 'Agro & Agriculture Fruit', 2);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Packaging Info', '12kg per box', 3);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Delivery Info', 'Delivery in 3 working days via Entebbe International Airport', 4);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Color', 'Green', 5);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Weight', '12-15Kg', 6);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Standard', 'International Standard', 7);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Grade', 'A', 8);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Listed price', 'USD 6 as listed on b2bmap', 9);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'b2bmap.com — not yet confirmed by the supplier', 10);

  delete from media where product_id = v_prod and kind = 'product';
  insert into media (account_id, product_id, kind, storage_path, caption, approved)
    values (v_acct, v_prod, 'product', 'img/imports/hass-avocado-01.jpg', 'Fresh Hass Avocado Wholesale – Best Price Supplier from Uganda', true);
  insert into media (account_id, product_id, kind, storage_path, caption, approved)
    values (v_acct, v_prod, 'product', 'img/imports/hass-avocado-02.jpg', 'Fresh Hass Avocado Wholesale – Best Price Supplier from Uganda', true);
  insert into media (account_id, product_id, kind, storage_path, caption, approved)
    values (v_acct, v_prod, 'product', 'img/imports/hass-avocado-03.jpg', 'Fresh Hass Avocado Wholesale – Best Price Supplier from Uganda', true);

  insert into account_categories (account_id, category_id)
  values (v_acct, 'agriculture-produce') on conflict do nothing;
end $$;

-- 7 KVA Honda Inverter Generator for Sale at Best Price in Uganda
--   Price is a market estimate: the listing said only "Negotiable".
do $$
declare v_acct uuid; v_prod uuid;
begin
  select id into v_acct from accounts where phone = '+256703894856' and role = 'supplier';
  if v_acct is null then raise notice 'supplier missing for honda-7kva'; return; end if;

  select id into v_prod from products where supplier_id = v_acct and import_source = 'b2bmap:honda-7kva';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      status, import_source)
    values (v_acct, '7 KVA Honda Inverter Generator for Sale at Best Price in Uganda', 'electrical-lighting', 'The EU70is uses Honda’s four-stroke GX390 engine coupled with an Electronic Fuel-Injection system, delivering a maximum output of 7, 000 watts AC and rated output of 5, 500 watts.

Experience unparalleled power with the Honda EU70is Portable Generator.

Its robust 4-stroke GX390 engine, coupled with advanced Electronic Fuel-Injection and sine-wave inverter technology, guarantees smooth, high-quality power delivery.

With a maximum output of 7kVA and a rated output of 5.5kVA, it''s perfect for heavy-duty commercial and domestic use.

Enjoy easy operation with a push-button starter and a quiet triple chamber ''low tune'' muffler.

Plus, benefit from improved fuel consumption, easier maintenance, and enhanced performance.

Trust the EU70is to meet all your electricity needs with precision and reliability.',
      17020000, 'unit', 1, 'published', 'b2bmap:honda-7kva')
    returning id into v_prod;
  end if;

  delete from product_specs where product_id = v_prod;
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Country of Origin', 'Japan', 0);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'HS Code', 'WPE-006', 1);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Category', 'Automotive & Automobile Auto Accessories', 2);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Indicative price', 'USD 4,600 (market estimate, not quoted by the supplier)', 3);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'b2bmap.com — not yet confirmed by the supplier', 4);

  delete from media where product_id = v_prod and kind = 'product';
  insert into media (account_id, product_id, kind, storage_path, caption, approved)
    values (v_acct, v_prod, 'product', 'img/imports/honda-7kva-01.jpg', '7 KVA Honda Inverter Generator for Sale at Best Price in Uganda', true);
  insert into media (account_id, product_id, kind, storage_path, caption, approved)
    values (v_acct, v_prod, 'product', 'img/imports/honda-7kva-02.jpg', '7 KVA Honda Inverter Generator for Sale at Best Price in Uganda', true);

  insert into account_categories (account_id, category_id)
  values (v_acct, 'electrical-lighting') on conflict do nothing;
end $$;

-- Heavy-Duty Livestock Weighing Platform – Accurate Digital Scales Uganda
do $$
declare v_acct uuid; v_prod uuid;
begin
  select id into v_acct from accounts where phone = '+256775259917' and role = 'supplier';
  if v_acct is null then raise notice 'supplier missing for livestock-platform'; return; end if;

  select id into v_prod from products where supplier_id = v_acct and import_source = 'b2bmap:livestock-platform';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      status, import_source)
    values (v_acct, 'Heavy-Duty Livestock Weighing Platform – Accurate Digital Scales Uganda', 'livestock-feeds', 'Livestock weighing platforms are essential tools for farmers, veterinarians, and livestock traders who need to monitor animal weight accurately and efficiently.

These platforms are specifically designed to handle the movement and weight distribution of live animals such as cattle, goats, pigs, and sheep.

Accurate Weighing Scales Ltd supplies robust and easy-to-clean livestock weighing platforms designed for durability, accuracy, and animal safety, even in rugged farm environments.

Our livestock weighing platforms are engineered to withstand harsh farm conditions while maintaining precision.

They feature a robust structure, stainless steel load cells, and optional ramps for easy animal entry.

It is for weighing cattle, sheep, and pigs, these scales help monitor animal growth and optimize feed efficiency.',
      3700000, 'unit', 1, 'published', 'b2bmap:livestock-platform')
    returning id into v_prod;
  end if;

  delete from product_specs where product_id = v_prod;
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Brand', 'Accurate scales', 0);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Country of Origin', 'Japan', 1);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Category', 'Machinery & Industrial Supplies Farming Machinery', 2);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Payment Terms', 'Cash bank', 3);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Delivery Info', 'Same day delivery within Kampala', 4);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Model Number', 'ACCU-ANIMAL256', 5);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Color', 'grey', 6);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Size', '5mm', 7);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Weight', '1ton', 8);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Style', 'cage type', 9);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Technology', 'digital', 10);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Standard', 'high', 11);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Grade', 'class III', 12);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Listed price', 'USD 1,000 as listed on b2bmap', 13);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'b2bmap.com — not yet confirmed by the supplier', 14);

  delete from media where product_id = v_prod and kind = 'product';
  insert into media (account_id, product_id, kind, storage_path, caption, approved)
    values (v_acct, v_prod, 'product', 'img/imports/livestock-platform-01.jpg', 'Heavy-Duty Livestock Weighing Platform – Accurate Digital Scales Uganda', true);
  insert into media (account_id, product_id, kind, storage_path, caption, approved)
    values (v_acct, v_prod, 'product', 'img/imports/livestock-platform-02.jpg', 'Heavy-Duty Livestock Weighing Platform – Accurate Digital Scales Uganda', true);
  insert into media (account_id, product_id, kind, storage_path, caption, approved)
    values (v_acct, v_prod, 'product', 'img/imports/livestock-platform-03.jpg', 'Heavy-Duty Livestock Weighing Platform – Accurate Digital Scales Uganda', true);
  insert into media (account_id, product_id, kind, storage_path, caption, approved)
    values (v_acct, v_prod, 'product', 'img/imports/livestock-platform-04.jpg', 'Heavy-Duty Livestock Weighing Platform – Accurate Digital Scales Uganda', true);

  insert into account_categories (account_id, category_id)
  values (v_acct, 'livestock-feeds') on conflict do nothing;
end $$;

-- Kampala Platform Weighing Scales for Agricultural Use Model 09989 Blue
do $$
declare v_acct uuid; v_prod uuid;
begin
  select id into v_acct from accounts where phone = '+256775259917' and role = 'supplier';
  if v_acct is null then raise notice 'supplier missing for platform-09989'; return; end if;

  select id into v_prod from products where supplier_id = v_acct and import_source = 'b2bmap:platform-09989';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      status, import_source)
    values (v_acct, 'Kampala Platform Weighing Scales for Agricultural Use Model 09989 Blue', 'agriculture-produce', 'Kampala Platform Weighing Scales are an essential tool for measuring the weight of agricultural products, such as maize, corn, and wheat. As a wholesaler, Accurate Weighing Scales offers this portable and user-friendly weighing solution that guarantees measurements. These scales are designed with advanced technology to ensure that users can rely on their accuracy, making them vital for businesses in the agro and agriculture sectors.

The model number 09989 features a durable stainless-steel design that is both and lightweight, weighing only 5 kg. This scale''s compact size and portability make it ideal for use in various environments, especially warehouses where weighing positions frequently change. The built-in handles and wheels enhance its mobility, allowing users to move it effortlessly from one location to another.

The Kampala Platform Weighing Scales offers accurate weight readings but also provide excellent value for money.',
      2757000, 'unit', 1, 'published', 'b2bmap:platform-09989')
    returning id into v_prod;
  end if;

  delete from product_specs where product_id = v_prod;
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Country of Origin', 'United Kingdom', 0);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Category', 'Electronics & Electrical Networking Devices', 1);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Payment Terms', 'CASH', 2);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Model Number', '09989', 3);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Color', 'BLUE', 4);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Size', '5', 5);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Weight', '5kg', 6);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Style', 'Stainless', 7);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Technology', 'Advanced', 8);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Standard', 'precise', 9);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Grade', '1', 10);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Listed price', 'USD 745 as listed on b2bmap', 11);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'b2bmap.com — not yet confirmed by the supplier', 12);

  delete from media where product_id = v_prod and kind = 'product';
  insert into media (account_id, product_id, kind, storage_path, caption, approved)
    values (v_acct, v_prod, 'product', 'img/imports/platform-09989-01.png', 'Kampala Platform Weighing Scales for Agricultural Use Model 09989 Blue', true);
  insert into media (account_id, product_id, kind, storage_path, caption, approved)
    values (v_acct, v_prod, 'product', 'img/imports/platform-09989-02.png', 'Kampala Platform Weighing Scales for Agricultural Use Model 09989 Blue', true);
  insert into media (account_id, product_id, kind, storage_path, caption, approved)
    values (v_acct, v_prod, 'product', 'img/imports/platform-09989-03.jpg', 'Kampala Platform Weighing Scales for Agricultural Use Model 09989 Blue', true);

  insert into account_categories (account_id, category_id)
  values (v_acct, 'agriculture-produce') on conflict do nothing;
end $$;

-- HD 6/15-4 Pressure Cleaner – Cold Water Machine for Industrial Use
--   Price is a market estimate: the listing said only "Negotiable".
do $$
declare v_acct uuid; v_prod uuid;
begin
  select id into v_acct from accounts where phone = '+256703894856' and role = 'supplier';
  if v_acct is null then raise notice 'supplier missing for pressure-cleaner'; return; end if;

  select id into v_prod from products where supplier_id = v_acct and import_source = 'b2bmap:pressure-cleaner';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      status, import_source)
    values (v_acct, 'HD 6/15-4 Pressure Cleaner – Cold Water Machine for Industrial Use', 'cleaning-hygiene', 'HD 6/15-4 Classic Pressure Washer delivers 150 bar pressure and runs on a three-phase motor. Suitable for outdoor, vehicle, and floor cleaning. It uses crankshaft pump technology.

Whether on large construction sites, in earthworks, quarrying or agriculture: anywhere where very coarse dirt has to be removed in difficult outdoor conditions,

Our three-phase current HD 16/15-4 Cage Plus cold water high-pressure cleaner with 150 bar water pressure is the ideal choice for these types of water-intensive applications.',
      6660000, 'unit', 1, 'published', 'b2bmap:pressure-cleaner')
    returning id into v_prod;
  end if;

  delete from product_specs where product_id = v_prod;
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Brand', 'Pressure Cleaner', 0);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Country of Origin', 'India', 1);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'HS Code', 'WPE-007', 2);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Category', 'Machinery & Industrial Supplies Apparel & Fashion Machinery & Tools', 3);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Indicative price', 'USD 1,800 (market estimate, not quoted by the supplier)', 4);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'b2bmap.com — not yet confirmed by the supplier', 5);

  delete from media where product_id = v_prod and kind = 'product';
  insert into media (account_id, product_id, kind, storage_path, caption, approved)
    values (v_acct, v_prod, 'product', 'img/imports/pressure-cleaner-01.jpg', 'HD 6/15-4 Pressure Cleaner – Cold Water Machine for Industrial Use', true);
  insert into media (account_id, product_id, kind, storage_path, caption, approved)
    values (v_acct, v_prod, 'product', 'img/imports/pressure-cleaner-02.jpg', 'HD 6/15-4 Pressure Cleaner – Cold Water Machine for Industrial Use', true);

  insert into account_categories (account_id, category_id)
  values (v_acct, 'cleaning-hygiene') on conflict do nothing;
end $$;

-- Spanish Silver Mercury for Gold Mining
do $$
declare v_acct uuid; v_prod uuid;
begin
  select id into v_acct from accounts where phone = '+256786466544' and role = 'supplier';
  if v_acct is null then raise notice 'supplier missing for silver-mercury'; return; end if;

  select id into v_prod from products where supplier_id = v_acct and import_source = 'b2bmap:silver-mercury';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      status, import_source)
    values (v_acct, 'Spanish Silver Mercury for Gold Mining', 'chemicals-industrial', 'Silver Mercury Ltd proudly presents our high-purity Spanish Silver Mercury, a key component for gold mining and extraction. Our liquid mercury comes in various forms, including Metallic Liquid Mercury, Liquid White Mercury, Pure Liquid Mercury, and Virgin Liquid Mercury. As a leading Manufacturer and Exporter in the chemical industry, we supply 50 to 400 metric tons monthly.

Our Silver Mercury is renowned for its 99.999% purity, making it a prime choice for gold mining applications. Meticulously processed, our product ensures optimal results in artisanal and small-scale gold mining. The mercury is expertly mixed with gold-containing materials, forming a mercury-gold amalgam. Upon heating, the mercury vaporizes, leaving behind pure gold.

Country of Origin: Spain. Application: Gold Mining and Gold Extraction. Trust in our monthly supply capacity and benefit from the reliability of Silver Mercury Ltd. Choose from our range, including Virgin Silver Mercury and Spanish Silver Mercury, and enhance your gold extraction processes.',
      192000, 'kg', 1000, 'published', 'b2bmap:silver-mercury')
    returning id into v_prod;
  end if;

  delete from product_specs where product_id = v_prod;
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Brand', '00254786466544', 0);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Country of Origin', 'Spain', 1);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Category', 'Chemicals Chemical Minerals', 2);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Payment Terms', 'CIF', 3);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Packaging Info', '00254786466544', 4);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Listed price', 'USD 52 as listed on b2bmap', 5);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'b2bmap.com — not yet confirmed by the supplier', 6);

  delete from media where product_id = v_prod and kind = 'product';
  insert into media (account_id, product_id, kind, storage_path, caption, approved)
    values (v_acct, v_prod, 'product', 'img/imports/silver-mercury-01.jpeg', 'Spanish Silver Mercury for Gold Mining', true);
  insert into media (account_id, product_id, kind, storage_path, caption, approved)
    values (v_acct, v_prod, 'product', 'img/imports/silver-mercury-02.jpeg', 'Spanish Silver Mercury for Gold Mining', true);
  insert into media (account_id, product_id, kind, storage_path, caption, approved)
    values (v_acct, v_prod, 'product', 'img/imports/silver-mercury-03.jpeg', 'Spanish Silver Mercury for Gold Mining', true);

  insert into account_categories (account_id, category_id)
  values (v_acct, 'chemicals-industrial') on conflict do nothing;
end $$;

-- Sinar GrainPro 6070 - Accurate Grain Moisture Meter
do $$
declare v_acct uuid; v_prod uuid;
begin
  select id into v_acct from accounts where phone = '+256705577823' and role = 'supplier';
  if v_acct is null then raise notice 'supplier missing for sinar-6070'; return; end if;

  select id into v_prod from products where supplier_id = v_acct and import_source = 'b2bmap:sinar-6070';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      status, import_source)
    values (v_acct, 'Sinar GrainPro 6070 - Accurate Grain Moisture Meter', 'agriculture-produce', 'Sinar – Model GrainPro 6070, also known as the Grain Moisture Meter, is a versatile tool designed to accurately measure moisture levels in various grains such as maize, coffee, cocoa, beans, and rice paddy.

Manufactured in Germany, this latest iteration supersedes the Sinar AP6060, offering enhanced sensitivity and reliability. With its portable design, it provides convenience and ease of use for wholesalers seeking precise moisture readings for corn, wheat, rice, beans, and more.

Whether you''re analyzing grain moisture for quality control or optimizing storage conditions, the Sinar GrainPro 6070 ensures efficient and effective operations.',
      2379000, 'unit', 1, 'published', 'b2bmap:sinar-6070')
    returning id into v_prod;
  end if;

  delete from product_specs where product_id = v_prod;
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Country of Origin', 'Germany', 0);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Category', 'Agro & Agriculture Agribusiness', 1);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Payment Terms', 'cash, bank,', 2);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Listed price', 'USD 643 as listed on b2bmap', 3);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'b2bmap.com — not yet confirmed by the supplier', 4);

  delete from media where product_id = v_prod and kind = 'product';
  insert into media (account_id, product_id, kind, storage_path, caption, approved)
    values (v_acct, v_prod, 'product', 'img/imports/sinar-6070-01.jpg', 'Sinar GrainPro 6070 - Accurate Grain Moisture Meter', true);

  insert into account_categories (account_id, category_id)
  values (v_acct, 'agriculture-produce') on conflict do nothing;
end $$;

-- Solar Borehole Water Pump – 180m Lift, Uganda Wholesale Supply
--   Price is a market estimate: the listing said only "Negotiable".
do $$
declare v_acct uuid; v_prod uuid;
begin
  select id into v_acct from accounts where phone = '+256703894856' and role = 'supplier';
  if v_acct is null then raise notice 'supplier missing for solar-borehole'; return; end if;

  select id into v_prod from products where supplier_id = v_acct and import_source = 'b2bmap:solar-borehole';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      status, import_source)
    values (v_acct, 'Solar Borehole Water Pump – 180m Lift, Uganda Wholesale Supply', 'solar-power', 'This 3-inch solar borehole water pump uses a DC brushless motor for quiet, high-efficiency operation. It requires no battery is required, but optional battery use is supported with a charger.

It has MPPT control, dry run protection, and wide voltage support.

For 3 inch solar deep well pump -

SIHIO provides OEM and after-sale services.

FEATURES OF 3 INCH SOLAR BOREHOLE PUMP

FUNCTION OF SIHIO SOLAR BOREHOLE WATER PUMPS

PACKAGE OF SOLAR AC DC POWERED HYBRIDE PERIPHERAL PUMP',
      5550000, 'unit', 1, 'published', 'b2bmap:solar-borehole')
    returning id into v_prod;
  end if;

  delete from product_specs where product_id = v_prod;
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Country of Origin', 'China', 0);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'HS Code', 'WPE-005', 1);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Category', 'Machinery & Industrial Supplies Farming Machinery', 2);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Indicative price', 'USD 1,500 (market estimate, not quoted by the supplier)', 3);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'b2bmap.com — not yet confirmed by the supplier', 4);

  delete from media where product_id = v_prod and kind = 'product';
  insert into media (account_id, product_id, kind, storage_path, caption, approved)
    values (v_acct, v_prod, 'product', 'img/imports/solar-borehole-01.jpg', 'Solar Borehole Water Pump – 180m Lift, Uganda Wholesale Supply', true);
  insert into media (account_id, product_id, kind, storage_path, caption, approved)
    values (v_acct, v_prod, 'product', 'img/imports/solar-borehole-02.png', 'Solar Borehole Water Pump – 180m Lift, Uganda Wholesale Supply', true);

  insert into account_categories (account_id, category_id)
  values (v_acct, 'solar-power') on conflict do nothing;
end $$;

-- Commercial digital TCS platform weighing scales
do $$
declare v_acct uuid; v_prod uuid;
begin
  select id into v_acct from accounts where phone = '+256775259917' and role = 'supplier';
  if v_acct is null then raise notice 'supplier missing for tcs-platform'; return; end if;

  select id into v_prod from products where supplier_id = v_acct and import_source = 'b2bmap:tcs-platform';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      status, import_source)
    values (v_acct, 'Commercial digital TCS platform weighing scales', 'agriculture-produce', 'Our range of industrial scales is very comprehensive and includes Commercial digital TCS platform weighing scales, bench and mechanical platform scales, wet area scales. Accurate Weighing Scales offers the ideal type of digital platform weighing scale for weighing heavy materials. You will find platform weighing scales in industries dealing with maize brand and grains, coffee, cocoa, tea, beans, flour, wheat, barley, and more.',
      2923000, 'unit', 1, 'published', 'b2bmap:tcs-platform')
    returning id into v_prod;
  end if;

  delete from product_specs where product_id = v_prod;
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Country of Origin', 'Spain', 0);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'HS Code', 'TCS', 1);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Category', 'Agro & Agriculture Agribusiness', 2);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Payment Terms', 'cash', 3);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Model Number', 'TCS', 4);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Color', 'Stainless', 5);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Size', '5', 6);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Weight', 'medium', 7);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Style', 'Stainless', 8);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Technology', 'High', 9);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Standard', 'Accurate', 10);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Grade', 'Super', 11);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Listed price', 'USD 790 as listed on b2bmap', 12);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'b2bmap.com — not yet confirmed by the supplier', 13);

  delete from media where product_id = v_prod and kind = 'product';
  insert into media (account_id, product_id, kind, storage_path, caption, approved)
    values (v_acct, v_prod, 'product', 'img/imports/tcs-platform-01.jpg', 'Commercial digital TCS platform weighing scales', true);

  insert into account_categories (account_id, category_id)
  values (v_acct, 'agriculture-produce') on conflict do nothing;
end $$;

-- Unimeter – Model – Grain Moisture Meter
do $$
declare v_acct uuid; v_prod uuid;
begin
  select id into v_acct from accounts where phone = '+256705577823' and role = 'supplier';
  if v_acct is null then raise notice 'supplier missing for unimeter'; return; end if;

  select id into v_prod from products where supplier_id = v_acct and import_source = 'b2bmap:unimeter';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      status, import_source)
    values (v_acct, 'Unimeter – Model – Grain Moisture Meter', 'agriculture-produce', 'The Unimeter Digital has an in-built grinder to give the best moisture measurement results in grain to the User. All of our moisture meters have very high-quality control.

Moisture meters are used for regular moisture measurement during the drying process and while the grain is in storage.

If grains are harvested wetter than necessary, it will result in extra drying costs. Digital moisture meters save you from extra drying costs. Some moisture meters come with an in-built grinder.',
      2757000, 'unit', 1, 'published', 'b2bmap:unimeter')
    returning id into v_prod;
  end if;

  delete from product_specs where product_id = v_prod;
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Country of Origin', 'United Kingdom', 0);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Category', 'Agro & Agriculture Agribusiness', 1);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Payment Terms', 'Cash, bank', 2);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Listed price', 'USD 745 as listed on b2bmap', 3);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'b2bmap.com — not yet confirmed by the supplier', 4);

  delete from media where product_id = v_prod and kind = 'product';
  insert into media (account_id, product_id, kind, storage_path, caption, approved)
    values (v_acct, v_prod, 'product', 'img/imports/unimeter-01.jpg', 'Unimeter – Model – Grain Moisture Meter', true);

  insert into account_categories (account_id, category_id)
  values (v_acct, 'agriculture-produce') on conflict do nothing;
end $$;

-- Wet & Dry Vacuum Cleaner 2400W with 23L Tank for Heavy Use Uganda
--   Price is a market estimate: the listing said only "Negotiable".
do $$
declare v_acct uuid; v_prod uuid;
begin
  select id into v_acct from accounts where phone = '+256703894856' and role = 'supplier';
  if v_acct is null then raise notice 'supplier missing for wet-dry-vac'; return; end if;

  select id into v_prod from products where supplier_id = v_acct and import_source = 'b2bmap:wet-dry-vac';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      status, import_source)
    values (v_acct, 'Wet & Dry Vacuum Cleaner 2400W with 23L Tank for Heavy Use Uganda', 'cleaning-hygiene', 'This vacuum cleaner features a 2400W motor and a 23L stainless steel tank. It works on both wet and dry surfaces. It includes a clip-on system and easy-to-move wheels.

It also has a nozzle for hard-to-reach places. Built for homes, cars, and commercial use.

23L DUST BAG CAPACITY

A capacious container is built into the hoover that collects all the dust and dirt with the easy clip-on system.

Powering on/off and emptying the vacuum cleaner is clean and hassle-free.

And the solid stainless steel tank is durable and of high-quality making it a safe and user-friendly design.

DRY & WET FUNCTION

This function is perfect for drying and wetting of narrow and hard-to-reach areas. You don’t need to change the filter during operation.

The simple operation allows you to work effortlessly and effectively. The vacuum is as such lightweight.

You can take it easy by hand from house to yard. In addition to this, the vacuum has glide wheels.

EASY PARKING NOZZLE

The floor, carpet, bed, sofa, as well as car interiors or small corners, the vacuum cleaner with a perfect nozzle, can easily reach and clean them.

The Easy Parking nozzle is suitable for smooth surfaces, small space, and soft surfaces. And is particularly helpful in cleaning crevices and corners.

HIGH-PERFORMANCE MOTOR

This vacuum is equipped with a 2400W pure copper motor, which can deliver top-line power and performance.

This makes this vacuum easy to clean your automobile, house, van, and workshop anytime, this vac cleaner offers a large capacity of 23L.

You do not need to empty the bucket frequently.',
      925000, 'unit', 1, 'published', 'b2bmap:wet-dry-vac')
    returning id into v_prod;
  end if;

  delete from product_specs where product_id = v_prod;
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Brand', 'Vacuum Cleaner', 0);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Country of Origin', 'Japan', 1);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Category', 'Machinery & Industrial Supplies Apparel & Fashion Machinery & Tools', 2);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Indicative price', 'USD 250 (market estimate, not quoted by the supplier)', 3);
  insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'b2bmap.com — not yet confirmed by the supplier', 4);

  delete from media where product_id = v_prod and kind = 'product';
  insert into media (account_id, product_id, kind, storage_path, caption, approved)
    values (v_acct, v_prod, 'product', 'img/imports/wet-dry-vac-01.jpg', 'Wet & Dry Vacuum Cleaner 2400W with 23L Tank for Heavy Use Uganda', true);
  insert into media (account_id, product_id, kind, storage_path, caption, approved)
    values (v_acct, v_prod, 'product', 'img/imports/wet-dry-vac-02.jpg', 'Wet & Dry Vacuum Cleaner 2400W with 23L Tank for Heavy Use Uganda', true);

  insert into account_categories (account_id, category_id)
  values (v_acct, 'cleaning-hygiene') on conflict do nothing;
end $$;

commit;

-- ─────────────────────────────────────────────── check
select a.company, a.phone, count(p.id) as listings
from accounts a left join products p on p.supplier_id = a.id
where a.import_source = 'b2bmap'
group by a.company, a.phone order by a.company;

-- ─────────────────────────────────────────────── undo
-- Removes everything this file created and nothing else.
--
-- delete from products where import_source like 'b2bmap:%';
-- delete from auth.users where email like '%@suppliers.bubu.market';
-- delete from accounts where import_source = 'b2bmap';

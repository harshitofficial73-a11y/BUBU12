-- BUBU.Market · Africa2Trust import, part 5 of 6
-- 15 suppliers. Run the parts in order; each one is safe to re-run.
-- READ-ME-FIRST.txt explains the prices and the photographs.
--
--   Robjose Electricals
--   Sure Power Supplies Ltd
--   Fire Masters Ltd
--   Britania Allied Industries Limited (BAIL)
--   Century Bottling Company Ltd., (Coca Cola)
--   Crown Beverages Ltd
--   Martyrs Coffee Limited
--   Mukwano Group
--   Yo Kuku
--   YALELO Uganda
--   Bidco Uganda Limited
--   AVION UGANDA
--   Biva Organic
--   GREEN WORLD INTERNATIONAL UGANDA LIMITED.
--   Rene Industries

begin;

create extension if not exists pgcrypto;
alter table accounts add column if not exists import_source text;
alter table products add column if not exists import_source text;

-- Robjose Electricals · +256757697122256757697121256702439244 · 18 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'robjose-electricals@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'robjose-electricals@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256757697122256757697121256702439244' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'trader', 'free', 'Robjose Electricals', 'Robjose Electricals',
      'RE', '+256757697122256757697121256702439244', null, '+256757697122256757697121256702439244', 'robjose-electricals@suppliers.bubu.market',
      '4, Duster st. shop, Central, Kampala', 'kampala', 'electronics', 'Robjose Electricals supplies electronics from Kampala. 18 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Robjose Electricals supplies electronics from Kampala. 18 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'electronics') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/3%20phase.jpg', 'Robjose Electricals — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = '3 Phase HRC Isolators UK';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, '3 Phase HRC Isolators UK', 'electronics', 'Three Phase TPN Fuse Switch Disconnector 100A 415V MEM 100KXTNC2F Three Phase TPN 100A 415V Fuse Switch Disconnector with surface-mounting enclosure fabricated from rust-protected sheet steel with a light grey paint finish. Supplied with removable top and bottom endplates incorporating knockouts (blank endplates available) and gasketed doors giving IP41 protection. Chromium-plated front operating handles with ON (I) OFF (O) indication, and internal fixing enabling units to be mounted closely side by side. Exel2 switch disconnectors and fuse-switch-disconnectors are type tested to BSEN60947-3 and meet the constructional requirements for isolation as speciifed in BSEN60947-3. Switches are of the quick make and break type, suitable for use on AC or DC. Units have removable moving contact assemblies to facilitate wiring. Interiors comprise porcelain bases fitted with non-ferrous conducting… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 85000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/3%20phase.jpg', '3 Phase HRC Isolators UK', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/3+phase.jpg', '3 Phase HRC Isolators UK', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/pvc+box.jpg', '3 Phase HRC Isolators UK', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'AKG Three way Junction Box 50 MM';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'AKG Three way Junction Box 50 MM', 'electronics', 'AKG Three way Junction Box 50 MM Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 145000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/pvc%20box.jpg', 'AKG Three way Junction Box 50 MM', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/3+phase.jpg', 'AKG Three way Junction Box 50 MM', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/pvc+box.jpg', 'AKG Three way Junction Box 50 MM', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Cable Ties';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Cable Ties', 'electronics', 'A cable tie or tie-wrap, also known as a hose tie, zip tie, zap strap, or Panduit strap, is a type of fastener, for holding items together, primarily electric cables or wires. Because of their low cost and ease of use, tie-wraps are ubiquitous, finding use in a wide range of other applications. Stainless steel versions, either naked or coated with a rugged plastic, cater for exterior applications and hazardous environments Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 8500, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/cable%20ties.jpg', 'Cable Ties', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/3+phase.jpg', 'Cable Ties', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/pvc+box.jpg', 'Cable Ties', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Cooper Tape Arrestors';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Cooper Tape Arrestors', 'electronics', 'Copper tape has countless applications in electronics from creating low-profile traces for electrical components to RF-shielding and antenna-making. Copper tape is even used to join things together using solder, this copper tape is adhesive-backed, comes in rolls of feet Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 145000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/copper%20tape.jpg', 'Cooper Tape Arrestors', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/3+phase.jpg', 'Cooper Tape Arrestors', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/pvc+box.jpg', 'Cooper Tape Arrestors', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Decoration Switches And Sockets';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Decoration Switches And Sockets', 'electronics', 'decorative light switches are available in a huge range of finishes so you can find the product which suits your style perfectly. light switches and sockets in stainless steel, polished chrome, pearl nickel, black nickel, antique brass, satin brass, polished brass and Georgian cast brass, with a choice of black or white inserts. If you’re not sure what the best product is for the job at hand, our friendly sales team is here to help. Just give them Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 85000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/dec%20switches%20.jpg', 'Decoration Switches And Sockets', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/3+phase.jpg', 'Decoration Switches And Sockets', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/pvc+box.jpg', 'Decoration Switches And Sockets', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'D-link data cable category 6';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'D-link data cable category 6', 'electronics', 'Specifications: Type: Cat6 Number of Conductor: 8 Conductor Diameter: 0.57mm Cross: PE Insulation: HDPE Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 38000, 'length', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/dlink.jpg', 'D-link data cable category 6', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/3+phase.jpg', 'D-link data cable category 6', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/pvc+box.jpg', 'D-link data cable category 6', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'D-link Data Sockets';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'D-link Data Sockets', 'electronics', 'D-link Data Sockets Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 145000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/data%20sockets.jpg', 'D-link Data Sockets', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/3+phase.jpg', 'D-link Data Sockets', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/pvc+box.jpg', 'D-link Data Sockets', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Fiber optic patch cord';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Fiber optic patch cord', 'electronics', 'Featrues: Various connector type available Low back reflection loss Compact size Low insertion loss High Return Loss Diameter Φ0.9mm, Φ2.0mm, Φ3.0mm Fiber Available Single-mode Fiber or Multi-mode Fiber Available (For Simplex or Duplex) Applitcation: CATV System Telecommunications Optical Networks FTTH (Fiber to the Home) High speed transmission Systems Testing instruments Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 250000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/patch%20cords.jpg', 'Fiber optic patch cord', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/3+phase.jpg', 'Fiber optic patch cord', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/pvc+box.jpg', 'Fiber optic patch cord', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Flood Lights';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Flood Lights', 'electronics', 'Bright & Energy Effivient: 14500 lumen, great replacement for 400W traditional HPS lamp, saving over 60% on your electricity bill Wide Beam Angle: 120° beam angle, no shadow or glare, providing great bright light Durable: By adopting qualified aluminum material, this flood light has excellent heat dissipation, making it more durable Flexible Installation with the metal bracket, it can be ceiling-mounted, wall-mounted, and ground-mounted. The lamp body is 150° adjustable Widely Used: With IP65 rating, this adjustable floodlight can be widely used in outdoor and indoor lighting projects, including billboards, show windows, gardens, warehouses and security lighting Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 32000, 'bag', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/floodlights.jpg', 'Flood Lights', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/3+phase.jpg', 'Flood Lights', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/pvc+box.jpg', 'Flood Lights', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'industrial generator sockets';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'industrial generator sockets', 'electronics', 'Industrial plug and socket, connector is a new generation connector appratus for power connecting, has the features such as security & reliability.They are used widly in the place such as steel smelt, petrochemical processing, electric power, electronic, railway, building ground, airport, mine Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 4500000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/ind%20gen%20socs.jpg', 'industrial generator sockets', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/3+phase.jpg', 'industrial generator sockets', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/pvc+box.jpg', 'industrial generator sockets', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'LED LIGHTS';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'LED LIGHTS', 'electronics', 'An LED lamp is a light-emitting diode (LED) product which is assembled into a lamp (or light bulb) for use in lighting fixtures Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 22000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/led%20lights.jpg', 'LED LIGHTS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/3+phase.jpg', 'LED LIGHTS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/pvc+box.jpg', 'LED LIGHTS', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'LED Pendants Lights';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'LED Pendants Lights', 'electronics', 'Pendant and hanging lights add a touch of class to any interior design. Add atmosphere to your home or restaurant Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 22000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/IMG-20161209-WA0006.jpg', 'LED Pendants Lights', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/3+phase.jpg', 'LED Pendants Lights', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/pvc+box.jpg', 'LED Pendants Lights', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'metal clad switches and sockets';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'metal clad switches and sockets', 'electronics', 'This Metal Clad series is a heavy duty range of switches and sockets finished in a durable powder coated metal clad finish. Fully certified to latest British Standards. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 145000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/metal%20clad.jpg', 'metal clad switches and sockets', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/3+phase.jpg', 'metal clad switches and sockets', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/pvc+box.jpg', 'metal clad switches and sockets', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Patch Panels';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Patch Panels', 'electronics', 'These panels are robust and easy to install, providing double the density of a standard 1U patch panel. The built-in rear cable management design enables each cable to be securely fixed to the back of the panel. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 145000, 'roll', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/patch%20panel.jpg', 'Patch Panels', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/3+phase.jpg', 'Patch Panels', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/pvc+box.jpg', 'Patch Panels', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Power Extensions';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Power Extensions', 'electronics', 'Power Extensions Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 145000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/power%20extension.jpg', 'Power Extensions', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/3+phase.jpg', 'Power Extensions', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/pvc+box.jpg', 'Power Extensions', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Single Core Cables';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Single Core Cables', 'electronics', 'Single Core Cables are harmonised approved PVC cables for use in internal wiring of devices or for conduit or trunking wiring Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 38000, 'length', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/rsz_img-20161209-wa0002.jpg', 'Single Core Cables', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/3+phase.jpg', 'Single Core Cables', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/pvc+box.jpg', 'Single Core Cables', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Twin Earth Cables';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Twin Earth Cables', 'electronics', 'Twin and earth cable comprises two individually insulated current carrying conductors and an uninsulated circuit protective conductor. Twin & Earth cable is the most common cable used for domestic wiring today. The sheath is either grey (PVC) or white for low smoke cables (OHLS) Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 145000, 'roll', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/twin%20earth%20cables.jpg', 'Twin Earth Cables', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/3+phase.jpg', 'Twin Earth Cables', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/pvc+box.jpg', 'Twin Earth Cables', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Wall bracket lights';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Wall bracket lights', 'electronics', 'Subtly stylish and practical, wall lights provide a decorative illumination to your interior, as well as safely lighting hallways, staircases and exteriors Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 320000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/wall%20bracket%20lights.jpg', 'Wall bracket lights', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/3+phase.jpg', 'Wall bracket lights', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/pvc+box.jpg', 'Wall bracket lights', true);
  end if;
end $$;

-- Sure Power Supplies Ltd · +256703383005256393112477 · 7 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'sure-power-supplies-ltd@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'sure-power-supplies-ltd@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256703383005256393112477' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'trader', 'free', 'Sure Power Supplies Ltd', 'Sure Power Supplies Ltd',
      'SP', '+256703383005256393112477', null, '+256703383005256393112477', 'sure-power-supplies-ltd@suppliers.bubu.market',
      '-, Energy Center, Shop No.L2 47-48, Central, Kampala', 'kampala', 'electronics', 'Sure Power Supplies Ltd supplies electronics from Kampala. 7 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Sure Power Supplies Ltd supplies electronics from Kampala. 7 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'electronics') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/earthing.jpg', 'Sure Power Supplies Ltd — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Earth rods';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Earth rods', 'electronics', 'At Sure Power Supplies Limited, we deal with the following products - Electrical materials,Cable Management Solutions,Electrical,Solar,Back up Systems( inverters, batteries..etc),Fire Protection(Fire extinguishers,smoke detectors,fire panels,heat detectors..etc) & Net working solutions. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 620000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/earthing.jpg', 'Earth rods', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/cables.jpg', 'Earth rods', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/inverters.jpg', 'Earth rods', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Electrical Cables';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Electrical Cables', 'electronics', 'At Sure Power Supplies Limited, we deal with the following products - Electrical materials,Cable Management Solutions,Electrical,Solar,Back up Systems( inverters, batteries..etc),Fire Protection(Fire extinguishers,smoke detectors,fire panels,heat detectors..etc) & Net working solutions Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 620000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/cables.jpg', 'Electrical Cables', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/earthing.jpg', 'Electrical Cables', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/inverters.jpg', 'Electrical Cables', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Inverters';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Inverters', 'electronics', 'At Sure Power Supplies Limited, we deal with the following products - Electrical materials,Cable Management Solutions,Electrical,Solar,Back up Systems( inverters, batteries..etc),Fire Protection(Fire extinguishers,smoke detectors,fire panels,heat detectors..etc) & Net working solutions Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 620000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/inverters.jpg', 'Inverters', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/earthing.jpg', 'Inverters', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/cables.jpg', 'Inverters', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Lights';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Lights', 'electronics', 'At Sure Power Supplies Limited, we deal with the following products - Electrical materials,Cable Management Solutions,Electrical,Solar,Back up Systems( inverters, batteries..etc),Fire Protection(Fire extinguishers,smoke detectors,fire panels,heat detectors..etc) & Net working solutions. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 620000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/lights.jpg', 'Lights', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/earthing.jpg', 'Lights', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/cables.jpg', 'Lights', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Patch Panels';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Patch Panels', 'electronics', 'At Sure Power Supplies Limited, we deal with the following products - Electrical materials,Cable Management Solutions,Electrical,Solar,Back up Systems( inverters, batteries..etc),Fire Protection(Fire extinguishers,smoke detectors,fire panels,heat detectors..etc) & Net working solutions. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 620000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/patch%20panel.jpg', 'Patch Panels', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/earthing.jpg', 'Patch Panels', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/cables.jpg', 'Patch Panels', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Ridge Saddles';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Ridge Saddles', 'electronics', 'At Sure Power Supplies Limited, we deal with the following products - Electrical materials,Cable Management Solutions,Electrical,Solar,Back up Systems( inverters, batteries..etc),Fire Protection(Fire extinguishers,smoke detectors,fire panels,heat detectors..etc) & Net working solutions Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 620000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/ridge.jpg', 'Ridge Saddles', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/earthing.jpg', 'Ridge Saddles', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/cables.jpg', 'Ridge Saddles', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Solar Panels';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Solar Panels', 'electronics', 'At Sure Power Supplies Limited, we deal with the following products - Electrical materials,Cable Management Solutions,Electrical,Solar,Back up Systems( inverters, batteries..etc),Fire Protection(Fire extinguishers,smoke detectors,fire panels,heat detectors..etc) & Net working solutions Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 620000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/solsys.jpg', 'Solar Panels', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/earthing.jpg', 'Solar Panels', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/cables.jpg', 'Solar Panels', true);
  end if;
end $$;

-- Fire Masters Ltd · +256414258912+256750073014+256393278750 · 3 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'fire-masters-ltd@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'fire-masters-ltd@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256414258912+256750073014+256393278750' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'trader', 'free', 'Fire Masters Ltd', 'Fire Masters Ltd',
      'FM', '+256414258912+256750073014+256393278750', null, '+256414258912+256750073014+256393278750', 'fire-masters-ltd@suppliers.bubu.market',
      'Plot 101 Prince Kakungulu Road, Kibuli Box 3887 Kampala, ., Central, Kampala', 'kampala', 'electronics', 'Fire Masters Ltd supplies electronics from Kampala. 3 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Fire Masters Ltd supplies electronics from Kampala. 3 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'electronics') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Prod-_24756_65393122.jpg', 'Fire Masters Ltd — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Carbon dioxide Extinguisher';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Carbon dioxide Extinguisher', 'electronics', 'Agent displaces oxygen (CO2 or inert gases), removes heat from the combustion zone (Halotron, FE-36) or inhibits chemical chain reaction (Halons). They are labelled clean agents because they do not leave any residue after discharge which is ideal for sensitive electronics and documents. CARBON DIOXIDE FIRE EXTIGUISHER HAVE CLASSES: B,C CLASS B: Liquid fuels and gasses CLASS C: Electrical Fires SIZES:2KG, 2.5KG, 5KG, 10KG NOTE: Always blue indicates powder portable equipment Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 145000, 'cylinder', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_24756_65393122.jpg', 'Carbon dioxide Extinguisher', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_24756_65394052.jpg', 'Carbon dioxide Extinguisher', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_24756_65393630.jpg', 'Carbon dioxide Extinguisher', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Dry chemical powder extinguisher';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Dry chemical powder extinguisher', 'electronics', 'This is a powder based agent that extinguishes by separating the four parts of the fire tetrahedron. It prevents the chemical reaction involving heat, fuel, and oxygen and halts the production of fire sustaining "free-radicals", thus extinguishing the fire. DRY CHEMICAL POWDER FIRE EXTIGUISHER HAVE CLASSES: A,B & C CLASS A: Ordinary Fires involving wood, paper & textiles CLASS B: Liquid fuels and gasses CLASS C: Electrical Fires SIZES: 1KG, 2KG, 6KG, 9KG. NOTE: Always blue indicates powder portable equipment Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 145000, 'cylinder', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_24756_65394052.jpg', 'Dry chemical powder extinguisher', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_24756_65393122.jpg', 'Dry chemical powder extinguisher', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_24756_65393630.jpg', 'Dry chemical powder extinguisher', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Dry Powder chemical Fire extinguisher (Automatic)';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Dry Powder chemical Fire extinguisher (Automatic)', 'electronics', 'Dry powder chemical Fire extinguisher Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 145000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_24756_65393630.jpg', 'Dry Powder chemical Fire extinguisher (Automatic)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_24756_65393122.jpg', 'Dry Powder chemical Fire extinguisher (Automatic)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_24756_65394052.jpg', 'Dry Powder chemical Fire extinguisher (Automatic)', true);
  end if;
end $$;

-- Britania Allied Industries Limited (BAIL) · +256414332100101 · 5 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'britania-allied-industries-limited-bail@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'britania-allied-industries-limited-bail@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256414332100101' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'manufacturer', 'free', 'Britania Allied Industries Limited (BAIL)', 'Britania Allied Industries Limited (BAIL)',
      'BA', '+256414332100101', null, '+256414332100101', 'britania-allied-industries-limited-bail@suppliers.bubu.market',
      'Plot M247B Ntinda Industrial Area,, Central, Kampala', 'kampala', 'food and beverages', 'Britania Allied Industries Limited (BAIL) supplies food and beverages from Kampala. 5 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Britania Allied Industries Limited (BAIL) supplies food and beverages from Kampala. 5 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'food-beverage') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Prod-_14744_656201653.jpg', 'Britania Allied Industries Limited (BAIL) — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Ladid Nectar Juice';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Ladid Nectar Juice', 'food-beverage', 'Available in pack size 12pkts X 1ltr and in three varieties; Mango, Guava & Fruit Cocktail. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 28000, 'crate', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14744_656201653.jpg', 'Ladid Nectar Juice', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14744_65620391.jpg', 'Ladid Nectar Juice', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14744_65620421.jpg', 'Ladid Nectar Juice', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Splash';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Splash', 'food-beverage', 'Splash Pure refreshing fruit Juice made from selected high quality tropical fruits of Uganda. Splash available in: Mango, Orange, Apple, Pineapple, Pinacolada, Guava, Tropical fruit Punch, Fruit cocktail, and simply Hibi. Splash is available in 150ml, 250ml and 1 Litre.Pack Sizes 18pkts X 150mls/carton 24pkts X 250mls/tray or 96pkts X 250mls/carton 12pkts X 1ltr /tray or 24pkts X 1ltr/Carton Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 28000, 'crate', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14744_65620421.jpg', 'Splash', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14744_656201653.jpg', 'Splash', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14744_65620391.jpg', 'Splash', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Top Up Tomato Sauce';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Top Up Tomato Sauce', 'food-beverage', 'Top-up is the brand name for our sauces made from fresh garden tomatoes, chillies, and garlic; These however come in the form of tomato sauces, chili sauces, Peri Peri, hot ’n’ sweet, and chili garlic and are in varied taste, sizes and prices. Pack sizes Tomato 4 Jerricans X 5kg/Carton Tomato 12 Bottles X 700mls/Carton Tomato 24 Bottles X 400gms/Carton Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 12000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14744_656203115.jpg', 'Top Up Tomato Sauce', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14744_656201653.jpg', 'Top Up Tomato Sauce', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14744_65620391.jpg', 'Top Up Tomato Sauce', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Yo-Jus';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Yo-Jus', 'food-beverage', 'Fresh fruit Juice. Packed in an attractive and affordable Kids size 150mls X 18pkts/ctn and 36pkts/ctn. Easy family and Economy school pack; Convenient in handling and use with a ready “straw applicator”. Available in Mango, Apple, Pineapple and Blackcurrant. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 28000, 'crate', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14744_656202456.jpg', 'Yo-Jus', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14744_656201653.jpg', 'Yo-Jus', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14744_65620391.jpg', 'Yo-Jus', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Food products - Premium Biscuits';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Food products - Premium Biscuits', 'food-beverage', 'ATC Premium Biscuits available in Nice, Shortcake, Coco Bite, Family, Marie, Morning Coffee and Petit Beurre. Pack size 25pkts X 200g/Carton Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 12000, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14744_65620391.jpg', 'Food products - Premium Biscuits', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14744_656201653.jpg', 'Food products - Premium Biscuits', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14744_65620421.jpg', 'Food products - Premium Biscuits', true);
  end if;
end $$;

-- Century Bottling Company Ltd., (Coca Cola) · +2560312236500+2560414288415 · 1 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'century-bottling-company-ltd-coca-cola@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'century-bottling-company-ltd-coca-cola@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+2560312236500+2560414288415' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'manufacturer', 'free', 'Century Bottling Company Ltd., (Coca Cola)', 'Century Bottling Company Ltd., (Coca Cola)',
      'CB', '+2560312236500+2560414288415', null, '+2560312236500+2560414288415', 'century-bottling-company-ltd-coca-cola@suppliers.bubu.market',
      'Namanve, Kampala, Kampala, Uganda., ., Central, Kampala', 'kampala', 'food and beverages', 'Century Bottling Company Ltd., (Coca Cola) supplies food and beverages from Kampala. 1 line is listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Century Bottling Company Ltd., (Coca Cola) supplies food and beverages from Kampala. 1 line is listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'food-beverage') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Prod-_21064_702113856.jpg', 'Century Bottling Company Ltd., (Coca Cola) — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Coca cola';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Coca cola', 'food-beverage', 'With our heavy reliance on natural ingredients we are acutely aware of reducing our key consumption metrics and working with the communities in which we operate to mitigate the global environmental risks to us all Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 12000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_21064_702113856.jpg', 'Coca cola', true);
  end if;
end $$;

-- Crown Beverages Ltd · +2560312343219+25603123431004 · 2 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'crown-beverages-ltd@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'crown-beverages-ltd@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+2560312343219+25603123431004' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'manufacturer', 'free', 'Crown Beverages Ltd', 'Crown Beverages Ltd',
      'CB', '+2560312343219+25603123431004', null, '+2560312343219+25603123431004', 'crown-beverages-ltd@suppliers.bubu.market',
      'Kampala, Uganda, Plot M214 Jinja Road, Nakawa Industrial Area, Kampala, Nakawa, Kampala', 'kampala', 'food and beverages', 'Crown Beverages Ltd supplies food and beverages from Kampala. 2 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Crown Beverages Ltd supplies food and beverages from Kampala. 2 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'food-beverage') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Crown-Banner.png', 'Crown Beverages Ltd — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Nivana water';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Nivana water', 'food-beverage', 'Nivana water was created to make quality tasting packed drinking water accessible to everyone at very affordable prices. Today Nivana is provided in a range of conveniently sized on- the-go formats that fit in your bag, to jumbo sized bottle that fulfils your home and office needs Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 28000, 'crate', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3482_702111415.png', 'Nivana water', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3482_702112421.png', 'Nivana water', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Pepsi';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Pepsi', 'food-beverage', 'The world’s best tasting cola was created in 1893 and brought to the Ugandan market in the 1990s. In a world that is alive with new possibilities but sometimes hard to escape conventions routines and expectations, Pepsi gives you the fizz to break out and discover the new, for the love of it. Enjoy it at home, with friends, with meals or on the go. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 12000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3482_702112421.png', 'Pepsi', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3482_702111415.png', 'Pepsi', true);
  end if;
end $$;

-- Martyrs Coffee Limited · +256701967138+256785023702+256785023702 · 4 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'martyrs-coffee-limited@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'martyrs-coffee-limited@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256701967138+256785023702+256785023702' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'manufacturer', 'free', 'Martyrs Coffee Limited', 'Martyrs Coffee Limited',
      'MC', '+256701967138+256785023702+256785023702', null, '+256701967138+256785023702+256785023702', 'martyrs-coffee-limited@suppliers.bubu.market',
      'Sentema, Kakiri sub county, Wakiso District, Uganda, East Africa, Wakiso, Uganda, Kakiri, Wakiso', 'wakiso', 'food and beverages', 'Martyrs Coffee Limited supplies food and beverages from Wakiso. 4 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Martyrs Coffee Limited supplies food and beverages from Wakiso. 4 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'food-beverage') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/marty_260710081722171_001.jpg', 'Martyrs Coffee Limited — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Martyrs Coffee 100g – Premium Ugandan Ground Coffee';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Martyrs Coffee 100g – Premium Ugandan Ground Coffee', 'food-beverage', 'Premium Ugandan Ground Coffee Martyrs Coffee 100g Premium Ground Coffee (Coffee Powder) • Freshly Roasted • Professionally Packaged Rich Ugandan Coffee in Every Cup Martyrs Coffee 100g is a premium ground coffee produced from carefully selected Ugandan Arabica and Robusta coffee beans. Expertly roasted and finely ground, it delivers a rich aroma, smooth taste, and full-bodied coffee experience that reflects the quality of Uganda''s world-renowned coffee. Professionally packaged in a convenient 250-gram pack, this coffee is ideal for daily enjoyment at home, in the office, cafés, restaurants, and hospitality establishments. Every pack celebrates Uganda''s rich coffee heritage while honoring the resilience, courage, and inspiration behind the Martyrs Coffee brand. Product Features Premium Ugandan ground coffee Made from carefully selected Arabica and Robusta beans Professionally roasted for…', 10000, 'gm', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/89083_100g_20260711061424.jpg', 'Martyrs Coffee 100g – Premium Ugandan Ground Coffee', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/89083_20gm_20260711054039.jpg', 'Martyrs Coffee 100g – Premium Ugandan Ground Coffee', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/89083_250g_20260710101034.jpg', 'Martyrs Coffee 100g – Premium Ugandan Ground Coffee', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Martyrs Coffee 20g – Premium Ugandan Ground Coffee';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Martyrs Coffee 20g – Premium Ugandan Ground Coffee', 'food-beverage', 'Premium Ugandan Ground Coffee Martyrs Coffee 20g Premium Ground Coffee (Coffee Powder) • Freshly Roasted • Professionally Packaged Rich Ugandan Coffee in Every Cup Martyrs Coffee 20g is a premium ground coffee produced from carefully selected Ugandan Arabica and Robusta coffee beans. Expertly roasted and finely ground, it delivers a rich aroma, smooth taste, and full-bodied coffee experience that reflects the quality of Uganda''s world-renowned coffee. Professionally packaged in a convenient 250-gram pack, this coffee is ideal for daily enjoyment at home, in the office, cafés, restaurants, and hospitality establishments. Every pack celebrates Uganda''s rich coffee heritage while honoring the resilience, courage, and inspiration behind the Martyrs Coffee brand. Product Features Premium Ugandan ground coffee Made from carefully selected Arabica and Robusta beans Professionally roasted for…', 2000, 'gm', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/89083_20gm_20260711054039.jpg', 'Martyrs Coffee 20g – Premium Ugandan Ground Coffee', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/89083_100g_20260711061424.jpg', 'Martyrs Coffee 20g – Premium Ugandan Ground Coffee', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/89083_250g_20260710101034.jpg', 'Martyrs Coffee 20g – Premium Ugandan Ground Coffee', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Martyrs Coffee 250g – Premium Ugandan Ground Coffee';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Martyrs Coffee 250g – Premium Ugandan Ground Coffee', 'food-beverage', 'Premium Ugandan Ground Coffee Martyrs Coffee 250g Premium Ground Coffee (Coffee Powder) • Freshly Roasted • Professionally Packaged Rich Ugandan Coffee in Every Cup Martyrs Coffee 250g is a premium ground coffee produced from carefully selected Ugandan Arabica and Robusta coffee beans. Expertly roasted and finely ground, it delivers a rich aroma, smooth taste, and full-bodied coffee experience that reflects the quality of Uganda''s world-renowned coffee. Professionally packaged in a convenient 250-gram pack, this coffee is ideal for daily enjoyment at home, in the office, cafés, restaurants, and hospitality establishments. Every pack celebrates Uganda''s rich coffee heritage while honoring the resilience, courage, and inspiration behind the Martyrs Coffee brand. Product Features Premium Ugandan ground coffee Made from carefully selected Arabica and Robusta beans Professionally roasted for…', 15000, 'gm', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/89083_250g_20260710101034.jpg', 'Martyrs Coffee 250g – Premium Ugandan Ground Coffee', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/89083_100g_20260711061424.jpg', 'Martyrs Coffee 250g – Premium Ugandan Ground Coffee', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/89083_20gm_20260711054039.jpg', 'Martyrs Coffee 250g – Premium Ugandan Ground Coffee', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Martyrs Coffee 50g – Premium Ugandan Ground Coffee';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Martyrs Coffee 50g – Premium Ugandan Ground Coffee', 'food-beverage', 'Premium Ugandan Ground Coffee Martyrs Coffee 50g Premium Ground Coffee (Coffee Powder) • Freshly Roasted • Professionally Packaged Rich Ugandan Coffee in Every Cup Martyrs Coffee 50g is a premium ground coffee produced from carefully selected Ugandan Arabica and Robusta coffee beans. Expertly roasted and finely ground, it delivers a rich aroma, smooth taste, and full-bodied coffee experience that reflects the quality of Uganda''s world-renowned coffee. Professionally packaged in a convenient 250-gram pack, this coffee is ideal for daily enjoyment at home, in the office, cafés, restaurants, and hospitality establishments. Every pack celebrates Uganda''s rich coffee heritage while honoring the resilience, courage, and inspiration behind the Martyrs Coffee brand. Product Features Premium Ugandan ground coffee Made from carefully selected Arabica and Robusta beans Professionally roasted for…', 500, 'gm', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/89083_50gm_20260711054922.jpg', 'Martyrs Coffee 50g – Premium Ugandan Ground Coffee', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/89083_100g_20260711061424.jpg', 'Martyrs Coffee 50g – Premium Ugandan Ground Coffee', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/89083_20gm_20260711054039.jpg', 'Martyrs Coffee 50g – Premium Ugandan Ground Coffee', true);
  end if;
end $$;

-- Mukwano Group · +256414313313+2563123132000800200070 · 2 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'mukwano-group@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'mukwano-group@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256414313313+2563123132000800200070' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'manufacturer', 'free', 'Mukwano Group', 'Mukwano Group',
      'MG', '+256414313313+2563123132000800200070', null, '+256414313313+2563123132000800200070', 'mukwano-group@suppliers.bubu.market',
      'Plot 30, Mukwano Road, Namuwongo, Kampala', 'kampala', 'food and beverages', 'Mukwano Group supplies food and beverages, cleaning and personal care from Kampala. 2 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Mukwano Group supplies food and beverages, cleaning and personal care from Kampala. 2 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'food-beverage') on conflict do nothing;
  insert into account_categories (account_id, category_id) values (v_acct, 'cleaning-hygiene') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Prod-_613_701124343.png', 'Mukwano Group — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'AQUA SIPI PACKAGED DRINKING WATER';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'AQUA SIPI PACKAGED DRINKING WATER', 'food-beverage', 'AQUA SIPI packaged drinking water-AQUA SIPI Packaged Drinking Water has become a household name in Uganda and the East African region since hitting the shelves in2006. Bottled in an ultra-modern automated plant, AQUA SIPI was the first bottled water in Uganda to receive the ISO 22000 Quality and Food Safety Management Certification and conforms to Uganda National Bureau of Standards (UNBS) Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 28000, 'crate', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_613_701124343.png', 'AQUA SIPI PACKAGED DRINKING WATER', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_613_701125221.png', 'AQUA SIPI PACKAGED DRINKING WATER', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Sunseed Sunflower Premium Cooking Oil';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Sunseed Sunflower Premium Cooking Oil', 'cleaning-hygiene', 'Sunseed Sunflower Premium Cooking Oil -Is ultra-refined 100% local Ugandan Sunflower oil, which is rich in vitamin E, low in saturated fat, and cholesterol-free. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 25000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_613_701125221.png', 'Sunseed Sunflower Premium Cooking Oil', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_613_701124343.png', 'Sunseed Sunflower Premium Cooking Oil', true);
  end if;
end $$;

-- Yo Kuku · +256792780780+256792782782 · 1 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'yo-kuku@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'yo-kuku@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256792780780+256792782782' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'manufacturer', 'free', 'Yo Kuku', 'Yo Kuku',
      'YK', '+256792780780+256792782782', null, '+256792780780+256792782782', 'yo-kuku@suppliers.bubu.market',
      '243, Kira Road, bukoto, Kampala', 'kampala', 'food and beverages', 'Yo Kuku supplies food and beverages from Kampala. 1 line is listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Yo Kuku supplies food and beverages from Kampala. 1 line is listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'food-beverage') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/product.jpg', 'Yo Kuku — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Food products - Chicken parts';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Food products - Chicken parts', 'food-beverage', 'Our superior cold storage process ensures that the chicken that reaches our customer is fresh and of the best quality. We run our own transport department that covers both chilled and frozen distribution. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 6800, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/product.jpg', 'Food products - Chicken parts', true);
  end if;
end $$;

-- YALELO Uganda · +256779319996 · 1 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'yalelo-uganda@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'yalelo-uganda@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256779319996' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'manufacturer', 'free', 'YALELO Uganda', 'YALELO Uganda',
      'YU', '+256779319996', null, '+256779319996', 'yalelo-uganda@suppliers.bubu.market',
      'Kampala - Uganda, Kyonoonya market centre , Kaleerwe opposite Bidda electronics, Central, Kampala', 'kampala', 'food and beverages', 'YALELO Uganda supplies food and beverages from Kampala. 1 line is listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'YALELO Uganda supplies food and beverages from Kampala. 1 line is listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'food-beverage') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Prod-_22002_70111816.jpg', 'YALELO Uganda — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Meat and Dairy products - Whole Round Fish';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Meat and Dairy products - Whole Round Fish', 'food-beverage', 'Whole Round Fish 450g-1kg 5-6 Days 0-2ºC Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 12000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_22002_70111816.jpg', 'Meat and Dairy products - Whole Round Fish', true);
  end if;
end $$;

-- Bidco Uganda Limited · +256434124200 · 5 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'bidco-uganda-limited@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'bidco-uganda-limited@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256434124200' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'manufacturer', 'free', 'Bidco Uganda Limited', 'Bidco Uganda Limited',
      'BU', '+256434124200', null, '+256434124200', 'bidco-uganda-limited@suppliers.bubu.market',
      'P O Box 1136, Masese, Jinja - Uganda, Plot No-152/M, Massese Industrial Area, Jinja, Central, Jinja', 'jinja', 'cleaning and personal care', 'Bidco Uganda Limited supplies cleaning and personal care from Jinja. 5 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Bidco Uganda Limited supplies cleaning and personal care from Jinja. 5 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'cleaning-hygiene') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Prod-_14747_65794612.jpg', 'Bidco Uganda Limited — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Fortune Butto';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Fortune Butto', 'cleaning-hygiene', 'The is a pure, healthy, nourishing and affordable vegetable cooking oil. It is available in sachets and can be found in any outlet. Why use Fortune Butto Contains natural Vitamin E. It is made purely from vegetable oil Does not smoke or burn and can be used for repeated frying. Enhances the natural flavors of food. Suitable for deep frying. Fortune Butto is available in 50 ml, 100 ml, 200 ml, 500 ml and 1 Litre sachets. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 9500, 'litre', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14747_65794612.jpg', 'Fortune Butto', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14747_65785146.jpg', 'Fortune Butto', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14747_65793025.jpg', 'Fortune Butto', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Fortune Cooking Oil';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Fortune Cooking Oil', 'cleaning-hygiene', 'This 100% triple refined vegetable Oil is one of the most competitive oils in East and Central Africa. It is economical and has superior frying performance for both deep and shallow frying. Why use Fortune Cooking Oil It is made purely from vegetable oil Contains natural Vitamin E. Medically proven to lower total blood cholesterol levels Does not smoke or burn, has a long shelf life and can be used for repeated frying. Food fried in Golen fry lasts fresher longer as it has a very high oxidative stability Enhances the natural flavors of food. Suitable for deep frying becuase it has moderate linoleic acid content and a high level of natural oxidants. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 9500, 'litre', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14747_65785146.jpg', 'Fortune Cooking Oil', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14747_65794612.jpg', 'Fortune Cooking Oil', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14747_65793025.jpg', 'Fortune Cooking Oil', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Gental Washing Powder';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Gental Washing Powder', 'cleaning-hygiene', 'Gentle washing powder contains active organic matter amd stainex enzymes which penetrates stains and digest the dirt to yield effective cleaning and brightening action. Why use Gental Washing Powder It gets rid of stains fast Lathers easily Its in various sizes and at the respective prices, allowing customers to purchase according to their needs and ability. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 15000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14747_65793025.jpg', 'Gental Washing Powder', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14747_65794612.jpg', 'Gental Washing Powder', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14747_65785146.jpg', 'Gental Washing Powder', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Gold Band Margarine';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Gold Band Margarine', 'cleaning-hygiene', 'BIDCO Gold Band is the perfect household margarine. It can be used for making sandwiches and spreads, baking, pan frying, sauce making, and as a topping on posho, beans and porridge. Why use Gold Band Margarine It has a delicious buttery flavor Spreads smoothly and easily Can be stored without refrgeration Is enriched with Vitamins A, B1, B2, D and E Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 12000, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14747_65793636.jpg', 'Gold Band Margarine', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14747_65794612.jpg', 'Gold Band Margarine', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14747_65785146.jpg', 'Gold Band Margarine', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Kimbo';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Kimbo', 'cleaning-hygiene', 'Kimbo is a pure white vegetable fat, loaded with Vitamins. It is suitable for all purpose home cooking and industrial frying. e.g. baking, general cooking, shallow frying and direct creaming and icing in bakeries. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 9500, 'litre', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14747_6579427.jpg', 'Kimbo', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14747_65794612.jpg', 'Kimbo', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14747_65785146.jpg', 'Kimbo', true);
  end if;
end $$;

-- AVION UGANDA · +256759605031 · 6 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'avion-uganda@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'avion-uganda@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256759605031' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'trader', 'free', 'AVION UGANDA', 'AVION UGANDA',
      'AU', '+256759605031', null, '+256759605031', 'avion-uganda@suppliers.bubu.market',
      'Opp Theta Medical, Mawanda Rd, Kampala, ., Central, Kampala', 'kampala', 'medical supplies', 'AVION UGANDA supplies medical supplies, cleaning and personal care from Kampala. 6 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'AVION UGANDA supplies medical supplies, cleaning and personal care from Kampala. 6 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'medical-supplies') on conflict do nothing;
  insert into account_categories (account_id, category_id) values (v_acct, 'cleaning-hygiene') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Prod-_31461_1090163616.jpg', 'AVION UGANDA — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'AVION Clear Transparent Protective Shield';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'AVION Clear Transparent Protective Shield', 'medical-supplies', 'AVION Clear Transparent Protective Shield For the Protection of the facial area and associated mucous membranes that is Eyes, Nose & Mouth.Kind Reminder. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 22000, 'box', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31461_1090163616.jpg', 'AVION Clear Transparent Protective Shield', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31461_109015553.jpg', 'AVION Clear Transparent Protective Shield', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31461_109319044.jpg', 'AVION Clear Transparent Protective Shield', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Avion Dish Washing Gel';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Avion Dish Washing Gel', 'cleaning-hygiene', 'Avion Dish Washing Gel is used primarily for removing leftover food, oil and greese from the used dishes and tableware. avion dish washing gel is a high foaming mixture of surfactants that is used for hand washing of glasses, plates, cutlery and cooking utensils in a sink. A drop of avion dishwash gel has 2 times more cleaning power that can get through more dishes with less useage. powerful formulation of avion dishwashing gel will leave your hands safe while your dishes sparkling clean everytime you use it. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 9500, 'litre', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31461_109015553.jpg', 'Avion Dish Washing Gel', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31461_1090163616.jpg', 'Avion Dish Washing Gel', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31461_109319044.jpg', 'Avion Dish Washing Gel', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Avion Drinking Straws';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Avion Drinking Straws', 'cleaning-hygiene', 'Sip into the new week with AVION drinking straws. Because with AVION straws, every sip indeed counts. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 15000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31461_109319044.jpg', 'Avion Drinking Straws', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31461_1090163616.jpg', 'Avion Drinking Straws', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31461_109015553.jpg', 'Avion Drinking Straws', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Avion Hand Sanitizer';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Avion Hand Sanitizer', 'cleaning-hygiene', 'Avion Hand Sanitizer''s bacteriostatic rate is as high as 99.99%, which directly eliminates bacteria and virus and forms a sterilizing protective layers. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 6500, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31461_109017165.jpg', 'Avion Hand Sanitizer', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31461_1090163616.jpg', 'Avion Hand Sanitizer', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31461_109015553.jpg', 'Avion Hand Sanitizer', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Avion Soft & Absorbent Napkins';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Avion Soft & Absorbent Napkins', 'cleaning-hygiene', 'Avion Soft & Absorbent Napkins has a perfect & smooth surface that gives you More comfort. Airlaid paper that gives more freshness and softness, Superb Absorbent core that prevents moisture, keeps surface and a bottom layer that avoids moisture & heat fast keeping you fresh everyday. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 16000, 'ream', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31461_109015435.jpg', 'Avion Soft & Absorbent Napkins', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31461_1090163616.jpg', 'Avion Soft & Absorbent Napkins', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31461_109015553.jpg', 'Avion Soft & Absorbent Napkins', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Avion Wavex Paper Saviettes';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Avion Wavex Paper Saviettes', 'cleaning-hygiene', 'Avion Wavex Paper Saviettes give your table setting that little bit extra and are both a practical and stylish decoration. Choose napkins according to the occasion and let them put the finishing touches. Avion Wavex Paper Saviettes are a feel luxurious and the paper napkins lift the meal whether you eat breakfast, lunch or dinner. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 16000, 'ream', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31461_1090181424.jpg', 'Avion Wavex Paper Saviettes', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31461_1090163616.jpg', 'Avion Wavex Paper Saviettes', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31461_109015553.jpg', 'Avion Wavex Paper Saviettes', true);
  end if;
end $$;

-- Biva Organic · +256752602427+256773454502 · 1 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'biva-organic@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'biva-organic@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256752602427+256773454502' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'manufacturer', 'free', 'Biva Organic', 'Biva Organic',
      'BO', '+256752602427+256773454502', null, '+256752602427+256773454502', 'biva-organic@suppliers.bubu.market',
      'Biva Organic Building, Hamu Mukasa Rd, Kampala, Uganda, Kampala, Uganda, Mengo, Kampala', 'kampala', 'medical supplies', 'Biva Organic supplies medical supplies from Kampala. 1 line is listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Biva Organic supplies medical supplies from Kampala. 1 line is listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'medical-supplies') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/dr_ss_260629034820681_004.jpg', 'Biva Organic — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Kigelia Africana oil/ Fenugreek Oil';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Kigelia Africana oil/ Fenugreek Oil', 'medical-supplies', 'Premium Natural Herbal Oil Biva Organic Kigelia Africana Oil / Fenugreek Oil Biva Organic Kigelia Africana Oil / Fenugreek Oil is a naturally inspired herbal oil for organic skincare, hair nourishment, body care, and plant-based wellness routines. This botanical blend brings together the traditional value of Kigelia Africana and Fenugreek Oil in a natural personal care product suitable for everyday wellness and self-care. Product Overview Kigelia Africana, commonly known as the African Sausage Tree, is widely respected in African herbal traditions and natural skincare practices. Fenugreek Oil is also valued for its rich, nourishing qualities and its common use in personal care routines. This product is ideal for customers looking for a natural body oil, herbal skincare oil, massage oil, or botanical hair and scalp care oil. It suits people who prefer organic, plant-based alternatives in…', 40000, 'piece', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/89048_kige_20260701072152.jpg', 'Kigelia Africana oil/ Fenugreek Oil', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/89048_kige_20260701072257.jpg', 'Kigelia Africana oil/ Fenugreek Oil', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/89048_kige_20260701072338.jpg', 'Kigelia Africana oil/ Fenugreek Oil', true);
  end if;
end $$;

-- GREEN WORLD INTERNATIONAL UGANDA LIMITED. · +256782409378+256706740562 · 13 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'green-world-international-uganda-limited@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'green-world-international-uganda-limited@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256782409378+256706740562' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'trader', 'free', 'GREEN WORLD INTERNATIONAL UGANDA LIMITED.', 'GREEN WORLD INTERNATIONAL UGANDA LIMITED.',
      'GW', '+256782409378+256706740562', null, '+256782409378+256706740562', 'green-world-international-uganda-limited@suppliers.bubu.market',
      'Akamwesi Shopping Mall 1st Floor Room NW-10. Along Gayaza Road Kampala - Uganda, ., Central, Kampala', 'kampala', 'medical supplies', 'GREEN WORLD INTERNATIONAL UGANDA LIMITED. supplies medical supplies from Kampala. 13 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'GREEN WORLD INTERNATIONAL UGANDA LIMITED. supplies medical supplies from Kampala. 13 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'medical-supplies') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Prod-_27501_838174131.jpg', 'GREEN WORLD INTERNATIONAL UGANDA LIMITED. — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'B-Carotene & Lycopene Capsule';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'B-Carotene & Lycopene Capsule', 'medical-supplies', 'Characteristics and benefits 1. Supplements Body with Vitamin A. 2. Serves as a strong antioxidant which deactivates free radicals. 3. Prevents cancer, especially prostate cancer. 4. Prevents atheroscierosis through lowering blood lipid. Suitable For; Teenegers and adults with Vitamin A deficiency Males with Prostate disorders such as prostatitis, benign prostatic, hyperplasia (prostate enlargement), and prostate cancer People with elevated blood lipid Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 12000, 'box', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27501_838174131.jpg', 'B-Carotene & Lycopene Capsule', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27501_861185018.jpg', 'B-Carotene & Lycopene Capsule', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27501_861165116.jpg', 'B-Carotene & Lycopene Capsule', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Blueberry Super Nutrition';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Blueberry Super Nutrition', 'medical-supplies', 'Ingredients: Calcium 0.1 g, Daucus carota subsp. sativus 2 g (equals to 1418 micrograms beta-Carotene), Fructooligosaccharides 2.6 g, Panax quinquefolius 0.5 g, Rice Protein 10 g, Vaccinium angustifolium 0.6 g, Vaccinium angustifolium 0.2 g (20 : 1 DHE: 4000 mg) Benefits: Source of protein to maintain good health and to build, repair body tissues. Source of amino acids involved in muscle protein synthesis. Assists in the building of lean muscle (tissue/mass) when combined with regular (weight/resistance) training and a healthy balanced diet. Helps in the development and maintenance of bones and teeth especially in childhood, adolescence and young adulthood Adequate calcium (and vitamin D) (throughout life) as part of a healthy diet, (along with physical activity) may reduce the risk of developing osteoporosis (in peri- and postmenopausal women) (in later life) Provides antioxidants… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 6800, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27501_861185018.jpg', 'Blueberry Super Nutrition', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27501_838174131.jpg', 'Blueberry Super Nutrition', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27501_861165116.jpg', 'Blueberry Super Nutrition', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Clear Lung Tea';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Clear Lung Tea', 'medical-supplies', 'Ingredients: Flos Chrysanthemi, Cordate Houttuynia, Bulbus Lilii, Apricot Kernel, Exocarpium Citri Rubrum, Green Tea Characteristics and Benefits: 1. Cleanses lung; kills bacteria and virus inside the respiratory system; 2. Increases the amount of immunoglobulin; enhances immunity of the body; 3. Activates lymphokine which kills virus in the respiratory system directly; 4. Resolves and expectorates phlegm rapidly; 5. Provides oxygen for repairing damaged mucosa; enhances the activity of lung epithelial tissues; 6. Relieves cough and asthma; 7. Strengthens the pulmonary ventilation. Suitable for: * People with respiratory diseases such as pulmonary TB, asthma, chronic cough * People working in air-polluted environment * Smokers or second-hand smokers Key knowledge: * Pulmonary diseases According to statistics of World Health Organization, there are 510 million patients suffering from… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 12000, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27501_861165116.jpg', 'Clear Lung Tea', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27501_838174131.jpg', 'Clear Lung Tea', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27501_861185018.jpg', 'Clear Lung Tea', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Jinpure Tea';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Jinpure Tea', 'medical-supplies', 'Ingredients: 1. Flos Lonicerae (Honeysuckle)-Anti-virus & anti-bacteria + Immune modulator 2. Herba Taraxaci (Dandelion)- Anti-virus & anti-bacteria + Anti-inflammatory 3. Herba Houttuyniae - Anti-virus & anti-bacteria + Anti-inflammatory 4. Fructus Forsythiae - Anti-virus & anti-bacteria + Lower body temperature 5. Apricot Kernel- Relieve cough & asthma 6. Herba Portulacae - Relieve cough & asthma + detoxification 7. Green Tea - Antioxidant, Detoxification How to take Jinpure Tea? l Take 1-2 sachets daily l Brew the tea with boiling water for 5 minutes l Each tea bag brews 3-5 cups of tea Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 12000, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27501_86116361.jpg', 'Jinpure Tea', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27501_838174131.jpg', 'Jinpure Tea', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27501_861185018.jpg', 'Jinpure Tea', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Multu-Vitamin Tablet for Adults';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Multu-Vitamin Tablet for Adults', 'medical-supplies', 'Characteristics and Benefits Multivitamin keeps the normal metabolism and function of the body. Green world Multi-vitamins tablet supply all the necessary vitamins required by body. Intake of this product every day can balance the vitamin supplement requirements for both adults and children Suitable For; Adults, especially: * People with vitamin deficiency * People can not meet their Recommended Daily Allowance of vitamins. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 12000, 'box', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27501_83820342.jpg', 'Multu-Vitamin Tablet for Adults', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27501_838174131.jpg', 'Multu-Vitamin Tablet for Adults', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27501_861185018.jpg', 'Multu-Vitamin Tablet for Adults', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Pine Pollen Tea';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Pine Pollen Tea', 'medical-supplies', 'Ingredients : Extracts of pine bark of Chinese Red Pine, coniferous tree, pine pollen, green tea Characteristics : · Pleasant Taste · Easy to absorb · Easy to use It doesn’t only satisfy a Tea Lover’s need but also provide excellent health benefits. The product can regulate and balance body functions, prevent fatigue, stabilize emotion and please people. Benefits: Adjust intestine and stomach to its optimum state, stimulate the regeneration of digestive enzyme, increase appetite, delay aging and refresh body, anti-fatigue and anti-aging health benefits. Recommended for: All people, especially the elderly and weak people. Suggested Use: Brew one tea sachet for 3-5 minutes and then drink. The same tea sachet can be use more than once. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 12000, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27501_861161617.jpg', 'Pine Pollen Tea', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27501_838174131.jpg', 'Pine Pollen Tea', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27501_861185018.jpg', 'Pine Pollen Tea', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Pro-Sliming Tea';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Pro-Sliming Tea', 'medical-supplies', 'Ingredients Folium Nelumbinis Semen Cassiae Semen Raphani Fructus Cannabis Flos Aurantii Pollen Pini Extractum Key Information: v Each of the six herbal ingredients in this tea works effectively against fat. v Acting synergistically, they interfere with every link of the human fat metabolism. v From reducing the absorption of dietary fat, enhancing the liver function of transporting and metabolizing fat, to improving bile secretion to break down the fat. v You will not experience lethargy or malnutrition during your weight loss program v The Fructus Cannabis and Pine Pollen in the tea provide essential nutrients and strengthen your stamina. v Helps you to lose weight in a manner that is healthy and safe. Characteristics and Benefits Ø Accelerates metabolism and degradation of fat Ø Burns fat as fuel to reduce the lipid content of the body Ø Reduces absorption of dietary fat and helps… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 12000, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27501_861154945.jpg', 'Pro-Sliming Tea', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27501_838174131.jpg', 'Pro-Sliming Tea', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27501_861185018.jpg', 'Pro-Sliming Tea', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Protein Powder';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Protein Powder', 'medical-supplies', 'Characteristics and Benefits 1. Promotes growth and development of human body. 2. Carries out the duties specified by the information encoded in genes. 3. Constitutes enzymes, which catalyze chemical reactions. 4. Involved in the process of cell signaling and signal transduction. 5. Structural proteins confer stiffness and rigidity to otherwise-fluid biological components. Suitable For; People in status of malnutrition such as alcoholism * People at the late stage of wasting disease such as cancer, AIDS, tuberculosis, diabetes, chronic atrophic gastritis, malignant thyrotoxicosis, etc. * Vegetarians who have insufficient intake of protein. * Athletes who need to build muscles. * People who are at body weight control program Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 145000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27501_838194144.jpg', 'Protein Powder', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27501_838174131.jpg', 'Protein Powder', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27501_861185018.jpg', 'Protein Powder', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Se Tablet';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Se Tablet', 'medical-supplies', 'Characteristics and Benefits 1. Relieves Selenium deficiency related disorder. 2. Enhances the body''s anti-oxidation ability. 3. Regulates the secretion of thyroxin. 4. Participates in the production of sperm. 5. Supports the immune system. Suitable For; * People with selenium deficiency. * People craving in refined food Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 12000, 'box', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27501_838201350.jpg', 'Se Tablet', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27501_838174131.jpg', 'Se Tablet', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27501_861185018.jpg', 'Se Tablet', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Serum Calcium Tablets';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Serum Calcium Tablets', 'medical-supplies', 'Calcium plays a big role in maintaining the normal physiological function. It is the most abundant mineral in the body, it is found in some foods, added to others, available as a dietary supplement, and present in some medicines ( such as antacids). Calcium is required for vascular contraction and vasodilation, muscle function, nerve transmission, intracellular signaling and hormonal secretion, though less than 1% of the total body calcium is neededto support these critical matabolic functions. Reservior of calcium - bone and teeth. Serum calcium is very tightly regulated and does not fluctuate with changes in dietary intakes; the body uses bone tissue as a reservior for, and source of calcium , to maintain constant concentrations of calcium in blood, muscle, and intercellular fluids. The remaining 99% of the body''s calcium supply is stored in the bones and teeth where it supports their… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 18000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27501_838175215.jpg', 'Serum Calcium Tablets', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27501_838174131.jpg', 'Serum Calcium Tablets', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27501_861185018.jpg', 'Serum Calcium Tablets', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Uterus Cleansing Pill';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Uterus Cleansing Pill', 'medical-supplies', 'Benefits. A natural Treatment for all gynocological Disorders such as: - Infertility - Fibroids - Ovarian cysts - PIDS - Hormonal Imbalance - Virginal ordor and discharge - Virginal Dryness and itching Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 3200, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27501_83592325.jpg', 'Uterus Cleansing Pill', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27501_838174131.jpg', 'Uterus Cleansing Pill', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27501_861185018.jpg', 'Uterus Cleansing Pill', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Vigpower Capsule';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Vigpower Capsule', 'medical-supplies', 'The GREEN WORLD Male care packages include a variety of items including: male enhancement pills, prostate supplements, sexual performance products for improved long-lasting erections. The packs provides wonderful relief from the many burdens associated with being a man in today''s world. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 32000, 'bag', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27501_836135945.jpg', 'Vigpower Capsule', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27501_838174131.jpg', 'Vigpower Capsule', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27501_861185018.jpg', 'Vigpower Capsule', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Zinc Tablet for Adult';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Zinc Tablet for Adult', 'medical-supplies', 'Characteristics and Benefits 1. Essential for optimal physical performance and energy levels. 2. For protein synthesis and proper function of red and white blood cells . 3. Participates is synthesize of more than 200 metalloprotease and nucleic acid 4. Enhances immunity and accelerates wound healing. 5. Support reproductive system of men and women and gelps with infertility Suitable For; * People with insufficient daily intake of zinc. * People with digestive problems and poor stomach acid. * People who smoke and take alcohol excessively. * Vegeterians. * Women on the birth control pills or hormone replacement therapy. * Athletes or people who are physically active. * Children Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 12000, 'box', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27501_838195127.jpg', 'Zinc Tablet for Adult', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27501_838174131.jpg', 'Zinc Tablet for Adult', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_27501_861185018.jpg', 'Zinc Tablet for Adult', true);
  end if;
end $$;

-- Rene Industries · +2564142365954341416 · 9 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'rene-industries@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'rene-industries@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+2564142365954341416' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'manufacturer', 'free', 'Rene Industries', 'Rene Industries',
      'RI', '+2564142365954341416', null, '+2564142365954341416', 'rene-industries@suppliers.bubu.market',
      'P. O. Box 6034, Kampala. Uganda, Plot 680 Kamuli, Kireka, Central, Kampala', 'kampala', 'medical supplies', 'Rene Industries supplies medical supplies from Kampala. 9 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Rene Industries supplies medical supplies from Kampala. 9 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'medical-supplies') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Prod-_14742_671105220.gif', 'Rene Industries — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Revive - ORS(Orange flavour)';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Revive - ORS(Orange flavour)', 'medical-supplies', 'Revive is reduced osmolarity oral rehydration salts used to prevent and treat dehydration, especially that due to diarrhea. Revive is an extremely effective solution that rehydrates children and adults and replenishes body fluids Presentation 20.5gms Sachet Indications Oral replacement of electrolytes and fluids in patients with dehydration, particularly those associated with acute diarrhoea of various causes. Pharmacological class Electrolyte Pharmacological properties Electrolyte replacement Mechanism of Action Revive is an extremely effective solution that rehydrates children and adults and replenishes body fluids. The Oral rehydration salts solution is absorbed in the small intestine, thus replacing the water and electrolytes lost. Electrolytes – Sodium & Potassium chloride: Replace lost electrolytes A bicarbonate source – Trisodium citrate – to correct or prevent metabolic acidosis… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 6800, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14742_671133219.gif', 'Revive - ORS(Orange flavour)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery14742-3227133252.gif', 'Revive - ORS(Orange flavour)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14742_671105220.gif', 'Revive - ORS(Orange flavour)', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Zinkora Kit - ORS + Dispersible Zinc Sulphate Tablet';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Zinkora Kit - ORS + Dispersible Zinc Sulphate Tablet', 'medical-supplies', 'Composition: Each pack contains: two sachets of Revive one strip of ReZn Presentation Kit Oral replacement of electrolytes and fluids in patients with dehydration, particularly those associated with acute diarrhoea of various causes. Zinc supplementation has been shown to be an effective treatment for acute, persistent, and dysenteric diarrhoea in children under five. ReZn tablets are used to reduce morbidity and mortality in children under five with acute, persistent and dysenteric diarrhoea. Recommended use with REVIVE ORS for maximum benefits. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 32000, 'bag', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14742_671125123.gif', 'Zinkora Kit - ORS + Dispersible Zinc Sulphate Tablet', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery14742-3227125154.gif', 'Zinkora Kit - ORS + Dispersible Zinc Sulphate Tablet', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14742_671105220.gif', 'Zinkora Kit - ORS + Dispersible Zinc Sulphate Tablet', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Becoren Vitamin B Complex Tablets';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Becoren Vitamin B Complex Tablets', 'medical-supplies', 'Becoren tablets consists of a group of B vitamins which play a vital role in maintaining good health and well-being. As the building blocks of a healthy body, B vitamins have a direct impact on your energy levels, brain function, and cell metabolism. Vitamin B complex helps prevent infections and helps support or promote: cell health. Thiamine is the coenzyme of carboxylase and is required for carbohydrate metabolism. Riboflavin is an essential component of certain oxidative enzyme system in intermediary metabolism. Vitamin B6 is essential for the build-up and the conversion of amino acids into proteins in the body and Nicotinamide is an essential part of co-dehydrogenases 1 and 2, and also it is present in every living cell. Presentation Blister Pack of 10×10’s Tablets Indications: Becoren is an ideal for vigour, growth and vitality, useful in correcting vitamin deficiencies in all age… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 12000, 'box', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14742_671105220.gif', 'Becoren Vitamin B Complex Tablets', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery14742-3227105242.gif', 'Becoren Vitamin B Complex Tablets', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14742_671111227.gif', 'Becoren Vitamin B Complex Tablets', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Chewcee Vitamin C Tablets';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Chewcee Vitamin C Tablets', 'medical-supplies', 'Vitamin C It is a potent water soluble anti-oxidant, also known as ascorbic acid, is necessary for the growth, development and repair of all body tissues. Vitamin C plays a role many oxidative and other metabolic reactions, e.g. hydroxylation of proline and lysine residues of protocollagen. Severe vitamin C deficiency leads to scurvy commonly seen in malnourished infants, children, elderly alcoholics and drug addicts. Presentation Blister pack of 10×10’s Tablets Indications: Treatment of scurvy, postoperatively, anaemia, to acidity urine U.T.I, Common cold, asthma, cancer, atherosclerosis, formation of collagen, absorption of iron, the immune system, wound healing, and the maintenance of cartilage, bones, and teeth. Pharmacological class Vitamin Pharmacological properties Anti-oxidant Mechanism of Action Ascorbic acid (vitamin c) is reversibly oxidized to dehydroascorbic acid (vitamin… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 12000, 'box', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14742_671111227.gif', 'Chewcee Vitamin C Tablets', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery14742-3227111253.gif', 'Chewcee Vitamin C Tablets', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14742_671105220.gif', 'Chewcee Vitamin C Tablets', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Foliren Folic Acid Tablets';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Foliren Folic Acid Tablets', 'medical-supplies', 'Folic acid is a member of the vitamin B group and is the substrate for the production of tetrahydrofolate by enzymatic reduction in vivo. Tetrahydrofolate is a coenzyme for various metabolic pathways including purine and pyrimidine nucleotide synthesis, and ultimately DNA synthesis. It is also involved in some amino acid conversions, and in the formation and utilisation of formate. Presentation Blister pack of 10×10’s tablets and Jar of 1000’s Tablets Indications: For treatment of folic acid deficiency, megaloblastic anaemia and in anemias of nutritional supplements, pregnancy, infancy, or childhood. Folate deficiency is a consequence of inadequate dietary intake, malabsorption, or increased utilisation in conditions such as pregnancy, lactation, haemolytic anaemia, hyperthyroidism, exfoliative dermatitis, and chronic infection. Folic Acid is also indicated for prophylaxis of folate… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 12000, 'box', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14742_67110136.gif', 'Foliren Folic Acid Tablets', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery14742-3227102633.gif', 'Foliren Folic Acid Tablets', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14742_671105220.gif', 'Foliren Folic Acid Tablets', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Multiren Multivitamin Tablets';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Multiren Multivitamin Tablets', 'medical-supplies', 'Multiren tablets consists of a group of water-soluble vitamins, some of which are Coenzymes and fat soluble, Vitamin A. B vitamins play a vital role in maintaining good health and well-being. Multivitamins are used to provide vitamins that are not taken in through the diet. Multivitamins are also used to treat vitamin deficiencies (lack of vitamins) caused by illness, pregnancy, poor nutrition, digestive disorders, and many other conditions. Presentation Blister Pack of 10×10’s Tablets Indications: Multiren is an ideal for vigour, growth and vitality, useful in correcting vitamin deficiencies in all age groups. Pharmacological class Vitamins and trace elements Pharmacological properties Antioxidant, coenzyme, vitamin supplementation Mechanism of Action Multivitamins act as coenzymes in a substantial proportion of the enzymatic processes that underpin every aspect of cellular… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 9500, 'litre', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14742_671112624.gif', 'Multiren Multivitamin Tablets', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery14742-3227112647.gif', 'Multiren Multivitamin Tablets', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14742_671105220.gif', 'Multiren Multivitamin Tablets', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Pyriren Pyridoxine Tablets';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Pyriren Pyridoxine Tablets', 'medical-supplies', 'The prevention and management of Pyridoxine (vitamin B6) deficiency. Treatment of sideroblastic anaemias, homocystinuria or primary hyperoxaluria. Pyridoxine (Vitamin B6) dependency in infants. Actions: Pyridoxine (vitamin B6) is a water-soluble vitamin involved principally in amino acid metabolism, but is also involved in carbohydrate and fat metabolism. It is also required for the formation of hemoglobin. Pyridoxine deficiency is rare in humans because of its widespread distribuion in foods. Pyridoxine deficiency may be drug induced, and inadequate utilization of pyridoxine may result from certain inborn errors of metabolism. Pyridoxine deficiency may lead to sideroblastic anaemia, dermatitis, cheilosis and neurological symptoms such as peripheral neuritis and convulsions. Pharmacokinetics: Pyridoxine is readily absorbed from the gastrointestinal tract after oral administration and… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 12000, 'box', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14742_67195257.gif', 'Pyriren Pyridoxine Tablets', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery14742-322795829.gif', 'Pyriren Pyridoxine Tablets', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14742_671105220.gif', 'Pyriren Pyridoxine Tablets', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'RENIRON Multivitamin Syrup';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'RENIRON Multivitamin Syrup', 'medical-supplies', 'RENIRON is recommended to fulfill the nutritional need in pregnant and nursing mothers, growing children, loss of appetite, iron deficiency anaemia, general convalescences and other nutritional deficiencies. DOSES AND ADMINISTRATION Pregnancy: The birth weight of a newborn baby is a true indication of the baby’s I.Q and its future health potential and it is a known fact that proper iron supplementation during pregnancy results in higher birth weights in newborn babies. If you are pregnant and not strict to take rich balanced diet, it is advisable to start taking one RENIRON capsule a day after food or 10ml (2 teaspoonfuls) RENIRON syrup twice daily 15 minutes before food. General anaemic conditions: If your food habits are not correct, invariably you continue to take ill balanced food and slowly anaemia due to nutritional deficiencies of iron and folic acid will set in. Initially the… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 12000, 'box', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14742_67011490.gif', 'RENIRON Multivitamin Syrup', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery14742-3226115426.gif', 'RENIRON Multivitamin Syrup', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14742_671105220.gif', 'RENIRON Multivitamin Syrup', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Vitaren Multivitamin Syrup';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Vitaren Multivitamin Syrup', 'medical-supplies', 'Vitaren syrup is a group of water-soluble vitamins, some of which are Coenzymes and fat soluble, Vitamin A. B vitamins play a vital role in maintaining good health and well-being. Multivitamins are used to provide vitamins that are not taken in through the diet. Multivitamins are also used to treat vitamin deficiencies (lack of vitamins) caused by illness, pregnancy, poor nutrition, digestive disorders, and many other conditions. Presentation VITAREN is available in 100ml & 60ml bottle. Indications: Vitaren syrup is an ideal for vigour, growth and vitality, useful in correcting vitamin deficiencies in all age groups. Pharmacological class Vitamins and trace elements Pharmacological properties Vitamin Supplementation Mechanism of Action Multivitamins act as coenzymes in a substantial proportion of the enzymatic processes that underpin every aspect of cellular physiological functioning.… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 9500, 'litre', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14742_671102941.gif', 'Vitaren Multivitamin Syrup', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery14742-322710307.gif', 'Vitaren Multivitamin Syrup', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14742_671105220.gif', 'Vitaren Multivitamin Syrup', true);
  end if;
end $$;

commit;

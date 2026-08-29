-- BUBU.Market · Africa2Trust import, part 3 of 6
-- 10 suppliers. Run the parts in order; each one is safe to re-run.
-- READ-ME-FIRST.txt explains the prices and the photographs.
--
--   Sustain A Skin
--   Maridadi Crafts & Design
--   Nnyanzi Art Studio
--   Priamit Enterprises Limited
--   MOTORCARE UGANDA LIMITED
--   TOYOTA UGANDA LTD
--   Simba Automotives
--   Spear Motors Limited
--   Real Oils
--   Bata Shoe Co. Uganda Ltd

begin;

create extension if not exists pgcrypto;
alter table accounts add column if not exists import_source text;
alter table products add column if not exists import_source text;

-- Sustain A Skin · +256782744231+256772459134 · 49 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'sustain-a-skin@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'sustain-a-skin@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256782744231+256772459134' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'trader', 'free', 'Sustain A Skin', 'Sustain A Skin',
      'SA', '+256782744231+256772459134', null, '+256782744231+256772459134', 'sustain-a-skin@suppliers.bubu.market',
      'plot 17, Crafts Africa, buganda road, shop no. 15, Central, Kampala', 'kampala', 'stationery, art and printing', 'Sustain A Skin supplies stationery, art and printing, furniture and fittings, textiles and apparel from Kampala. 49 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Sustain A Skin supplies stationery, art and printing, furniture and fittings, textiles and apparel from Kampala. 49 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'stationery-printing') on conflict do nothing;
  insert into account_categories (account_id, category_id) values (v_acct, 'furniture-fittings') on conflict do nothing;
  insert into account_categories (account_id, category_id) values (v_acct, 'textiles-apparel') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/ix/Lady-Home.jpg', 'Sustain A Skin — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Afro-green fusion flower bud bangle and ring';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Afro-green fusion flower bud bangle and ring', 'stationery-printing', 'Afro-green fusion flower bud bangle and ring add a flair to your outfit, can add that wildlife chic to your look. Perhaps you’re looking for a more earthy look- achieve it with our wild seed hand painted necklaces. Afro-green fusion flower bud bangle and ring Hand beaded and dyed, this exquisite set creates an aura of vivacity and youthfulness. Materials: Dyed beads Chunky necklace: Paper beads, seeds, and 100% cotton African themed cloth Oversized bag: Dyed banana fibre with metal and seed detail and leather strap. Colours available: Multiple colours Recommended for: High end glamour outing Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 25000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_model.jpg', 'Afro-green fusion flower bud bangle and ring', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Afro-green fusion flower bud bangle and ring', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Afro-green fusion flower bud bangle and ring', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Assorted bangles';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Assorted bangles', 'stationery-printing', 'If you’re looking for a piece of jewellery that adds flair to your outfit, a necklace of hippo teeth or cowhide bangle can add that wildlife chic to your look. Perhaps you’re looking for a more earthy look- achieve it with our wild seed hand painted necklaces. Assorted bangles Materials: Grass, wood, bone Colours available: Multiple colours Recommended for: A weekend tea party, trip to the supermarket or casual day in the office Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 180000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sustain_Assortedbangles.gif', 'Assorted bangles', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Assorted bangles', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Assorted bangles', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Assorted Jewellery';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Assorted Jewellery', 'stationery-printing', 'In stock we have a wide variety of jewellery to spruce up any outfit or enhance a mood. From earrings to necklaces our range is inexhaustible with more pieces being created daily. Assorted jewellery In stock we have a wide variety of jewellery to spruce up any outfit or enhance a mood. From earrings to necklaces our range is inexhaustible with more pieces being created daily. Materials: Metal, sisal, beads, seeds, cow horn, animal teeth, grass Colours available: Multiple colours Recommended for: Casual to formal occasions Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 180000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_assojewe.gif', 'Assorted Jewellery', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Assorted Jewellery', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Assorted Jewellery', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Assorted jewellery set';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Assorted jewellery set', 'stationery-printing', 'If you’re looking for a piece of jewellery that adds flair to your outfit, a necklace of hippo teeth or cowhide bangle can add that wildlife chic to your look. Perhaps you’re looking for a more earthy look- achieve it with our wild seed hand painted necklaces. Assorted jewellery set Bangle: Cow bone Necklace: Cowrie shells Comb: Cow bone Colours available: Brown, black and cream Recommended for: A unique gift set Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 180000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_jewellyset.gif', 'Assorted jewellery set', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Assorted jewellery set', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Assorted jewellery set', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Chunky bangles';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Chunky bangles', 'stationery-printing', 'If you’re looking for a piece of jewellery that adds flair to your outfit, a necklace of hippo teeth or cowhide bangle can add that wildlife chic to your look. Perhaps you’re looking for a more earthy look- achieve it with our wild seed hand painted necklaces. Chunky bangles Material: Cow bone Recommended for: Complement an all black outfit to give a hint of classic chic Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 180000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Sustain_Chunkybangles.gif', 'Chunky bangles', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Chunky bangles', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Chunky bangles', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Colourful paper bead jewellery';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Colourful paper bead jewellery', 'stationery-printing', 'Paper beads are a popular trend and help provide incomes to impoverished communities. Their uniqueness is in the fact that no one piece ever looks alike. Get anklets, bangles, necklaces, earrings, purses and waist beads Colourful paper bead jewellery Paper beads are a popular trend and help provide incomes to impoverished communities. Their uniqueness is in the fact that no one piece ever looks alike. Get anklets, bangles, necklaces, earrings, purses and waist beads Materials: Recycled and varnished coloured paper Colours available: Multiple colours Recommended for: A day out on the town Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 16000, 'ream', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_paperbead.jpg', 'Colourful paper bead jewellery', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Colourful paper bead jewellery', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Colourful paper bead jewellery', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Hollow seed earrings and necklace set';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Hollow seed earrings and necklace set', 'stationery-printing', 'Hollow seed earrings and necklace set add a flair to your outfit, can add that wildlife chic to your look. Perhaps you’re looking for a more earthy look- achieve it with our wild seed hand painted necklaces. Hollow seed earrings and necklace set Materials: Seed and beads Belt: Paper beads and painted entwined scrap string Colours available: Multiple colours Recommended for: High end glamour outing Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 3200, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_seedrings.gif', 'Hollow seed earrings and necklace set', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Hollow seed earrings and necklace set', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Hollow seed earrings and necklace set', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Layered assorted seed necklace';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Layered assorted seed necklace', 'stationery-printing', 'Layered assorted seed necklace An intriguing and intricate piece, this necklace will match any outfit because of the multiplicity of colours and variety of hand painted seeds. Materials: Dyed and varnished seeds Colours available: Multiple colours Recommended for: A day for making statements Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 3200, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_layeredseednecklace.gif', 'Layered assorted seed necklace', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Layered assorted seed necklace', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Layered assorted seed necklace', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Multilayered necklace';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Multilayered necklace', 'stationery-printing', 'If you’re looking for a piece of jewellery that adds flair to your outfit, a necklace of hippo teeth or cowhide bangle can add that wildlife chic to your look. Perhaps you’re looking for a more earthy look- achieve it with our wild seed hand painted necklaces. Multilayered necklace Materials: Coloured, varnished plant seeds Colours available: Red Recommended for: A glamorous night out or charity gala- bound to attract lots of attention and questions Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 180000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sustain_necklace.gif', 'Multilayered necklace', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Multilayered necklace', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Multilayered necklace', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Multilayered seed necklace';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Multilayered seed necklace', 'stationery-printing', 'This handmade seed necklace is a fun interesting accessory to liven up a plain outfit Multilayered seed necklace This handmade seed necklace is a fun interesting accessory to liven up a plain outfit Materials: Assorted, dried, coloured and varnished seeds Colours available: Multiple colours Recommended for: Formal occasion Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 3200, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_seednecklace.gif', 'Multilayered seed necklace', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Multilayered seed necklace', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Multilayered seed necklace', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Multiloop stone bracelet';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Multiloop stone bracelet', 'stationery-printing', 'If you’re looking for an accessory that isn’t quite like anything around-this stone bangle with matching necklace will give your outfit an edgy stunning look. Multiloop stone bracelet If you’re looking for an accessory that isn’t quite like anything around-this stone bangle with matching necklace will give your outfit an edgy stunning look. Materials: Coloured stones interlaced with bright beads Colours available: Multiple colours Recommended for: A day out on the town Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 180000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_stonebracelet.gif', 'Multiloop stone bracelet', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Multiloop stone bracelet', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Multiloop stone bracelet', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Spiral Earrings and tie belt';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Spiral Earrings and tie belt', 'stationery-printing', 'Spiral Earrings and tie belt add a flair to your outfit, can add that wildlife chic to your look. Perhaps you’re looking for a more earthy look- achieve it with our wild seed hand painted necklaces. Spiral Earrings and tie belt Earrings: Dried grass Belt: Paper beads and painted entwined scrap string Colours available: Multiple colours Recommended for: Weekend wear Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 3200, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_earrings.gif', 'Spiral Earrings and tie belt', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Spiral Earrings and tie belt', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Spiral Earrings and tie belt', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'African tribal mask';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'African tribal mask', 'stationery-printing', 'African tribal mask Give them a scare donning this tribal mask and stand out from all the other ordinary costumes Material: Painted and varnished wood Colours available: Multiple colours Recommended for: Halloween, fancy dress party Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 95000, 'bucket', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_africamask.gif', 'African tribal mask', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'African tribal mask', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'African tribal mask', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Assorted Accessories';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Assorted Accessories', 'stationery-printing', 'Assorted accessories: Wooden accessories to enhance your living space come in all shapes and sizes, animals and utensils. Colours available: Brown, black Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 24000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_Assortedaccessories.jpg', 'Assorted Accessories', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Assorted Accessories', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Assorted Accessories', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Black and Gold Gourd';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Black and Gold Gourd', 'stationery-printing', 'Black and gold gourd: Traditionally used as a drinking vessel by African men, carved by hand, from the hollow gourd plant which is then painted and varnished Black and gold gourd: Traditionally used as a drinking vessel by African men, carved by hand, from the hollow gourd plant which is then painted and varnished Colours available: Multiple colours Recommended for: Living room accessory Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 95000, 'bucket', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Blackandgoldgourd.jpg', 'Black and Gold Gourd', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Black and Gold Gourd', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Black and Gold Gourd', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Boxed Giraffe Wall Hanging';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Boxed Giraffe Wall Hanging', 'stationery-printing', 'Boxed giraffe wall hanging: Wooden, painted carvings in a hollow box. Assorted animals available Colours available: Brown and black Recommended for: Living room accessory Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 24000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sun_giraffe_wallhanging.jpg', 'Boxed Giraffe Wall Hanging', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Boxed Giraffe Wall Hanging', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Boxed Giraffe Wall Hanging', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Cotton Wall Hanging';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Cotton Wall Hanging', 'stationery-printing', 'Cotton wall hanging: Hand painted domestic African life scene. A colourful storytelling piece Colours available: Multiple Recommended for: Living room accessory Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 24000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Sus_Cottonwallhanging.jpg', 'Cotton Wall Hanging', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Cotton Wall Hanging', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Cotton Wall Hanging', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Cow horn and bow and arrow';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Cow horn and bow and arrow', 'stationery-printing', 'Create conversation buzz by accessorizing your room with these ancient African utility items Cow horn and bow and arrow: Create conversation buzz by accessorizing your room with these ancient African utility items Colours available: Multiple colours Recommended for: Living room accessory Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 24000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Cowhornandbow.jpg', 'Cow horn and bow and arrow', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Cow horn and bow and arrow', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Cow horn and bow and arrow', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Cowhide Bangles';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Cowhide Bangles', 'stationery-printing', 'If you’re looking for a piece of jewellery that adds flair to your outfit, a necklace of hippo teeth or cowhide bangle can add that wildlife chic to your look. Perhaps you’re looking for a more earthy look- achieve it with our wild seed hand painted necklaces. Bangles Materials: Cowhide Colours available: Brown, black and white Recommended for: Weekend and lounge wear Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 180000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sustain_skinbangle.jpg', 'Cowhide Bangles', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Cowhide Bangles', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Cowhide Bangles', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Cream and Black Food Basket';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Cream and Black Food Basket', 'stationery-printing', 'Cream and black food basket: Used to serve a local dish known as ‘Kalo’ made from millet flour. Because of the porous nature of the baskets, the food does not sweat, and it remains soft and malleable. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 18000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Sus_foodbasket.jpg', 'Cream and Black Food Basket', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Cream and Black Food Basket', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Cream and Black Food Basket', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Cutlery Wall Hanging';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Cutlery Wall Hanging', 'stationery-printing', 'Cutlery wall hanging: Wooden, painted carvings in a hollow box. Assorted cutlery available Colours available: Brown and black Recommended for: Living room accessory Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 24000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_Cutlerywallhanging.jpg', 'Cutlery Wall Hanging', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Cutlery Wall Hanging', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Cutlery Wall Hanging', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Foot Stool';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Foot Stool', 'stationery-printing', 'Footstool: Wooden footstool covered with goat skin Colours available: Brown, black Recommended for: Entry hallway or porch Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 180000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_footstool.jpg', 'Foot Stool', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Foot Stool', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Foot Stool', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Multicoloured Mats';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Multicoloured Mats', 'stationery-printing', 'Multicoloured mats: Made from tough cotton cloth, these mats are useful for outdoor sitting- campfire, beach or a garden party. Colours available: Multiple Recommended for: Sitting, serving food, storing fruit and utensils or hanging as wall decor. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 6800, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_mats.jpg', 'Multicoloured Mats', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Multicoloured Mats', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Multicoloured Mats', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Multicoloured Storage Baskets';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Multicoloured Storage Baskets', 'stationery-printing', 'Multicoloured storage baskets: Made from raffia, banana fibre these baskets are used to store fruit and other essential household items. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 24000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_storagebaskets.jpg', 'Multicoloured Storage Baskets', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Multicoloured Storage Baskets', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Multicoloured Storage Baskets', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Purple Baskets';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Purple Baskets', 'stationery-printing', 'Purple baskets: Comes as a set of three multipurpose use baskets Colours available: Multiple colours Recommended for: Storage- fruits, jewellery, utensils, trinkets Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 180000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_baskets.jpg', 'Purple Baskets', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Purple Baskets', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Purple Baskets', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Table Coasters';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Table Coasters', 'stationery-printing', 'Table coasters: Set of three coasters complete with cow horn storage. Colours available: Brown, black Recommended for: Living room display cabinet or table centre piece Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 95000000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_Tablecoasters.jpg', 'Table Coasters', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Table Coasters', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Table Coasters', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Walking Cane';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Walking Cane', 'stationery-printing', 'Walking cane: Painted and varnished wood Wall hanging: Millet seed waste glued on canvas to create beautiful artwork which is then framed Colours available: Brown and black Recommended for: Living room accessory Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 95000, 'bucket', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Walkingcane.jpg', 'Walking Cane', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Walking Cane', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Walking Cane', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Wide belt';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Wide belt', 'stationery-printing', 'Wide belt adds a flair to your outfit, can add that wildlife chic to your look. Wide belt Material: Cowhide Colours available: Mixed- brown, black and cream Recommended for: A hot date night Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 18000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sust_belt.gif', 'Wide belt', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Wide belt', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Wide belt', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Wooden Foot Stool';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Wooden Foot Stool', 'stationery-printing', 'Wooden footstool with embellished leather seat. Recommended for: Entry hallway or porch Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 180000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Sus_Woodenfootstool.jpg', 'Wooden Foot Stool', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Wooden Foot Stool', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Wooden Foot Stool', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Orange airplane,Stuffed African dolls,,Motorbike';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Orange airplane,Stuffed African dolls,,Motorbike', 'furniture-fittings', 'Children’s toys: Toys made from recycled materials Orange airplane: Bottle tops and wire Ostrich: Bottle tops and wire Brocade elephant: Stuffed with cloth Stuffed African dolls: Cotton and scrap cloth Motorbike: Wire and rubber Recommended for: Safe for child’s play as there are no movable or breakable parts. All cloths are cotton and toys are handmade. Dolls may also make a great collector’s item. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 8500, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_kistoys.jpg', 'Orange airplane,Stuffed African dolls,,Motorbike', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Orange airplane,Stuffed African dolls,,Motorbike', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Orange airplane,Stuffed African dolls,,Motorbike', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Gourd';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Gourd', 'furniture-fittings', 'Gourd: Locally known in Western Uganda as ‘ekyanzi’ these gourds are given to a bride as a send off wedding gift and are used for storing milk. Even before the wedding ceremony, the bride-to-be would be ‘fattened’ for 6 months, given a large gourd of milk cream to consume before sundown. Gourd: Locally known in Western Uganda as ‘ekyanzi’ these gourds are given to a bride as a send off wedding gift and are used for storing milk. Even before the wedding ceremony, the bride-to-be would be ‘fattened’ for 6 months, given a large gourd of milk cream to consume before sundown. Colours available: Various patterns Recommended for: Romantic dinner setting Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 320000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_Gourd.jpg', 'Gourd', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Gourd', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Gourd', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Shell Table Lamp';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Shell Table Lamp', 'furniture-fittings', 'Shell table lamp: Table lamp made of cow bone Colours available: White Recommended for: Romantic dinner setting Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 22000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Shelltablelamp.jpg', 'Shell Table Lamp', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Shell Table Lamp', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Shell Table Lamp', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Assorted Wraps';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Assorted Wraps', 'textiles-apparel', 'Authentic African themed multipurpose cloths Assorted wraps Authentic African themed multipurpose cloths Blue Kikoy cloth: 100%, hand woven Ugandan cotton- 2 metres Red and gray cloth: This cotton sheet, locally known as a Kanga or Lesu, is popular for its eye-catching, vibrant colours- 4 metres Colours available: Multiple colours Recommended for: Visit to a conservative community, lounge wear, bad hair day, beach wear Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 85000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Assorted_-wraps.gif', 'Assorted Wraps', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Assorted Wraps', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Assorted Wraps', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Pure Cotton Accessory Cloths';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Pure Cotton Accessory Cloths', 'textiles-apparel', 'Pure cotton accessory cloths: Drape these over your chairs or on your walls to add colour, chic, or sophistication to a room. They can also be used to create cushion covers, table mats, and other multipurpose cloths Colours available: Multiple colours Recommended for: Living room accessory Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 320000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/accessory-cloths.jpg', 'Pure Cotton Accessory Cloths', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Pure Cotton Accessory Cloths', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Pure Cotton Accessory Cloths', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Assorted Colourful Bangles';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Assorted Colourful Bangles', 'textiles-apparel', 'Who said men cant enjoy colour? Mix and match to get a fun manly look. Assorted colourful bangles Who said men cant enjoy colour? Mix and match to get a fun manly look. Materials: Metal, leather, hide, beads Colours available: Multiple colours Recommended for: Keep the bright ones for a fun day out while the metallic and leather ones are suitable for formal wear Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 180000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_menbangles.gif', 'Assorted Colourful Bangles', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Assorted Colourful Bangles', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Assorted Colourful Bangles', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'His Goat Hide Wallets';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'His Goat Hide Wallets', 'textiles-apparel', 'Own this beautiful wildlife fusion wallet with multiple pockets, and inside leather lining. His goat hide wallets Own this beautiful wildlife fusion wallet with multiple pockets, and inside leather lining. Materials: 100% hand woven Ugandan cotton kikoy material Colours available: Multiple colours Recommended for: A fun day out Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 85000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_hishidewallet.gif', 'His Goat Hide Wallets', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'His Goat Hide Wallets', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'His Goat Hide Wallets', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Men Sandal';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Men Sandal', 'textiles-apparel', 'Sandal: Leather sole, accessorized with goat hide Colours available: Brown and black Recommended for: Lounge wear, weekend wear Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 85000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Sus-MenSandle.jpg', 'Men Sandal', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Men Sandal', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Men Sandal', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Men Sun Hat';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Men Sun Hat', 'textiles-apparel', 'Sun Hat: Sisal with jagged edge pattern Long Shirt: Kikoy with detailing on the neck Colours available: Multiple colours Recommended for: Weekend wear Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 85000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_mensunhat.gif', 'Men Sun Hat', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Men Sun Hat', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Men Sun Hat', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Natural Necklace';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Natural Necklace', 'textiles-apparel', 'Wear two together; a plant seed necklace teemed with an ivory necklace Natural necklace Wear two together; a plant seed necklace teemed with an ivory necklace Materials: Seeds and ivory Colours available: Brown and black and white Recommended for: Weekend wear Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 25000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_menecklace.jpg', 'Natural Necklace', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Natural Necklace', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Natural Necklace', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Zebra Themed Accessories';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Zebra Themed Accessories', 'textiles-apparel', 'The black and white look never goes wrong and in this case the zebra pattern creates an exquisite look Zebra themed accessories The black and white look never goes wrong and in this case the zebra pattern creates an exquisite look Materials: Cow horn Colours available: Multiple colours Recommended for: Both formal and informal occasions. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 85000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Zebrathemedaccessories.gif', 'Zebra Themed Accessories', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Zebra Themed Accessories', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Zebra Themed Accessories', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Scarves: Kikoy Long Scarf';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Scarves: Kikoy Long Scarf', 'textiles-apparel', 'Scarves: Kikoy long scarf Colours available: Multiple colours Recommended for: Cold evening out on the high street Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 85000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Kikoy_long_scarf.gif', 'Scarves: Kikoy Long Scarf', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Scarves: Kikoy Long Scarf', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Scarves: Kikoy Long Scarf', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Shirts: Kikoy and cotton';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Shirts: Kikoy and cotton', 'textiles-apparel', 'Shirts: Kikoy and cotton Colours available: Multiple colours Recommended for: Weekend wear, lounge wear Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 85000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Shirts_Kikoyandcotton.jpg', 'Shirts: Kikoy and cotton', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Shirts: Kikoy and cotton', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Shirts: Kikoy and cotton', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'African Sisal Hats';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'African Sisal Hats', 'textiles-apparel', 'Protect yourself from the sun or create a fun chic look by tying your favourite scarf around the hat. African sisal hats Protect yourself from the sun or create a fun chic look by tying your favourite scarf around the hat. Materials: 100% hand woven Ugandan cotton kikoy material Colours available: Multiple colours Recommended for: A fun day out Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 85000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'African Sisal Hats', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'African Sisal Hats', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_slingbag.jpg', 'African Sisal Hats', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Her Goat Hide Wallets';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Her Goat Hide Wallets', 'textiles-apparel', 'Own this beautiful wildlife fusion wallet with multiple pockets, and inside leather lining. Her goat hide wallets Own this beautiful wildlife fusion wallet with multiple pockets, and inside leather lining. Materials: 100% hand woven Ugandan cotton kikoy material Colours available: Multiple colours Recommended for: A fun day out Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 85000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_ladieshidewallet.gif', 'Her Goat Hide Wallets', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Her Goat Hide Wallets', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Her Goat Hide Wallets', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'African Themed Kikoy Sling Bag';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'African Themed Kikoy Sling Bag', 'textiles-apparel', 'Enjoy a day out on the beach or a shopping spree with this colourful easy bag African themed kikoy sling bag Enjoy a day out on the beach or a shopping spree with this colourful easy bag Materials: 100% hand woven Ugandan cotton kikoy material Colours available: Multiple colours Recommended for: A fun day out Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 1800, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_slingbag.jpg', 'African Themed Kikoy Sling Bag', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'African Themed Kikoy Sling Bag', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'African Themed Kikoy Sling Bag', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Bark Cloth Executive Bag';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Bark Cloth Executive Bag', 'textiles-apparel', 'Made from tree bark traditionally used by the Baganda tribe in Uganda to make bark cloth, this bag is a classic formal look Bark cloth executive bag Made from tree bark traditionally used by the Baganda tribe in Uganda to make bark cloth, this bag is a classic formal look Materials: 100% tree bark with rolled leather handles Colours available: Brown Recommended for: Formal wear Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 1800, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Sus_Barkclothbag.gif', 'Bark Cloth Executive Bag', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Bark Cloth Executive Bag', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Bark Cloth Executive Bag', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Candy Kiondo bags';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Candy Kiondo bags', 'textiles-apparel', 'A handy durable bag with flat base great for slipping in papers/envelopes Candy Kiondo bags A handy durable bag with flat base great for slipping in papers/envelopes Materials: Twisted sisal grass, hand dyed and hand woven. Rolled leather handle with zip. Lined interior with small inner pockets. Colours available: Multiple colours Recommended for: Office and other semi-casual wear Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 25000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Sus_Kiondo_bags.jpg', 'Candy Kiondo bags', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Candy Kiondo bags', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Candy Kiondo bags', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'African Free Tie and Dye Dress';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'African Free Tie and Dye Dress', 'textiles-apparel', 'Enjoy the cool breeze in a zebra patterned or cream cotton ankle length dress which allows for comfort, aeration with a hint of simple sophistication. They all come with a matching head wrap and are available sleeveless or short sleeves with a variety of neck shapes and shoulder designs. African free tie and dye dress Enjoy the cool breeze in a zebra patterned or cream cotton ankle length dress which allows for comfort, aeration with a hint of simple sophistication. They all come with a matching head wrap and are available sleeveless or short sleeves with a variety of neck shapes and shoulder designs. Materials: 100% hand woven Ugandan cotton Colours available: Multiple colours Recommended for: Formal occasion, pre and post pregnancy wear, tea party Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 18000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'African Free Tie and Dye Dress', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'African Free Tie and Dye Dress', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_slingbag.jpg', 'African Free Tie and Dye Dress', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Lounge cloth';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Lounge cloth', 'textiles-apparel', 'Enjoy the cool breeze in a zebra patterned or cream cotton wrap which allows for comfort, aeration with a hint of simple sophistication Lounge cloth Enjoy the cool breeze in a zebra patterned or cream cotton wrap which allows for comfort, aeration with a hint of simple sophistication Materials: 100% hand woven Ugandan cotton Colours available: Multiple colours Recommended for: Lounge wear Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 18000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/lounge_clothes.gif', 'Lounge cloth', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_tieanddye.gif', 'Lounge cloth', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sus_sisalhats.jpg', 'Lounge cloth', true);
  end if;
end $$;

-- Maridadi Crafts & Design · +256752555438+256712875886 · 3 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'maridadi-crafts-design@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'maridadi-crafts-design@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256752555438+256712875886' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'trader', 'free', 'Maridadi Crafts & Design', 'Maridadi Crafts & Design',
      'MC', '+256752555438+256712875886', null, '+256752555438+256712875886', 'maridadi-crafts-design@suppliers.bubu.market',
      '4054, Kiwafu Road, Kansanga, Kampala', 'kampala', 'stationery, art and printing', 'Maridadi Crafts & Design supplies stationery, art and printing from Kampala. 3 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Maridadi Crafts & Design supplies stationery, art and printing from Kampala. 3 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'stationery-printing') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Banana%20Fibre%20_BASKETS.jpg', 'Maridadi Crafts & Design — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Banana Fiber Tray';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Banana Fiber Tray', 'stationery-printing', 'This is a Banana Fiber Tray hand-made and wooven to perfection using banana fibres.. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 24000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Banana-Fibre-tray.gif', 'Banana Fiber Tray', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Banana+Fibre+_BASKETS.jpg', 'Banana Fiber Tray', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Banana-Fibre-_BASKETS2.gif', 'Banana Fiber Tray', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Banana Fibre Baskets';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Banana Fibre Baskets', 'stationery-printing', 'These Baskets are made of both Banana fibre and sisal. The Banana fibre is dorminanty used for the final finish of the basket and the sisal is used as an additional touch to the design. The baskets an be used for decorating a living room or sitting room, they can be used for carrying dry foodstuffs, and can also be used for parties in the best way that could suite you. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 24000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Banana%20Fibre%20_BASKETS.jpg', 'Banana Fibre Baskets', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Banana-Fibre-tray.gif', 'Banana Fibre Baskets', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Banana+Fibre+_BASKETS.jpg', 'Banana Fibre Baskets', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Earrings';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Earrings', 'stationery-printing', 'Sample of our earrings summary Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 24000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Earings.gif', 'Earrings', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Banana-Fibre-tray.gif', 'Earrings', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Banana+Fibre+_BASKETS.jpg', 'Earrings', true);
  end if;
end $$;

-- Nnyanzi Art Studio · +256772345079+256752345079 · 16 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'nnyanzi-art-studio@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'nnyanzi-art-studio@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256772345079+256752345079' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'trader', 'free', 'Nnyanzi Art Studio', 'Nnyanzi Art Studio',
      'NA', '+256772345079+256752345079', null, '+256772345079+256752345079', 'nnyanzi-art-studio@suppliers.bubu.market',
      'Kampala, Uganda, Shop number 30 in the NACCAU Arts and Crafts village, next to the National Theatre on Plot 4/6 Dewinton road., Central, Kam', 'kampala', 'stationery, art and printing', 'Nnyanzi Art Studio supplies stationery, art and printing from Kampala. 16 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Nnyanzi Art Studio supplies stationery, art and printing from Kampala. 16 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'stationery-printing') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/5-Nnyanzi-Art-Studio-Cover-5.jpg', 'Nnyanzi Art Studio — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Fond Memories';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Fond Memories', 'stationery-printing', 'PAINTING TITLE : Fond Memories. ARTIST : Nuwa Wamala Nnyanzi. MEDIUM: Batik. SIZE: 41x56 cm (16"x22"). YEAR: 2014. PRICE: $300. You were my gleam. A precious gift to me. Forever is what I thought you and I will be. You came into my life like a shooting star. Then left faster than you appeared! Hardly did I know, life had other calculations! I think back to the times we used to take a dip in the deep ends of the lake! Your irresistible smile vanishing into the water as you swam. I will never let you slip from my heart...! Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 6800, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_11496256.jpg', 'Fond Memories', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_114962630.jpg', 'Fond Memories', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_114962815.jpg', 'Fond Memories', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'African Symbols';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'African Symbols', 'stationery-printing', 'PAINTING Title: African Symbols. Artist: Nuwa Wamala Nnyanzi. Medium: Acrylics on canvas. Size: 41x26 cm (22"x16") Year: 2015. Price: $750 Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 6800, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_114962630.jpg', 'African Symbols', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_11496256.jpg', 'African Symbols', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_114962815.jpg', 'African Symbols', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Alone and not frightened!';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Alone and not frightened!', 'stationery-printing', 'PAINTING Title:Alone and not frightened! Artst: Nuwa Wamala Nnyanzi Medium: Acrylics on barkcloth Size: 91x61 cm (36"x24") Year: 2023 Price: $ 500 Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 6800, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_114962815.jpg', 'Alone and not frightened!', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_11496256.jpg', 'Alone and not frightened!', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_114962630.jpg', 'Alone and not frightened!', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Balancing Act';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Balancing Act', 'stationery-printing', 'PAINTING Title:Balancing Act Artst: Nuwa Wamala Nnyanzi Medium: Serigraph (limited edition of 950) Size: 40.5 x 61 cm (16"x24" ) Year: 1991 Price: $ 20. Handpulled silk screen print of cotton fabric. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 6800, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_115052140.jpg', 'Balancing Act', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_11496256.jpg', 'Balancing Act', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_114962630.jpg', 'Balancing Act', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Closely knit family';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Closely knit family', 'stationery-printing', 'PAINTING - TITLE: Closely knit family. ARTIST : Nuwa Wamala Nnyanzi. MEDIUM : Acrylics on canvas. SIZE: 46x61 cm (18"x24"). PRICE: $400. Dad is our greatest support system! He provides and protects us all. Mum is our sunlight, she provides love and care to us all. Us the children, we provide happiness and wonders in their lives. We back each other up, we are a great team. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 6800, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_114962110.jpg', 'Closely knit family', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_11496256.jpg', 'Closely knit family', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_114962630.jpg', 'Closely knit family', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Couple In Love';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Couple In Love', 'stationery-printing', 'Artist : Nuwa Wamala Nnyanzi Title : Couple In Love Code : NWN/41 Medium: Serigraph (Ltd Ed) Size: 20×45.5 cm (8″x18″) Year : 1991 Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 24000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_114110155.jpg', 'Couple In Love', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery31728-3697102511.png', 'Couple In Love', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_11496256.jpg', 'Couple In Love', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Divine Messangers';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Divine Messangers', 'stationery-printing', 'PAINTING TITLE : Divine Messangers. ARTIST : Nuwa Wamala Nnyanzi. MEDIUM: Batik. SIZE: 56x40.5 cm (22"x16"). YEAR: 2008. PRICE: $500 Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 6800, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_114962537..jpg', 'Divine Messangers', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_11496256.jpg', 'Divine Messangers', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_114962630.jpg', 'Divine Messangers', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Freedom of Worship';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Freedom of Worship', 'stationery-printing', 'PAINTING TITLE: Freedom of Worship. ARTIST : Nuwa Wamala Nnyanzi. MEDIUM : Acrylics on canvas. SIZE: 46x61 cm (18"x24"). YEAR : 2013. PRICE: $400. I am free to believe! I am free to affirm his presence. I am free to sing to the almighty. I am free to praise the King! Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 6800, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_114962253.jpg', 'Freedom of Worship', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_11496256.jpg', 'Freedom of Worship', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_114962630.jpg', 'Freedom of Worship', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Investor or Harvester?';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Investor or Harvester?', 'stationery-printing', 'PAINTING Title: Investor or Harvester? Artist: Nuwa Wamala Nnyanzi. Medium: Acrylics on canvas. Size: 76x74 cm (30"x29") Year: 2022. Price: $500 Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 6800, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_114962719.jpg', 'Investor or Harvester?', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_11496256.jpg', 'Investor or Harvester?', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_114962630.jpg', 'Investor or Harvester?', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Joyful Pounder';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Joyful Pounder', 'stationery-printing', 'Artist : Nuwa Wamala Nnyanzi Title : Joyful Pounder Code : NWN/02 Medium: Serigraph (Ltd Ed) Size: 40.5 x 61 cm (16″x24″) Year : 1991 Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 24000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_1141101548.jpg', 'Joyful Pounder', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery31728-3697102830.png', 'Joyful Pounder', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_11496256.jpg', 'Joyful Pounder', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Out-Doing Each Other';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Out-Doing Each Other', 'stationery-printing', 'Artist : Nuwa Wamala Nnyanzi Title : Out-Doing Each Other Code : NWN/05 Medium: Serigraph (Ltd Ed) Size: 61×40.5 cm (24″x16″) Year : 1991 Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 24000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_1141101631.jpg', 'Out-Doing Each Other', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery31728-3697103151.png', 'Out-Doing Each Other', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_11496256.jpg', 'Out-Doing Each Other', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Peace Talks';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Peace Talks', 'stationery-printing', 'Artist : Nuwa Wamala Nnyanzi Title : Peace Talks Code : NWN/04 Medium: Serigraph (Ltd Ed) Size: 16” x 22” ( 38 x 66 cm) Year : 1991 Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 24000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_1141101746.jpg', 'Peace Talks', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery31728-3697103540.png', 'Peace Talks', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_11496256.jpg', 'Peace Talks', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Responding to advice';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Responding to advice', 'stationery-printing', 'PAINTING TITLE: Responding to advice ARTIST: Nuwa Wamala Nnyanzi MEDIUM: Neon acrylics on canvas SIZE: 61x91 cm or 24"x36" YEAR: 2023 PRICE: $500. Only the wise can take in advise and instill it in their lives. The wise one will listen and act as soon as possible. The foolish one never listens, he finds the advise useless and unproductive. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 6800, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_114962157.jpg', 'Responding to advice', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_11496256.jpg', 'Responding to advice', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_114962630.jpg', 'Responding to advice', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'The Answer';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'The Answer', 'stationery-printing', 'Artist: Nuwa Wamala Nnyanzi Title: The answer Code: NWN/WEB/025 Size: 22” x 16” (56 x 40..5 cm) Medium: Batik Year: 2011 Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 24000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_1141101355.jpg', 'The Answer', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery31728-3697102149.png', 'The Answer', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_11496256.jpg', 'The Answer', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'The Holy Family';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'The Holy Family', 'stationery-printing', 'PAINTING TITLE : The Holy Family . ARTIST : Nuwa Wamala Nnyanzi. MEDIUM: Batik. SIZE: 38x56 cm (15"x22"). YEAR: 2012. PRICE: $300. Saint Joseph, the father among father''s. The protector of the Church. A Guardian of his people. A patient man, one of a kind. Overseer of the family. The Virgin Mary, the mother of our saviour. The mother to the motherless. The queen of our hearts. The handmaid of our Lord. The heart of the family. Jesus Christ, the Holy son of God. The head of the church. Saviour of all believers. A blessing to human kind. The Holy family that places God at the center of their lives. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 6800, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_114962431.jpg', 'The Holy Family', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_11496256.jpg', 'The Holy Family', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_114962630.jpg', 'The Holy Family', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'United States of Love';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'United States of Love', 'stationery-printing', 'PAINTING TITLE: United States of Love ARTIST: Nuwa Wamala Nnyanzi MEDIUM: Acrylics on canvas SIZE: 91x61 cm (36"x24") YEAR: 2023 PRICE: $500. Imagine the world Living as a global village Coming together as one We can be called the World Citizens Loving each other through it all! Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 6800, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_114962341.jpg', 'United States of Love', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_11496256.jpg', 'United States of Love', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_31728_114962630.jpg', 'United States of Love', true);
  end if;
end $$;

-- Priamit Enterprises Limited · +256772736444+256414232116230068 · 1 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'priamit-enterprises-limited@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'priamit-enterprises-limited@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256772736444+256414232116230068' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'trader', 'free', 'Priamit Enterprises Limited', 'Priamit Enterprises Limited',
      'PE', '+256772736444+256414232116230068', null, '+256772736444+256414232116230068', 'priamit-enterprises-limited@suppliers.bubu.market',
      'Kampala, Uganda., Plot 16/1, Madhvani Building, Jinja Road, Kampala. (Opp Total Filling Station), Central, Kampala', 'kampala', 'vehicles and auto parts', 'Priamit Enterprises Limited supplies vehicles and auto parts from Kampala. 1 line is listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Priamit Enterprises Limited supplies vehicles and auto parts from Kampala. 1 line is listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'auto-parts') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Prod-_14773_693112645.png', 'Priamit Enterprises Limited — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'DUELER M/T673';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'DUELER M/T673', 'auto-parts', 'Sporting a dynamic tread pattern, the T673 off-road offers superior traction and self-cleaning capacity particularly on mud and dirt surfaces. SIZES 215/75R 15 6ply - 235/75R 15 6ply 30-9.50R 15 6ply - 31-10.50R 15 6ply 32-11.50R 15 6ply - 245/75R 16 6 ply 265/75R 16 6 ply - 285/75R 16 6 ply Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 260000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14773_693112645.png', 'DUELER M/T673', true);
  end if;
end $$;

-- MOTORCARE UGANDA LIMITED · +256772200014+256312238100 · 4 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'motorcare-uganda-limited@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'motorcare-uganda-limited@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256772200014+256312238100' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'trader', 'free', 'MOTORCARE UGANDA LIMITED', 'MOTORCARE UGANDA LIMITED',
      'MU', '+256772200014+256312238100', null, '+256772200014+256312238100', 'motorcare-uganda-limited@suppliers.bubu.market',
      'Kampala, Uganda, Plot 95, Jinja Road, Central, Kampala', 'kampala', 'vehicles and auto parts', 'MOTORCARE UGANDA LIMITED supplies vehicles and auto parts from Kampala. 4 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'MOTORCARE UGANDA LIMITED supplies vehicles and auto parts from Kampala. 4 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'auto-parts') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Offices.gif', 'MOTORCARE UGANDA LIMITED — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Heavy Duty & Commercial Vehicle Equipment - NISSAN NP300 HARDBODY';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Heavy Duty & Commercial Vehicle Equipment - NISSAN NP300 HARDBODY', 'auto-parts', 'The NISSAN NP300 HARDBODY has a backbone to match, too. A full-length, closed section ladder-type frame with high-tensile-strength steel – stronger than conventional steel – in strategic areas ensures improved structural rigidity. This means increased torsional stiffness, helping to deliver enhanced performance on-and off-road, whatever the load. Further proof that the NISSAN NP300 HARDBODY is the pickup built to tackle any challenge Africa has to offer. MADE FOR BUSINESS Inside and out, the Nissan NP300 Hardbody is designed to keep your business moving in the right direction OUR PROMISE TO YOU At Nissan we keep our promises and take care of our family. Servicing and repairing your Nissan at an authorised Nissan dealership is the way to go. Our Nissan technicians are highly trained specialists that know your Nissan better than anyone. They will use Genuine Nissan Parts, Genuine Nissan… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 95000000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_17822_68711417.png', 'Heavy Duty & Commercial Vehicle Equipment - NISSAN NP300 HARDBODY', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery17822-3243114945.jpg', 'Heavy Duty & Commercial Vehicle Equipment - NISSAN NP300 HARDBODY', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_17822_68616636.png', 'Heavy Duty & Commercial Vehicle Equipment - NISSAN NP300 HARDBODY', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'NISSAN ALMERA';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'NISSAN ALMERA', 'auto-parts', 'PERFORMANCE AND ECONOMY The Nissan ALMERA is powered by an impressive 1.5 litre petrol engine available in manual or automatic transmission, delivering 73kW of power with 134Nm of torque – enough to get you from A to B in no time. While the Nissan ALMERA feels like a big car on the inside, it still offers small sedan efficiency. When it comes to performance and outstanding fuel economy, the Nissan ALMERA really is the intelligent choice for those looking for big value for money. INTERIOR Step inside and the Nissan ALMERA delivers confident and modern sophistication that is practical, ergonomic, functional and aesthetically pleasing. The intelligently designed cabin layout puts all the controls you need right at your fingertips, from audio control to boot release, powered mirror control to remote central locking. High quality finishes compliment the vehicle’s stylish design, while… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 260000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_17822_68616636.png', 'NISSAN ALMERA', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_17822_68711417.png', 'NISSAN ALMERA', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_17822_68795832.jpg', 'NISSAN ALMERA', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'NISSAN PATROL';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'NISSAN PATROL', 'auto-parts', 'ALL CLASS. ALL TERRAIN. The iconic Nissan PATROL has always been the pinnacle of capability and versatility. It is now also the pinnacle of luxury and style. The new Nissan PATROL combines 70 years of legendary capability with a new standard in SUV refinement. PURE V8 POWER AT YOUR COMMAND There is no substitute for pure power, and the Nissan PATROL’s 5.6L V8 engine allows you to go where others don’t dare. With a class leading 298kW of power, and an exceptional 560Nm of torque, this remarkably fuel efficient engine allows you to take command of any terrain. OFF-ROAD CAPABILITY TO CONQUER ANY TERRAIN Power and technology meet with Intelligent 4x4, ensuring that no matter how demanding the driving conditions, the Nissan PATROL will have maximum grip at all times, transferring drive between wheels and axles. Simply switch between four drive modes with just a press of a button. TOUGH… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 260000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_17822_68795832.jpg', 'NISSAN PATROL', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery17822-3243101254.jpg', 'NISSAN PATROL', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery17822-324310130.jpg', 'NISSAN PATROL', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'NISSAN XTRAIL';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'NISSAN XTRAIL', 'auto-parts', 'MADE FOR FAMILY ADVENTURE Nissan Genuine Accessories are designed to make your family adventures bigger and more enjoyable, enabling you to take all the essential gear for an unforgettable getaway. INTELLIGENT POWER. GO FURTHER WITH A CLEAN CONSCIENCE Looking for excellent fuel economy in a roomy crossover that’s lots of fun to drive? That’s what you get with the Nissan X-TRAIL. From exterior aerodynamics that whisper through the wind to advanced engines and a virtually gearless XTRONIC transmission, it takes efficiency and performance to the next level. NISSAN INTELLIGENT DRIVING. ADAPT TO ANY TYPE OF CONDITION IN THE BLINK OF AN EYE The Nissan X-TRAIL can adapt to changing conditions 30 times faster than the blink of an eye. Whether it’s sand or gravel, rain-covered surfaces or a tight turn, the system will automatically send power to the wheels that need it the most. Even in ideal… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 320000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_17822_686162749.jpg', 'NISSAN XTRAIL', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_17822_68616636.png', 'NISSAN XTRAIL', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_17822_68711417.png', 'NISSAN XTRAIL', true);
  end if;
end $$;

-- TOYOTA UGANDA LTD · +256800211033+256414349425 · 4 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'toyota-uganda-ltd@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'toyota-uganda-ltd@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256800211033+256414349425' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'trader', 'free', 'TOYOTA UGANDA LTD', 'TOYOTA UGANDA LTD',
      'TU', '+256800211033+256414349425', null, '+256800211033+256414349425', 'toyota-uganda-ltd@suppliers.bubu.market',
      'P. O. Box 31732 Kampala, Plot 1A & 1B First Street, Industrial Area, Kampala, Central, Kampala', 'kampala', 'vehicles and auto parts', 'TOYOTA UGANDA LTD supplies vehicles and auto parts from Kampala. 4 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'TOYOTA UGANDA LTD supplies vehicles and auto parts from Kampala. 4 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'auto-parts') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Prod-_17820_68215322.png', 'TOYOTA UGANDA LTD — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Heavy Duty & Commercial Vehicle Equipment - Toyota Hilux';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Heavy Duty & Commercial Vehicle Equipment - Toyota Hilux', 'auto-parts', 'With its advanced chassis and bodywork, the Toyota Hilux is the pick-up by excellence thanks to its unprecedented power proven for more than 50 years. The power and performance of this 4x4 meets every challenge whether it in the city or on off-road. Its robust but sporty design offers the promise of an exhilarating driving sensation in single or double cabin variants with an automatic or manual transmission. More adventurous, more powerful and more agile than ever, Hilux offers an exceptional level of driving and comfort as well as an unprecedented safety. Made in Africa, for Africa. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 95000000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_17820_68215322.png', 'Heavy Duty & Commercial Vehicle Equipment - Toyota Hilux', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_17820_682145747.png', 'Heavy Duty & Commercial Vehicle Equipment - Toyota Hilux', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_17820_686124910.jpg', 'Heavy Duty & Commercial Vehicle Equipment - Toyota Hilux', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Heavy Duty & Commercial Vehicle Equipment - TOYOTA-COASTER';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Heavy Duty & Commercial Vehicle Equipment - TOYOTA-COASTER', 'auto-parts', 'ENGINE •Displacement (cc) : 4164 •Fuel System : Other •Fuel type : Diese DIMENSIONS •Dimensions (Lxwxh) in mm : 6990 x 2080 x 2635 •Ground clearance (mm) : 180 •Wheelbase (mm) : 2635 TRANSMISSION •Gearbox : Manual • WEIGHT/CAPACITIES •Curb weight (kg) : 3660 •Fuel tank capacity (L) : 95 WARRANTY •Manufacturer Warranty : 3 years / 100 000 Km •Retail Network : Toyota Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 32000, 'bag', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_17820_686124910.jpg', 'Heavy Duty & Commercial Vehicle Equipment - TOYOTA-COASTER', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery17820-3242125754.jpg', 'Heavy Duty & Commercial Vehicle Equipment - TOYOTA-COASTER', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_17820_68215322.png', 'Heavy Duty & Commercial Vehicle Equipment - TOYOTA-COASTER', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Toyota Land Cruiser 200 LC200 4.5L GX-R 6-AT 4x4';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Toyota Land Cruiser 200 LC200 4.5L GX-R 6-AT 4x4', 'auto-parts', 'The Land Cruiser 200 sets new standards that makes this 4x4 the ultimate luxury and adventure companion. The comfort of its ultra-luxury and spacious interior is ensured by an easily configurable seating arrangement, an advanced air conditioning system, as well as numerous technological accessories. To handle efficiently all situations, the chassis and bodywork form an unequalled synergy of strength allowing a unique stability. Available with a petrol or diesel engine with manual or automatic transmission, it ensures powerful performance and exceptional journey. Tested in the most difficult driving conditions, the LC200 combines elegance and a premium level of comfort and safety. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 95000000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_17820_682145747.png', 'Toyota Land Cruiser 200 LC200 4.5L GX-R 6-AT 4x4', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_17820_68215322.png', 'Toyota Land Cruiser 200 LC200 4.5L GX-R 6-AT 4x4', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_17820_686124910.jpg', 'Toyota Land Cruiser 200 LC200 4.5L GX-R 6-AT 4x4', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'TOYOTA-RAV4';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'TOYOTA-RAV4', 'auto-parts', 'ENGINE •Displacement (cc) : 1987 •Fuel System : Electronic Fuel Injection •Fuel type : Petrol DIMENSIONS •Dimensions (Lxwxh) in mm : 4600 x 1855 x 1685 •Ground clearance (mm) : 195 •Wheelbase (mm) : 2690 TRANSMISSION •Gearbox : Manual, Automatic CVT, Automatic •Transmission : Front 2 WD, All time 4x4 WEIGHT/CAPACITIES •Curb weight (kg) : 1500 •Fuel tank capacity (L) : 55 WARRANTY Manufacturer Warranty : 3 years / 100 000 Km •Retail Network : Toyota Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 32000, 'bag', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_17820_686134537.png', 'TOYOTA-RAV4', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery17820-324215413.png', 'TOYOTA-RAV4', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_17820_68215322.png', 'TOYOTA-RAV4', true);
  end if;
end $$;

-- Simba Automotives · +256756670579+256711199999 · 4 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'simba-automotives@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'simba-automotives@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256756670579+256711199999' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'trader', 'free', 'Simba Automotives', 'Simba Automotives',
      'SA', '+256756670579+256711199999', null, '+256756670579+256711199999', 'simba-automotives@suppliers.bubu.market',
      '84, Kira Road, Central, Kampala', 'kampala', 'vehicles and auto parts', 'Simba Automotives supplies vehicles and auto parts from Kampala. 4 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Simba Automotives supplies vehicles and auto parts from Kampala. 4 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'auto-parts') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/250ccPolice.jpg', 'Simba Automotives — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Police Bike';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Police Bike', 'auto-parts', 'Technical Specifications FEATURES 1) Public Addressing System With Mic. 2) Siren (2 sides) with 3 types of sound system- (a) Emergency (b) Police Presentation (c) Road Clearance 3) Warning Lights 4) Police light Blue & Red 5) Two side boxes + one rear box with lights & turn indicators. 6) All controls on hand 7) Charging socket 8) Digital meter 9) 250 cc reliable & strong engine (strong pick up) 10) All terrain motorcycle 11) 15000 KM - warranty on engine 12) Front & Rear Disc Brakes 13) Six free services only consumable to be charged 14) Call away service from Simba Automotives Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 420000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/250ccPolice.jpg', 'Police Bike', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/2STROK.jpg', 'Police Bike', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/takken4.jpg', 'Police Bike', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Star Delux 150cc';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Star Delux 150cc', 'auto-parts', 'Technical Specifications Dimensions Overall Length 1760 mm Overall Width 695 mm Wheel Base 1235 mm Seat Height 820 mm Maximum Road Clearance 160 Weights Vehicle KERB Wt. 104 Kg for KS & 107 Kg for ES Engine Displacement 149.56 CC Bore 57.8 mm Stroke 57.0 mm Compression Ratio 9.0 ± 0.5:1 Max. Output/Power 6.3 Kw at 5500 RPM Maximum Torque IINM at 3250 RPM Clutch Multiplate, Oil bath type(wet) Spark Plug Champion - RN9YC; Mico BOSCH - WR8DC Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 95000000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/2STROK.jpg', 'Star Delux 150cc', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/250ccPolice.jpg', 'Star Delux 150cc', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/takken4.jpg', 'Star Delux 150cc', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'TEKKEN 250 CC';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'TEKKEN 250 CC', 'auto-parts', 'Technical Specifications Engine and Transmission Engine Type RE250 Displacement(cc) 223 Engine Model Name 169FML Carburator Model Name and Specification PZ30?Main Jet105#?Idle Jet30# Bore x Stroke (mm) 69x62.2 Max.Power 12.5/7500 Max.Torque 17/6000 Compression Ratio 8.6:1 Fuel System Carburetor, Fuel Tank, Fuel Cock Fuel Control Plunger Type Carburetor Ignition C.D.I Starter Kick & Electric (Self) Lubrication System Pressure Splash Cooling System Oil Cool Gearbox Primary 3.33 1st Gear 2.909 2nd Gear 1.867 3rd Gear 1.389 4th Gear 1.15 5th Gear 0.95 Transmission Type Final Drive 520 Chain Driving Sprocket 16T Driven Sprocket 46T Clutch Type Oil-Immersed 6 Plate Physical Measures Dry Weight (Kgs) 132 Seat Height (mm) 820 Overall Height (mm) 1180 Overall Length (mm) 2100 Overall Width (mm) 860 Wheelbase (mm) 1370 Ground Clearance (mm) 260 Chassis and Dimensions Frame Type Crosstour Front… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 32000, 'bag', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/takken4.jpg', 'TEKKEN 250 CC', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/250ccPolice.jpg', 'TEKKEN 250 CC', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/2STROK.jpg', 'TEKKEN 250 CC', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'UG BOSS 125 cc';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'UG BOSS 125 cc', 'auto-parts', 'Technical Specifications Engine Engine Type 4 Stroke Single Cylinder Displacement 124.6cc Carburator Keihin PZ26 Bore & stroke (mm) 56.5x49.5 Max Power 7.1KW Max Torque 9.7 Compression Ratio 9:6:1 Fuel System Petrol 9397 octane Ignition Model CDI Start Mode Electric And Kick Start Lubrication System Pressure, SPLASH Cooling System Air cooled Gear Box 5 Speed Transmission Transmission Type Chain Drive Clutch Type Wet Multi-plate Chasis And Dimensions Frame Type Double cradle frame with silent bush engine mountings Front Suspension Front Shock Absorber With Rubber Dust Cover Rear Suspension Rear Shock Absorber With Progressive Load Springs Front Tire Size 2.75x17 Rear Tire Size 3.00x17 Break Type(F/R) 130mmbigger Drum Brakes Physical Measurement Product Dimensions[LXWXH](MM) 2040x750x1055 Net Weight(KG) 125 Seat weight:(mm) 790 Wheel Base:(MM) 1315 Ground Clearance:(MM) 163 Others Top… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 32000, 'bag', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/ug_boss-main.jpg', 'UG BOSS 125 cc', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/250ccPolice.jpg', 'UG BOSS 125 cc', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/2STROK.jpg', 'UG BOSS 125 cc', true);
  end if;
end $$;

-- Spear Motors Limited · +256392222696+256414285551 · 2 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'spear-motors-limited@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'spear-motors-limited@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256392222696+256414285551' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'trader', 'free', 'Spear Motors Limited', 'Spear Motors Limited',
      'SM', '+256392222696+256414285551', null, '+256392222696+256414285551', 'spear-motors-limited@suppliers.bubu.market',
      'Plot M428, Nakawa,Jinja Road, Central, Kampala', 'kampala', 'vehicles and auto parts', 'Spear Motors Limited supplies vehicles and auto parts from Kampala. 2 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Spear Motors Limited supplies vehicles and auto parts from Kampala. 2 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'auto-parts') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Prod-_432_682114439.4%20LTD.png', 'Spear Motors Limited — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'JEEP RENEGADE 1.4 LTD';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'JEEP RENEGADE 1.4 LTD', 'auto-parts', 'The design of the new Jeep Renegade contributes to reducing air friction and drag, leaving you with best-in-class aerodynamics and optimal fuel efficiency. The well engineered technology on this model helps make it a bit roomier, and improves fuel consumption, reduces wind noise, and much more. Check it out today. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 260000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_432_682114439.4%20LTD.png', 'JEEP RENEGADE 1.4 LTD', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_432_682114439.4+LTD.png', 'JEEP RENEGADE 1.4 LTD', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_432_682105127.png', 'JEEP RENEGADE 1.4 LTD', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'MERCEDES BENZ V220D';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'MERCEDES BENZ V220D', 'auto-parts', 'This new V-class model is spacious and comfortable, with must-have features at a great price. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 6800, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_432_682105127.png', 'MERCEDES BENZ V220D', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery432-3238132147.jpg', 'MERCEDES BENZ V220D', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_432_682114439.4+LTD.png', 'MERCEDES BENZ V220D', true);
  end if;
end $$;

-- Real Oils · +256754351607+256700270790 · 4 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'real-oils@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'real-oils@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256754351607+256700270790' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'manufacturer', 'free', 'Real Oils', 'Real Oils',
      'RO', '+256754351607+256700270790', null, '+256754351607+256700270790', 'real-oils@suppliers.bubu.market',
      'Wakiso, Uganda, Nangabo, Munyonyo, Kampala', 'kampala', 'cleaning and personal care', 'Real Oils supplies cleaning and personal care from Kampala. 4 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Real Oils supplies cleaning and personal care from Kampala. 4 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'cleaning-hygiene') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/be673621-5247-4677-afe1-8fd635dc9212_Castor-Oils-Flyers-International.jpg', 'Real Oils — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Tools & Accessories - 1 Litre Castor Oil - Real Oils Uganda';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Tools & Accessories - 1 Litre Castor Oil - Real Oils Uganda', 'cleaning-hygiene', 'Real Oils Uganda''s Castor oil is a versatile natural remedy derived from the seeds of the Ricinus communis plant. It has been used for centuries in traditional medicine and modern skincare due to its powerful healing properties. Below are all the known health benefits and uses of castor oil: 1. Skin Health Moisturizes Dry Skin – Deeply hydrates and nourishes dry, flaky skin. Fights Acne – Has antibacterial and anti-inflammatory properties that help reduce acne. Anti-Aging Properties – Rich in antioxidants and fatty acids that help reduce wrinkles and fine lines. Heals Wounds and Cuts – Accelerates wound healing by promoting tissue growth. Soothes Sunburns – Reduces inflammation and hydrates sun-damaged skin. Treats Skin Infections – Has antimicrobial properties that help treat fungal infections, including ringworm. 2. Hair and Scalp Care Promotes Hair Growth – Stimulates hair follicles…', 100000, 'item', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_38683_206863839.jpg', 'Tools & Accessories - 1 Litre Castor Oil - Real Oils Uganda', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery38683-4475114333.jpg', 'Tools & Accessories - 1 Litre Castor Oil - Real Oils Uganda', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery38683-4475114358.jpg', 'Tools & Accessories - 1 Litre Castor Oil - Real Oils Uganda', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Real Castor Oils 120 mls';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Real Castor Oils 120 mls', 'cleaning-hygiene', 'Premium 100% Organic Cold-Pressed Castor Oil — 120 ml Real Oils Uganda Experience the natural goodness of Real Oils Uganda’s 120 ml bottle of cold-pressed Castor Oil. Compact and convenient, this pure organic oil is perfect for personal care, travel use, or sampling. Rich in fatty acids and antioxidants, it nourishes skin, strengthens hair, and supports everyday beauty needs. Perfect for: Hair Scalp Skin Lashes & Brows Nails & Cuticles Key Benefits Moisturizes Skin: Provides deep hydration and supports natural healing for smooth, healthy skin. Nourishes Hair & Scalp: Reduces dryness, strengthens roots, and may encourage hair growth. Multipurpose Oil: Suitable for brows, lashes, cuticles, and overall beauty routines. Gentle & Natural: Cold-pressed and free of chemicals, making it safe for regular use. Pure & Ethical: Sustainably sourced and processed in Uganda for guaranteed…', 20000, 'ltr', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_38683_206864613.jpg', 'Real Castor Oils 120 mls', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_38683_206863839.jpg', 'Real Castor Oils 120 mls', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_38683_206864515.jpg', 'Real Castor Oils 120 mls', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Real Castor Oils 240mls';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Real Castor Oils 240mls', 'cleaning-hygiene', 'Premium 100% Organic Cold-Pressed Castor Oil — 240 ml Real Oils Uganda Discover the nourishing power of Real Oils Uganda’s 240 ml bottle of pure Castor Oil—perfect for daily beauty and wellness care. Cold-pressed from organically grown castor beans, this natural oil is packed with essential fatty acids and antioxidants for vibrant skin, strong hair, and more. Perfect for: Hair Scalp Skin Lashes & Brows Nails & Cuticles Key Benefits Hydrates & Repairs Skin: Restores natural moisture, supporting smooth and glowing skin. Strengthens Hair: Promotes healthy follicles, reduces hair breakage, and soothes the scalp. Multi-Purpose Beauty Oil: Excellent for lashes, brows, nails, and cuticles. Gentle & Natural: Perfect for massage, relaxation, and natural skincare. Pure & Ethical: 100% additive-free and cold-pressed for maximum potency. Why Choose Real Oils? Real Oils guarantees authenticity,…', 60000, 'ltr', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_38683_206864515.jpg', 'Real Castor Oils 240mls', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_38683_206863839.jpg', 'Real Castor Oils 240mls', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_38683_206864613.jpg', 'Real Castor Oils 240mls', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Real Castor Oils 500mls';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Real Castor Oils 500mls', 'cleaning-hygiene', 'Premium 100% Organic Cold-Pressed Castor Oil — 500 ml Real Oils Uganda Elevate your self-care routine with this 500 ml bottle of Real Oils’ premium Castor Oil—an all-natural beauty and wellness essential. Cold-pressed for purity, this chemical-free oil preserves rich fatty acids and antioxidants for head-to-toe nourishment. Perfect for: Hair Scalp Skin Lashes & Brows Nails & Cuticles Key Benefits Deep Hydration & Skin Repair: Ricinoleic acid helps lock in moisture, leaving skin soft, supple, and rejuvenated. Hair & Scalp Revitalization: Supports stronger strands, reduces breakage, soothes a dry scalp, and may encourage new growth. Versatile Beauty Use: Ideal as a nourishing treatment for lashes, brows, nails, and cuticles. Wellness Friendly: Naturally soothing for gentle massage and daily self-care rituals. Pure & Ethical: 100% pure, additive-free, and cold-pressed to retain beneficial…', 60000, 'ltr', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_38683_206864438.jpg', 'Real Castor Oils 500mls', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_38683_206863839.jpg', 'Real Castor Oils 500mls', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_38683_206864613.jpg', 'Real Castor Oils 500mls', true);
  end if;
end $$;

-- Bata Shoe Co. Uganda Ltd · +256393261342 · 1 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'bata-shoe-co-uganda-ltd@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'bata-shoe-co-uganda-ltd@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256393261342' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'trader', 'free', 'Bata Shoe Co. Uganda Ltd', 'Bata Shoe Co. Uganda Ltd',
      'BS', '+256393261342', null, '+256393261342', 'bata-shoe-co-uganda-ltd@suppliers.bubu.market',
      '9-95, 5 industrial area, Central, Kampala', 'kampala', 'cleaning and personal care', 'Bata Shoe Co. Uganda Ltd supplies cleaning and personal care from Kampala. 1 line is listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Bata Shoe Co. Uganda Ltd supplies cleaning and personal care from Kampala. 1 line is listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'cleaning-hygiene') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Prod-_3123_701154721.jpg', 'Bata Shoe Co. Uganda Ltd — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Bata';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Bata', 'cleaning-hygiene', 'Few things define a lifestyle the way shoes do. We are among the very best in the world at making them. That’s why 1 million plus people choose to buy Bata every day. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 15000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3123_701154721.jpg', 'Bata', true);
  end if;
end $$;

commit;

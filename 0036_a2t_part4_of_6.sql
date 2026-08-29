-- BUBU.Market · Africa2Trust import, part 4 of 6
-- 11 suppliers. Run the parts in order; each one is safe to re-run.
-- READ-ME-FIRST.txt explains the prices and the photographs.
--
--   Blessed Organic Release
--   Movit Products Ltd
--   Samona Products Ltd
--   Unilever (U) Ltd
--   DOSHI STEEL INDUSTRIES (U) LTD
--   S & G ENTERPRISES LTD
--   East African Roofings Systems Limited
--   Uganda Baati Limited
--   Metrotile Uganda Limited
--   S .S. G Granites Ltd
--   Chint Electrical Excellence Ltd

begin;

create extension if not exists pgcrypto;
alter table accounts add column if not exists import_source text;
alter table products add column if not exists import_source text;

-- Blessed Organic Release · +256790644423+256772312677 · 1 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'blessed-organic-release@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'blessed-organic-release@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256790644423+256772312677' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'trader', 'free', 'Blessed Organic Release', 'Blessed Organic Release',
      'BO', '+256790644423+256772312677', null, '+256790644423+256772312677', 'blessed-organic-release@suppliers.bubu.market',
      'Pader Town Council Lagwai Road, Opposite ARLM Vocation School, Next to Police Baracks, P O Box 21 Pader, Central, Pader', 'kampala', 'cleaning and personal care', 'Blessed Organic Release supplies cleaning and personal care from Kampala. 1 line is listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Blessed Organic Release supplies cleaning and personal care from Kampala. 1 line is listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'cleaning-hygiene') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Our-Team-1.gif', 'Blessed Organic Release — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Ature Baby Oil 20ml';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Ature Baby Oil 20ml', 'cleaning-hygiene', 'Ature organics baby oil is a blend of cold compressed grade A organic shea oil and virgin olive oil that brings together two of nature’s perfect emollients and moisturizers with an abundance of Vitamin A and E for healthy, nourished and smooth skin. Directions for use : Massage Ature organics baby oil on baby’s skin after bath for daily maximum results Ingredients: Olive fruit oil, Shea Oil, Sesame seed oil, Moringa, Rosemary leaf extract. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 9500, 'litre', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_24591_71754629.gif', 'Ature Baby Oil 20ml', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery24591-327355039.gif', 'Ature Baby Oil 20ml', true);
  end if;
end $$;

-- Movit Products Ltd · +2567933514380800203011 · 5 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'movit-products-ltd@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'movit-products-ltd@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+2567933514380800203011' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'manufacturer', 'free', 'Movit Products Ltd', 'Movit Products Ltd',
      'MP', '+2567933514380800203011', null, '+2567933514380800203011', 'movit-products-ltd@suppliers.bubu.market',
      'Plot 4454 & 4455, Bunamwaya Off Entebbe road, Kampala, Zzana, Kampala', 'kampala', 'cleaning and personal care', 'Movit Products Ltd supplies cleaning and personal care from Kampala. 5 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Movit Products Ltd supplies cleaning and personal care from Kampala. 5 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'cleaning-hygiene') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Prod-_609_656124324.png', 'Movit Products Ltd — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Radiant bath & shower gel (aloe vera)';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Radiant bath & shower gel (aloe vera)', 'cleaning-hygiene', 'The unique showering experience with RADIANT BATH & SHOWER GEL- ALOE VERA refreshes your body and provides you with a gentle skin feeling. Dermatologically confirmed skin compatibility.PH skin neutral. Categories: Body Care, Radiant, Shower Gels Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 18000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_609_656124324.png', 'Radiant bath & shower gel (aloe vera)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_609_65613516.png', 'Radiant bath & shower gel (aloe vera)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_609_656121533.png', 'Radiant bath & shower gel (aloe vera)', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Radiant conditioning creme hair relaxer';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Radiant conditioning creme hair relaxer', 'cleaning-hygiene', 'Apply radiant hair pomade to the skin around the hairline and back of the neck. Put on plastic or rubber gloves to protect hands. Section hair from the front to the back and from ear to ear.. ..start the timer and commence applying crème relaxer(start from the back of the neck and work towards the forehead. The creme should be applied from the root of the hair 5mm from the scalp to the end of the shaft. work in a small section at a time. When all hair is covered with relaxer, smooth hair with hands, starting from the back where the creme was first applied and work towards the forehead. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 18000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_609_65613516.png', 'Radiant conditioning creme hair relaxer', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_609_656124324.png', 'Radiant conditioning creme hair relaxer', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_609_656121533.png', 'Radiant conditioning creme hair relaxer', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Radiant conditioning neutralizing hair Shampoo';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Radiant conditioning neutralizing hair Shampoo', 'cleaning-hygiene', 'Radiant conditioning neutralizing hair Shampoo with color signal neutralizes the alkalinity of chemical treatments while it deep cleanses with a rich, creamy lather. It helps to restore hair to its normal PH balance. The gentle formula leaves hair silky and tangle-free. Categories: Hair Care, Radiant, Shampoos Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 18000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_609_656121533.png', 'Radiant conditioning neutralizing hair Shampoo', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery609-3212122657.png', 'Radiant conditioning neutralizing hair Shampoo', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_609_656124324.png', 'Radiant conditioning neutralizing hair Shampoo', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Radiant face and body scrub';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Radiant face and body scrub', 'cleaning-hygiene', 'The gentle and effective formulation with apricot helps the skin to remain healthier and more purified. The finely crushed Apricot shell with natural ingredients removes all traces of dead skin cells and opens blocked pores. regular use will make the skin fresher, healthier, and soft. Categories: Body Care, Radiant, Scrubs Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 18000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_609_656131746.png', 'Radiant face and body scrub', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_609_656124324.png', 'Radiant face and body scrub', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_609_65613516.png', 'Radiant face and body scrub', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Radiant Talcum powder';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Radiant Talcum powder', 'cleaning-hygiene', 'Radiant Talcum powder has natural goodness and active ingredients to help completely dry skin after bathing leaving the skin feeling soft,smooth and pure. It absorbs sweat,de-odorises and fights body odour. Categories: Body Care, Powders, Radiant Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 18000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_609_656145711.png', 'Radiant Talcum powder', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_609_656124324.png', 'Radiant Talcum powder', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_609_65613516.png', 'Radiant Talcum powder', true);
  end if;
end $$;

-- Samona Products Ltd · +256751084206+256704768252+256772401879 · 1 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'samona-products-ltd@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'samona-products-ltd@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256751084206+256704768252+256772401879' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'manufacturer', 'free', 'Samona Products Ltd', 'Samona Products Ltd',
      'SP', '+256751084206+256704768252+256772401879', null, '+256751084206+256704768252+256772401879', 'samona-products-ltd@suppliers.bubu.market',
      'Kampala, Uganda, Busega Central B zone, Masaka Road, Rubaga, Kampala', 'kampala', 'cleaning and personal care', 'Samona Products Ltd supplies cleaning and personal care from Kampala. 1 line is listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Samona Products Ltd supplies cleaning and personal care from Kampala. 1 line is listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'cleaning-hygiene') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Prod-_3146_69817438.png', 'Samona Products Ltd — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Samona Anti-Aging';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Samona Anti-Aging', 'cleaning-hygiene', 'There is need therefore to seek for professional cosmetics manufacturers in order not to damage your skin for life time complications. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 18000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3146_69817438.png', 'Samona Anti-Aging', true);
  end if;
end $$;

-- Unilever (U) Ltd · +256312226100 · 2 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'unilever-u-ltd@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'unilever-u-ltd@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256312226100' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'manufacturer', 'free', 'Unilever (U) Ltd', 'Unilever (U) Ltd',
      'UU', '+256312226100', null, '+256312226100', 'unilever-u-ltd@suppliers.bubu.market',
      'Plot 26 Kyadondo Rd(Makerere / Kyadondo Road area).; Kampala, Uganda, East Africa, Kampala, Uganda, Bugolobi, Kampala', 'kampala', 'cleaning and personal care', 'Unilever (U) Ltd supplies cleaning and personal care, food and beverages from Kampala. 2 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Unilever (U) Ltd supplies cleaning and personal care, food and beverages from Kampala. 2 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'cleaning-hygiene') on conflict do nothing;
  insert into account_categories (account_id, category_id) values (v_acct, 'food-beverage') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Prod-_3479_701114845.jpg', 'Unilever (U) Ltd — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Soaps and toiletries - Lifebouy';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Soaps and toiletries - Lifebouy', 'cleaning-hygiene', 'The desire to be clean, active, and healthy is intrinsic to everyone – irrespective of age or economic status. Lifebuoy understands this, and has championed the cause for better health through hygiene for more than a century. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 6500, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3479_701113546.jpg', 'Soaps and toiletries - Lifebouy', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3479_701114845.jpg', 'Soaps and toiletries - Lifebouy', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Meat and Dairy products - Ben & Jerry Ice Cream';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Meat and Dairy products - Ben & Jerry Ice Cream', 'food-beverage', 'Ben & Jerry''s offers flavor fans worldwide more than 50 frozen treats to enjoy, from the generous chunks and swirls to Doggy Desserts and non-dairy flavors made with high-quality, ethically sourced ingredients. With ingredients grown by Fairtrade farmers, milk, and cream sourced from local dairy farmers, and brownies sourced from Greyston Bakery, a bakery that changes lives. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 18000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3479_701114845.jpg', 'Meat and Dairy products - Ben & Jerry Ice Cream', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3479_701113546.jpg', 'Meat and Dairy products - Ben & Jerry Ice Cream', true);
  end if;
end $$;

-- DOSHI STEEL INDUSTRIES (U) LTD · +2564142512161718 · 5 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'doshi-steel-industries-u-ltd@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'doshi-steel-industries-u-ltd@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+2564142512161718' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'manufacturer', 'free', 'DOSHI STEEL INDUSTRIES (U) LTD', 'DOSHI STEEL INDUSTRIES (U) LTD',
      'DS', '+2564142512161718', null, '+2564142512161718', 'doshi-steel-industries-u-ltd@suppliers.bubu.market',
      '10, Nyondo Close, Bugolobi, Central, Kampala', 'kampala', 'hardware and tools', 'DOSHI STEEL INDUSTRIES (U) LTD supplies hardware and tools from Kampala. 5 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'DOSHI STEEL INDUSTRIES (U) LTD supplies hardware and tools from Kampala. 5 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'hardware-tools') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Prod-_14763_656194715.png', 'DOSHI STEEL INDUSTRIES (U) LTD — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Locking Systems';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Locking Systems', 'hardware-tools', 'Godrej® Locking Systems is where form and function meet. Doshi is a distributor of the century old brand that is synonymous with trust, protection and integrity. Godrej® offers innovative locking solutions for homes, offices, industries and other establishments for millions of people around the world. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 180000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14763_656194715.png', 'Locking Systems', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14763_656193133.jpg', 'Locking Systems', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14763_656191724.jpg', 'Locking Systems', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Steel Doors';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Steel Doors', 'hardware-tools', 'Our Steel Doors are made for the discerning customer who is looking for both security and style. The doors come in sizes of 2050 mm x 960 mm and are inside opening. Each door is fitted with a complete lock. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 180000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14763_656193133.jpg', 'Steel Doors', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14763_656194715.png', 'Steel Doors', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14763_656191724.jpg', 'Steel Doors', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Steel Sheets & Plates';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Steel Sheets & Plates', 'hardware-tools', 'The steel sheets and plates come in a standard size of 2440 mm x 1220 mm (8ft x 4 ft). However, special lengths and sizes are available on order. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 180000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14763_656191724.jpg', 'Steel Sheets & Plates', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14763_656194715.png', 'Steel Sheets & Plates', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14763_656193133.jpg', 'Steel Sheets & Plates', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Universal Beams & Columns';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Universal Beams & Columns', 'hardware-tools', 'Doshi Steel is a trusted supplier of Beams & Columns that come in S 355 and in standard lengths of 12 meters. CNC cutting & Drilling services are available for this sections. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 250000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14763_656184731.jpg', 'Universal Beams & Columns', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14763_656194715.png', 'Universal Beams & Columns', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14763_656193133.jpg', 'Universal Beams & Columns', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Wire Nails';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Wire Nails', 'hardware-tools', 'Doshi Steel is a renown manufacturer of wire nails in Kenya. Our nails are preferred due to their strength and lack of burrs. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 6500, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14763_656192421.jpg', 'Wire Nails', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14763_656194715.png', 'Wire Nails', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_14763_656193133.jpg', 'Wire Nails', true);
  end if;
end $$;

-- S & G ENTERPRISES LTD · +256757708592256414233124 · 9 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 's-g-enterprises-ltd@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      's-g-enterprises-ltd@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256757708592256414233124' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'trader', 'free', 'S & G ENTERPRISES LTD', 'S & G ENTERPRISES LTD',
      'SG', '+256757708592256414233124', null, '+256757708592256414233124', 's-g-enterprises-ltd@suppliers.bubu.market',
      '-, Sikh, Shoppers Stop Plaza, Central, Kampala', 'kampala', 'hardware and tools', 'S & G ENTERPRISES LTD supplies hardware and tools, electronics from Kampala. 9 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'S & G ENTERPRISES LTD supplies hardware and tools, electronics from Kampala. 9 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'hardware-tools') on conflict do nothing;
  insert into account_categories (account_id, category_id) values (v_acct, 'electronics') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/emt60wh.jpg', 'S & G ENTERPRISES LTD — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'BASE UNIT';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'BASE UNIT', 'hardware-tools', 'Sterling Twin Plus is a totally integrated cable management solution with a large bend radius option to control cables for optimum performance and exceed all current cabling standards. Bends, angles and tees with a large bend radius of 50mm Cable control performance that exceeds international category standards Conductive spray coating for protection against EMI in PVC-U versions Busbar option available Utilises full range of Sterling flush accessories and boxes Available in lengths suited to international specification Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 145000, 'roll', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/emt60wh.jpg', 'BASE UNIT', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Insulated_Socket_Enclosures_(IP65)83128.jpg', 'BASE UNIT', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/rsz_1rsz_cflspec1_image15w30w.jpg', 'BASE UNIT', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Sterling Profile aluminium';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Sterling Profile aluminium', 'hardware-tools', '167 x 50mm Three compartments that can be subdivided Individual covers for each compartment Fittings and accessories with built in overlaps A range of polycarbonate clip on fittings Comprehensive range of flush power and data accessories Fully compatible with Sterling accessories Can accomodate the 63 Amp Sterling Busbar System Silver or white powder coated as standard Other colours or foils on request Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 180000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/alisterlingprofile.jpg', 'Sterling Profile aluminium', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/emt60wh.jpg', 'Sterling Profile aluminium', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Insulated_Socket_Enclosures_(IP65)83128.jpg', 'Sterling Profile aluminium', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Sterling Twin Plus';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Sterling Twin Plus', 'hardware-tools', 'Twin Plus is a totally integrated cable management solution with a large bend radius option to control cables for optimum performance and exceed all current cabling standards Bends, angles and tees with a large bend radius of 50mm Cable control performance that exceeds international category standards Conductive Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 145000, 'roll', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/sterlingtwindata.jpg', 'Sterling Twin Plus', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/emt60wh.jpg', 'Sterling Twin Plus', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Insulated_Socket_Enclosures_(IP65)83128.jpg', 'Sterling Twin Plus', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Click Mode 6 Gang 2 Way 10AX Modular Plate Light Switch';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Click Mode 6 Gang 2 Way 10AX Modular Plate Light Switch', 'electronics', 'Part Number CMA105 Number Of Switches 6 Information Switches are suitable for 1 and 2 Way Switching Colour White Rating 10 Amp X Rated Fixing Centres mm 120.6mm Minimum Flush Back Box Depth mm 25mm Minimum Dry Lining Back Box mm 35mm Minimum Surface Back Box mm 25mm Information Supplied with fixing screws Information Switches are X-rated and can be used for switching inductive or fluorescent loads without de-rating Note: Switch modules are fully interchangeable and can be replaced or changed Information Individually packaged British Standard BS EN60669-1 Guarantee 20 Year Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 320000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Insulated_Socket_Enclosures_(IP65)83128.jpg', 'Click Mode 6 Gang 2 Way 10AX Modular Plate Light Switch', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/emt60wh.jpg', 'Click Mode 6 Gang 2 Way 10AX Modular Plate Light Switch', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/rsz_1rsz_cflspec1_image15w30w.jpg', 'Click Mode 6 Gang 2 Way 10AX Modular Plate Light Switch', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'DC Compact Fluorescent Lamps';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'DC Compact Fluorescent Lamps', 'electronics', 'Phocos´s Compact Fluoresecent Lamps (CFL) with 15 W and 30 W power consumption open up a new range for 12 V and 24 V DC lighting equipment. The life span of the lamp is more than 10,000 hours. The new version of CFL lamps is now regulated by a DC-preheating circuit which makes an extremely high number of switching cycles possible (IEC925). The lamps are also equipped with an over-temperature protection (OTP) which causes the lamps to automatically switch off prior to overheating (especially when operated at extreme environmental conditions) and therefore prevents damage to the lamp. Thus, the product life span is significantly increased. Of course the lamps comply with the CE standards for low interference with radios and other electronic devices.The special shape of the 15 W tube allows the installation in locations where usually only incandescent bulbs fit. The lamps have a standard… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 22000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/rsz_1rsz_cflspec1_image15w30w.jpg', 'DC Compact Fluorescent Lamps', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/emt60wh.jpg', 'DC Compact Fluorescent Lamps', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Insulated_Socket_Enclosures_(IP65)83128.jpg', 'DC Compact Fluorescent Lamps', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Exir Bullet Network Camera';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Exir Bullet Network Camera', 'electronics', 'The Hikvision DS-2CD2T42WD-I8 is a 4MP EXIR bullet camera with a range of features including; 120dB wide dynamic range, 3D digital noise reduction, an IP66 rated housing to protect the camera from harsh outdoor weather conditions and up to 80 meters IR range. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 420000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/2t42_1.jpg', 'Exir Bullet Network Camera', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/emt60wh.jpg', 'Exir Bullet Network Camera', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Insulated_Socket_Enclosures_(IP65)83128.jpg', 'Exir Bullet Network Camera', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Hikvision Dome';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Hikvision Dome', 'electronics', '1.3MP (1280 x 960) high resolution HD 720p real-time video Up to 30m IR visibility True day/night 3D DNR & DWDR & BLC IP66 rating Vandal-proof housing - See more at: http://www.alldataresource.com/Hikvision-DS2CD2112I-Dome-Ip66-13Mp-4Mm-Definition-Ir-Poe12Dc_p_210850.html#sthash.w3I2zFym.dpuf Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 145000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/rsz_hik-ds2cd2112i.jpg', 'Hikvision Dome', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/emt60wh.jpg', 'Hikvision Dome', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Insulated_Socket_Enclosures_(IP65)83128.jpg', 'Hikvision Dome', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'IR Mini Bullet Camera';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'IR Mini Bullet Camera', 'electronics', 'Quick Detail: 1. 1.3MP High Resolution : 1280*960 2. 25M IR Distance 3. Waterproof and Mini Housing 4. Built-in P2P, Video Push Alarm for IOS, Android Description: 1. Onvif standard 2.2 Version 2. Support P2P, Video Push alarm , WDR 3. Support IPHONE and Android 4. Support Firefox, Google Chrome and Safari 5. 36pcs led light Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 420000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/FINAL.jpg', 'IR Mini Bullet Camera', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/emt60wh.jpg', 'IR Mini Bullet Camera', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Insulated_Socket_Enclosures_(IP65)83128.jpg', 'IR Mini Bullet Camera', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Phocos Voltage Converters';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Phocos Voltage Converters', 'electronics', 'DC/DC converters extend users applications Maximum output current adopts to output voltage Excess enrgy management system in DCL makes the PV system more efficient overheating protection extends product lifetime display LEDs for "power on" and "current limitation" Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 145000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/solar-charge-controller-phocos-ca06-22-5a.jpg', 'Phocos Voltage Converters', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/emt60wh.jpg', 'Phocos Voltage Converters', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Insulated_Socket_Enclosures_(IP65)83128.jpg', 'Phocos Voltage Converters', true);
  end if;
end $$;

-- East African Roofings Systems Limited · +2560705221159+2560393277866+2560705221158 · 3 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'east-african-roofings-systems-limited@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'east-african-roofings-systems-limited@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+2560705221159+2560393277866+2560705221158' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'manufacturer', 'free', 'East African Roofings Systems Limited', 'East African Roofings Systems Limited',
      'EA', '+2560705221159+2560393277866+2560705221158', null, '+2560705221159+2560393277866+2560705221158', 'east-african-roofings-systems-limited@suppliers.bubu.market',
      'East Africa, Plot 55-87 Movit Road, Zana Entebbe Road, Zaana, Kampala', 'kampala', 'building materials', 'East African Roofings Systems Limited supplies building materials from Kampala. 3 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'East African Roofings Systems Limited supplies building materials from Kampala. 3 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'building-construction') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Prod-_3392_656103026.jpg', 'East African Roofings Systems Limited — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'PPGI Super Tiger Profile';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'PPGI Super Tiger Profile', 'building-construction', 'Super Tiger sheets are made from pre-painted galvanized iron sheets and combines increased longevity with low maintenance costs. Super Tigersheets are suitable for both residential and commercial purposes. Sheet Width 975 -1000 mm Overall Width 885 mm Cover width 814 mm Pitch 203.5 mm No of trough 5 Thickness 0.25-0.4mm Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 48000, 'sheet', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3392_656103026.jpg', 'PPGI Super Tiger Profile', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3392_656111820.jpg', 'PPGI Super Tiger Profile', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3392_65695419.jpg', 'PPGI Super Tiger Profile', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Tiger galvinised pain sheets.';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Tiger galvinised pain sheets.', 'building-construction', 'Tiger galvinised pain sheets are pre-painted metal sheets made from the strongest steel providing you with a roof that is durable colourful and beautiful at a low cost. Sheet Width 975 - 100 mm Overall width 885mm Cover width 815mm Pitch 203.5mm No of trough 5 Thickness 0.25-0.4mm Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 120000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3392_656111820.jpg', 'Tiger galvinised pain sheets.', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3392_656103026.jpg', 'Tiger galvinised pain sheets.', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3392_65695419.jpg', 'Tiger galvinised pain sheets.', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Tiger galvinised sheets';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Tiger galvinised sheets', 'building-construction', 'Corrugated galvanized iron is a building material composed of sheets of hot-dip galvanized mild steel, cold-rolled to produce a linear corrugated pattern in them. The corrugations increase the bending strength of the sheet in the direction perpendicular to the corrugations, but not parallel to them normally each sheet is manufactured longer in its strong direction. Sheet Width 975 - 100 mm Overall width 885mm Cover width 815mm Pitch 203.5mm No of trough 5 Thickness 0.25-0.4mm Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 48000, 'sheet', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3392_65695419.jpg', 'Tiger galvinised sheets', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3392_656103026.jpg', 'Tiger galvinised sheets', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_3392_656111820.jpg', 'Tiger galvinised sheets', true);
  end if;
end $$;

-- Uganda Baati Limited · +2564142541089 · 1 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'uganda-baati-limited@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'uganda-baati-limited@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+2564142541089' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'manufacturer', 'free', 'Uganda Baati Limited', 'Uganda Baati Limited',
      'UB', '+2564142541089', null, '+2564142541089', 'uganda-baati-limited@suppliers.bubu.market',
      'Plot 14/28, Kibira Road, Industrial A, Central, Kampala', 'kampala', 'building materials', 'Uganda Baati Limited supplies building materials from Kampala. 1 line is listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Uganda Baati Limited supplies building materials from Kampala. 1 line is listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'building-construction') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/corrugated_sheets.jpg', 'Uganda Baati Limited — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Corrugated Sheets';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Corrugated Sheets', 'building-construction', 'Corrugated sheets are available in different colors ranging i.e Top – Brick Red, Sky Blue, Dark Green, Kraft Grey, Avocado, Brilliant White, Fortune Green, Tile red, Lagoon, Light Cream, Brilliant Blue and Charcoal Bottom – Baker Grey Note: Special colours available on request for quantity orders. APPLICATIONS: Cladding (Roofing/ Walling) Decking False Ceilings etc. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 48000, 'sheet', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/corrugated_sheets.jpg', 'Corrugated Sheets', true);
  end if;
end $$;

-- Metrotile Uganda Limited · +256774246142+2567052210027+256200900927+256200902162 · 3 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'metrotile-uganda-limited@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'metrotile-uganda-limited@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256774246142+2567052210027+256200900927+256200902162' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'manufacturer', 'free', 'Metrotile Uganda Limited', 'Metrotile Uganda Limited',
      'MU', '+256774246142+2567052210027+256200900927+256200902162', null, '+256774246142+2567052210027+256200900927+256200902162', 'metrotile-uganda-limited@suppliers.bubu.market',
      'plot 87, 6th street industrial area, Central, Kampala', 'kampala', 'roofing and ceilings', 'Metrotile Uganda Limited supplies roofing and ceilings from Kampala. 3 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Metrotile Uganda Limited supplies roofing and ceilings from Kampala. 3 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'roofing-ceilings') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Prod-_9204_657114641.jpg', 'Metrotile Uganda Limited — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Metrotile Bond';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Metrotile Bond', 'roofing-ceilings', 'A traditional and attractive roof with timeless effect. The Metrotile Bond profile is designed to get the same appearance of the traditional clay roof style, with the additional benefits of steel roofing. Because of the downturned front and the upturned rear edges, the panels have a strong overlapping and interlocking tile covering, which provides an excellent durability, protection and resistance to wind lift or other extreme weather conditions. Specifications Minimum pitch 10° Maximum pitch 90° Size of tile – overall 1330 x 415 mm1 Size of tile – cover 1270 x 370 mm1 Gauge of steel 0,450 mm2 Coverage 0.47 m² (2.13 tiles/m²)1 Weight per m² 6.2 kg1 Weight per tile 2.8 kg1 Available Colours Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 48000, 'sheet', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_9204_657114641.jpg', 'Metrotile Bond', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_9204_657113528.jpg', 'Metrotile Bond', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_9204_6571476.jpg', 'Metrotile Bond', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Metrotile Roman';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Metrotile Roman', 'roofing-ceilings', 'An authentic Mediterranean look for your home. Metrotile Roman tiles have been designed to imitate the look of traditional natural clay roof tiles to give your home an authentic Mediterranean feel. Metrotile Roman tiles with their distinctive shape and pronounced profile are unique among stone-coated steel tiles. A heart of Aluzinc® coated steel or similar/equivalent protective layer with advanced stone granule coating guarantees optimal protection for your home. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 55000, 'sheet', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_9204_657113528.jpg', 'Metrotile Roman', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_9204_657114641.jpg', 'Metrotile Roman', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_9204_6571476.jpg', 'Metrotile Roman', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Metrotile Shake';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Metrotile Shake', 'roofing-ceilings', 'Inspired by classic wooden roofs but with all the strength of steel. Metrotile Shake tiles have all the features of traditional wooden shakes, but without the problems of splitting, warping or increased fire risk. Enhanced shadow lines and visual contrasts are combined with lightweight, long-life steel. Specifications Minimum pitch 10° Maximum pitch 90° Size of tile – overall 1325 x 415 mm1 Size of tile – cover 1245 x 370 mm1 Gauge of steel 0,450 mm2 Coverage 0,46 m² (2,17 tiles/m²)1 Weight per m² 6.1 kg1 Weight per tile 2.8 kg1 Available Colours Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 55000, 'sheet', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_9204_6571476.jpg', 'Metrotile Shake', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_9204_657114641.jpg', 'Metrotile Shake', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_9204_657113528.jpg', 'Metrotile Shake', true);
  end if;
end $$;

-- S .S. G Granites Ltd · +256752234568+256772432579 · 2 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 's-s-g-granites-ltd@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      's-s-g-granites-ltd@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256752234568+256772432579' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'manufacturer', 'free', 'S .S. G Granites Ltd', 'S .S. G Granites Ltd',
      'SS', '+256752234568+256772432579', null, '+256752234568+256772432579', 's-s-g-granites-ltd@suppliers.bubu.market',
      'Plot 355-356, Block 29, Opp. Mawanda Road Police, Kamwokya, Kampala', 'kampala', 'roofing and ceilings', 'S .S. G Granites Ltd supplies roofing and ceilings from Kampala. 2 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'S .S. G Granites Ltd supplies roofing and ceilings from Kampala. 2 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'roofing-ceilings') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/SSGGranite/SSGGranite2.jpg', 'S .S. G Granites Ltd — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'S.S.G Granite Tiles and Slabs';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'S.S.G Granite Tiles and Slabs', 'roofing-ceilings', 'Favored above many other stone countertops, granite is valued for its resistance to acids and its hardness. Granite tiles are easier to work with because they are smaller and lighter. They come precut and perfectly square. We sell Slabs and Tile. The main difference between slab and tile are the seams. Tiles obviously have many seams or grout lines. Slabs generally have seams unless your get a slab large enough for your entire counter. But slabs have far less seams than tiles. Thinking about installing granite countertops in your kitchen or bathroom? They add elegance to your home now and value to it throughout the years. Granite is a great choice for many reasons. With the proper selection and care, granite will continue to welcome you home for many decades. 3 REASONS GRANITE IS STILL THE BEST CHOICE FOR COUNTERTOPS 1. GRANITE IS DURABLE AND NEARLY MAINTENANCE FREE The stone so many… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 55000, 'sheet', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/granite-tiles.jpg', 'S.S.G Granite Tiles and Slabs', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Marble-Tiles-and-Slabs.jpg', 'S.S.G Granite Tiles and Slabs', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'S.S.G Marble Tiles and Slabs';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'S.S.G Marble Tiles and Slabs', 'roofing-ceilings', 'Marble Tiles and Slabs are used in prestige architecture and interior design. They are beautiful, extremely hard, metamorphic building materials. Marble has many decorative and structural uses. It is used for outdoor sculpture as well as for sculpture bases; in architecture it is used in exterior walls and veneers, flooring, decorative features, stairways and walkways. Why Marble For Commercial Construction? The following features set apart marble from other natural stones for construction: 1. Durable: Marble is one of the durable natural stone. Many ancient buildings and structures are the examples that illustrate long life of structures build with marble. 2. Heat Resistance: "Most natural stones exhibit high level of heat resistance. Marbles and granites are proven to be the most heat resistant material available on earth. In summer houses built with marble are cooler than those built… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 55000, 'sheet', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Marble-Tiles-and-Slabs.jpg', 'S.S.G Marble Tiles and Slabs', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/granite-tiles.jpg', 'S.S.G Marble Tiles and Slabs', true);
  end if;
end $$;

-- Chint Electrical Excellence Ltd · +256776495252+256757570888+256392266552 · 56 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'chint-electrical-excellence-ltd@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'chint-electrical-excellence-ltd@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256776495252+256757570888+256392266552' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'trader', 'free', 'Chint Electrical Excellence Ltd', 'Chint Electrical Excellence Ltd',
      'CE', '+256776495252+256757570888+256392266552', null, '+256776495252+256757570888+256392266552', 'chint-electrical-excellence-ltd@suppliers.bubu.market',
      'Shop No. K42 Plot No. 4 D, Teddy''s Shops & Apartment, Central, Kampala', 'kampala', 'electronics', 'Chint Electrical Excellence Ltd supplies electronics, electrical and lighting, solar and power from Kampala. 56 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Chint Electrical Excellence Ltd supplies electronics, electrical and lighting, solar and power from Kampala. 56 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'electronics') on conflict do nothing;
  insert into account_categories (account_id, category_id) values (v_acct, 'electrical-lighting') on conflict do nothing;
  insert into account_categories (account_id, category_id) values (v_acct, 'solar-power') on conflict do nothing;
  insert into account_categories (account_id, category_id) values (v_acct, 'plumbing-sanitary') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Prod-_15069_737115845.jpg', 'Chint Electrical Excellence Ltd — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'CHINT AC CONTACTOR 20A~1000A 110V/240V/415V (2 YEARS WARRANTY)';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'CHINT AC CONTACTOR 20A~1000A 110V/240V/415V (2 YEARS WARRANTY)', 'electronics', 'Chint Contactors for use in heavy duty industrial applications - Mainly used remote motor control componenets. Chint Contactors are Din rail mountable or fitted with holes. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 85000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/CHINTACCONTACTOR.gif', 'CHINT AC CONTACTOR 20A~1000A 110V/240V/415V (2 YEARS WARRANTY)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'CHINT AC CONTACTOR 20A~1000A 110V/240V/415V (2 YEARS WARRANTY)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'CHINT AC CONTACTOR 20A~1000A 110V/240V/415V (2 YEARS WARRANTY)', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'CHINT Modular Din-Rail Product-MCB (2YEARS WARRANTY)';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'CHINT Modular Din-Rail Product-MCB (2YEARS WARRANTY)', 'electronics', 'Chint modular DIN-rail devices are the complete range for all applications; easy to install, safe, reliable and user friendly. We have the most comprehensive ranges available to meet the needs of today''s demanding housing, commercial and industrial markets. (2YEARS WARRANTY) Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 85000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/CHINTModularDin-RailProduct-MCB.gif', 'CHINT Modular Din-Rail Product-MCB (2YEARS WARRANTY)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'CHINT Modular Din-Rail Product-MCB (2YEARS WARRANTY)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'CHINT Modular Din-Rail Product-MCB (2YEARS WARRANTY)', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'CHINT NM1 MCCB (2YEARS WARRANTY)';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'CHINT NM1 MCCB (2YEARS WARRANTY)', 'electronics', 'Electric ratings: AC 690V,50/60HZ, 10~1250A; Application: for power distribution or protection of the circuits from over-load, short-circuit and under-voltage. In addition, the breaker could be applied to infrequently start the motor and the over-load, short-circuit and under-voltage protection of the motor, as well. Standard: IEC/EN60947-2. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 85000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/CHINTNM1MCCB.gif', 'CHINT NM1 MCCB (2YEARS WARRANTY)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'CHINT NM1 MCCB (2YEARS WARRANTY)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'CHINT NM1 MCCB (2YEARS WARRANTY)', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'CHINT SWITCHES AND SOCEKT (2YEARS WARRANTY)';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'CHINT SWITCHES AND SOCEKT (2YEARS WARRANTY)', 'electronics', 'A slim, trim profile, pleasing to the eye, clean and refined CHINT switches & sockets perfectly complements the modern lifestyle. Inspired by the simple elegance, every piece of this robustly constructed switches and sockets expresses a pleasing appearance and a cool refined touch of style to suit almost any interior.. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 145000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/chint-switch-socket.gif', 'CHINT SWITCHES AND SOCEKT (2YEARS WARRANTY)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'CHINT SWITCHES AND SOCEKT (2YEARS WARRANTY)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'CHINT SWITCHES AND SOCEKT (2YEARS WARRANTY)', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'CHINT/SCC CABLES SINGLE CABLE/TWIN CABLE/FLEXIBLE CABLE/TV CABLE/TELEPHONE CABLE/UNDERGROUND CA';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'CHINT/SCC CABLES SINGLE CABLE/TWIN CABLE/FLEXIBLE CABLE/TV CABLE/TELEPHONE CABLE/UNDERGROUND CA', 'electronics', 'CHINT/SCC CABLES SINGLE CABLE/TWIN CABLE/FLEXIBLE CABLE/TV CABLE/TELEPHONE CABLE/UNDERGROUND CABLE/ Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 145000, 'roll', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Chint_Cables.gif', 'CHINT/SCC CABLES SINGLE CABLE/TWIN CABLE/FLEXIBLE CABLE/TV CABLE/TELEPHONE CABLE/UNDERGROUND CA', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'CHINT/SCC CABLES SINGLE CABLE/TWIN CABLE/FLEXIBLE CABLE/TV CABLE/TELEPHONE CABLE/UNDERGROUND CA', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'CHINT/SCC CABLES SINGLE CABLE/TWIN CABLE/FLEXIBLE CABLE/TV CABLE/TELEPHONE CABLE/UNDERGROUND CA', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Microswitch';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Microswitch', 'electronics', 'JD, J ZT, Z LK, Z TK The controller of electromagnetic speed-adjustable motor of JD,JZT,ZLK,ZTK series, are design product of ministry of machine-building industry of nationwide combination(unity). JD, J ZT, Z LK, Z TK The controller of electromagnetic speed-adjustable motor of JD,JZT,ZLK,ZTK series, are design product of ministry of machine-building industry of nationwide combination(unity). JD, JZT, ZLK, ZTK Electromagnetic Speed-adjustable Motor Control Device JD, JZT, ZLK, ZTK series electromagnetic speed-adjustable motor controller is the national union (unified) design product of the former Ministry of Machinery Industry used to control speed governing of the electromagnetic speed-adjustable motor (slip motor) to achieve constant torque stepless speed control. The controller applies only to slip motor instead of ordinary motor. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 320000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/20150415191101980.jpg', 'Microswitch', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'Microswitch', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'Microswitch', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = '62 Series Analog Panel Meter';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, '62 Series Analog Panel Meter', 'electronics', '62 series panel meters are adopted pivoting point & bearings supporting hairspring structure. The supporting part consists of jeweled bearing and pivoting point, the moving part consists of system?moving coil and bakelite case, adopting arc shape and transparent glass cover. The whole looks beautiful and provides an open view. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 250000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', '62 Series Analog Panel Meter', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', '62 Series Analog Panel Meter', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737183222.jpg', '62 Series Analog Panel Meter', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'CHS150 Single Phase Smart Meter';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'CHS150 Single Phase Smart Meter', 'electronics', 'Better AMI Performance ? Ultra Anti-Tamper ? Large LCD Display ? Replaceable Battery Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 620000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736164022.png', 'CHS150 Single Phase Smart Meter', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'CHS150 Single Phase Smart Meter', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'CHS150 Single Phase Smart Meter', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'G1.6, G2.5 Small Diaphragm Gas Meter (Aluminum)';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'G1.6, G2.5 Small Diaphragm Gas Meter (Aluminum)', 'electronics', '? Small cyclic volume ? Strong anti-corrosion capability ? Separate mechanism Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 250000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736175826.png', 'G1.6, G2.5 Small Diaphragm Gas Meter (Aluminum)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'G1.6, G2.5 Small Diaphragm Gas Meter (Aluminum)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'G1.6, G2.5 Small Diaphragm Gas Meter (Aluminum)', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'G1.6,G2.5 Aluminium Case Gas Meter';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'G1.6,G2.5 Aluminium Case Gas Meter', 'electronics', 'Diaphragm gas meter is volumetric diaphragm gas meters, are used in measuring the volume of natural gas, city pipe gas, liquid gas, marsh gas and other gas with working pressure of (0.5~20)kPa.r. The gas meters are in compliance with GB/T6968-1997 Class B requirements. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 38000, 'length', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736183133.jpg', 'G1.6,G2.5 Aluminium Case Gas Meter', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'G1.6,G2.5 Aluminium Case Gas Meter', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'G1.6,G2.5 Aluminium Case Gas Meter', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'N266 series digital clamp meter';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'N266 series digital clamp meter', 'electronics', 'Introduction: N266 and N266F are kind of trinity half digital pincer-like meter with stable performance, safety and reliability. Adopting A/D converter with large-scaled collected circuit and equipped with overload protecting circuit for overall instrument, it is characterized with all range overload protection, low voltage indication, data hold, inductive indication and fast measurement, becoming the first choice for the electrical measurement. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 22000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736181632.jpg', 'N266 series digital clamp meter', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'N266 series digital clamp meter', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'N266 series digital clamp meter', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'NAS830B, NAS838 series portable digital multi-meter';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'NAS830B, NAS838 series portable digital multi-meter', 'electronics', 'Introduction: NAS830 and NAS838 type are kinds of trinity half automatic range portable pocket-size digital multi-meter with stable performance, safety and reliability, based on ergonomics design, aesthetic and durable, characterized with functions of data hold, backlight, low voltage display, automatic negative display and mal-operate protections, becoming the best tool for electrical engineering. The instrument can measure parameters of DC voltage, AC voltage, DC current, resistance, temperature, diode and on-off test for circuit. Based on different models for products, the functions will also be different. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 250000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736174644.jpg', 'NAS830B, NAS838 series portable digital multi-meter', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'NAS830B, NAS838 series portable digital multi-meter', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'NAS830B, NAS838 series portable digital multi-meter', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'NP Series Analog Panel Meter';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'NP Series Analog Panel Meter', 'electronics', 'The models of NP series mounted panel meters are mainly NP48?NP72?NP96. (The corresponding models sold in China are 99T666, 65T666 and 51T666.) NP series square panel meters are electromagnetic type, adopting repulsive construction. The meters are consist of measuring mechanism and indicating device., with casing adopted by flame-retardant ABS engineering plastics, safe measure terminals, high-efficiency connection type, and adopted by printing dial & transparent glass cover. The whole looks beautiful and provides an open view. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 250000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736172340.jpg', 'NP Series Analog Panel Meter', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'NP Series Analog Panel Meter', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'NP Series Analog Panel Meter', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'PD666-□ series Three Phase Digital Multi-function Meter';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'PD666-□ series Three Phase Digital Multi-function Meter', 'electronics', 'Main functions and characteristics ?LED and LCD display function ?Measurement three phase current, voltage, active power, reactive power, power factor, frequency, import and export active energy, four quadrant reactive energy. ?RS485 communication interface, according to MODBUS-RTU communication protocol, and baud rate can be set. ?Extensible switch input function. ?Extensible analog output function, current range 4~20mA, 0~20 mA ,0~10 mA selectable ?Extensible relay switch output function, upper and lower alarm output can be realized. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 22000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736165338.png', 'PD666-□ series Three Phase Digital Multi-function Meter', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'PD666-□ series Three Phase Digital Multi-function Meter', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'PD666-□ series Three Phase Digital Multi-function Meter', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'PD7777-□S3 series three phase digital multi-functional meter';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'PD7777-□S3 series three phase digital multi-functional meter', 'electronics', 'Summary: As a new generation of programmable intelligent instrument, PD7777-?S3 series three phase digital multi-functional meter is designed for the demand of power monitoring and electric energy measurement including power system, communication industry and construction industry, integrated with measurement and communication, mainly applied into real-time measurement and indication for the electrical parameters such as voltage, current, active power, negative power, frequency, power factor, four-quadrant energy, realizing networked through RS485 communication interface and external device. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 250000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_73617846.png', 'PD7777-□S3 series three phase digital multi-functional meter', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'PD7777-□S3 series three phase digital multi-functional meter', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'PD7777-□S3 series three phase digital multi-functional meter', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Led lights - LED Bulb-01';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Led lights - LED Bulb-01', 'electrical-lighting', 'Optical design: High quality PC shade, high transparency High-end LED chip: Encapsulation by golden thread, 80 percent energy saving Intelligent IC power supply: Constant current driver, with overload, short-circuit, under voltage protection Plastic plus aluminum lamp body: excellent heat dissipation Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 22000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736121343.jpg', 'Led lights - LED Bulb-01', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'Led lights - LED Bulb-01', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'Led lights - LED Bulb-01', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Led lights - LED Ceiling Lamp (Phoenix Tail Shape)';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Led lights - LED Ceiling Lamp (Phoenix Tail Shape)', 'electrical-lighting', '?The light has a beautiful appearance, the chassis uses alloy material, and the light cover adopts imported high light transmittance of PMMA material which will not change color in a long term; ?The light uses high quality LED light source with high light transmittance of PMMA light cover which in turn brings soft, healthy and comfortable light. ?No mercury, no ultraviolet, no splash screen, green, environmental protection; ?Good luminous flux and color rendering, high luminous efficiency, long service life ?Use high quality constant current driven which has the protective function in abnormal state (no-load, over current, short circuit, under voltage, etc.), and it has good stability and reliability. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 22000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736115229.jpg', 'Led lights - LED Ceiling Lamp (Phoenix Tail Shape)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'Led lights - LED Ceiling Lamp (Phoenix Tail Shape)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'Led lights - LED Ceiling Lamp (Phoenix Tail Shape)', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Led lights - LED Ceiling Spot Light-01(High Light)';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Led lights - LED Ceiling Spot Light-01(High Light)', 'electrical-lighting', 'LED Ceiling Spot Light-01(High Light) Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 22000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736113818.jpg', 'Led lights - LED Ceiling Spot Light-01(High Light)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'Led lights - LED Ceiling Spot Light-01(High Light)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'Led lights - LED Ceiling Spot Light-01(High Light)', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Led lights - LED Ceiling Spot Light-01(White)';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Led lights - LED Ceiling Spot Light-01(White)', 'electrical-lighting', 'Modern European-style luxury design, various colors are available. Material: die-cast aluminum body, laser-engraved Logo with utmost noble quality. Design: Dilated handle, easy installation. Optical design: Sophisticated optical beehive lens, precise control of light, efficient energy-saving High-end LED chip: Encapsulation by gold thread, 80 percent energy saving. Intelligent IC power supply: Constant current drive, with overload, short-circuit , under voltage protect. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 22000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736151022.jpg', 'Led lights - LED Ceiling Spot Light-01(White)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'Led lights - LED Ceiling Spot Light-01(White)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'Led lights - LED Ceiling Spot Light-01(White)', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Led lights - LED Downlight-03(High Light)';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Led lights - LED Downlight-03(High Light)', 'electrical-lighting', '?Material: Aircraft-grade aluminum, laser-engraved Logo with utmost noble quality. ?Design: Dilated handle, easy installation. ?Optical design: High quality diffusion panel, efficient energy-saving, uniform light emitting. ?High-end LED chip: Encapsulation by gold thread, 80 percent energy saving. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 22000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_7361241.jpg', 'Led lights - LED Downlight-03(High Light)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'Led lights - LED Downlight-03(High Light)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'Led lights - LED Downlight-03(High Light)', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Led lights - LED Downlight-03(White)';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Led lights - LED Downlight-03(White)', 'electrical-lighting', '?Material: Aircraft-grade aluminum, laser-engraved Logo with utmost noble quality. ?Design: Dilated handle, easy installation. ?Optical design: High quality diffusion panel, efficient energy-saving, uniform light emitting. ?High-end LED chip: Encapsulation by gold thread, 80 percent energy saving. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 22000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736125229.jpg', 'Led lights - LED Downlight-03(White)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'Led lights - LED Downlight-03(White)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'Led lights - LED Downlight-03(White)', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Led lights - LED Grill Light-01';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Led lights - LED Grill Light-01', 'electrical-lighting', '?High-quality stringy panel, laser-engraved Logo with utmost noble quality ?Dilated handle, easy installation ?Optical design: Sophisticated optical beehive lens, precise control of light, efficient energy-saving ?High-end LED chip: Encapsulation by gold thread, 80 percent energy saving. ?Intelligent IC power supply: Constant current driver, with overload, short-circuit, under voltage protectio Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 22000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736122733.jpg', 'Led lights - LED Grill Light-01', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'Led lights - LED Grill Light-01', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'Led lights - LED Grill Light-01', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Led lights - LED Grill Light-02';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Led lights - LED Grill Light-02', 'electrical-lighting', '?High-quality stringy panel, laser-engraved Logo with utmost noble quality ?Dilated handle, easy installation ?Optical design: Sophisticated optical beehive lens, precise control of light, efficient energy-saving ?High-end LED chip: Encapsulation by gold thread, 80 percent energy saving. ?Intelligent IC power supply: Constant current driver, with overload, short-circuit, under voltage protection Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 22000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736154518.jpg', 'Led lights - LED Grill Light-02', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'Led lights - LED Grill Light-02', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'Led lights - LED Grill Light-02', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Led lights - LED GU10 01';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Led lights - LED GU10 01', 'electrical-lighting', 'Optical design: High quality PC shade, high transparency High-end LED chip: Encapsulation by golden thread, 80 percent energy saving Intelligent IC power supply: Constant current driver, with overload, short-circuit, under voltage protection Plastic plus aluminum lamp body: excellent heat dissipation Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 22000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_73613941.jpg', 'Led lights - LED GU10 01', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'Led lights - LED GU10 01', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'Led lights - LED GU10 01', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Led lights - LED MR16 01';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Led lights - LED MR16 01', 'electrical-lighting', 'High-end LED chip: Encapsulation by golden thread, 80 percent energy saving Intelligent IC power supply: Constant current driver, with overload, short-circuit, under voltage protection Plastic plus aluminum lamp body: excellent heat dissipation Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 22000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736155433.jpg', 'Led lights - LED MR16 01', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'Led lights - LED MR16 01', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'Led lights - LED MR16 01', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Led lights - LED Panel Light-01';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Led lights - LED Panel Light-01', 'electrical-lighting', 'Exclusive use for integrated ceiling, replace aluminum gusset perfectly Aircraft-grade aluminum, laser-engraved Logo, with utmost noble quality Optical design: high quality light panel, louver, reflective sheeting etc, efficient energy-saving, uniform light emitting High-end LED chip: Encapsulation by golden thread, 80 percent energy saving Intelligent IC power supply: Constant current driver, with overload, short-circuit, under voltage protection Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 22000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736124129.jpg', 'Led lights - LED Panel Light-01', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'Led lights - LED Panel Light-01', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'Led lights - LED Panel Light-01', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Led lights - LED Panel Light-02';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Led lights - LED Panel Light-02', 'electrical-lighting', 'Exclusive use for integrated ceiling, replace aluminum gusset perfectly Aircraft-grade aluminum, laser-engraved Logo, with utmost noble quality Optical design: high quality light panel, louver, reflective sheeting etc, efficient energy-saving, uniform light emitting High-end LED chip: Encapsulation by golden thread, 80 percent energy saving Intelligent IC power supply: Constant current driver, with overload, short-circuit, under voltage protection Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 22000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736124721.jpg', 'Led lights - LED Panel Light-02', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'Led lights - LED Panel Light-02', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'Led lights - LED Panel Light-02', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Led lights - LED T5 Batten';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Led lights - LED T5 Batten', 'electrical-lighting', 'Single-end power supply, convenient and easy installation Optical design: High quality PC shade, high transparency High-end LED chip: Encapsulation by golden thread, 80 percent energy saving Intelligent IC power supply: Constant current driver, with overload, short-circuit, under voltage protection Glass lamp body: Excellent heat dissipation performance Copper nickel plated connector, high antioxidant, safety-connection Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 22000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736145643.jpg', 'Led lights - LED T5 Batten', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'Led lights - LED T5 Batten', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'Led lights - LED T5 Batten', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Led lights - LED Track Light-01';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Led lights - LED Track Light-01', 'electrical-lighting', '?Apply to two line track: Easy installation ?Aircraft-grade aluminum: Refined modeling, excellent heat dissipation ?Optical design: Sophisticated reflector cup design, efficient energy-saving, uniform light emitting; Anti-dazzle design, healthy and comfortable. ?High-end LED chip: COB LED, Encapsulation by gold thread, 80 percent energy saving. ?Intelligent IC power supply: Constant current drive, with overload, short-circuit, under voltage protect. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 22000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736122237.jpg', 'Led lights - LED Track Light-01', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'Led lights - LED Track Light-01', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'Led lights - LED Track Light-01', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'HDLRT0 Fuse for Distribution';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'HDLRT0 Fuse for Distribution', 'electrical-lighting', 'HDLRT0 Fuse for Distribution .Electric ratings: AC50Hz, AC380V/DC400V, up to 1000A; .Application: for protection of power distribution apparatus against over-load and short circuit; .Standard: IEC 60269 Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 85000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_747174731.jpg', 'HDLRT0 Fuse for Distribution', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'HDLRT0 Fuse for Distribution', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'HDLRT0 Fuse for Distribution', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'JSZ3 Time Delay Relay';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'JSZ3 Time Delay Relay', 'electrical-lighting', 'JSZ3 Time Delay Relay is applicable for automatic control system, such as machine automatic control, and complete equipment automatic control, etc Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 145000, 'roll', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_74717946.jpg', 'JSZ3 Time Delay Relay', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'JSZ3 Time Delay Relay', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'JSZ3 Time Delay Relay', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'RT29 Cylinder Cap Fuse';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'RT29 Cylinder Cap Fuse', 'electrical-lighting', 'RT29 Cylinder Cap Fuse Electric ratings: AC500V, up to 125A; Application: for protection of power distribution apparatus against over-load and short circuit; The combination of the fuse with impinger and fuse type disconnector can be used for phase-failure protection of motors. Time delay fuse (aM) can be used for protection of motor starting; standard: IEC 60269. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 85000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_747172453.jpg', 'RT29 Cylinder Cap Fuse', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'RT29 Cylinder Cap Fuse', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'RT29 Cylinder Cap Fuse', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = '166(435~450)AstroTwins_CHSM72M(DG)F-BH';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, '166(435~450)AstroTwins_CHSM72M(DG)F-BH', 'solar-power', 'Power range:435W-450W Max. system voltage:1500 VDC Dimention:2131 x 1052 x 30 mm / 83.90 x 41.42 x 1.18 inch Frame thickness:30 mm / 1.18 inch Glass thickness:2.0 mm / 0.08 inch Cable length:Portrait: 350 mm (13.78 inch) Landscape: 1300 mm (51.18 inch) Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 145000, 'roll', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', '166(435~450)AstroTwins_CHSM72M(DG)F-BH', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', '166(435~450)AstroTwins_CHSM72M(DG)F-BH', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737183222.jpg', '166(435~450)AstroTwins_CHSM72M(DG)F-BH', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'DL41Electronic Horn';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'DL41Electronic Horn', 'electronics', 'DL41Electronic Horn Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 145000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737134521.jpg', 'DL41Electronic Horn', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'DL41Electronic Horn', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'DL41Electronic Horn', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Capacitors';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Capacitors', 'electrical-lighting', 'Capacitors are simple passive device that can store an electrical charge on their plates when connected to a voltage source Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 55000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737151717.jpg', 'Capacitors', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'Capacitors', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'Capacitors', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'CPS combiner box';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'CPS combiner box', 'electrical-lighting', 'For medium and large PV systems, DC combination equipment is essential and can be used to simplify the cable connection between PV panels and inverters in order to raise the reliability of the PV system and make the maintenance of system more convenient. CPS PV combiner box provides customers with a safe, concise and also economic PV system product in standard industrial design according to the CGC/GF002:2010 national regulations of PV combiner box’s technical specifications. Users may put the PV panels with the same type together in series as PV arrays within the allowable DC voltage range for the inverter and then connect several arrays to the combiner box for DC convergence. Before inputting DC to the inverter, the surge protector and breaker in the combiner box ensures the safety of PV system. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 620000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737114342.jpg', 'CPS combiner box', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'CPS combiner box', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'CPS combiner box', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Earth Leakage';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Earth Leakage', 'electrical-lighting', 'Earth Leakage Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 55000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737143143.jpg', 'Earth Leakage', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'Earth Leakage', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'Earth Leakage', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Phase Monitors';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Phase Monitors', 'electrical-lighting', 'Phase Monitors Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 55000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_73714483.jpg', 'Phase Monitors', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'Phase Monitors', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'Phase Monitors', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Soft Starters';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Soft Starters', 'electrical-lighting', 'Soft Starters Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 55000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737144011.jpg', 'Soft Starters', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'Soft Starters', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'Soft Starters', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Spanners';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Spanners', 'electrical-lighting', 'Spanners Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 55000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737154032.jpg', 'Spanners', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'Spanners', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'Spanners', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Candles Chandeliers';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Candles Chandeliers', 'electrical-lighting', 'Domestic Candles Chandeliers Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 22000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737111328.jpg', 'Candles Chandeliers', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'Candles Chandeliers', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'Candles Chandeliers', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Drum Chandeliers';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Drum Chandeliers', 'electrical-lighting', 'Domestic Drum Chandeliers Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 22000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_73711039.jpg', 'Drum Chandeliers', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'Drum Chandeliers', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'Drum Chandeliers', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Contactor Changeover';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Contactor Changeover', 'electrical-lighting', 'Contactor Changeover Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 85000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737141037.jpg', 'Contactor Changeover', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'Contactor Changeover', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'Contactor Changeover', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Motorised MCCB Changeover';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Motorised MCCB Changeover', 'electrical-lighting', 'Auto Motorised MCCB Changeover Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 85000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_73714224.jpg', 'Motorised MCCB Changeover', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'Motorised MCCB Changeover', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'Motorised MCCB Changeover', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Motorised Relay Changeover';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Motorised Relay Changeover', 'electrical-lighting', 'Motorised Relay Changeover Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 85000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737141759.jpg', 'Motorised Relay Changeover', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'Motorised Relay Changeover', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'Motorised Relay Changeover', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Black PVC Pipes and Accessories';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Black PVC Pipes and Accessories', 'plumbing-sanitary', 'Black PVC Pipes and Accessories Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 38000, 'length', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737183222.jpg', 'Black PVC Pipes and Accessories', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'Black PVC Pipes and Accessories', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'Black PVC Pipes and Accessories', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Chint Metal Cable Tray';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Chint Metal Cable Tray', 'plumbing-sanitary', 'Chint Metal Cable Tray Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 145000, 'roll', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_73717214.jpg', 'Chint Metal Cable Tray', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'Chint Metal Cable Tray', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'Chint Metal Cable Tray', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Chint PVC couplers';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Chint PVC couplers', 'plumbing-sanitary', 'Chint PVC couplers Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 38000, 'length', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737185621.jpg', 'Chint PVC couplers', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'Chint PVC couplers', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'Chint PVC couplers', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Chint PVC Moulded Box';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Chint PVC Moulded Box', 'plumbing-sanitary', 'Chint PVC Moulded Box Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 38000, 'length', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737182352.jpg', 'Chint PVC Moulded Box', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'Chint PVC Moulded Box', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'Chint PVC Moulded Box', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Pipe product';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Pipe product', 'plumbing-sanitary', 'Pipe product Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 38000, 'length', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737192158.jpg', 'Pipe product', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'Pipe product', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'Pipe product', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'PVC Bends';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'PVC Bends', 'plumbing-sanitary', 'PVC Bends Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 38000, 'length', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737184849.jpg', 'PVC Bends', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'PVC Bends', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'PVC Bends', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'PVC Flexible Conduit';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'PVC Flexible Conduit', 'plumbing-sanitary', 'PVC Flexible Conduit Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 38000, 'length', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737171836.jpg', 'PVC Flexible Conduit', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'PVC Flexible Conduit', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'PVC Flexible Conduit', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'PVC Flexible-bending-spring';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'PVC Flexible-bending-spring', 'plumbing-sanitary', 'PVC Flexible-bending-springs Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 38000, 'length', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_73717117.jpg', 'PVC Flexible-bending-spring', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'PVC Flexible-bending-spring', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'PVC Flexible-bending-spring', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'PVC U-Clip';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'PVC U-Clip', 'plumbing-sanitary', 'PVC U-Clip Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 38000, 'length', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_73719750.jpg', 'PVC U-Clip', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'PVC U-Clip', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'PVC U-Clip', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Soft Tubes';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Soft Tubes', 'plumbing-sanitary', 'Soft Tubes Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 45000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_73719174.jpg', 'Soft Tubes', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'Soft Tubes', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'Soft Tubes', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Trunking PVC';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Trunking PVC', 'plumbing-sanitary', 'Trunking PVC Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 38000, 'length', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737165327.jpg', 'Trunking PVC', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_737115845.jpg', 'Trunking PVC', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_15069_736185257.jpg', 'Trunking PVC', true);
  end if;
end $$;

commit;

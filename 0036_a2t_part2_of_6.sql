-- BUBU.Market · Africa2Trust import, part 2 of 6
-- 6 suppliers. Run the parts in order; each one is safe to re-run.
-- READ-ME-FIRST.txt explains the prices and the photographs.
--
--   Maua and More
--   African Mushroom Growers (U) Ltd
--   Master Garden Varieties
--   Pearl Cocoa Ltd
--   SEMHAR ENTERPRISE LIMITED (SEL)
--   Horn Products Limited

begin;

create extension if not exists pgcrypto;
alter table accounts add column if not exists import_source text;
alter table products add column if not exists import_source text;

-- Maua and More · +256753105788+256777014020 · 49 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'maua-and-more@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'maua-and-more@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256753105788+256777014020' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'trader', 'free', 'Maua and More', 'Maua and More',
      'MA', '+256753105788+256777014020', null, '+256753105788+256777014020', 'maua-and-more@suppliers.bubu.market',
      'Right hand, Middle Parking Exit Ramp, Plot 64-86 Yusuf Lule Road,Garden City Mall, Central, Kampala', 'kampala', 'plants and agro inputs', 'Maua and More supplies plants and agro inputs from Kampala. 49 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Maua and More supplies plants and agro inputs from Kampala. 49 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'agro-inputs-seeds') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Maua-Flier-600B.jpg', 'Maua and More — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Pothos/Money Plant/Devil''s Ivy';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Pothos/Money Plant/Devil''s Ivy', 'agro-inputs-seeds', 'Pothos is arguably the easiest of all houseplants to grow, even if you are a person who forgets to water your plants. This trailing vine has pointed, heart-shaped green leaves, sometimes variegated with white, yellow, or pale green. While pothos likes bright, indirect light it can thrive in areas that don’t get a lot of sunlight or have only fluorescent lighting. It''s an excellent plant for locations such as offices and sitting rooms. One advantage of growing pothos is that they are high on the list of plants that can help purify indoor air of chemicals. It makes for a good water plant as well! Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 25000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Pothos-400.jpg', 'Pothos/Money Plant/Devil''s Ivy', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_675111456.gif', 'Pothos/Money Plant/Devil''s Ivy', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/African-Violet.jpg', 'Pothos/Money Plant/Devil''s Ivy', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Aeschynanthus or Lipstick Plants';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Aeschynanthus or Lipstick Plants', 'agro-inputs-seeds', 'These plants have pointy, wax leaves and blooms with bright clusters of flowers. Vivid red blossoms emerge from bright maroon buds of a tube of lipstick. Growing lipstick plants is not difficult, and with proper care you get rewarded with continuous flowers. Light The plants grow well in partial shade areas. The lipstick vine blooms with adequate light. Avoid placing this plant in full shade or full sun. Water Water moderately and be sure not to soak the soil or you risk root rot and fungal problems. The lipstick plant has many species/ varieties and these are some of what we have in our collection', 120000, 'piece', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_675111456.gif', 'Aeschynanthus or Lipstick Plants', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-3231112151.gif', 'Aeschynanthus or Lipstick Plants', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-3231112218.gif', 'Aeschynanthus or Lipstick Plants', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'African Violets';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'African Violets', 'agro-inputs-seeds', 'This is a small house plant with ovate hairy leaves and consists of miniature, medium and large species. The large species can get to a maximum of 16cm high These delightful plants will brighten up any room with their colourful blooms formed on clusters of blue, purple, red, pink, and white. Their flowering period varies however some cultivars bloom all year round if well taken care of. They are basically indoors so you can have them in your house, office, balcony provided you places them in a spot that receives medium to bright indirect light to induce blooms but not under direct burning sunshine. They need just enough water to keep them moist but not soggy. African violets are highly sensitive to temperature changes especially rapid leaf cooling so its advisable not to wet their leaves while watering African violets have long been associated with mothers and motherhood. For this… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 25000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/African-Violet.jpg', 'African Violets', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-276362944.gif', 'African Violets', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-276362956.gif', 'African Violets', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'ANTHURIUM andraenum also known as Flamingo or Lance leaf';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'ANTHURIUM andraenum also known as Flamingo or Lance leaf', 'agro-inputs-seeds', 'Is a delightful tropical plant with glossy heart shaped dropping leaves and bright heart shaped blooms with colors varying from Red, orange,pink, white, green and black. It is basically an indoor plant which makes it a very good house plant and you can have it for your office too and in any other indoor space, For outdoor purposes you can have it on your shady balcony, use it in your landscape work as long as its in a shady spot Anthuriums are not hard to care for and maintain as long as you have the plant in the right soil, and in the right light location The plant grows best in bright indirect light however in very low light conditions, it will have fewer flowers and grow slower and yet so direct burning sun may cause the leaves to burn Fertilise once in a while like every after 4months with a fertiliser with high concentration of Phosphorus to induce blooms For the potted plant, only… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 25000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/ANTHURIUM-andraenum.jpg', 'ANTHURIUM andraenum also known as Flamingo or Lance leaf', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_675111456.gif', 'ANTHURIUM andraenum also known as Flamingo or Lance leaf', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/African-Violet.jpg', 'ANTHURIUM andraenum also known as Flamingo or Lance leaf', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Asplenium Parvati Fern';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Asplenium Parvati Fern', 'agro-inputs-seeds', 'This fern is an easy to take care of fern, notable for its dense intricate fronds/ leaves. It’s also known as Mother Fern or leather fern. Uses The plant is a very good indoor plant. It can be used as a table center piece, at home, office or any other indoor space. Watering Water regularly and thoroughly so that water reaches the plant’s deeper roots. Ferns like moisture so make sure the soil does not dry out fully between watering. Light It’s best grown in bright but indirect light conditions to keep the plant healthy but can survive 2-3 meters away from a window. It may suffer if placed where it receives too much direct sunlight. Lack of light can lead to leggy stems or low growth rate or loss of some leaves. Prune out any brown leaves or stems.', 80000, 'item', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_7865341.gif', 'Asplenium Parvati Fern', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-33425418.gif', 'Asplenium Parvati Fern', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-3342546.gif', 'Asplenium Parvati Fern', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Cactus /Cacti';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Cactus /Cacti', 'agro-inputs-seeds', 'Plant name: CACTUS Cacti are desert plants that come in different shapes and sizes and some boast brightly coloured flowers. They have adaptations to conserve water. The spines help to prevent water loss. Cacti are known for their love for sunlight however indoor cacti tend to need less light and are smaller in size. Place them near a well lit window and also move them out for early morning or late evening sunlight like once in a week. For indoors, you can have them as a house plant or an office plant or any indoor space as long as there is enough bright light, for out door purposes you can still have them potted, as stand alone and also use them in rock gardens or in a cactus flower bed Cactus are very strong in eliminating bacteria, tackling down pollution, great at reducing radiations especially electronic ones thus preventing the would be cancers that would result from electronic… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 25000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Cactus.gif', 'Cactus /Cacti', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-2741125347.gif', 'Cactus /Cacti', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-276341321.gif', 'Cactus /Cacti', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Philodendron Atom';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Philodendron Atom', 'agro-inputs-seeds', 'The Philodendron Atom (Philodendron selloum) is a compact, tropical indoor plant with glossy lobe-shaped leaves. A shade plant with a compact growing habit, it grows to about 30cm high and 20cm wide, making it a welcome addition to your living room. Light It prefers growing in indirect sunlight. Watering Water twice a week but most importantly check if the soil is dry before watering again It does well in Well-drained soil or potting mix. Note, price doesn’t include ceramic pots', 90000, 'item', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_787151758.gif', 'Philodendron Atom', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-3343151844.gif', 'Philodendron Atom', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-3343151859.gif', 'Philodendron Atom', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'CALATHEA / Peacock/Zebra plant';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'CALATHEA / Peacock/Zebra plant', 'agro-inputs-seeds', 'Also known as peacock/zebra There are several dozens of species in this genus. Each specie is unique in the way it looks but they all have the same care. They are popular for there attention grabbing decorative leaves and in some species, colorful inflorescences. Some species have an amazing feature of folding up their leaves in the evening and then unfurl in the morning a Phenomenon that earns them their name of PRAYER PLANTS They make very good indoor plants since they prefer low light to medium light. Therefore you can have it in the house, office, and any other indoor space. You can also have it on your shady balcony or part of your landscape provided its in shade. The soil should be kept moist but not so wet and yet not so dry. They are very low maintenance plants considering you place the plant in shade and keep the soil moist. PS. Calatheas are a symbol of new beginning. This… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 25000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/CALATHEA-400.jpg', 'CALATHEA / Peacock/Zebra plant', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-315084150.png', 'CALATHEA / Peacock/Zebra plant', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-31508425.png', 'CALATHEA / Peacock/Zebra plant', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Angloenema';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Angloenema', 'agro-inputs-seeds', 'A-gla-o-ne-ma also known as Chinese Evergreens. They have beautiful decorative foliage / leaves. They are excellent indoor plants as long as there is enought light. The dark green varieties can with stand abit of low light conditions whereas the colored / variagated ones would prefer to be more in a well- lit location. Be careful not to put your A-gla-o-ne-ma in full sun as the leaves will burn. Also they prefer well drained soil. Keep the soil moist. Only water when the 2 inches if the top layer are dry to touch. Avoid over watering as the leaves will turn yellow', 90000, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_594124748.png', 'Angloenema', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-3150124832.png', 'Angloenema', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_675111456.gif', 'Angloenema', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Anthuriums';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Anthuriums', 'agro-inputs-seeds', 'Plant name: ANTHURIUM andraenum also known as flamingo or lance leaf Is a delightful tropical plant with glossy heart shaped dropping leaves and bright heart shaped blooms with colors varying from Red, orange,pink, white, green and black It is basically an indoor plant which makes it a very good house plant and you can have it for your office too and in any other indoor space, For outdoor purposes you can have it on your shady balcony, use it in your landscape work as long as its in a shady spot Anthuriums are not hard to care for and maintain as long as you have the plant in the right soil, and in the right light location The plant grows best in bright indirect light however in very low light conditions, it will have fewer flowers and grow slower and yet so direct burning sun may cause the leaves to burn Fertilise once in a while like every after 4months with a fertiliser with high… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 25000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Anthuriums.gif', 'Anthuriums', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-315085043.png', 'Anthuriums', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-315085058.png', 'Anthuriums', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Asplenium';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Asplenium', 'agro-inputs-seeds', 'Plants genus: Asplenium Mainly looking at the bird''s nest ferns These are tropical plants with light green, large and broad shinny leaves. They can survive both as air plants or as a terristerial plant. Bird''s nest ferns have a very low maintenance routine. They prefer partial shade to full shade. So if you are having it as an indoor plant, ensure to place it where there is enough bright light. Whereas a s an outdoor plant , it doesn''t like direct sunlight as the leaves may get scorched Water when the soil is dry, these nest ferns like it when soil is moist at all times but not soggy so avoid avoid over watering. While watering, water around the edge of the center rosette but not exactly in the center to avoid the water becoming stagnant which may cause root rot. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 25000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_59474919.png', 'Asplenium', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-315074728.png', 'Asplenium', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-315074744.png', 'Asplenium', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Begonia';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Begonia', 'agro-inputs-seeds', 'Plant Genus: BEGONIA These perennial flowering plants are popular for their fancy leaves that have many beautiful colors, patterns and beautiful variegations Some species are grown as house plants but they have to be placed where they receive very bright light. The other species are are out door plants, you can have it as a potted plant or plants them in shaded beds to add colour in the garden. However some begonias can with stand full sun conditions They dont like being over watered so its better to water when dry. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 25000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Begonia.gif', 'Begonia', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-314982236.png', 'Begonia', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-314982252.png', 'Begonia', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Bougainvillea';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Bougainvillea', 'agro-inputs-seeds', 'Is an evergreen thorny ornamental vine. The actual flower of the plant is small and generally white covered with bright colored bracts in shades of pink, red, yellow, orange, purple, white, Uses Can be grown as a pot plant or container plant Grown in flower beds Can be trained as a climber Its one of the best pergola plants Can be trained as a topiary Makes a beautiful bonsai specimen Light They grow best in an area where they receive a minimum of 5-6hours of sunlight everyday Watering When grown in a pot, it will require to be watered often when the soil dries out, when grown in the ground, they are drought tolerant once established Note, price doesn’t include ceramic pot.', 70000, 'item', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_78661921.gif', 'Bougainvillea', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-334261954.gif', 'Bougainvillea', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-33426204.gif', 'Bougainvillea', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Bromelia';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Bromelia', 'agro-inputs-seeds', 'Plant Name: BROMELIADS These share the same botanical family with the pineapple. They have a wide varieties of leaf color ranging from green to maroon to different variegations. They are adopted to different various climates, some of the species we have in our collection will require from just having enough bright light to partial shade and some with stand full sun conditions They are so easy to care for and will just need to put some water in there centre cup formed from the arrangement of their leaves These astounding beauties add an exotic touch to your home. You can have them as potted plants or mass plant them in your garden, and edge to mark off your flower bed. They also make very good rock garden plants. Some are air plants hence can have them attached to trees or drift woods Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 25000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Bromelia.gif', 'Bromelia', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-31509011.png', 'Bromelia', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-31509026.png', 'Bromelia', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Caladiums';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Caladiums', 'agro-inputs-seeds', 'Caladiums-They are commonly known as heart of Jesus. They are known for their big heart-shaped leaves that display amazing color combinations of white, pink, red and green. Uses of Caladiums in a Landscape Mass planting Caladiums creates a focal point in a landscape. White cultivar selection are excellent choices to for mixing with ferns and hostas. Can be grown around the base of a tree. Can be grown as a ground cover. They also grow well in containers. Light conditions They thrive well in shady or semi- shady locations. A few of them tolerate sunshine. The leaf colors are more vibrant when grown in shade. Watering Keep the soil evenly moist during the growing season. If you allow the soil to dry out completely, the leaves may yellow and drop.', 50000, 'item', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_786142552.gif', 'Caladiums', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-3342142627.gif', 'Caladiums', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-3342142640.gif', 'Caladiums', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Calathea';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Calathea', 'agro-inputs-seeds', 'Plant genus: CALATHEA Also known as peacock/zebra There are several dozens of species in this genus. Each specie is unique in the way it looks but they all have the same care. They are popular for there attention grabbing decorative leaves and in some species, colorful inflorescences. Some species have an amazing feature of folding up their leaves in the evening and then unfurl in the morning a Phenomenon that earns them their name of PRAYER PLANTS They make very good indoor plants since they prefer low light to medium light. Therefore you can have it in the house, office, and any other indoor space. You can also have it on your shady balcony or part of your landscape provided its in shade. The soil should be kept moist but not so wet and yet not so dry. They are very low maintenance plants considering you place the plant in shade and keep the soil moist. PS. Calatheas are a symbol of… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 25000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Calathea.gif', 'Calathea', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-315084236.png', 'Calathea', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-315084254.png', 'Calathea', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Desert rose (Adenium Obesum)';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Desert rose (Adenium Obesum)', 'agro-inputs-seeds', 'The Desert rose ( Adenium Obesum) is a slow growing plant. Its often used as a bonsai plant due to it’s thick trunk and trumpeting flowers. Uses Widely used as an ornamental plant Can be grown as a bonsai Grown as a container plant Sunlight The plant thrives well in a-lot of sunlight of full sun conditions. This could be about 6hours of sun a day Water Similar to other succulent plants, it needs careful water management. Allow the soil to dry out completely before the next watering. Also grow it in a pot with ample drainage holes Prune periodically to encourage new shoots of branches in your desert rose', 80000, 'item', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_786172253.gif', 'Desert rose (Adenium Obesum)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-3342172330.gif', 'Desert rose (Adenium Obesum)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-3342172342.gif', 'Desert rose (Adenium Obesum)', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Dianthus';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Dianthus', 'agro-inputs-seeds', 'They have shapely blooms contrasting nicely with the evergreen foliage making an eye catching display and they bloom all year round. Dianthus grow well in pots, borders / edges, ground covers. They are also perfect for attracting butterflies so you can use them in butterfly garden designs. Place them where they receive atleast 6hours of sun. Water when the soil is dry to to touch and only water them at the base of the plant to keep leaves dry and prevent mildew spotting.', 60000, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_594125354.png', 'Dianthus', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-3150125425.png', 'Dianthus', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_675111456.gif', 'Dianthus', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Dracaena';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Dracaena', 'agro-inputs-seeds', 'Plant genus: Dracaena Is a large group of popular house plants that tolerates a wide variety of conditions. They have spiky , tropical foliage that come in a variety of colors, shapes and patterns These plants make very nice indoor plants and even help purify air. The small bushy form of young plants suit table tops, desks or shelves. In the right conditions, some can grow up to 6feet tall making it perfect for adding life to a corner of a living room, office or any indoor space Its easy to grow indoors since some species can even survive dim light conditions. The plant is also ideal for balcony, garden or any other outdoor space. Don''t over water, the plant doesn''t want soggy soil. Let the soil dry out before you water. The plant requires well drained soils Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 25000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Dracaena.gif', 'Dracaena', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-31507570.png', 'Dracaena', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-315075716.png', 'Dracaena', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Fittonia / Nerve Plant';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Fittonia / Nerve Plant', 'agro-inputs-seeds', 'Plant genus: Fittonias Fittonias are evergreen spreading perennials and usually don''t grow as high since they get to like 10cm to 15cm. The plant is also known as NERVE PLANT. They are decoratively veined. Although, the the most popular vein colour is silvery white, there are other varieties in pink, white, and green They are very wonderful indoor plants, so you can have them in your house, office space, etc for small spaces like table tops, shelves, window seals or any other small indoor space. There spreading habit makes an ideal ground cover thus you can have them as a hanging plant They are very easy to care for and maintain as long as you provide the right growing conditions. Fittonias are best kept in moist soil. Without water for a few days, the plant tends to ""FAINT"" but this can be revived with a quick watering. Too much water causes yellowing of leaves The plant grows best… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 25000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Fittonia.gif', 'Fittonia / Nerve Plant', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-276382256.gif', 'Fittonia / Nerve Plant', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-276382322.gif', 'Fittonia / Nerve Plant', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Geranium';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Geranium', 'agro-inputs-seeds', '"Plant genus: GERANIUM Geraniums is a genus of flowering species. They have palmate leaves that are broadly round. The leaves too emit a lovely scent. Geranium flowers come in different shades of red, pink, and white ideal for adding color to your outdoor space. One can have them as potted plants on a sunny balcony, as a hanging plant or in a flower bed. They thrive better in full sun conditions. They don''t like water logged soils so it''s better to water when the soil is dry. PS. They make a lovely house warming gift as they represent friendship or good health." Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 25000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_5948746.png', 'Geranium', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-315081034.png', 'Geranium', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-315081049.png', 'Geranium', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Gerberas';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Gerberas', 'agro-inputs-seeds', 'The flowers come in numerous bright colored shades of yellow, red , white, orange, pink, etc and some varieties are bicolored meaning they have 2 colors on their petals Uses Gerberas are planted as bedding plants Grown as container plants They are also good air purifying plants Light Gerberas grow well in areas where they get at least 6hours of sunshine Watering Water regularly when the soil dries up. When watering avoid overhead irrigation to prevent leaf diseases. Discourage fungal infections by watering early in the day so the leaves can dry put before nightfall.', 40000, 'item', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_78621275.gif', 'Gerberas', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-3342215413.gif', 'Gerberas', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-334221542.gif', 'Gerberas', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Houttuynia Cordata';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Houttuynia Cordata', 'agro-inputs-seeds', 'Houttuynia Cordata - It’s also known as Chameleon plant. It is an attractive low growing shrub, bearing a striking carpet of variegated red, cream and green leaves. It’s flowers are simple with prominent centres. Uses in landscaping Can be grown as a ground cover Grown as a pot plant Used to demarcate ponds/ water garden margins Light It grows well in partial sun to full sun conditions Water They grow well in moist soils. Water when the top layers of soil are dry. Do not let the soil dry out completely Performs best if given ample space to spread', 80000, 'item', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_787135949.gif', 'Houttuynia Cordata', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-334314024.gif', 'Houttuynia Cordata', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-334314054.gif', 'Houttuynia Cordata', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Hoya';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Hoya', 'agro-inputs-seeds', 'Hoyas are popularly grown for their attractive foliage and some for their strongly scented flowers. Hoyas grow well indoors, preferring bright light, but will tolerate fairly low light levels, although they may not flower without bright light Never cut the long tendrils! Leaves and flower clusters develop from these. Hoyas don’t mind being a bit root bound. Therefore you can Keep it in the same pot for years, but remember to fertilize. Plant in pots with well draining soil and water when the soil is dry to touch.', 80000, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_59413754.png', 'Hoya', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-315013825.png', 'Hoya', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_675111456.gif', 'Hoya', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Kalanchoe';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Kalanchoe', 'agro-inputs-seeds', 'Plant Name: KALANCHOE blossfelidiana, commonly pronounced as Ka-la-n-ko. This amazing long flowering perennial succulent, blooms throughout the year at random times. The blooms come in different shades of orange, yellow, pink, red and white, thus adding a splash of color to your outdoor space. Its a sun loving plant, it requires 8 to 10hours of sun. It grows with minimal care and fertilisation, water when dry and trim off any dead or wilting flowers to maintain vigorous flowering Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 25000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Kalanchoe.gif', 'Kalanchoe', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-27639231.gif', 'Kalanchoe', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-27639245.gif', 'Kalanchoe', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Maidenhair Fern';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Maidenhair Fern', 'agro-inputs-seeds', 'Adiantums Ferns are also commonly know as Maidenhair Fern. The plant is known for it''s soft draping fronds / leaves in lime green. It loves indirect /filtered light and can not tolerate full sun This fern doesn''t find it fun for it''s soil to dry out.So keep the soil moist at all times but also not soggy.', 80000, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_594131441.png', 'Maidenhair Fern', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-3150131531.png', 'Maidenhair Fern', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_675111456.gif', 'Maidenhair Fern', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Pothos, Money Plant, Devil''s Ivy';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Pothos, Money Plant, Devil''s Ivy', 'agro-inputs-seeds', 'Pothos is arguably the easiest of all houseplants to grow, even if you are a person who forgets to water your plants. This trailing vine has pointed, heart-shaped green leaves, sometimes variegated with white, yellow, or pale green. While pothos likes bright, indirect light it can thrive in areas that don’t get a lot of sunlight or have only fluorescent lighting. It''s an excellent plant for locations such as offices and sitting rooms. One advantage of growing pothos is that they are high on the list of plants that can help purify indoor air of chemicals. It makes for a good water plant as well!" Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 25000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_593143038.png', 'Pothos, Money Plant, Devil''s Ivy', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-3149143113.png', 'Pothos, Money Plant, Devil''s Ivy', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-3149143130.png', 'Pothos, Money Plant, Devil''s Ivy', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Sinningia Specioza';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Sinningia Specioza', 'agro-inputs-seeds', 'Sinningias have amazing attractive blooms usuall in shades of red, pink, and purple and variagated with white It prefers being placed where it receives partial sunlight. Avoid placing it under direct strong sun. Water when the soil is dry to touch. Ensure that its in well drained soil that can easily drain out excess water. Since the plant has hairy leaves, you can use a sprayer bottle with water and clean its foliage.', 75000, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_59413128.png', 'Sinningia Specioza', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-315013158.png', 'Sinningia Specioza', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_675111456.gif', 'Sinningia Specioza', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'This Aphelandra botanica';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'This Aphelandra botanica', 'agro-inputs-seeds', 'This Aphelandra botanica also commonly known as zebra plant flowers yellow like the ceramic pot we have placed it in?? This plant is known for its large shiny leaves and dark green foliage deeply veined in yellow or white reminiscent of zebra stripes hence the common name. Uses Grown as a container plant Used as garden plant LIGHT They thrive well in indirect light or partial shade, as they are used to growing under canopy of trees in the tropical jungles. Direct sunlight can scorch the leaves and in complete shade, the plant won’t bloom. Watering Water moderately. Do not let the soil to dry out and do not let it be excessively moist Plant in well drained soils as the plant doesn’t like it in soggy soils. Also it doesn’t like to dry out for long. Price doesn’t include ceramic pot', 100000, 'item', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_787192143.gif', 'This Aphelandra botanica', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-334319227.gif', 'This Aphelandra botanica', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_675111456.gif', 'This Aphelandra botanica', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Tillandsia Cyanea';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Tillandsia Cyanea', 'agro-inputs-seeds', 'Tillandsia cyanea or Pink quill is a must treat to yourself this Tuesday if you don’t have one yet in your collection. It is a species of flowering plant in the bromeliads family. An epiphytic (plants that obtain their food nutrients and water from the air) perennial growing to 50cm high and 50cm wide It grows both as an air plant and in soil. Not only is it a very easy and tough house plant but handles dry conditions. What makes this bromeliad so cool along with its bloom in relation to the size of the plant, is the fact that it is sold as an air plant as well as a potted plant It grows equally well either way. Good bright natural light is best for it. Morning or late evening sunlight helps it to bring on the flowering and keep it happy in a long run Avoid any strong direct sun burn. The best way to water yours is to spray it once or twice a week depending on how fast it dries up Since…', 50000, 'item', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_787202924.gif', 'Tillandsia Cyanea', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-3343202953.gif', 'Tillandsia Cyanea', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_675111456.gif', 'Tillandsia Cyanea', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Tillandsia, air plants';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Tillandsia, air plants', 'agro-inputs-seeds', 'Plant genus: Tillandsia/ air plants Today the genus we are looking at is an excellent example of diversity because it exhibits a multitude of physiological and morphological differences. They are called air plants because of their propensity to cling wherever conditions permit for example on tree branches, trunks, barks, rocks etc and also because they don''t grow in soil. Their leaves are more or less silvery in Color. They are covered with specialized cells called trichomes that are capable of rapidly absorbing water that gathers on them from which the plant survives. They are stunning as standalones. They are also used as features in living art pieces eg terrariums and other arrangements Air plants are easy to take care of. They need bright indirect light. If you are having yours indoors, place it near a window. Mist it more often with water if the temperature are high. WATERING: you… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 25000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Tillandsia.gif', 'Tillandsia, air plants', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-314983533.png', 'Tillandsia, air plants', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-314983549.png', 'Tillandsia, air plants', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Azalea shrub';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Azalea shrub', 'agro-inputs-seeds', 'Nothing is more beautiful than an Azalea shrub in bloom. These easy-care shrubs come in so many colors therefore its hard to find one that doesnt suit your needs. Azaleas can be grown in any Garden, instantly adding interest and color to drab areas. Grow or plant Azaleas in cool, lightly shaded areas. Full sun can actually burn the leaves while heavy shade can deprive them of necessary oxygen, resulting into poor blooming and weaker growth. However, Azaleas if slowly trained, can adopt to full sun conditions in the long run. They prefer well-drained soils. Also ensure keeping the soil moisturised at all times. Do not let the soil to completely dry out and do not over water. To maintain a compact appearance or simply encourage bushier growth, trim Azaleas after their blooming period has expired. Taking time to trim Azaleas by cutting back the branches of these shrubs will also help renew…', 100000, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_593132612.png', 'Azalea shrub', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-3149132912.png', 'Azalea shrub', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_675111456.gif', 'Azalea shrub', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'BROMELIADS';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'BROMELIADS', 'agro-inputs-seeds', 'These share the same botanical family with the pineapple. They have a wide varieties of leaf color ranging from green to maroon to different variegations. They are adopted to different various climates, some of the species we have in our collection will require from just having enough bright light to partial shade and some with stand full sun conditions They are so easy to care for and will just need to put some water in there centre cup formed from the arrangement of their leaves These astounding beauties add an exotic touch to your home. You can have them as potted plants or mass plant them in your garden, and edge to mark off your flower bed. They also make very good rock garden plants. Some are air plants hence can have them attached to trees or drift woods Take a look at some of our bromeliads collection #MauaAndMore #MauaMoments #staysafe Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 25000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/BROMELIADS-400B.jpg', 'BROMELIADS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_675111456.gif', 'BROMELIADS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/African-Violet.jpg', 'BROMELIADS', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Citrofortunella';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Citrofortunella', 'agro-inputs-seeds', 'Citrofortunella also known as lime is a citrus hybrid plant. It is Usually short and produces fruits even at a smaller size. It can be eaten as a whole or even used for juice. It can also be used to flavour drinks, and also used in beverages marinate fish, chicken etc. It can be used as a substitute for lemons..... They grow well in direct sunlight or half shade. You can feed them with Abit of compost.', 190000, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_59314142.png', 'Citrofortunella', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-314914216.png', 'Citrofortunella', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_675111456.gif', 'Citrofortunella', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Euonyumus Japonicus';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Euonyumus Japonicus', 'agro-inputs-seeds', 'Euonyumus japonicus, pronounced as u-oni-mus - This Is an evergreen shrub commonly used as landscape plant. Uses It makes a wonderful hedge plant It can be grown as a container plant It can be used to screen off a space It can be used as topiaries and standards Light It tolerates full sun and heavy shade but does well in sun dappled conditions with afternoon shade. Watering It has average watering needs and doesn’t need to be watered too frequently. Avoid over watering as it can cause root root. Make sure the soil is dry on too before watering again Prune occasionally to encourage it to be bushy', 30000, 'item', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_7862173.gif', 'Euonyumus Japonicus', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-334221744.gif', 'Euonyumus Japonicus', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-334221756.gif', 'Euonyumus Japonicus', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Gardenia -';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Gardenia -', 'agro-inputs-seeds', 'They are popular for their fragrant flowers and very dark green leaves. We recommend you plant them where people will notice there fragrance. Light Gardenias prefer partial shade areas where they receive a bit of sun. water Keep soil continuously moist. Do not overwater as it will cause root rot and do not let the plant to completely dry out for long. Prune gardenias after the plants have stopped blooming. Remove untidy branched and spent blooms.', 70000, 'item', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_787143050.gif', 'Gardenia -', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-3343143135.gif', 'Gardenia -', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-3343143147.gif', 'Gardenia -', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Hydrangeas';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Hydrangeas', 'agro-inputs-seeds', 'If you’re looking for a garden flower with a showy appeal, Hydrangea flowers are truly stunning. Although their appearance may seem high maintenance, with the right conditions and care, hydrangeas are actually easy to grow. Uses Can make good potted / container plants Flower bed plants Their blooms are used as cut flowers Mass planting in flower beds Hydrangeas love warm morning sun and they are susceptible to midday sunshine. The best place to plant hydrangeas is sheltered location with sunny mornings and shady afternoons. Hydrangeas grow well in soil containing abundance of organic material. Good drainage is vital. While Hydrangeas like moist soil, they cannot tolerate being waterlogged. Soggy, poor draining soils can cause root rot. Price doesn’t include ceramic pot', 50000, 'item', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_787141214.gif', 'Hydrangeas', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-3343141253.gif', 'Hydrangeas', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-3343141318.gif', 'Hydrangeas', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'KALANCHOE blossfelidiana';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'KALANCHOE blossfelidiana', 'agro-inputs-seeds', 'KALANCHOE blossfelidiana, commonly pronounced as Ka-la-n-ko ?? As we count down days with hope of the world healing, today we bring you this amazing long flowering perennial succulent, it blooms throughout the year at random times. The blooms come in different shades of orange, yellow, pink, red and white, thus adding a splash of color to your outdoor space. Its a sun loving plant, it requires 8 to 10hours of sun. It grows with minimal care and fertilisation, water when dry and trim off any dead or wilting flowers to maintain vigorous flowering PS: You can share with us a picture of your Kalanchoe plant in the comments section, those who don''t have it yet, we have some for sale once this is over #MauaMoments #bloomsofhope #washhands #staysafe Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 25000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/KALANCHOE-blossfelidiana.jpg', 'KALANCHOE blossfelidiana', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_675111456.gif', 'KALANCHOE blossfelidiana', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/African-Violet.jpg', 'KALANCHOE blossfelidiana', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'MEDINILLA';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'MEDINILLA', 'agro-inputs-seeds', 'Medinilla is one of the most graceful and stylish flowering plants you can grow outdoors in partial shade areas. Its beautiful, rose pink hanging flowers will add a pop of colour to any of your space, These plants require bright, indirect sunlight and should be shaded from the hottest rays of the day. If the leaves start turning brown either the air is too dry or your plant’s getting too much direct sunlight – adjust its position. Water well during the dry season and during the rainy months, water just enough to stop the plant from drying. This plant also loves humidity - mist spray the leaves during flowering season to encourage growth. The flowers on this plant will naturally die, so don''t take it personally. Simply prune them when they do to keep your Medinilla healthy.', 170000, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_593133241.png', 'MEDINILLA', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-3149133313.png', 'MEDINILLA', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_675111456.gif', 'MEDINILLA', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'ORCHID';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'ORCHID', 'agro-inputs-seeds', 'The Orchid family is a diverse and widespread family of flowering plants, with blooms that are often colorful and fragrant At Maua and More, we have wide range of orchid varieties from which include, Phaleanopsis, Dendrobiums, Cattleyas, oncidiums, zygopetalum, etc Orchids can be grown both indoors and outdoors depending on variety. Generally orchids are easy to take care of provided all their basic needs are met such as light, temperature and humidity Most orchid varieties are not grown in soil. There are several types of growing media that can be used with orchid plants. These include; bark, spahgnum peatmoss, charcoal, etc Orchids grow well where they receive partial sunlight. Insufficient light results into poor flowering. However too much sunlight can lead to leaf scorch Most of them, the roots are visible, so water when the roots tend to appear greyish or silverish, when the…', 125000, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_595115242.png', 'ORCHID', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-3151115331.png', 'ORCHID', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_675111456.gif', 'ORCHID', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Plumbago';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Plumbago', 'agro-inputs-seeds', 'The plumbago plant also known as the cape plumbago or sky flower is an evergreen shrub that flowers all year round with either blue or white blooms It can be grown as a container plant, stand alone shrub and planted in flowerbeds. It blooms best in full sun but will tolerate some shade but it will not bloom as much. The shrub tends to grow leggy therefore occasional prunning is advised The plant is pest resistant.', 50000, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_59512223.png', 'Plumbago', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-3151122232.png', 'Plumbago', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_675111456.gif', 'Plumbago', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Polka Dot';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Polka Dot', 'agro-inputs-seeds', 'Hypoestes Phyllostachya commonly known as polkadot plant. It is an eye-catching little plant with brightly spotted leaves that stand out against the foliage. It grows 1-2feet tall and 1 foot wide. The plant can be grown in the garden / flowerbeds, as a container plant and as a house plant. Polkadot plants have a tendency of growing leggy, therefore to promote a bushier growth, pinch back the top 2 leaves on each stem. This also helps the plant to grow healthier and more vigorous. If Grown as an outdoor plant, it likes a spot with some shade, too much sunlight causes the leaf colors to fade which lessens the ornamental value of the plant. As indoor plant, its better to place it where there is enough bright natural light. Water moderately. Avoid letting the soil dry out as that causes leaves to wilt and the plant to struggle. Also the soil shouldn’t be soggy as that causes root rot.', 30000, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_59314912.png', 'Polka Dot', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-314914944.png', 'Polka Dot', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_675111456.gif', 'Polka Dot', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Variegated leaf Begonias';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Variegated leaf Begonias', 'agro-inputs-seeds', 'Variegated leaf Begonias are some of the most beautiful, visually interesting plants you can grow in your plants collection. They grow well in indirect bright light to partial sun. Too much sun will scorch the leaves. Water moderately to keep the soil only moist. Too much water or overwatering is the quickest way to kill a begonia. Ensure to let the soil dry out slightly in between waterings. Also always keep the leaves dry to prevent powdery mildew. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 25000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_5967570.png', 'Variegated leaf Begonias', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-302413549.jpg', 'Variegated leaf Begonias', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-315275858.png', 'Variegated leaf Begonias', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Alocasia Reginula Black Velvet';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Alocasia Reginula Black Velvet', 'agro-inputs-seeds', 'Alocasia Reginula Black Velvet Is an exotic, elegant with silver veins that shine against the broad leaf’s dark, velvety background. Light The plant grows well in bright indirect light, however its more tolerant of lower light than the other cultivars. Water Allow the top two inches of soil to dry before watering again. The plant is prone to root rot, therefore avoid excessively wet conditions', 130000, 'item', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_78642514.gif', 'Alocasia Reginula Black Velvet', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-334243021.gif', 'Alocasia Reginula Black Velvet', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-334243032.gif', 'Alocasia Reginula Black Velvet', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Asparagus ferns';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Asparagus ferns', 'agro-inputs-seeds', 'These ferns have attractive, feathery, light leaves. Uses: Grown in hanging baskets Can be used to decorate the deck or patio They are indoor air purifying plants. Make good pot plants Can be grown in bedrooms Light When growing asparagus ferns outside, place them in a part sun to shady location for best foliage growth. Water Mist the plant daily to keep the tiny leaves from turning brown and dropping. Keep the plant well watered at all times', 50000, 'item', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_78644627.gif', 'Asparagus ferns', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-334244656.gif', 'Asparagus ferns', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-334244717.gif', 'Asparagus ferns', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Blue star fern';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Blue star fern', 'agro-inputs-seeds', 'The Blue star fern is botanically known as Phlebodium davana. It has a beautiful appearance due to gray-blue color and gracefully serrated leaves. Uses The plant is ideal for bathrooms and kitchens provided there is enough bright natural light. It also does well in hanging baskets. Light Davana prefers partial shade but will enjoy some brighter indirect lighting conditions. Keep away from complete shade and direct sunlight sources as this will burn and dry out the leaves. Dark corners or very low light conditions will stunt the plant. Watering Keep the soil moist at all times. Water when the surface of soil becomes slightly dry. Avoid soggy soils it’s advisable to water on the sides other than directly onto the leaves. These ferns prefer higher humidity levels therefore mist the leaves occasionally for best results. Remember to rotate this fern occasionally so it can evenly receive…', 50000, 'item', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_7865527.gif', 'Blue star fern', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-334255235.gif', 'Blue star fern', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_675111456.gif', 'Blue star fern', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Dracaena Surculosa';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Dracaena Surculosa', 'agro-inputs-seeds', 'Dracaena surculosa is a popular indoor ornamental plant. The main attraction about this plant is it has bamboo like stem and it can purify the air. It’s a perfect choice to adding life to your home Uses Used in home and office decor Grown as an air purifying plant Sunlight Place your plant in a spot that receives bright indirect light Watering Water only when the soil feels dry to touch. The soil must never be allowed to dry out completely Plant protection Wipe the dust from the leaves with a clean wet cloth or wash it off using a water in a hand sprayer Remove dead leaves and any other infected parts of the plant NOTE, Price doesn’t include ceramic pot', 90000, 'item', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_786173843.gif', 'Dracaena Surculosa', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-3342173935.gif', 'Dracaena Surculosa', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-3342173950.gif', 'Dracaena Surculosa', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Pilea Peperomioides';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Pilea Peperomioides', 'agro-inputs-seeds', 'Pilea peperomioides also commonly known as Chinese money plant or Coin plant. is a popular house plant with attractive coin shape leaves LIGHT It thrives well in bright indirect light. The plant responds faster to light therefore it can easily tend to grow towards one end if not placed where it evenly receives light. What you need to do if you notice this is to rotate it every week so the plant’s leaves spread out evenly WATER Water when the soil dries out to touch but do not leave it to dry out for longer times and also avoid over watering', 40000, 'item', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_78719122.gif', 'Pilea Peperomioides', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-334319155.gif', 'Pilea Peperomioides', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_16045_675111456.gif', 'Pilea Peperomioides', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Succulents';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Succulents', 'agro-inputs-seeds', 'Plant group: SUCCULENTS These plants have thickened and fleshy leaves to retain water in arid climates or dry soil conditions. They are often grown as ornamental plants because because of their striking and unusual appearance. They are commonly used in floral arrangements, can be placed at a window sill, for office in small spaces like tables or shelves, and also used in rock gardens or succulent beds. For indoor purposes, its better to place them in spots with very bright light or even rays of sun coming in. You can also move them out like once in a week for morning sun Succulents have the ability to thrive with relatively minimal care They don''t like too much water so its better to water when soil is dry which an estimate of once in a week or after 5 days. They also prefer well drained soils which is more of sandy. PS. succulents symbolize enduring and timeless love. For they are… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 25000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Succulents.gif', 'Succulents', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-276373621.gif', 'Succulents', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery16045-276373635.gif', 'Succulents', true);
  end if;
end $$;

-- African Mushroom Growers (U) Ltd · +256708382116+256782324041+256755488979 · 10 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'african-mushroom-growers-u-ltd@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'african-mushroom-growers-u-ltd@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256708382116+256782324041+256755488979' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'manufacturer', 'free', 'African Mushroom Growers (U) Ltd', 'African Mushroom Growers (U) Ltd',
      'AM', '+256708382116+256782324041+256755488979', null, '+256708382116+256782324041+256755488979', 'african-mushroom-growers-u-ltd@suppliers.bubu.market',
      'Kampala, Uganda, Makindye, Makindye, Kampala', 'kampala', 'agricultural produce', 'African Mushroom Growers (U) Ltd supplies agricultural produce, food and beverages from Kampala. 10 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'African Mushroom Growers (U) Ltd supplies agricultural produce, food and beverages from Kampala. 10 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'agriculture-produce') on conflict do nothing;
  insert into account_categories (account_id, category_id) values (v_acct, 'food-beverage') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/African-Mushroom-Growers-Products.jpg', 'African Mushroom Growers (U) Ltd — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Cotton Seed Husks';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Cotton Seed Husks', 'agriculture-produce', 'African Mushroom Growers sells Cotton seed husks, also known as cotton seed hulls. They are the outer coverings of cotton seeds. These by-products of the cotton industry have a variety of uses in agriculture, industry, and mushroom cultivation. Applications of Cotton Seed Husks Mushroom Cultivation: Widely used as a substrate for growing mushrooms, especially for species like oyster mushrooms.Their high lignocellulosic content makes them an excellent medium for fungal growth. Soil Amendment: When added to soil, cotton seed husks improve aeration, water retention, and organic matter content. Used as mulch, they help retain soil moisture, regulate soil temperature, and suppress weed growth. Composting: A valuable carbon source in composting, helping balance the carbon-to-nitrogen ratio. Their fibrous nature aids in aeration and decomposition processes. Industrial Uses: Utilized in the…', 1200, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_37045_1669131324.jpg', 'Cotton Seed Husks', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery37045-4225132042.jpg', 'Cotton Seed Husks', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_37045_16681692.jpg', 'Cotton Seed Husks', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Mother Spawn';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Mother Spawn', 'agriculture-produce', 'African Mushroom Grower''s Mother spawn are well prepared and are a critical component in the cultivation of mushrooms, serving as the primary source of fungal mycelium for further propagation. Mother spawn bottles, also known as master spawn or mother culture bottles, are containers filled with a sterilized substrate that has been inoculated with a pure culture of mushroom mycelium. They are used to produce the initial mycelium that will be transferred to larger batches of substrate for mushroom production. Purpose and Importance: Source of Mycelium: They act as the original source of mycelium used to inoculate secondary spawn, ensuring genetic consistency and vigor in the mushroom crop. Scaling Up: A single mother spawn bottle can inoculate multiple secondary spawn containers, which are then used to inoculate the final substrate for fruiting. Quality Control: By maintaining a pure and…', 20000, 'item', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_37045_1669122928.jpg', 'Mother Spawn', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery37045-422512369.jpg', 'Mother Spawn', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_37045_16681692.jpg', 'Mother Spawn', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Mushroom gardens ready for fruiting';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Mushroom gardens ready for fruiting', 'agriculture-produce', 'African Mushroom Growers Button Mushroom gardens and Oyster Mushroom Gardens are ready for fruiting. They are an exciting and practical way to cultivate mushrooms at home or on a small scale. These gardens typically consist of pre-inoculated substrates or kits that have already undergone the necessary steps of colonization and are ready to produce mushrooms. Types of Mushroom Gardens: Kits: These are sold as ready-to-use blocks or bags containing a substrate fully colonized with mushroom mycelium for oyster mushrooms Tubs or Trays: Containers filled with a prepared substrate, used for growing button mushrooms. Benefits of Ready-to-Fruit Mushroom Gardens: Convenience: These kits simplify the growing process, eliminating the need for inoculation and initial substrate preparation. Educational: Great for learning about mushroom cultivation and the lifecycle of fungi. Fresh Produce: Provides…', 3000, 'roll', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_37045_1669115023.jpg', 'Mushroom gardens ready for fruiting', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery37045-422511572.jpg', 'Mushroom gardens ready for fruiting', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_37045_16681692.jpg', 'Mushroom gardens ready for fruiting', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Ami Wine';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Ami Wine', 'food-beverage', 'Ami Wine is natural wine produced from oyster mushrooms, ready to drink at home and functions. Our bottle is 750 Ml. It is a relatively unique and niche product. It has gained interest in specialty circles due to its distinctive flavor profile and health benefits. Uses of Ami Wine: Culinary Applications:Cooking Ingredient: Used in recipes to add depth and umami flavor to dishes. It can be incorporated into sauces, marinades, and dressings. Culinary Applications: Pairing with Food: Serves as a complementary beverage for meals, particularly those featuring mushrooms, seafood, and poultry. Cocktail Ingredient: Mixology: Can be used in cocktails and mixed drinks to provide a unique flavor twist. Its earthy and slightly nutty notes can enhance various cocktail recipes. Health and Wellness: Health Drinks: Consumed for its potential health benefits, often marketed as a wellness or functional…', 20000, 'item', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_37045_16681692.jpg', 'Ami Wine', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery37045-4224162144.jpg', 'Ami Wine', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_37045_1669131324.jpg', 'Ami Wine', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Food products - Kice Dried Oyster Mushrooms';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Food products - Kice Dried Oyster Mushrooms', 'food-beverage', 'Kice Dried Oyster Mushrooms are well dried, with shelf life of more than two years. 100% natural with no preservatives. Our dried Oyster Mushrooms offer a concentrated form of the nutritional benefits found in their fresh counterparts. Nutrition Composition Dried oyster mushrooms are packed with nutrients, and their nutritional profile becomes more concentrated due to the removal of moisture. A typical 100-gram serving of dried oyster mushrooms may contain approximately: Calories: 250-300 kcal Protein: 20-30 grams Carbohydrates: 40-50 grams Fiber: 10-15 grams Fats: 2-5 grams: Saturated Fat: Low;Unsaturated Fat: Present in small amounts Vitamins:Vitamin D: Higher concentrations due to drying and potential exposure to sunlight; B Vitamins: Includes B1 (Thiamine), B2 (Riboflavin), B3 (Niacin), B5 (Pantothenic Acid), and B7 (Biotin) Minerals:Potassium: 800-1000 mg;Iron: 10-15 mg;Phosphorus:…', 5000, 'packet', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_37045_1668164256.jpg', 'Food products - Kice Dried Oyster Mushrooms', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery37045-4224165615.jpg', 'Food products - Kice Dried Oyster Mushrooms', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_37045_16681692.jpg', 'Food products - Kice Dried Oyster Mushrooms', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Food products - Kice Fresh Button Mushrooms';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Food products - Kice Fresh Button Mushrooms', 'food-beverage', 'At African Mushroom Growers (U) Ltd we sell fresh harvested button mushrooms from our gardens. Our mushrooms are edible, very nutritious and popular. They offer a range of health benefits and culinary uses due to their rich nutrient profile and versatile flavor. Nutritional Profile of Button Mushrooms: Button mushrooms are low in calories but rich in essential nutrients: Vitamins: Good source of B vitamins (B2, B3, B5) and vitamin D when exposed to sunlight. Minerals: Contain important minerals such as selenium, potassium, phosphorus, and copper. Antioxidants: High in antioxidants, including ergothioneine and glutathione. Fiber: Provide dietary fiber, which aids in digestion. Health Benefits of Button Mushrooms: Immune Support:Contain polysaccharides, such as beta-glucans, which can enhance immune function. Cancer Prevention: Rich in antioxidants and compounds that have been linked to…', 10000, 'item', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_37045_1679122036.jpg', 'Food products - Kice Fresh Button Mushrooms', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_37045_16681692.jpg', 'Food products - Kice Fresh Button Mushrooms', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_37045_1669131324.jpg', 'Food products - Kice Fresh Button Mushrooms', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Food products - Kice Fresh Oyster Mushroom';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Food products - Kice Fresh Oyster Mushroom', 'food-beverage', 'At African Mushroom Growers (U) Ltd we sell fresh harvested oyster mushrooms from our gardens. Our mushrooms are edible, very nutritious and popular. They offer a range of health benefits and culinary uses due to their rich nutrient profile and versatile flavor. Here’s an overview of their nutrition composition, uses, and health benefits: Nutrition Composition: A typical 100-gram serving of fresh oyster mushrooms contains approximately: 1.Calories: 33 kcal 2.Protein: 3.3 grams 3.Carbohydrates: 6.1 grams Fiber: 2.3 grams Sugars: 0.6 grams 4.Fats: 0.3 grams Saturated Fat: 0.1 grams Unsaturated Fat: 0.2 grams 5.Vitamins: Vitamin D: Amount varies, especially if exposed to sunlight; helps with calcium absorption. B Vitamins: Includes B1 (Thiamine), B2 (Riboflavin), B3 (Niacin), B5 (Pantothenic Acid), and B7 (Biotin). 6.Minerals: Potassium: 300-400 mg Iron: 1-2 mg Phosphorus: 30-50 mg…', 6000, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_37045_1669111040.jpg', 'Food products - Kice Fresh Oyster Mushroom', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_37045_16681692.jpg', 'Food products - Kice Fresh Oyster Mushroom', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_37045_1669131324.jpg', 'Food products - Kice Fresh Oyster Mushroom', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Food products - Kice Oyster Mushroom Powder Box -250g';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Food products - Kice Oyster Mushroom Powder Box -250g', 'food-beverage', 'Kice Oyster Mushroom Powder Box is 250g - is a versatile product made from dried oyster mushrooms that are ground into a fine powder. This form retains many of the nutritional benefits of the whole mushroom while offering convenience and extended shelf life. Nutrition Composition A typical 100-gram serving may contain approximately: 1.Calories: 250-300 kcal 2.Protein: 20-30 grams 3.Carbohydrates: 40-50 grams 4.Fiber: 10-15 grams 5.Fats: 2-5 grams Saturated Fat: Low Unsaturated Fat: Present in small amounts 6.Vitamins: Vitamin D: Enhanced due to drying; helps with calcium absorption and bone health. B Vitamins: Includes B1 (Thiamine), B2 (Riboflavin), B3 (Niacin), B5 (Pantothenic Acid), and B7 (Biotin). 7.Minerals: Potassium: 800-1000 mg Iron: 10-15 mg Phosphorus: 300-500 mg Calcium: 50-100 mg Selenium: Significant amounts. 8.Antioxidants: Ergothioneine: A potent antioxidant that helps…', 10000, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_37045_1668174156.jpg', 'Food products - Kice Oyster Mushroom Powder Box -250g', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery37045-4224192513.jpg', 'Food products - Kice Oyster Mushroom Powder Box -250g', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_37045_16681692.jpg', 'Food products - Kice Oyster Mushroom Powder Box -250g', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Food products - Kice Oyster Mushroom Powder Tin - 100g';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Food products - Kice Oyster Mushroom Powder Tin - 100g', 'food-beverage', 'Kice Oyster Mushroom Powder Tin is 100g - is a versatile product made from dried oyster mushrooms that are ground into a fine powder. This form retains many of the nutritional benefits of the whole mushroom while offering convenience and extended shelf life. Nutrition Composition A typical 100-gram serving may contain approximately: 1.Calories: 250-300 kcal 2.Protein: 20-30 grams 3.Carbohydrates: 40-50 grams 4.Fiber: 10-15 grams 5.Fats: 2-5 grams Saturated Fat: Low Unsaturated Fat: Present in small amounts 6.Vitamins: Vitamin D: Enhanced due to drying; helps with calcium absorption and bone health. B Vitamins: Includes B1 (Thiamine), B2 (Riboflavin), B3 (Niacin), B5 (Pantothenic Acid), and B7 (Biotin). 7.Minerals: Potassium: 800-1000 mg Iron: 10-15 mg Phosphorus: 300-500 mg Calcium: 50-100 mg Selenium: Significant amounts. 8.Antioxidants: Ergothioneine: A potent antioxidant that helps…', 10000, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_37045_1669105554.jpg', 'Food products - Kice Oyster Mushroom Powder Tin - 100g', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery37045-422511030.jpg', 'Food products - Kice Oyster Mushroom Powder Tin - 100g', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_37045_16681692.jpg', 'Food products - Kice Oyster Mushroom Powder Tin - 100g', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Food products - Oyster Mushroom Herbal Jelly';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Food products - Oyster Mushroom Herbal Jelly', 'food-beverage', 'Oyster Mushroom Herbal Jelly - When used as a lotion or Vaseline it offers several potential benefits due to the bioactive compounds found in oyster mushrooms. These mushrooms are known for their nutritional and medicinal properties, which can translate into various skin care benefits. Benefits: Antioxidant Properties: Oyster mushrooms contain antioxidants like ergothioneine and selenium, which help protect the skin from oxidative stress and free radical damage, potentially reducing the signs of aging. Anti-Inflammatory Effects: The bioactive compounds in oyster mushrooms have anti-inflammatory properties that can help soothe irritated or inflamed skin, making the jelly beneficial for conditions like eczema or dermatitis. Moisturizing:When formulated as a lotion or Vaseline, the jelly can provide deep hydration, helping to maintain the skin’s moisture barrier and prevent dryness.…', 10000, 'piece', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_37045_1669103942.jpg', 'Food products - Oyster Mushroom Herbal Jelly', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B/ProductPics/ProdGallery37045-4225104615.jpg', 'Food products - Oyster Mushroom Herbal Jelly', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_37045_16681692.jpg', 'Food products - Oyster Mushroom Herbal Jelly', true);
  end if;
end $$;

-- Master Garden Varieties · +256774123228+256703626057 · 1 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'master-garden-varieties@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'master-garden-varieties@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256774123228+256703626057' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'trader', 'free', 'Master Garden Varieties', 'Master Garden Varieties',
      'MG', '+256774123228+256703626057', null, '+256774123228+256703626057', 'master-garden-varieties@suppliers.bubu.market',
      'P. O. Box 27220, Kampala, Makurubita, Luwero District, Central, Luweero', 'kampala', 'agricultural produce', 'Master Garden Varieties supplies agricultural produce from Kampala. 1 line is listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Master Garden Varieties supplies agricultural produce from Kampala. 1 line is listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'agriculture-produce') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/upfnnalongo3.gif', 'Master Garden Varieties — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'UPF Nnalongo (Passion Fruits Type) - Master Garden Varieties';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'UPF Nnalongo (Passion Fruits Type) - Master Garden Varieties', 'agriculture-produce', 'UPF Nnalongo is a Ugandan passion fruit variety that produces multiple fruits from a single fruit stalk. Background. Nnalongo, in Uganda, is a woman who produces more than one baby at ago. Because this variety shares the same attributes, and was developed in Uganda, we looked around for a name that would best describe what it does and at the same time reflect Uganda. We developed it locally, using a local but efficient technology from our local (commonly known as UPF12/Masaka) variety. For that matter, by physical characteristics, its masaka save for the yield. What inspired us! Because of the ever increasing demand for the fruit locally and abroad and because only a handful of farmers in Uganda at the time were involved in the trade, and even those few involved, the yields were low due unpredictable weather and high cost of production, we kept thinking: What can one do to use less and… Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 6500, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/upfnnalongo3.gif', 'UPF Nnalongo (Passion Fruits Type) - Master Garden Varieties', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/B2B/ProductDetail/uganda/agri-products/agri-products-unclassified/master-garden-varieties/upf-nnalongo-passion-fruits-type-master-garden-varieties/1/1/499/17018/img/MasterGardenVarieties/Master-UPF-Nnalongo-In-The-Garden.jpg', 'UPF Nnalongo (Passion Fruits Type) - Master Garden Varieties', true);
  end if;
end $$;

-- Pearl Cocoa Ltd · +256755500336+256774042072 · 2 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'pearl-cocoa-ltd@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'pearl-cocoa-ltd@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256755500336+256774042072' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'manufacturer', 'free', 'Pearl Cocoa Ltd', 'Pearl Cocoa Ltd',
      'PC', '+256755500336+256774042072', null, '+256755500336+256774042072', 'pearl-cocoa-ltd@suppliers.bubu.market',
      'Nalukolongo, Kampala, Uganda, P. O. Box 6699, Kampala - Uganda, Nateete, Kampala', 'kampala', 'agricultural produce', 'Pearl Cocoa Ltd supplies agricultural produce from Kampala. 2 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Pearl Cocoa Ltd supplies agricultural produce from Kampala. 2 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'agriculture-produce') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Pearl-Cocoa.jpg', 'Pearl Cocoa Ltd — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'Cocoa Powder';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Cocoa Powder', 'agriculture-produce', 'Cake & Powder Natural Cocoa Powder. Natural High Fat Cocoa Powder. Natural Extra High Fat Cocoa Powder. Premium Natural Cocoa Powder. Alkalized Cocoa Powder. Premium Alkalized Cocoa Powder. Alkalized High Fat Cocoa Powder. Alkalized Extra High Fat Cocoa Powder. Medium Brown Cocoa Powder. Medium Dark Brown Cocoa Powder. Dark Brown Cocoa Powder. Black/Brown Cocoa Powder. Black Cocoa Powder. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 12000, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_29343_9028137.jpg', 'Cocoa Powder', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_29343_9028843.jpg', 'Cocoa Powder', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'Pearl Cocoa Liquor';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'Pearl Cocoa Liquor', 'agriculture-produce', 'Pearl Cocoa Liquor Natural Cocoa Liquor. Premium Natural Cocoa Liquor. Alkalized Cocoa Liquor. Premium Alkalized Cocoa Liquor. Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 12000, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_29343_9028843.jpg', 'Pearl Cocoa Liquor', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Prod-_29343_9028137.jpg', 'Pearl Cocoa Liquor', true);
  end if;
end $$;

-- SEMHAR ENTERPRISE LIMITED (SEL) · +256772780950+256414672196 · 6 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'semhar-enterprise-limited-sel@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'semhar-enterprise-limited-sel@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256772780950+256414672196' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'trader', 'free', 'SEMHAR ENTERPRISE LIMITED (SEL)', 'SEMHAR ENTERPRISE LIMITED (SEL)',
      'SE', '+256772780950+256414672196', null, '+256772780950+256414672196', 'semhar-enterprise-limited-sel@suppliers.bubu.market',
      'Kampala, Tirupati Mazima Mall, 3rd Floor, Suite 262 - Nsambya-Ggaba Road, Central, Kampala', 'kampala', 'food and beverages', 'SEMHAR ENTERPRISE LIMITED (SEL) supplies food and beverages from Kampala. 6 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'SEMHAR ENTERPRISE LIMITED (SEL) supplies food and beverages from Kampala. 6 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'food-beverage') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/Semhar/Semhar-Banrock-Station-Collection.gif', 'SEMHAR ENTERPRISE LIMITED (SEL) — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'ADESSO (MERLOT)';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'ADESSO (MERLOT)', 'food-beverage', 'It is a dry red Italian wine with merlot and a alcohol content 12%.', 60000, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/CESARIADESSOCHARDONNAYRED.jpg', 'ADESSO (MERLOT)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/BANROCKSTATIONCOLOMBARDCHARDONNAY.jpg', 'ADESSO (MERLOT)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/BANROCKSTATIONCABRENETSAUVIGNON.jpg', 'ADESSO (MERLOT)', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'BANROCK STATION (COLOMBARD CHARDONNOY)';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'BANROCK STATION (COLOMBARD CHARDONNOY)', 'food-beverage', 'Beautifully Australian white wine matched the high acidity, fuller bodied Colombard with an aromatic Chardonnay.', 50000, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/BANROCKSTATIONCOLOMBARDCHARDONNAY.jpg', 'BANROCK STATION (COLOMBARD CHARDONNOY)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/CESARIADESSOCHARDONNAYRED.jpg', 'BANROCK STATION (COLOMBARD CHARDONNOY)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/BANROCKSTATIONCABRENETSAUVIGNON.jpg', 'BANROCK STATION (COLOMBARD CHARDONNOY)', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'BANROCK STATION CABRENET SAUVIGNON';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'BANROCK STATION CABRENET SAUVIGNON', 'food-beverage', 'Australian fruit-driven red wine with a sweet entry of blackberry, ripe black plum, and cassis. This soft, medium-bodied wine has nuances of dried herbs and toasted oak complementing the bright fruit characters.', 50000, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/BANROCKSTATIONCABRENETSAUVIGNON.jpg', 'BANROCK STATION CABRENET SAUVIGNON', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/CESARIADESSOCHARDONNAYRED.jpg', 'BANROCK STATION CABRENET SAUVIGNON', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/BANROCKSTATIONCOLOMBARDCHARDONNAY.jpg', 'BANROCK STATION CABRENET SAUVIGNON', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'LEONARDO (CHIANTI)';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'LEONARDO (CHIANTI)', 'food-beverage', 'It is a red Italian wine with a sangiovese 85%, merlot 10%, other red grapes 5% and an alcohol content of 12%.', 80000, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/LEONARDOCHIANTIITALIA.jpg', 'LEONARDO (CHIANTI)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/CESARIADESSOCHARDONNAYRED.jpg', 'LEONARDO (CHIANTI)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/BANROCKSTATIONCOLOMBARDCHARDONNAY.jpg', 'LEONARDO (CHIANTI)', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'TINI (VINO BLANCO)';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'TINI (VINO BLANCO)', 'food-beverage', 'It is white Italian wine with trebbiano, moscato, malvasia, and other Italian white grapes varieties and with an alcohol content of 11%.', 50000, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/TINIVINOBIANCO.jpg', 'TINI (VINO BLANCO)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/CESARIADESSOCHARDONNAYRED.jpg', 'TINI (VINO BLANCO)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/BANROCKSTATIONCOLOMBARDCHARDONNAY.jpg', 'TINI (VINO BLANCO)', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'TINI (VINO ROSSO)';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'TINI (VINO ROSSO)', 'food-beverage', 'It is an Italian wine with an alcohol content of 11.5%.', 50000, 'kg', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'As published by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/TINI-VINO-ROSSO.jpg', 'TINI (VINO ROSSO)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/CESARIADESSOCHARDONNAYRED.jpg', 'TINI (VINO ROSSO)', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/BANROCKSTATIONCOLOMBARDCHARDONNAY.jpg', 'TINI (VINO ROSSO)', true);
  end if;
end $$;

-- Horn Products Limited · +256772459134+25641253617 · 4 listings
do $$
declare v_user uuid; v_acct uuid; v_prod uuid;
begin
  select id into v_user from auth.users where email = 'horn-products-limited@suppliers.bubu.market';
  if v_user is null then
    v_user := gen_random_uuid();
    insert into auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new,
      phone_change, phone_change_token, reauthentication_token)
    values (v_user, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'horn-products-limited@suppliers.bubu.market', crypt('BubuSupplier@2026', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '', '', '', '');
  end if;

  select id into v_acct from accounts where phone = '+256772459134+25641253617' and role = 'supplier';
  if v_acct is null then
    insert into accounts (auth_user_id, role, business_type, tier, company, trade_name,
      initials, phone, alt_phone, whatsapp_phone, email, address, district_id,
      nature_of_business, about, coverage, import_source)
    values (v_user, 'supplier', 'manufacturer', 'free', 'Horn Products Limited', 'Horn Products Limited',
      'HP', '+256772459134+25641253617', null, '+256772459134+25641253617', 'horn-products-limited@suppliers.bubu.market',
      '--, --, Central, Kampala', 'kampala', 'stationery, art and printing', 'Horn Products Limited supplies stationery, art and printing from Kampala. 4 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.', 'Uganda', 'africa2trust')
    returning id into v_acct;
  else
    update accounts set auth_user_id = coalesce(auth_user_id, v_user),
      about = coalesce(nullif(about, ''), 'Horn Products Limited supplies stationery, art and printing from Kampala. 4 lines are listed here, each with photographs and specifications. This profile was built from a public trade directory and has not yet been confirmed by the business.') where id = v_acct;
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct, 'pending') on conflict (account_id) do nothing;

  insert into account_categories (account_id, category_id) values (v_acct, 'stationery-printing') on conflict do nothing;

  delete from media where account_id = v_acct and product_id is null and kind = 'company';
  insert into media (account_id, kind, storage_path, caption, approved)
    values (v_acct, 'company', 'https://www.africa2trust.com/imgs/_mg_0011.jpg', 'Horn Products Limited — storefront banner', true);

  select id into v_prod from products where supplier_id = v_acct and name = 'BANGLES';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'BANGLES', 'stationery-printing', 'Get different types of BANGLES Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 180000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/_mg_0011.jpg', 'BANGLES', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/art+021.jpg', 'BANGLES', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/_mg_0039.jpg', 'BANGLES', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'EAR RINGS';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'EAR RINGS', 'stationery-printing', 'We have designer ear rings of all shapes and sizes Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 24000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/art%20021.jpg', 'EAR RINGS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/_mg_0011.jpg', 'EAR RINGS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/art+021.jpg', 'EAR RINGS', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'FINGER RINGS';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'FINGER RINGS', 'stationery-printing', 'Get different finger ring types Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 24000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/_mg_0039.jpg', 'FINGER RINGS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/_mg_0011.jpg', 'FINGER RINGS', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/art+021.jpg', 'FINGER RINGS', true);
  end if;
  select id into v_prod from products where supplier_id = v_acct and name = 'HORN BEAD NECKLACES';
  if v_prod is null then
    insert into products (supplier_id, name, category_id, description, price, unit, moq,
      brand, status, import_source)
    values (v_acct, 'HORN BEAD NECKLACES', 'stationery-printing', 'Get different types of horn bead necklaces Indicative price: a Kampala wholesale estimate, not quoted by the supplier. Ask for a quotation.', 180000, 'unit', 1,
      null, 'published', 'africa2trust') returning id into v_prod;
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Price basis', 'Indicative — market estimate, not quoted by the supplier', 0);
    insert into product_specs (product_id, key, value, sort) values (v_prod, 'Imported from', 'africa2trust.com — not yet confirmed by the supplier', 1);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/Picture%20010.jpg', 'HORN BEAD NECKLACES', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/_mg_0011.jpg', 'HORN BEAD NECKLACES', true);
    insert into media (account_id, product_id, kind, storage_path, caption, approved)
      values (v_acct, v_prod, 'product', 'https://www.africa2trust.com/Imgs/art+021.jpg', 'HORN BEAD NECKLACES', true);
  end if;
end $$;

commit;

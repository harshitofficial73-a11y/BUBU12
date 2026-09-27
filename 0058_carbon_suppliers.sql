-- Carbon platform · supplier profiles from the Uganda B2B workbook
--
-- 180 suppliers, profiles only — no logins, as asked. Each carries an
-- import_code (S001…) so the product import can find it without guessing at
-- names, and so a re-run updates rather than duplicates.
--
-- Registration is left PENDING: nothing here has been verified, and these
-- businesses have not agreed to be listed.
--
-- Safe to re-run.

begin;

alter table accounts add column if not exists import_code text;
create unique index if not exists accounts_import_code_key
  on accounts (import_code) where import_code is not null;

-- S001 Bwengye Millers · 309 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Bwengye Millers','Bwengye Millers','BM',
  '+256771404275','+256757088722','+256771404275','Plot 12568 Naava Road, off Hoima Road, Kasubi, Kampala','kampala',
  'Bwengye Millers — Mill and agro-input supplier. Maize, beans, seeds, fertilizers and animal feeds. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S001')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S002 Mega Holdings Uganda Ltd · 60 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Mega Holdings Uganda Ltd','Mega Holdings Uganda Ltd','MH',
  '+256782339421','+256703339421','+256782339421','Plot 15 Martyrs Way, Ministers Village, Ntinda, Kampala','kampala',
  'Mega Holdings Uganda Ltd — Grain processor and bulk trader. Cereals, pulses, sesame, groundnuts and cassava. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S002')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S003 GKFOODS Ltd · 50 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','GKFOODS Ltd','GKFOODS Ltd','GL',
  '+256709763124','+256766528493','+256709763124','Plot 22/24 Semawatta Road, Ntinda, Kampala. Factory: Busesa, Bugweri','kampala',
  'GKFOODS Ltd — Local miller supplying rice and grain foods to bulk and institutional buyers. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S003')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S004 Sunrise Commodities and Millers (U) Ltd · 34 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Sunrise Commodities and Millers (U) Ltd','Sunrise Commodities and Millers (U) Ltd','SC',
  '+256755900718','+256712624624','+256755900718','Plot 163/165 Bombo Road, Kampala','kampala',
  'Sunrise Commodities and Millers (U) Ltd — Grain dealer and miller. Maize, beans, maize flour and sorghum. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S004')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S005 Ugagrains Ltd · 60 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Ugagrains Ltd','Ugagrains Ltd','UL',
  '+256758824824','+256772755824','+256758824824','Plot 10 Naguru Drive, Kampala','kampala',
  'Ugagrains Ltd — Processor and bulk trader of cereals and pulses. Directory contact. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S005')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S006 Dumark Enterprises Ltd · 32 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Dumark Enterprises Ltd','Dumark Enterprises Ltd','DE',
  '+256772428518',null,'+256772428518','Mbaguta Street, Mbarara City','mbarara',
  'Dumark Enterprises Ltd — Institutional bulk supplier of maize grain, maize flour and beans. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S006')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S012 Prest Foods (U) Ltd · 162 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Prest Foods (U) Ltd','Prest Foods (U) Ltd','PF',
  '+256782956805',null,'+256782956805','Nakasajja, Gayaza Road, Kampala','kampala',
  'Prest Foods (U) Ltd — Food supplier handling frozen vegetables, dry goods and fresh produce. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S012')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S011 Nabaat Agro Export · 34 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Nabaat Agro Export','Nabaat Agro Export','NA',
  '+256744248493',null,'+256744248493','Bukoto 1, Old Kira Road, Nakawa Division, Kampala','kampala',
  'Nabaat Agro Export — Uganda produce exporter. Avocado, coffee, tea, carrot, sesame, pineapple, lemon and tomato. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S011')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S007 Mwembetanga Fresh Foods · 144 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Mwembetanga Fresh Foods','Mwembetanga Fresh Foods','MF',
  '+256704643031','+256772308134','+256704643031','Plot 39A Mukwasi House, Lumumba Avenue, Kampala','kampala',
  'Mwembetanga Fresh Foods — Produce processor and exporter. Fruits, vegetables, beans, peanuts and maize flour. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S007')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S008 Pied Tropics Ltd · 144 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Pied Tropics Ltd','Pied Tropics Ltd','PT',
  '+256703664233','+256414671986','+256703664233','Lukuli, Makindye, Kampala','kampala',
  'Pied Tropics Ltd — Grower-linked bulk exporter of fresh and dried tropical produce and vanilla. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S008')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S009 SMG Farm Fresh · 142 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','SMG Farm Fresh','SMG Farm Fresh','SF',
  '+256705038531',null,'+256705038531','2nd Floor Kanjokya House, Plot 92 Kanjokya Street, Kamwokya, Kampala','kampala',
  'SMG Farm Fresh — Uganda-based fresh-food, fruit and vegetable exporter. Local order terms need confirmation. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S009')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S010 Afri-Fresh (Uganda) Ltd · 142 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Afri-Fresh (Uganda) Ltd','Afri-Fresh (Uganda) Ltd','AF',
  '+256759008686','+256759008688','+256759008686','Units 101–104, Tirupati Business Park, Plot M502, Kyebando, Kampala','kampala',
  'Afri-Fresh (Uganda) Ltd — Importer, wholesaler and distributor of fresh fruits and FMCG products. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S010')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S013 Nsanja Agro-Chemicals Ltd · 188 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Nsanja Agro-Chemicals Ltd','Nsanja Agro-Chemicals Ltd','NA',
  '+256392176170',null,'+256392176170','Plot 4 Ben Kiwanuka Street, Cares Corner Building, Shop 14, Kampala','kampala',
  'Nsanja Agro-Chemicals Ltd — Agro-input distributor. Seeds, fertilizers, pesticides and farm equipment. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S013')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S014 Trust Chemicals Uganda Ltd · 188 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Trust Chemicals Uganda Ltd','Trust Chemicals Uganda Ltd','TC',
  '+256783100652',null,'+256783100652','Plot 15 Nakivubo Lane, Kampala','kampala',
  'Trust Chemicals Uganda Ltd — Agro-input dealer. Chemicals, seeds and fertilizers. KCCA directory contact. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S014')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S015 Viena Farm Supply · 188 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Viena Farm Supply','Viena Farm Supply','VF',
  '+256772445910',null,'+256772445910','Container Village, Nakivubo, Kampala','kampala',
  'Viena Farm Supply — Agro-input dealer. Chemicals, seeds and fertilizers. KCCA directory contact. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S015')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S016 Superchem Agro Centre · 188 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Superchem Agro Centre','Superchem Agro Centre','SA',
  '+256774123865','+256701902408','+256774123865','Container Village, Nakivubo, Kampala','kampala',
  'Superchem Agro Centre — Agro-input dealer. Seeds, fertilizers and crop chemicals. KCCA directory contact. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S016')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S017 Global Agro Inputs Ltd · 136 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Global Agro Inputs Ltd','Global Agro Inputs Ltd','GA',
  '+256772621489',null,'+256772621489','11A Nakivubo Road, Container Village, Kampala','kampala',
  'Global Agro Inputs Ltd — Agro-input supplier. Seeds, seedlings, chemicals, implements and agricultural tools. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S017')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S018 Kwago Distributors Ltd · 20 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Kwago Distributors Ltd','Kwago Distributors Ltd','KD',
  '+256754348888',null,'+256754348888','Kampala, Uganda. P.O. Box 203311; street not published on source','kampala',
  'Kwago Distributors Ltd — Wholesaler and distributor of food, beverages and general merchandise. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S018')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S020 Spector Uganda Ltd · 11 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Spector Uganda Ltd','Spector Uganda Ltd','SU',
  '+256782779898','+256757759541','+256782779898','Plot 35B, Anyafio Village, Weather Head Park Lane, Arua City','arua',
  'Spector Uganda Ltd — Regional wholesaler and distributor of essential foods and household goods. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S020')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S162 Your Choice Ltd · 28 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Your Choice Ltd','Your Choice Ltd','YC',
  '+256772200113','+256312261587','+256772200113','Plot 24, 7th Street, Industrial Area, Kampala','kampala',
  'Your Choice Ltd — Local food importer/distributor with meat processing. Chilled/frozen foods, cheese, butter and ice cream. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S162')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S163 Fresh Cuts (U) Ltd / Quality Cuts · 24 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Fresh Cuts (U) Ltd / Quality Cuts','Fresh Cuts (U) Ltd / Quality Cuts','FC',
  '+256707571635','+256707512003','+256707571635','Plot 244 Block 266, Entebbe Road, Seguku','entebbe',
  'Fresh Cuts (U) Ltd / Quality Cuts — Local meat processor and wholesaler with direct special-order contacts. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S163')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S165 Uganda Meat Industries Ltd · 22 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Uganda Meat Industries Ltd','Uganda Meat Industries Ltd','UM',
  '+256774410856','+256414345595','+256774410856','Plot 5 Old Port Bell Road, Nakawa, Kampala','kampala',
  'Uganda Meat Industries Ltd — Local meat processor. KCCA directory contact; reconfirm product/cut availability. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S165')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S164 Cuts N Carvings Uganda · 24 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Cuts N Carvings Uganda','Cuts N Carvings Uganda','CN',
  '+256709991909','+256774140714','+256709991909','Old Port Bell Road, near Jessa Head Offices, Kampala','kampala',
  'Cuts N Carvings Uganda — Uganda outlet supplying frozen meats and seafood to homes and businesses. Bulk terms to confirm. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S164')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S019 INNIC Enterprises Ltd · 4 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','INNIC Enterprises Ltd','INNIC Enterprises Ltd','IE',
  '+256773894992','+256702594516','+256773894992','Room M03, Nambuusi Arcade, Kikuubo, Kampala','kampala',
  'INNIC Enterprises Ltd — Ingredient dealer. Bakery, ice cream and beverage ingredients, flavours and groceries. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S019')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S021 Kamp Feed · 117 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Kamp Feed','Kamp Feed','KF',
  '+256775716623','+256706604175','+256775716623','Plot 709 Kisaasi–Kyanja Road, opposite Rochester Hotel, Kampala','kampala',
  'Kamp Feed — Ugandan manufacturer of pelleted animal feeds. Factory in Nwoya. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S021')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S022 Conversion Feeds Ltd · 123 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Conversion Feeds Ltd','Conversion Feeds Ltd','CF',
  '+256782208208','+256707792064','+256782208208','Plot 5 Coronation Road, Old Kampala','kampala',
  'Conversion Feeds Ltd — Animal-feed distributor. Poultry, fish, pig, dairy and calf feed and concentrates. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S022')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S023 Concfeed International Ltd · 126 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Concfeed International Ltd','Concfeed International Ltd','CI',
  '+256393104283','+256754959083','+256393104283','Kawempe Mbogo, Bombo Road, Kampala','kampala',
  'Concfeed International Ltd — Local manufacturer of animal-feed additives and nutritional supplements. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S023')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S024 Champrisa International Ltd · 138 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Champrisa International Ltd','Champrisa International Ltd','CI',
  '+256775143081','+256200954701','+256775143081','Farm House, Kira, Kampala','kampala',
  'Champrisa International Ltd — Distributor of livestock and poultry nutritional products, concentrates and premixes. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S024')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S025 Kiwa and Sons · 144 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Kiwa and Sons','Kiwa and Sons','KA',
  '+256771824382','+256700962458','+256771824382','Lugazi Bridge, Kinyoro–Nakazadde Road, Lugazi','kampala',
  'Kiwa and Sons — Animal-feed miller and wholesaler. Feeds, additives and mineral supplements. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S025')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S158 Vet Equip Solutions Ltd · 88 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Vet Equip Solutions Ltd','Vet Equip Solutions Ltd','VE',
  '+256775966801','+256703282889','+256775966801','Shop F14, Kingsway Plaza, Kampala. Warehouse: Orange City Building, Kyengera','kampala',
  'Vet Equip Solutions Ltd — Local distributor of poultry equipment, cages, incubators, feeding/drinking systems and animal nutrition. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S158')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S159 Josca Farmer’s World Ltd · 73 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Josca Farmer’s World Ltd','Josca Farmer’s World Ltd','JF',
  '+256784106123','+256392002054','+256784106123','Bweyogerere, next to Watoto Church, Wakiso; Container Village, Kampala','kampala',
  'Josca Farmer’s World Ltd — Local bulk importer/distributor of poultry equipment, feeds and livestock supplements. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S159')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S160 God’s Mercy Agrovet · 21 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','God’s Mercy Agrovet','God’s Mercy Agrovet','GS',
  '+256759099188',null,'+256759099188','Kampala, Uganda; confirm street address','kampala',
  'God’s Mercy Agrovet — Independent poultry-supplies dealer with public feeder/drinker prices. Bulk terms to confirm. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S160')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S161 Kuteesa Poultry & Animal Feeds · 45 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Kuteesa Poultry & Animal Feeds','Kuteesa Poultry & Animal Feeds','KP',
  '+256705516219',null,'+256705516219',null,'kampala',
  'Kuteesa Poultry & Animal Feeds — Local animal-feed dealer supplying poultry feeders, drinkers and animal-health products. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S161')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S073 Snowmans Uganda Ltd · 195 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Snowmans Uganda Ltd','Snowmans Uganda Ltd','SU',
  '+256705220555',null,'+256705220555','Snowmans Centre, Plot 89, 7th Street, Industrial Area, Kampala','kampala',
  'Snowmans Uganda Ltd — Equipment supplier. Dairy processing, refrigeration, packaging, sealing, weighing and generators. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S073')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S075 Engineering Solutions (U) Ltd · 142 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Engineering Solutions (U) Ltd','Engineering Solutions (U) Ltd','ES',
  '+256200301800','+256200964221','+256200301800',null,'kampala',
  'Engineering Solutions (U) Ltd — Uganda agricultural-machinery distributor and fabricator. Tractors, implements, dairy and irrigation. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S075')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S076 Terra Agri Solutions · 210 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Terra Agri Solutions','Terra Agri Solutions','TA',
  '+256200917947',null,'+256200917947','Plot 310 Sserwada Close, Bukoto, Kampala. Confirm current office','kampala',
  'Terra Agri Solutions — Local agricultural-machinery dealer. Tractors, crop implements, harvest, grain and livestock systems. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S076')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S026 SH Family Hardware · 1658 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','SH Family Hardware','SH Family Hardware','SF',
  '+256772518513','+256754981574','+256772518513',null,'kampala',
  'SH Family Hardware — Wholesale and retail hardware. Building, roofing, plumbing, electrical and paint supplies. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S026')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S027 Super Deal Hardware · 1789 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Super Deal Hardware','Super Deal Hardware','SD',
  '+256751999195','+256773307171','+256751999195',null,'kampala',
  'Super Deal Hardware — Local hardware dealer. Tools, sanitaryware, plumbing, paint, steel and electrical goods. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S027')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S028 Give and Take MASE Hardware · 1269 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Give and Take MASE Hardware','Give and Take MASE Hardware','GA',
  '+256393208444','+256780554583','+256393208444','Rubaga Road main branch, Kampala','kampala',
  'Give and Take MASE Hardware — Local hardware supplier. Steel, welding, roofing, tools and construction products. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S028')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S029 Generous Trading & Investment Ltd · 1448 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Generous Trading & Investment Ltd','Generous Trading & Investment Ltd','GT',
  '+256782177960',null,'+256782177960','Kumi Road, Mbale, Uganda','mbale',
  'Generous Trading & Investment Ltd — Local building-material dealer. Construction, hardware, plumbing and electrical supplies. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S029')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S038 Valueware (U) Ltd · 514 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Valueware (U) Ltd','Valueware (U) Ltd','VU',
  '+256775372911','+256701039944','+256775372911','Shop A028, Original Shauriako Plaza, Kampala','kampala',
  'Valueware (U) Ltd — Hardware wholesaler and trade supplier. Power tools, hand tools and safety equipment. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S038')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S033 Steel Force Ltd · 524 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Steel Force Ltd','Steel Force Ltd','SF',
  '+256772302010',null,'+256772302010','Plot 62 Oboja Road, Jinja','jinja',
  'Steel Force Ltd — Wholesale dealer for steel, cement, roofing sheets and decorative/automotive paints. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S033')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S030 IBM Building & Construction Material Supply · 266 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','IBM Building & Construction Material Supply','IBM Building & Construction Material Supply','IB',
  '+256704032414','+256781580278','+256704032414','Kampala, Uganda; confirm collection depot','kampala',
  'IBM Building & Construction Material Supply — Bulk supplier of aggregates, sand, cement, bricks, concrete and other building materials. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S030')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S154 MBS Construction Chemicals Uganda Ltd · 96 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','MBS Construction Chemicals Uganda Ltd','MBS Construction Chemicals Uganda Ltd','MC',
  '+256772767477','+256414347130','+256772767477','1–27 Nasser Lane, Nakasero, Nasser Road, Kampala','kampala',
  'MBS Construction Chemicals Uganda Ltd — Local manufacturer/importer of concrete admixtures, waterproofing, flooring, grouts and sealants. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S154')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S155 Kalanzi Chemical & Constructions (U) Ltd · 76 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Kalanzi Chemical & Constructions (U) Ltd','Kalanzi Chemical & Constructions (U) Ltd','KC',
  '+256780224789','+256703181133','+256780224789','Plot 15/17, 2nd Street, Industrial Area, Kampala','kampala',
  'Kalanzi Chemical & Constructions (U) Ltd — Local distributor of construction chemicals, waterproofing and concrete systems. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S155')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S032 SPL Steel Distributors Co. Ltd · 350 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','SPL Steel Distributors Co. Ltd','SPL Steel Distributors Co. Ltd','SS',
  '+256789171184','+256393236377','+256789171184','Kikapwa Plaza, Erisa Nkoyoyo Road, Kisenyi, Kampala','kampala',
  'SPL Steel Distributors Co. Ltd — Steel wholesaler supplying contractors, manufacturers and hardware retailers. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S032')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S034 Kawotto Clays Ltd · 8 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Kawotto Clays Ltd','Kawotto Clays Ltd','KC',
  '+256772396950','+256701396950','+256772396950','Kajjansi, Kampala–Entebbe Road','kampala',
  'Kawotto Clays Ltd — Local manufacturer of clay roof tiles, facing bricks, maxpans, blocks, floor tiles and pavers. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S034')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S157 Tetrabuild Services Ltd · 60 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Tetrabuild Services Ltd','Tetrabuild Services Ltd','TS',
  '+256776836552','+256393255027','+256776836552','Plot 2209 Kalonda Rise, off Kulambiro Ring Road, Kulambiro, Kampala','kampala',
  'Tetrabuild Services Ltd — Local specialist-material distributor. Waterproofing, membranes, geosynthetics, scaffolding and formwork. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S157')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S156 Starke Polymers · 44 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Starke Polymers','Starke Polymers','SP',
  '+256764202020',null,'+256764202020','Plot 158, Sixth Street, Industrial Area, Kampala','kampala',
  'Starke Polymers — Local construction-chemical manufacturer. Admixtures, grouts, sealants, flooring and waterproofing. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S156')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S081 Erimu Company Ltd · 519 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Erimu Company Ltd','Erimu Company Ltd','EC',
  '+256707956135',null,'+256707956135','Factory: Namagoma, Masaka Road. Showrooms: Jinja Road and Ntinda, Kampala','kampala',
  'Erimu Company Ltd — Local wood-product manufacturer and trader. Doors, frames, boards and home/office furniture. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S081')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S127 Interior Technologies · 177 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Interior Technologies','Interior Technologies','IT',
  '+256414258493',null,'+256414258493','Plot 50 Robert Mugabe Road, Mbuya, Kampala','kampala',
  'Interior Technologies — Local fabricator and fit-out supplier. Ceilings, partitions, flooring, woodwork, blinds and wallpaper. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S127')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S181 Felm Ltd · 37 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Felm Ltd','Felm Ltd','FL',
  '+256752605799','+256777912321','+256752605799','Kitagobwa, Kasangati–Matugga Road, Wakiso','wakiso',
  'Felm Ltd — Local manufacturer of flexible packaging, PE/nonwoven bags, printed labels, DPC rolls and nursery polypots. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S181')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S184 Aquva International Ltd · 158 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Aquva International Ltd','Aquva International Ltd','AI',
  '+256782473730','+256772507908','+256782473730','Shop: Plot 1 Sure House, Bombo Road. Factory: Plot 37–43 Kibira Road, Industrial Area, Kampala','kampala',
  'Aquva International Ltd — Uganda engineering-supplies distributor. Bearings, industrial hardware, welding, tools, abrasives, pipes and insulation. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S184')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S040 Electro Centre Ltd · 510 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Electro Centre Ltd','Electro Centre Ltd','EC',
  '+256702891204',null,'+256702891204','231 Sixth Street, Industrial Area, Kampala','kampala',
  'Electro Centre Ltd — Local electrical supplier and HILTI distributor. Wiring, lighting, protection and professional tools. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S040')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S135 Candela Engineering and Supplies Ltd · 224 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Candela Engineering and Supplies Ltd','Candela Engineering and Supplies Ltd','CE',
  '+256786400160','+256701869182','+256786400160','Local industrial supplier. Bearings, lubricants, transmission spares, tools, PPE and automotive spares. Range lead; exact item and stock unconfirmed.','kampala',
  'Candela Engineering and Supplies Ltd — Local industrial supplier. Bearings, lubricants, transmission spares, tools, PPE and automotive spares. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S135')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S042 FRUX Solutions (U) Ltd · 386 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','FRUX Solutions (U) Ltd','FRUX Solutions (U) Ltd','FS',
  '+256746889178',null,'+256746889178','Industrial electrical and mechanical supplier. Motors, drives, bearings, belts, chains and seals. Range lead; exact item and stock unconfirmed.','kampala',
  'FRUX Solutions (U) Ltd — Industrial electrical and mechanical supplier. Motors, drives, bearings, belts, chains and seals. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S042')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S109 Jaywab Solutions Ltd · 148 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Jaywab Solutions Ltd','Jaywab Solutions Ltd','JS',
  '+256758678090','+256393001235','+256758678090','Allianz Hotels, Ground Floor, Kampala','kampala',
  'Jaywab Solutions Ltd — Specialist safety-wear and PPE supplier with published product prices. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S109')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S035 Kajjansi Brick & Tile Works Ltd · 6 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Kajjansi Brick & Tile Works Ltd','Kajjansi Brick & Tile Works Ltd','KB',
  '+256414200671',null,'+256414200671','Kajjansi, 8 miles Entebbe Road','entebbe',
  'Kajjansi Brick & Tile Works Ltd — Local clay-products manufacturer. Roofing tiles, ridges, bricks, maxpans and floor tiles. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S035')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S037 Tilex Imports Ltd · 4 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Tilex Imports Ltd','Tilex Imports Ltd','TI',
  '+256755168038',null,'+256755168038','Ntinda Complex, 1st Floor Room F19, Ntinda–Nakawa Road, Kampala','kampala',
  'Tilex Imports Ltd — Uganda importer and specialist distributor of Tilcor stone-coated metal roofing tiles. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S037')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S036 Royal Mabati Uganda Ltd · 6 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Royal Mabati Uganda Ltd','Royal Mabati Uganda Ltd','RM',
  '+256702638383','+256784426925','+256702638383','Bombo Road, Kawanda, opposite Safe Drive Uganda, near YAHYA Construction Centre','kampala',
  'Royal Mabati Uganda Ltd — Uganda roofing-sheet manufacturer. Corrugated, box-profile and tile-profile sheets and accessories. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S036')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S126 Amira Interiors Hub · 33 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Amira Interiors Hub','Amira Interiors Hub','AI',
  '+256749040672',null,'+256749040672','Industrial Area, Kampala; confirm street address','kampala',
  'Amira Interiors Hub — Local specialist supplier of PVC wall/ceiling panels and decorative interior materials. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S126')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S128 Timeline Interior and Services · 85 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Timeline Interior and Services','Timeline Interior and Services','TI',
  '+256705619035',null,'+256705619035','8th Street, Industrial Area, Kampala','kampala',
  'Timeline Interior and Services — Local interior supplier and fabricator. Wall panels, gypsum, flooring, ceilings and custom furniture. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S128')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S039 Elektrex Ltd · 337 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Elektrex Ltd','Elektrex Ltd','EL',
  '+256772755966','+256772755988','+256772755966','Plot 91/97, 7th Street, Industrial Area, Kampala','kampala',
  'Elektrex Ltd — Importer and supplier of electrical goods, lighting, distribution and solar equipment. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S039')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S041 Chint Uganda · 409 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Chint Uganda','Chint Uganda','CU',
  '+256392266552','+256393130666','+256392266552','Plot 147–153, 6th Street, Industrial Area, Kampala','kampala',
  'Chint Uganda — Uganda distributor and panel builder. Switchgear, lighting, motors, drives and solar systems. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S041')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S179 Bintech Systems & Supplies Ltd · 246 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Bintech Systems & Supplies Ltd','Bintech Systems & Supplies Ltd','BS',
  '+256749767637',null,'+256749767637','3rd Floor Shree Hari Plaza, Industrial Area, Kampala','kampala',
  'Bintech Systems & Supplies Ltd — Uganda distributor of electrical, sanitaryware and security products. CHINT, Tronic, Jaquar, Matrix and CP Plus ranges. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S179')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S048 Adritex (U) Ltd · 324 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Adritex (U) Ltd','Adritex (U) Ltd','AU',
  '+256414660937',null,'+256414660937','Oxford Station 8A, 7th Street, Industrial Area, Kampala','kampala',
  'Adritex (U) Ltd — Importer of water pumps, irrigation, water-treatment devices, generators and solar equipment. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S048')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S115 TMT Technologies (U) Ltd · 401 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','TMT Technologies (U) Ltd','TMT Technologies (U) Ltd','TT',
  '+256704807111','+256706665283','+256704807111','Plot 30 Soliz Courts, Lumumba Avenue, Nakasero, Kampala','kampala',
  'TMT Technologies (U) Ltd — Local ICT and office-equipment supplier. Computers, copiers, printers, networking and PABX. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S115')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S116 Treasure Plus Company Ltd · 381 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Treasure Plus Company Ltd','Treasure Plus Company Ltd','TP',
  '+256776112454','+256773136946','+256776112454','Plot 37–39, Ntinda, Kampala','kampala',
  'Treasure Plus Company Ltd — Uganda business-hardware distributor. HP, Lenovo and Dell partner. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S116')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S117 Twincom Technologies · 350 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Twincom Technologies','Twincom Technologies','TT',
  '+256782707080','+256759503990','+256782707080','Plot 218 Bobsons Building, Bulindo Road, Kira','kampala',
  'Twincom Technologies — Local ICT equipment supplier and integrator. Computers, servers and network equipment. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S117')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S147 Sarada Technologies Ltd · 326 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Sarada Technologies Ltd','Sarada Technologies Ltd','ST',
  '+256747171717','+256709005925','+256747171717','D’Almeida and Sons Building, Bombo Road, opposite SureHouse, next to Norvik Pharmacy, Kampala','kampala',
  'Sarada Technologies Ltd — Local reseller/installer of CCTV, networking equipment and computer hardware. Bulk terms to confirm. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S147')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S044 Sanpic Electronics · 4 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Sanpic Electronics','Sanpic Electronics','SE',
  '+256750200400','+256705414716','+256750200400','Spring Road, Bugolobi, next to ABSA Bank, Kampala','kampala',
  'Sanpic Electronics — Local appliance dealer. Wholesale/bulk terms need confirmation. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S044')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S045 A&S Electronics Ltd · 4 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','A&S Electronics Ltd','A&S Electronics Ltd','AS',
  '+256414341681','+256776848543','+256414341681','Metropole House, Entebbe Road, next to Kamu Kamu Plaza, Ground Floor G12, Kampala','kampala',
  'A&S Electronics Ltd — Uganda electronics supplier listed for electrical appliances in institutional procurement. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S045')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S153 Neriko Electronics · 12 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Neriko Electronics','Neriko Electronics','NE',
  '+256779319949',null,'+256779319949','Maricah Centrum Building, Rooms A6–7, Nkinzi Road, Wandegeya, Kampala','kampala',
  'Neriko Electronics — Local specialist electronic-components and prototyping supplier; Raspberry Pi reseller. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S153')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S046 Solaraire Ventures Ltd · 77 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Solaraire Ventures Ltd','Solaraire Ventures Ltd','SV',
  '+256740556288','+256709589794','+256740556288','Sir Apollo Kaggwa Road, behind WATU Makerere, Kampala','kampala',
  'Solaraire Ventures Ltd — Uganda wholesale distributor of solar panels, SAKO inverters and lithium batteries. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S046')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S047 Shine Wave Energy · 225 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Shine Wave Energy','Shine Wave Energy','SW',
  '+256200930194','+256743647125','+256200930194','Uganda; confirm street address before visiting','kampala',
  'Shine Wave Energy — Local solar and backup-power supplier. Panels, batteries and inverters. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S047')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S074 National Agro Machinery Ltd · 259 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','National Agro Machinery Ltd','National Agro Machinery Ltd','NA',
  '+256714899933','+256757575750','+256714899933','Plot 12/14/16 Entebbe Road, Kampala','kampala',
  'National Agro Machinery Ltd — Local machinery distributor. Agricultural machines, generators and solar equipment. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S074')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S071 Machine World Uganda · 186 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Machine World Uganda','Machine World Uganda','MW',
  '+256752815403',null,'+256752815403','William Street, Arua Park Plaza, Kampala','kampala',
  'Machine World Uganda — Local dealer in farm machinery, generators and construction equipment. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S071')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S049 Avant-Garde Distributors (U) Ltd · 175 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Avant-Garde Distributors (U) Ltd','Avant-Garde Distributors (U) Ltd','AG',
  '+256752628685','+256783437278','+256752628685','Shop A045, Gate 5, Ground Floor, Original Shauriyako Plaza, Nakivubo Road, Kampala','kampala',
  'Avant-Garde Distributors (U) Ltd — Distributor of water pumps, hoses, plumbing and irrigation fittings and spare parts. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S049')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S051 Clone Supplies Uganda · 233 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Clone Supplies Uganda','Clone Supplies Uganda','CS',
  '+256200934788',null,'+256200934788','Nakasero, Kampala','kampala',
  'Clone Supplies Uganda — Specialist plumbing and sanitaryware supplier. Pipes, fittings, valves and bathroom products. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S051')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S114 NSI Water Uganda · 165 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','NSI Water Uganda','NSI Water Uganda','NW',
  '+256394802101','+256200902158','+256394802101','Penn Station, 7th Street, Industrial Area, Kampala','kampala',
  'NSI Water Uganda — Local supplier of water-treatment equipment, borehole pumps and pool systems. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S114')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S050 Momila General Traders Ltd · 122 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Momila General Traders Ltd','Momila General Traders Ltd','MG',
  '+256758318063','+256758524471','+256758318063','Kampala, Uganda; street not published on source','kampala',
  'Momila General Traders Ltd — Importer and wholesale distributor of sanitaryware, bathroom fittings and kitchen mixers. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S050')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S185 WESDOM / WSD Uganda Team · 46 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','WESDOM / WSD Uganda Team','WESDOM / WSD Uganda Team','WW',
  '+256794949999',null,'+256794949999','Uganda-based valve project-sales team. Confirm local stock and industrial pressure/material ratings. Range lead; exact item and stock unconfirmed.','kampala',
  'WESDOM / WSD Uganda Team — Uganda-based valve project-sales team. Confirm local stock and industrial pressure/material ratings. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S185')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S052 NIM Paints · 170 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','NIM Paints','NIM Paints','NP',
  '+256785275476','+256784523877','+256785275476','Ugandan paint manufacturer. Decorative and industrial coatings. Direct sales contact. Range lead; exact item and stock unconfirmed.','kampala',
  'NIM Paints — Ugandan paint manufacturer. Decorative and industrial coatings. Direct sales contact. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S052')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S053 Monaco Coatings · 170 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Monaco Coatings','Monaco Coatings','MC',
  '+256200982982','+256392852727','+256200982982','Hardware City, Nakasero, Gate 7, Shops 14–16, Kampala','kampala',
  'Monaco Coatings — Uganda paint manufacturer with local branches and a factory outlet. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S053')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S054 Coral Coatings Ltd · 166 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Coral Coatings Ltd','Coral Coatings Ltd','CC',
  '+256779146627','+256759888337','+256779146627','Kireka, Kinawataka Road, Kampala','kampala',
  'Coral Coatings Ltd — Local manufacturer of interior, exterior, textured and emulsion paints. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S054')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S055 Raek Chemicals Ltd · 107 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Raek Chemicals Ltd','Raek Chemicals Ltd','RC',
  '+256778952095',null,'+256778952095','Plot 63, 8th Street, Namuwongo Road, Industrial Area, Kampala','kampala',
  'Raek Chemicals Ltd — Local supplier of paints, primers, wood finishes, thinners, resins and fibreglass materials. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S055')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S056 Mahavir Enterprises Ltd · 40 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Mahavir Enterprises Ltd','Mahavir Enterprises Ltd','ME',
  '+256702534555',null,'+256702534555','Industrial-chemical wholesaler. Cosmetic chemicals, solvents, surfactants, fragrances and flavours. Range lead; exact item and stock unconfirmed.','kampala',
  'Mahavir Enterprises Ltd — Industrial-chemical wholesaler. Cosmetic chemicals, solvents, surfactants, fragrances and flavours. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S056')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S057 Reliance Chemicals Ltd · 135 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Reliance Chemicals Ltd','Reliance Chemicals Ltd','RC',
  '+256759767766',null,'+256759767766','Local industrial-chemical distributor for manufacturing and industrial cleaning. Range lead; exact item and stock unconfirmed.','kampala',
  'Reliance Chemicals Ltd — Local industrial-chemical distributor for manufacturing and industrial cleaning. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S057')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S058 Opera Chemical SMC Ltd · 28 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Opera Chemical SMC Ltd','Opera Chemical SMC Ltd','OC',
  '+256754682121',null,'+256754682121','69, 7th Street, Industrial Area, Kampala','kampala',
  'Opera Chemical SMC Ltd — Chemical distributor. Soap, cosmetics and paint raw materials, acids and solvents. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S058')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S059 SHP Sons Uganda Ltd · 135 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','SHP Sons Uganda Ltd','SHP Sons Uganda Ltd','SS',
  '+256705069001','+256754489602','+256705069001','Local distributor of industrial, cleaning, paint, cosmetic and packaging chemicals. Range lead; exact item and stock unconfirmed.','kampala',
  'SHP Sons Uganda Ltd — Local distributor of industrial, cleaning, paint, cosmetic and packaging chemicals. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S059')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S060 Deep Commodities Ltd · 135 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Deep Commodities Ltd','Deep Commodities Ltd','DC',
  '+256787177476','+256758331002','+256787177476','Local industrial-chemical manufacturer and distributor. Confirm grade and pack size. Range lead; exact item and stock unconfirmed.','kampala',
  'Deep Commodities Ltd — Local industrial-chemical manufacturer and distributor. Confirm grade and pack size. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S060')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S111 KAS Engineering Ltd · 155 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','KAS Engineering Ltd','KAS Engineering Ltd','KE',
  '+256702811121','+256779233916','+256702811121','Plot KR-02 Kimbejja Road, Kyaliwajjala–Namugongo, Kampala','kampala',
  'KAS Engineering Ltd — Local supplier and engineering firm for treatment chemicals and water/wastewater systems. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S111')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S167 Oxygas Ltd · 13 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Oxygas Ltd','Oxygas Ltd','OL',
  '+256755333120','+256752700700','+256755333120','Uganda supplier of industrial gases in cylinders and bulk liquid. Range lead; exact item and stock unconfirmed.','kampala',
  'Oxygas Ltd — Uganda supplier of industrial gases in cylinders and bulk liquid. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S167')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S168 Indo-Gas Uganda Ltd · 9 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Indo-Gas Uganda Ltd','Indo-Gas Uganda Ltd','IG',
  '+256704973837','+256763141695','+256704973837','Local industrial/medical-gas supplier, with gas accessories and safety equipment. Range lead; exact item and stock unconfirmed.','kampala',
  'Indo-Gas Uganda Ltd — Local industrial/medical-gas supplier, with gas accessories and safety equipment. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S168')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S169 Ebenezer Gas Supplies Ltd · 6 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Ebenezer Gas Supplies Ltd','Ebenezer Gas Supplies Ltd','EG',
  '+256778640748','+256751263596','+256778640748','Local industrial and medical gas supplier offering bulk-order delivery. Range lead; exact item and stock unconfirmed.','kampala',
  'Ebenezer Gas Supplies Ltd — Local industrial and medical gas supplier offering bulk-order delivery. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S169')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S170 Conch Gas Ltd · 6 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Conch Gas Ltd','Conch Gas Ltd','CG',
  '+256776500786','+256703978198','+256776500786','Uganda supplier of industrial gases, LPG, refrigerants, grease and gas accessories. Range lead; exact item and stock unconfirmed.','kampala',
  'Conch Gas Ltd — Uganda supplier of industrial gases, LPG, refrigerants, grease and gas accessories. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S170')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S065 Rabbicare Motorcycle Accessories · 34 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Rabbicare Motorcycle Accessories','Rabbicare Motorcycle Accessories','RM',
  '+256775066426','+256755452527','+256775066426','Gulu City, Uganda; confirm street address','gulu',
  'Rabbicare Motorcycle Accessories — Direct importer and wholesale distributor of Bajaj motorcycle parts. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S065')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S175 Baninvest Ltd · 296 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Baninvest Ltd','Baninvest Ltd','BL',
  '+256772500220','+256757915111','+256772500220','Mengo Hill Road, Kampala','kampala',
  'Baninvest Ltd — Uganda bulk importer/dealer of European and Chinese truck and trailer spare parts. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S175')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S176 ALIDAM Heavy Parts · 293 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','ALIDAM Heavy Parts','ALIDAM Heavy Parts','AH',
  '+256779898495',null,'+256779898495','Sedona Complex, Rashid Khamis Road, Kampala','kampala',
  'ALIDAM Heavy Parts — Uganda wholesaler/retailer of heavy-equipment spares, tyres, filters, hydraulic seals and diesel engine components. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S176')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S061 AutoTech UG · 296 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','AutoTech UG','AutoTech UG','AU',
  '+256757169673','+256757469374','+256757169673','Kampala, Uganda; street not published on source','kampala',
  'AutoTech UG — Independent auto-parts dealer. Japanese/European engine, brake, suspension and electrical parts. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S061')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S062 Autotune & Engineering · 296 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Autotune & Engineering','Autotune & Engineering','AE',
  '+256751343990','+256393215555','+256751343990','Plot 24 Dewinton Road, Kampala','kampala',
  'Autotune & Engineering — Local automotive workshop and spare-parts stockist. Japanese and other vehicle brands. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S062')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S174 JES Autos · 289 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','JES Autos','JES Autos','JA',
  '+256742306500',null,'+256742306500','Kampala, Uganda; confirm street address','kampala',
  'JES Autos — Independent Uganda dealer for European vehicle spare parts. Confirm vehicle compatibility and bulk terms. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S174')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S063 Mandela Auto Spares Ltd · 229 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Mandela Auto Spares Ltd','Mandela Auto Spares Ltd','MA',
  '+256414235090','+256392735115','+256414235090','Plot 20/1 Ben Kiwanuka Street, Kampala','kampala',
  'Mandela Auto Spares Ltd — Uganda spare-parts distributor with a dedicated spares sales line. Confirm vehicle compatibility. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S063')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S064 KenPenz Auto Shop · 43 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','KenPenz Auto Shop','KenPenz Auto Shop','KA',
  '+256702680945',null,'+256702680945','Kiseka Market Business Center, Building T97, Kampala','kampala',
  'KenPenz Auto Shop — Independent auto-parts shop specialising in lamps, body parts, oils and additives. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S064')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S066 Yoshino Trading · 66 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Yoshino Trading','Yoshino Trading','YT',
  '+256706663101','+256777049069','+256706663101','Kampala, Uganda; confirm current vehicle yard','kampala',
  'Yoshino Trading — Uganda used-car and truck dealer with direct WhatsApp sales contacts. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S066')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S067 Driven Deals Ltd · 66 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Driven Deals Ltd','Driven Deals Ltd','DD',
  '+256773921342',null,'+256773921342','Kampala, Uganda; street not published on source','kampala',
  'Driven Deals Ltd — Independent Uganda vehicle dealer. Confirm model, year, duty status and current stock. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S067')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S068 Spear Motors Ltd · 66 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Spear Motors Ltd','Spear Motors Ltd','SM',
  '+256783614601','+256753614601','+256783614601','Uganda; confirm Kampala showroom before visiting','kampala',
  'Spear Motors Ltd — Uganda vehicle distributor with direct sales mobiles. Cars, vans and commercial trucks. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S068')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S070 Motorcare Uganda · 60 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Motorcare Uganda','Motorcare Uganda','MU',
  '+256772200012','+256312238100','+256772200012','Plot 95 Jinja Road, Kampala','kampala',
  'Motorcare Uganda — Uganda vehicle distributor. Nissan, Ford and Hyundai sales and parts support. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S070')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S069 Double Q / Hanlink Uganda · 48 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Double Q / Hanlink Uganda','Double Q / Hanlink Uganda','DQ',
  '+256708808888','+256780988888','+256708808888','Plot 414 Kasumba Square, Busega, Kampala','kampala',
  'Double Q / Hanlink Uganda — Uganda distributor of Sinotruk, HELI and XCMG vehicles and equipment. Local sales contacts. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S069')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S077 Victoria Equipment Ltd · 74 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Victoria Equipment Ltd','Victoria Equipment Ltd','VE',
  '+256770834765','+256414256025','+256770834765','Uganda equipment distributor. Earthmoving, compaction, drilling, quarry and road machinery. Range lead; exact item and stock unconfirmed.','kampala',
  'Victoria Equipment Ltd — Uganda equipment distributor. Earthmoving, compaction, drilling, quarry and road machinery. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S077')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S079 Achelis Uganda Ltd · 28 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Achelis Uganda Ltd','Achelis Uganda Ltd','AU',
  '+256747036199','+256200800500','+256747036199','Local industrial-equipment distributor with sales and technical support. Range lead; exact item and stock unconfirmed.','kampala',
  'Achelis Uganda Ltd — Local industrial-equipment distributor with sales and technical support. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S079')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S132 F&B Solutions Ltd · 496 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','F&B Solutions Ltd','F&B Solutions Ltd','FB',
  '+256782935776','+256753564364','+256782935776','6th Street, Industrial Area, between Exim Bank and City Tyres, Kampala','kampala',
  'F&B Solutions Ltd — Uganda machinery distributor. Food processing, filling, sealing, coding, wrapping and water-treatment plants. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S132')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S133 Musa Body Machinery (U) Ltd · 61 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Musa Body Machinery (U) Ltd','Musa Body Machinery (U) Ltd','MB',
  '+256707888101','+256707888109','+256707888101','Musa Body Building, Plot 1080 Katwe–Mutesa I Road, Kampala','kampala',
  'Musa Body Machinery (U) Ltd — Local agro-processing machinery fabricator/dealer. Historical KCCA directory contact; reconfirm trading status. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S133')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S172 Industrial Machines Uganda · 284 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Industrial Machines Uganda','Industrial Machines Uganda','IM',
  '+256744444077','+256200934407','+256744444077','Local industrial-equipment supplier. Agro-processing, packaging, bottling and auxiliary equipment. Range lead; exact item and stock unconfirmed.','kampala',
  'Industrial Machines Uganda — Local industrial-equipment supplier. Agro-processing, packaging, bottling and auxiliary equipment. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S172')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S131 Dynamic Machinery Ltd · 94 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Dynamic Machinery Ltd','Dynamic Machinery Ltd','DM',
  '+256772967552','+256200998102','+256772967552','Local industrial-parts supplier. Bearings, linear motion, oil seals, chains and power transmission. Range lead; exact item and stock unconfirmed.','kampala',
  'Dynamic Machinery Ltd — Local industrial-parts supplier. Bearings, linear motion, oil seals, chains and power transmission. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S131')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S134 East African Chains (U) Ltd · 91 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','East African Chains (U) Ltd','East African Chains (U) Ltd','EA',
  '+256200960426',null,'+256200960426','Plot 87, 1st Street, Kampala','kampala',
  'East African Chains (U) Ltd — Uganda branch supplying industrial transmission, conveying, lifting, lubrication, sealing and pumping products. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S134')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S072 Amani Victoria · 44 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Amani Victoria','Amani Victoria','AV',
  '+256769686287',null,'+256769686287','Kampala, Uganda; street not published on source','kampala',
  'Amani Victoria — Specialist equipment distributor. Compressors, optical sorting and coffee-processing machinery. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S072')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S129 Eagle Weighing Systems · 51 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Eagle Weighing Systems','Eagle Weighing Systems','EW',
  '+256700225423','+256787089315','+256700225423','University Plaza, Wandegeya, opposite Reeve House, Bombo Road, Kampala','kampala',
  'Eagle Weighing Systems — Uganda supplier of weighing and packaging equipment, including heat sealers and bag sealers. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S129')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S078 Kijoora Investments Ltd · 22 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Kijoora Investments Ltd','Kijoora Investments Ltd','KI',
  '+256755268389','+256776931796','+256755268389',null,'kampala',
  'Kijoora Investments Ltd — Independent dealer in heavy construction equipment, with sales, leasing and parts support. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S078')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S080 Fujian Industries Park Ltd · 502 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Fujian Industries Park Ltd','Fujian Industries Park Ltd','FI',
  '+256708359999','+256783599999','+256708359999',null,'kampala',
  'Fujian Industries Park Ltd — Local furniture manufacturer and wholesaler. Home, office, outdoor and metal furniture. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S080')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S082 Topwood SMC Ltd · 473 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Topwood SMC Ltd','Topwood SMC Ltd','TS',
  '+256774641271','+256784419054','+256774641271','Kampala, Uganda; workshop address to confirm','kampala',
  'Topwood SMC Ltd — Local manufacturer of bespoke fitted wood furniture for homes and offices. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S082')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S083 Prompt Supply 2011 · 784 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Prompt Supply 2011','Prompt Supply 2011','PS',
  '+256741240791','+256707481438','+256741240791','Vindax Plaza, Plot 172/174, Sixth Street, Kampala','kampala',
  'Prompt Supply 2011 — Uganda furniture manufacturer and bulk stationery distributor for institutions and businesses. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S083')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S084 Pinnacle Concepts Ltd · 453 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Pinnacle Concepts Ltd','Pinnacle Concepts Ltd','PC',
  '+256776497329','+256701497329','+256776497329','Pinnacle House, Plot 1075 Farm Road, Kyambogo, next to Trinity Hostel','kampala',
  'Pinnacle Concepts Ltd — Local home/office furniture supplier, with custom products, curtains and blinds. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S084')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S085 Faiba Furniture Enterprises · 201 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Faiba Furniture Enterprises','Faiba Furniture Enterprises','FF',
  '+256705579978','+256782962928','+256705579978','Arua Park, Nyumba Kubwa, Kampala','kampala',
  'Faiba Furniture Enterprises — Local office-furniture supplier providing custom chairs, tables and workspaces. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S085')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S089 Jimmy Brian Garments Co-SMC Ltd · 62 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Jimmy Brian Garments Co-SMC Ltd','Jimmy Brian Garments Co-SMC Ltd','JB',
  '+256782757845',null,'+256782757845','Nabukera Plaza H32, Nabugabo Street, Kampala','kampala',
  'Jimmy Brian Garments Co-SMC Ltd — Importer and wholesaler of menswear, suits and textile fabrics. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S089')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S090 Uganda Rosely Hometextile Manufacture Factory Ltd · 14 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Uganda Rosely Hometextile Manufacture Factory Ltd','Uganda Rosely Hometextile Manufacture Factory Ltd','UR',
  '+256701219539',null,'+256701219539','Plot 26 William Street, Kampala','kampala',
  'Uganda Rosely Hometextile Manufacture Factory Ltd — Local textiles and garments manufacturer. Directory contact. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S090')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S150 Waynah Textiles · 14 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Waynah Textiles','Waynah Textiles','WT',
  '+256200999671',null,'+256200999671','Ham Shopping Grounds, Block S, Shop S-360/351, Kisenyi II, Nakivubo Road, Kampala','kampala',
  'Waynah Textiles — Local fabric wholesaler supplying garment makers and retailers. Crepe, knitted, satin and textured fabrics. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S150')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S151 Fine Spinners Uganda Ltd · 30 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Fine Spinners Uganda Ltd','Fine Spinners Uganda Ltd','FS',
  '+256414342716',null,'+256414342716','Spring Road, Kiswa Zone, Bugolobi, Kampala','kampala',
  'Fine Spinners Uganda Ltd — Uganda cotton textile and garment manufacturer with integrated spinning, knitting, weaving and sewing. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S151')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S086 BP Royal Uganda Ltd · 64 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','BP Royal Uganda Ltd','BP Royal Uganda Ltd','BR',
  '+256773273991','+256414255808','+256773273991',null,'kampala',
  'BP Royal Uganda Ltd — Local manufacturer of uniforms, corporate/workwear and protective clothing, with embroidery. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S086')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S087 Uganda Uniform Manufacturers & Distributors Ltd · 64 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Uganda Uniform Manufacturers & Distributors Ltd','Uganda Uniform Manufacturers & Distributors Ltd','UU',
  '+256772848727','+256414342871','+256772848727','Plot 20/23 Nkrumah Road, Property House, Kampala','kampala',
  'Uganda Uniform Manufacturers & Distributors Ltd — Local uniform and garment manufacturer/distributor. Directory contact. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S087')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S088 Unique Uniform Manufacturers (U) Ltd · 64 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Unique Uniform Manufacturers (U) Ltd','Unique Uniform Manufacturers (U) Ltd','UU',
  '+256772618372','+256414234965','+256772618372','Plot 10 Kampala Road, Uganda House, Shop 13, Kampala','kampala',
  'Unique Uniform Manufacturers (U) Ltd — Local uniform and garment manufacturer. Directory contact. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S088')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S091 Krypt Investments Ltd · 117 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Krypt Investments Ltd','Krypt Investments Ltd','KI',
  '+256772316316','+256777726363','+256772316316','Kampala, Uganda; street not published on source','kampala',
  'Krypt Investments Ltd — Local manufacturer supplying cleaning, hygiene and medical products in bulk. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S091')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S092 Unique Soap Manufacturers (U) Ltd · 117 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Unique Soap Manufacturers (U) Ltd','Unique Soap Manufacturers (U) Ltd','US',
  '+256774829560','+256702829560','+256774829560','Kawempe Kulumba Zone, Kampala','kampala',
  'Unique Soap Manufacturers (U) Ltd — Ugandan manufacturer of soap and cleaning detergents for institutional and wholesale buyers. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S092')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S093 Visionneuse Enterprises Ltd · 117 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Visionneuse Enterprises Ltd','Visionneuse Enterprises Ltd','VE',
  '+256702050359','+256782050349','+256702050359','Seroma Shoppers Mall, Kampala','kampala',
  'Visionneuse Enterprises Ltd — Local manufacturer of personal-care products, soaps, detergents and chemical solutions. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S093')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S094 Safety 360 Ltd · 117 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Safety 360 Ltd','Safety 360 Ltd','SL',
  '+256781506634','+256708486998','+256781506634','Plot 4 Kiwana Road, Bukoto, Kampala','kampala',
  'Safety 360 Ltd — Ugandan manufacturer of cleaning products for commercial and institutional users. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S094')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S144 Notable Supplies Ltd · 85 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Notable Supplies Ltd','Notable Supplies Ltd','NS',
  '+256705226314','+256776112454','+256705226314','Plot 37–39, Ntinda, Kampala','kampala',
  'Notable Supplies Ltd — Local institutional supplier of janitorial equipment, dispensers, tissue, cleaning consumables and waste bins. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S144')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S173 KNAR Ltd · 63 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','KNAR Ltd','KNAR Ltd','KL',
  '+256393249328',null,'+256393249328','Plot 100 Mutesa II Road, Ntinda, Kampala','kampala',
  'KNAR Ltd — Local distributor of professional cleaning systems and equipment. Directory contact. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S173')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S095 DAAF World Services Ltd · 434 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','DAAF World Services Ltd','DAAF World Services Ltd','DW',
  '+256700767839','+256782742314','+256700767839','Khatija Towers, Bombo Road, Wandegeya, Kampala','kampala',
  'DAAF World Services Ltd — Importer and wholesaler of medical/surgical products, rehabilitation aids and lab equipment. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S095')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S096 Full Health and Home Care · 319 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Full Health and Home Care','Full Health and Home Care','FH',
  '+256758778867','+256701603444','+256758778867','Uganda; confirm Kampala office address','kampala',
  'Full Health and Home Care — Uganda supplier of medical equipment, surgical products and laboratory consumables. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S096')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S097 Mu Pharma Co SMC Ltd · 280 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Mu Pharma Co SMC Ltd','Mu Pharma Co SMC Ltd','MP',
  '+256777666725',null,'+256777666725','Bombo Road, opposite Kobil fuel station, Kampala','kampala',
  'Mu Pharma Co SMC Ltd — Uganda importer and wholesaler of medical equipment, surgical tools and sundries. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S097')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S098 Labtech Medical Supplies · 642 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Labtech Medical Supplies','Labtech Medical Supplies','LM',
  '+256749000477','+256393194179','+256749000477','Plot 80 Ben Kiwanuka Street, Kampala','kampala',
  'Labtech Medical Supplies — Local distributor of medical/laboratory equipment, consumables, diagnostics, PPE and dental supplies. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S098')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S124 Laboratory World Ltd · 371 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Laboratory World Ltd','Laboratory World Ltd','LW',
  '+256700272866','+256702149840','+256700272866','Sunset Arcade, Wilson Road, 2nd Floor Room 18, Kampala','kampala',
  'Laboratory World Ltd — Local distributor of laboratory equipment, diagnostic reagents and hospital consumables. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S124')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S099 A One Manufacturing Industry Ltd · 408 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','A One Manufacturing Industry Ltd','A One Manufacturing Industry Ltd','AO',
  '+256772486858','+256769330201','+256772486858','A One Plaza, Nasser Road, Kampala. Office: Plot 1814 Mawanda Road','kampala',
  'A One Manufacturing Industry Ltd — Local stationery manufacturer and wholesaler. Paper, books, classroom and office supplies. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S099')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S100 Shreeji Stationers Uganda Ltd · 408 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Shreeji Stationers Uganda Ltd','Shreeji Stationers Uganda Ltd','SS',
  '+256707556677','+256707223333','+256707556677','Plot 51/53 Nasser Road, opposite MTK Building, Kampala','kampala',
  'Shreeji Stationers Uganda Ltd — Local stationery manufacturer and wholesaler. School and office stationery and paper. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S100')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S101 Nile Education Company Ltd · 399 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Nile Education Company Ltd','Nile Education Company Ltd','NE',
  '+256751648878','+256780950970','+256751648878','Uganda; confirm Kampala shop address','kampala',
  'Nile Education Company Ltd — Ugandan manufacturer and wholesale distributor of school and office supplies. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S101')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S102 Sai Office Uganda · 399 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Sai Office Uganda','Sai Office Uganda','SO',
  '+256740039342','+256414251516','+256740039342','Plot 213 & 64 Meera Close, 6th Street Industrial Area, Kampala','kampala',
  'Sai Office Uganda — Local distributor of branded stationery, filing, desk accessories and presentation products. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S102')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S105 Modern Laminates Ltd · 55 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Modern Laminates Ltd','Modern Laminates Ltd','ML',
  '+256750165867',null,'+256750165867','Jinja manufacturer of kraft paper and paperboard for boxes, cartons and bags. Range lead; exact item and stock unconfirmed.','jinja',
  'Modern Laminates Ltd — Jinja manufacturer of kraft paper and paperboard for boxes, cartons and bags. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S105')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S103 Nile Plastic Industries Ltd · 121 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Nile Plastic Industries Ltd','Nile Plastic Industries Ltd','NP',
  '+256312263534','+256414271070','+256312263534','Plot 24 Walusimbi Mpanga Road, Nalukolongo, Masaka Road, Kampala','kampala',
  'Nile Plastic Industries Ltd — Local manufacturer of plastic bags, wrapping films and food-packaging products. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S103')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S106 Makap Uganda Ltd · 121 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Makap Uganda Ltd','Makap Uganda Ltd','MU',
  '+256740155004',null,'+256740155004','Block 44 Plot 91, Gonve, Nsanja Parish. Factory: Katosi, Mukono','mukono',
  'Makap Uganda Ltd — Local flexible-plastic packaging manufacturer supplying films, bags and sleeves. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S106')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S141 Amazon Concepts Uganda Ltd · 101 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Amazon Concepts Uganda Ltd','Amazon Concepts Uganda Ltd','AC',
  '+256784679761','+256703502344','+256784679761','Wandegeya Market, South Wing, Level 2, Room 176, Kampala','kampala',
  'Amazon Concepts Uganda Ltd — Local wholesaler of bags, sacks, food wrapping, printed packaging and cartons. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S141')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S180 Blitz Packaging Ltd · 97 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Blitz Packaging Ltd','Blitz Packaging Ltd','BP',
  '+256756958995',null,'+256756958995','Plot 20–22 Nalukolongo Ring Road, Kampala','kampala',
  'Blitz Packaging Ltd — Local flexible-packaging manufacturer. Bags, milk/yoghurt pouches, films, wrappers and liners. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S180')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S171 AGRITRADE Uganda / BOGRAJE AGRITRADE Ltd · 293 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','AGRITRADE Uganda / BOGRAJE AGRITRADE Ltd','AGRITRADE Uganda / BOGRAJE AGRITRADE Ltd','AU',
  '+256392134343','+256792914325','+256392134343','Plot 1643 Valley Road, Ntinda Kigowa, Kampala','kampala',
  'AGRITRADE Uganda / BOGRAJE AGRITRADE Ltd — Uganda sourcing/import supplier of packaging materials and filling, sealing, wrapping, coding and weighing equipment. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S171')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S142 Vistara Cartons · 49 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Vistara Cartons','Vistara Cartons','VC',
  '+256751152562',null,'+256751152562','Plot 17A/17B, Shop NS-4, Nasser Road, Kampala','kampala',
  'Vistara Cartons — Local manufacturer/supplier of custom cartons, paper bags and paper plates. UMA trade-fair directory contact. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S142')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S138 Nabukka Plastics Industries · 37 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Nabukka Plastics Industries','Nabukka Plastics Industries','NP',
  '+256772440815','+256702440815','+256772440815','Bweyogerere–Namanve, off Jinja Road, Kazinga Zone, Mukono','mukono',
  'Nabukka Plastics Industries — Local manufacturer of plastic bottles, cosmetic containers, spray containers and jerrycans. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S138')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S139 Bfresh Packaging Solutions · 37 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Bfresh Packaging Solutions','Bfresh Packaging Solutions','BP',
  '+256756710197','+256782498715','+256756710197','L1-23 Mabirizi Complex, Kampala Road, Kampala','kampala',
  'Bfresh Packaging Solutions — Local wholesale distributor of cosmetic packaging: glass bottles, jars, pumps, droppers and tubes. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S139')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S140 PACKIT Packaging · 42 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','PACKIT Packaging','PACKIT Packaging','PP',
  '+256769473614',null,'+256769473614',null,'kampala',
  'PACKIT Packaging — Ugandan bulk packaging supplier. Published MOQ of 1,000 pieces for listed jars, bottles, small buckets and jerrycans. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S140')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S104 Prime Concepts Packaging · 44 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Prime Concepts Packaging','Prime Concepts Packaging','PC',
  '+256709706156','+256787021110','+256709706156','86 Mutunda, Nkwakwa Road, Bbuto, Bweyogerere','kampala',
  'Prime Concepts Packaging — Local manufacturer of corrugated cartons and egg trays. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S104')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S182 Makss Packaging Industries Ltd · 77 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Makss Packaging Industries Ltd','Makss Packaging Industries Ltd','MP',
  '+256701349936','+256758122133','+256701349936','Plot 41 Mukabya Close, Nakasero Industrial Area, Kampala','kampala',
  'Makss Packaging Industries Ltd — Local carton manufacturer and packaging-system dealer. Strapping rolls, tools, machines, tapes and spares. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S182')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S183 Statpack Uganda Ltd · 187 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Statpack Uganda Ltd','Statpack Uganda Ltd','SU',
  '+256757345228','+256709753754','+256757345228','Plot 140, Sixth Street, Industrial Area, Kampala','kampala',
  'Statpack Uganda Ltd — Uganda-based packaging distributor. Tapes, films, strapping, wrapping/sealing machines, coding and conveyors. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S183')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S107 Gawam Industries · 8 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Gawam Industries','Gawam Industries','GI',
  '+256200911497',null,'+256200911497','Plot 1042 Block 33, Mutundwe Kiyimba Road, Nalukolongo Industrial Area, Kampala','kampala',
  'Gawam Industries — Uganda packaging manufacturer. ABLE foil, cling film, sealing and masking tapes. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S107')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S108 Safequip Safety Company Ltd · 206 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Safequip Safety Company Ltd','Safequip Safety Company Ltd','SS',
  '+256756926140','+256776926140','+256756926140','Lico Holdings Building, Floor 2 Shop B22, Kireka Trading Centre, opposite Shell, Namugongo Road','kampala',
  'Safequip Safety Company Ltd — Specialist PPE and workwear supplier serving businesses and resellers. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S108')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S110 Rennes Solutions Ltd · 142 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Rennes Solutions Ltd','Rennes Solutions Ltd','RS',
  '+256780329457',null,'+256780329457','Uganda; confirm Kampala office address','kampala',
  'Rennes Solutions Ltd — Local institutional supplier of PPE, fire safety, site signage and office supplies. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S110')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S112 Aquadrop Water Solutions Ltd · 143 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Aquadrop Water Solutions Ltd','Aquadrop Water Solutions Ltd','AW',
  '+256706910402','+256200909200','+256706910402','Plot 74 Kanjokya Street, Kampala','kampala',
  'Aquadrop Water Solutions Ltd — Uganda-based engineering office supplying water and sewage treatment equipment and chemicals. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S112')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S113 Aqua Solutions International Ltd · 164 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Aqua Solutions International Ltd','Aqua Solutions International Ltd','AS',
  '+256772606898','+256751121286','+256772606898','Mbogo Road, Kampala; confirm premises before visiting','kampala',
  'Aqua Solutions International Ltd — Uganda supplier of water-treatment and water-testing products. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S113')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S152 Hydraulic and Sanitation Consult Ltd (HYDSAN) · 51 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Hydraulic and Sanitation Consult Ltd (HYDSAN)','Hydraulic and Sanitation Consult Ltd (HYDSAN)','HA',
  '+256772434822','+256752434822','+256772434822','Plot 205 Block 219, Margherita Close, Najeera 2, Kira Municipality','kampala',
  'Hydraulic and Sanitation Consult Ltd (HYDSAN) — Ugandan water/wastewater engineering supplier. Treatment plants, shredders, separators and compost systems. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S152')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S148 Othee Technologies Co Ltd · 275 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Othee Technologies Co Ltd','Othee Technologies Co Ltd','OT',
  '+256394896840',null,'+256394896840','Kampala, Uganda; confirm office street address','kampala',
  'Othee Technologies Co Ltd — Local technology integrator and hardware supplier. Networking, telecom, CCTV, access control and Starlink. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S148')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S122 Security Shark · 424 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Security Shark','Security Shark','SS',
  '+256706188199',null,'+256706188199','Uganda; confirm Kampala sales-office address','kampala',
  'Security Shark — Local security supplier serving installers and distributors. CCTV, access, alarms and networking. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S122')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S178 KIBS Systems Ltd · 195 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','KIBS Systems Ltd','KIBS Systems Ltd','KS',
  '+256706791125','+256393114905','+256706791125','1st Floor Koli House, Ntinda–Kiwatule Road, Kampala','kampala',
  'KIBS Systems Ltd — Local electronic-security supplier/integrator. CCTV, alarms, gates, electric fencing, access control and PABX. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S178')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S118 Cresco Supplies Ltd · 161 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Cresco Supplies Ltd','Cresco Supplies Ltd','CS',
  '+256755501118',null,'+256755501118','Aha Towers, 4th Floor, Plot 7 Lourdel Road, Nakasero, Kampala','kampala',
  'Cresco Supplies Ltd — Specialist supplier of commercial kitchens, laundries, hotel linen, crockery and hospitality supplies. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S118')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S119 Mwonjo Commercial Equipment · 161 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Mwonjo Commercial Equipment','Mwonjo Commercial Equipment','MC',
  '+256784690421',null,'+256784690421','Silva Arcade, opposite YMCA, Kampala','kampala',
  'Mwonjo Commercial Equipment — Local manufacturer/fabricator and supplier of commercial kitchen and stainless-steel equipment. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S119')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S145 Kitchen Kingz Fabrication Company Ltd · 121 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Kitchen Kingz Fabrication Company Ltd','Kitchen Kingz Fabrication Company Ltd','KK',
  '+256780884736','+256709837829','+256780884736','Bweyogerere workshop, Wakiso. Mbuya contact office, Kampala; confirm collection site','kampala',
  'Kitchen Kingz Fabrication Company Ltd — Local fabricator/importer of commercial kitchen tables, sinks, hoods, shelving, ranges, bakery equipment and refrigeration. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S145')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S146 House of Stainless Ltd · 156 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','House of Stainless Ltd','House of Stainless Ltd','HO',
  '+256701440056',null,'+256701440056','Katwe, Kampala','kampala',
  'House of Stainless Ltd — Local manufacturer and wholesaler of commercial kitchen, bakery, refrigeration and stainless-steel equipment. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S146')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S043 ADH Group Uganda Ltd · 61 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','ADH Group Uganda Ltd','ADH Group Uganda Ltd','AG',
  '+256757148823','+256704031444','+256757148823','Weraga Road, Ndeeba, Kampala','kampala',
  'ADH Group Uganda Ltd — Importer and wholesaler of home, solar and commercial kitchen appliances. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S043')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S120 Kangaroo Enterprises Ltd · 291 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Kangaroo Enterprises Ltd','Kangaroo Enterprises Ltd','KE',
  '+256776285537',null,'+256776285537','Silver Arcade, Room 3, Plot 62 Bombo Road, opposite YMCA, Kampala','kampala',
  'Kangaroo Enterprises Ltd — Uganda security-product distributor. CCTV, metal detectors, trackers, alarms and access systems. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S120')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S121 Proxima Solutions Uganda · 291 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Proxima Solutions Uganda','Proxima Solutions Uganda','PS',
  '+256200998085','+256762350784','+256200998085','Suite MCG09, Mirage Complex, Port Bell Road, Bugolobi, Kampala','kampala',
  'Proxima Solutions Uganda — Local security and telematics supplier. CCTV, access control, tracking and gate automation. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S121')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S177 Watch-Point Systems (U) Ltd · 211 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Watch-Point Systems (U) Ltd','Watch-Point Systems (U) Ltd','WP',
  '+256200926348','+256772078651','+256200926348','Plot 38 Kampala Road, Kampala','kampala',
  'Watch-Point Systems (U) Ltd — Local supplier/installer of CCTV, access control, biometric attendance, alarms and fire systems. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S177')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S123 Science Logistics Ltd · 251 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Science Logistics Ltd','Science Logistics Ltd','SL',
  '+256393206314',null,'+256393206314','Plot 1274 Kinyolo Road, Muyenga, Kampala','kampala',
  'Science Logistics Ltd — Uganda laboratory supplier. Instruments, analytical chemicals, reagents and consumables. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S123')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S125 Livan Lab Supplies Uganda Ltd · 251 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Livan Lab Supplies Uganda Ltd','Livan Lab Supplies Uganda Ltd','LL',
  '+256772248260',null,'+256772248260','B8, Ivory Plaza, Wilson Road, Kampala','kampala',
  'Livan Lab Supplies Uganda Ltd — Local distributor of laboratory equipment, diagnostic analysers, reagents and consumables. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S125')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S130 Accurate Weighing Scales Ltd · 10 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Accurate Weighing Scales Ltd','Accurate Weighing Scales Ltd','AW',
  '+256785462212','+256703172505','+256785462212','Local supplier of industrial/commercial scales, bag-stitching and closing machines. Range lead; exact item and stock unconfirmed.','kampala',
  'Accurate Weighing Scales Ltd — Local supplier of industrial/commercial scales, bag-stitching and closing machines. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S130')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- S136 KAS Holdings Ltd · 6 products
insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','KAS Holdings Ltd','KAS Holdings Ltd','KH',
  '+256753360164','+256772614622','+256753360164','Local bulk supplier of high-pressure hydraulic hoses, industrial hoses, fittings and crimping services. Range lead; exact item and stock unconfirmed.','kampala',
  'KAS Holdings Ltd — Local bulk supplier of high-pressure hydraulic hoses, industrial hoses, fittings and crimping services. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S136')
on conflict (import_code) do update set
  company=excluded.company, phone=coalesce(accounts.phone,excluded.phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

-- Verification queue: pending, not verified.
insert into account_registration (account_id, overall_state)
select id, 'pending' from accounts where import_source = 'uganda-b2b'
on conflict (account_id) do nothing;

commit;

notify pgrst, 'reload schema';

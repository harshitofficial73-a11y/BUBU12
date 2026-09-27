-- Carbon platform · suppliers from the Extra Research workbook
--
-- 208 suppliers, of which 140 were already imported by 0058 — the supplier
-- codes are consistent across both workbooks, which I verified: all 140 shared
-- codes name the same company in both. So this UPDATES those and inserts the
-- 68 that are new, rather than creating near-duplicates.
--
-- Profiles only, no logins. Safe to re-run.

begin;

alter table accounts add column if not exists import_code text;
create unique index if not exists accounts_import_code_key
  on accounts (import_code) where import_code is not null;

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Mega Holdings Uganda Ltd','Mega Holdings Uganda Ltd','MH',
  '+256782339421','+256703339421','+256782339421','Plot 15 Martyrs Way, Ministers Village, Ntinda, Kampala','kampala',
  'Mega Holdings Uganda Ltd — Grain processor and bulk trader. Cereals, pulses, sesame, groundnuts and cassava. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S002')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','GKFOODS Ltd','GKFOODS Ltd','GL',
  '+256709763124','+256766528493','+256709763124','Plot 22/24 Semawatta Road, Ntinda, Kampala. Factory: Busesa, Bugweri','kampala',
  'GKFOODS Ltd — Local miller supplying rice and grain foods to bulk and institutional buyers. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S003')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Ugagrains Ltd','Ugagrains Ltd','UL',
  '+256758824824','+256772755824','+256758824824','Plot 10 Naguru Drive, Kampala','kampala',
  'Ugagrains Ltd — Processor and bulk trader of cereals and pulses. Directory contact. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S005')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Nutrofeed Uganda','Nutrofeed Uganda','NU',
  '+256772615553','+256701615553','+256772615553','Kampala, Uganda; confirm street address','kampala',
  'Nutrofeed Uganda — Local wholesale and institutional food supplier: cereals, rice, pasta, poultry, fresh fruit and vegetables. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S190')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Super Agro Food Industries Ltd','Super Agro Food Industries Ltd','SA',
  '+256751240980','+256759643536','+256751240980','Block 197, Plot 544, Hoima Road, Wakiso; outlet at Mukwano Mall, Rashid Khamis Road, Old Kampala','kampala',
  'Super Agro Food Industries Ltd — Uganda food processor and spice exporter; rice, spices, masalas, pulses and flour products. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S206')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Bwengye Millers','Bwengye Millers','BM',
  '+256771404275','+256757088722','+256771404275','Plot 12568 Naava Road, off Hoima Road, Kasubi, Kampala','kampala',
  'Bwengye Millers — Mill and agro-input supplier. Maize, beans, seeds, fertilizers and animal feeds. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S001')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','MailChimp Multi-purpose (U) Ltd','MailChimp Multi-purpose (U) Ltd','MM',
  '+256771156360',null,'+256771156360','Plot 14–18 Cooper Road, Kampala','kampala',
  'MailChimp Multi-purpose (U) Ltd — Kampala-based bulk agro-commodity supplier/exporter; beans, chickpeas, nuts, spices, sunflower products, sesame, maize and rice. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S205')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Sahara Spice Hub','Sahara Spice Hub','SS',
  '+256700874250','+256704598526','+256700874250','Kampala spice and nuts dealer; bulk terms to confirm. Range lead; exact item and stock unconfirmed.','kampala',
  'Sahara Spice Hub — Kampala spice and nuts dealer; bulk terms to confirm. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S204')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Nabaat Agro Export','Nabaat Agro Export','NA',
  '+256744248493',null,'+256744248493','Bukoto 1, Old Kira Road, Nakawa Division, Kampala','kampala',
  'Nabaat Agro Export — Uganda produce exporter. Avocado, coffee, tea, carrot, sesame, pineapple, lemon and tomato. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S011')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','HARAS Organic Products Ltd','HARAS Organic Products Ltd','HO',
  '+256756839414','+256767978252','+256756839414','Kalerwe AM Plaza, Kampala; branch at Kasoma Zone, Luweero','kampala',
  'HARAS Organic Products Ltd — Uganda agro-commodity processor and exporter; chillies, nuts, cocoa, chia, sesame, ginger, turmeric and coffee. Domestic bulk terms to confirm. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S213')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Citco Agro Solutions Ltd','Citco Agro Solutions Ltd','CA',
  '+256705177256',null,'+256705177256','Kampala, Uganda; detailed address supplied on enquiry','kampala',
  'Citco Agro Solutions Ltd — Kampala agricultural exporter supplying coffee, cocoa, chilli, avocado and vanilla; domestic bulk availability to confirm. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S214')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Pied Tropics Ltd','Pied Tropics Ltd','PT',
  '+256703664233','+256414671986','+256703664233','Lukuli, Makindye, Kampala','kampala',
  'Pied Tropics Ltd — Grower-linked bulk exporter of fresh and dried tropical produce and vanilla. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S008')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Prest Foods (U) Ltd','Prest Foods (U) Ltd','PF',
  '+256782956805',null,'+256782956805','Nakasajja, Gayaza Road, Kampala','kampala',
  'Prest Foods (U) Ltd — Food supplier handling frozen vegetables, dry goods and fresh produce. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S012')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Global Agro Inputs Ltd','Global Agro Inputs Ltd','GA',
  '+256772621489',null,'+256772621489','11A Nakivubo Road, Container Village, Kampala','kampala',
  'Global Agro Inputs Ltd — Agro-input supplier. Seeds, seedlings, chemicals, implements and agricultural tools. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S017')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Nsanja Agro-Chemicals Ltd','Nsanja Agro-Chemicals Ltd','NA',
  '+256392176170',null,'+256392176170','Plot 4 Ben Kiwanuka Street, Cares Corner Building, Shop 14, Kampala','kampala',
  'Nsanja Agro-Chemicals Ltd — Agro-input distributor. Seeds, fertilizers, pesticides and farm equipment. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S013')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Trust Chemicals Uganda Ltd','Trust Chemicals Uganda Ltd','TC',
  '+256783100652',null,'+256783100652','Plot 15 Nakivubo Lane, Kampala','kampala',
  'Trust Chemicals Uganda Ltd — Agro-input dealer. Chemicals, seeds and fertilizers. KCCA directory contact. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S014')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Viena Farm Supply','Viena Farm Supply','VF',
  '+256772445910',null,'+256772445910','Container Village, Nakivubo, Kampala','kampala',
  'Viena Farm Supply — Agro-input dealer. Chemicals, seeds and fertilizers. KCCA directory contact. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S015')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Superchem Agro Centre','Superchem Agro Centre','SA',
  '+256774123865','+256701902408','+256774123865','Container Village, Nakivubo, Kampala','kampala',
  'Superchem Agro Centre — Agro-input dealer. Seeds, fertilizers and crop chemicals. KCCA directory contact. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S016')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Adritex (U) Ltd','Adritex (U) Ltd','AU',
  '+256414660937',null,'+256414660937','Oxford Station 8A, 7th Street, Industrial Area, Kampala','kampala',
  'Adritex (U) Ltd — Importer of water pumps, irrigation, water-treatment devices, generators and solar equipment. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S048')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Avant-Garde Distributors (U) Ltd','Avant-Garde Distributors (U) Ltd','AG',
  '+256752628685','+256783437278','+256752628685','Shop A045, Gate 5, Ground Floor, Original Shauriyako Plaza, Nakivubo Road, Kampala','kampala',
  'Avant-Garde Distributors (U) Ltd — Distributor of water pumps, hoses, plumbing and irrigation fittings and spare parts. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S049')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Hydroline Irrigation Uganda','Hydroline Irrigation Uganda','HI',
  '+256200907450','+256778609102','+256200907450','Kasangati, Gayaza Road','kampala',
  'Hydroline Irrigation Uganda — Local supplier of drip/sprinkler irrigation, pipes, pumps, filters and greenhouse kits, with installation support. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S235')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Agromax (U) Ltd','Agromax (U) Ltd','AU',
  '+256756622465','+256414666030','+256756622465','Plot 92, Lutette, Gayaza Road','kampala',
  'Agromax (U) Ltd — Uganda horticulture supplier listed for drip irrigation systems, greenhouse installation and seedling nurseries. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S236')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Felm Ltd','Felm Ltd','FL',
  '+256752605799','+256777912321','+256752605799','Kitagobwa, Kasangati–Matugga Road, Wakiso','wakiso',
  'Felm Ltd — Local manufacturer of flexible packaging, PE/nonwoven bags, printed labels, DPC rolls and nursery polypots. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S181')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Kwago Distributors Ltd','Kwago Distributors Ltd','KD',
  '+256754348888',null,'+256754348888','Kampala, Uganda. P.O. Box 203311; street not published on source','kampala',
  'Kwago Distributors Ltd — Wholesaler and distributor of food, beverages and general merchandise. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S018')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','INNIC Enterprises Ltd','INNIC Enterprises Ltd','IE',
  '+256773894992','+256702594516','+256773894992','Room M03, Nambuusi Arcade, Kikuubo, Kampala','kampala',
  'INNIC Enterprises Ltd — Ingredient dealer. Bakery, ice cream and beverage ingredients, flavours and groceries. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S019')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Spector Uganda Ltd','Spector Uganda Ltd','SU',
  '+256782779898','+256757759541','+256782779898','Plot 35B, Anyafio Village, Weather Head Park Lane, Arua City','arua',
  'Spector Uganda Ltd — Regional wholesaler and distributor of essential foods and household goods. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S020')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Kikuubo Suppliers','Kikuubo Suppliers','KS',
  '+256756158466',null,'+256756158466','Kikuubo, Kampala','kampala',
  'Kikuubo Suppliers — Local wholesaler and retailer of groceries, cooking oil, sugar, soap and household consumables. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S197')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Wholesales Uganda','Wholesales Uganda','WU',
  '+256751893712',null,'+256751893712',null,'kampala',
  'Wholesales Uganda — Uganda online wholesaler and retailer; food cupboard, beverages and household essentials. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S198')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Royal Milk / Rainbow Dairy Uganda','Royal Milk / Rainbow Dairy Uganda','RM',
  '+256747650926','+256747580824','+256747650926','Plot 1230 Block 113, Namanve, Kyaggwe, Mukono','mukono',
  'Royal Milk / Rainbow Dairy Uganda — Uganda dairy manufacturer. Milk and yoghurt; direct partnerships contact. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S166')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','SuperKatale Distributors','SuperKatale Distributors','SD',
  '+256748337843',null,'+256748337843','Bweyogerere, after Flyover along Jinja Road','jinja',
  'SuperKatale Distributors — Uganda distributor for foodservice, retail and hospitality: frozen foods, dairy, snacks, confectionery and non-alcoholic drinks. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S189')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Best Ingredients Africa Ltd','Best Ingredients Africa Ltd','BI',
  '+256788722180','+256759097176','+256788722180','Plot 94, Block 112, Kolo Namanve Industrial Park, Kampala','kampala',
  'Best Ingredients Africa Ltd — Uganda office of an East African food-ingredient manufacturer/distributor supplying bakery ingredients and food additives. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S240')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Your Choice Ltd','Your Choice Ltd','YC',
  '+256772200113','+256312261587','+256772200113','Plot 24, 7th Street, Industrial Area, Kampala','kampala',
  'Your Choice Ltd — Local food importer/distributor with meat processing. Chilled/frozen foods, cheese, butter and ice cream. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S162')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Fresh Cuts (U) Ltd / Quality Cuts','Fresh Cuts (U) Ltd / Quality Cuts','FC',
  '+256707571635','+256707512003','+256707571635','Plot 244 Block 266, Entebbe Road, Seguku','entebbe',
  'Fresh Cuts (U) Ltd / Quality Cuts — Local meat processor and wholesaler with direct special-order contacts. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S163')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Uganda Meat Industries Ltd','Uganda Meat Industries Ltd','UM',
  '+256774410856','+256414345595','+256774410856','Plot 5 Old Port Bell Road, Nakawa, Kampala','kampala',
  'Uganda Meat Industries Ltd — Local meat processor. KCCA directory contact; reconfirm product/cut availability. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S165')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Cuts N Carvings Uganda','Cuts N Carvings Uganda','CN',
  '+256709991909','+256774140714','+256709991909','Old Port Bell Road, near Jessa Head Offices, Kampala','kampala',
  'Cuts N Carvings Uganda — Uganda outlet supplying frozen meats and seafood to homes and businesses. Bulk terms to confirm. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S164')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Mwembetanga Fresh Foods','Mwembetanga Fresh Foods','MF',
  '+256704643031','+256772308134','+256704643031','Plot 39A Mukwasi House, Lumumba Avenue, Kampala','kampala',
  'Mwembetanga Fresh Foods — Produce processor and exporter. Fruits, vegetables, beans, peanuts and maize flour. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S007')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','God’s Mercy Agrovet','God’s Mercy Agrovet','GS',
  '+256759099188',null,'+256759099188','Kampala, Uganda; confirm street address','kampala',
  'God’s Mercy Agrovet — Independent poultry-supplies dealer with public feeder/drinker prices. Bulk terms to confirm. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S160')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Austin Farm','Austin Farm','AF',
  '+256774550349','+256702738607','+256774550349',null,'kampala',
  'Austin Farm — Uganda pasture/fodder producer listed for silage, pasture seeds, planting materials and establishment services in a 2025 dairy-input directory. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S239')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Cleaning and General Supplies Enterprises Uganda','Cleaning and General Supplies Enterprises Uganda','CA',
  '+256777690769',null,'+256777690769','Plot 472, Off Wamala Road, Najjanakumbi','kampala',
  'Cleaning and General Supplies Enterprises Uganda — Local institutional procurement supplier; medical/laboratory, agricultural tools, office/ICT, industrial, food and construction supplies. Exact specification requires procurement confirmation. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S210')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Itungo Pastures','Itungo Pastures','IP',
  '+256705167067','+256782185097','+256705167067','Wakiso Town Council, along Hoima Road','wakiso',
  'Itungo Pastures — Wakiso commercial forage supplier; pasture planting materials, forage cutters and balers, and silage/hay preservation support. Species and supply format require confirmation. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S238')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Radiant Farm Uganda','Radiant Farm Uganda','RF',
  '+256702760564','+256702350821','+256702760564','Office: Conrad Plaza, Floor 6, Plot 23 Entebbe Road, Kampala; farm: Plot 5 Kitotolo Road, Nsangabwami Kikandwa, Mityana','kampala',
  'Radiant Farm Uganda — Local fodder producer/supplier of maize silage, shredded hay and balanced livestock feed blends. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S237')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Vet Equip Solutions Ltd','Vet Equip Solutions Ltd','VE',
  '+256775966801','+256703282889','+256775966801','Shop F14, Kingsway Plaza, Kampala. Warehouse: Orange City Building, Kyengera','kampala',
  'Vet Equip Solutions Ltd — Local distributor of poultry equipment, cages, incubators, feeding/drinking systems and animal nutrition. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S158')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Josca Farmer’s World Ltd','Josca Farmer’s World Ltd','JF',
  '+256784106123','+256392002054','+256784106123','Bweyogerere, next to Watoto Church, Wakiso; Container Village, Kampala','kampala',
  'Josca Farmer’s World Ltd — Local bulk importer/distributor of poultry equipment, feeds and livestock supplements. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S159')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','BQ Machinery (U) Ltd','BQ Machinery (U) Ltd','BM',
  '+256702914940','+256774062801','+256702914940','Plot 2–8, 8th Street, Industrial Area, Kampala','kampala',
  'BQ Machinery (U) Ltd — Local machinery supplier: generators, water pumps, compactors, cleaning and welding equipment, air compressors, farm and poultry equipment. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S193')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Kamp Feed','Kamp Feed','KF',
  '+256775716623','+256706604175','+256775716623','Plot 709 Kisaasi–Kyanja Road, opposite Rochester Hotel, Kampala','kampala',
  'Kamp Feed — Ugandan manufacturer of pelleted animal feeds. Factory in Nwoya. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S021')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Conversion Feeds Ltd','Conversion Feeds Ltd','CF',
  '+256782208208','+256707792064','+256782208208','Plot 5 Coronation Road, Old Kampala','kampala',
  'Conversion Feeds Ltd — Animal-feed distributor. Poultry, fish, pig, dairy and calf feed and concentrates. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S022')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Kiwa and Sons','Kiwa and Sons','KA',
  '+256771824382','+256700962458','+256771824382','Lugazi Bridge, Kinyoro–Nakazadde Road, Lugazi','kampala',
  'Kiwa and Sons — Animal-feed miller and wholesaler. Feeds, additives and mineral supplements. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S025')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Snowmans Uganda Ltd','Snowmans Uganda Ltd','SU',
  '+256705220555',null,'+256705220555','Snowmans Centre, Plot 89, 7th Street, Industrial Area, Kampala','kampala',
  'Snowmans Uganda Ltd — Equipment supplier. Dairy processing, refrigeration, packaging, sealing, weighing and generators. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S073')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Engineering Solutions (U) Ltd','Engineering Solutions (U) Ltd','ES',
  '+256200301800','+256200964221','+256200301800',null,'kampala',
  'Engineering Solutions (U) Ltd — Uganda agricultural-machinery distributor and fabricator. Tractors, implements, dairy and irrigation. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S075')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Terra Agri Solutions','Terra Agri Solutions','TA',
  '+256200917947',null,'+256200917947','Plot 310 Sserwada Close, Bukoto, Kampala. Confirm current office','kampala',
  'Terra Agri Solutions — Local agricultural-machinery dealer. Tractors, crop implements, harvest, grain and livestock systems. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S076')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Super Deal Hardware','Super Deal Hardware','SD',
  '+256751999195','+256773307171','+256751999195',null,'kampala',
  'Super Deal Hardware — Local hardware dealer. Tools, sanitaryware, plumbing, paint, steel and electrical goods. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S027')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Give and Take MASE Hardware','Give and Take MASE Hardware','GA',
  '+256393208444','+256780554583','+256393208444','Rubaga Road main branch, Kampala','kampala',
  'Give and Take MASE Hardware — Local hardware supplier. Steel, welding, roofing, tools and construction products. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S028')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Valueware (U) Ltd','Valueware (U) Ltd','VU',
  '+256775372911','+256701039944','+256775372911','Shop A028, Original Shauriako Plaza, Kampala','kampala',
  'Valueware (U) Ltd — Hardware wholesaler and trade supplier. Power tools, hand tools and safety equipment. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S038')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Lexa Engineering / Lexa Real Estate Agency Ltd','Lexa Engineering / Lexa Real Estate Agency Ltd','LE',
  '+256780752075','+256776177171','+256780752075','Twin Mall, Kira, Room 51, Kampala','kampala',
  'Lexa Engineering / Lexa Real Estate Agency Ltd — Local construction-material and hardware supplier; plumbing, electrical, steel sections and safety gear. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S199')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Smeaton Constructions Hardware','Smeaton Constructions Hardware','SC',
  '+256758821603','+256789853114','+256758821603','Nabbingo, Kampala area; confirm shop address','kampala',
  'Smeaton Constructions Hardware — Local construction-material supplier offering building materials, plumbing, sanitaryware and hardware. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S200')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Interior Technologies','Interior Technologies','IT',
  '+256414258493',null,'+256414258493','Plot 50 Robert Mugabe Road, Mbuya, Kampala','kampala',
  'Interior Technologies — Local fabricator and fit-out supplier. Ceilings, partitions, flooring, woodwork, blinds and wallpaper. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S127')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Tetrabuild Services Ltd','Tetrabuild Services Ltd','TS',
  '+256776836552','+256393255027','+256776836552','Plot 2209 Kalonda Rise, off Kulambiro Ring Road, Kulambiro, Kampala','kampala',
  'Tetrabuild Services Ltd — Local specialist-material distributor. Waterproofing, membranes, geosynthetics, scaffolding and formwork. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S157')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','PG Mold (U) Ltd','PG Mold (U) Ltd','PM',
  '+256704771061','+256777102929','+256704771061','Kasangati, Wampewo, Gayaza Road, opposite Vision Petrol Station, Wakiso','wakiso',
  'PG Mold (U) Ltd — Local supplier offering scaffolding and concrete formwork for sale or hire, including ringlock/cuplock systems and slab support. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S234')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','C.B. World Investment Ltd','C.B. World Investment Ltd','CB',
  '+256754407792','+256776917792','+256754407792','Plot 938, Ntinda–Kisaasi Road, Kisota Zone, Kampala','kampala',
  'C.B. World Investment Ltd — Uganda importer and distributor of industrial/automotive lubricants, transformer oils, rubber process oils and white oils; also bitumen and paraffin. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S231')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Depo Uganda','Depo Uganda','DU',
  '+256776898888','+256758853285','+256776898888','Plot 2A, Old Port Bell Road, Industrial Area, Kampala','kampala',
  'Depo Uganda — Local distributor of building products, interior wall/floor finishes, plastic flooring and acoustic suspended ceilings. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S247')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Erimu Company Ltd','Erimu Company Ltd','EC',
  '+256707956135',null,'+256707956135','Factory: Namagoma, Masaka Road. Showrooms: Jinja Road and Ntinda, Kampala','kampala',
  'Erimu Company Ltd — Local wood-product manufacturer and trader. Doors, frames, boards and home/office furniture. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S081')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','SPL Steel Distributors Co. Ltd','SPL Steel Distributors Co. Ltd','SS',
  '+256789171184','+256393236377','+256789171184','Kikapwa Plaza, Erisa Nkoyoyo Road, Kisenyi, Kampala','kampala',
  'SPL Steel Distributors Co. Ltd — Steel wholesaler supplying contractors, manufacturers and hardware retailers. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S032')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','SH Family Hardware','SH Family Hardware','SF',
  '+256772518513','+256754981574','+256772518513',null,'kampala',
  'SH Family Hardware — Wholesale and retail hardware. Building, roofing, plumbing, electrical and paint supplies. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S026')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Generous Trading & Investment Ltd','Generous Trading & Investment Ltd','GT',
  '+256782177960',null,'+256782177960','Kumi Road, Mbale, Uganda','mbale',
  'Generous Trading & Investment Ltd — Local building-material dealer. Construction, hardware, plumbing and electrical supplies. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S029')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Steel Force Ltd','Steel Force Ltd','SF',
  '+256772302010',null,'+256772302010','Plot 62 Oboja Road, Jinja','jinja',
  'Steel Force Ltd — Wholesale dealer for steel, cement, roofing sheets and decorative/automotive paints. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S033')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Aquva International Ltd','Aquva International Ltd','AI',
  '+256782473730','+256772507908','+256782473730','Shop: Plot 1 Sure House, Bombo Road. Factory: Plot 37–43 Kibira Road, Industrial Area, Kampala','kampala',
  'Aquva International Ltd — Uganda engineering-supplies distributor. Bearings, industrial hardware, welding, tools, abrasives, pipes and insulation. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S184')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','FRUX Solutions (U) Ltd','FRUX Solutions (U) Ltd','FS',
  '+256746889178',null,'+256746889178','Industrial electrical and mechanical supplier. Motors, drives, bearings, belts, chains and seals. Range lead; exact item and stock unconfirmed.','kampala',
  'FRUX Solutions (U) Ltd — Industrial electrical and mechanical supplier. Motors, drives, bearings, belts, chains and seals. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S042')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Electro Centre Ltd','Electro Centre Ltd','EC',
  '+256702891204',null,'+256702891204','231 Sixth Street, Industrial Area, Kampala','kampala',
  'Electro Centre Ltd — Local electrical supplier and HILTI distributor. Wiring, lighting, protection and professional tools. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S040')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Candela Engineering and Supplies Ltd','Candela Engineering and Supplies Ltd','CE',
  '+256786400160','+256701869182','+256786400160','Local industrial supplier. Bearings, lubricants, transmission spares, tools, PPE and automotive spares. Range lead; exact item and stock unconfirmed.','kampala',
  'Candela Engineering and Supplies Ltd — Local industrial supplier. Bearings, lubricants, transmission spares, tools, PPE and automotive spares. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S135')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Timeline Interior and Services','Timeline Interior and Services','TI',
  '+256705619035',null,'+256705619035','8th Street, Industrial Area, Kampala','kampala',
  'Timeline Interior and Services — Local interior supplier and fabricator. Wall panels, gypsum, flooring, ceilings and custom furniture. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S128')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Kajjansi Brick & Tile Works Ltd','Kajjansi Brick & Tile Works Ltd','KB',
  '+256414200671',null,'+256414200671','Kajjansi, 8 miles Entebbe Road','entebbe',
  'Kajjansi Brick & Tile Works Ltd — Local clay-products manufacturer. Roofing tiles, ridges, bricks, maxpans and floor tiles. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S035')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Royal Mabati Uganda Ltd','Royal Mabati Uganda Ltd','RM',
  '+256702638383','+256784426925','+256702638383','Bombo Road, Kawanda, opposite Safe Drive Uganda, near YAHYA Construction Centre','kampala',
  'Royal Mabati Uganda Ltd — Uganda roofing-sheet manufacturer. Corrugated, box-profile and tile-profile sheets and accessories. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S036')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Elektrex Ltd','Elektrex Ltd','EL',
  '+256772755966','+256772755988','+256772755966','Plot 91/97, 7th Street, Industrial Area, Kampala','kampala',
  'Elektrex Ltd — Importer and supplier of electrical goods, lighting, distribution and solar equipment. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S039')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Chint Uganda','Chint Uganda','CU',
  '+256392266552','+256393130666','+256392266552','Plot 147–153, 6th Street, Industrial Area, Kampala','kampala',
  'Chint Uganda — Uganda distributor and panel builder. Switchgear, lighting, motors, drives and solar systems. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S041')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','AgaCan Group Uganda','AgaCan Group Uganda','AG',
  '+256755978947',null,'+256755978947','Trust Tower, Plot 4 Kyadondo Road, Kampala','kampala',
  'AgaCan Group Uganda — Industrial procurement supplier with a Kampala office; electrical, mechanical, fluid-power, tools, ICT, PPE and office ranges. Special-order availability requires confirmation. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S186')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Bintech Systems & Supplies Ltd','Bintech Systems & Supplies Ltd','BS',
  '+256749767637',null,'+256749767637','3rd Floor Shree Hari Plaza, Industrial Area, Kampala','kampala',
  'Bintech Systems & Supplies Ltd — Uganda distributor of electrical, sanitaryware and security products. CHINT, Tronic, Jaquar, Matrix and CP Plus ranges. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S179')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','PEL Automation / Petro Equipment Logistics','PEL Automation / Petro Equipment Logistics','PA',
  '+256752978809',null,'+256752978809','Plot 3155, Namanve Industrial Park, Bbuto Road, after SGS Vehicle Inspection Station, Kampala–Jinja Highway','kampala',
  'PEL Automation / Petro Equipment Logistics — Uganda industrial product and system supplier for instrumentation, measurement, electrical and automation applications; project specification and procurement required. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S241')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Axentra Uganda','Axentra Uganda','AU',
  '+256750630612','+256777186725','+256750630612','Kampala, Uganda; confirm street address','kampala',
  'Axentra Uganda — Local engineering supplier of industrial equipment, pumps, compressors, generators, tools, mechanical/electrical/hydraulic components and safety equipment. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S187')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Sanpic Electronics','Sanpic Electronics','SE',
  '+256750200400','+256705414716','+256750200400','Spring Road, Bugolobi, next to ABSA Bank, Kampala','kampala',
  'Sanpic Electronics — Local appliance dealer. Wholesale/bulk terms need confirmation. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S044')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','A&S Electronics Ltd','A&S Electronics Ltd','AS',
  '+256414341681','+256776848543','+256414341681','Metropole House, Entebbe Road, next to Kamu Kamu Plaza, Ground Floor G12, Kampala','kampala',
  'A&S Electronics Ltd — Uganda electronics supplier listed for electrical appliances in institutional procurement. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S045')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','London Quality Electronics UG','London Quality Electronics UG','LQ',
  '+256787094266','+256701160068','+256787094266','Plot 6 Entebbe Road, KamuKamu Plaza, Shop LG1, opposite ABSA Bank, Kampala','kampala',
  'London Quality Electronics UG — Independent appliance dealer. Wholesale/bulk terms need confirmation. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S149')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Kaliira Electronics Center','Kaliira Electronics Center','KE',
  '+256703825217','+256774599216','+256703825217','Katwe Business Centre, Katwe, Kampala','kampala',
  'Kaliira Electronics Center — Kampala electronics dealer accepting wholesale inquiries; televisions, phones, refrigerators, home theatre and accessories. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S203')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','TMT Technologies (U) Ltd','TMT Technologies (U) Ltd','TT',
  '+256704807111','+256706665283','+256704807111','Plot 30 Soliz Courts, Lumumba Avenue, Nakasero, Kampala','kampala',
  'TMT Technologies (U) Ltd — Local ICT and office-equipment supplier. Computers, copiers, printers, networking and PABX. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S115')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Treasure Plus Company Ltd','Treasure Plus Company Ltd','TP',
  '+256776112454','+256773136946','+256776112454','Plot 37–39, Ntinda, Kampala','kampala',
  'Treasure Plus Company Ltd — Uganda business-hardware distributor. HP, Lenovo and Dell partner. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S116')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Twincom Technologies','Twincom Technologies','TT',
  '+256782707080','+256759503990','+256782707080','Plot 218 Bobsons Building, Bulindo Road, Kira','kampala',
  'Twincom Technologies — Local ICT equipment supplier and integrator. Computers, servers and network equipment. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S117')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Neriko Electronics','Neriko Electronics','NE',
  '+256779319949',null,'+256779319949','Maricah Centrum Building, Rooms A6–7, Nkinzi Road, Wandegeya, Kampala','kampala',
  'Neriko Electronics — Local specialist electronic-components and prototyping supplier; Raspberry Pi reseller. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S153')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Sarada Technologies Ltd','Sarada Technologies Ltd','ST',
  '+256747171717','+256709005925','+256747171717','D’Almeida and Sons Building, Bombo Road, opposite SureHouse, next to Norvik Pharmacy, Kampala','kampala',
  'Sarada Technologies Ltd — Local reseller/installer of CCTV, networking equipment and computer hardware. Bulk terms to confirm. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S147')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','G3A Technologies','G3A Technologies','GA',
  '+256752720501',null,'+256752720501','Bukoto–Kisaasi Road, Kampala, P.O. Box 176257','kampala',
  'G3A Technologies — Kampala AV and IT supplier/integrator for public-address systems, video displays, digital signage, meeting systems, servers and network equipment. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S251')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','PRO AV Africa','PRO AV Africa','PA',
  '+256752506090',null,'+256752506090','Plot 84B Luthuli Avenue, Bugolobi, Kampala','kampala',
  'PRO AV Africa — Kampala wholesale distributor of professional audio, video, conferencing, projection, public-address and broadcast equipment. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S252')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Logix Technical Solutions','Logix Technical Solutions','LT',
  '+256393202127','+256772712259','+256393202127','Plot 744 Namuli Road, Kampala','kampala',
  'Logix Technical Solutions — Uganda supplier and installer of CCTV, access control, ICT, backup power, public-address and audio-visual presentation systems. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S253')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','ADH Group Uganda Ltd','ADH Group Uganda Ltd','AG',
  '+256757148823','+256704031444','+256757148823','Weraga Road, Ndeeba, Kampala','kampala',
  'ADH Group Uganda Ltd — Importer and wholesaler of home, solar and commercial kitchen appliances. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S043')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','National Agro Machinery Ltd','National Agro Machinery Ltd','NA',
  '+256714899933','+256757575750','+256714899933','Plot 12/14/16 Entebbe Road, Kampala','kampala',
  'National Agro Machinery Ltd — Local machinery distributor. Agricultural machines, generators and solar equipment. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S074')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Machine World Uganda','Machine World Uganda','MW',
  '+256752815403',null,'+256752815403','William Street, Arua Park Plaza, Kampala','kampala',
  'Machine World Uganda — Local dealer in farm machinery, generators and construction equipment. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S071')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Kenezio Equipment Co. Ltd','Kenezio Equipment Co. Ltd','KE',
  '+256781462780','+256788300774','+256781462780','Kampala, Uganda; confirm yard address','kampala',
  'Kenezio Equipment Co. Ltd — Uganda construction-equipment sales and rental business; excavators, bulldozers, wheel loaders, rollers, backhoes, concrete equipment and generators. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S194')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Shine Wave Energy','Shine Wave Energy','SW',
  '+256200930194','+256743647125','+256200930194','Uganda; confirm street address before visiting','kampala',
  'Shine Wave Energy — Local solar and backup-power supplier. Panels, batteries and inverters. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S047')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Clone Supplies Uganda','Clone Supplies Uganda','CS',
  '+256200934788',null,'+256200934788','Nakasero, Kampala','kampala',
  'Clone Supplies Uganda — Specialist plumbing and sanitaryware supplier. Pipes, fittings, valves and bathroom products. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S051')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Momila General Traders Ltd','Momila General Traders Ltd','MG',
  '+256758318063','+256758524471','+256758318063','Kampala, Uganda; street not published on source','kampala',
  'Momila General Traders Ltd — Importer and wholesale distributor of sanitaryware, bathroom fittings and kitchen mixers. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S050')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','NSI Water Uganda','NSI Water Uganda','NW',
  '+256394802101','+256200902158','+256394802101','Penn Station, 7th Street, Industrial Area, Kampala','kampala',
  'NSI Water Uganda — Local supplier of water-treatment equipment, borehole pumps and pool systems. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S114')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','WaterQuip Uganda Ltd','WaterQuip Uganda Ltd','WU',
  '+256773770365',null,'+256773770365','Quality Shopping Village, Naalya–Namugongo Road, Kampala','kampala',
  'WaterQuip Uganda Ltd — Local water-filter and treatment-equipment supplier; directory-listed contact and premises. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S245')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Smart Water Systems – SMC Ltd','Smart Water Systems – SMC Ltd','SW',
  '+256776088901',null,'+256776088901','Plot 1–5 Kinawataka Road, Warehouse 4, Nakawa, Kampala','kampala',
  'Smart Water Systems – SMC Ltd — Uganda water-storage, water-purification and wastewater-treatment systems supplier. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S246')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','NIM Paints','NIM Paints','NP',
  '+256785275476','+256784523877','+256785275476','Ugandan paint manufacturer. Decorative and industrial coatings. Direct sales contact. Range lead; exact item and stock unconfirmed.','kampala',
  'NIM Paints — Ugandan paint manufacturer. Decorative and industrial coatings. Direct sales contact. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S052')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Monaco Coatings','Monaco Coatings','MC',
  '+256200982982','+256392852727','+256200982982','Hardware City, Nakasero, Gate 7, Shops 14–16, Kampala','kampala',
  'Monaco Coatings — Uganda paint manufacturer with local branches and a factory outlet. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S053')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Coral Coatings Ltd','Coral Coatings Ltd','CC',
  '+256779146627','+256759888337','+256779146627','Kireka, Kinawataka Road, Kampala','kampala',
  'Coral Coatings Ltd — Local manufacturer of interior, exterior, textured and emulsion paints. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S054')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Raek Chemicals Ltd','Raek Chemicals Ltd','RC',
  '+256778952095',null,'+256778952095','Plot 63, 8th Street, Namuwongo Road, Industrial Area, Kampala','kampala',
  'Raek Chemicals Ltd — Local supplier of paints, primers, wood finishes, thinners, resins and fibreglass materials. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S055')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','LGS Chemicals SMC Ltd','LGS Chemicals SMC Ltd','LC',
  '+256700455566',null,'+256700455566','Industrial Area, 7th Street, Kampala','kampala',
  'LGS Chemicals SMC Ltd — Kampala coatings/varnish manufacturer and industrial chemical trader; emulsions, enamels, primers, roof coatings, wood finishes, solvents, glycols, acids, surfactants and resins. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S216')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Interstate Chemical Industries Ltd','Interstate Chemical Industries Ltd','IC',
  '+256757834516',null,'+256757834516','Plot 902, Kyambogo Industrial Area, Kampala','kampala',
  'Interstate Chemical Industries Ltd — Uganda bulk-chemical distributor serving paints, plastics, rubber, detergents, food, textiles and industrial applications. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S207')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','T&S ChemSolutions Ltd','T&S ChemSolutions Ltd','TS',
  '+256760937969','+256748584824','+256760937969',null,'kampala',
  'T&S ChemSolutions Ltd — Local industrial/specialty chemical supplier; soap, cosmetics, food, paints, plastics and water-treatment chemicals. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S208')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Reliance Chemicals Ltd','Reliance Chemicals Ltd','RC',
  '+256759767766',null,'+256759767766','Local industrial-chemical distributor for manufacturing and industrial cleaning. Range lead; exact item and stock unconfirmed.','kampala',
  'Reliance Chemicals Ltd — Local industrial-chemical distributor for manufacturing and industrial cleaning. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S057')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','SHP Sons Uganda Ltd','SHP Sons Uganda Ltd','SS',
  '+256705069001','+256754489602','+256705069001','Local distributor of industrial, cleaning, paint, cosmetic and packaging chemicals. Range lead; exact item and stock unconfirmed.','kampala',
  'SHP Sons Uganda Ltd — Local distributor of industrial, cleaning, paint, cosmetic and packaging chemicals. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S059')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Deep Commodities Ltd','Deep Commodities Ltd','DC',
  '+256787177476','+256758331002','+256787177476','Local industrial-chemical manufacturer and distributor. Confirm grade and pack size. Range lead; exact item and stock unconfirmed.','kampala',
  'Deep Commodities Ltd — Local industrial-chemical manufacturer and distributor. Confirm grade and pack size. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S060')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','KAS Engineering Ltd','KAS Engineering Ltd','KE',
  '+256702811121','+256779233916','+256702811121','Plot KR-02 Kimbejja Road, Kyaliwajjala–Namugongo, Kampala','kampala',
  'KAS Engineering Ltd — Local supplier and engineering firm for treatment chemicals and water/wastewater systems. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S111')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Teejo Investment Ltd','Teejo Investment Ltd','TI',
  '+256702996449','+256772996449','+256702996449','No additional supported Uganda match for Industrial detergent. Minimum four not yet met.','kampala',
  'Teejo Investment Ltd — Local distributor of laboratory chemicals, cleaning agents, water-system supplies, safety gear and pneumatic valves. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S221')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Conch Gas Ltd','Conch Gas Ltd','CG',
  '+256776500786','+256703978198','+256776500786','Uganda supplier of industrial gases, LPG, refrigerants, grease and gas accessories. Range lead; exact item and stock unconfirmed.','kampala',
  'Conch Gas Ltd — Uganda supplier of industrial gases, LPG, refrigerants, grease and gas accessories. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S170')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Canadian Oil Refinery & Energy Ltd','Canadian Oil Refinery & Energy Ltd','CO',
  '+256740100222','+256740707777','+256740100222','Kakerenge, Bombo Road, Kampala','kampala',
  'Canadian Oil Refinery & Energy Ltd — Kampala lubricant manufacturer advertising industrial lubrication products. Confirm the required oil grade and application. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S232')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','AXCL Lubricants (U) Ltd','AXCL Lubricants (U) Ltd','AL',
  '+256759000420','+256758166615','+256759000420','Plot 268, Namanve Business Park, Mukono District; P.O. Box 9076 Kampala','kampala',
  'AXCL Lubricants (U) Ltd — Uganda-based lubricant factory supplying automotive and industrial oils, hydraulic/gear oils, cutting oil and grease. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S233')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Oxygas Ltd','Oxygas Ltd','OL',
  '+256755333120','+256752700700','+256755333120','Uganda supplier of industrial gases in cylinders and bulk liquid. Range lead; exact item and stock unconfirmed.','kampala',
  'Oxygas Ltd — Uganda supplier of industrial gases in cylinders and bulk liquid. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S167')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Indo-Gas Uganda Ltd','Indo-Gas Uganda Ltd','IG',
  '+256704973837','+256763141695','+256704973837','Local industrial/medical-gas supplier, with gas accessories and safety equipment. Range lead; exact item and stock unconfirmed.','kampala',
  'Indo-Gas Uganda Ltd — Local industrial/medical-gas supplier, with gas accessories and safety equipment. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S168')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Ebenezer Gas Supplies Ltd','Ebenezer Gas Supplies Ltd','EG',
  '+256778640748','+256751263596','+256778640748','Local industrial and medical gas supplier offering bulk-order delivery. Range lead; exact item and stock unconfirmed.','kampala',
  'Ebenezer Gas Supplies Ltd — Local industrial and medical gas supplier offering bulk-order delivery. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S169')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Opera Chemical SMC Ltd','Opera Chemical SMC Ltd','OC',
  '+256754682121',null,'+256754682121','69, 7th Street, Industrial Area, Kampala','kampala',
  'Opera Chemical SMC Ltd — Chemical distributor. Soap, cosmetics and paint raw materials, acids and solvents. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S058')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','MBS Construction Chemicals Uganda Ltd','MBS Construction Chemicals Uganda Ltd','MC',
  '+256772767477','+256414347130','+256772767477','1–27 Nasser Lane, Nakasero, Nasser Road, Kampala','kampala',
  'MBS Construction Chemicals Uganda Ltd — Local manufacturer/importer of concrete admixtures, waterproofing, flooring, grouts and sealants. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S154')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Kalanzi Chemical & Constructions (U) Ltd','Kalanzi Chemical & Constructions (U) Ltd','KC',
  '+256780224789','+256703181133','+256780224789','Plot 15/17, 2nd Street, Industrial Area, Kampala','kampala',
  'Kalanzi Chemical & Constructions (U) Ltd — Local distributor of construction chemicals, waterproofing and concrete systems. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S155')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Starke Polymers','Starke Polymers','SP',
  '+256764202020',null,'+256764202020','Plot 158, Sixth Street, Industrial Area, Kampala','kampala',
  'Starke Polymers — Local construction-chemical manufacturer. Admixtures, grouts, sealants, flooring and waterproofing. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S156')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Yoshino Trading','Yoshino Trading','YT',
  '+256706663101','+256777049069','+256706663101','Kampala, Uganda; confirm current vehicle yard','kampala',
  'Yoshino Trading — Uganda used-car and truck dealer with direct WhatsApp sales contacts. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S066')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Driven Deals Ltd','Driven Deals Ltd','DD',
  '+256773921342',null,'+256773921342','Kampala, Uganda; street not published on source','kampala',
  'Driven Deals Ltd — Independent Uganda vehicle dealer. Confirm model, year, duty status and current stock. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S067')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Motorcare Uganda','Motorcare Uganda','MU',
  '+256772200012','+256312238100','+256772200012','Plot 95 Jinja Road, Kampala','kampala',
  'Motorcare Uganda — Uganda vehicle distributor. Nissan, Ford and Hyundai sales and parts support. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S070')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Spear Motors Ltd','Spear Motors Ltd','SM',
  '+256783614601','+256753614601','+256783614601','Uganda; confirm Kampala showroom before visiting','kampala',
  'Spear Motors Ltd — Uganda vehicle distributor with direct sales mobiles. Cars, vans and commercial trucks. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S068')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Modern Emperor Automobiles Ltd','Modern Emperor Automobiles Ltd','ME',
  '+256709035440','+256800300480','+256709035440','Plot 6, Hill Crescent, Banda, Kampala','kampala',
  'Modern Emperor Automobiles Ltd — Uganda commercial-vehicle dealer and assembler for Ashok Leyland trucks and buses; successor to Emperor and Modern Automobiles. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S217')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Jamali Tech','Jamali Tech','JT',
  '+256742264753',null,'+256742264753','Industrial Area, Kampala; confirm showroom plot','kampala',
  'Jamali Tech — Kampala distributor of generators, pumps, agricultural and industrial equipment and commercial vehicles. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S218')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Double Q / Hanlink Uganda','Double Q / Hanlink Uganda','DQ',
  '+256708808888','+256780988888','+256708808888','Plot 414 Kasumba Square, Busega, Kampala','kampala',
  'Double Q / Hanlink Uganda — Uganda distributor of Sinotruk, HELI and XCMG vehicles and equipment. Local sales contacts. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S069')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Agriserv Ltd','Agriserv Ltd','AL',
  '+256741885887',null,'+256741885887','Aworanga, Anaka Road, Gulu','gulu',
  'Agriserv Ltd — Uganda CASE IH distributor supplying tractors, agricultural implements, genuine parts and local servicing. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S219')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','ARK Agriculture Ltd','ARK Agriculture Ltd','AA',
  '+256200910353',null,'+256200910353','Plot 10, Mubende–Kyegegwa–Kyenjojo–Fort Portal Road, Uganda','fort-portal',
  'ARK Agriculture Ltd — Uganda agricultural machinery sourcing business for tractors, combines, potato harvesters, seed drills and irrigation systems. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S192')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Achelis Uganda Ltd','Achelis Uganda Ltd','AU',
  '+256747036199','+256200800500','+256747036199','Local industrial-equipment distributor with sales and technical support. Range lead; exact item and stock unconfirmed.','kampala',
  'Achelis Uganda Ltd — Local industrial-equipment distributor with sales and technical support. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S079')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','F&B Solutions Ltd','F&B Solutions Ltd','FB',
  '+256782935776','+256753564364','+256782935776','6th Street, Industrial Area, between Exim Bank and City Tyres, Kampala','kampala',
  'F&B Solutions Ltd — Uganda machinery distributor. Food processing, filling, sealing, coding, wrapping and water-treatment plants. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S132')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Industrial Machines Uganda','Industrial Machines Uganda','IM',
  '+256744444077','+256200934407','+256744444077','Local industrial-equipment supplier. Agro-processing, packaging, bottling and auxiliary equipment. Range lead; exact item and stock unconfirmed.','kampala',
  'Industrial Machines Uganda — Local industrial-equipment supplier. Agro-processing, packaging, bottling and auxiliary equipment. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S172')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Nimax Uganda','Nimax Uganda','NU',
  '+256200906179',null,'+256200906179',null,'kampala',
  'Nimax Uganda — Local distributor of coding, marking, inspection, digital-printing and labelling equipment; also lists robotic palletizing. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S196')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','ALIDAM Heavy Parts','ALIDAM Heavy Parts','AH',
  '+256779898495',null,'+256779898495','Sedona Complex, Rashid Khamis Road, Kampala','kampala',
  'ALIDAM Heavy Parts — Uganda wholesaler/retailer of heavy-equipment spares, tyres, filters, hydraulic seals and diesel engine components. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S176')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','East African Chains (U) Ltd','East African Chains (U) Ltd','EA',
  '+256200960426',null,'+256200960426','Plot 87, 1st Street, Kampala','kampala',
  'East African Chains (U) Ltd — Uganda branch supplying industrial transmission, conveying, lifting, lubrication, sealing and pumping products. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S134')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','EMK Hydraulics & Spares','EMK Hydraulics & Spares','EH',
  '+256753574740','+256777629913','+256753574740','Kampala, Uganda; confirm workshop street address','kampala',
  'EMK Hydraulics & Spares — Uganda hydraulic-systems and heavy-machinery spare-parts supplier; advertises Sinopulse hose and fitting distribution. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S188')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','KNAR Ltd','KNAR Ltd','KL',
  '+256393249328',null,'+256393249328','Plot 100 Mutesa II Road, Ntinda, Kampala','kampala',
  'KNAR Ltd — Local distributor of professional cleaning systems and equipment. Directory contact. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S173')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Victoria Equipment Ltd','Victoria Equipment Ltd','VE',
  '+256770834765','+256414256025','+256770834765','Uganda equipment distributor. Earthmoving, compaction, drilling, quarry and road machinery. Range lead; exact item and stock unconfirmed.','kampala',
  'Victoria Equipment Ltd — Uganda equipment distributor. Earthmoving, compaction, drilling, quarry and road machinery. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S077')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Kijoora Investments Ltd','Kijoora Investments Ltd','KI',
  '+256755268389','+256776931796','+256755268389',null,'kampala',
  'Kijoora Investments Ltd — Independent dealer in heavy construction equipment, with sales, leasing and parts support. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S078')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Vecarian Plant Ltd — Uganda','Vecarian Plant Ltd — Uganda','VP',
  '+256790419436',null,'+256790419436','S-9, Creston Business Park, Namanve Industrial Park, Kampala–Jinja Highway','kampala',
  'Vecarian Plant Ltd — Uganda — Uganda-based SDLG dealer for wheel loaders, graders, excavators, rollers and backhoe loaders. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S195')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Rennes Solutions Ltd','Rennes Solutions Ltd','RS',
  '+256780329457',null,'+256780329457','Uganda; confirm Kampala office address','kampala',
  'Rennes Solutions Ltd — Local institutional supplier of PPE, fire safety, site signage and office supplies. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S110')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Musa Body Machinery (U) Ltd','Musa Body Machinery (U) Ltd','MB',
  '+256707888101','+256707888109','+256707888101','Musa Body Building, Plot 1080 Katwe–Mutesa I Road, Kampala','kampala',
  'Musa Body Machinery (U) Ltd — Local agro-processing machinery fabricator/dealer. Historical KCCA directory contact; reconfirm trading status. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S133')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Jimmy Brian Garments Co-SMC Ltd','Jimmy Brian Garments Co-SMC Ltd','JB',
  '+256782757845',null,'+256782757845','Nabukera Plaza H32, Nabugabo Street, Kampala','kampala',
  'Jimmy Brian Garments Co-SMC Ltd — Importer and wholesaler of menswear, suits and textile fabrics. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S089')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Uganda Rosely Hometextile Manufacture Factory Ltd','Uganda Rosely Hometextile Manufacture Factory Ltd','UR',
  '+256701219539',null,'+256701219539','Plot 26 William Street, Kampala','kampala',
  'Uganda Rosely Hometextile Manufacture Factory Ltd — Local textiles and garments manufacturer. Directory contact. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S090')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Waynah Textiles','Waynah Textiles','WT',
  '+256200999671',null,'+256200999671','Ham Shopping Grounds, Block S, Shop S-360/351, Kisenyi II, Nakivubo Road, Kampala','kampala',
  'Waynah Textiles — Local fabric wholesaler supplying garment makers and retailers. Crepe, knitted, satin and textured fabrics. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S150')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Shree Modern Textiles','Shree Modern Textiles','SM',
  '+256742792768',null,'+256742792768','Jinja textile manufacturer; home furnishing, suiting, shirting and African-print fabrics. Range lead; exact item and stock unconfirmed.','jinja',
  'Shree Modern Textiles — Jinja textile manufacturer; home furnishing, suiting, shirting and African-print fabrics. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S201')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Comeagain Investments Ltd','Comeagain Investments Ltd','CI',
  '+256701451506','+256200915520','+256701451506','Uganda; confirm showroom street address','kampala',
  'Comeagain Investments Ltd — Local interior-textile supplier; curtains, netting, sofa fabrics, cushions, bedding, accessories, blinds and furniture. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S202')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','EverGreen Uniforms & Textiles','EverGreen Uniforms & Textiles','EU',
  '+256752805524',null,'+256752805524','Bandwe, Nalumunye, Kampala; confirm workshop location','kampala',
  'EverGreen Uniforms & Textiles — Uganda manufacturer of school, corporate, security, medical and hospitality uniforms; socks, sweaters and protective garments. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S209')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','BP Royal Uganda Ltd','BP Royal Uganda Ltd','BR',
  '+256773273991','+256414255808','+256773273991',null,'kampala',
  'BP Royal Uganda Ltd — Local manufacturer of uniforms, corporate/workwear and protective clothing, with embroidery. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S086')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Uganda Uniform Manufacturers & Distributors Ltd','Uganda Uniform Manufacturers & Distributors Ltd','UU',
  '+256772848727','+256414342871','+256772848727','Plot 20/23 Nkrumah Road, Property House, Kampala','kampala',
  'Uganda Uniform Manufacturers & Distributors Ltd — Local uniform and garment manufacturer/distributor. Directory contact. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S087')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Unique Uniform Manufacturers (U) Ltd','Unique Uniform Manufacturers (U) Ltd','UU',
  '+256772618372','+256414234965','+256772618372','Plot 10 Kampala Road, Uganda House, Shop 13, Kampala','kampala',
  'Unique Uniform Manufacturers (U) Ltd — Local uniform and garment manufacturer. Directory contact. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S088')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Fine Spinners Uganda Ltd','Fine Spinners Uganda Ltd','FS',
  '+256414342716',null,'+256414342716','Spring Road, Kiswa Zone, Bugolobi, Kampala','kampala',
  'Fine Spinners Uganda Ltd — Uganda cotton textile and garment manufacturer with integrated spinning, knitting, weaving and sewing. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S151')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Beddings Uganda','Beddings Uganda','BU',
  '+256704043157',null,'+256704043157','Nabugabo, Kampala; confirm shop number','kampala',
  'Beddings Uganda — Local linen wholesaler and retailer serving hotels and lodges; bedsheets, duvets, pillows, protectors, towels and bathrobes. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S191')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Solace Hotel Supplies','Solace Hotel Supplies','SH',
  '+256701215253',null,'+256701215253','Kamu Kamu Plaza, Level 1, FF13, Kampala','kampala',
  'Solace Hotel Supplies — Local specialist supplier of hotel bed/bath linen, kitchenware, curtains, mosquito nets and tissue; directory-listed contact. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S228')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Troven Enterprises – SMC Ltd','Troven Enterprises – SMC Ltd','TE',
  '+256756486177',null,'+256756486177','Kampala, Uganda; confirm business premises','kampala',
  'Troven Enterprises – SMC Ltd — Kampala institutional supplier of office stationery, printer consumables, bulk cleaning materials and branded merchandise. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S223')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Laika African Store Ltd','Laika African Store Ltd','LA',
  '+256701622241','+256785626066','+256701622241','Kampala, Uganda; confirm shop address','kampala',
  'Laika African Store Ltd — Uganda manufacturer of custom African-fabric bags: backpacks, laptop, travel, tote, shoulder and workshop bags. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S249')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Kampala Bags','Kampala Bags','KB',
  '+256755951244',null,'+256755951244','Wilson Road, Kampala','kampala',
  'Kampala Bags — Local specialist bag dealer with luggage, duffel, laptop, school, tote and travel bags; bulk terms require confirmation. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S250')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Jumla Stores','Jumla Stores','JS',
  '+256752208878',null,'+256752208878','Plot 59 William Street, Discover Plaza, Ground Floor, Shop F7, Kampala','kampala',
  'Jumla Stores — Local bulk cleaning and janitorial supplies distributor serving businesses and institutions; cleaning chemicals, tools, waste bins and safety wear. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S220')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Imperial Tissue Ltd','Imperial Tissue Ltd','IT',
  '+256784492525','+256741048488','+256784492525','Plot 84–87 Block 112, Kampala Industrial & Business Park, Namanve','kampala',
  'Imperial Tissue Ltd — Local tissue manufacturer with direct wholesale/HORECA sales. Toilet paper, kitchen towels, napkins and serviettes. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S143')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Notable Supplies Ltd','Notable Supplies Ltd','NS',
  '+256705226314','+256776112454','+256705226314','Plot 37–39, Ntinda, Kampala','kampala',
  'Notable Supplies Ltd — Local institutional supplier of janitorial equipment, dispensers, tissue, cleaning consumables and waste bins. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S144')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','TrueTech Water Solutions','TrueTech Water Solutions','TW',
  '+256773346417','+256705033652','+256773346417','Kabusu MM Building, Kampala–Masaka Road','kampala',
  'TrueTech Water Solutions — Kampala equipment supplier offering water pumps, pressure washers, wet/dry vacuums and floor-scrubbing machines. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S243')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Water and Power Equipment Uganda Ltd','Water and Power Equipment Uganda Ltd','WA',
  '+256703894856','+256782977211','+256703894856','Namuwongo Road, Industrial Area, opposite Kalsa Engineering Works; Essteria Building, Plot 19/23 Entebbe Road, Kampala','kampala',
  'Water and Power Equipment Uganda Ltd — Local equipment dealer for cleaning machines, carpet cleaners, scrubber-driers, pressure washers, pumps and garden equipment. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S244')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Blitz Packaging Ltd','Blitz Packaging Ltd','BP',
  '+256756958995',null,'+256756958995','Plot 20–22 Nalukolongo Ring Road, Kampala','kampala',
  'Blitz Packaging Ltd — Local flexible-packaging manufacturer. Bags, milk/yoghurt pouches, films, wrappers and liners. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S180')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Visionneuse Enterprises Ltd','Visionneuse Enterprises Ltd','VE',
  '+256702050359','+256782050349','+256702050359','Seroma Shoppers Mall, Kampala','kampala',
  'Visionneuse Enterprises Ltd — Local manufacturer of personal-care products, soaps, detergents and chemical solutions. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S093')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Mambo Freshy Amenities','Mambo Freshy Amenities','MF',
  '+256774864664',null,'+256774864664','Zana, Suuna Road, JL LEE Apartments C6','kampala',
  'Mambo Freshy Amenities — Uganda hotel-amenity importer and distributor; toiletries, dental kits, shower caps, slippers and dispensers. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S230')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Labtech Medical Supplies','Labtech Medical Supplies','LM',
  '+256749000477','+256393194179','+256749000477','Plot 80 Ben Kiwanuka Street, Kampala','kampala',
  'Labtech Medical Supplies — Local distributor of medical/laboratory equipment, consumables, diagnostics, PPE and dental supplies. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S098')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Laboratory World Ltd','Laboratory World Ltd','LW',
  '+256700272866','+256702149840','+256700272866','Sunset Arcade, Wilson Road, 2nd Floor Room 18, Kampala','kampala',
  'Laboratory World Ltd — Local distributor of laboratory equipment, diagnostic reagents and hospital consumables. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S124')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','DAAF World Services Ltd','DAAF World Services Ltd','DW',
  '+256700767839','+256782742314','+256700767839','Khatija Towers, Bombo Road, Wandegeya, Kampala','kampala',
  'DAAF World Services Ltd — Importer and wholesaler of medical/surgical products, rehabilitation aids and lab equipment. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S095')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Full Health and Home Care','Full Health and Home Care','FH',
  '+256758778867','+256701603444','+256758778867','Uganda; confirm Kampala office address','kampala',
  'Full Health and Home Care — Uganda supplier of medical equipment, surgical products and laboratory consumables. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S096')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Mu Pharma Co SMC Ltd','Mu Pharma Co SMC Ltd','MP',
  '+256777666725',null,'+256777666725','Bombo Road, opposite Kobil fuel station, Kampala','kampala',
  'Mu Pharma Co SMC Ltd — Uganda importer and wholesaler of medical equipment, surgical tools and sundries. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S097')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Laboratory Needs Solution Ltd','Laboratory Needs Solution Ltd','LN',
  '+256392916565','+256392177199','+256392916565','Plot 212 Nsalo Road, Old Kampala, P.O. Box 10341','kampala',
  'Laboratory Needs Solution Ltd — Uganda laboratory equipment, medical devices, diagnostic equipment and consumables distributor. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S211')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Standard Medical Supplies Co Ltd','Standard Medical Supplies Co Ltd','SM',
  '+256200906826',null,'+256200906826','Hoima Road, Nansana Masitowa, Bank of Africa Building, First Floor F1-08, opposite Kenjoy Supermarket','hoima',
  'Standard Medical Supplies Co Ltd — Uganda medical and laboratory equipment, diagnostic products, reagents, first aid and medical consumables supplier. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S212')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Avenex Uganda','Avenex Uganda','AU',
  '+256744254374','+256779256670','+256744254374',null,'kampala',
  'Avenex Uganda — Local wholesale/retail scholastic, stationery, office supplies, electronics and general merchandise distributor. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S222')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Sai Office Uganda','Sai Office Uganda','SO',
  '+256740039342','+256414251516','+256740039342','Plot 213 & 64 Meera Close, 6th Street Industrial Area, Kampala','kampala',
  'Sai Office Uganda — Local distributor of branded stationery, filing, desk accessories and presentation products. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S102')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','AGRITRADE Uganda / BOGRAJE AGRITRADE Ltd','AGRITRADE Uganda / BOGRAJE AGRITRADE Ltd','AU',
  '+256392134343','+256792914325','+256392134343','Plot 1643 Valley Road, Ntinda Kigowa, Kampala','kampala',
  'AGRITRADE Uganda / BOGRAJE AGRITRADE Ltd — Uganda sourcing/import supplier of packaging materials and filling, sealing, wrapping, coding and weighing equipment. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S171')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Nile Plastic Industries Ltd','Nile Plastic Industries Ltd','NP',
  '+256312263534','+256414271070','+256312263534','Plot 24 Walusimbi Mpanga Road, Nalukolongo, Masaka Road, Kampala','kampala',
  'Nile Plastic Industries Ltd — Local manufacturer of plastic bags, wrapping films and food-packaging products. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S103')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Makap Uganda Ltd','Makap Uganda Ltd','MU',
  '+256740155004',null,'+256740155004','Block 44 Plot 91, Gonve, Nsanja Parish. Factory: Katosi, Mukono','mukono',
  'Makap Uganda Ltd — Local flexible-plastic packaging manufacturer supplying films, bags and sleeves. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S106')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Sim Packaging Solutions (U) Ltd','Sim Packaging Solutions (U) Ltd','SP',
  '+256312165751',null,'+256312165751','Plot 4454, Movit Road, Zana, off Entebbe Road','entebbe',
  'Sim Packaging Solutions (U) Ltd — Uganda manufacturer of plastic packaging: buckets, caps, jars, HDPE/PET bottles, jerrycans and preforms. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S226')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Cottfield Group — Plastics','Cottfield Group — Plastics','CG',
  '+256783509759','+256757657365','+256783509759','Plot 415/519, Block 2, Bulangira, Kibuku District; P.O. Box 1333 Mbale','mbale',
  'Cottfield Group — Plastics — Uganda plastics manufacturer using blow moulding; jerrycans, drums, basins and containers up to 30 litres. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S227')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Nabukka Plastics Industries','Nabukka Plastics Industries','NP',
  '+256772440815','+256702440815','+256772440815','Bweyogerere–Namanve, off Jinja Road, Kazinga Zone, Mukono','mukono',
  'Nabukka Plastics Industries — Local manufacturer of plastic bottles, cosmetic containers, spray containers and jerrycans. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S138')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','PACKIT Packaging','PACKIT Packaging','PP',
  '+256769473614',null,'+256769473614',null,'kampala',
  'PACKIT Packaging — Ugandan bulk packaging supplier. Published MOQ of 1,000 pieces for listed jars, bottles, small buckets and jerrycans. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S140')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Bfresh Packaging Solutions','Bfresh Packaging Solutions','BP',
  '+256756710197','+256782498715','+256756710197','L1-23 Mabirizi Complex, Kampala Road, Kampala','kampala',
  'Bfresh Packaging Solutions — Local wholesale distributor of cosmetic packaging: glass bottles, jars, pumps, droppers and tubes. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S139')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Makss Packaging Industries Ltd','Makss Packaging Industries Ltd','MP',
  '+256701349936','+256758122133','+256701349936','Plot 41 Mukabya Close, Nakasero Industrial Area, Kampala','kampala',
  'Makss Packaging Industries Ltd — Local carton manufacturer and packaging-system dealer. Strapping rolls, tools, machines, tapes and spares. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S182')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Statpack Uganda Ltd','Statpack Uganda Ltd','SU',
  '+256757345228','+256709753754','+256757345228','Plot 140, Sixth Street, Industrial Area, Kampala','kampala',
  'Statpack Uganda Ltd — Uganda-based packaging distributor. Tapes, films, strapping, wrapping/sealing machines, coding and conveyors. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S183')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Gawam Industries','Gawam Industries','GI',
  '+256200911497',null,'+256200911497','Plot 1042 Block 33, Mutundwe Kiyimba Road, Nalukolongo Industrial Area, Kampala','kampala',
  'Gawam Industries — Uganda packaging manufacturer. ABLE foil, cling film, sealing and masking tapes. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S107')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Amazon Concepts Uganda Ltd','Amazon Concepts Uganda Ltd','AC',
  '+256784679761','+256703502344','+256784679761','Wandegeya Market, South Wing, Level 2, Room 176, Kampala','kampala',
  'Amazon Concepts Uganda Ltd — Local wholesaler of bags, sacks, food wrapping, printed packaging and cartons. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S141')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Safequip Safety Company Ltd','Safequip Safety Company Ltd','SS',
  '+256756926140','+256776926140','+256756926140','Lico Holdings Building, Floor 2 Shop B22, Kireka Trading Centre, opposite Shell, Namugongo Road','kampala',
  'Safequip Safety Company Ltd — Specialist PPE and workwear supplier serving businesses and resellers. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S108')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Jaywab Solutions Ltd','Jaywab Solutions Ltd','JS',
  '+256758678090','+256393001235','+256758678090','Allianz Hotels, Ground Floor, Kampala','kampala',
  'Jaywab Solutions Ltd — Specialist safety-wear and PPE supplier with published product prices. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S109')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Aqua Solutions International Ltd','Aqua Solutions International Ltd','AS',
  '+256772606898','+256751121286','+256772606898','Mbogo Road, Kampala; confirm premises before visiting','kampala',
  'Aqua Solutions International Ltd — Uganda supplier of water-treatment and water-testing products. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S113')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Hydraulic and Sanitation Consult Ltd (HYDSAN)','Hydraulic and Sanitation Consult Ltd (HYDSAN)','HA',
  '+256772434822','+256752434822','+256772434822','Plot 205 Block 219, Margherita Close, Najeera 2, Kira Municipality','kampala',
  'Hydraulic and Sanitation Consult Ltd (HYDSAN) — Ugandan water/wastewater engineering supplier. Treatment plants, shredders, separators and compost systems. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S152')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Security Shark','Security Shark','SS',
  '+256706188199',null,'+256706188199','Uganda; confirm Kampala sales-office address','kampala',
  'Security Shark — Local security supplier serving installers and distributors. CCTV, access, alarms and networking. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S122')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','KIBS Systems Ltd','KIBS Systems Ltd','KS',
  '+256706791125','+256393114905','+256706791125','1st Floor Koli House, Ntinda–Kiwatule Road, Kampala','kampala',
  'KIBS Systems Ltd — Local electronic-security supplier/integrator. CCTV, alarms, gates, electric fencing, access control and PABX. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S178')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Cresco Supplies Ltd','Cresco Supplies Ltd','CS',
  '+256755501118',null,'+256755501118','Aha Towers, 4th Floor, Plot 7 Lourdel Road, Nakasero, Kampala','kampala',
  'Cresco Supplies Ltd — Specialist supplier of commercial kitchens, laundries, hotel linen, crockery and hospitality supplies. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S118')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Mwonjo Commercial Equipment','Mwonjo Commercial Equipment','MC',
  '+256784690421',null,'+256784690421','Silva Arcade, opposite YMCA, Kampala','kampala',
  'Mwonjo Commercial Equipment — Local manufacturer/fabricator and supplier of commercial kitchen and stainless-steel equipment. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S119')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','House of Stainless Ltd','House of Stainless Ltd','HO',
  '+256701440056',null,'+256701440056','Katwe, Kampala','kampala',
  'House of Stainless Ltd — Local manufacturer and wholesaler of commercial kitchen, bakery, refrigeration and stainless-steel equipment. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S146')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Kitchen Kingz Fabrication Company Ltd','Kitchen Kingz Fabrication Company Ltd','KK',
  '+256780884736','+256709837829','+256780884736','Bweyogerere workshop, Wakiso. Mbuya contact office, Kampala; confirm collection site','kampala',
  'Kitchen Kingz Fabrication Company Ltd — Local fabricator/importer of commercial kitchen tables, sinks, hoods, shelving, ranges, bakery equipment and refrigeration. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S145')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Fujian Industries Park Ltd','Fujian Industries Park Ltd','FI',
  '+256708359999','+256783599999','+256708359999',null,'kampala',
  'Fujian Industries Park Ltd — Local furniture manufacturer and wholesaler. Home, office, outdoor and metal furniture. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S080')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Othee Technologies Co Ltd','Othee Technologies Co Ltd','OT',
  '+256394896840',null,'+256394896840','Kampala, Uganda; confirm office street address','kampala',
  'Othee Technologies Co Ltd — Local technology integrator and hardware supplier. Networking, telecom, CCTV, access control and Starlink. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S148')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Science Logistics Ltd','Science Logistics Ltd','SL',
  '+256393206314',null,'+256393206314','Plot 1274 Kinyolo Road, Muyenga, Kampala','kampala',
  'Science Logistics Ltd — Uganda laboratory supplier. Instruments, analytical chemicals, reagents and consumables. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S123')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Livan Lab Supplies Uganda Ltd','Livan Lab Supplies Uganda Ltd','LL',
  '+256772248260',null,'+256772248260','B8, Ivory Plaza, Wilson Road, Kampala','kampala',
  'Livan Lab Supplies Uganda Ltd — Local distributor of laboratory equipment, diagnostic analysers, reagents and consumables. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S125')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Prompt Supply 2011','Prompt Supply 2011','PS',
  '+256741240791','+256707481438','+256741240791','Vindax Plaza, Plot 172/174, Sixth Street, Kampala','kampala',
  'Prompt Supply 2011 — Uganda furniture manufacturer and bulk stationery distributor for institutions and businesses. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S083')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Amira Interiors Hub','Amira Interiors Hub','AI',
  '+256749040672',null,'+256749040672','Industrial Area, Kampala; confirm street address','kampala',
  'Amira Interiors Hub — Local specialist supplier of PVC wall/ceiling panels and decorative interior materials. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S126')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Pinnacle Concepts Ltd','Pinnacle Concepts Ltd','PC',
  '+256776497329','+256701497329','+256776497329','Pinnacle House, Plot 1075 Farm Road, Kyambogo, next to Trinity Hostel','kampala',
  'Pinnacle Concepts Ltd — Local home/office furniture supplier, with custom products, curtains and blinds. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S084')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Bokmak Distributors Ltd','Bokmak Distributors Ltd','BD',
  '+256392081550','+256752838712','+256392081550','Kampala interior-fittings supplier: partitions, blinds, furniture, lighting, gypsum and carpet fitting. Range lead; exact item and stock unconfirmed.','kampala',
  'Bokmak Distributors Ltd — Kampala interior-fittings supplier: partitions, blinds, furniture, lighting, gypsum and carpet fitting. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S229')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Incise Uganda Ltd','Incise Uganda Ltd','IU',
  '+256701279865','+256772227196','+256701279865','Plot 176, 6th Street, Industrial Area, Kampala','kampala',
  'Incise Uganda Ltd — Local manufacturer and supplier of decorative wall and floor finishes, including hardwood flooring; directory-listed contact. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S248')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into accounts (role, business_type, tier, company, trade_name, initials,
  phone, alt_phone, whatsapp_phone, address, district_id, about, coverage,
  supplier_state, import_source, import_code)
values ('supplier','trader','free','Sani Engineering & Automation Ltd','Sani Engineering & Automation Ltd','SE',
  '+256759853704','+256781118767','+256759853704','Plot 705, Mawanda Road, Tirupati House, Kampala','kampala',
  'Sani Engineering & Automation Ltd — Uganda manufacturer/assembler and supplier of industrial weighing, allied automation, fire equipment, CCTV and networking systems. Range lead; exact item and stock unconfirmed. Listed from a Uganda B2B supplier directory; details not yet confirmed by the business.','Uganda','approved','uganda-b2b','S242')
on conflict (import_code) do update set
  company=excluded.company,
  phone=coalesce(accounts.phone,excluded.phone),
  alt_phone=coalesce(accounts.alt_phone,excluded.alt_phone),
  address=coalesce(nullif(accounts.address,''),excluded.address),
  about=coalesce(nullif(accounts.about,''),excluded.about);

insert into account_registration (account_id, overall_state)
select id, 'pending' from accounts where import_source = 'uganda-b2b'
on conflict (account_id) do nothing;

commit;

notify pgrst, 'reload schema';

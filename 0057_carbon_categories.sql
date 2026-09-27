-- Carbon platform · categories from the Uganda B2B workbook
--
-- 36 main categories and 359 subcategories. 23 of the mains match trades your
-- database already holds and are upserted onto the SAME id, so existing
-- listings keep their category. 13 are new.
--
-- Subcategory ids are prefixed with their parent (cement-aggregates--sand),
-- because two trades can legitimately share a subcategory name.
--
-- Safe to re-run.

begin;

insert into categories (id, name, parent_id, sort) values ('agriculture-produce', 'Agriculture & Produce', null, 100)
on conflict (id) do update set name = excluded.name;
insert into categories (id, name, parent_id, sort) values ('agro-inputs-seeds', 'Agro Inputs & Seeds', null, 100)
on conflict (id) do update set name = excluded.name;
insert into categories (id, name, parent_id, sort) values ('food-beverage', 'Food & Beverage Wholesale', null, 100)
on conflict (id) do update set name = excluded.name;
insert into categories (id, name, parent_id, sort) values ('livestock-feeds', 'Livestock & Feeds', null, 100)
on conflict (id) do update set name = excluded.name;
insert into categories (id, name, parent_id, sort) values ('building-construction', 'Building & Construction', null, 100)
on conflict (id) do update set name = excluded.name;
insert into categories (id, name, parent_id, sort) values ('cement-aggregates', 'Cement & Aggregates', null, 100)
on conflict (id) do update set name = excluded.name;
insert into categories (id, name, parent_id, sort) values ('steel-metal', 'Steel & Metal', null, 100)
on conflict (id) do update set name = excluded.name;
insert into categories (id, name, parent_id, sort) values ('hardware-tools', 'Hardware & Tools', null, 100)
on conflict (id) do update set name = excluded.name;
insert into categories (id, name, parent_id, sort) values ('roofing-ceilings', 'Roofing & Ceilings', null, 100)
on conflict (id) do update set name = excluded.name;
insert into categories (id, name, parent_id, sort) values ('electrical-lighting', 'Electrical & Lighting', null, 100)
on conflict (id) do update set name = excluded.name;
insert into categories (id, name, parent_id, sort) values ('electronics', 'Electronics', null, 100)
on conflict (id) do update set name = excluded.name;
insert into categories (id, name, parent_id, sort) values ('solar-power', 'Solar & Power', null, 100)
on conflict (id) do update set name = excluded.name;
insert into categories (id, name, parent_id, sort) values ('plumbing-sanitary', 'Plumbing & Sanitary', null, 100)
on conflict (id) do update set name = excluded.name;
insert into categories (id, name, parent_id, sort) values ('paints-finishes', 'Paints & Finishes', null, 100)
on conflict (id) do update set name = excluded.name;
insert into categories (id, name, parent_id, sort) values ('chemicals-industrial', 'Chemicals & Industrial', null, 100)
on conflict (id) do update set name = excluded.name;
insert into categories (id, name, parent_id, sort) values ('auto-parts', 'Auto Parts', null, 100)
on conflict (id) do update set name = excluded.name;
insert into categories (id, name, parent_id, sort) values ('automotive-vehicles-and-commercial-equipment', 'Automotive Vehicles & Commercial Equipment', null, 100)
on conflict (id) do update set name = excluded.name;
insert into categories (id, name, parent_id, sort) values ('machinery-and-industrial-equipment', 'Machinery & Industrial Equipment', null, 100)
on conflict (id) do update set name = excluded.name;
insert into categories (id, name, parent_id, sort) values ('construction-machinery-and-equipment', 'Construction Machinery & Equipment', null, 100)
on conflict (id) do update set name = excluded.name;
insert into categories (id, name, parent_id, sort) values ('agriculture-machinery-and-equipment', 'Agriculture Machinery & Equipment', null, 100)
on conflict (id) do update set name = excluded.name;
insert into categories (id, name, parent_id, sort) values ('furniture-fittings', 'Furniture & Fittings', null, 100)
on conflict (id) do update set name = excluded.name;
insert into categories (id, name, parent_id, sort) values ('textiles-apparel', 'Textiles & Apparel', null, 100)
on conflict (id) do update set name = excluded.name;
insert into categories (id, name, parent_id, sort) values ('cleaning-hygiene', 'Cleaning & Hygiene', null, 100)
on conflict (id) do update set name = excluded.name;
insert into categories (id, name, parent_id, sort) values ('medical-supplies', 'Medical Supplies', null, 100)
on conflict (id) do update set name = excluded.name;
insert into categories (id, name, parent_id, sort) values ('stationery-printing', 'Stationery & Printing', null, 100)
on conflict (id) do update set name = excluded.name;
insert into categories (id, name, parent_id, sort) values ('packaging', 'Packaging & Packaging Materials', null, 100)
on conflict (id) do update set name = excluded.name;
insert into categories (id, name, parent_id, sort) values ('safety-ppe', 'Safety & PPE', null, 100)
on conflict (id) do update set name = excluded.name;
insert into categories (id, name, parent_id, sort) values ('water-treatment-and-waste-management', 'Water Treatment & Waste Management', null, 100)
on conflict (id) do update set name = excluded.name;
insert into categories (id, name, parent_id, sort) values ('office-and-business-supplies', 'Office & Business Supplies', null, 100)
on conflict (id) do update set name = excluded.name;
insert into categories (id, name, parent_id, sort) values ('ict-and-telecom-equipment', 'ICT & Telecom Equipment', null, 100)
on conflict (id) do update set name = excluded.name;
insert into categories (id, name, parent_id, sort) values ('hospitality-and-catering-supplies', 'Hospitality & Catering Supplies', null, 100)
on conflict (id) do update set name = excluded.name;
insert into categories (id, name, parent_id, sort) values ('security-and-surveillance', 'Security & Surveillance', null, 100)
on conflict (id) do update set name = excluded.name;
insert into categories (id, name, parent_id, sort) values ('laboratory-and-scientific-equipment', 'Laboratory & Scientific Equipment', null, 100)
on conflict (id) do update set name = excluded.name;
insert into categories (id, name, parent_id, sort) values ('furniture-and-interior-products', 'Furniture & Interior Products', null, 100)
on conflict (id) do update set name = excluded.name;
insert into categories (id, name, parent_id, sort) values ('packaging-machinery', 'Packaging Machinery', null, 100)
on conflict (id) do update set name = excluded.name;
insert into categories (id, name, parent_id, sort) values ('other-industrial-supplies', 'Other Industrial Supplies', null, 100)
on conflict (id) do update set name = excluded.name;

-- 359 subcategories
insert into categories (id, name, parent_id, sort) values ('agriculture-produce--cereals-and-grains', 'Cereals & grains', 'agriculture-produce', 200)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('agriculture-produce--pulses', 'Pulses', 'agriculture-produce', 201)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('agriculture-produce--oilseeds', 'Oilseeds', 'agriculture-produce', 202)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('agriculture-produce--roots-and-tubers', 'Roots & tubers', 'agriculture-produce', 203)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('agriculture-produce--fresh-vegetables', 'Fresh vegetables', 'agriculture-produce', 204)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('agriculture-produce--leafy-vegetables', 'Leafy vegetables', 'agriculture-produce', 205)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('agriculture-produce--fresh-fruits', 'Fresh fruits', 'agriculture-produce', 206)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('agriculture-produce--tropical-and-specialty-fruits', 'Tropical & specialty fruits', 'agriculture-produce', 207)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('agriculture-produce--coffee-and-cocoa', 'Coffee & cocoa', 'agriculture-produce', 208)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('agriculture-produce--tea-and-plantation-crops', 'Tea & plantation crops', 'agriculture-produce', 209)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('agriculture-produce--dried-produce', 'Dried produce', 'agriculture-produce', 210)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('agriculture-produce--spices-and-herbs', 'Spices & herbs', 'agriculture-produce', 211)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('agriculture-produce--horticulture', 'Horticulture', 'agriculture-produce', 212)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('agriculture-produce--expanded-product-families', 'Expanded product families', 'agriculture-produce', 213)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('agro-inputs-seeds--maize-seeds', 'Maize seeds', 'agro-inputs-seeds', 214)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('agro-inputs-seeds--cereal-seeds', 'Cereal seeds', 'agro-inputs-seeds', 215)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('agro-inputs-seeds--legume-seeds', 'Legume seeds', 'agro-inputs-seeds', 216)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('agro-inputs-seeds--vegetable-seeds', 'Vegetable seeds', 'agro-inputs-seeds', 217)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('agro-inputs-seeds--oilseed-seeds', 'Oilseed seeds', 'agro-inputs-seeds', 218)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('agro-inputs-seeds--planting-materials', 'Planting materials', 'agro-inputs-seeds', 219)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('agro-inputs-seeds--fertilizers', 'Fertilizers', 'agro-inputs-seeds', 220)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('agro-inputs-seeds--micronutrients', 'Micronutrients', 'agro-inputs-seeds', 221)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('agro-inputs-seeds--organic-inputs', 'Organic inputs', 'agro-inputs-seeds', 222)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('agro-inputs-seeds--crop-protection', 'Crop protection', 'agro-inputs-seeds', 223)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('agro-inputs-seeds--ipm-products', 'IPM products', 'agro-inputs-seeds', 224)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('agro-inputs-seeds--growth-regulators', 'Growth regulators', 'agro-inputs-seeds', 225)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('agro-inputs-seeds--greenhouse-inputs', 'Greenhouse inputs', 'agro-inputs-seeds', 226)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('agro-inputs-seeds--pasture-inputs', 'Pasture inputs', 'agro-inputs-seeds', 227)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('agro-inputs-seeds--expanded-product-families', 'Expanded product families', 'agro-inputs-seeds', 228)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('food-beverage--staples', 'Staples', 'food-beverage', 229)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('food-beverage--cooking-ingredients', 'Cooking ingredients', 'food-beverage', 230)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('food-beverage--edible-oils', 'Edible oils', 'food-beverage', 231)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('food-beverage--meat', 'Meat', 'food-beverage', 232)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('food-beverage--fish', 'Fish', 'food-beverage', 233)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('food-beverage--fruits-and-vegetables', 'Fruits & vegetables', 'food-beverage', 234)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('food-beverage--beverages', 'Beverages', 'food-beverage', 235)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('food-beverage--snacks', 'Snacks', 'food-beverage', 236)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('food-beverage--frozen-foods', 'Frozen foods', 'food-beverage', 237)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('food-beverage--canned-foods', 'Canned foods', 'food-beverage', 238)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('food-beverage--condiments', 'Condiments', 'food-beverage', 239)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('food-beverage--specialty-foods', 'Specialty foods', 'food-beverage', 240)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('food-beverage--expanded-product-families', 'Expanded product families', 'food-beverage', 241)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('livestock-feeds--poultry-feed', 'Poultry feed', 'livestock-feeds', 242)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('livestock-feeds--cattle-feed', 'Cattle feed', 'livestock-feeds', 243)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('livestock-feeds--pig-feed', 'Pig feed', 'livestock-feeds', 244)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('livestock-feeds--goat-and-sheep-feed', 'Goat & sheep feed', 'livestock-feeds', 245)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('livestock-feeds--fodder', 'Fodder', 'livestock-feeds', 246)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('livestock-feeds--supplements', 'Supplements', 'livestock-feeds', 247)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('livestock-feeds--poultry-equipment', 'Poultry equipment', 'livestock-feeds', 248)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('livestock-feeds--dairy-equipment', 'Dairy equipment', 'livestock-feeds', 249)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('livestock-feeds--expanded-product-families', 'Expanded product families', 'livestock-feeds', 250)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('building-construction--site-and-earthworks', 'Site & earthworks', 'building-construction', 251)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('building-construction--concrete', 'Concrete', 'building-construction', 252)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('building-construction--masonry', 'Masonry', 'building-construction', 253)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('building-construction--reinforcement', 'Reinforcement', 'building-construction', 254)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('building-construction--formwork', 'Formwork', 'building-construction', 255)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('building-construction--scaffolding', 'Scaffolding', 'building-construction', 256)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('building-construction--waterproofing', 'Waterproofing', 'building-construction', 257)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('building-construction--construction-chemicals', 'Construction chemicals', 'building-construction', 258)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('building-construction--flooring', 'Flooring', 'building-construction', 259)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('building-construction--doors-and-windows', 'Doors & windows', 'building-construction', 260)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('building-construction--interior-construction', 'Interior construction', 'building-construction', 261)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('building-construction--construction-hardware', 'Construction hardware', 'building-construction', 262)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('building-construction--drainage', 'Drainage', 'building-construction', 263)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('building-construction--structural-products', 'Structural products', 'building-construction', 264)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('building-construction--site-consumables', 'Site consumables', 'building-construction', 265)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('building-construction--expanded-product-families', 'Expanded product families', 'building-construction', 266)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('cement-aggregates--cement-types', 'Cement types', 'cement-aggregates', 267)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('cement-aggregates--concrete-mixes', 'Concrete mixes', 'cement-aggregates', 268)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('cement-aggregates--sand', 'Sand', 'cement-aggregates', 269)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('cement-aggregates--aggregates', 'Aggregates', 'cement-aggregates', 270)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('cement-aggregates--road-aggregates', 'Road aggregates', 'cement-aggregates', 271)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('cement-aggregates--specialty-aggregates', 'Specialty aggregates', 'cement-aggregates', 272)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('cement-aggregates--concrete-admixtures', 'Concrete admixtures', 'cement-aggregates', 273)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('cement-aggregates--lime', 'Lime', 'cement-aggregates', 274)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('cement-aggregates--mortars', 'Mortars', 'cement-aggregates', 275)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('cement-aggregates--precast', 'Precast', 'cement-aggregates', 276)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('cement-aggregates--testing', 'Testing', 'cement-aggregates', 277)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('cement-aggregates--bulk-handling', 'Bulk handling', 'cement-aggregates', 278)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('cement-aggregates--packaging', 'Packaging', 'cement-aggregates', 279)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('cement-aggregates--quality-inputs', 'Quality inputs', 'cement-aggregates', 280)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('cement-aggregates--decorative-aggregates', 'Decorative aggregates', 'cement-aggregates', 281)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('cement-aggregates--expanded-product-families', 'Expanded product families', 'cement-aggregates', 282)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('steel-metal--structural-sections', 'Structural sections', 'steel-metal', 283)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('steel-metal--bars-and-rods', 'Bars & rods', 'steel-metal', 284)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('steel-metal--sheets-and-plates', 'Sheets & plates', 'steel-metal', 285)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('steel-metal--pipes-and-tubes', 'Pipes & tubes', 'steel-metal', 286)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('steel-metal--reinforcement', 'Reinforcement', 'steel-metal', 287)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('steel-metal--fencing', 'Fencing', 'steel-metal', 288)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('steel-metal--stainless-steel', 'Stainless steel', 'steel-metal', 289)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('steel-metal--aluminium', 'Aluminium', 'steel-metal', 290)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('steel-metal--copper-and-brass', 'Copper & brass', 'steel-metal', 291)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('steel-metal--fabrication-consumables', 'Fabrication consumables', 'steel-metal', 292)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('steel-metal--metal-fasteners', 'Metal fasteners', 'steel-metal', 293)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('steel-metal--roofing-steel', 'Roofing steel', 'steel-metal', 294)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('steel-metal--metal-products', 'Metal products', 'steel-metal', 295)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('steel-metal--wire-products', 'Wire products', 'steel-metal', 296)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('steel-metal--surface-treatment', 'Surface treatment', 'steel-metal', 297)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('steel-metal--expanded-product-families', 'Expanded product families', 'steel-metal', 298)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('hardware-tools--hand-tools', 'Hand tools', 'hardware-tools', 299)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('hardware-tools--measuring', 'Measuring', 'hardware-tools', 300)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('hardware-tools--cutting', 'Cutting', 'hardware-tools', 301)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('hardware-tools--power-tools', 'Power tools', 'hardware-tools', 302)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('hardware-tools--fasteners', 'Fasteners', 'hardware-tools', 303)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('hardware-tools--anchors', 'Anchors', 'hardware-tools', 304)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('hardware-tools--adhesives', 'Adhesives', 'hardware-tools', 305)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('hardware-tools--abrasives', 'Abrasives', 'hardware-tools', 306)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('hardware-tools--workshop', 'Workshop', 'hardware-tools', 307)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('hardware-tools--garden-tools', 'Garden tools', 'hardware-tools', 308)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('hardware-tools--plumbing-tools', 'Plumbing tools', 'hardware-tools', 309)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('hardware-tools--electrical-tools', 'Electrical tools', 'hardware-tools', 310)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('hardware-tools--masonry-tools', 'Masonry tools', 'hardware-tools', 311)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('hardware-tools--painting-tools', 'Painting tools', 'hardware-tools', 312)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('hardware-tools--ladders-and-access', 'Ladders & access', 'hardware-tools', 313)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('hardware-tools--expanded-product-families', 'Expanded product families', 'hardware-tools', 314)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('roofing-ceilings--roof-sheets', 'Roof sheets', 'roofing-ceilings', 315)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('roofing-ceilings--roof-tiles', 'Roof tiles', 'roofing-ceilings', 316)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('roofing-ceilings--roof-accessories', 'Roof accessories', 'roofing-ceilings', 317)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('roofing-ceilings--gutters', 'Gutters', 'roofing-ceilings', 318)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('roofing-ceilings--fasteners', 'Fasteners', 'roofing-ceilings', 319)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('roofing-ceilings--insulation', 'Insulation', 'roofing-ceilings', 320)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('roofing-ceilings--ceiling-boards', 'Ceiling boards', 'roofing-ceilings', 321)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('roofing-ceilings--suspended-ceilings', 'Suspended ceilings', 'roofing-ceilings', 322)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('roofing-ceilings--roof-timber', 'Roof timber', 'roofing-ceilings', 323)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('roofing-ceilings--ventilation', 'Ventilation', 'roofing-ceilings', 324)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('roofing-ceilings--roof-waterproofing', 'Roof waterproofing', 'roofing-ceilings', 325)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('roofing-ceilings--daylighting', 'Daylighting', 'roofing-ceilings', 326)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('roofing-ceilings--roof-safety', 'Roof safety', 'roofing-ceilings', 327)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('roofing-ceilings--ceiling-finishes', 'Ceiling finishes', 'roofing-ceilings', 328)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('roofing-ceilings--roof-drainage', 'Roof drainage', 'roofing-ceilings', 329)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('roofing-ceilings--expanded-product-families', 'Expanded product families', 'roofing-ceilings', 330)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('electrical-lighting--power-cables', 'Power cables', 'electrical-lighting', 331)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('electrical-lighting--wiring', 'Wiring', 'electrical-lighting', 332)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('electrical-lighting--data-cables', 'Data cables', 'electrical-lighting', 333)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('electrical-lighting--conduit', 'Conduit', 'electrical-lighting', 334)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('electrical-lighting--switchgear', 'Switchgear', 'electrical-lighting', 335)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('electrical-lighting--distribution', 'Distribution', 'electrical-lighting', 336)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('electrical-lighting--lighting', 'Lighting', 'electrical-lighting', 337)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('electrical-lighting--switches-and-sockets', 'Switches & sockets', 'electrical-lighting', 338)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('electrical-lighting--fans', 'Fans', 'electrical-lighting', 339)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('electrical-lighting--earthing', 'Earthing', 'electrical-lighting', 340)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('electrical-lighting--automation', 'Automation', 'electrical-lighting', 341)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('electrical-lighting--motors', 'Motors', 'electrical-lighting', 342)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('electrical-lighting--transformers', 'Transformers', 'electrical-lighting', 343)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('electrical-lighting--electrical-accessories', 'Electrical accessories', 'electrical-lighting', 344)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('electrical-lighting--expanded-product-families', 'Expanded product families', 'electrical-lighting', 345)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('electronics--equipment', 'Equipment', 'electronics', 346)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('electronics--consumables', 'Consumables', 'electronics', 347)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('electronics--components', 'Components', 'electronics', 348)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('electronics--installation', 'Installation', 'electronics', 349)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('electronics--protection', 'Protection', 'electronics', 350)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('electronics--maintenance', 'Maintenance', 'electronics', 351)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('electronics--expanded-product-families', 'Expanded product families', 'electronics', 352)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('solar-power--core-products', 'Core Products', 'solar-power', 353)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('solar-power--components', 'Components', 'solar-power', 354)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('solar-power--equipment', 'Equipment', 'solar-power', 355)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('solar-power--consumables', 'Consumables', 'solar-power', 356)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('solar-power--installation', 'Installation', 'solar-power', 357)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('solar-power--maintenance', 'Maintenance', 'solar-power', 358)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('solar-power--control', 'Control', 'solar-power', 359)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('solar-power--protection', 'Protection', 'solar-power', 360)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('solar-power--processing', 'Processing', 'solar-power', 361)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('solar-power--expanded-product-families', 'Expanded product families', 'solar-power', 362)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('plumbing-sanitary--water-pipes', 'Water pipes', 'plumbing-sanitary', 363)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('plumbing-sanitary--drainage', 'Drainage', 'plumbing-sanitary', 364)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('plumbing-sanitary--fittings', 'Fittings', 'plumbing-sanitary', 365)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('plumbing-sanitary--valves', 'Valves', 'plumbing-sanitary', 366)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('plumbing-sanitary--pipe-accessories', 'Pipe accessories', 'plumbing-sanitary', 367)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('plumbing-sanitary--sanitaryware', 'Sanitaryware', 'plumbing-sanitary', 368)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('plumbing-sanitary--bathroom-fittings', 'Bathroom fittings', 'plumbing-sanitary', 369)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('plumbing-sanitary--kitchen-plumbing', 'Kitchen plumbing', 'plumbing-sanitary', 370)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('plumbing-sanitary--water-tanks', 'Water tanks', 'plumbing-sanitary', 371)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('plumbing-sanitary--pumps', 'Pumps', 'plumbing-sanitary', 372)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('plumbing-sanitary--sewerage', 'Sewerage', 'plumbing-sanitary', 373)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('plumbing-sanitary--plumbing-tools', 'Plumbing tools', 'plumbing-sanitary', 374)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('plumbing-sanitary--fixtures', 'Fixtures', 'plumbing-sanitary', 375)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('plumbing-sanitary--expanded-product-families', 'Expanded product families', 'plumbing-sanitary', 376)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('paints-finishes--core-products', 'Core Products', 'paints-finishes', 377)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('paints-finishes--components', 'Components', 'paints-finishes', 378)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('paints-finishes--equipment', 'Equipment', 'paints-finishes', 379)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('paints-finishes--consumables', 'Consumables', 'paints-finishes', 380)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('paints-finishes--installation', 'Installation', 'paints-finishes', 381)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('paints-finishes--maintenance', 'Maintenance', 'paints-finishes', 382)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('paints-finishes--control', 'Control', 'paints-finishes', 383)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('paints-finishes--protection', 'Protection', 'paints-finishes', 384)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('paints-finishes--expanded-product-families', 'Expanded product families', 'paints-finishes', 385)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('chemicals-industrial--core-products', 'Core Products', 'chemicals-industrial', 386)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('chemicals-industrial--components', 'Components', 'chemicals-industrial', 387)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('chemicals-industrial--equipment', 'Equipment', 'chemicals-industrial', 388)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('chemicals-industrial--consumables', 'Consumables', 'chemicals-industrial', 389)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('chemicals-industrial--maintenance', 'Maintenance', 'chemicals-industrial', 390)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('chemicals-industrial--control', 'Control', 'chemicals-industrial', 391)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('chemicals-industrial--protection', 'Protection', 'chemicals-industrial', 392)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('chemicals-industrial--expanded-product-families', 'Expanded product families', 'chemicals-industrial', 393)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('auto-parts--core-products', 'Core Products', 'auto-parts', 394)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('auto-parts--components', 'Components', 'auto-parts', 395)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('auto-parts--equipment', 'Equipment', 'auto-parts', 396)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('auto-parts--consumables', 'Consumables', 'auto-parts', 397)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('auto-parts--installation', 'Installation', 'auto-parts', 398)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('auto-parts--maintenance', 'Maintenance', 'auto-parts', 399)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('auto-parts--control', 'Control', 'auto-parts', 400)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('auto-parts--protection', 'Protection', 'auto-parts', 401)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('auto-parts--processing', 'Processing', 'auto-parts', 402)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('auto-parts--expanded-product-families', 'Expanded product families', 'auto-parts', 403)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('automotive-vehicles-and-commercial-equipment--vehicles-core', 'Vehicles/Core', 'automotive-vehicles-and-commercial-equipment', 404)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('automotive-vehicles-and-commercial-equipment--equipment', 'Equipment', 'automotive-vehicles-and-commercial-equipment', 405)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('automotive-vehicles-and-commercial-equipment--systems', 'Systems', 'automotive-vehicles-and-commercial-equipment', 406)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('automotive-vehicles-and-commercial-equipment--accessories', 'Accessories', 'automotive-vehicles-and-commercial-equipment', 407)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('automotive-vehicles-and-commercial-equipment--service', 'Service', 'automotive-vehicles-and-commercial-equipment', 408)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('automotive-vehicles-and-commercial-equipment--replacement-parts', 'Replacement Parts', 'automotive-vehicles-and-commercial-equipment', 409)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('automotive-vehicles-and-commercial-equipment--control', 'Control', 'automotive-vehicles-and-commercial-equipment', 410)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('automotive-vehicles-and-commercial-equipment--expanded-product-families', 'Expanded product families', 'automotive-vehicles-and-commercial-equipment', 411)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('machinery-and-industrial-equipment--vehicles-core', 'Vehicles/Core', 'machinery-and-industrial-equipment', 412)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('machinery-and-industrial-equipment--equipment', 'Equipment', 'machinery-and-industrial-equipment', 413)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('machinery-and-industrial-equipment--components', 'Components', 'machinery-and-industrial-equipment', 414)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('machinery-and-industrial-equipment--systems', 'Systems', 'machinery-and-industrial-equipment', 415)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('machinery-and-industrial-equipment--accessories', 'Accessories', 'machinery-and-industrial-equipment', 416)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('machinery-and-industrial-equipment--service', 'Service', 'machinery-and-industrial-equipment', 417)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('machinery-and-industrial-equipment--replacement-parts', 'Replacement Parts', 'machinery-and-industrial-equipment', 418)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('machinery-and-industrial-equipment--expanded-product-families', 'Expanded product families', 'machinery-and-industrial-equipment', 419)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('construction-machinery-and-equipment--vehicles-core', 'Vehicles/Core', 'construction-machinery-and-equipment', 420)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('construction-machinery-and-equipment--components', 'Components', 'construction-machinery-and-equipment', 421)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('construction-machinery-and-equipment--systems', 'Systems', 'construction-machinery-and-equipment', 422)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('construction-machinery-and-equipment--accessories', 'Accessories', 'construction-machinery-and-equipment', 423)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('construction-machinery-and-equipment--expanded-product-families', 'Expanded product families', 'construction-machinery-and-equipment', 424)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('agriculture-machinery-and-equipment--equipment', 'Equipment', 'agriculture-machinery-and-equipment', 425)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('agriculture-machinery-and-equipment--components', 'Components', 'agriculture-machinery-and-equipment', 426)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('agriculture-machinery-and-equipment--systems', 'Systems', 'agriculture-machinery-and-equipment', 427)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('agriculture-machinery-and-equipment--accessories', 'Accessories', 'agriculture-machinery-and-equipment', 428)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('agriculture-machinery-and-equipment--service', 'Service', 'agriculture-machinery-and-equipment', 429)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('agriculture-machinery-and-equipment--replacement-parts', 'Replacement Parts', 'agriculture-machinery-and-equipment', 430)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('agriculture-machinery-and-equipment--expanded-product-families', 'Expanded product families', 'agriculture-machinery-and-equipment', 431)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('furniture-fittings--vehicles-core', 'Vehicles/Core', 'furniture-fittings', 432)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('furniture-fittings--equipment', 'Equipment', 'furniture-fittings', 433)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('furniture-fittings--components', 'Components', 'furniture-fittings', 434)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('furniture-fittings--systems', 'Systems', 'furniture-fittings', 435)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('furniture-fittings--accessories', 'Accessories', 'furniture-fittings', 436)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('furniture-fittings--service', 'Service', 'furniture-fittings', 437)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('furniture-fittings--replacement-parts', 'Replacement Parts', 'furniture-fittings', 438)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('furniture-fittings--expanded-product-families', 'Expanded product families', 'furniture-fittings', 439)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('textiles-apparel--vehicles-core', 'Vehicles/Core', 'textiles-apparel', 440)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('textiles-apparel--equipment', 'Equipment', 'textiles-apparel', 441)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('textiles-apparel--components', 'Components', 'textiles-apparel', 442)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('textiles-apparel--systems', 'Systems', 'textiles-apparel', 443)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('textiles-apparel--service', 'Service', 'textiles-apparel', 444)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('textiles-apparel--expanded-product-families', 'Expanded product families', 'textiles-apparel', 445)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('cleaning-hygiene--core', 'Core', 'cleaning-hygiene', 446)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('cleaning-hygiene--equipment', 'Equipment', 'cleaning-hygiene', 447)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('cleaning-hygiene--consumables', 'Consumables', 'cleaning-hygiene', 448)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('cleaning-hygiene--installation', 'Installation', 'cleaning-hygiene', 449)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('cleaning-hygiene--maintenance', 'Maintenance', 'cleaning-hygiene', 450)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('cleaning-hygiene--expanded-product-families', 'Expanded product families', 'cleaning-hygiene', 451)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('medical-supplies--core', 'Core', 'medical-supplies', 452)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('medical-supplies--equipment', 'Equipment', 'medical-supplies', 453)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('medical-supplies--consumables', 'Consumables', 'medical-supplies', 454)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('medical-supplies--components', 'Components', 'medical-supplies', 455)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('medical-supplies--installation', 'Installation', 'medical-supplies', 456)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('medical-supplies--protection', 'Protection', 'medical-supplies', 457)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('medical-supplies--maintenance', 'Maintenance', 'medical-supplies', 458)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('medical-supplies--expanded-product-families', 'Expanded product families', 'medical-supplies', 459)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('stationery-printing--core', 'Core', 'stationery-printing', 460)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('stationery-printing--equipment', 'Equipment', 'stationery-printing', 461)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('stationery-printing--consumables', 'Consumables', 'stationery-printing', 462)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('stationery-printing--components', 'Components', 'stationery-printing', 463)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('stationery-printing--installation', 'Installation', 'stationery-printing', 464)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('stationery-printing--protection', 'Protection', 'stationery-printing', 465)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('stationery-printing--maintenance', 'Maintenance', 'stationery-printing', 466)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('stationery-printing--expanded-product-families', 'Expanded product families', 'stationery-printing', 467)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('packaging--core', 'Core', 'packaging', 468)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('packaging--equipment', 'Equipment', 'packaging', 469)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('packaging--consumables', 'Consumables', 'packaging', 470)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('packaging--components', 'Components', 'packaging', 471)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('packaging--installation', 'Installation', 'packaging', 472)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('packaging--protection', 'Protection', 'packaging', 473)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('packaging--maintenance', 'Maintenance', 'packaging', 474)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('packaging--expanded-product-families', 'Expanded product families', 'packaging', 475)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('safety-ppe--core', 'Core', 'safety-ppe', 476)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('safety-ppe--equipment', 'Equipment', 'safety-ppe', 477)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('safety-ppe--consumables', 'Consumables', 'safety-ppe', 478)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('safety-ppe--components', 'Components', 'safety-ppe', 479)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('safety-ppe--installation', 'Installation', 'safety-ppe', 480)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('safety-ppe--protection', 'Protection', 'safety-ppe', 481)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('safety-ppe--maintenance', 'Maintenance', 'safety-ppe', 482)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('safety-ppe--expanded-product-families', 'Expanded product families', 'safety-ppe', 483)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('water-treatment-and-waste-management--core', 'Core', 'water-treatment-and-waste-management', 484)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('water-treatment-and-waste-management--equipment', 'Equipment', 'water-treatment-and-waste-management', 485)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('water-treatment-and-waste-management--consumables', 'Consumables', 'water-treatment-and-waste-management', 486)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('water-treatment-and-waste-management--components', 'Components', 'water-treatment-and-waste-management', 487)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('water-treatment-and-waste-management--installation', 'Installation', 'water-treatment-and-waste-management', 488)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('water-treatment-and-waste-management--expanded-product-families', 'Expanded product families', 'water-treatment-and-waste-management', 489)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('office-and-business-supplies--vehicles-core', 'Vehicles/Core', 'office-and-business-supplies', 490)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('office-and-business-supplies--equipment', 'Equipment', 'office-and-business-supplies', 491)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('office-and-business-supplies--components', 'Components', 'office-and-business-supplies', 492)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('office-and-business-supplies--systems', 'Systems', 'office-and-business-supplies', 493)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('office-and-business-supplies--accessories', 'Accessories', 'office-and-business-supplies', 494)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('office-and-business-supplies--service', 'Service', 'office-and-business-supplies', 495)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('office-and-business-supplies--replacement-parts', 'Replacement Parts', 'office-and-business-supplies', 496)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('office-and-business-supplies--expanded-product-families', 'Expanded product families', 'office-and-business-supplies', 497)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('ict-and-telecom-equipment--vehicles-core', 'Vehicles/Core', 'ict-and-telecom-equipment', 498)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('ict-and-telecom-equipment--equipment', 'Equipment', 'ict-and-telecom-equipment', 499)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('ict-and-telecom-equipment--components', 'Components', 'ict-and-telecom-equipment', 500)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('ict-and-telecom-equipment--systems', 'Systems', 'ict-and-telecom-equipment', 501)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('ict-and-telecom-equipment--accessories', 'Accessories', 'ict-and-telecom-equipment', 502)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('ict-and-telecom-equipment--service', 'Service', 'ict-and-telecom-equipment', 503)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('ict-and-telecom-equipment--replacement-parts', 'Replacement Parts', 'ict-and-telecom-equipment', 504)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('ict-and-telecom-equipment--expanded-product-families', 'Expanded product families', 'ict-and-telecom-equipment', 505)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('hospitality-and-catering-supplies--vehicles-core', 'Vehicles/Core', 'hospitality-and-catering-supplies', 506)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('hospitality-and-catering-supplies--equipment', 'Equipment', 'hospitality-and-catering-supplies', 507)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('hospitality-and-catering-supplies--components', 'Components', 'hospitality-and-catering-supplies', 508)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('hospitality-and-catering-supplies--systems', 'Systems', 'hospitality-and-catering-supplies', 509)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('hospitality-and-catering-supplies--accessories', 'Accessories', 'hospitality-and-catering-supplies', 510)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('hospitality-and-catering-supplies--service', 'Service', 'hospitality-and-catering-supplies', 511)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('hospitality-and-catering-supplies--replacement-parts', 'Replacement Parts', 'hospitality-and-catering-supplies', 512)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('hospitality-and-catering-supplies--expanded-product-families', 'Expanded product families', 'hospitality-and-catering-supplies', 513)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('security-and-surveillance--core', 'Core', 'security-and-surveillance', 514)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('security-and-surveillance--equipment', 'Equipment', 'security-and-surveillance', 515)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('security-and-surveillance--consumables', 'Consumables', 'security-and-surveillance', 516)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('security-and-surveillance--components', 'Components', 'security-and-surveillance', 517)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('security-and-surveillance--installation', 'Installation', 'security-and-surveillance', 518)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('security-and-surveillance--protection', 'Protection', 'security-and-surveillance', 519)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('security-and-surveillance--maintenance', 'Maintenance', 'security-and-surveillance', 520)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('security-and-surveillance--expanded-product-families', 'Expanded product families', 'security-and-surveillance', 521)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('laboratory-and-scientific-equipment--vehicles-core', 'Vehicles/Core', 'laboratory-and-scientific-equipment', 522)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('laboratory-and-scientific-equipment--equipment', 'Equipment', 'laboratory-and-scientific-equipment', 523)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('laboratory-and-scientific-equipment--components', 'Components', 'laboratory-and-scientific-equipment', 524)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('laboratory-and-scientific-equipment--systems', 'Systems', 'laboratory-and-scientific-equipment', 525)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('laboratory-and-scientific-equipment--accessories', 'Accessories', 'laboratory-and-scientific-equipment', 526)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('laboratory-and-scientific-equipment--service', 'Service', 'laboratory-and-scientific-equipment', 527)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('laboratory-and-scientific-equipment--replacement-parts', 'Replacement Parts', 'laboratory-and-scientific-equipment', 528)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('laboratory-and-scientific-equipment--expanded-product-families', 'Expanded product families', 'laboratory-and-scientific-equipment', 529)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('furniture-and-interior-products--vehicles-core', 'Vehicles/Core', 'furniture-and-interior-products', 530)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('furniture-and-interior-products--equipment', 'Equipment', 'furniture-and-interior-products', 531)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('furniture-and-interior-products--components', 'Components', 'furniture-and-interior-products', 532)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('furniture-and-interior-products--accessories', 'Accessories', 'furniture-and-interior-products', 533)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('furniture-and-interior-products--service', 'Service', 'furniture-and-interior-products', 534)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('furniture-and-interior-products--replacement-parts', 'Replacement Parts', 'furniture-and-interior-products', 535)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('furniture-and-interior-products--expanded-product-families', 'Expanded product families', 'furniture-and-interior-products', 536)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('packaging-machinery--vehicles-core', 'Vehicles/Core', 'packaging-machinery', 537)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('packaging-machinery--equipment', 'Equipment', 'packaging-machinery', 538)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('packaging-machinery--components', 'Components', 'packaging-machinery', 539)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('packaging-machinery--systems', 'Systems', 'packaging-machinery', 540)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('packaging-machinery--accessories', 'Accessories', 'packaging-machinery', 541)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('packaging-machinery--service', 'Service', 'packaging-machinery', 542)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('packaging-machinery--replacement-parts', 'Replacement Parts', 'packaging-machinery', 543)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('packaging-machinery--expanded-product-families', 'Expanded product families', 'packaging-machinery', 544)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('other-industrial-supplies--bearings', 'Bearings', 'other-industrial-supplies', 545)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('other-industrial-supplies--power-transmission', 'Power transmission', 'other-industrial-supplies', 546)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('other-industrial-supplies--seals', 'Seals', 'other-industrial-supplies', 547)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('other-industrial-supplies--pneumatics', 'Pneumatics', 'other-industrial-supplies', 548)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('other-industrial-supplies--hydraulics', 'Hydraulics', 'other-industrial-supplies', 549)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('other-industrial-supplies--flow-control', 'Flow control', 'other-industrial-supplies', 550)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('other-industrial-supplies--motors-and-drives', 'Motors & drives', 'other-industrial-supplies', 551)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('other-industrial-supplies--workshop-consumables', 'Workshop consumables', 'other-industrial-supplies', 552)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('other-industrial-supplies--industrial-hardware', 'Industrial hardware', 'other-industrial-supplies', 553)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('other-industrial-supplies--motors-and-electrical', 'Motors & electrical', 'other-industrial-supplies', 554)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('other-industrial-supplies--workshop-equipment', 'Workshop equipment', 'other-industrial-supplies', 555)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('other-industrial-supplies--material-handling', 'Material handling', 'other-industrial-supplies', 556)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('other-industrial-supplies--maintenance-products', 'Maintenance products', 'other-industrial-supplies', 557)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('other-industrial-supplies--expanded-product-families', 'Expanded product families', 'other-industrial-supplies', 558)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;

commit;

notify pgrst, 'reload schema';

-- Carbon platform · 31 further subcategories from the Extra Research workbook
-- Run after 0057. Safe to re-run.

begin;

insert into categories (id, name, parent_id, sort) values ('agriculture-produce--nuts', 'Nuts', 'agriculture-produce', 700)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('agriculture-produce--animal-origin-produce', 'Animal-origin produce', 'agriculture-produce', 701)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('agro-inputs-seeds--irrigation-inputs', 'Irrigation inputs', 'agro-inputs-seeds', 702)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('food-beverage--breakfast-foods', 'Breakfast foods', 'food-beverage', 703)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('food-beverage--dairy', 'Dairy', 'food-beverage', 704)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('food-beverage--bakery-products', 'Bakery products', 'food-beverage', 705)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('livestock-feeds--livestock-equipment', 'Livestock equipment', 'livestock-feeds', 706)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('livestock-feeds--beekeeping', 'Beekeeping', 'livestock-feeds', 707)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('electrical-lighting--power-quality', 'Power quality', 'electrical-lighting', 708)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('electronics--core', 'Core', 'electronics', 709)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('plumbing-sanitary--water-meters', 'Water meters', 'plumbing-sanitary', 710)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('plumbing-sanitary--water-filtration', 'Water filtration', 'plumbing-sanitary', 711)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('chemicals-industrial--installation', 'Installation', 'chemicals-industrial', 712)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('chemicals-industrial--processing', 'Processing', 'chemicals-industrial', 713)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('automotive-vehicles-and-commercial-equipment--components', 'Components', 'automotive-vehicles-and-commercial-equipment', 714)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('machinery-and-industrial-equipment--control', 'Control', 'machinery-and-industrial-equipment', 715)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('construction-machinery-and-equipment--equipment', 'Equipment', 'construction-machinery-and-equipment', 716)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('construction-machinery-and-equipment--service', 'Service', 'construction-machinery-and-equipment', 717)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('construction-machinery-and-equipment--replacement-parts', 'Replacement Parts', 'construction-machinery-and-equipment', 718)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('agriculture-machinery-and-equipment--vehicles-core', 'Vehicles/Core', 'agriculture-machinery-and-equipment', 719)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('textiles-apparel--accessories', 'Accessories', 'textiles-apparel', 720)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('textiles-apparel--replacement-parts', 'Replacement Parts', 'textiles-apparel', 721)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('cleaning-hygiene--components', 'Components', 'cleaning-hygiene', 722)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('cleaning-hygiene--protection', 'Protection', 'cleaning-hygiene', 723)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('water-treatment-and-waste-management--protection', 'Protection', 'water-treatment-and-waste-management', 724)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('water-treatment-and-waste-management--maintenance', 'Maintenance', 'water-treatment-and-waste-management', 725)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('water-treatment-and-waste-management--storage', 'Storage', 'water-treatment-and-waste-management', 726)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('ict-and-telecom-equipment--control', 'Control', 'ict-and-telecom-equipment', 727)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('furniture-and-interior-products--systems', 'Systems', 'furniture-and-interior-products', 728)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('other-industrial-supplies--filters', 'Filters', 'other-industrial-supplies', 729)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;
insert into categories (id, name, parent_id, sort) values ('other-industrial-supplies--sensors', 'Sensors', 'other-industrial-supplies', 730)
on conflict (id) do update set name = excluded.name, parent_id = excluded.parent_id;

commit;

notify pgrst, 'reload schema';

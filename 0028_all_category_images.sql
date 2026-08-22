-- Every category now has artwork shipped with the app.
--
-- Migration 0010 already mapped each category to a filename, but those files
-- were never in the repo, so 0023 overwrote the mapping with the eight images
-- that did exist and nulled the rest. All thirty files are now shipped, so the
-- full mapping is restored.
--
-- Only rows still pointing at a bundled default are touched. A photo an admin
-- uploaded through the Categories screen lives in the public-media bucket and
-- its URL does not start with 'assets/', so it is left alone.

update categories set image_url = case id
  when 'building-construction' then 'assets/categories/building-construction.avif'
  when 'cement-aggregates'     then 'assets/categories/cement-aggregates.jpg'
  when 'steel-metal'           then 'assets/categories/steel-metal.avif'
  when 'roofing-ceilings'      then 'assets/categories/roofing-ceilings.jpeg'
  when 'hardware-tools'        then 'assets/categories/hardware-tools.jpeg'
  when 'electrical-lighting'   then 'assets/categories/electrical-lighting.webp'
  when 'plumbing-sanitary'     then 'assets/categories/plumbing-sanitary.webp'
  when 'paints-finishes'       then 'assets/categories/paints-finishes.webp'
  when 'agriculture-produce'   then 'assets/categories/agriculture-produce.jpeg'
  when 'agro-inputs-seeds'     then 'assets/categories/agro-inputs-seeds.webp'
  when 'livestock-feeds'       then 'assets/categories/livestock-feeds.jpg'
  when 'food-beverage'         then 'assets/categories/food-beverage.webp'
  when 'packaging'             then 'assets/categories/packaging.jpeg'
  when 'chemicals-industrial'  then 'assets/categories/chemicals-industrial.jpg'
  when 'medical-supplies'      then 'assets/categories/medical-supplies.webp'
  when 'electronics'           then 'assets/categories/electronics.jpg'
  when 'solar-power'           then 'assets/categories/solar-power.jpeg'
  when 'auto-parts'            then 'assets/categories/auto-parts.webp'
  when 'furniture-fittings'    then 'assets/categories/furniture-fittings.jpg'
  when 'textiles-apparel'      then 'assets/categories/textiles-apparel.webp'
  when 'stationery-printing'   then 'assets/categories/stationery-printing.jpg'
  when 'cleaning-hygiene'      then 'assets/categories/cleaning-hygiene.jpeg'
  else image_url
end
where image_url is null or image_url = '' or image_url like 'assets/%';

-- Subcategories created through the admin screen, matched on name rather than
-- id because their ids carry a generated hash suffix.
update categories c set image_url = v.url
from (values
  ('examination gloves', 'assets/categories/examination-gloves.png'),
  ('face protection',    'assets/categories/face-protection.png'),
  ('workwear',           'assets/categories/workwear.png'),
  ('cement & binders',   'assets/categories/cement-binders.png')
) as v(nm, url)
where lower(c.name) = v.nm
  and (c.image_url is null or c.image_url = '' or c.image_url like 'assets/%');

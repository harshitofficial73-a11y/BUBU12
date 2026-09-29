-- Category pages timed out after the specification import.
--
-- The listing query pulls each product's specifications. product_specs had no
-- index on product_id, so for every product the database read the whole table.
-- That was fine at a few thousand rows; after 0073 added specifications to
-- 44,000 listings it ran past the time limit and the page showed "No products".
--
-- Safe to re-run.

create index if not exists product_specs_product_id_idx on public.product_specs (product_id, sort);
create index if not exists media_product_id_idx         on public.media (product_id);

analyze public.product_specs;
analyze public.media;

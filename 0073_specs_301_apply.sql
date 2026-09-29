-- Carbon platform · product specifications, apply 1 of 8
--
-- Writes the specifications for one eighth of the imported catalogue and
-- returns how many products it matched (expect roughly 5,600).
-- If the editor times out, just run this same file again.

select public.apply_catalogue_specs(0, 8) as products_updated;

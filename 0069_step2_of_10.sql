-- 0069 batch 2 of 10. Run steps 1 to 10 in any order, after step 0.
update products p
   set price = greatest(500,
         round(coalesce(public.bubu_price_band(p.name), p.price)
           * (0.88 + (abs(hashtext(p.supplier_id::text || p.name)) % 25) / 100.0)
           / case when coalesce(public.bubu_price_band(p.name), p.price) >= 1000000 then 50000
                  when coalesce(public.bubu_price_band(p.name), p.price) >= 100000 then 1000
                  else 500 end)
         * case when coalesce(public.bubu_price_band(p.name), p.price) >= 1000000 then 50000
                when coalesce(public.bubu_price_band(p.name), p.price) >= 100000 then 1000
                else 500 end)
 where p.import_source = 'uganda-b2b'
   and p.description like 'Indicative%'
   and abs(hashtext(p.id::text)) % 10 = 1;

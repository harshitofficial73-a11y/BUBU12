-- 0069 step 0 · run first. Creates the price table used by the batches.
create or replace function public.bubu_price_band(p_name text) returns bigint language sql immutable as $$
  select case
    when p_name ~* '\m(excavator|bulldozer|grader|crane)\M'                 then 245000000
    when p_name ~* '\m(tractor)\M'                                          then 78000000
    when p_name ~* '\m(lorry|truck|tipper)\M'                              then 118000000
    when p_name ~* '\m(pick.?up|van|minibus)\M'                            then 68000000
    when p_name ~* '\m(forklift)\M'                                         then 62000000
    when p_name ~* '\m(motorcycle|boda)\M'                                  then 5600000
    when p_name ~* '\m(generator|genset)\M'                                 then 6800000
    when p_name ~* '\m(photocopier|copier)\M'                               then 7400000
    when p_name ~* '\m(server)\M'                                           then 11500000
    when p_name ~* '\m(laptop|notebook)\M'                                  then 2600000
    when p_name ~* '\m(desktop|computer|monitor)\M'                         then 1650000
    when p_name ~* '\m(printer)\M' and p_name !~* '\m(ribbon|toner|cartridge|kit|drum)\M' then 1250000
    when p_name ~* '\m(fuser|drum unit)\M'                                  then 420000
    when p_name ~* '\m(toner|cartridge)\M'                                  then 185000
    when p_name ~* '\m(ribbon)\M'                                           then 38000
    when p_name ~* '\m(cleaning kit)\M'                                     then 65000
    when p_name ~* '\m(router|switch|access point)\M'                       then 480000
    when p_name ~* '\m(cctv|camera|dvr|nvr)\M'                              then 390000
    when p_name ~* '\m(solar panel|panel)\M'                                then 720000
    when p_name ~* '\m(inverter)\M'                                         then 1850000
    when p_name ~* '\m(battery|batteries)\M'                                then 690000
    when p_name ~* '\m(pump)\M'                                             then 980000
    when p_name ~* '\m(compressor)\M'                                       then 2900000
    when p_name ~* '\m(welding|welder)\M'                                   then 1400000
    when p_name ~* '\m(drill|grinder|saw)\M'                                then 320000
    when p_name ~* '\m(microscope|centrifuge|incubator|autoclave)\M'        then 5200000
    when p_name ~* '\m(test tube|beaker|flask|pipette)\M'                   then 14000
    when p_name ~* '\m(cement)\M'                                           then 33000
    when p_name ~* '\m(sand|ballast|aggregate|hardcore|murram)\M'           then 195000
    when p_name ~* '\m(iron sheet|roofing sheet|mabati)\M'                 then 52000
    when p_name ~* '\m(tile|tiles)\M'                                       then 48000
    when p_name ~* '\m(rebar|deformed bar|y12|y10|y16)\M'                  then 64000
    when p_name ~* '\m(nail|nails)\M'                                       then 7000
    when p_name ~* '\m(paint|emulsion|gloss)\M'                             then 105000
    when p_name ~* '\m(pipe|pipes)\M'                                       then 36000
    when p_name ~* '\m(cable|wire)\M'                                       then 155000
    when p_name ~* '\m(bulb|lamp|led)\M'                                    then 18000
    when p_name ~* '\m(breaker|mcb|socket|switch)\M'                        then 42000
    when p_name ~* '\m(tyre|tyres)\M'                                       then 340000
    when p_name ~* '\m(brake|filter|clutch)\M'                              then 145000
    when p_name ~* '\m(helmet|boots|goggles|gloves|vest|coverall)\M'        then 38000
    when p_name ~* '\m(chair|desk|table|cabinet|shelf)\M'                   then 285000
    when p_name ~* '\m(mattress|bed|sofa)\M'                                then 690000
    when p_name ~* '\m(paper|ream)\M'                                       then 19000
    when p_name ~* '\m(pen|pencil|marker|stapler|file)\M'                   then 9500
    when p_name ~* '\m(maize|beans|rice|sorghum|millet|groundnut|coffee|sesame)\M' then 3400
    when p_name ~* '\m(fertili[sz]er|urea|npk|dap)\M'                       then 165000
    when p_name ~* '\m(seed|seeds)\M'                                       then 28000
    when p_name ~* '\m(feed|feeds)\M'                                       then 98000
    when p_name ~* '\m(soap|detergent|bleach|sanitiser)\M'                  then 8500
    when p_name ~* '\m(oil)\M'                                              then 11500
    when p_name ~* '\m(sugar|flour|salt)\M'                                 then 4800
    when p_name ~* '\m(juice|soda|water)\M'                                 then 26000
    when p_name ~* '\m(carton|box|bag|sack)\M'                              then 2600
    when p_name ~* '\m(syringe|mask|bandage|gauze)\M'                       then 26000
    when p_name ~* '\m(plate|cup|cutlery|crockery)\M'                       then 42000
    when p_name ~* '\m(fridge|freezer|oven|cooker)\M'                       then 1950000
    when p_name ~* '\m(installation|service|maintenance)\M'                 then 450000
    else null
  end;
$$;

-- 0069 check · run last.
select count(*) as listings, count(distinct price) as distinct_prices
  from products where import_source = 'uganda-b2b';

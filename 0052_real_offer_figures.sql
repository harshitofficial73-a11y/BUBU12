-- Response rate, supplier rating and MOQ, from the database.
--
-- The offer cards were inventing all three:
--
--   resp = 72 + ((price + position * 17) % 26)
--   rate = product rating, minus 0.2 per position in the list
--   count = 12 + position * 9 + (orders % 40)
--
-- So a supplier's "80% response rate" was a function of their price, and the
-- same supplier ranked lower showed a worse rating than ranked higher. Numbers
-- that look like measurements but measure nothing are worse than no numbers:
-- a buyer chooses on them.
--
-- Now:
--
--   response rate  conversations where the supplier has sent at least one
--                  message, over conversations they were given. Starts at 100
--                  and falls only when they leave someone unanswered — one
--                  reply is a response, as you said.
--   rating         the supplier's own buyer-given score, with its real count.
--   moq            from the product, defaulting to 1 where it is missing.
--
-- Safe to re-run.

begin;

-- Conversations opened with this supplier, and how many they answered.
create or replace function public.supplier_response_rate(p_supplier uuid)
returns integer
language sql
stable
security definer
set search_path = public
as $$
  select case
    when count(*) = 0 then 100          -- nobody has asked yet: nothing to fail
    else greatest(0, least(100,
      round(100.0 * count(*) filter (where answered) / count(*))::integer))
  end
  from (
    select c.id,
           exists (select 1 from messages m
                    where m.conversation_id = c.id
                      and m.sender_id = p_supplier) as answered
      from conversations c
     where c.supplier_id = p_supplier
  ) t;
$$;

grant execute on function public.supplier_response_rate(uuid) to authenticated, anon;

-- The offer rows a buyer sees under a product. Everything on the card comes
-- from here now, so nothing has to be invented in the browser.
--
-- Every existing column is kept — name and rating included — because other code
-- selects * from this view and dropping a column it reads would break quietly.
drop view if exists public.product_offers cascade;

create view public.product_offers as
  select
    p.id                              as product_id,
    p.name,
    p.supplier_id,
    a.company                         as supplier,
    a.district_id,
    p.price,
    -- MOQ from the product, defaulting to 1. A missing or zero minimum means
    -- "one", not "none".
    coalesce(nullif(p.moq, 0), 1)     as moq,
    coalesce(nullif(trim(p.unit), ''), 'unit') as unit,
    p.rating,
    (r.overall_state = 'verified')    as verified,
    greatest(0, extract(year from age(now(), a.created_at))::integer)
                                      as years_on_platform,
    -- The supplier's score as BUYERS rated them, with the prior from 0050 so a
    -- new supplier starts at 5 rather than at nothing.
    coalesce(a.supplier_rating, 5.0)  as supplier_rating,
    coalesce(a.supplier_rating_count, 0) as supplier_rating_count,
    public.supplier_response_rate(a.id)  as response_rate
  from products p
  join accounts a on a.id = p.supplier_id
  left join account_registration r on r.account_id = a.id
  where p.status = 'published';

grant select on public.product_offers to authenticated, anon;

commit;

notify pgrst, 'reload schema';

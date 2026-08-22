-- Requirements no longer carry a category. A buyer types what they need and
-- suppliers see it when the words overlap with something they actually sell.
--
-- Matching works on word stems rather than whole strings, so "octagonal pole"
-- reaches a supplier selling "galvanised poles": the tokens "pole" and "poles"
-- match on a shared prefix. pg_trgm similarity is layered on top to survive
-- typos and spelling drift.

create extension if not exists pg_trgm;

-- category is optional from now on
alter table requirements alter column category_id drop not null;

create or replace function public.lead_terms(p_account uuid)
returns table(term text) language sql stable set search_path=public as $$
  -- every word of three letters or more that this supplier trades in:
  -- product names, brands, the categories those products sit in, and the
  -- categories the supplier signed up against
  select distinct lower(w)
  from (
    select unnest(string_to_array(
      regexp_replace(lower(concat_ws(' ', p.name, p.brand, c.name)), '[^a-z0-9]+', ' ', 'g'), ' ')) as w
    from products p
    left join categories c on c.id = p.category_id
    where p.supplier_id = p_account
    union all
    select unnest(string_to_array(
      regexp_replace(lower(c.name), '[^a-z0-9]+', ' ', 'g'), ' ')) as w
    from account_categories ac
    join categories c on c.id = ac.category_id
    where ac.account_id = p_account
  ) t
  where length(w) >= 3
    and w not in ('and','the','for','with','from','all','other','general','misc','ltd','type','size');
$$;

create or replace function my_buy_leads()
returns setof requirements language sql stable security definer set search_path=public as $$
  with me as (select current_account_id() as id),
  terms as (select term from lead_terms((select id from me))),
  has_terms as (select exists(select 1 from terms) as any)
  select distinct r.*
  from requirements r, me, has_terms
  where r.state = 'open'
    and r.buyer_id <> me.id
    and (
      -- a supplier with nothing listed yet sees the whole open board
      not has_terms.any

      -- a shared word stem, in either direction, between the request and
      -- something the supplier sells
      or exists (
        select 1
        from terms t
        cross join unnest(string_to_array(
          regexp_replace(lower(concat_ws(' ', r.title, r.specification)), '[^a-z0-9]+', ' ', 'g'), ' ')) as rw
        where length(rw) >= 3
          and (rw like t.term || '%' or t.term like rw || '%')
      )

      -- or the whole phrase is close enough to survive a typo
      or exists (
        select 1 from terms t where similarity(lower(r.title), t.term) > 0.35
      )

      -- or the buyer did pick a category and the supplier holds it
      or exists (
        select 1 from account_categories ac
        left join categories rc on rc.id = r.category_id
        where ac.account_id = me.id
          and r.category_id is not null
          and (ac.category_id = r.category_id or ac.category_id = rc.parent_id)
      )
    )
    -- the supplier's own value and district preferences still apply
    and not exists (
      select 1 from lead_preferences pref
      where pref.account_id = me.id
        and (
          (pref.min_value is not null and coalesce(r.estimated_value, 0) < pref.min_value)
          or (not pref.nationwide and cardinality(pref.districts) > 0
              and r.district_id is not null
              and r.district_id <> all(pref.districts)
              and not exists (select 1 from unnest(pref.districts) d
                              where district_km(d, r.district_id) <= pref.radius_km))
        )
    )
  order by r.created_at desc;
$$;

grant execute on function public.lead_terms(uuid) to authenticated;

-- Buyer-side suggestions while typing a requirement: the product names already
-- on the platform that share a word stem with what has been typed so far.
create or replace function public.suggest_products(p_query text)
returns table(name text, category_id text, category_name text, supplier_count bigint)
language sql stable security definer set search_path=public as $$
  with q as (
    select lower(w) as w
    from unnest(string_to_array(regexp_replace(lower(coalesce(p_query,'')), '[^a-z0-9]+', ' ', 'g'), ' ')) as w
    where length(w) >= 2
  )
  select p.name, p.category_id, c.name, count(distinct p.supplier_id)
  from products p
  left join categories c on c.id = p.category_id
  where p.status = 'published'
    and exists (
      select 1 from q
      cross join unnest(string_to_array(regexp_replace(lower(p.name), '[^a-z0-9]+', ' ', 'g'), ' ')) as pw
      where pw like q.w || '%' or q.w like pw || '%'
    )
  group by p.name, p.category_id, c.name
  order by count(distinct p.supplier_id) desc, p.name
  limit 8;
$$;

grant execute on function public.suggest_products(text) to authenticated, anon;

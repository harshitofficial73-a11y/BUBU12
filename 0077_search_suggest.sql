-- Smart search suggestions for the top search bar.
--
-- The old suggest_products matched loosely and ranked badly: "cemet" returned
-- C-section and a bottle of wine, "octagon" an O-ring. This one ranks, in order:
--   1. names that START with what was typed        (cement → Cement bag)
--   2. names with a WORD starting with it            (sheet → Iron sheet)
--   3. names that contain it anywhere
--   4. close misspellings, by trigram similarity     (cemet → Cement, solr → Solar)
-- and also returns matching categories, so "roof" offers Roofing & Ceilings.
--
-- Import prefixes such as "Installation system — " are stripped for display,
-- so each product appears once under its plain name.
--
-- Safe to re-run.

create extension if not exists pg_trgm;

create index if not exists products_name_trgm on public.products using gin (lower(name) gin_trgm_ops);
create index if not exists categories_name_trgm on public.categories using gin (lower(name) gin_trgm_ops);

create or replace function public.search_suggest(p_query text)
returns table(kind text, label text, category_id text, category_name text, listings integer, rank integer)
language sql stable security definer set search_path = public, extensions as $$
  with q as (select lower(trim(coalesce(p_query, ''))) as s),
  plain as (
    select p.id, p.category_id,
           trim(regexp_replace(p.name, '^.*\s—\s', '')) as nm
    from products p, q
    where p.status = 'published' and length(q.s) >= 2
      and (lower(p.name) like '%' || q.s || '%'
           or word_similarity(q.s, lower(p.name)) > 0.45)
    limit 4000
  ),
  prod as (
    select 'product'::text as kind, pl.nm as label,
           (array_agg(pl.category_id order by pl.category_id))[1] as category_id,
           count(*)::int as listings,
           min(case
             when lower(pl.nm) like q.s || '%' then 1
             when lower(pl.nm) ~ ('(^|[^a-z])' || regexp_replace(q.s, '([^a-z0-9 ])', '\\\1', 'g')) then 2
             when lower(pl.nm) like '%' || q.s || '%' then 3
             else 4 end) as rank,
           max(word_similarity(q.s, lower(pl.nm))) as sim
    from plain pl, q
    group by pl.nm, q.s
  ),
  cat as (
    select 'category'::text as kind, c.name as label, c.id as category_id, 0 as listings,
           case when lower(c.name) like q.s || '%' then 0
                when lower(c.name) like '%' || q.s || '%' then 1 else 2 end as rank,
           word_similarity(q.s, lower(c.name)) as sim
    from categories c, q
    where length(q.s) >= 2
      and (lower(c.name) like '%' || q.s || '%' or word_similarity(q.s, lower(c.name)) > 0.5)
  )
  (select c.kind, c.label, c.category_id, null::text, c.listings, c.rank
     from cat c order by c.rank, c.sim desc, length(c.label) limit 3)
  union all
  (select p.kind, p.label, p.category_id, cc.name, p.listings, p.rank
     from prod p left join categories cc on cc.id = p.category_id
     order by p.rank, p.sim desc, p.listings desc, length(p.label) limit 8);
$$;

grant execute on function public.search_suggest(text) to anon, authenticated;

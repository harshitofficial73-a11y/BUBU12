-- 0066 · Category product counts, done in the database.
--
-- The app counted products by downloading them to the browser, and Supabase
-- caps a download at 1,000 rows. With ~45,000 listings it counted the first
-- thousand only, so every category past them read "No listings yet".
-- Safe to re-run.

create or replace function public.category_counts()
returns table (category_id text, n bigint)
language sql
stable
security definer
set search_path = public
as $$
  select category_id, count(*)
    from products
   where status = 'published' and category_id is not null
   group by category_id;
$$;

grant execute on function public.category_counts() to anon, authenticated;

notify pgrst, 'reload schema';

-- Check: real totals per main category
select coalesce(k.parent_id, k.id) as main, sum(c.n) as products
  from public.category_counts() c
  join categories k on k.id = c.category_id
 group by 1 order by 2;

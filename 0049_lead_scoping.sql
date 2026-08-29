-- Buy leads, scoped to what a supplier actually sells.
--
-- my_buy_leads showed the WHOLE open board to any supplier with nothing listed,
-- and once they listed something it matched on word overlap with no distinction
-- between a direct hit and a near miss. A supplier scrolling forty leads for
-- goods they do not stock stops scrolling.
--
-- Two lists now, from one function:
--
--   matched    the requirement names something in their catalogue. These are
--              theirs to quote.
--   suggested  same category or trade, but nothing in their catalogue matches
--              the words. Worth a look, and worth listing the product for.
--
-- The suggested list is the useful half of the old behaviour kept deliberately:
-- it tells a supplier what buyers are asking for that they do not yet list.
--
-- Safe to re-run.

begin;

-- "create or replace" cannot change a function's return type, and several of
-- these already exist in some shape — including from a partial run of this very
-- file. Drop every version by name first, read from the catalogue rather than
-- guessed at, so this works whatever your database currently holds and works
-- again on a re-run.
--
-- I hit this in 0043 and fixed it there only. Applying it to every function a
-- migration replaces is the actual lesson.
do $$
declare r record;
begin
  -- Dependents first, then what they call, so no CASCADE is needed. CASCADE
  -- would drop anything else depending on these without saying so, which is
  -- not a risk worth taking on a live database.
  for r in
    select p.oid::regprocedure as sig
      from pg_proc p
      join pg_namespace n on n.oid = p.pronamespace
     where n.nspname = 'public'
       and p.proname in ('my_lead_board', 'my_buy_leads', 'category_demand')
  loop
    execute 'drop function ' || r.sig;
  end loop;

  for r in
    select p.oid::regprocedure as sig
      from pg_proc p
      join pg_namespace n on n.oid = p.pronamespace
     where n.nspname = 'public'
       and p.proname = 'lead_terms'
  loop
    execute 'drop function ' || r.sig;
  end loop;
end $$;

-- Every word of three letters or more that this supplier trades in.
create or replace function public.lead_terms(p_account uuid)
returns table(term text)
language sql
stable
security definer
set search_path = public
as $$
  select distinct lower(w)
  from (
    select unnest(string_to_array(
      regexp_replace(lower(concat_ws(' ', p.name, p.brand)), '[^a-z0-9]+', ' ', 'g'), ' ')) as w
    from products p
    where p.supplier_id = p_account and p.status = 'published'
  ) t
  where length(w) >= 3
    and w not in ('and','the','for','with','from','all','other','general','misc',
                  'ltd','type','size','new','set','pcs','per');
$$;

grant execute on function public.lead_terms(uuid) to authenticated;

-- One row per open requirement the supplier may care about, labelled.
create or replace function public.my_lead_board()
returns setof jsonb
language sql
stable
security definer
set search_path = public
as $$
  with me as (select current_account_id() as id),
  terms as (select term from lead_terms((select id from me))),
  my_cats as (
    select distinct p.category_id
      from products p, me
     where p.supplier_id = me.id and p.status = 'published'
       and p.category_id is not null
    union
    select ac.category_id from account_categories ac, me where ac.account_id = me.id
  ),
  scored as (
    select r.*,
           -- how many words of the requirement this supplier's catalogue covers
           (select count(*)
              from terms t
             where exists (
               select 1
               from unnest(string_to_array(
                 regexp_replace(lower(concat_ws(' ', r.title, r.specification)),
                                '[^a-z0-9]+', ' ', 'g'), ' ')) as rw(w)
               where length(rw.w) >= 3
                 and (rw.w like t.term || '%' or t.term like rw.w || '%')
             )) as hits,
           (r.category_id in (select category_id from my_cats)) as same_cat
      from requirements r, me
     where r.state = 'open'
       and r.buyer_id <> me.id
  )
  select jsonb_build_object(
    'id', s.id,
    'title', s.title,
    'quantity', s.quantity,
    'unit', s.quantity_unit,
    'specification', s.specification,
    'category_id', s.category_id,
    'district_id', s.district_id,
    'deliver_to', s.deliver_to,
    'estimated_value', s.estimated_value,
    'purpose', s.purpose,
    'created_at', s.created_at,
    'hits', s.hits,
    -- 'matched' means their catalogue names it. 'suggested' means their trade
    -- covers it but they have not listed the product.
    'bucket', case when s.hits > 0 then 'matched' else 'suggested' end
  )
  from scored s
  where s.hits > 0 or s.same_cat
  order by (s.hits > 0) desc, s.hits desc, s.created_at desc
  limit 120;
$$;

grant execute on function public.my_lead_board() to authenticated;

-- How much buyers are actually asking for in each category, so a supplier
-- choosing where to list can see which choice earns leads rather than guessing.
-- Counts open requirements only, over the last 90 days.
create or replace function public.category_demand()
returns setof jsonb
language sql
stable
security definer
set search_path = public
as $$
  select jsonb_build_object(
    'category_id', c.id,
    'name', c.name,
    'parent_id', c.parent_id,
    'open_leads', (select count(*) from requirements r
                    where r.category_id = c.id
                      and r.state = 'open'
                      and r.created_at > now() - interval '90 days'),
    'listings', (select count(*) from products p
                  where p.category_id = c.id and p.status = 'published')
  )
  from categories c
  order by c.name;
$$;

grant execute on function public.category_demand() to authenticated, anon;

-- The existing board keeps working, but only returns MATCHED leads now — a
-- supplier's own list should be things they can quote today.
create or replace function my_buy_leads()
returns setof requirements
language sql
stable
security definer
set search_path = public
as $$
  with me as (select current_account_id() as id),
  terms as (select term from lead_terms((select id from me)))
  select distinct r.*
  from requirements r, me
  where r.state = 'open'
    and r.buyer_id <> me.id
    and exists (
      select 1
      from terms t
      cross join unnest(string_to_array(
        regexp_replace(lower(concat_ws(' ', r.title, r.specification)),
                       '[^a-z0-9]+', ' ', 'g'), ' ')) as rw(w)
      where length(rw.w) >= 3
        and (rw.w like t.term || '%' or t.term like rw.w || '%')
    )
    and not exists (
      select 1 from lead_preferences pref
      where pref.account_id = me.id
        and (
          (pref.min_value is not null and coalesce(r.estimated_value, 0) < pref.min_value)
          or (not pref.nationwide and cardinality(pref.districts) > 0
              and r.district_id is not null
              and r.district_id <> all(pref.districts))
        )
    )
  order by r.created_at desc;
$$;

commit;

notify pgrst, 'reload schema';

-- Manage requirements, part two: the allotment functions.
--
-- 0037 created the table but stopped before the functions. This file is just
-- the functions, written a simpler way: one text blob per supplier, then count
-- how many words of the requirement appear in it. No multi-way cross join, so
-- it is both easier to read and quicker on a large catalogue.
--
-- Safe to run on its own, and safe to re-run.

-- Up to ten suppliers for one requirement, ranked by how much of the request
-- their catalogue covers. Recorded once, so the buyer sees the same ten in the
-- same order every time.
create or replace function public.allot_requirement_suppliers(p_requirement uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_buyer   uuid;
  v_text    text;
  v_cat     text;
  v_words   text[];
begin
  select r.buyer_id,
         lower(concat_ws(' ', r.title, r.specification)),
         r.category_id
    into v_buyer, v_text, v_cat
    from requirements r
   where r.id = p_requirement;

  if v_buyer is null then
    return;
  end if;

  if exists (select 1 from requirement_matches where requirement_id = p_requirement) then
    return;
  end if;

  -- The words worth matching on: three letters or more, no filler.
  select array_agg(distinct w)
    into v_words
    from unnest(string_to_array(regexp_replace(coalesce(v_text, ''), '[^a-z0-9]+', ' ', 'g'), ' ')) as t(w)
   where length(w) >= 3
     and w not in ('and','the','for','with','from','all','other','general','misc',
                   'ltd','type','size','need','want','required','quantity','please');

  with supplier_text as (
    select a.id,
           a.rating,
           count(*) as listings,
           regexp_replace(lower(string_agg(
             concat_ws(' ', p.name, p.brand, c.name), ' ')), '[^a-z0-9]+', ' ', 'g') as blob
      from accounts a
      join products p on p.supplier_id = a.id and p.status = 'published'
      left join categories c on c.id = p.category_id
     where a.role = 'supplier'
       and a.id <> v_buyer
     group by a.id, a.rating
  ),
  scored as (
    select s.id, s.rating, s.listings,
           (select count(*)
              from unnest(coalesce(v_words, array[]::text[])) as q(w)
             where s.blob like '%' || q.w || '%') as hits
      from supplier_text s
  )
  insert into requirement_matches (requirement_id, supplier_id, rank)
  select p_requirement, x.id,
         row_number() over (order by x.hits desc, x.rating desc nulls last, x.listings desc)
    from scored x
   where x.hits > 0
   order by x.hits desc, x.rating desc nulls last, x.listings desc
   limit 10
  on conflict (requirement_id, supplier_id) do nothing;

  -- Nothing matched on words. Fall back to the requirement's category, so the
  -- buyer is never handed an empty list.
  if v_cat is not null
     and not exists (select 1 from requirement_matches where requirement_id = p_requirement) then
    insert into requirement_matches (requirement_id, supplier_id, rank)
    select p_requirement, y.id, row_number() over (order by y.rating desc nulls last, y.listings desc)
      from (
        select a.id, a.rating, count(*) as listings
          from accounts a
          join products p on p.supplier_id = a.id and p.status = 'published'
         where a.role = 'supplier'
           and a.id <> v_buyer
           and p.category_id = v_cat
         group by a.id, a.rating
      ) y
     order by y.rating desc nulls last, y.listings desc
     limit 10
    on conflict (requirement_id, supplier_id) do nothing;
  end if;
end;
$$;

grant execute on function public.allot_requirement_suppliers(uuid) to authenticated;

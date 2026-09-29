-- 0067 · Remove empty and duplicate subcategories.
--
-- Only touches SUBcategories. Main categories are never deleted here.
-- Safe to re-run.

begin;

-- 1 · Same name under the same main category: keep the one with the most
--     products, move everything from the others onto it, delete the others.
with ranked as (
  select k.id, k.parent_id, lower(trim(k.name)) as nm,
         (select count(*) from products p where p.category_id = k.id) as n,
         row_number() over (partition by k.parent_id, lower(trim(k.name))
                            order by (select count(*) from products p where p.category_id = k.id) desc, k.id) as rk
    from categories k
   where k.parent_id is not null
),
keep as (select parent_id, nm, id as keep_id from ranked where rk = 1),
dup  as (select r.id as dup_id, k.keep_id from ranked r join keep k using (parent_id, nm) where r.rk > 1)
update products p set category_id = d.keep_id from dup d where p.category_id = d.dup_id;

with ranked as (
  select k.id, k.parent_id, lower(trim(k.name)) as nm,
         row_number() over (partition by k.parent_id, lower(trim(k.name))
                            order by (select count(*) from products p where p.category_id = k.id) desc, k.id) as rk
    from categories k where k.parent_id is not null
)
update requirements r set category_id = null
  from ranked x where x.rk > 1 and r.category_id = x.id;

with ranked as (
  select k.id, k.parent_id, lower(trim(k.name)) as nm,
         row_number() over (partition by k.parent_id, lower(trim(k.name))
                            order by (select count(*) from products p where p.category_id = k.id) desc, k.id) as rk
    from categories k where k.parent_id is not null
)
delete from account_categories a using ranked x where x.rk > 1 and a.category_id = x.id;

with ranked as (
  select k.id, k.parent_id, lower(trim(k.name)) as nm,
         row_number() over (partition by k.parent_id, lower(trim(k.name))
                            order by (select count(*) from products p where p.category_id = k.id) desc, k.id) as rk
    from categories k where k.parent_id is not null
)
delete from categories c using ranked x where x.rk > 1 and c.id = x.id;

-- 2 · Subcategories with no products, no children and no requirements.
delete from account_categories a
 using categories k
 where a.category_id = k.id and k.parent_id is not null
   and not exists (select 1 from products p where p.category_id = k.id)
   and not exists (select 1 from categories c where c.parent_id = k.id)
   and not exists (select 1 from requirements r where r.category_id = k.id);

delete from categories k
 where k.parent_id is not null
   and not exists (select 1 from products p where p.category_id = k.id)
   and not exists (select 1 from categories c where c.parent_id = k.id)
   and not exists (select 1 from requirements r where r.category_id = k.id);

commit;

notify pgrst, 'reload schema';

-- Check
select (select count(*) from categories where parent_id is null)     as main_categories,
       (select count(*) from categories where parent_id is not null) as subcategories,
       (select count(*) from categories k where k.parent_id is not null
          and not exists (select 1 from products p where p.category_id = k.id)) as empty_subcategories_left;

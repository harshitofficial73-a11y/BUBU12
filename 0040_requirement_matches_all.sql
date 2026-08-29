-- Manage requirements — everything in one file, in dependency order.
--
-- Supersedes 0037, 0038 and 0039. Those failed because 0037 stopped at its
-- first statement, so the table was never there for the others to reference.
-- Run ONLY this file. Safe to re-run.

begin;

create extension if not exists pgcrypto;

-- ── 1. The table ────────────────────────────────────────────────────────────
-- Which suppliers were allotted to which requirement, and what the buyer
-- thought of each. Recorded once so the shortlist does not reshuffle.
create table if not exists public.requirement_matches (
  id             uuid primary key default gen_random_uuid(),
  requirement_id uuid not null,
  supplier_id    uuid not null,
  rank           integer not null default 0,
  verdict        text,
  created_at     timestamptz not null default now()
);

-- Constraints added separately: on a re-run the table already exists, and
-- adding them inline would be skipped by "if not exists".
do $$
begin
  if not exists (select 1 from pg_constraint where conname = 'requirement_matches_req_fk') then
    alter table public.requirement_matches
      add constraint requirement_matches_req_fk
      foreign key (requirement_id) references public.requirements(id) on delete cascade;
  end if;
  if not exists (select 1 from pg_constraint where conname = 'requirement_matches_sup_fk') then
    alter table public.requirement_matches
      add constraint requirement_matches_sup_fk
      foreign key (supplier_id) references public.accounts(id) on delete cascade;
  end if;
  if not exists (select 1 from pg_constraint where conname = 'requirement_matches_uniq') then
    alter table public.requirement_matches
      add constraint requirement_matches_uniq unique (requirement_id, supplier_id);
  end if;
end $$;

create index if not exists requirement_matches_req_idx
  on public.requirement_matches (requirement_id, rank);

alter table public.requirement_matches enable row level security;

drop policy if exists rm_read on public.requirement_matches;
create policy rm_read on public.requirement_matches for select using (
  exists (select 1 from public.requirements r
           where r.id = requirement_id and r.buyer_id = public.current_account_id())
  or supplier_id = public.current_account_id()
  or public.is_admin()
);

drop policy if exists rm_write on public.requirement_matches;
create policy rm_write on public.requirement_matches for update using (
  exists (select 1 from public.requirements r
           where r.id = requirement_id and r.buyer_id = public.current_account_id())
) with check (
  exists (select 1 from public.requirements r
           where r.id = requirement_id and r.buyer_id = public.current_account_id())
);

-- ── 2. Allotment ────────────────────────────────────────────────────────────
-- At most ten suppliers per requirement, ranked by how much of the request
-- their catalogue actually covers, then rating, then how much they list.
create or replace function public.allot_requirement_suppliers(p_requirement uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_buyer uuid;
  v_text  text;
  v_cat   text;
  v_words text[];
begin
  select r.buyer_id,
         lower(concat_ws(' ', r.title, r.specification)),
         r.category_id
    into v_buyer, v_text, v_cat
    from requirements r
   where r.id = p_requirement;

  if v_buyer is null then return; end if;
  if exists (select 1 from requirement_matches where requirement_id = p_requirement) then
    return;
  end if;

  select array_agg(distinct w)
    into v_words
    from unnest(string_to_array(
           regexp_replace(coalesce(v_text, ''), '[^a-z0-9]+', ' ', 'g'), ' ')) as t(w)
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

  -- No word matched. Fall back to the category, so the buyer is never handed
  -- an empty list when suppliers in that trade do exist.
  if v_cat is not null
     and not exists (select 1 from requirement_matches where requirement_id = p_requirement) then
    insert into requirement_matches (requirement_id, supplier_id, rank)
    select p_requirement, y.id,
           row_number() over (order by y.rating desc nulls last, y.listings desc)
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

-- ── 3. Reading them back ────────────────────────────────────────────────────
create or replace function public.my_requirements()
returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(jsonb_agg(t.x order by t.created_at desc), '[]'::jsonb)
  from (
    select r.created_at,
           jsonb_build_object(
      'id', r.id,
      'title', r.title,
      'quantity', r.quantity,
      'unit', r.quantity_unit,
      'specification', r.specification,
      'district', r.district_id,
      'deliver_to', r.deliver_to,
      'value', r.estimated_value,
      'state', r.state,
      'created_at', r.created_at,
      'category', (select c.name from categories c where c.id = r.category_id),
      'quote_count', (select count(*) from quotes q
                       where q.requirement_id = r.id and q.state <> 'draft'),
      'suppliers', coalesce((
        select jsonb_agg(jsonb_build_object(
          'match_id', m.id,
          'id', a.id,
          'rank', m.rank,
          'verdict', m.verdict,
          'company', a.company,
          'trade_name', a.trade_name,
          'business_type', a.business_type,
          'district', a.district_id,
          'address', a.address,
          'phone', a.phone,
          'whatsapp', coalesce(a.whatsapp_phone, a.phone),
          'email', a.email,
          'rating', a.rating,
          'rating_count', a.rating_count,
          'verified', (select reg.overall_state = 'verified'
                         from account_registration reg
                        where reg.account_id = a.id),
          'listings', (select count(*) from products p
                        where p.supplier_id = a.id and p.status = 'published'),
          'photo', (select md.storage_path
                      from media md
                      join products p2 on p2.id = md.product_id
                     where p2.supplier_id = a.id
                       and md.kind = 'product'
                       and md.approved
                     order by md.created_at
                     limit 1)
        ) order by m.rank)
        from requirement_matches m
        join accounts a on a.id = m.supplier_id
       where m.requirement_id = r.id
      ), '[]'::jsonb)
    ) as x
    from requirements r
   where r.buyer_id = current_account_id()
   order by r.created_at desc
   limit 60
  ) t;
$$;

grant execute on function public.my_requirements() to authenticated;

-- ── 4. The buyer's verdict, and withdrawing ─────────────────────────────────
create or replace function public.rate_requirement_match(p_match uuid, p_verdict text)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  update requirement_matches m
     set verdict = case when p_verdict in ('yes', 'no') then p_verdict else null end
   where m.id = p_match
     and exists (select 1 from requirements r
                  where r.id = m.requirement_id
                    and r.buyer_id = current_account_id());
end;
$$;

grant execute on function public.rate_requirement_match(uuid, text) to authenticated;

-- 'withdrawn' is the state the schema has; there is no 'closed'.
create or replace function public.close_requirement(p_requirement uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  update requirements
     set state = 'withdrawn'
   where id = p_requirement
     and buyer_id = current_account_id();
end;
$$;

grant execute on function public.close_requirement(uuid) to authenticated;

commit;

-- Allot the requirements already posted, so nobody has to re-post to be
-- matched. Outside the transaction: a failure here must not undo the schema.
do $$
declare r record;
begin
  for r in select id from requirements order by created_at desc limit 200 loop
    begin
      perform public.allot_requirement_suppliers(r.id);
    exception when others then
      null;  -- one odd requirement must not stop the rest
    end;
  end loop;
end $$;

notify pgrst, 'reload schema';

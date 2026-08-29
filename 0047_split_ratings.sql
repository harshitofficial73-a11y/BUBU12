-- Buyer and seller ratings were being averaged into one number.
--
-- 0025 stored a single accounts.rating and refreshed it from BOTH review
-- tables in one UNION. So a trader rated 5 as a supplier and 2 as a buyer
-- showed 3.5 — a figure that describes nothing. They measure different things:
-- one is "do they deliver what they promised", the other is "do they pay and
-- reply". A buyer choosing a supplier should not see the supplier's own
-- payment record mixed into their delivery score.
--
-- Two scores now, kept apart, each computed from its own table. The old
-- combined column stays and keeps working, so nothing that reads it breaks.
--
-- Safe to re-run.

begin;

-- "create or replace" cannot change a function's return type. Drop every
-- existing version by name first — read from the catalogue, not guessed at — so
-- this runs whatever shape the database currently holds, and runs again.
do $$
declare r record;
begin
  for r in
    select p.oid::regprocedure as sig
      from pg_proc p
      join pg_namespace n on n.oid = p.pronamespace
     where n.nspname = 'public'
       and p.proname in ('my_ratings')
  loop
    execute 'drop function ' || r.sig;
  end loop;
end $$;


alter table public.accounts add column if not exists supplier_rating numeric(2,1);
alter table public.accounts add column if not exists supplier_rating_count integer not null default 0;
alter table public.accounts add column if not exists buyer_rating numeric(2,1);
alter table public.accounts add column if not exists buyer_rating_count integer not null default 0;

create or replace function public.refresh_account_rating(p_account uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_sup_avg numeric; v_sup_n integer;
  v_buy_avg numeric; v_buy_n integer;
begin
  select round(avg(rating)::numeric, 1), count(*)
    into v_sup_avg, v_sup_n
    from supplier_reviews where supplier_id = p_account;

  select round(avg(rating)::numeric, 1), count(*)
    into v_buy_avg, v_buy_n
    from buyer_reviews where buyer_id = p_account;

  update accounts
     set supplier_rating = v_sup_avg,
         supplier_rating_count = coalesce(v_sup_n, 0),
         buyer_rating = v_buy_avg,
         buyer_rating_count = coalesce(v_buy_n, 0),
         -- The combined figure is kept for anything still reading it, but it is
         -- now weighted by how many ratings each side has rather than being a
         -- flat average of two averages.
         rating = case
           when coalesce(v_sup_n, 0) + coalesce(v_buy_n, 0) = 0 then null
           else round(((coalesce(v_sup_avg, 0) * coalesce(v_sup_n, 0)
                      + coalesce(v_buy_avg, 0) * coalesce(v_buy_n, 0))
                      / (coalesce(v_sup_n, 0) + coalesce(v_buy_n, 0)))::numeric, 1)
         end,
         rating_count = coalesce(v_sup_n, 0) + coalesce(v_buy_n, 0)
   where id = p_account;
end;
$$;

grant execute on function public.refresh_account_rating(uuid) to authenticated;

-- Both scores for the caller, for the top bar.
create or replace function public.my_ratings()
returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  select jsonb_build_object(
    'supplier_rating', a.supplier_rating,
    'supplier_rating_count', a.supplier_rating_count,
    'buyer_rating', a.buyer_rating,
    'buyer_rating_count', a.buyer_rating_count,
    'supplier_reviews', coalesce((
      select jsonb_agg(jsonb_build_object('rating', r.rating, 'body', r.body,
               'created_at', r.created_at, 'from', b.company) order by r.created_at desc)
        from supplier_reviews r
        left join accounts b on b.id = r.buyer_id
       where r.supplier_id = a.id), '[]'::jsonb),
    'buyer_reviews', coalesce((
      select jsonb_agg(jsonb_build_object('rating', r.rating, 'body', r.body,
               'created_at', r.created_at, 'from', s.company) order by r.created_at desc)
        from buyer_reviews r
        left join accounts s on s.id = r.supplier_id
       where r.buyer_id = a.id), '[]'::jsonb)
  )
  from accounts a
  where a.id = current_account_id();
$$;

grant execute on function public.my_ratings() to authenticated;

-- Recompute everything with the new split.
select public.refresh_account_rating(id) from public.accounts;

commit;

notify pgrst, 'reload schema';

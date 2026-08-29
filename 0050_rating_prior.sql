-- Everyone starts at 5, and real ratings pull it from there.
--
-- Done as a prior rather than a literal 5, because a literal 5 with no ratings
-- behind it collapses on the first real one — 5.0 to 2.0 overnight, which reads
-- as a broken score rather than a fair one.
--
-- So every account carries two notional 5-star ratings that nobody gave it:
--
--   no real ratings      5.0
--   one real 2           (5+5+2)/3  = 4.0
--   three real 2s        (5+5+6)/5  = 3.2
--   ten real 2s          (10+20)/12 = 2.5
--
-- It starts where you asked, moves the moment somebody rates, and settles on
-- the truth once there are a handful. Two is deliberately small: three real
-- ratings already outweigh the prior.
--
-- The COUNT stays honest — it reports real ratings only, so "5.0 from no
-- ratings yet" and "5.0 from 40 ratings" are distinguishable. A score with a
-- prior behind it and a count that hid the prior would be misleading.
--
-- Safe to re-run.

begin;

-- No drop guard here on purpose: this function returns void in both the old and
-- the new version, so "create or replace" is safe — and it must be replaced
-- rather than dropped, because two review triggers call it and dropping would
-- detach them.

create or replace function public.refresh_account_rating(p_account uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_prior_n  integer := 2;    -- notional ratings
  v_prior_v  numeric := 5.0;  -- at five stars
  v_sup_sum numeric; v_sup_n integer;
  v_buy_sum numeric; v_buy_n integer;
begin
  select coalesce(sum(rating), 0), count(*)
    into v_sup_sum, v_sup_n
    from supplier_reviews where supplier_id = p_account;

  select coalesce(sum(rating), 0), count(*)
    into v_buy_sum, v_buy_n
    from buyer_reviews where buyer_id = p_account;

  update accounts
     set supplier_rating = round(
           ((v_sup_sum + v_prior_v * v_prior_n) / (v_sup_n + v_prior_n))::numeric, 1),
         supplier_rating_count = v_sup_n,
         buyer_rating = round(
           ((v_buy_sum + v_prior_v * v_prior_n) / (v_buy_n + v_prior_n))::numeric, 1),
         buyer_rating_count = v_buy_n,
         -- The combined figure gets one prior, not two, so holding both roles
         -- does not double the head start.
         rating = round(
           ((v_sup_sum + v_buy_sum + v_prior_v * v_prior_n)
            / (v_sup_n + v_buy_n + v_prior_n))::numeric, 1),
         rating_count = v_sup_n + v_buy_n
   where id = p_account;
end;
$$;

grant execute on function public.refresh_account_rating(uuid) to authenticated;

-- Recompute every account so nobody is left on the old scale.
select public.refresh_account_rating(id) from public.accounts;

commit;

notify pgrst, 'reload schema';

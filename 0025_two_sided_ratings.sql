-- Two-sided ratings.
--
-- A buyer may rate a supplier once they have actually received a quote from
-- them. A supplier may rate a buyer once they have bought that buyer's lead.
-- Both are once-only and both are enforced in SQL, so the button being hidden
-- in the browser is a convenience, not the control.

create table if not exists public.buyer_reviews (
  id uuid primary key default uuid_generate_v4(),
  buyer_id uuid not null references public.accounts(id) on delete cascade,
  supplier_id uuid not null references public.accounts(id) on delete cascade,
  rating integer not null check (rating between 1 and 5),
  body text,
  created_at timestamptz not null default now(),
  unique (buyer_id, supplier_id)
);
alter table public.buyer_reviews enable row level security;

drop policy if exists buyer_reviews_read on public.buyer_reviews;
create policy buyer_reviews_read on public.buyer_reviews for select using (true);
drop policy if exists buyer_reviews_supplier_write on public.buyer_reviews;
create policy buyer_reviews_supplier_write on public.buyer_reviews
for all to authenticated using (supplier_id = current_account_id())
with check (supplier_id = current_account_id());

-- The score lives on the account so every screen can read it without an
-- aggregate query.
alter table accounts add column if not exists rating numeric(2,1);
alter table accounts add column if not exists rating_count integer not null default 0;

create or replace function public.refresh_account_rating(p_account uuid)
returns void language plpgsql security definer set search_path=public as $$
declare v_avg numeric; v_count integer;
begin
  select round(avg(r.rating)::numeric, 1), count(*) into v_avg, v_count
  from (
    select rating from supplier_reviews where supplier_id = p_account
    union all
    select rating from buyer_reviews where buyer_id = p_account
  ) r;
  update accounts set rating = v_avg, rating_count = coalesce(v_count, 0)
  where id = p_account;
end $$;

create or replace function public.tg_refresh_supplier_rating()
returns trigger language plpgsql security definer set search_path=public as $$
begin
  perform refresh_account_rating(coalesce(new.supplier_id, old.supplier_id));
  return null;
end $$;

create or replace function public.tg_refresh_buyer_rating()
returns trigger language plpgsql security definer set search_path=public as $$
begin
  perform refresh_account_rating(coalesce(new.buyer_id, old.buyer_id));
  return null;
end $$;

drop trigger if exists supplier_reviews_rating on supplier_reviews;
create trigger supplier_reviews_rating after insert or update or delete on supplier_reviews
for each row execute function tg_refresh_supplier_rating();

drop trigger if exists buyer_reviews_rating on buyer_reviews;
create trigger buyer_reviews_rating after insert or update or delete on buyer_reviews
for each row execute function tg_refresh_buyer_rating();

-- A buyer rates a supplier: allowed once a quote has been received.
create or replace function public.rate_supplier(p_supplier uuid, p_rating integer, p_body text default null)
returns jsonb language plpgsql security definer set search_path=public as $$
declare v_buyer uuid := current_account_id();
begin
  if v_buyer is null then raise exception 'sign in required'; end if;
  if p_rating < 1 or p_rating > 5 then raise exception 'rating must be 1 to 5'; end if;
  if not exists (select 1 from accounts where id = v_buyer and role = 'buyer') then
    raise exception 'buyer account required';
  end if;
  if not exists (
    select 1 from quotes q join requirements r on r.id = q.requirement_id
    where r.buyer_id = v_buyer and q.supplier_id = p_supplier and q.state <> 'draft'
  ) then raise exception 'you can rate a supplier once they have sent you a quote'; end if;
  if exists (select 1 from supplier_reviews where supplier_id = p_supplier and buyer_id = v_buyer) then
    raise exception 'you have already rated this supplier';
  end if;

  insert into supplier_reviews(supplier_id, buyer_id, rating, body)
  values (p_supplier, v_buyer, p_rating, nullif(btrim(coalesce(p_body,'')), ''));
  return jsonb_build_object('status','saved','supplier',p_supplier,'rating',p_rating);
end $$;

-- A supplier rates a buyer: allowed once the buyer's lead has been bought.
create or replace function public.rate_buyer(p_buyer uuid, p_rating integer, p_body text default null)
returns jsonb language plpgsql security definer set search_path=public as $$
declare v_supplier uuid := current_account_id();
begin
  if v_supplier is null then raise exception 'sign in required'; end if;
  if p_rating < 1 or p_rating > 5 then raise exception 'rating must be 1 to 5'; end if;
  if not exists (select 1 from accounts where id = v_supplier and role = 'supplier') then
    raise exception 'supplier account required';
  end if;
  if not exists (
    select 1 from lead_purchases lp join requirements r on r.id = lp.requirement_id
    where lp.supplier_id = v_supplier and r.buyer_id = p_buyer
      and lp.payment_state <> 'payment_required'
  ) then raise exception 'you can rate a buyer once you have bought one of their leads'; end if;
  if exists (select 1 from buyer_reviews where buyer_id = p_buyer and supplier_id = v_supplier) then
    raise exception 'you have already rated this buyer';
  end if;

  insert into buyer_reviews(buyer_id, supplier_id, rating, body)
  values (p_buyer, v_supplier, p_rating, nullif(btrim(coalesce(p_body,'')), ''));
  return jsonb_build_object('status','saved','buyer',p_buyer,'rating',p_rating);
end $$;

-- Everything a screen needs: my own score, and who I may still rate.
create or replace function public.my_ratings()
returns jsonb language plpgsql security definer set search_path=public as $$
declare v_me uuid := current_account_id(); v_role text;
begin
  if v_me is null then raise exception 'sign in required'; end if;
  select role::text into v_role from accounts where id = v_me;

  return jsonb_build_object(
    'mine', (select jsonb_build_object('rating', a.rating, 'count', a.rating_count)
             from accounts a where a.id = v_me),

    -- reviews written about me, newest first
    'received', coalesce((
      select jsonb_agg(x order by x->>'created_at' desc) from (
        select jsonb_build_object('rating', sr.rating, 'body', sr.body,
          'created_at', sr.created_at, 'from', b.company) as x
        from supplier_reviews sr join accounts b on b.id = sr.buyer_id
        where sr.supplier_id = v_me
        union all
        select jsonb_build_object('rating', br.rating, 'body', br.body,
          'created_at', br.created_at, 'from', s.company) as x
        from buyer_reviews br join accounts s on s.id = br.supplier_id
        where br.buyer_id = v_me
      ) t), '[]'::jsonb),

    -- counterparties I am entitled to rate, and whether I already did
    'ratable', coalesce((
      select jsonb_agg(jsonb_build_object('id', t.id, 'company', t.company,
        'already', t.already) order by t.company)
      from (
        select distinct a.id, a.company,
          exists(select 1 from supplier_reviews sr
                 where sr.supplier_id = a.id and sr.buyer_id = v_me) as already
        from quotes q
        join requirements r on r.id = q.requirement_id
        join accounts a on a.id = q.supplier_id
        where v_role = 'buyer' and r.buyer_id = v_me and q.state <> 'draft'
        union all
        select distinct a.id, a.company,
          exists(select 1 from buyer_reviews br
                 where br.buyer_id = a.id and br.supplier_id = v_me) as already
        from lead_purchases lp
        join requirements r on r.id = lp.requirement_id
        join accounts a on a.id = r.buyer_id
        where v_role = 'supplier' and lp.supplier_id = v_me
          and lp.payment_state <> 'payment_required'
      ) t), '[]'::jsonb)
  );
end $$;

grant execute on function public.rate_supplier(uuid,integer,text) to authenticated;
grant execute on function public.rate_buyer(uuid,integer,text) to authenticated;
grant execute on function public.my_ratings() to authenticated;
grant execute on function public.refresh_account_rating(uuid) to authenticated;

-- backfill scores for any reviews already on file
select refresh_account_rating(id) from accounts;

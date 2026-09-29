-- Admin activity log: who is doing what on the platform, and how much.
--
-- One function, admin only. It reads the tables the platform already writes —
-- sign-ups, listings, requirements, quote requests, quotes, lead purchases,
-- finance and logistics enquiries, ratings, messages — and returns:
--
--   summary   counts per activity for today, 7 days, 30 days and all time
--   daily     events per day for the last 14 days
--   top       most-requested products and most-contacted suppliers
--   feed      the latest events, newest first
--
-- Each source is read inside its own exception block, so a table that does not
-- exist yet in your database is skipped instead of failing the whole screen.
-- Bulk-imported listings are excluded from the feed, or 44,000 rows stamped at
-- one moment would bury everything a real person did.
--
-- Safe to re-run.

begin;

do $$
declare r record;
begin
  for r in select p.oid::regprocedure as sig from pg_proc p
             join pg_namespace n on n.oid = p.pronamespace
            where n.nspname = 'public' and p.proname = 'admin_activity'
  loop execute 'drop function ' || r.sig; end loop;
end $$;

create or replace function public.admin_activity(p_days integer default 30)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_since timestamptz := now() - make_interval(days => greatest(coalesce(p_days, 30), 1));
  v_out jsonb;
begin
  if not is_admin() then raise exception 'Admin account required'; end if;

  create temp table if not exists _act (
    kind text, at timestamptz, actor text, subject text, detail text
  ) on commit drop;
  truncate _act;

  -- sign-ups
  begin
    insert into _act
    select case when a.role = 'supplier' then 'supplier_signup' else 'buyer_signup' end,
           a.created_at, coalesce(a.company, a.email, 'Unnamed'),
           case when a.role = 'supplier' then 'Supplier registered' else 'Buyer registered' end,
           coalesce(a.district_id, '')
      from accounts a
     where a.role in ('buyer', 'supplier') and a.created_at is not null
       and coalesce(a.import_source, '') = '';
  exception when others then
    begin
      insert into _act
      select case when a.role = 'supplier' then 'supplier_signup' else 'buyer_signup' end,
             a.created_at, coalesce(a.company, a.email, 'Unnamed'),
             case when a.role = 'supplier' then 'Supplier registered' else 'Buyer registered' end,
             coalesce(a.district_id, '')
        from accounts a where a.role in ('buyer', 'supplier') and a.created_at is not null;
    exception when others then null; end;
  end;

  -- listings added by suppliers themselves (imports excluded)
  begin
    insert into _act
    select 'listing', p.created_at, coalesce(a.company, 'Supplier'), p.name,
           coalesce(p.category_id, '')
      from products p join accounts a on a.id = p.supplier_id
     where p.created_at is not null and coalesce(p.import_source, '') = '';
  exception when others then null; end;

  -- requirements posted by buyers
  begin
    insert into _act
    select 'requirement', r.created_at, coalesce(a.company, 'Buyer'), r.title,
           trim(coalesce(r.quantity::text, '') || ' ' || coalesce(r.quantity_unit, ''))
      from requirements r join accounts a on a.id = r.buyer_id
     where r.created_at is not null;
  exception when others then null; end;

  -- quote requests and enquiries: a conversation opened by a buyer
  begin
    insert into _act
    select 'quote_request', c.created_at, coalesce(b.company, 'Buyer'),
           coalesce(nullif(c.subject, ''), 'Enquiry'),
           'to ' || coalesce(s.company, 'supplier')
      from conversations c
      left join accounts b on b.id = c.buyer_id
      left join accounts s on s.id = c.supplier_id
     where c.created_at is not null;
  exception when others then null; end;

  -- quotes sent by suppliers
  begin
    insert into _act
    select 'quote', q.created_at, coalesce(s.company, 'Supplier'),
           coalesce(r.title, 'Quote'),
           case when q.unit_price is not null
                then 'UGX ' || to_char(q.unit_price, 'FM999,999,999,999') else '' end
      from quotes q
      left join accounts s on s.id = q.supplier_id
      left join requirements r on r.id = q.requirement_id
     where q.created_at is not null;
  exception when others then null; end;

  -- buy leads unlocked
  begin
    insert into _act
    select 'lead_purchase', l.created_at, coalesce(s.company, 'Supplier'),
           coalesce(r.title, 'Buy lead'), ''
      from lead_purchases l
      left join accounts s on s.id = l.supplier_id
      left join requirements r on r.id = l.requirement_id
     where l.created_at is not null;
  exception when others then null; end;

  -- credit, tax and trade finance interest
  begin
    insert into _act
    select 'finance', e.created_at, coalesce(a.company, 'Account'),
           case e.kind when 'credit' then 'Business credit'
                       when 'tax' then 'Tax and accounting'
                       when 'trade_finance' then 'Trade finance' else e.kind end,
           case when e.indicative_limit is not null
                then 'UGX ' || to_char(e.indicative_limit, 'FM999,999,999,999') else '' end
      from finance_enquiries e join accounts a on a.id = e.account_id
     where e.created_at is not null;
  exception when others then null; end;

  -- haulage requests
  begin
    insert into _act
    select 'logistics', l.created_at, coalesce(a.company, 'Account'),
           coalesce(initcap(l.from_district), '?') || ' → ' || coalesce(initcap(l.to_district), '?'),
           coalesce(l.vehicle_type, '')
      from logistics_requests l join accounts a on a.id = l.account_id
     where l.created_at is not null;
  exception when others then null; end;

  -- ratings, both directions
  begin
    insert into _act
    select 'rating', r.created_at, coalesce(b.company, 'Buyer'),
           'Rated ' || coalesce(s.company, 'a supplier'), r.rating::text || ' ★'
      from supplier_reviews r
      left join accounts b on b.id = r.buyer_id
      left join accounts s on s.id = r.supplier_id
     where r.created_at is not null;
  exception when others then null; end;
  begin
    insert into _act
    select 'rating', r.created_at, coalesce(s.company, 'Supplier'),
           'Rated ' || coalesce(b.company, 'a buyer'), r.rating::text || ' ★'
      from buyer_reviews r
      left join accounts b on b.id = r.buyer_id
      left join accounts s on s.id = r.supplier_id
     where r.created_at is not null;
  exception when others then null; end;

  -- messages: counted, not listed one by one
  begin
    insert into _act
    select 'message', m.created_at, '', '', ''
      from messages m where m.created_at is not null;
  exception when others then null; end;

  select jsonb_build_object(
    'generated_at', now(),
    'summary', '{}'::jsonb,
    'daily', coalesce((
      select jsonb_agg(jsonb_build_object('day', d::date, 'n', (
        select count(*) from _act where kind <> 'message'
           and at >= d and at < d + interval '1 day')) order by d)
      from generate_series(date_trunc('day', now()) - interval '13 days',
                           date_trunc('day', now()), interval '1 day') d
    ), '[]'::jsonb),
    'top_products', coalesce((
      select jsonb_agg(x) from (
        select jsonb_build_object('name', subject, 'n', count(*)) x
          from _act where kind in ('quote_request', 'requirement') and at >= v_since
         group by subject order by count(*) desc limit 6) t
    ), '[]'::jsonb),
    'top_suppliers', coalesce((
      select jsonb_agg(x) from (
        select jsonb_build_object('name', substr(detail, 4), 'n', count(*)) x
          from _act where kind = 'quote_request' and at >= v_since
         group by detail order by count(*) desc limit 6) t
    ), '[]'::jsonb),
    'feed', coalesce((
      select jsonb_agg(jsonb_build_object('kind', kind, 'at', at, 'actor', actor,
               'subject', subject, 'detail', detail) order by at desc)
        from (select * from _act where kind <> 'message' and at >= v_since
               order by at desc limit 300) f
    ), '[]'::jsonb)
  ) into v_out;

  -- counts per activity
  select jsonb_set(v_out, '{summary}', coalesce((
    select jsonb_object_agg(kind, s) from (
      select kind, jsonb_build_object(
        'today', count(*) filter (where at >= date_trunc('day', now())),
        'week',  count(*) filter (where at >= now() - interval '7 days'),
        'month', count(*) filter (where at >= now() - interval '30 days'),
        'total', count(*)) s
      from _act group by kind) k), '{}'::jsonb))
  into v_out;

  return v_out;
end;
$$;

grant execute on function public.admin_activity(integer) to authenticated;

commit;

notify pgrst, 'reload schema';

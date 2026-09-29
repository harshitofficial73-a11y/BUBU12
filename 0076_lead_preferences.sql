-- Lead preferences that actually save.
--
-- The screen had its own local defaults and its Save button wrote company
-- details instead — so nothing a supplier chose there ever reached the
-- database or changed which leads they saw. These two functions read and
-- write exactly what the screen shows. The categories chosen become the
-- account's trade categories, which is what the lead board matches on.
--
-- Safe to re-run.

alter table public.lead_preferences add column if not exists excluded     text[]  not null default '{}';
alter table public.lead_preferences add column if not exists daily_cap    integer not null default 4;
alter table public.lead_preferences add column if not exists vat_only     boolean not null default false;
alter table public.lead_preferences add column if not exists repeat_first boolean not null default false;

create or replace function public.my_lead_preferences()
returns jsonb language sql stable security definer set search_path = public as $$
  select jsonb_build_object(
    'districts',     coalesce(p.districts, '{}'),
    'min_value',     p.min_value,
    'verified_only', coalesce(p.verified_only, false),
    'vat_only',      coalesce(p.vat_only, false),
    'repeat_first',  coalesce(p.repeat_first, false),
    'excluded',      coalesce(p.excluded, '{}'),
    'daily_cap',     coalesce(p.daily_cap, 4),
    'categories',    coalesce((select jsonb_agg(ac.category_id) from account_categories ac
                                where ac.account_id = a.id), '[]'::jsonb),
    'saved',         p.account_id is not null)
  from accounts a
  left join lead_preferences p on p.account_id = a.id
  where a.id = current_account_id();
$$;
grant execute on function public.my_lead_preferences() to authenticated;

create or replace function public.save_lead_preferences(
  p_districts text[], p_min_value bigint, p_verified_only boolean, p_vat_only boolean,
  p_repeat_first boolean, p_excluded text[], p_daily_cap integer, p_categories text[])
returns jsonb language plpgsql security definer set search_path = public as $$
declare v_acct uuid := current_account_id();
begin
  if v_acct is null then raise exception 'Sign in first'; end if;

  insert into lead_preferences (account_id, districts, nationwide, min_value, verified_only,
                                vat_only, repeat_first, excluded, daily_cap)
  values (v_acct, coalesce(p_districts, '{}'), coalesce(cardinality(p_districts), 0) = 0,
          p_min_value, coalesce(p_verified_only, false), coalesce(p_vat_only, false),
          coalesce(p_repeat_first, false), coalesce(p_excluded, '{}'), greatest(1, coalesce(p_daily_cap, 4)))
  on conflict (account_id) do update set
    districts = excluded.districts, nationwide = excluded.nationwide, min_value = excluded.min_value,
    verified_only = excluded.verified_only, vat_only = excluded.vat_only,
    repeat_first = excluded.repeat_first, excluded = excluded.excluded, daily_cap = excluded.daily_cap;

  -- Only replace categories when some were chosen, so an empty save never
  -- silently takes a supplier off every lead.
  if coalesce(cardinality(p_categories), 0) > 0 then
    delete from account_categories where account_id = v_acct;
    insert into account_categories (account_id, category_id)
    select v_acct, c from unnest(p_categories) c
    where exists (select 1 from categories where id = c)
    on conflict do nothing;
  end if;

  return public.my_lead_preferences();
end $$;
grant execute on function public.save_lead_preferences(text[], bigint, boolean, boolean, boolean, text[], integer, text[]) to authenticated;

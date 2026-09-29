-- Free plan: 30 buy leads a month, then pay per lead.
--
-- Until now the free plan granted 0 credits, so every lead cost UGX 18,000
-- from the first one. Now each free account gets 30 on the 1st of every
-- month; once those are used the existing pay-per-lead step takes over.
--
-- Also accepts accounts that registered as buyers and were later approved to
-- sell (supplier_state = 'approved'), which the old role check shut out.
--
-- Safe to re-run.

create or replace function ensure_monthly_lead_credits(p_account uuid default current_account_id())
returns integer language plpgsql security definer set search_path=public as $$
declare v_tier membership_tier; v_allowance integer; v_start date; v_end date;
begin
  select tier into v_tier from accounts
   where id = p_account and (role = 'supplier' or supplier_state = 'approved');
  if not found then return 0; end if;
  v_allowance := case v_tier when 'industry_leader' then 50 when 'star_supplier' then 20 else 30 end;
  v_start := date_trunc('month', current_date)::date;
  v_end := (date_trunc('month', current_date) + interval '1 month - 1 day')::date;
  insert into lead_credits(account_id,granted,used,expires_on,period_start,source)
  values(p_account,v_allowance,0,v_end,v_start,'monthly_plan')
  on conflict(account_id,period_start,source) where period_start is not null do nothing;
  return coalesce((select sum(granted-used) from lead_credits
    where account_id=p_account and source='monthly_plan' and period_start=v_start),0);
end $$;
grant execute on function ensure_monthly_lead_credits(uuid) to authenticated;

create or replace function lead_balance()
returns jsonb language plpgsql security definer set search_path=public as $$
declare v_account uuid:=current_account_id(); v_tier membership_tier; v_remaining integer;
begin
  if v_account is null then raise exception 'sign in required'; end if;
  select tier into v_tier from accounts where id=v_account;
  v_remaining := ensure_monthly_lead_credits(v_account);
  return jsonb_build_object('tier',v_tier,'remaining',v_remaining,
    'monthly_allowance',case v_tier when 'industry_leader' then 50 when 'star_supplier' then 20 else 30 end,
    'cash_price',18000);
end $$;
grant execute on function lead_balance() to authenticated;

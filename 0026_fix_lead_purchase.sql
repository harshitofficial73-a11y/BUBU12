-- purchase_lead still used the old category gate, which blocks the very leads
-- the new matcher surfaces.
--
-- Two problems with it. It required the supplier to hold a row in
-- account_categories at all, so a supplier who never picked categories could
-- buy nothing — not even a lead with no category, because the `is null` branch
-- sat inside an EXISTS over that same empty table. And it ignored the
-- word-stem matching that decides what appears on the board in the first
-- place, so a lead could be visible and unbuyable at once.
--
-- The gate is now the board itself: if my_buy_leads() shows it, it can be
-- bought. One rule, one place.

create or replace function purchase_lead(p_requirement uuid, p_confirm_cash_payment boolean default false)
returns jsonb language plpgsql security definer set search_path=public as $$
declare
  v_supplier uuid:=current_account_id(); v_req requirements; v_buyer accounts;
  v_tier membership_tier; v_credit lead_credits; v_purchase lead_purchases;
  v_conversation conversations; v_remaining integer; v_amount bigint:=0; v_state text:='included_credit';
begin
  if v_supplier is null then raise exception 'sign in required'; end if;
  select tier into v_tier from accounts where id=v_supplier and role='supplier';
  if not found then raise exception 'supplier account required'; end if;
  select * into v_req from requirements where id=p_requirement and state='open' for share;
  if not found then raise exception 'requirement is no longer open'; end if;
  if v_req.buyer_id = v_supplier then raise exception 'this is your own requirement'; end if;

  -- already bought: hand back the details rather than charging twice
  select * into v_purchase from lead_purchases
    where supplier_id=v_supplier and requirement_id=p_requirement;
  if found and v_purchase.payment_state <> 'payment_required' then
    select * into v_buyer from accounts where id=v_req.buyer_id;
    return jsonb_build_object('status','already_purchased','buyer_phone',v_buyer.phone,
      'buyer_company',v_buyer.company,'buyer_email',v_buyer.email,
      'conversation_id',v_purchase.conversation_id,
      'remaining',ensure_monthly_lead_credits(v_supplier),'charged',v_purchase.payment_amount);
  end if;

  -- the board decides eligibility
  if not exists (select 1 from my_buy_leads() b where b.id = p_requirement) then
    raise exception 'this lead is not on your board';
  end if;

  perform ensure_monthly_lead_credits(v_supplier);
  select * into v_credit from lead_credits where account_id=v_supplier
    and source='monthly_plan' and period_start=date_trunc('month',current_date)::date
    and used<granted for update skip locked limit 1;
  if not found then
    if not p_confirm_cash_payment then
      -- no row is written here any more. Recording a 'payment_required' row
      -- made the lead look half-bought: it stayed on the board, opened no
      -- chat, and revealed nothing, which is exactly what a supplier reported
      -- as "I bought it and nothing happened".
      return jsonb_build_object('status','payment_required','charged',18000,'remaining',0);
    end if;
    v_amount:=18000; v_state:='paid';
  else
    update lead_credits set used=used+1 where id=v_credit.id;
  end if;

  insert into conversations(supplier_id,buyer_id,requirement_id,last_message_at)
  values(v_supplier,v_req.buyer_id,p_requirement,now())
  on conflict(supplier_id,buyer_id,requirement_id) do update set last_message_at=excluded.last_message_at
  returning * into v_conversation;
  insert into contact_reveals(account_id,requirement_id)
  values(v_supplier,p_requirement) on conflict do nothing;
  insert into lead_purchases(supplier_id,requirement_id,payment_amount,payment_state,conversation_id)
  values(v_supplier,p_requirement,v_amount,v_state,v_conversation.id)
  on conflict(supplier_id,requirement_id) do update set payment_amount=excluded.payment_amount,
    payment_state=excluded.payment_state,conversation_id=excluded.conversation_id,purchased_at=now()
  returning * into v_purchase;
  select * into v_buyer from accounts where id=v_req.buyer_id;
  v_remaining:=ensure_monthly_lead_credits(v_supplier);
  return jsonb_build_object('status','purchased','buyer_phone',v_buyer.phone,
    'buyer_company',v_buyer.company,'buyer_email',v_buyer.email,
    'conversation_id',v_conversation.id,
    'remaining',v_remaining,'charged',v_amount);
end $$;

grant execute on function purchase_lead(uuid,boolean) to authenticated;

-- Clear any half-bought rows the old version left behind, so those leads stop
-- looking purchased-but-not-purchased.
delete from lead_purchases where payment_state = 'payment_required';

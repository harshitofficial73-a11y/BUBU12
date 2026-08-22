-- Buyer requirement -> matched supplier lead -> credit/payment -> contact + chat.
-- Star suppliers receive 20 lead purchases per calendar month; Industry Leaders 50.

alter table categories add column if not exists image_url text;

insert into categories(id,name,sort) values
 ('building-construction','Building & construction',1),
 ('agriculture-produce','Agriculture & produce',9),
 ('food-beverage','Food & beverage wholesale',12),
 ('packaging','Packaging',13),('chemicals-industrial','Chemicals & industrial',14),
 ('medical-supplies','Medical supplies',15),('electronics','Electronics',16),
 ('solar-power','Solar & power',17),('auto-parts','Auto parts',18),
 ('furniture-fittings','Furniture & fittings',19),('textiles-apparel','Textiles & apparel',20),
 ('stationery-printing','Stationery & printing',21),('cleaning-hygiene','Cleaning & hygiene',22)
on conflict(id) do update set name=excluded.name,sort=excluded.sort;
insert into categories(id,name,parent_id,sort) values
 ('cement-aggregates','Cement & aggregates','building-construction',2),
 ('steel-metal','Steel & metal','building-construction',3),
 ('roofing-ceilings','Roofing & ceilings','building-construction',4),
 ('hardware-tools','Hardware & tools','building-construction',5),
 ('electrical-lighting','Electrical & lighting','building-construction',6),
 ('plumbing-sanitary','Plumbing & sanitary','building-construction',7),
 ('paints-finishes','Paints & finishes','building-construction',8),
 ('agro-inputs-seeds','Agro inputs & seeds','agriculture-produce',10),
 ('livestock-feeds','Livestock & feeds','agriculture-produce',11)
on conflict(id) do update set name=excluded.name,parent_id=excluded.parent_id,sort=excluded.sort;

update categories set image_url = case id
  when 'building-construction' then 'assets/categories/building-construction.avif'
  when 'cement-aggregates' then 'assets/categories/cement-aggregates.jpg'
  when 'steel-metal' then 'assets/categories/steel-metal.avif'
  when 'roofing-ceilings' then 'assets/categories/roofing-ceilings.jpeg'
  when 'hardware-tools' then 'assets/categories/hardware-tools.jpeg'
  when 'electrical-lighting' then 'assets/categories/electrical-lighting.webp'
  when 'plumbing-sanitary' then 'assets/categories/plumbing-sanitary.webp'
  when 'paints-finishes' then 'assets/categories/paints-finishes.webp'
  when 'agriculture-produce' then 'assets/categories/agriculture-produce.jpeg'
  when 'agro-inputs-seeds' then 'assets/categories/agro-inputs-seeds.webp'
  when 'livestock-feeds' then 'assets/categories/livestock-feeds.jpg'
  when 'food-beverage' then 'assets/categories/food-beverage.webp'
  when 'packaging' then 'assets/categories/packaging.jpeg'
  when 'chemicals-industrial' then 'assets/categories/chemicals-industrial.jpg'
  when 'medical-supplies' then 'assets/categories/medical-supplies.webp'
  when 'electronics' then 'assets/categories/electronics.jpg'
  when 'solar-power' then 'assets/categories/solar-power.jpeg'
  when 'auto-parts' then 'assets/categories/auto-parts.webp'
  when 'furniture-fittings' then 'assets/categories/furniture-fittings.jpg'
  when 'textiles-apparel' then 'assets/categories/textiles-apparel.webp'
  when 'stationery-printing' then 'assets/categories/stationery-printing.jpg'
  when 'cleaning-hygiene' then 'assets/categories/cleaning-hygiene.jpeg'
  else image_url end;

-- Temporary launch rule requested by BUBU: every supplier starts on Star.
update accounts set tier = 'star_supplier' where role = 'supplier';

alter table lead_credits add column if not exists period_start date;
alter table lead_credits add column if not exists source text not null default 'legacy';
create unique index if not exists lead_credits_monthly_unique
  on lead_credits(account_id, period_start, source) where period_start is not null;

create table if not exists lead_purchases (
  id uuid primary key default uuid_generate_v4(),
  supplier_id uuid not null references accounts(id) on delete cascade,
  requirement_id uuid not null references requirements(id) on delete cascade,
  payment_amount bigint not null default 0,
  payment_state text not null default 'included_credit'
    check (payment_state in ('included_credit','paid','payment_required')),
  conversation_id uuid references conversations(id) on delete set null,
  purchased_at timestamptz not null default now(),
  unique(supplier_id, requirement_id)
);
alter table lead_purchases enable row level security;
drop policy if exists lead_purchases_own on lead_purchases;
create policy lead_purchases_own on lead_purchases for select
  using (supplier_id = current_account_id() or is_admin());

create unique index if not exists contact_reveals_requirement_unique
  on contact_reveals(account_id, requirement_id) where requirement_id is not null;

create or replace function ensure_monthly_lead_credits(p_account uuid default current_account_id())
returns integer language plpgsql security definer set search_path=public as $$
declare v_tier membership_tier; v_allowance integer; v_start date; v_end date;
begin
  select tier into v_tier from accounts where id=p_account and role='supplier';
  v_allowance := case v_tier when 'industry_leader' then 50 when 'star_supplier' then 20 else 0 end;
  v_start := date_trunc('month', current_date)::date;
  v_end := (date_trunc('month', current_date) + interval '1 month - 1 day')::date;
  if v_allowance > 0 then
    insert into lead_credits(account_id,granted,used,expires_on,period_start,source)
    values(p_account,v_allowance,0,v_end,v_start,'monthly_plan')
    on conflict(account_id,period_start,source) where period_start is not null do nothing;
  end if;
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
    'monthly_allowance',case v_tier when 'industry_leader' then 50 when 'star_supplier' then 20 else 0 end,
    'cash_price',18000);
end $$;
grant execute on function lead_balance() to authenticated;

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
  if not exists (
    select 1 from account_categories ac
    left join categories rc on rc.id=v_req.category_id
    left join categories sc on sc.id=ac.category_id
    where ac.account_id=v_supplier and (
      v_req.category_id is null or ac.category_id=v_req.category_id
      or ac.category_id=rc.parent_id or sc.parent_id=v_req.category_id
    )
  ) then raise exception 'this requirement is outside your categories'; end if;

  select * into v_purchase from lead_purchases
    where supplier_id=v_supplier and requirement_id=p_requirement;
  if found and v_purchase.payment_state <> 'payment_required' then
    select * into v_buyer from accounts where id=v_req.buyer_id;
    return jsonb_build_object('status','already_purchased','buyer_phone',v_buyer.phone,
      'buyer_company',v_buyer.company,'conversation_id',v_purchase.conversation_id,
      'remaining',ensure_monthly_lead_credits(v_supplier),'charged',v_purchase.payment_amount);
  end if;

  perform ensure_monthly_lead_credits(v_supplier);
  select * into v_credit from lead_credits where account_id=v_supplier
    and source='monthly_plan' and period_start=date_trunc('month',current_date)::date
    and used<granted for update skip locked limit 1;
  if not found then
    if not p_confirm_cash_payment then
      insert into lead_purchases(supplier_id,requirement_id,payment_amount,payment_state)
      values(v_supplier,p_requirement,18000,'payment_required')
      on conflict(supplier_id,requirement_id) do update set payment_amount=18000,payment_state='payment_required';
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
    'buyer_company',v_buyer.company,'conversation_id',v_conversation.id,
    'remaining',v_remaining,'charged',v_amount);
end $$;
grant execute on function purchase_lead(uuid,boolean) to authenticated;

create or replace function reveal_contact(p_requirement uuid, p_product uuid)
returns text language plpgsql security definer set search_path=public as $$
declare v_result jsonb; v_account uuid:=current_account_id(); v_target text;
begin
  if p_requirement is not null then
    v_result:=purchase_lead(p_requirement,false);
    if v_result->>'status'='payment_required' then raise exception 'payment of UGX 18,000 required'; end if;
    return v_result->>'buyer_phone';
  end if;
  select a.phone into v_target from products p join accounts a on a.id=p.supplier_id where p.id=p_product;
  return v_target;
end $$;

create or replace function my_buy_leads()
returns setof requirements language sql stable security definer set search_path=public as $$
  select distinct r.* from requirements r
  join categories rc on rc.id=r.category_id
  join account_categories ac on ac.account_id=current_account_id()
  left join categories sc on sc.id=ac.category_id
  left join lead_preferences pref on pref.account_id=current_account_id()
  where r.state='open' and r.buyer_id<>current_account_id()
    and (ac.category_id=r.category_id or ac.category_id=rc.parent_id or sc.parent_id=r.category_id)
    and (pref.account_id is null or pref.min_value is null or coalesce(r.estimated_value,0)>=pref.min_value)
    and (pref.account_id is null or pref.nationwide or cardinality(pref.districts)=0
      or r.district_id=any(pref.districts)
      or exists(select 1 from unnest(pref.districts) d where district_km(d,r.district_id)<=pref.radius_km))
  order by r.created_at desc;
$$;

update plans set lead_credits=20 where tier='star_supplier';
update plans set lead_credits=50 where tier='industry_leader';
update fee_rules set minimum=18000,note='UGX 18,000 when no included monthly credit remains'
  where name='Buy lead credit';

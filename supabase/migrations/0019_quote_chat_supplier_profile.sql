-- Product quote requests, buyer notifications and buyer-safe supplier profiles.

create table if not exists public.buyer_notifications (
  id uuid primary key default uuid_generate_v4(),
  buyer_id uuid not null references public.accounts(id) on delete cascade,
  topic text not null,
  title text not null,
  body text,
  entity_type text,
  entity_id uuid,
  read_at timestamptz,
  created_at timestamptz not null default now()
);
create index if not exists buyer_notifications_buyer_created_idx
  on public.buyer_notifications(buyer_id, created_at desc);

create table if not exists public.supplier_reviews (
  id uuid primary key default uuid_generate_v4(),
  supplier_id uuid not null references public.accounts(id) on delete cascade,
  buyer_id uuid not null references public.accounts(id) on delete cascade,
  rating integer not null check (rating between 1 and 5),
  body text,
  created_at timestamptz not null default now(),
  unique (supplier_id, buyer_id)
);

alter table public.buyer_notifications enable row level security;
alter table public.supplier_reviews enable row level security;

drop policy if exists buyer_notifications_own_read on public.buyer_notifications;
create policy buyer_notifications_own_read on public.buyer_notifications
for select to authenticated using (
  buyer_id = (select id from public.accounts where auth_user_id = auth.uid())
);
drop policy if exists buyer_notifications_own_update on public.buyer_notifications;
create policy buyer_notifications_own_update on public.buyer_notifications
for update to authenticated using (
  buyer_id = (select id from public.accounts where auth_user_id = auth.uid())
) with check (
  buyer_id = (select id from public.accounts where auth_user_id = auth.uid())
);
drop policy if exists supplier_reviews_public_read on public.supplier_reviews;
create policy supplier_reviews_public_read on public.supplier_reviews for select using (true);
drop policy if exists supplier_reviews_buyer_write on public.supplier_reviews;
create policy supplier_reviews_buyer_write on public.supplier_reviews
for all to authenticated using (
  buyer_id = (select id from public.accounts where auth_user_id = auth.uid())
) with check (
  buyer_id = (select id from public.accounts where auth_user_id = auth.uid())
);

create or replace function public.submit_product_quote_request(
  p_product uuid, p_supplier uuid, p_quantity numeric default 1
) returns jsonb language plpgsql security definer set search_path=public as $$
declare
  v_buyer accounts%rowtype;
  v_product products%rowtype;
  v_requirement uuid;
  v_conversation uuid;
begin
  select * into v_buyer from accounts where auth_user_id=auth.uid() and role='buyer';
  if v_buyer.id is null then raise exception 'Buyer account required'; end if;
  select * into v_product from products
    where id=p_product and supplier_id=p_supplier and status='published';
  if v_product.id is null then raise exception 'Published supplier product not found'; end if;

  insert into requirements(buyer_id,title,category_id,quantity,quantity_unit,specification,
    purpose,deliver_to,district_id,state)
  values(v_buyer.id,v_product.name,v_product.category_id,greatest(coalesce(p_quantity,1),1),
    coalesce(v_product.unit,'units'),v_product.description,'Business use',v_buyer.address,
    v_buyer.district_id,'open') returning id into v_requirement;

  insert into conversations(supplier_id,buyer_id,requirement_id,last_message_at)
  values(p_supplier,v_buyer.id,v_requirement,now()) returning id into v_conversation;

  insert into messages(conversation_id,sender_id,direction,channel,body)
  values(v_conversation,v_buyer.id,'out','app',
    'Quote requested for '||v_product.name||' — quantity '||greatest(coalesce(p_quantity,1),1)||' '||coalesce(v_product.unit,'units')||'.');

  return jsonb_build_object('requirement_id',v_requirement,'conversation_id',v_conversation,
    'supplier_id',p_supplier,'product_id',p_product);
end $$;

create or replace function public.start_supplier_conversation(p_supplier uuid)
returns jsonb language plpgsql security definer set search_path=public as $$
declare v_buyer uuid; v_id uuid;
begin
  select id into v_buyer from accounts where auth_user_id=auth.uid() and role='buyer';
  if v_buyer is null then raise exception 'Buyer account required'; end if;
  select id into v_id from conversations where supplier_id=p_supplier and buyer_id=v_buyer
    order by last_message_at desc nulls last,created_at desc limit 1;
  if v_id is null then
    insert into conversations(supplier_id,buyer_id,last_message_at)
      values(p_supplier,v_buyer,now()) returning id into v_id;
  end if;
  return jsonb_build_object('conversation_id',v_id,'supplier_id',p_supplier);
end $$;

create or replace function public.reveal_supplier_contact(p_supplier uuid)
returns jsonb language plpgsql security definer set search_path=public as $$
declare v_buyer uuid; v_supplier accounts%rowtype;
begin
  select id into v_buyer from accounts where auth_user_id=auth.uid() and role='buyer';
  if v_buyer is null then raise exception 'Buyer account required'; end if;
  select * into v_supplier from accounts where id=p_supplier and role='supplier';
  if v_supplier.id is null then raise exception 'Supplier not found'; end if;
  return jsonb_build_object('supplier_id',v_supplier.id,'company',v_supplier.company,
    'phone',v_supplier.phone,'whatsapp_phone',v_supplier.whatsapp_phone);
end $$;

create or replace function public.load_public_supplier_profile(p_supplier uuid)
returns jsonb language plpgsql security definer set search_path=public as $$
declare v_buyer uuid; v_result jsonb;
begin
  select id into v_buyer from accounts where auth_user_id=auth.uid() and role='buyer';
  if v_buyer is null then raise exception 'Buyer account required'; end if;
  select jsonb_build_object(
    'id',a.id,'company',a.company,'trade_name',a.trade_name,'initials',a.initials,
    'tier',a.tier,'business_type',a.business_type,'district_id',a.district_id,
    'about',a.about,'coverage',a.coverage,'nature_of_business',a.nature_of_business,
    'brands',a.brands,'verification_state',r.overall_state,
    'credentials',jsonb_build_object('ursb_state',r.ursb_state,'tin_state',r.tin_state,
      'licence_state',r.licence_state),
    'products',coalesce((select jsonb_agg(to_jsonb(p) order by p.created_at desc)
      from products p where p.supplier_id=a.id and p.status='published'),'[]'::jsonb),
    'reviews',coalesce((select jsonb_agg(jsonb_build_object('rating',sr.rating,'body',sr.body,
      'created_at',sr.created_at,'buyer',ba.company) order by sr.created_at desc)
      from supplier_reviews sr join accounts ba on ba.id=sr.buyer_id where sr.supplier_id=a.id),'[]'::jsonb),
    'past_quotes',coalesce((select jsonb_agg(jsonb_build_object('id',q.id,'state',q.state,
      'unit_price',q.unit_price,'lead_time',q.lead_time,'message',q.message,'created_at',q.created_at,
      'requirement',rq.title) order by q.created_at desc)
      from quotes q join requirements rq on rq.id=q.requirement_id
      where q.supplier_id=a.id and rq.buyer_id=v_buyer),'[]'::jsonb),
    'conversations',coalesce((select jsonb_agg(jsonb_build_object('id',c.id,
      'requirement_id',c.requirement_id,'last_message_at',c.last_message_at) order by c.created_at desc)
      from conversations c where c.supplier_id=a.id and c.buyer_id=v_buyer),'[]'::jsonb)
  ) into v_result from accounts a join account_registration r on r.account_id=a.id
  where a.id=p_supplier and a.role='supplier' and r.overall_state='verified';
  if v_result is null then raise exception 'Verified supplier not found'; end if;
  return v_result;
end $$;

create or replace function public.notify_buyer_on_quote() returns trigger
language plpgsql security definer set search_path=public as $$
declare v_buyer uuid; v_supplier text;
begin
  if new.state='sent' and (tg_op='INSERT' or old.state is distinct from new.state) then
    select r.buyer_id,a.company into v_buyer,v_supplier from requirements r
      join accounts a on a.id=new.supplier_id where r.id=new.requirement_id;
    insert into buyer_notifications(buyer_id,topic,title,body,entity_type,entity_id)
      values(v_buyer,'quote','New quotation received',v_supplier||' sent you a quotation.',
        'quote',new.id);
  end if;
  return new;
end $$;
drop trigger if exists quote_buyer_notification on public.quotes;
create trigger quote_buyer_notification after insert or update of state on public.quotes
for each row execute function public.notify_buyer_on_quote();

grant select,update on public.buyer_notifications to authenticated;
grant select,insert,update,delete on public.supplier_reviews to authenticated;
grant execute on function public.submit_product_quote_request(uuid,uuid,numeric) to authenticated;
grant execute on function public.start_supplier_conversation(uuid) to authenticated;
grant execute on function public.reveal_supplier_contact(uuid) to authenticated;
grant execute on function public.load_public_supplier_profile(uuid) to authenticated;

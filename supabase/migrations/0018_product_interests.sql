create table if not exists product_interests (
  buyer_id uuid not null references accounts(id) on delete cascade,
  product_id uuid not null references products(id) on delete cascade,
  notifications_enabled boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  primary key (buyer_id, product_id)
);

alter table product_interests enable row level security;
drop policy if exists product_interests_buyer_manage on product_interests;
create policy product_interests_buyer_manage on product_interests for all to authenticated
using (buyer_id=current_account_id()) with check (buyer_id=current_account_id());

grant select,insert,update,delete on product_interests to authenticated;

create table if not exists product_interest_notifications (
  id uuid primary key default uuid_generate_v4(),
  buyer_id uuid not null references accounts(id) on delete cascade,
  product_id uuid not null references products(id) on delete cascade,
  title text not null,
  body text not null,
  read_at timestamptz,
  created_at timestamptz not null default now()
);
alter table product_interest_notifications enable row level security;
drop policy if exists product_interest_notifications_buyer_read on product_interest_notifications;
create policy product_interest_notifications_buyer_read on product_interest_notifications for select to authenticated
using (buyer_id=current_account_id());
grant select on product_interest_notifications to authenticated;

create or replace function notify_product_interest_buyers() returns trigger language plpgsql security definer set search_path=public as $$
begin
  if old.price is distinct from new.price or old.status is distinct from new.status or old.name is distinct from new.name then
    insert into product_interest_notifications(buyer_id,product_id,title,body)
    select i.buyer_id,new.id,'Product update: '||new.name,
      case when old.price is distinct from new.price then 'Price updated to UGX '||trim(to_char(new.price,'FM999G999G999G990'))
           when old.status is distinct from new.status then 'Availability changed to '||new.status::text
           else 'Product information was updated' end
    from product_interests i where i.product_id=new.id and i.notifications_enabled;
  end if;
  return new;
end $$;
drop trigger if exists product_interest_product_update on products;
create trigger product_interest_product_update after update on products for each row execute function notify_product_interest_buyers();

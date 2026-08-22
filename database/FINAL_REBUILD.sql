-- BUBU.Market FINAL REBUILD
-- Run after FINAL_RESET.sql or in a new Supabase project.


-- ============================================================
-- deploy/supabase/migrations/0001_schema.sql
-- ============================================================

-- BUBU.Market · Supabase schema
-- Run in order: 0001_schema.sql, 0002_rls.sql, 0003_functions.sql, then seed.sql
-- Money is stored in integer UGX minor-free units (no decimals). Dates are timestamptz.

create extension if not exists "uuid-ossp";
create extension if not exists "pgcrypto";

-- ─────────────────────────────────────────── enums

create type account_role      as enum ('buyer','supplier','admin');
create type business_type     as enum ('trader','manufacturer');
create type membership_tier   as enum ('free','star_supplier','industry_leader');
create type verification_state as enum ('unverified','pending','verified','rejected');
create type listing_status    as enum ('draft','published','archived');
create type requirement_state as enum ('open','quoted','awarded','withdrawn','expired');
create type quote_state       as enum ('draft','sent','accepted','rejected','expired');
create type order_state       as enum ('pending_payment','funded','dispatch','in_transit','delivered','closed','refunded');
create type escrow_state      as enum ('none','held','released','refunded');
create type payment_method    as enum ('mtn_momo','airtel_money','bank_transfer','credit_terms');
create type payment_state     as enum ('prompt_sent','success','failed','timeout');
create type dispute_state     as enum ('open','under_review','resolved');
create type dispute_outcome   as enum ('refund_buyer','release_supplier','split');
create type message_channel   as enum ('app','whatsapp','sms','call');
create type message_direction as enum ('in','out');
create type document_kind     as enum ('certificate_of_incorporation','ura_tin_certificate','trading_licence',
                                        'vat_certificate','national_id','bank_confirmation','unbs_certificate','other');

-- ─────────────────────────────────────────── geography

create table districts (
  id            text primary key,              -- 'kampala'
  name          text not null,
  region        text not null,                 -- Central | Eastern | Northern | Western
  lat           numeric(8,5) not null,
  lng           numeric(8,5) not null
);

-- ─────────────────────────────────────────── catalogue taxonomy

create table categories (
  id        text primary key,                  -- 'building-construction'
  name      text not null,
  parent_id text references categories,
  sort      integer default 0
);

-- ─────────────────────────────────────────── accounts

create table accounts (
  id                  uuid primary key default uuid_generate_v4(),
  auth_user_id        uuid unique references auth.users on delete set null,
  role                account_role not null,
  business_type       business_type,           -- null for buyers and admins
  tier                membership_tier not null default 'free',
  company             text not null,
  trade_name          text,
  initials            text,
  phone               text not null unique,    -- E.164, +2567XXXXXXXX
  alt_phone           text,
  whatsapp_phone      text,
  email               text,
  address             text,
  district_id         text references districts,
  incorporated_on     date,
  spend_12m           bigint default 0,
  supplier_count      integer default 0,
  about               text,
  coverage            text,
  nature_of_business  text,
  staff_count         text,
  turnover            text,
  brands              text,
  created_at          timestamptz not null default now(),
  updated_at          timestamptz not null default now()
);
create index on accounts (role);
create index on accounts (district_id);

-- registration records are separated so admin can verify each field independently
create table account_registration (
  account_id          uuid primary key references accounts on delete cascade,
  ursb_number         text,
  ursb_state          verification_state not null default 'unverified',
  tin                 text,
  tin_state           verification_state not null default 'unverified',
  trading_licence     text,
  licence_authority   text,                    -- 'KCCA', 'Mukono MC', district
  licence_expires_on  date,
  licence_state       verification_state not null default 'unverified',
  vat_number          text,
  vat_state           verification_state not null default 'unverified',
  director_nin        text,
  nin_state           verification_state not null default 'unverified',
  overall_state       verification_state not null default 'unverified',
  verified_at         timestamptz,
  verified_by         uuid references accounts
);

create table account_categories (
  account_id   uuid references accounts on delete cascade,
  category_id  text references categories,
  primary key (account_id, category_id)
);

create table account_users (            -- staff logins under one business
  id           uuid primary key default uuid_generate_v4(),
  account_id   uuid not null references accounts on delete cascade,
  auth_user_id uuid references auth.users on delete cascade,
  full_name    text not null,
  role_title   text,
  phone        text,
  can_post     boolean default true,
  can_accept   boolean default false,
  can_release  boolean default false,
  can_billing  boolean default false,
  created_at   timestamptz not null default now()
);

create table addresses (
  id          uuid primary key default uuid_generate_v4(),
  account_id  uuid not null references accounts on delete cascade,
  label       text not null,
  street      text not null,
  district_id text references districts,
  contact     text,
  phone       text,
  is_default  boolean default false
);

create table payout_methods (
  id          uuid primary key default uuid_generate_v4(),
  account_id  uuid not null references accounts on delete cascade,
  method      payment_method not null,
  detail      text not null,                  -- phone or masked account
  state       verification_state not null default 'unverified',
  is_default  boolean default false
);

create table handsets (                        -- the BUBU virtual-number ring list
  id           uuid primary key default uuid_generate_v4(),
  account_id   uuid not null references accounts on delete cascade,
  phone        text not null,
  owner_label  text,
  office_hours boolean default true,
  after_hours  boolean default false,
  verified_at  timestamptz,
  constraint handsets_max_five check (true)    -- enforced in application/trigger
);

-- ─────────────────────────────────────────── catalogue

create table products (
  id           uuid primary key default uuid_generate_v4(),
  supplier_id  uuid not null references accounts on delete cascade,
  name         text not null,
  category_id  text references categories,
  family       text,                           -- 'Aggregates', 'Grain and pulses'
  description  text,
  price        bigint not null,                -- UGX per unit
  unit         text not null,                  -- bag, tonne, kg, unit, set
  moq          integer not null default 1,
  brand        text,
  status       listing_status not null default 'draft',
  rating       numeric(2,1),
  order_count  integer default 0,
  view_count   integer default 0,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);
create index on products (supplier_id);
create index on products (category_id);
create index on products using gin (to_tsvector('english', name || ' ' || coalesce(description,'')));

create table product_specs (
  id          uuid primary key default uuid_generate_v4(),
  product_id  uuid not null references products on delete cascade,
  key         text not null,
  value       text not null,
  sort        integer default 0
);

create table media (
  id          uuid primary key default uuid_generate_v4(),
  account_id  uuid not null references accounts on delete cascade,
  product_id  uuid references products on delete cascade,
  kind        text not null default 'product', -- product | company | certificate | premises
  storage_path text not null,                  -- Supabase Storage object path
  caption     text,
  approved    boolean default false,
  created_at  timestamptz not null default now()
);

create table documents (
  id           uuid primary key default uuid_generate_v4(),
  account_id   uuid not null references accounts on delete cascade,
  kind         document_kind not null,
  issuer       text,
  reference    text,
  issued_on    date,
  expires_on   date,
  storage_path text,
  state        verification_state not null default 'pending',
  created_at   timestamptz not null default now()
);

-- ─────────────────────────────────────────── demand side

create table requirements (                    -- buyer RFQ; suppliers see these as buy leads
  id           uuid primary key default uuid_generate_v4(),
  buyer_id     uuid not null references accounts on delete cascade,
  title        text not null,
  category_id  text references categories,
  quantity     numeric(14,2) not null,
  quantity_unit text not null,
  specification text,
  purpose      text,                            -- Business use | Resale | Tender
  deliver_to   text,
  district_id  text references districts,
  needed_by    date,
  estimated_value bigint,
  payment_method payment_method,
  state        requirement_state not null default 'open',
  created_at   timestamptz not null default now(),
  expires_at   timestamptz
);
create index on requirements (state, district_id, category_id);
create index on requirements (created_at desc);

create table quotes (
  id             uuid primary key default uuid_generate_v4(),
  requirement_id uuid not null references requirements on delete cascade,
  supplier_id    uuid not null references accounts on delete cascade,
  unit_price     bigint not null,
  quantity       text,
  lead_time      text,
  delivery_terms text,                          -- Delivered | Buyer collects | Ex works
  validity_days  integer default 10,
  message        text,
  state          quote_state not null default 'draft',
  created_at     timestamptz not null default now(),
  unique (requirement_id, supplier_id)
);

create table quote_attachments (
  id           uuid primary key default uuid_generate_v4(),
  quote_id     uuid not null references quotes on delete cascade,
  storage_path text not null,
  label        text
);

-- lead credits: revealing a buyer's number costs one
create table lead_credits (
  id          uuid primary key default uuid_generate_v4(),
  account_id  uuid not null references accounts on delete cascade,
  granted     integer not null,
  used        integer not null default 0,
  expires_on  date
);

create table contact_reveals (
  id             uuid primary key default uuid_generate_v4(),
  account_id     uuid not null references accounts on delete cascade,
  requirement_id uuid references requirements on delete cascade,
  product_id     uuid references products on delete cascade,
  revealed_at    timestamptz not null default now(),
  unique (account_id, requirement_id, product_id)
);

create table lead_preferences (
  account_id   uuid primary key references accounts on delete cascade,
  districts    text[] not null default '{}',
  radius_km    integer not null default 60,
  nationwide   boolean not null default false,
  min_value    bigint,
  verified_only boolean not null default false
);

-- ─────────────────────────────────────────── orders, escrow, money

create table orders (
  id             uuid primary key default uuid_generate_v4(),
  reference      text not null unique,          -- BM-2026-0418
  buyer_id       uuid not null references accounts,
  supplier_id    uuid not null references accounts,
  requirement_id uuid references requirements,
  quote_id       uuid references quotes,
  subtotal       bigint not null,
  vat_rate       numeric(4,3) not null default 0.180,
  vat            bigint not null default 0,
  delivery_fee   bigint not null default 0,
  total          bigint not null,
  deliver_to     text,
  district_id    text references districts,
  state          order_state not null default 'pending_payment',
  escrow_state   escrow_state not null default 'none',
  funded_at      timestamptz,
  dispatched_at  timestamptz,
  delivered_at   timestamptz,
  released_at    timestamptz,
  auto_release_at timestamptz,                  -- delivered_at + 7 days
  created_at     timestamptz not null default now()
);
create index on orders (buyer_id);
create index on orders (supplier_id);
create index on orders (state);

create table order_lines (
  id          uuid primary key default uuid_generate_v4(),
  order_id    uuid not null references orders on delete cascade,
  product_id  uuid references products,
  name        text not null,
  quantity    numeric(14,2) not null,
  unit        text not null,
  unit_price  bigint not null,
  line_total  bigint not null
);

create table payments (
  id          uuid primary key default uuid_generate_v4(),
  order_id    uuid not null references orders on delete cascade,
  method      payment_method not null,
  payer_phone text,
  amount      bigint not null,
  provider_ref text,
  state       payment_state not null default 'prompt_sent',
  raw_callback jsonb,
  created_at  timestamptz not null default now(),
  settled_at  timestamptz
);

create table invoices (
  id            uuid primary key default uuid_generate_v4(),
  account_id    uuid not null references accounts on delete cascade,
  order_id      uuid references orders on delete cascade,
  number        text not null unique,           -- BUBU-INV-2026-0431
  kind          text not null default 'tax',    -- tax | proforma | service
  subtotal      bigint not null,
  vat           bigint not null,
  total         bigint not null,
  issued_on     date not null default current_date,
  efris_fdn     text,                           -- EFRIS fiscal document number
  storage_path  text
);

create table subscriptions (                    -- supplier programme membership
  id          uuid primary key default uuid_generate_v4(),
  account_id  uuid not null references accounts on delete cascade,
  tier        membership_tier not null,
  price       bigint not null,
  lead_credits integer not null default 0,
  starts_on   date not null,
  ends_on     date not null,
  invoice_id  uuid references invoices
);

create table fee_rules (
  id          uuid primary key default uuid_generate_v4(),
  name        text not null,
  applies_to  text not null,                    -- all_orders | export | tier
  rate        numeric(5,4),
  flat_amount bigint,
  minimum     bigint,
  payer       account_role not null,
  note        text,
  active      boolean default true
);

-- ─────────────────────────────────────────── disputes

create table disputes (
  id            uuid primary key default uuid_generate_v4(),
  order_id      uuid not null references orders on delete cascade,
  raised_by     uuid not null references accounts,
  claim         text not null,
  amount_held   bigint not null,
  state         dispute_state not null default 'open',
  outcome       dispute_outcome,
  decided_by    uuid references accounts,
  decided_at    timestamptz,
  resolution_note text,
  created_at    timestamptz not null default now()
);

create table dispute_evidence (
  id           uuid primary key default uuid_generate_v4(),
  dispute_id   uuid not null references disputes on delete cascade,
  storage_path text not null,
  caption      text
);

-- ─────────────────────────────────────────── conversations

create table conversations (
  id             uuid primary key default uuid_generate_v4(),
  supplier_id    uuid not null references accounts on delete cascade,
  buyer_id       uuid not null references accounts on delete cascade,
  requirement_id uuid references requirements on delete set null,
  labels         text[] default '{}',
  last_message_at timestamptz,
  created_at     timestamptz not null default now(),
  unique (supplier_id, buyer_id, requirement_id)
);

create table messages (
  id              uuid primary key default uuid_generate_v4(),
  conversation_id uuid not null references conversations on delete cascade,
  sender_id       uuid references accounts,
  direction       message_direction not null,
  channel         message_channel not null default 'app',
  body            text,
  call_seconds    integer,
  call_missed     boolean,
  recording_path  text,                          -- retained 90 days (DPPA 2019)
  sent_at         timestamptz not null default now(),
  read_at         timestamptz
);
create index on messages (conversation_id, sent_at);

-- ─────────────────────────────────────────── verification queue

create table applications (
  id           uuid primary key default uuid_generate_v4(),
  account_id   uuid not null references accounts on delete cascade,
  submitted_at timestamptz not null default now(),
  state        verification_state not null default 'pending',
  registry_ursb text,                            -- match | no_match | pending
  registry_ura  text,
  licence_check text,
  sanctions     text,
  decided_by   uuid references accounts,
  decided_at   timestamptz,
  reason       text
);
create index on applications (state, submitted_at);

-- ─────────────────────────────────────────── notifications

create table notification_prefs (
  account_id uuid not null references accounts on delete cascade,
  topic      text not null,                      -- enquiries | replies | followups | missed_calls | lead_alerts | tenders | payouts | offers
  email      boolean default false,
  sms        boolean default false,
  app        boolean default true,
  whatsapp   boolean default false,
  primary key (account_id, topic)
);

create table audit_log (
  id         bigserial primary key,
  actor_id   uuid references accounts,
  action     text not null,
  entity     text not null,
  entity_id  uuid,
  before     jsonb,
  after      jsonb,
  created_at timestamptz not null default now()
);

-- ============================================================
-- deploy/supabase/migrations/0002_rls.sql
-- ============================================================

-- BUBU.Market · row level security
-- Every table is closed by default; a supplier must never read another supplier's
-- leads, orders, conversations or documents.

create or replace function current_account_id() returns uuid
language sql stable security definer as $$
  select id from accounts where auth_user_id = auth.uid()
  union all
  select account_id from account_users where auth_user_id = auth.uid()
  limit 1;
$$;

create or replace function current_role_name() returns account_role
language sql stable security definer as $$
  select role from accounts where id = current_account_id();
$$;

create or replace function is_admin() returns boolean
language sql stable security definer as $$
  select coalesce(current_role_name() = 'admin', false);
$$;

do $$ declare t text;
begin
  for t in select unnest(array['accounts','account_registration','account_categories','account_users','addresses',
    'payout_methods','handsets','products','product_specs','media','documents','requirements','quotes',
    'quote_attachments','lead_credits','contact_reveals','lead_preferences','orders','order_lines','payments',
    'invoices','subscriptions','disputes','dispute_evidence','conversations','messages','applications',
    'notification_prefs','audit_log'])
  loop
    execute format('alter table %I enable row level security', t);
  end loop;
end $$;

-- reference data is world readable
alter table districts enable row level security;
alter table categories enable row level security;
alter table fee_rules enable row level security;
create policy districts_read  on districts  for select using (true);
create policy categories_read on categories for select using (true);
create policy fee_rules_read  on fee_rules  for select using (active);

-- accounts: own record, plus public columns of verified suppliers
create policy accounts_self on accounts for select
  using (id = current_account_id() or is_admin()
         or (role = 'supplier' and exists (
              select 1 from account_registration r
              where r.account_id = accounts.id and r.overall_state = 'verified')));
create policy accounts_update_self on accounts for update
  using (id = current_account_id()) with check (id = current_account_id());
create policy accounts_admin_all on accounts for all using (is_admin());

create policy registration_self on account_registration for select
  using (account_id = current_account_id() or is_admin());
create policy registration_write_self on account_registration for update
  using (account_id = current_account_id()) with check (account_id = current_account_id());
create policy registration_admin on account_registration for all using (is_admin());

-- owned-row tables: one policy shape, applied per table
do $$ declare t text;
begin
  for t in select unnest(array['account_categories','account_users','addresses','payout_methods','handsets',
    'lead_credits','contact_reveals','lead_preferences','documents','notification_prefs'])
  loop
    execute format($f$
      create policy %1$s_own on %1$I for all
        using (account_id = current_account_id() or is_admin())
        with check (account_id = current_account_id() or is_admin());
    $f$, t);
  end loop;
end $$;

-- products: published listings are public, drafts are the supplier's own
create policy products_public on products for select
  using (status = 'published' or supplier_id = current_account_id() or is_admin());
create policy products_own_write on products for all
  using (supplier_id = current_account_id() or is_admin())
  with check (supplier_id = current_account_id() or is_admin());

create policy specs_read on product_specs for select
  using (exists (select 1 from products p where p.id = product_id
                 and (p.status = 'published' or p.supplier_id = current_account_id() or is_admin())));
create policy specs_write on product_specs for all
  using (exists (select 1 from products p where p.id = product_id and p.supplier_id = current_account_id()) or is_admin())
  with check (exists (select 1 from products p where p.id = product_id and p.supplier_id = current_account_id()) or is_admin());

create policy media_read on media for select
  using (approved or account_id = current_account_id() or is_admin());
create policy media_write on media for all
  using (account_id = current_account_id() or is_admin())
  with check (account_id = current_account_id() or is_admin());

-- requirements: the buyer owns them; suppliers read open ones matching their categories
create policy requirements_buyer on requirements for all
  using (buyer_id = current_account_id() or is_admin())
  with check (buyer_id = current_account_id() or is_admin());
create policy requirements_supplier_read on requirements for select
  using (state = 'open' and current_role_name() = 'supplier'
         and (category_id is null or exists (
              select 1 from account_categories ac
              where ac.account_id = current_account_id() and ac.category_id = requirements.category_id)));

-- quotes: visible to the quoting supplier and the requirement's buyer
create policy quotes_parties on quotes for select
  using (supplier_id = current_account_id() or is_admin()
         or exists (select 1 from requirements r where r.id = requirement_id and r.buyer_id = current_account_id()));
create policy quotes_supplier_write on quotes for all
  using (supplier_id = current_account_id() or is_admin())
  with check (supplier_id = current_account_id() or is_admin());
create policy quote_files on quote_attachments for all
  using (exists (select 1 from quotes q where q.id = quote_id and q.supplier_id = current_account_id()) or is_admin())
  with check (exists (select 1 from quotes q where q.id = quote_id and q.supplier_id = current_account_id()) or is_admin());

-- orders and money: both parties, admin
create policy orders_parties on orders for select
  using (buyer_id = current_account_id() or supplier_id = current_account_id() or is_admin());
create policy orders_buyer_insert on orders for insert
  with check (buyer_id = current_account_id());
create policy orders_parties_update on orders for update
  using (buyer_id = current_account_id() or supplier_id = current_account_id() or is_admin());

create policy lines_parties on order_lines for select
  using (exists (select 1 from orders o where o.id = order_id
                 and (o.buyer_id = current_account_id() or o.supplier_id = current_account_id() or is_admin())));
create policy payments_parties on payments for select
  using (exists (select 1 from orders o where o.id = order_id
                 and (o.buyer_id = current_account_id() or o.supplier_id = current_account_id() or is_admin())));
create policy invoices_own on invoices for select
  using (account_id = current_account_id() or is_admin());
create policy subscriptions_own on subscriptions for select
  using (account_id = current_account_id() or is_admin());

-- disputes: parties may read and raise; only admin may resolve
create policy disputes_parties on disputes for select
  using (is_admin() or exists (select 1 from orders o where o.id = order_id
         and (o.buyer_id = current_account_id() or o.supplier_id = current_account_id())));
create policy disputes_raise on disputes for insert
  with check (raised_by = current_account_id());
create policy disputes_admin_resolve on disputes for update using (is_admin());
create policy evidence_parties on dispute_evidence for all
  using (is_admin() or exists (select 1 from disputes d join orders o on o.id = d.order_id
         where d.id = dispute_id and (o.buyer_id = current_account_id() or o.supplier_id = current_account_id())))
  with check (true);

-- conversations and messages: the two parties only
create policy conversations_parties on conversations for all
  using (supplier_id = current_account_id() or buyer_id = current_account_id() or is_admin())
  with check (supplier_id = current_account_id() or buyer_id = current_account_id());
create policy messages_parties on messages for all
  using (exists (select 1 from conversations c where c.id = conversation_id
                 and (c.supplier_id = current_account_id() or c.buyer_id = current_account_id() or is_admin())))
  with check (exists (select 1 from conversations c where c.id = conversation_id
                 and (c.supplier_id = current_account_id() or c.buyer_id = current_account_id())));

-- applications: own, or any for admin
create policy applications_own on applications for select
  using (account_id = current_account_id() or is_admin());
create policy applications_submit on applications for insert
  with check (account_id = current_account_id());
create policy applications_admin on applications for update using (is_admin());

create policy audit_admin on audit_log for select using (is_admin());

-- ============================================================
-- deploy/supabase/migrations/0003_functions.sql
-- ============================================================

-- BUBU.Market · functions, triggers and views

-- keep updated_at honest
create or replace function touch_updated_at() returns trigger language plpgsql as $$
begin new.updated_at = now(); return new; end $$;
create trigger accounts_touch before update on accounts for each row execute function touch_updated_at();
create trigger products_touch before update on products for each row execute function touch_updated_at();

-- order reference: BM-YYYY-NNNN
create sequence if not exists order_ref_seq;
create or replace function next_order_reference() returns text language sql as $$
  select 'BM-' || to_char(now(),'YYYY') || '-' || lpad(nextval('order_ref_seq')::text, 4, '0');
$$;

-- VAT and total are computed, never trusted from the client
create or replace function compute_order_totals() returns trigger language plpgsql as $$
begin
  new.subtotal := coalesce((select sum(line_total) from order_lines where order_id = new.id), new.subtotal);
  new.vat      := round(new.subtotal * new.vat_rate);
  new.total    := new.subtotal + new.vat + coalesce(new.delivery_fee, 0);
  return new;
end $$;
create trigger orders_totals before insert or update on orders
  for each row execute function compute_order_totals();

-- escrow transitions, the only sanctioned path
create or replace function fund_order(p_order uuid, p_method payment_method, p_phone text)
returns payments language plpgsql security definer as $$
declare p payments;
begin
  insert into payments (order_id, method, payer_phone, amount, state)
  select p_order, p_method, p_phone, total, 'prompt_sent' from orders where id = p_order
  returning * into p;
  update orders set state = 'funded', escrow_state = 'held', funded_at = now() where id = p_order;
  return p;
end $$;

create or replace function confirm_delivery(p_order uuid)
returns orders language plpgsql security definer as $$
declare o orders;
begin
  update orders set state = 'delivered', delivered_at = now(),
    auto_release_at = now() + interval '7 days'
  where id = p_order returning * into o;
  return o;
end $$;

create or replace function release_escrow(p_order uuid)
returns orders language plpgsql security definer as $$
declare o orders;
begin
  update orders set escrow_state = 'released', released_at = now(), state = 'closed'
  where id = p_order and not exists (
    select 1 from disputes d where d.order_id = p_order and d.state <> 'resolved')
  returning * into o;
  return o;
end $$;

create or replace function resolve_dispute(p_dispute uuid, p_outcome dispute_outcome, p_note text)
returns disputes language plpgsql security definer as $$
declare d disputes;
begin
  if not is_admin() then raise exception 'admin only'; end if;
  update disputes set state = 'resolved', outcome = p_outcome, resolution_note = p_note,
    decided_by = current_account_id(), decided_at = now()
  where id = p_dispute returning * into d;
  update orders set escrow_state = case when p_outcome = 'refund_buyer' then 'refunded' else 'released' end,
    state = case when p_outcome = 'refund_buyer' then 'refunded' else 'closed' end,
    released_at = now()
  where id = d.order_id;
  return d;
end $$;

-- verification decisions
create or replace function approve_application(p_app uuid)
returns applications language plpgsql security definer as $$
declare a applications;
begin
  if not is_admin() then raise exception 'admin only'; end if;
  update applications set state = 'verified', decided_by = current_account_id(), decided_at = now()
  where id = p_app returning * into a;
  update account_registration set overall_state = 'verified', verified_at = now(),
    verified_by = current_account_id() where account_id = a.account_id;
  return a;
end $$;

create or replace function reject_application(p_app uuid, p_reason text)
returns applications language plpgsql security definer as $$
declare a applications;
begin
  if not is_admin() then raise exception 'admin only'; end if;
  update applications set state = 'rejected', reason = p_reason,
    decided_by = current_account_id(), decided_at = now()
  where id = p_app returning * into a;
  update account_registration set overall_state = 'rejected' where account_id = a.account_id;
  return a;
end $$;

-- revealing a contact spends one lead credit, atomically
create or replace function reveal_contact(p_requirement uuid, p_product uuid)
returns text language plpgsql security definer as $$
declare acct uuid := current_account_id(); remaining int; target text;
begin
  select sum(granted - used) into remaining from lead_credits
   where account_id = acct and (expires_on is null or expires_on >= current_date);
  if coalesce(remaining, 0) < 1 then raise exception 'no lead credits remaining'; end if;

  insert into contact_reveals (account_id, requirement_id, product_id)
  values (acct, p_requirement, p_product) on conflict do nothing;

  update lead_credits set used = used + 1
   where id = (select id from lead_credits where account_id = acct
               and granted > used and (expires_on is null or expires_on >= current_date)
               order by expires_on nulls last limit 1);

  if p_requirement is not null then
    select a.phone into target from requirements r join accounts a on a.id = r.buyer_id where r.id = p_requirement;
  else
    select a.phone into target from products p join accounts a on a.id = p.supplier_id where p.id = p_product;
  end if;
  return target;
end $$;

-- distance in km between two districts, for buy-lead radius filtering
create or replace function district_km(a text, b text) returns numeric
language sql stable as $$
  select 6371 * 2 * asin(sqrt(
    power(sin(radians(d2.lat - d1.lat) / 2), 2) +
    cos(radians(d1.lat)) * cos(radians(d2.lat)) *
    power(sin(radians(d2.lng - d1.lng) / 2), 2)))
  from districts d1, districts d2 where d1.id = a and d2.id = b;
$$;

-- buy leads for the calling supplier, honouring its own preferences
create or replace function my_buy_leads()
returns setof requirements language sql stable security definer as $$
  with pref as (select * from lead_preferences where account_id = current_account_id()),
       mine as (select category_id from account_categories where account_id = current_account_id())
  select r.* from requirements r, pref
  where r.state = 'open'
    and r.buyer_id <> current_account_id()
    and (r.category_id is null or r.category_id in (select category_id from mine))
    and (pref.min_value is null or coalesce(r.estimated_value, 0) >= pref.min_value)
    and (pref.nationwide
         or r.district_id = any (pref.districts)
         or exists (select 1 from unnest(pref.districts) d
                    where district_km(d, r.district_id) <= pref.radius_km))
  order by r.created_at desc;
$$;

-- public storefront view: safe columns only, verified suppliers only
create or replace view public_suppliers as
select a.id, a.company, a.trade_name, a.initials, a.business_type, a.tier, a.district_id,
       a.about, a.coverage, a.nature_of_business, a.brands, a.incorporated_on,
       r.overall_state as verification_state
from accounts a join account_registration r on r.account_id = a.id
where a.role = 'supplier' and r.overall_state = 'verified';

-- offers per product: what the marketplace product page lists
create or replace view product_offers as
select p.id as product_id, p.name, a.id as supplier_id, a.company as supplier,
       a.district_id, p.price, p.moq, p.unit, p.rating,
       (r.overall_state = 'verified') as verified,
       extract(year from age(now(), a.created_at))::int as years_on_platform
from products p
join accounts a on a.id = p.supplier_id
join account_registration r on r.account_id = a.id
where p.status = 'published';

-- catalogue analytics the supplier dashboard reads
create or replace view supplier_catalog_stats as
select p.supplier_id, count(*) as listings, sum(p.view_count) as views,
       sum(p.order_count) as orders,
       count(*) filter (where p.status = 'published') as active,
       count(*) filter (where p.status <> 'published') as inactive
from products p group by p.supplier_id;

-- ============================================================
-- deploy/supabase/migrations/0004_supplier_application.sql
-- ============================================================

-- Submit a supplier application in one database transaction.
-- The caller must already have an authenticated Supabase session (after email OTP).

create or replace function submit_supplier_application(
  p_company text,
  p_trade_name text,
  p_phone text,
  p_email text,
  p_business_type business_type,
  p_ursb_number text,
  p_tin text,
  p_trading_licence text,
  p_vat_number text default null,
  p_address text default null,
  p_district_id text default null
) returns applications
language plpgsql security definer set search_path = public as $$
declare
  v_account accounts;
  v_application applications;
  v_district_id text;
begin
  if auth.uid() is null then
    raise exception 'sign in before submitting an application';
  end if;
  if coalesce(trim(p_company), '') = '' or coalesce(trim(p_phone), '') = '' then
    raise exception 'company name and phone number are required';
  end if;

  select id into v_district_id
  from districts
  where id = lower(replace(trim(coalesce(p_district_id, '')), ' ', '-'))
     or lower(name) = lower(trim(coalesce(p_district_id, '')))
  limit 1;

  if coalesce(trim(p_district_id), '') <> '' and v_district_id is null then
    raise exception 'Choose a valid Uganda district';
  end if;

  insert into accounts (
    auth_user_id, role, business_type, company, trade_name, initials,
    phone, email, address, district_id
  ) values (
    auth.uid(), 'supplier', p_business_type, trim(p_company), nullif(trim(p_trade_name), ''),
    upper(left(trim(p_company), 1)), trim(p_phone), nullif(trim(p_email), ''),
    nullif(trim(p_address), ''), v_district_id
  )
  on conflict (auth_user_id) do update set
    business_type = excluded.business_type, company = excluded.company,
    trade_name = excluded.trade_name, phone = excluded.phone, email = excluded.email,
    address = excluded.address, district_id = excluded.district_id, updated_at = now()
  returning * into v_account;

  insert into account_registration (
    account_id, ursb_number, tin, trading_licence, vat_number,
    ursb_state, tin_state, licence_state, vat_state, overall_state
  ) values (
    v_account.id, nullif(trim(p_ursb_number), ''), nullif(trim(p_tin), ''),
    nullif(trim(p_trading_licence), ''), nullif(trim(p_vat_number), ''),
    'pending', 'pending', 'pending',
    (case when nullif(trim(p_vat_number), '') is null then 'unverified' else 'pending' end)::verification_state,
    'pending'
  )
  on conflict (account_id) do update set
    ursb_number = excluded.ursb_number, tin = excluded.tin,
    trading_licence = excluded.trading_licence, vat_number = excluded.vat_number,
    ursb_state = 'pending', tin_state = 'pending', licence_state = 'pending',
    vat_state = excluded.vat_state, overall_state = 'pending',
    verified_at = null, verified_by = null;

  delete from applications where account_id = v_account.id and state = 'pending';
  insert into applications (account_id, state, registry_ursb, registry_ura, licence_check, sanctions)
  values (v_account.id, 'pending', 'pending', 'pending', 'pending', 'pending')
  returning * into v_application;

  return v_application;
end $$;

grant execute on function submit_supplier_application(text, text, text, text, business_type, text, text, text, text, text, text) to authenticated;

-- ============================================================
-- deploy/supabase/migrations/0005_live_commercial.sql
-- ============================================================

-- BUBU.Market live commercial workflow.
-- Marketplace discovery, RFQs, quotes, verification and chat are database-backed.
-- BUBU collects money only for subscription plans; marketplace order payments and escrow are legacy.

create table if not exists plans (
  code text primary key, name text not null, description text,
  price bigint not null check (price >= 0), billing_days integer not null default 30 check (billing_days > 0),
  tier membership_tier not null, lead_credits integer not null default 0,
  features jsonb not null default '[]'::jsonb, active boolean not null default true,
  created_at timestamptz not null default now()
);
create table if not exists plan_purchases (
  id uuid primary key default uuid_generate_v4(), account_id uuid not null references accounts on delete cascade,
  plan_code text not null references plans(code), amount bigint not null, method payment_method not null,
  payer_phone text, provider_ref text, state payment_state not null default 'prompt_sent',
  starts_on date, ends_on date, raw_callback jsonb, created_at timestamptz not null default now(), settled_at timestamptz
);
create index if not exists plan_purchases_account_created on plan_purchases(account_id, created_at desc);
alter table plans enable row level security;
alter table plan_purchases enable row level security;
drop policy if exists plans_read on plans;
create policy plans_read on plans for select using (active or is_admin());
drop policy if exists plan_purchases_own on plan_purchases;
create policy plan_purchases_own on plan_purchases for select using (account_id=current_account_id() or is_admin());

insert into plans(code,name,description,price,billing_days,tier,lead_credits,features) values
('free','Free','Create a profile and publish a starter catalogue',0,3650,'free',0,
 '["Company profile","Up to 5 products","Receive enquiries"]'),
('star-monthly','Star Supplier','More catalogue reach and verified lead tools',99000,30,'star_supplier',25,
 '["Unlimited products","25 contact reveals","Priority search placement","Catalogue analytics"]'),
('leader-monthly','Industry Leader','Full commercial visibility and team tools',249000,30,'industry_leader',100,
 '["Everything in Star","100 contact reveals","Team access","Priority verification","Advanced analytics"]')
on conflict(code) do update set name=excluded.name,description=excluded.description,price=excluded.price,
billing_days=excluded.billing_days,tier=excluded.tier,lead_credits=excluded.lead_credits,features=excluded.features,active=true;

create or replace function create_buyer_profile(
  p_company text,p_phone text,p_email text,p_district_id text,p_buyer_type text default null,
  p_full_name text default null,p_category_ids text[] default '{}'
) returns accounts language plpgsql security definer set search_path=public as $$
declare v_account accounts; v_category text;
begin
  if auth.uid() is null then raise exception 'sign in before creating a profile'; end if;
  if coalesce(trim(p_company),'')='' or coalesce(trim(p_phone),'')='' then raise exception 'name and phone are required'; end if;
  insert into accounts(auth_user_id,role,company,trade_name,initials,phone,email,district_id,nature_of_business)
  values(auth.uid(),'buyer',trim(p_company),trim(p_company),upper(left(trim(p_company),2)),trim(p_phone),
    nullif(trim(p_email),''),nullif(trim(p_district_id),''),nullif(trim(p_buyer_type),''))
  on conflict(auth_user_id) do update set company=excluded.company,trade_name=excluded.trade_name,
    phone=excluded.phone,email=excluded.email,district_id=excluded.district_id,
    nature_of_business=excluded.nature_of_business,updated_at=now() returning * into v_account;
  insert into account_users(account_id,auth_user_id,full_name,role_title)
  values(v_account.id,auth.uid(),coalesce(nullif(trim(p_full_name),''),trim(p_company)),coalesce(p_buyer_type,'Buyer'))
  on conflict do nothing;
  delete from account_categories where account_id=v_account.id;
  foreach v_category in array coalesce(p_category_ids,'{}') loop
    insert into account_categories(account_id,category_id) values(v_account.id,v_category) on conflict do nothing;
  end loop;
  return v_account;
end $$;
grant execute on function create_buyer_profile(text,text,text,text,text,text,text[]) to authenticated;

create or replace function start_plan_purchase(p_plan_code text,p_method payment_method,p_phone text)
returns plan_purchases language plpgsql security definer set search_path=public as $$
declare v_plan plans; v_purchase plan_purchases; v_account uuid:=current_account_id();
begin
  if v_account is null then raise exception 'sign in before purchasing a plan'; end if;
  select * into v_plan from plans where code=p_plan_code and active;
  if not found then raise exception 'plan is not available'; end if;
  if v_plan.price=0 then raise exception 'the free plan does not require payment'; end if;
  insert into plan_purchases(account_id,plan_code,amount,method,payer_phone)
  values(v_account,v_plan.code,v_plan.price,p_method,nullif(trim(p_phone),'')) returning * into v_purchase;
  return v_purchase;
end $$;
grant execute on function start_plan_purchase(text,payment_method,text) to authenticated;

create or replace function activate_plan_purchase(p_purchase uuid,p_provider_ref text)
returns subscriptions language plpgsql security definer set search_path=public as $$
declare v_purchase plan_purchases; v_plan plans; v_sub subscriptions;
begin
  if not is_admin() and auth.role()<>'service_role' then raise exception 'trusted payment service only'; end if;
  update plan_purchases set state='success',provider_ref=p_provider_ref,settled_at=now(),starts_on=current_date
  where id=p_purchase and state='prompt_sent' returning * into v_purchase;
  if not found then raise exception 'purchase is not pending'; end if;
  select * into v_plan from plans where code=v_purchase.plan_code;
  update plan_purchases set ends_on=current_date+v_plan.billing_days where id=p_purchase;
  insert into subscriptions(account_id,tier,price,lead_credits,starts_on,ends_on)
  values(v_purchase.account_id,v_plan.tier,v_plan.price,v_plan.lead_credits,current_date,current_date+v_plan.billing_days)
  returning * into v_sub;
  update accounts set tier=v_plan.tier where id=v_purchase.account_id;
  if v_plan.lead_credits>0 then insert into lead_credits(account_id,granted,expires_on)
    values(v_purchase.account_id,v_plan.lead_credits,current_date+v_plan.billing_days); end if;
  return v_sub;
end $$;

create or replace function message_after_insert() returns trigger language plpgsql security definer as $$
begin update conversations set last_message_at=new.sent_at where id=new.conversation_id; return new; end $$;
drop trigger if exists messages_touch_conversation on messages;
create trigger messages_touch_conversation after insert on messages for each row execute function message_after_insert();

create unique index if not exists conversations_one_general_thread
on conversations(supplier_id,buyer_id) where requirement_id is null;

-- Storage: public catalogue/company images; documents remain visible only to their owner and admins.
drop policy if exists media_public_images on storage.objects;
create policy media_public_images on storage.objects for select using (
  bucket_id='media' and (storage.foldername(name))[1] in ('products','company')
);
drop policy if exists media_owner_read on storage.objects;
create policy media_owner_read on storage.objects for select using (
  bucket_id='media' and ((storage.foldername(name))[2]=current_account_id()::text or is_admin())
);
drop policy if exists media_owner_insert on storage.objects;
create policy media_owner_insert on storage.objects for insert to authenticated with check (
  bucket_id='media' and (storage.foldername(name))[1] in ('products','company','documents')
  and (storage.foldername(name))[2]=current_account_id()::text
);
drop policy if exists media_owner_update on storage.objects;
create policy media_owner_update on storage.objects for update to authenticated using (
  bucket_id='media' and ((storage.foldername(name))[2]=current_account_id()::text or is_admin())
) with check (bucket_id='media');
drop policy if exists media_owner_delete on storage.objects;
create policy media_owner_delete on storage.objects for delete to authenticated using (
  bucket_id='media' and ((storage.foldername(name))[2]=current_account_id()::text or is_admin())
);

-- Disable old marketplace money functions for browser sessions while preserving historical rows.
revoke execute on function fund_order(uuid,payment_method,text) from anon,authenticated;
revoke execute on function release_escrow(uuid) from anon,authenticated;

-- ============================================================
-- deploy/supabase/migrations/0006_fix_supplier_registration.sql
-- ============================================================

-- Fix supplier registration when VAT is optional.
-- PostgreSQL otherwise infers the CASE result as text instead of verification_state.

create or replace function submit_supplier_application(
  p_company text,
  p_trade_name text,
  p_phone text,
  p_email text,
  p_business_type business_type,
  p_ursb_number text,
  p_tin text,
  p_trading_licence text,
  p_vat_number text default null,
  p_address text default null,
  p_district_id text default null
) returns applications
language plpgsql security definer set search_path = public as $$
declare
  v_account accounts;
  v_application applications;
  v_district_id text;
begin
  if auth.uid() is null then
    raise exception 'sign in before submitting an application';
  end if;
  if coalesce(trim(p_company), '') = '' or coalesce(trim(p_phone), '') = '' then
    raise exception 'company name and phone number are required';
  end if;

  select id into v_district_id
  from districts
  where id = lower(replace(trim(coalesce(p_district_id, '')), ' ', '-'))
     or lower(name) = lower(trim(coalesce(p_district_id, '')))
  limit 1;

  if coalesce(trim(p_district_id), '') <> '' and v_district_id is null then
    raise exception 'Choose a valid Uganda district';
  end if;

  insert into accounts (
    auth_user_id, role, business_type, company, trade_name, initials,
    phone, email, address, district_id
  ) values (
    auth.uid(), 'supplier', p_business_type, trim(p_company), nullif(trim(p_trade_name), ''),
    upper(left(trim(p_company), 1)), trim(p_phone), nullif(trim(p_email), ''),
    nullif(trim(p_address), ''), v_district_id
  )
  on conflict (auth_user_id) do update set
    business_type = excluded.business_type, company = excluded.company,
    trade_name = excluded.trade_name, phone = excluded.phone, email = excluded.email,
    address = excluded.address, district_id = excluded.district_id, updated_at = now()
  returning * into v_account;

  insert into account_registration (
    account_id, ursb_number, tin, trading_licence, vat_number,
    ursb_state, tin_state, licence_state, vat_state, overall_state
  ) values (
    v_account.id, nullif(trim(p_ursb_number), ''), nullif(trim(p_tin), ''),
    nullif(trim(p_trading_licence), ''), nullif(trim(p_vat_number), ''),
    'pending', 'pending', 'pending',
    (case when nullif(trim(p_vat_number), '') is null then 'unverified' else 'pending' end)::verification_state,
    'pending'
  )
  on conflict (account_id) do update set
    ursb_number = excluded.ursb_number, tin = excluded.tin,
    trading_licence = excluded.trading_licence, vat_number = excluded.vat_number,
    ursb_state = 'pending', tin_state = 'pending', licence_state = 'pending',
    vat_state = excluded.vat_state, overall_state = 'pending',
    verified_at = null, verified_by = null;

  delete from applications where account_id = v_account.id and state = 'pending';
  insert into applications (account_id, state, registry_ursb, registry_ura, licence_check, sanctions)
  values (v_account.id, 'pending', 'pending', 'pending', 'pending', 'pending')
  returning * into v_application;

  return v_application;
end $$;

grant execute on function submit_supplier_application(
  text, text, text, text, business_type, text, text, text, text, text, text
) to authenticated;

-- ============================================================
-- deploy/supabase/migrations/0007_create_media_bucket.sql
-- ============================================================

-- Storage used by product/company media and private verification documents.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'media',
  'media',
  false,
  10485760,
  array['image/jpeg','image/png','image/webp','application/pdf']
)
on conflict (id) do update set
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

-- ============================================================
-- deploy/supabase/migrations/0008_admin_category_management.sql
-- ============================================================

-- Allow authenticated BUBU administrators to manage the catalogue taxonomy.
-- Public and supplier accounts remain read-only.

drop policy if exists categories_admin_write on categories;
create policy categories_admin_write on categories
for all to authenticated
using (is_admin())
with check (is_admin());

-- ============================================================
-- deploy/supabase/migrations/0009_supplier_company_profile.sql
-- ============================================================

-- Supplier company-profile fields that were previously display-only demo values.
alter table accounts add column if not exists alt_email text;
alter table accounts add column if not exists landline text;
alter table accounts add column if not exists legal_form text;
alter table accounts add column if not exists warehouse text;
alter table accounts add column if not exists fleet text;
alter table accounts add column if not exists banker text;
alter table accounts add column if not exists payment_terms text;
alter table accounts add column if not exists memberships text;
alter table accounts add column if not exists certifications text;

-- ============================================================
-- deploy/supabase/migrations/0010_lead_marketplace.sql
-- ============================================================

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

-- ============================================================
-- deploy/supabase/migrations/0011_uganda_districts.sql
-- ============================================================

-- Required reference data for Buyer/Supplier registration and lead-distance matching.
insert into districts(id,name,region,lat,lng) values
 ('kampala','Kampala','Central',0.34760,32.58250),
 ('wakiso','Wakiso','Central',0.40440,32.45940),
 ('mukono','Mukono','Central',0.35330,32.75530),
 ('entebbe','Entebbe','Central',0.05120,32.46330),
 ('jinja','Jinja','Eastern',0.42440,33.20420),
 ('mbale','Mbale','Eastern',1.06440,34.17970),
 ('soroti','Soroti','Eastern',1.71460,33.61110),
 ('tororo','Tororo','Eastern',0.69280,34.18080),
 ('lira','Lira','Northern',2.23500,32.90970),
 ('gulu','Gulu','Northern',2.77460,32.29900),
 ('arua','Arua','Northern',3.02010,30.91100),
 ('hoima','Hoima','Western',1.43510,31.35240),
 ('masaka','Masaka','Central',-0.34100,31.73600),
 ('mbarara','Mbarara','Western',-0.60720,30.65450),
 ('fort-portal','Fort Portal','Western',0.65400,30.27500),
 ('kabale','Kabale','Western',-1.24830,29.98990),
 ('kiryandongo','Kiryandongo','Western',1.87000,32.07000)
on conflict(id) do update set name=excluded.name,region=excluded.region,lat=excluded.lat,lng=excluded.lng;

-- ============================================================
-- deploy/supabase/migrations/0012_buyer_quote_manager.sql
-- ============================================================

-- Buyers may accept or decline supplier quotes without creating marketplace payments/orders.
create or replace function decide_quote(p_quote uuid, p_decision quote_state)
returns quotes language plpgsql security definer set search_path=public as $$
declare v_quote quotes; v_buyer uuid:=current_account_id();
begin
  if p_decision not in ('accepted','rejected') then raise exception 'decision must be accepted or rejected'; end if;
  select q.* into v_quote from quotes q join requirements r on r.id=q.requirement_id
    where q.id=p_quote and r.buyer_id=v_buyer for update;
  if not found then raise exception 'quote not found for this buyer'; end if;
  update quotes set state=p_decision where id=p_quote returning * into v_quote;
  if p_decision='accepted' then
    update quotes set state='rejected' where requirement_id=v_quote.requirement_id and id<>p_quote and state='sent';
    update requirements set state='awarded' where id=v_quote.requirement_id;
  end if;
  return v_quote;
end $$;
grant execute on function decide_quote(uuid,quote_state) to authenticated;

-- ============================================================
-- deploy/supabase/migrations/0013_buyer_supplier_visibility.sql
-- ============================================================

-- A buyer may see supplier identity only after the two accounts share a quote or chat.
drop policy if exists accounts_buyer_supplier_relationship on accounts;
create policy accounts_buyer_supplier_relationship on accounts for select using (
  role='supplier' and (
    exists(select 1 from conversations c
      where c.supplier_id=accounts.id and c.buyer_id=current_account_id())
    or exists(select 1 from quotes q join requirements r on r.id=q.requirement_id
      where q.supplier_id=accounts.id and r.buyer_id=current_account_id())
  )
);

-- ============================================================
-- deploy/supabase/migrations/0014_api_grants.sql
-- ============================================================

grant usage on schema public to anon, authenticated;
grant select on all tables in schema public to anon;
grant select, insert, update, delete on all tables in schema public to authenticated;
grant usage, select on all sequences in schema public to authenticated;
grant execute on all functions in schema public to authenticated;
alter default privileges for role postgres in schema public grant select on tables to anon;
alter default privileges for role postgres in schema public grant select, insert, update, delete on tables to authenticated;
alter default privileges for role postgres in schema public grant usage, select on sequences to authenticated;
alter default privileges for role postgres in schema public grant execute on functions to authenticated;

-- ============================================================
-- deploy/supabase/migrations/0015_catalog_media_admin.sql
-- ============================================================

update storage.buckets
set file_size_limit = 52428800,
    allowed_mime_types = array['image/jpeg','image/png','image/webp','application/pdf','video/mp4','video/webm','video/quicktime']
where id = 'media';

create or replace function create_catalog_category(p_name text, p_parent_id text default null)
returns categories language plpgsql security definer set search_path=public as $$
declare v_name text:=trim(p_name); v_id text; v_row categories;
begin
  if current_role_name() not in ('supplier','admin') then raise exception 'supplier or admin account required'; end if;
  if v_name='' then raise exception 'category name is required'; end if;
  if p_parent_id is not null and not exists(select 1 from categories where id=p_parent_id and parent_id is null)
    then raise exception 'valid top-level parent category required'; end if;
  select * into v_row from categories where lower(name)=lower(v_name) and parent_id is not distinct from p_parent_id limit 1;
  if found then return v_row; end if;
  v_id:=trim(both '-' from regexp_replace(lower(v_name),'[^a-z0-9]+','-','g'));
  if v_id='' then v_id:='category'; end if;
  if exists(select 1 from categories where id=v_id) then v_id:=v_id||'-'||substr(md5(coalesce(p_parent_id,'root')||v_name),1,6); end if;
  insert into categories(id,name,parent_id,sort) values(v_id,v_name,p_parent_id,(select coalesce(max(sort),0)+1 from categories)) returning * into v_row;
  return v_row;
end $$;
grant execute on function create_catalog_category(text,text) to authenticated;

-- 0016_tenders_media_history.sql
create table if not exists tenders (
  id uuid primary key default uuid_generate_v4(), title text not null,
  category_id text references categories, description text, estimated_value bigint,
  district_id text references districts, reference text, procurement_method text,
  bid_security text, requirements text, site_visit text, closes_at timestamptz,
  document_path text, status text not null default 'open' check (status in ('draft','open','closed','cancelled')),
  created_by uuid references accounts on delete set null, created_at timestamptz not null default now()
);
create index if not exists tenders_category_status_idx on tenders(category_id,status,closes_at);
alter table tenders enable row level security;
drop policy if exists tenders_read on tenders;
create policy tenders_read on tenders for select using (status='open' or is_admin());
drop policy if exists tenders_admin_write on tenders;
create policy tenders_admin_write on tenders for all using (is_admin()) with check (is_admin());
grant select on tenders to anon;
grant select,insert,update,delete on tenders to authenticated;

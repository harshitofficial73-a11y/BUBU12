-- Real tender publishing plus storefront media support.
create table if not exists tenders (
  id uuid primary key default uuid_generate_v4(),
  title text not null,
  category_id text references categories,
  description text,
  estimated_value bigint,
  district_id text references districts,
  reference text,
  procurement_method text,
  bid_security text,
  requirements text,
  site_visit text,
  closes_at timestamptz,
  document_path text,
  status text not null default 'open' check (status in ('draft','open','closed','cancelled')),
  created_by uuid references accounts on delete set null,
  created_at timestamptz not null default now()
);
create index if not exists tenders_category_status_idx on tenders(category_id,status,closes_at);
alter table tenders enable row level security;
drop policy if exists tenders_read on tenders;
create policy tenders_read on tenders for select using (status='open' or is_admin());
drop policy if exists tenders_admin_write on tenders;
create policy tenders_admin_write on tenders for all using (is_admin()) with check (is_admin());
grant select on tenders to anon;
grant select,insert,update,delete on tenders to authenticated;

-- Existing media RLS already limits writes to the current account. These labels
-- distinguish ordinary gallery photos from the company logo and cover image.

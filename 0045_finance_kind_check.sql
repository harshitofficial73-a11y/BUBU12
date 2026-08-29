-- Trade finance enquiries were being rejected by the table.
--
-- 0031 created finance_enquiries with a CHECK constraint allowing only
-- 'credit' and 'tax'. 0043 taught the function a third kind, 'trade_finance',
-- but left the constraint alone — so every invoice-finance enquiry was refused
-- by the database while the app showed "Thank you for your interest" and
-- swallowed the error.
--
-- That is the worst shape of bug: the trader believes they have asked, and
-- nobody is ever told. Found by submitting one and reading the row back.
--
-- Safe to re-run.

begin;

do $$
declare r record;
begin
  -- Drop whatever check is on `kind`, whatever it happens to be called.
  for r in
    select con.conname
      from pg_constraint con
      join pg_class c on c.oid = con.conrelid
      join pg_namespace n on n.oid = c.relnamespace
     where n.nspname = 'public'
       and c.relname = 'finance_enquiries'
       and con.contype = 'c'
       and pg_get_constraintdef(con.oid) ilike '%kind%'
  loop
    execute 'alter table public.finance_enquiries drop constraint ' || quote_ident(r.conname);
  end loop;
end $$;

alter table public.finance_enquiries
  add constraint finance_enquiries_kind_check
  check (kind in ('credit', 'tax', 'trade_finance'));

-- The same trap on the state column, if it is constrained: the admin screen
-- sets 'contacted' and 'closed'.
do $$
declare r record; v_def text;
begin
  for r in
    select con.conname, pg_get_constraintdef(con.oid) as def
      from pg_constraint con
      join pg_class c on c.oid = con.conrelid
      join pg_namespace n on n.oid = c.relnamespace
     where n.nspname = 'public'
       and c.relname = 'finance_enquiries'
       and con.contype = 'c'
       and pg_get_constraintdef(con.oid) ilike '%state%'
  loop
    v_def := r.def;
    if v_def not ilike '%contacted%' or v_def not ilike '%closed%' then
      execute 'alter table public.finance_enquiries drop constraint ' || quote_ident(r.conname);
      execute 'alter table public.finance_enquiries add constraint finance_enquiries_state_check '
        || 'check (state in (''new'', ''contacted'', ''closed''))';
    end if;
  end loop;
end $$;

commit;

notify pgrst, 'reload schema';

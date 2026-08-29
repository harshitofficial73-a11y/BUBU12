-- Selling was granted without approval. Two causes, both closed here.
--
-- 1. MY CAPABILITY RULE TRUSTED THE ROLE
--
--    my_capabilities said:
--      'can_sell', (a.role = 'supplier' or a.supplier_state = 'approved')
--
--    But submit_supplier_application inserts role = 'supplier' the moment
--    somebody self-registers as one. So registering as a supplier granted
--    selling instantly, and the approval step could be walked straight past.
--
--    A reasonable assumption for accounts that predate this work — they were
--    let in by the old route — but wrong going forward. 0044 already
--    back-filled every existing supplier to 'approved', so they keep selling.
--    can_sell now depends on that one column and nothing else.
--
-- 2. SELF-REGISTRATION DID NOT SET A STATE
--
--    A new supplier registration left supplier_state at its default 'none',
--    so it was only can_sell's role check that let them in at all. Now it
--    records 'pending', which is what it is, and puts them in the admin queue.
--
-- Safe to re-run.

begin;

-- "create or replace" cannot change a function's return type. Drop every
-- existing version by name first — read from the catalogue, not guessed at — so
-- this runs whatever shape the database currently holds, and runs again.
do $$
declare r record;
begin
  for r in
    select p.oid::regprocedure as sig
      from pg_proc p
      join pg_namespace n on n.oid = p.pronamespace
     where n.nspname = 'public'
       and p.proname in ('my_capabilities')
  loop
    execute 'drop function ' || r.sig;
  end loop;
end $$;


-- ── 1. can_sell means approved. Nothing else. ───────────────────────────────
create or replace function public.my_capabilities()
returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  select jsonb_build_object(
    'account_id', a.id,
    'role', a.role,
    'can_buy', true,
    -- One column decides this. The role no longer implies it.
    'can_sell', (a.supplier_state = 'approved'),
    'supplier_state', a.supplier_state,
    'is_admin', a.role = 'admin',
    'has_ursb', coalesce(nullif(trim(coalesce(r.ursb_number, '')), ''), '') <> '',
    'has_tin', coalesce(nullif(trim(coalesce(r.tin, '')), ''), '') <> '',
    'has_licence', coalesce(nullif(trim(coalesce(r.trading_licence, '')), ''), '') <> '',
    'doc_count', (select count(*) from documents d where d.account_id = a.id),
    'product_count', (select count(*) from products p where p.supplier_id = a.id),
    'applied_at', (select max(s.submitted_at) from applications s where s.account_id = a.id)
  )
  from accounts a
  left join account_registration r on r.account_id = a.id
  where a.id = current_account_id();
$$;

grant execute on function public.my_capabilities() to authenticated;

-- Safety net for the back-fill: any supplier whose registration was actually
-- verified is approved. Anyone else holding role 'supplier' without a verified
-- registration becomes pending rather than silently keeping access.
update public.accounts a
   set supplier_state = 'approved'
  from public.account_registration r
 where r.account_id = a.id
   and r.overall_state = 'verified'
   and a.supplier_state <> 'approved';

update public.accounts a
   set supplier_state = 'pending'
 where a.role = 'supplier'
   and a.supplier_state = 'none';

-- ── 2. Self-registering as a supplier records pending, not access ───────────
create or replace function public.mark_supplier_pending()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  -- A brand new supplier row, or one switching into the role, is pending until
  -- admin says otherwise. An already-approved account is left alone.
  if new.role = 'supplier' and coalesce(new.supplier_state, 'none') = 'none' then
    new.supplier_state := 'pending';
  end if;
  return new;
end;
$$;

drop trigger if exists accounts_supplier_pending on public.accounts;
create trigger accounts_supplier_pending
  before insert or update of role on public.accounts
  for each row execute function public.mark_supplier_pending();

commit;

notify pgrst, 'reload schema';

-- Supplier accounts must never be asked to verify again.
--
-- I over-tightened this in 0046. can_sell became "supplier_state = 'approved'"
-- and nothing else, and 0046 then set any supplier still sitting at the default
-- 'none' to 'pending' — so a supplier account created between 0044 and 0046 was
-- locked out of its own selling side and asked to apply.
--
-- The rule you stated, which this now implements exactly:
--
--   A SUPPLIER account can sell, and can also buy, with no further approval.
--   A BUYER account must be approved once to sell. After that it is free too.
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


-- Nobody who registered as a supplier is waiting on anything.
update public.accounts
   set supplier_state = 'approved'
 where role = 'supplier'
   and supplier_state <> 'approved';

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
    -- Everyone buys. A supplier account sells because it registered as one; a
    -- buyer account sells once admin has approved it.
    'can_buy', true,
    'can_sell', (a.role = 'supplier' or a.supplier_state = 'approved'),
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

-- The trigger from 0046 marked new supplier rows 'pending'. Under the rule
-- above a supplier account is not pending, so it now marks them approved —
-- keeping the column honest rather than leaving it at 'none'.
create or replace function public.mark_supplier_pending()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.role = 'supplier' and coalesce(new.supplier_state, 'none') = 'none' then
    new.supplier_state := 'approved';
  end if;
  return new;
end;
$$;

commit;

notify pgrst, 'reload schema';

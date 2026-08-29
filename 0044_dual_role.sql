-- One account, two capabilities.
--
-- Until now an account was a buyer OR a supplier, and the role switcher just
-- changed which screens you saw — it did not reflect anything real, and it
-- offered Admin view to everybody.
--
-- Now:
--   Every account can buy. Buying needs no approval.
--   Selling needs approval. A supplier account already has it. A buyer applies,
--   admin reviews, and until then the supplier side says so.
--
-- And an account can never trade with itself: its own requirements are hidden
-- from its own lead board, its own listings are hidden from its own search, and
-- it cannot open a conversation with itself.
--
-- Safe to re-run.

begin;

-- none      never asked
-- pending   applied, waiting on admin
-- approved  may sell
-- rejected  admin declined; they can apply again
alter table public.accounts
  add column if not exists supplier_state text not null default 'none';

-- Anyone already registered as a supplier keeps selling: they were approved by
-- the older route, and a migration must not take that away.
update public.accounts
   set supplier_state = 'approved'
 where role = 'supplier' and supplier_state = 'none';

-- What the app needs to decide which views to offer.
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
    'can_sell', (a.role = 'supplier' or a.supplier_state = 'approved'),
    'supplier_state', a.supplier_state,
    'is_admin', a.role = 'admin',
    -- what is still outstanding, so the waiting screen can be specific
    'has_ursb', coalesce(nullif(trim(coalesce(r.ursb_number, '')), ''), '') <> '',
    'has_tin', coalesce(nullif(trim(coalesce(r.tin, '')), ''), '') <> '',
    'has_licence', coalesce(nullif(trim(coalesce(r.trading_licence, '')), ''), '') <> '',
    'doc_count', (select count(*) from documents d where d.account_id = a.id),
    'product_count', (select count(*) from products p where p.supplier_id = a.id),
    'applied_at', (select max(s.submitted_at) from applications s
                    where s.account_id = a.id)
  )
  from accounts a
  left join account_registration r on r.account_id = a.id
  where a.id = current_account_id();
$$;

grant execute on function public.my_capabilities() to authenticated;

-- A buyer asking to sell. Records the application and flips them to pending, so
-- they appear in the admin queue that already exists.
create or replace function public.apply_to_sell()
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare v_acct accounts; v_reg account_registration; v_missing text[] := '{}';
begin
  select * into v_acct from accounts where id = current_account_id();
  if v_acct.id is null then raise exception 'Sign in first'; end if;
  if v_acct.role = 'supplier' or v_acct.supplier_state = 'approved' then
    return jsonb_build_object('state', 'approved');
  end if;

  select * into v_reg from account_registration where account_id = v_acct.id;

  -- The paperwork admin actually checks. Asking for it up front is kinder than
  -- accepting an application and rejecting it a week later.
  if coalesce(nullif(trim(coalesce(v_reg.ursb_number, '')), ''), '') = ''
    then v_missing := v_missing || 'URSB registration number'; end if;
  if coalesce(nullif(trim(coalesce(v_reg.tin, '')), ''), '') = ''
    then v_missing := v_missing || 'URA TIN'; end if;
  if not exists (select 1 from documents d where d.account_id = v_acct.id)
    then v_missing := v_missing || 'At least one document'; end if;

  if array_length(v_missing, 1) > 0 then
    return jsonb_build_object('state', 'incomplete', 'missing', to_jsonb(v_missing));
  end if;

  insert into account_registration (account_id, overall_state)
  values (v_acct.id, 'pending')
  on conflict (account_id) do update set overall_state = 'pending'
    where account_registration.overall_state not in ('verified');

  -- One open application at a time; a second tap must not queue a duplicate.
  if not exists (select 1 from applications
                  where account_id = v_acct.id and state = 'pending') then
    insert into applications (account_id, state, submitted_at)
    values (v_acct.id, 'pending', now());
  end if;

  update accounts set supplier_state = 'pending' where id = v_acct.id;
  return jsonb_build_object('state', 'pending');
end;
$$;

grant execute on function public.apply_to_sell() to authenticated;

-- Admin's decision. Approving lets them sell; the account keeps buying either
-- way, which is the point of one account with two capabilities.
create or replace function public.decide_seller(p_account uuid, p_approve boolean)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if not is_admin() then raise exception 'Admin account required'; end if;
  update accounts
     set supplier_state = case when p_approve then 'approved' else 'rejected' end
   where id = p_account;
  update account_registration
     set overall_state = case when p_approve then 'verified' else 'rejected' end,
         verified_at = case when p_approve then now() else null end,
         verified_by = current_account_id()
   where account_id = p_account;
  update applications
     set state = case when p_approve then 'verified' else 'rejected' end,
         decided_by = current_account_id(),
         decided_at = now()
   where account_id = p_account and state = 'pending';
end;
$$;

grant execute on function public.decide_seller(uuid, boolean) to authenticated;

-- ── No trading with yourself ────────────────────────────────────────────────

-- Browsing as a buyer must not show your own listings. One account now buys and
-- sells, so without this a trader sees their own cement in the marketplace and
-- their own requirement on their own lead board.
create or replace function public.hide_own(p_supplier uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(p_supplier <> current_account_id(), true);
$$;

grant execute on function public.hide_own(uuid) to authenticated, anon;

-- The lead board already excluded the caller's own requirements. This makes it
-- explicit and adds the same rule to conversations.
create or replace function public.start_supplier_conversation(p_supplier uuid)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare v_me uuid; v_conv uuid;
begin
  v_me := current_account_id();
  if v_me is null then raise exception 'Sign in first'; end if;
  if v_me = p_supplier then
    raise exception 'That is your own business — you cannot message yourself';
  end if;
  select id into v_conv from conversations
   where buyer_id = v_me and supplier_id = p_supplier and requirement_id is null
   limit 1;
  if v_conv is null then
    insert into conversations (buyer_id, supplier_id, subject)
    values (v_me, p_supplier,
      (select coalesce(company, 'Enquiry') from accounts where id = p_supplier))
    returning id into v_conv;
  end if;
  return jsonb_build_object('id', v_conv);
end;
$$;

grant execute on function public.start_supplier_conversation(uuid) to authenticated;

commit;

notify pgrst, 'reload schema';

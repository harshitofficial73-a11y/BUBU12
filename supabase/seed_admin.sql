-- BUBU.Market · link Nidhi as the first platform administrator
-- FIRST create nidhi@bubumarket.com in Authentication -> Users.
-- Password: Bubu@2027; Auto-confirm email: enabled. Then run this file.

do $$
declare
  v_email text := 'nidhi@bubumarket.com';
  v_uid uuid;
  v_account_id uuid;
begin
  select id into v_uid from auth.users
  where lower(email) = lower(v_email)
  order by created_at desc limit 1;

  if v_uid is null then
    raise exception 'Create nidhi@bubumarket.com in Authentication -> Users first';
  end if;

  select id into v_account_id from public.accounts
  where role = 'admin' order by created_at limit 1;

  if v_account_id is null then
    insert into public.accounts (
      auth_user_id, role, tier, company, trade_name, initials,
      phone, email, address, district_id
    ) values (
      v_uid, 'admin', 'free', 'BUBU.Market Uganda Limited',
      'Platform Operations', 'NN', '+256800218400', v_email,
      'Level 4, Acacia Place, Kololo', 'kampala'
    ) returning id into v_account_id;
  else
    update public.accounts set
      auth_user_id = v_uid, role = 'admin',
      company = 'BUBU.Market Uganda Limited', trade_name = 'Platform Operations',
      initials = 'NN', email = v_email, updated_at = now()
    where id = v_account_id;
  end if;

  insert into public.account_users (
    account_id, auth_user_id, full_name, role_title, phone,
    can_post, can_accept, can_release, can_billing
  ) values (
    v_account_id, v_uid, 'Nidhi', 'Platform Administrator', '+256800218400',
    true, true, true, true
  ) on conflict (auth_user_id) do update set
    account_id = excluded.account_id, full_name = excluded.full_name,
    role_title = excluded.role_title, can_post = true, can_accept = true,
    can_release = true, can_billing = true;

  insert into public.account_registration (
    account_id, ursb_number, tin, trading_licence, licence_authority,
    overall_state, ursb_state, tin_state, licence_state, verified_at
  ) values (
    v_account_id, '80020000000001', '1000000001',
    'KCCA/TL/2026/00001', 'KCCA',
    'verified', 'verified', 'verified', 'verified', now()
  ) on conflict (account_id) do update set
    overall_state = 'verified', ursb_state = 'verified', tin_state = 'verified',
    licence_state = 'verified', verified_at = coalesce(public.account_registration.verified_at, now());

  raise notice 'Nidhi admin is ready: account %, auth user %', v_account_id, v_uid;
end $$;

select a.role, a.company, a.email, u.email_confirmed_at
from public.accounts a join auth.users u on u.id = a.auth_user_id
where lower(a.email) = 'nidhi@bubumarket.com';

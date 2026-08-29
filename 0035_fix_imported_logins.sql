-- Sign-in fix for the eight imported suppliers.
--
-- The import created their logins with a plain INSERT into auth.users. That
-- works for the password itself, but Supabase's auth service reads several
-- token columns into plain strings, and a plain INSERT leaves them NULL.
-- The service cannot read NULL into a string, so it fails before it ever
-- checks the password — which is why signing in returned
-- "Database error querying schema" rather than "wrong password".
--
-- Setting those columns to an empty string is what the service expects for
-- "no token outstanding". Nothing else about the accounts changes, and the
-- password is untouched.
--
-- Safe to run more than once.

update auth.users set
  confirmation_token     = coalesce(confirmation_token, ''),
  recovery_token         = coalesce(recovery_token, ''),
  email_change           = coalesce(email_change, ''),
  email_change_token_new = coalesce(email_change_token_new, ''),
  phone_change           = coalesce(phone_change, ''),
  phone_change_token     = coalesce(phone_change_token, ''),
  reauthentication_token = coalesce(reauthentication_token, '')
where email like '%@suppliers.bubu.market';

-- Some projects also carry this older column. Ignored when absent.
do $$
begin
  update auth.users
  set email_change_token_current = coalesce(email_change_token_current, '')
  where email like '%@suppliers.bubu.market';
exception when undefined_column then null;
end $$;

-- What you should see: eight rows, every token column an empty string.
select email, confirmation_token = '' as ok_confirm, recovery_token = '' as ok_recovery,
       email_change = '' as ok_change
from auth.users
where email like '%@suppliers.bubu.market'
order by email;

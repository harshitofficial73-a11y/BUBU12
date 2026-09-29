-- Is this email or phone already registered?
--
-- Registration now checks before sending a code, so someone who already has an
-- account is told to sign in rather than being sent a code and then failing at
-- the last step with a database error.
--
-- Only COMPLETED registrations count (a row in accounts). A person who started
-- registering and gave up still has a half-made sign-in record; counting that
-- would lock them out of ever finishing.
--
-- Returns two yes/no answers and nothing else, so it cannot be used to read
-- anyone's details.
--
-- Safe to re-run.

create or replace function public.registration_taken(p_email text, p_phone text)
returns jsonb
language sql stable security definer set search_path = public as $$
  with d as (
    select lower(trim(coalesce(p_email, ''))) as e,
           right(regexp_replace(coalesce(p_phone, ''), '\D', '', 'g'), 9) as p
  )
  select jsonb_build_object(
    'email', exists (select 1 from accounts a, d
                      where d.e <> '' and lower(trim(a.email)) = d.e),
    'phone', exists (select 1 from accounts a, d
                      where length(d.p) = 9 and (
                        right(regexp_replace(coalesce(a.phone, ''), '\D', '', 'g'), 9) = d.p
                        or right(regexp_replace(coalesce(a.whatsapp_phone, ''), '\D', '', 'g'), 9) = d.p)))
  from d;
$$;

grant execute on function public.registration_taken(text, text) to anon, authenticated;

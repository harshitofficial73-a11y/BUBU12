-- Imported phone numbers were concatenated into one string.
--
-- My import generator joined every number a supplier listed into a single
-- value, so Power Products Uganda Ltd carries this as its phone:
--
--   +256758383266+256758383340+256414341174+256392176430
--
-- It is not a phone number. It cannot be dialled, and wa.me is handed 48
-- digits, which is the real reason WhatsApp "does not work" for imported
-- suppliers — the link is built correctly from a number that is nonsense.
--
-- Two shapes came out of the source: some keep a + between each number, some
-- ran together with no separator at all. Both are split here.
--
-- The first number becomes phone, the second alt_phone, and the first also
-- becomes whatsapp_phone where that was equally broken. Any beyond the second
-- are appended to the account's about text rather than dropped, so nothing is
-- lost — there are only two columns for numbers.
--
-- Safe to re-run: it only touches values that are still too long to be a phone
-- number, so a corrected row is left alone.

begin;

create or replace function public.split_ug_phones(p_raw text)
returns text[]
language plpgsql
immutable
as $$
declare
  v text := regexp_replace(coalesce(p_raw, ''), '[^0-9+]', '', 'g');
  v_out text[] := '{}';
  v_part text;
begin
  if v = '' then return v_out; end if;

  -- Shape one: a + before each number.
  if (length(v) - length(replace(v, '+', ''))) > 1 then
    foreach v_part in array regexp_split_to_array(v, '\+') loop
      if length(v_part) between 9 and 13 then
        v_out := v_out || ('+' || v_part);
      end if;
    end loop;
    return v_out;
  end if;

  -- Shape two: run together with no separator. Ugandan numbers are +256 plus
  -- nine digits, so cut on each 256 that starts a full-length number.
  v := regexp_replace(v, '^\+', '');
  while length(v) >= 12 loop
    if substring(v from 1 for 3) = '256' then
      v_out := v_out || ('+' || substring(v from 1 for 12));
      v := substring(v from 13);
    else
      -- Not a shape we recognise: keep what is left as one number and stop,
      -- rather than chopping it into fragments that dial nowhere.
      exit;
    end if;
  end loop;
  if length(v) between 9 and 12 then
    v_out := v_out || ('+' || case when substring(v from 1 for 3) = '256' then v else '256' || v end);
  end if;
  return v_out;
end;
$$;

do $$
declare
  r record;
  v_nums text[];
  v_extra text;
begin
  for r in
    select id, phone, alt_phone, whatsapp_phone, about
      from accounts
     -- only rows still holding a concatenated value
     where length(regexp_replace(coalesce(phone, ''), '[^0-9]', '', 'g')) > 13
  loop
    v_nums := public.split_ug_phones(r.phone);
    if array_length(v_nums, 1) is null then continue; end if;

    -- Anything past the second number has no column, so it is recorded in the
    -- profile text instead of being thrown away.
    v_extra := null;
    if array_length(v_nums, 1) > 2 then
      v_extra := 'Other numbers: ' || array_to_string(v_nums[3:array_length(v_nums, 1)], ', ') || '.';
    end if;

    update accounts
       set phone = v_nums[1],
           alt_phone = coalesce(
             case when array_length(v_nums, 1) > 1 then v_nums[2] end,
             case when length(regexp_replace(coalesce(alt_phone, ''), '[^0-9]', '', 'g')) between 9 and 13
                  then alt_phone end),
           whatsapp_phone = case
             when length(regexp_replace(coalesce(whatsapp_phone, ''), '[^0-9]', '', 'g')) between 9 and 13
               then whatsapp_phone
             else v_nums[1]
           end,
           about = case
             when v_extra is null then about
             when coalesce(about, '') like '%Other numbers:%' then about
             else trim(both ' ' from coalesce(about, '') || ' ' || v_extra)
           end
     where id = r.id;
  end loop;
end $$;

-- Any whatsapp_phone still too long, whatever its origin.
update accounts
   set whatsapp_phone = phone
 where length(regexp_replace(coalesce(whatsapp_phone, ''), '[^0-9]', '', 'g')) > 13
   and length(regexp_replace(coalesce(phone, ''), '[^0-9]', '', 'g')) between 9 and 13;

commit;

notify pgrst, 'reload schema';

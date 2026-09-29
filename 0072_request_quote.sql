-- 0072 · Request a quote actually opens a conversation.
--
-- 0044's start_supplier_conversation inserted a "subject" column that the
-- conversations table does not have, so every Request quote failed with a
-- column error before any message was written.
--
-- This replaces it, and adds request_product_quote: one call that finds or
-- opens the thread between this buyer and supplier and posts the quote request
-- in it, so the buyer sees it in Messages and the supplier in their inbox.
-- Done inside the database so it does not depend on message-table policies.
--
-- Safe to re-run.

begin;

do $$
declare r record;
begin
  for r in select p.oid::regprocedure as sig from pg_proc p
             join pg_namespace n on n.oid = p.pronamespace
            where n.nspname = 'public'
              and p.proname in ('start_supplier_conversation', 'request_product_quote')
  loop execute 'drop function ' || r.sig; end loop;
end $$;

create function public.start_supplier_conversation(p_supplier uuid)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare v_me uuid; v_conv uuid;
begin
  v_me := current_account_id();
  if v_me is null then raise exception 'Sign in to contact a supplier'; end if;
  if v_me = p_supplier then raise exception 'That is your own business'; end if;
  select id into v_conv from conversations
   where buyer_id = v_me and supplier_id = p_supplier and requirement_id is null
   limit 1;
  if v_conv is null then
    insert into conversations (buyer_id, supplier_id, last_message_at)
    values (v_me, p_supplier, now())
    returning id into v_conv;
  end if;
  return jsonb_build_object('id', v_conv);
end;
$$;

create function public.request_product_quote(p_product uuid, p_supplier uuid, p_quantity numeric default 1)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare v_me uuid; v_conv uuid; v_prod products%rowtype; v_body text;
begin
  v_me := current_account_id();
  if v_me is null then raise exception 'Sign in to request a quote'; end if;
  if v_me = p_supplier then raise exception 'That is your own listing'; end if;

  select * into v_prod from products where id = p_product;

  select id into v_conv from conversations
   where buyer_id = v_me and supplier_id = p_supplier and requirement_id is null
   limit 1;
  if v_conv is null then
    insert into conversations (buyer_id, supplier_id, last_message_at)
    values (v_me, p_supplier, now())
    returning id into v_conv;
  end if;

  v_body := 'Quote request: ' || coalesce(v_prod.name, 'your product')
         || ' — quantity ' || trim(to_char(coalesce(p_quantity, 1), 'FM999999990.##'))
         || ' ' || coalesce(v_prod.unit, 'unit')
         || '. Please send your best price and delivery time.';

  insert into messages (conversation_id, sender_id, direction, channel, body)
  values (v_conv, v_me, 'out', 'app', v_body);

  update conversations set last_message_at = now() where id = v_conv;

  return jsonb_build_object('conversation_id', v_conv, 'body', v_body);
end;
$$;

grant execute on function public.start_supplier_conversation(uuid) to authenticated;
grant execute on function public.request_product_quote(uuid, uuid, numeric) to authenticated;

commit;

notify pgrst, 'reload schema';

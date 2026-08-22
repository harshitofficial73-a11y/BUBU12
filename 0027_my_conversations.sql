-- Conversations with their counterparty attached.
--
-- The old client query joined accounts directly:
--   conversations.select('*, buyer:buyer_id(company,phone,district_id) …')
-- RLS on `accounts` stops a supplier reading a buyer's row, so that join came
-- back null and the chat header had no name and no number — it rendered
-- "Select a conversation" and "Number not on file" even with a thread open.
--
-- This returns the counterparty from a SECURITY DEFINER function instead, with
-- the phone released only when the caller is entitled to it: the supplier has
-- bought that lead, or the caller is the buyer looking at their own supplier.

create or replace function public.my_conversations()
returns jsonb language plpgsql security definer set search_path=public as $$
declare v_me uuid := current_account_id();
begin
  if v_me is null then raise exception 'sign in required'; end if;

  return coalesce((
    select jsonb_agg(row order by row->>'last_message_at' desc nulls last)
    from (
      select jsonb_build_object(
        'id', c.id,
        'supplier_id', c.supplier_id,
        'buyer_id', c.buyer_id,
        'requirement_id', c.requirement_id,
        'requirement_title', r.title,
        'last_message_at', c.last_message_at,
        'i_am_supplier', (c.supplier_id = v_me),

        'other', jsonb_build_object(
          'id', o.id,
          'company', o.company,
          'trade_name', o.trade_name,
          'district_id', o.district_id,
          'rating', o.rating,
          -- released to the buyer always, and to the supplier once the lead is paid for
          'phone', case
            when c.buyer_id = v_me then o.phone
            when exists (select 1 from lead_purchases lp
                         where lp.supplier_id = v_me
                           and lp.requirement_id = c.requirement_id
                           and lp.payment_state <> 'payment_required') then o.phone
            end,
          'email', case
            when c.buyer_id = v_me then o.email
            when exists (select 1 from lead_purchases lp
                         where lp.supplier_id = v_me
                           and lp.requirement_id = c.requirement_id
                           and lp.payment_state <> 'payment_required') then o.email
            end),

        'messages', coalesce((
          select jsonb_agg(jsonb_build_object('id', m.id, 'sender_id', m.sender_id,
            'direction', m.direction, 'channel', m.channel, 'body', m.body,
            'sent_at', m.sent_at, 'read_at', m.read_at) order by m.sent_at)
          from messages m where m.conversation_id = c.id), '[]'::jsonb)
      ) as row
      from conversations c
      join accounts o on o.id = case when c.supplier_id = v_me then c.buyer_id else c.supplier_id end
      left join requirements r on r.id = c.requirement_id
      where c.supplier_id = v_me or c.buyer_id = v_me
    ) t
  ), '[]'::jsonb);
end $$;

grant execute on function public.my_conversations() to authenticated;

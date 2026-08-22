-- One board for the supplier's leads: what is still for sale and what they
-- already bought, with the buyer detail each state is allowed to see.
--
-- Contact details are gated in SQL, not in the browser. An unpurchased lead
-- never carries the buyer's phone, company or email in its payload, so there is
-- nothing to uncover by reading the network response.

create or replace function public.my_lead_board()
returns jsonb language plpgsql security definer set search_path=public as $$
declare
  v_supplier uuid := current_account_id();
begin
  if v_supplier is null then raise exception 'sign in required'; end if;

  return coalesce((
    select jsonb_agg(row order by row->>'created_at' desc)
    from (
      select jsonb_build_object(
        'id', r.id,
        'title', r.title,
        'quantity', r.quantity,
        'quantity_unit', r.quantity_unit,
        'specification', r.specification,
        'deliver_to', r.deliver_to,
        'district_id', r.district_id,
        'estimated_value', r.estimated_value,
        'purpose', r.purpose,
        'state', r.state,
        'created_at', r.created_at,
        'category_id', r.category_id,

        'purchased', (lp.id is not null and lp.payment_state <> 'payment_required'),
        'purchased_at', lp.purchased_at,
        'conversation_id', lp.conversation_id,
        'charged', lp.payment_amount,

        -- the supplier's own quote against this requirement, if sent
        'my_quote', (select jsonb_build_object('state', q.state, 'unit_price', q.unit_price,
                              'quantity', q.quantity, 'created_at', q.created_at)
                     from quotes q
                     where q.requirement_id = r.id and q.supplier_id = v_supplier),

        'buyer', jsonb_build_object(
          -- always visible: enough to judge the lead, nothing to identify by
          'member_since', b.created_at,
          'district_id', b.district_id,
          'ursb_verified', coalesce(br.ursb_state::text, '') = 'verified',
          'vat_registered', coalesce(br.vat_number, '') <> '',
          'requirement_count', (select count(*) from requirements x where x.buyer_id = b.id),
          'quotes_received', (select count(*) from quotes x
                              join requirements xr on xr.id = x.requirement_id
                              where xr.buyer_id = b.id),
          'replies', (select count(*) from messages m
                      join conversations c on c.id = m.conversation_id
                      where c.buyer_id = b.id and m.sender_id = b.id),
          'buys', coalesce((select jsonb_agg(distinct x.title)
                            from requirements x where x.buyer_id = b.id), '[]'::jsonb),

          -- released only once the lead is paid for
          'company', case when lp.id is not null and lp.payment_state <> 'payment_required'
                     then b.company end,
          'trade_name', case when lp.id is not null and lp.payment_state <> 'payment_required'
                       then b.trade_name end,
          'phone', case when lp.id is not null and lp.payment_state <> 'payment_required'
                   then b.phone end,
          'whatsapp', case when lp.id is not null and lp.payment_state <> 'payment_required'
                      then b.whatsapp_phone end,
          'email', case when lp.id is not null and lp.payment_state <> 'payment_required'
                   then b.email end,
          'address', case when lp.id is not null and lp.payment_state <> 'payment_required'
                     then b.address end
        )
      ) as row
      from requirements r
      join accounts b on b.id = r.buyer_id
      left join account_registration br on br.account_id = b.id
      left join lead_purchases lp on lp.requirement_id = r.id and lp.supplier_id = v_supplier
      where r.buyer_id <> v_supplier
        and (
          -- still on the board
          (r.state = 'open' and r.id in (select id from my_buy_leads()))
          -- or already bought, which keeps it in the lead manager for good
          or (lp.id is not null and lp.payment_state <> 'payment_required')
        )
    ) t
  ), '[]'::jsonb);
end $$;

grant execute on function public.my_lead_board() to authenticated;

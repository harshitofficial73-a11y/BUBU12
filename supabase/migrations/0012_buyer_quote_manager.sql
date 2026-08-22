-- Buyers may accept or decline supplier quotes without creating marketplace payments/orders.
create or replace function decide_quote(p_quote uuid, p_decision quote_state)
returns quotes language plpgsql security definer set search_path=public as $$
declare v_quote quotes; v_buyer uuid:=current_account_id();
begin
  if p_decision not in ('accepted','rejected') then raise exception 'decision must be accepted or rejected'; end if;
  select q.* into v_quote from quotes q join requirements r on r.id=q.requirement_id
    where q.id=p_quote and r.buyer_id=v_buyer for update;
  if not found then raise exception 'quote not found for this buyer'; end if;
  update quotes set state=p_decision where id=p_quote returning * into v_quote;
  if p_decision='accepted' then
    update quotes set state='rejected' where requirement_id=v_quote.requirement_id and id<>p_quote and state='sent';
    update requirements set state='awarded' where id=v_quote.requirement_id;
  end if;
  return v_quote;
end $$;
grant execute on function decide_quote(uuid,quote_state) to authenticated;

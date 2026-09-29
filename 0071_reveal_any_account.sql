-- 0071 · Let any signed-in account see a supplier's number.
--
-- reveal_supplier_contact still required role = 'buyer'. Since accounts both
-- buy and sell, anyone signed in on a supplier account who switched to Buying
-- was refused ("Buyer account required"), so Get quote and Call now showed no
-- number. Now: any signed-in account, except the supplier themselves.
-- Safe to re-run.

create or replace function public.reveal_supplier_contact(p_supplier uuid)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare v_me uuid; v_supplier accounts%rowtype;
begin
  v_me := current_account_id();
  if v_me is null then raise exception 'Sign in to see the number'; end if;
  select * into v_supplier from accounts where id = p_supplier;
  if v_supplier.id is null then raise exception 'Supplier not found'; end if;
  return jsonb_build_object(
    'supplier_id', v_supplier.id,
    'company', v_supplier.company,
    'phone', v_supplier.phone,
    'alt_phone', v_supplier.alt_phone,
    'whatsapp_phone', coalesce(v_supplier.whatsapp_phone, v_supplier.phone));
end;
$$;

grant execute on function public.reveal_supplier_contact(uuid) to authenticated;

notify pgrst, 'reload schema';

-- Full member record for the admin console, in one round trip.
--
-- Deliberately excluded: passwords. Supabase stores only a bcrypt hash of a
-- password in auth.users.encrypted_password and there is no way to recover the
-- plain text from it. What an admin can act on instead is whether a password is
-- set at all, whether the email is confirmed, and when the member last signed
-- in; all three are returned below.

create or replace function public.admin_member_detail(p_account uuid)
returns jsonb language plpgsql security definer set search_path=public as $$
declare
  v_result jsonb;
begin
  if not is_admin() then raise exception 'Admin account required'; end if;

  select jsonb_build_object(
    'account', jsonb_build_object(
      'id', a.id, 'role', a.role, 'company', a.company, 'trade_name', a.trade_name,
      'initials', a.initials, 'business_type', a.business_type, 'tier', a.tier,
      'phone', a.phone, 'alt_phone', a.alt_phone, 'whatsapp_phone', a.whatsapp_phone,
      'email', a.email, 'address', a.address, 'district_id', a.district_id,
      'incorporated_on', a.incorporated_on, 'about', a.about, 'coverage', a.coverage,
      'nature_of_business', a.nature_of_business, 'staff_count', a.staff_count,
      'turnover', a.turnover, 'brands', a.brands, 'spend_12m', a.spend_12m,
      'supplier_count', a.supplier_count,
      'created_at', a.created_at, 'updated_at', a.updated_at),

    'login', (
      select jsonb_build_object(
        'auth_user_id', u.id, 'email', u.email, 'phone', u.phone,
        'has_password', (u.encrypted_password is not null and u.encrypted_password <> ''),
        'email_confirmed_at', u.email_confirmed_at,
        'phone_confirmed_at', u.phone_confirmed_at,
        'last_sign_in_at', u.last_sign_in_at,
        'created_at', u.created_at)
      from auth.users u where u.id = a.auth_user_id),

    'registration', (
      select to_jsonb(r) - 'account_id' from account_registration r where r.account_id = a.id),

    'categories', coalesce((
      select jsonb_agg(jsonb_build_object('id', c.id, 'name', c.name, 'parent_id', c.parent_id)
        order by c.name)
      from account_categories ac join categories c on c.id = ac.category_id
      where ac.account_id = a.id), '[]'::jsonb),

    'documents', coalesce((
      select jsonb_agg(jsonb_build_object(
        'id', d.id, 'kind', d.kind, 'issuer', d.issuer, 'reference', d.reference,
        'storage_path', d.storage_path, 'state', d.state, 'created_at', d.created_at)
        order by d.created_at desc)
      from documents d where d.account_id = a.id), '[]'::jsonb),

    'products', coalesce((
      select jsonb_agg(jsonb_build_object(
        'id', p.id, 'name', p.name, 'category_id', p.category_id,
        'category_name', pc.name, 'description', p.description,
        'price', p.price, 'unit', p.unit, 'moq', p.moq, 'brand', p.brand,
        'status', p.status, 'rating', p.rating, 'order_count', p.order_count,
        'view_count', p.view_count, 'created_at', p.created_at,
        'specs', coalesce((select jsonb_agg(jsonb_build_object('key', s.key, 'value', s.value) order by s.sort)
          from product_specs s where s.product_id = p.id), '[]'::jsonb),
        'photos', coalesce((select jsonb_agg(m.storage_path order by m.created_at)
          from media m where m.product_id = p.id and m.kind = 'product'), '[]'::jsonb),
        'document_path', (select m.storage_path from media m
          where m.product_id = p.id and m.kind = 'product_pdf' order by m.created_at desc limit 1))
        order by p.created_at desc)
      from products p left join categories pc on pc.id = p.category_id
      where p.supplier_id = a.id), '[]'::jsonb),

    'addresses', coalesce((select jsonb_agg(to_jsonb(x) - 'account_id')
      from addresses x where x.account_id = a.id), '[]'::jsonb),
    'payout_methods', coalesce((select jsonb_agg(to_jsonb(x) - 'account_id')
      from payout_methods x where x.account_id = a.id), '[]'::jsonb),
    'handsets', coalesce((select jsonb_agg(to_jsonb(x) - 'account_id')
      from handsets x where x.account_id = a.id), '[]'::jsonb),
    'staff', coalesce((select jsonb_agg(to_jsonb(x) - 'account_id')
      from account_users x where x.account_id = a.id), '[]'::jsonb),

    'subscription', (select to_jsonb(s) - 'account_id' from subscriptions s
      where s.account_id = a.id order by s.created_at desc limit 1),
    'plan_purchases', coalesce((
      select jsonb_agg(jsonb_build_object('plan_code', pp.plan_code, 'amount', pp.amount,
        'method', pp.method, 'created_at', pp.created_at) order by pp.created_at desc)
      from plan_purchases pp where pp.account_id = a.id), '[]'::jsonb),

    'requirements', coalesce((
      select jsonb_agg(jsonb_build_object('id', rq.id, 'title', rq.title,
        'quantity', rq.quantity, 'unit', rq.quantity_unit, 'state', rq.state,
        'category_id', rq.category_id, 'estimated_value', rq.estimated_value,
        'needed_by', rq.needed_by, 'created_at', rq.created_at,
        'quote_count', (select count(*) from quotes q where q.requirement_id = rq.id))
        order by rq.created_at desc)
      from requirements rq where rq.buyer_id = a.id), '[]'::jsonb),

    'quotes', coalesce((
      select jsonb_agg(jsonb_build_object('id', q.id, 'requirement_id', q.requirement_id,
        'unit_price', q.unit_price, 'quantity', q.quantity, 'lead_time', q.lead_time,
        'state', q.state, 'created_at', q.created_at)
        order by q.created_at desc)
      from quotes q where q.supplier_id = a.id), '[]'::jsonb),

    'applications', coalesce((
      select jsonb_agg(jsonb_build_object('id', ap.id, 'state', ap.state,
        'submitted_at', ap.submitted_at, 'reason', ap.reason) order by ap.submitted_at desc)
      from applications ap where ap.account_id = a.id), '[]'::jsonb),

    'notification_prefs', coalesce((
      select jsonb_agg(jsonb_build_object('topic', np.topic, 'sms', np.sms,
        'whatsapp', np.whatsapp, 'email', np.email, 'app', np.app))
      from notification_prefs np where np.account_id = a.id), '[]'::jsonb),

    'counts', jsonb_build_object(
      'products', (select count(*) from products p where p.supplier_id = a.id),
      'conversations', (select count(*) from conversations c
        where c.supplier_id = a.id or c.buyer_id = a.id),
      'messages', (select count(*) from messages m join conversations c on c.id = m.conversation_id
        where c.supplier_id = a.id or c.buyer_id = a.id),
      'documents', (select count(*) from documents d where d.account_id = a.id),
      'requirements', (select count(*) from requirements rq where rq.buyer_id = a.id),
      'quotes', (select count(*) from quotes q where q.supplier_id = a.id)),

    'history', coalesce((
      select jsonb_agg(jsonb_build_object('at', al.created_at, 'action', al.action,
        'entity', al.entity, 'entity_id', al.entity_id) order by al.created_at desc)
      from (select * from audit_log l
            where l.actor_id = a.id or l.entity_id = a.id
            order by l.created_at desc limit 40) al), '[]'::jsonb)
  )
  into v_result
  from accounts a
  where a.id = p_account;

  if v_result is null then raise exception 'No such account'; end if;
  return v_result;
end $$;

grant execute on function public.admin_member_detail(uuid) to authenticated;

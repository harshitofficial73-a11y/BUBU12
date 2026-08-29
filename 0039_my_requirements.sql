-- Manage requirements, part three: reading them back.
--
-- Separate file so a failure in one is obvious. Safe to re-run.

-- Every requirement the caller posted, with its allotted suppliers and their
-- contact details. The buyer posted it, so those numbers are theirs to see.
create or replace function public.my_requirements()
returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(jsonb_agg(t.x order by t.created_at desc), '[]'::jsonb)
  from (
    select r.created_at,
           jsonb_build_object(
      'id', r.id,
      'title', r.title,
      'quantity', r.quantity,
      'unit', r.quantity_unit,
      'specification', r.specification,
      'district', r.district_id,
      'deliver_to', r.deliver_to,
      'value', r.estimated_value,
      'state', r.state,
      'created_at', r.created_at,
      'category', (select c.name from categories c where c.id = r.category_id),
      'quote_count', (select count(*) from quotes q
                       where q.requirement_id = r.id and q.state <> 'draft'),
      'suppliers', coalesce((
        select jsonb_agg(jsonb_build_object(
          'match_id', m.id,
          'id', a.id,
          'rank', m.rank,
          'verdict', m.verdict,
          'company', a.company,
          'trade_name', a.trade_name,
          'business_type', a.business_type,
          'district', a.district_id,
          'address', a.address,
          'phone', a.phone,
          'whatsapp', coalesce(a.whatsapp_phone, a.phone),
          'email', a.email,
          'rating', a.rating,
          'rating_count', a.rating_count,
          'verified', (select reg.overall_state = 'verified'
                         from account_registration reg
                        where reg.account_id = a.id),
          'listings', (select count(*) from products p
                        where p.supplier_id = a.id and p.status = 'published'),
          'photo', (select md.storage_path
                      from media md
                      join products p2 on p2.id = md.product_id
                     where p2.supplier_id = a.id
                       and md.kind = 'product'
                       and md.approved
                     order by md.created_at
                     limit 1)
        ) order by m.rank)
        from requirement_matches m
        join accounts a on a.id = m.supplier_id
       where m.requirement_id = r.id
      ), '[]'::jsonb)
    ) as x
    from requirements r
   where r.buyer_id = current_account_id()
   order by r.created_at desc
   limit 60
  ) t;
$$;

grant execute on function public.my_requirements() to authenticated;

-- The buyer's Yes/No on one allotted supplier. An empty verdict clears it.
create or replace function public.rate_requirement_match(p_match uuid, p_verdict text)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  update requirement_matches m
     set verdict = case when p_verdict in ('yes', 'no') then p_verdict else null end
   where m.id = p_match
     and exists (select 1 from requirements r
                  where r.id = m.requirement_id
                    and r.buyer_id = current_account_id());
end;
$$;

grant execute on function public.rate_requirement_match(uuid, text) to authenticated;

-- Withdrawing a requirement stops new quotes without deleting the history.
-- 'withdrawn' is the state the schema has; there is no 'closed'.
create or replace function public.close_requirement(p_requirement uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  update requirements
     set state = 'withdrawn'
   where id = p_requirement
     and buyer_id = current_account_id();
end;
$$;

grant execute on function public.close_requirement(uuid) to authenticated;

-- PostgREST caches the list of functions; this makes the new ones visible at
-- once instead of after the next restart.
notify pgrst, 'reload schema';

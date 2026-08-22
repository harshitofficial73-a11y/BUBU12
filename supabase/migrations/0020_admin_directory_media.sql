-- Reliable admin directories that do not depend on PostgREST relationship inference.

create or replace function public.admin_member_directory()
returns jsonb language plpgsql security definer set search_path=public as $$
begin
  if not is_admin() then raise exception 'Admin account required'; end if;
  return coalesce((
    select jsonb_agg(jsonb_build_object(
      'id',a.id,'company',a.company,'trade_name',a.trade_name,'email',a.email,
      'phone',a.phone,'role',a.role,'business_type',a.business_type,'tier',a.tier,
      'district_id',a.district_id,'address',a.address,'created_at',a.created_at,
      'verification_state',coalesce(r.overall_state::text,'active'),
      'ursb_number',r.ursb_number,'tin',r.tin,
      'product_count',(select count(*) from products p where p.supplier_id=a.id)
    ) order by a.created_at desc)
    from accounts a left join account_registration r on r.account_id=a.id
  ),'[]'::jsonb);
end $$;

create or replace function public.admin_application_directory()
returns jsonb language plpgsql security definer set search_path=public as $$
begin
  if not is_admin() then raise exception 'Admin account required'; end if;
  return coalesce((
    select jsonb_agg(jsonb_build_object(
      'id',ap.id,'account_id',ap.account_id,'state',ap.state,
      'submitted_at',ap.submitted_at,'review_note',ap.reason,
      'account',jsonb_build_object(
        'id',a.id,'company',a.company,'trade_name',a.trade_name,'email',a.email,
        'phone',a.phone,'alt_phone',a.alt_phone,'whatsapp_phone',a.whatsapp_phone,
        'business_type',a.business_type,'district_id',a.district_id,'address',a.address,
        'about',a.about,'coverage',a.coverage,'nature_of_business',a.nature_of_business),
      'registration',case when r.account_id is null then '{}'::jsonb else jsonb_build_object(
        'ursb_number',r.ursb_number,'ursb_state',r.ursb_state,'tin',r.tin,
        'tin_state',r.tin_state,'trading_licence',r.trading_licence,
        'licence_authority',r.licence_authority,'licence_state',r.licence_state,
        'vat_number',r.vat_number,'director_nin',r.director_nin,
        'overall_state',r.overall_state) end,
      'categories',coalesce((select jsonb_agg(jsonb_build_object('id',c.id,'name',c.name))
        from account_categories ac join categories c on c.id=ac.category_id
        where ac.account_id=a.id),'[]'::jsonb),
      'documents',coalesce((select jsonb_agg(jsonb_build_object(
        'id',d.id,'kind',d.kind,'issuer',d.issuer,'reference',d.reference,
        'storage_path',d.storage_path,'created_at',d.created_at) order by d.created_at desc)
        from documents d where d.account_id=a.id),'[]'::jsonb)
    ) order by ap.submitted_at)
    from applications ap join accounts a on a.id=ap.account_id
    left join account_registration r on r.account_id=a.id
    where ap.state='pending'
  ),'[]'::jsonb);
end $$;

grant execute on function public.admin_member_directory() to authenticated;
grant execute on function public.admin_application_directory() to authenticated;

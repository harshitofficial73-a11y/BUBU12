-- Makes buyer profile creation repeatable and accepts either category IDs or names.
create or replace function create_buyer_profile(
  p_company text,p_phone text,p_email text,p_district_id text,p_buyer_type text default null,
  p_full_name text default null,p_category_ids text[] default '{}'
) returns accounts language plpgsql security definer set search_path=public as $$
declare v_account accounts; v_category text; v_category_id text;
begin
  if auth.uid() is null then raise exception 'sign in before creating a profile'; end if;
  if coalesce(trim(p_company),'')='' or coalesce(trim(p_phone),'')='' then raise exception 'name and phone are required'; end if;

  select * into v_account from accounts where auth_user_id=auth.uid();
  if found and v_account.role <> 'buyer' then
    raise exception 'This login already belongs to a % account. Sign out before creating a buyer profile.', v_account.role;
  end if;

  insert into accounts(auth_user_id,role,company,trade_name,initials,phone,email,district_id,nature_of_business)
  values(auth.uid(),'buyer',trim(p_company),trim(p_company),upper(left(trim(p_company),2)),trim(p_phone),
    nullif(trim(p_email),''),nullif(trim(p_district_id),''),nullif(trim(p_buyer_type),''))
  on conflict(auth_user_id) do update set company=excluded.company,trade_name=excluded.trade_name,
    phone=excluded.phone,email=excluded.email,district_id=excluded.district_id,
    nature_of_business=excluded.nature_of_business,updated_at=now() returning * into v_account;

  update account_users set account_id=v_account.id,
    full_name=coalesce(nullif(trim(p_full_name),''),trim(p_company)),role_title=coalesce(p_buyer_type,'Buyer')
  where auth_user_id=auth.uid();
  if not found then
    insert into account_users(account_id,auth_user_id,full_name,role_title)
    values(v_account.id,auth.uid(),coalesce(nullif(trim(p_full_name),''),trim(p_company)),coalesce(p_buyer_type,'Buyer'));
  end if;

  delete from account_categories where account_id=v_account.id;
  foreach v_category in array coalesce(p_category_ids,'{}') loop
    select id into v_category_id from categories
    where id=v_category or lower(name)=lower(v_category) order by (id=v_category) desc limit 1;
    if v_category_id is not null then
      insert into account_categories(account_id,category_id) values(v_account.id,v_category_id) on conflict do nothing;
    end if;
    v_category_id:=null;
  end loop;
  return v_account;
end $$;

grant execute on function create_buyer_profile(text,text,text,text,text,text,text[]) to authenticated;

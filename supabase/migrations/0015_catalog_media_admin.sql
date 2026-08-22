-- Product attachments, controlled custom taxonomy and Admin catalogue reporting.
update storage.buckets
set file_size_limit = 52428800,
    allowed_mime_types = array[
      'image/jpeg','image/png','image/webp','application/pdf',
      'video/mp4','video/webm','video/quicktime'
    ]
where id = 'media';

create or replace function create_catalog_category(p_name text, p_parent_id text default null)
returns categories
language plpgsql security definer set search_path=public as $$
declare
  v_name text := trim(p_name);
  v_id text;
  v_row categories;
begin
  if current_role_name() not in ('supplier','admin') then
    raise exception 'supplier or admin account required';
  end if;
  if v_name = '' then raise exception 'category name is required'; end if;
  if p_parent_id is not null and not exists(select 1 from categories where id=p_parent_id and parent_id is null) then
    raise exception 'valid top-level parent category required';
  end if;
  select * into v_row from categories
   where lower(name)=lower(v_name) and parent_id is not distinct from p_parent_id limit 1;
  if found then return v_row; end if;
  v_id := regexp_replace(lower(v_name), '[^a-z0-9]+', '-', 'g');
  v_id := trim(both '-' from v_id);
  if v_id='' then v_id := 'category'; end if;
  if exists(select 1 from categories where id=v_id) then
    v_id := v_id || '-' || substr(md5(coalesce(p_parent_id,'root') || v_name),1,6);
  end if;
  insert into categories(id,name,parent_id,sort)
  values(v_id,v_name,p_parent_id,(select coalesce(max(sort),0)+1 from categories))
  returning * into v_row;
  return v_row;
end $$;
grant execute on function create_catalog_category(text,text) to authenticated;

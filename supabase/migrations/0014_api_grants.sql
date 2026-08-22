-- Restore API privileges after recreating the public schema.
grant usage on schema public to anon, authenticated;
grant select on all tables in schema public to anon;
grant select, insert, update, delete on all tables in schema public to authenticated;
grant usage, select on all sequences in schema public to authenticated;
grant execute on all functions in schema public to authenticated;
alter default privileges for role postgres in schema public grant select on tables to anon;
alter default privileges for role postgres in schema public grant select, insert, update, delete on tables to authenticated;
alter default privileges for role postgres in schema public grant usage, select on sequences to authenticated;
alter default privileges for role postgres in schema public grant execute on functions to authenticated;

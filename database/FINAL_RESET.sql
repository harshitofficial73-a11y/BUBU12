-- BUBU.Market DATABASE RESET
-- WARNING: THIS PERMANENTLY DELETES ALL BUBU APP DATA AND AUTH USERS.
-- Empty/delete the media bucket through Supabase Storage before running this.
-- Run only when you intentionally want a completely clean project.

begin;

-- Remove authentication identities first so account links cascade cleanly.
delete from auth.users;

-- Remove every application table, policy, trigger and function.
drop schema if exists public cascade;
create schema public;

grant usage on schema public to postgres, anon, authenticated, service_role;
grant all on schema public to postgres, service_role;
alter default privileges in schema public grant all on tables to postgres, service_role;
alter default privileges in schema public grant all on functions to postgres, service_role;
alter default privileges in schema public grant all on sequences to postgres, service_role;

commit;

-- NEXT: run FINAL_REBUILD.sql, configure Auth, then create the first admin.

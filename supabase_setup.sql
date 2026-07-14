-- Version 1.8.0: zentrale Verwaltung, öffentliche Turnierliste und Sichtbarkeit
create extension if not exists pgcrypto;

create table if not exists public.tournaments (
  code text primary key,
  name text not null default 'Volleyballturnier',
  data jsonb not null default '{}'::jsonb,
  password_hash text,
  is_public boolean not null default true,
  updated_at timestamptz not null default now()
);
alter table public.tournaments add column if not exists name text not null default 'Volleyballturnier';
alter table public.tournaments add column if not exists is_public boolean not null default true;

create table if not exists public.app_settings (
  id integer primary key default 1 check (id=1),
  admin_password_hash text,
  updated_at timestamptz not null default now()
);
insert into public.app_settings(id) values (1) on conflict (id) do nothing;

alter table public.tournaments enable row level security;
alter table public.app_settings enable row level security;
revoke all on public.tournaments from anon, authenticated;
revoke all on public.app_settings from anon, authenticated;

-- Alte Funktionssignaturen entfernen, damit geänderte Rückgabetypen sauber angelegt werden.
drop function if exists public.list_tournaments();
drop function if exists public.list_all_tournaments(text);
drop function if exists public.load_tournament(text);
drop function if exists public.load_tournament_admin(text,text);
drop function if exists public.admin_login(text);
drop function if exists public.change_admin_password(text,text);
drop function if exists public.create_tournament(text,text,text,jsonb);
drop function if exists public.create_tournament(text,text,text,jsonb,boolean);
drop function if exists public.save_tournament(text,text,text,jsonb);
drop function if exists public.save_tournament(text,text,text,jsonb,boolean);
drop function if exists public.delete_tournament(text,text);

create or replace function public.check_admin_password(p_password text)
returns boolean language plpgsql security definer set search_path=public,extensions as $$
declare h text;
begin
 select admin_password_hash into h from public.app_settings where id=1;
 return h is not null and crypt(coalesce(p_password,''),h)=h;
end;$$;

-- Beim allerersten Login wird das erste Passwort eingerichtet.
create or replace function public.admin_login(p_password text)
returns boolean language plpgsql security definer set search_path=public,extensions as $$
declare h text;
begin
 if length(coalesce(p_password,''))<6 then raise exception 'Das Passwort muss mindestens 6 Zeichen haben.'; end if;
 select admin_password_hash into h from public.app_settings where id=1 for update;
 if h is null then
   update public.app_settings set admin_password_hash=crypt(p_password,gen_salt('bf')),updated_at=now() where id=1;
   return true;
 end if;
 return crypt(p_password,h)=h;
end;$$;

create or replace function public.change_admin_password(p_old_password text,p_new_password text)
returns void language plpgsql security definer set search_path=public,extensions as $$
begin
 if not public.check_admin_password(p_old_password) then raise exception 'Das bisherige Passwort ist falsch.'; end if;
 if length(coalesce(p_new_password,''))<6 then raise exception 'Das neue Passwort muss mindestens 6 Zeichen haben.'; end if;
 update public.app_settings set admin_password_hash=crypt(p_new_password,gen_salt('bf')),updated_at=now() where id=1;
end;$$;

-- Öffentlich sichtbar sind nur ausdrücklich freigegebene Turniere.
create or replace function public.list_tournaments()
returns table(code text,name text,event_date date,updated_at timestamptz)
language sql security definer set search_path=public as $$
 select t.code,t.name,case when coalesce(t.data->>'date','') ~ '^\d{4}-\d{2}-\d{2}$' then (t.data->>'date')::date else null end,t.updated_at
 from public.tournaments t where t.is_public=true
 order by 3 desc nulls last,t.name;
$$;

create or replace function public.list_all_tournaments(p_admin_password text)
returns table(code text,name text,event_date date,is_public boolean,updated_at timestamptz)
language plpgsql security definer set search_path=public as $$
begin
 if not public.check_admin_password(p_admin_password) then raise exception 'Falsches Passwort.'; end if;
 return query select t.code,t.name,case when coalesce(t.data->>'date','') ~ '^\d{4}-\d{2}-\d{2}$' then (t.data->>'date')::date else null end,t.is_public,t.updated_at from public.tournaments t order by 3 desc nulls last,t.name;
end;$$;

create or replace function public.load_tournament(p_code text)
returns table(code text,name text,data jsonb,is_public boolean,updated_at timestamptz)
language sql security definer set search_path=public as $$
 select t.code,t.name,t.data,t.is_public,t.updated_at from public.tournaments t where t.code=upper(trim(p_code)) and t.is_public=true;
$$;

create or replace function public.load_tournament_admin(p_code text,p_admin_password text)
returns table(code text,name text,data jsonb,is_public boolean,updated_at timestamptz)
language plpgsql security definer set search_path=public as $$
begin
 if not public.check_admin_password(p_admin_password) then raise exception 'Falsches Passwort.'; end if;
 return query select t.code,t.name,t.data,t.is_public,t.updated_at from public.tournaments t where t.code=upper(trim(p_code));
end;$$;

create or replace function public.create_tournament(p_code text,p_name text,p_admin_password text,p_data jsonb,p_public boolean)
returns void language plpgsql security definer set search_path=public as $$
declare v_code text:=upper(trim(p_code));
begin
 if not public.check_admin_password(p_admin_password) then raise exception 'Falsches Passwort.'; end if;
 if v_code !~ '^[A-Z0-9_-]{3,40}$' then raise exception 'Der Turniercode muss 3 bis 40 Zeichen lang sein.'; end if;
 if exists(select 1 from public.tournaments where code=v_code) then raise exception 'Dieser Turniercode ist bereits vergeben.'; end if;
 insert into public.tournaments(code,name,data,is_public,updated_at) values(v_code,coalesce(nullif(trim(p_name),''),'Volleyballturnier'),coalesce(p_data,'{}'::jsonb),coalesce(p_public,true),now());
end;$$;

create or replace function public.save_tournament(p_code text,p_admin_password text,p_name text,p_data jsonb,p_public boolean)
returns void language plpgsql security definer set search_path=public as $$
begin
 if not public.check_admin_password(p_admin_password) then raise exception 'Falsches Passwort.'; end if;
 update public.tournaments set name=coalesce(nullif(trim(p_name),''),name),data=coalesce(p_data,data),is_public=coalesce(p_public,is_public),updated_at=now() where code=upper(trim(p_code));
 if not found then raise exception 'Turnier nicht gefunden.'; end if;
end;$$;

create or replace function public.delete_tournament(p_code text,p_admin_password text)
returns void language plpgsql security definer set search_path=public as $$
begin
 if not public.check_admin_password(p_admin_password) then raise exception 'Falsches Passwort.'; end if;
 delete from public.tournaments where code=upper(trim(p_code));
 if not found then raise exception 'Turnier nicht gefunden.'; end if;
end;$$;

grant execute on function public.list_tournaments() to anon,authenticated;
grant execute on function public.load_tournament(text) to anon,authenticated;
grant execute on function public.admin_login(text) to anon,authenticated;
grant execute on function public.list_all_tournaments(text) to anon,authenticated;
grant execute on function public.load_tournament_admin(text,text) to anon,authenticated;
grant execute on function public.create_tournament(text,text,text,jsonb,boolean) to anon,authenticated;
grant execute on function public.save_tournament(text,text,text,jsonb,boolean) to anon,authenticated;
grant execute on function public.delete_tournament(text,text) to anon,authenticated;
grant execute on function public.change_admin_password(text,text) to anon,authenticated;

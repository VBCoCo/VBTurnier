-- Version 1.5.0: Turnierauswahl mit Turniername und tatsächlichem Turnierdatum
-- Im Supabase SQL Editor vollstaendig ausfuehren.

create extension if not exists pgcrypto;

create table if not exists public.tournaments (
  code text primary key,
  name text not null default 'Volleyballturnier',
  data jsonb not null default '{}'::jsonb,
  password_hash text,
  updated_at timestamptz not null default now()
);

-- Migration einer aelteren Tabelle
alter table public.tournaments add column if not exists name text not null default 'Volleyballturnier';
alter table public.tournaments add column if not exists password_hash text;

alter table public.tournaments enable row level security;

-- Direkte Tabellenzugriffe fuer die anonyme Webseite sperren.
drop policy if exists "turniere lesen" on public.tournaments;
drop policy if exists "turniere anlegen" on public.tournaments;
drop policy if exists "turniere aendern" on public.tournaments;
revoke all on public.tournaments from anon, authenticated;

-- Nur oeffentliche Metadaten fuer das Auswahlmenue.
create or replace function public.list_tournaments()
returns table(code text, name text, event_date date, updated_at timestamptz)
language sql
security definer
set search_path = public
as $$
  select
    t.code,
    t.name,
    case
      when coalesce(t.data->>'date', '') ~ '^\d{4}-\d{2}-\d{2}$'
      then (t.data->>'date')::date
      else null
    end as event_date,
    t.updated_at
  from public.tournaments t
  order by event_date desc nulls last, t.name asc;
$$;

-- Turnierstand darf ohne Passwort gelesen werden.
create or replace function public.load_tournament(p_code text)
returns table(code text, name text, data jsonb, updated_at timestamptz)
language sql
security definer
set search_path = public
as $$
  select t.code, t.name, t.data, t.updated_at
  from public.tournaments t
  where t.code = upper(trim(p_code));
$$;

-- Neues Turnier immer mit Passwort anlegen.
create or replace function public.create_tournament(
  p_code text,
  p_name text,
  p_password text,
  p_data jsonb
)
returns void
language plpgsql
security definer
set search_path = public, extensions
as $$
declare
  v_code text := upper(trim(p_code));
begin
  if v_code !~ '^[A-Z0-9_-]{3,40}$' then
    raise exception 'Der Turniercode muss 3 bis 40 Zeichen lang sein.';
  end if;
  if length(coalesce(p_password, '')) < 6 then
    raise exception 'Das Passwort muss mindestens 6 Zeichen haben.';
  end if;
  if exists(select 1 from public.tournaments where code = v_code) then
    raise exception 'Dieser Turniercode ist bereits vergeben.';
  end if;

  insert into public.tournaments(code, name, data, password_hash, updated_at)
  values (
    v_code,
    coalesce(nullif(trim(p_name), ''), 'Volleyballturnier'),
    coalesce(p_data, '{}'::jsonb),
    crypt(p_password, gen_salt('bf')),
    now()
  );
end;
$$;

-- Aenderungen nur mit korrektem Passwort.
-- Bestehende Alt-Turniere ohne Passwort werden beim ersten Speichern beansprucht.
create or replace function public.save_tournament(
  p_code text,
  p_password text,
  p_name text,
  p_data jsonb
)
returns void
language plpgsql
security definer
set search_path = public, extensions
as $$
declare
  v_code text := upper(trim(p_code));
  v_hash text;
begin
  select password_hash into v_hash
  from public.tournaments
  where code = v_code
  for update;

  if not found then
    raise exception 'Turnier nicht gefunden.';
  end if;
  if length(coalesce(p_password, '')) < 6 then
    raise exception 'Passwort fehlt oder ist zu kurz.';
  end if;

  if v_hash is null then
    update public.tournaments
       set password_hash = crypt(p_password, gen_salt('bf')),
           name = coalesce(nullif(trim(p_name), ''), name),
           data = coalesce(p_data, data),
           updated_at = now()
     where code = v_code;
  elsif crypt(p_password, v_hash) = v_hash then
    update public.tournaments
       set name = coalesce(nullif(trim(p_name), ''), name),
           data = coalesce(p_data, data),
           updated_at = now()
     where code = v_code;
  else
    raise exception 'Falsches Passwort.';
  end if;
end;
$$;

grant execute on function public.list_tournaments() to anon, authenticated;
grant execute on function public.load_tournament(text) to anon, authenticated;
grant execute on function public.create_tournament(text,text,text,jsonb) to anon, authenticated;
grant execute on function public.save_tournament(text,text,text,jsonb) to anon, authenticated;

-- Im Supabase SQL Editor einmal ausfuehren.
create table if not exists public.tournaments (
  code text primary key,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.tournaments enable row level security;

-- Fuer ein vereinsinternes Turnier mit schwer erratbarem Turniercode.
-- Jeder mit Code und Webseitenzugang kann diesen Datensatz lesen/aendern.
drop policy if exists "turniere lesen" on public.tournaments;
create policy "turniere lesen" on public.tournaments
for select to anon using (true);

drop policy if exists "turniere anlegen" on public.tournaments;
create policy "turniere anlegen" on public.tournaments
for insert to anon with check (true);

drop policy if exists "turniere aendern" on public.tournaments;
create policy "turniere aendern" on public.tournaments
for update to anon using (true) with check (true);

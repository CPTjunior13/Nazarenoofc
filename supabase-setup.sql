-- Cole tudo no Supabase: SQL Editor > New query > Run (pode rodar mais de uma vez)

create table if not exists public.songs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  name text not null,
  yt text,
  audio_path text not null,
  bg_path text,
  ord int not null default 0,
  created_at timestamptz default now()
);
alter table public.songs enable row level security;
drop policy if exists "songs do dono" on public.songs;
create policy "songs do dono" on public.songs for all
  using (auth.uid() = user_id) with check (auth.uid() = user_id);

create table if not exists public.app_settings (
  user_id uuid primary key default auth.uid() references auth.users(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz default now()
);
alter table public.app_settings enable row level security;
drop policy if exists "config do dono" on public.app_settings;
create policy "config do dono" on public.app_settings for all
  using (auth.uid() = user_id) with check (auth.uid() = user_id);

insert into storage.buckets (id, name, public, file_size_limit)
values ('musicas', 'musicas', false, 52428800) on conflict (id) do nothing;

drop policy if exists "arquivos: ler" on storage.objects;
drop policy if exists "arquivos: enviar" on storage.objects;
drop policy if exists "arquivos: atualizar" on storage.objects;
drop policy if exists "arquivos: apagar" on storage.objects;
create policy "arquivos: ler" on storage.objects for select
  using (bucket_id = 'musicas' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "arquivos: enviar" on storage.objects for insert
  with check (bucket_id = 'musicas' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "arquivos: atualizar" on storage.objects for update
  using (bucket_id = 'musicas' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "arquivos: apagar" on storage.objects for delete
  using (bucket_id = 'musicas' and (storage.foldername(name))[1] = auth.uid()::text);

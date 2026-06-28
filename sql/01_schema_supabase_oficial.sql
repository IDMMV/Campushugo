-- CampusHugo Pro Oficial - SQL único inicial
-- Ejecutar en Supabase SQL Editor.

create extension if not exists pgcrypto;

-- 1) Perfiles y roles
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text unique,
  full_name text,
  role text not null default 'alumno' check (role in ('alumno','admin','instructor')),
  is_premium boolean not null default false,
  created_at timestamptz default now()
);

alter table public.profiles enable row level security;

drop policy if exists "profiles_select_own" on public.profiles;
create policy "profiles_select_own" on public.profiles for select using (auth.uid() = id or exists(select 1 from public.profiles p where p.id=auth.uid() and p.role='admin'));

drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_update_own" on public.profiles for update using (auth.uid() = id or exists(select 1 from public.profiles p where p.id=auth.uid() and p.role='admin'));

create or replace function public.handle_new_user()
returns trigger language plpgsql security definer as $$
begin
  insert into public.profiles (id,email,full_name)
  values (new.id,new.email,coalesce(new.raw_user_meta_data->>'full_name',''))
  on conflict (id) do nothing;
  return new;
end; $$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users for each row execute function public.handle_new_user();

-- 2) Cursos
create table if not exists public.courses (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  slug text unique,
  description text,
  category text,
  level text,
  access text default 'free' check (access in ('free','premium')),
  price numeric(10,2) default 0,
  cover_url text,
  is_published boolean default true,
  created_by uuid references public.profiles(id),
  created_at timestamptz default now()
);

alter table public.courses enable row level security;
create policy "courses_public_select" on public.courses for select using (is_published = true or exists(select 1 from public.profiles p where p.id=auth.uid() and p.role in ('admin','instructor')));
create policy "courses_admin_all" on public.courses for all using (exists(select 1 from public.profiles p where p.id=auth.uid() and p.role in ('admin','instructor'))) with check (exists(select 1 from public.profiles p where p.id=auth.uid() and p.role in ('admin','instructor')));

-- 3) Lecciones interactivas y bloques tipo Prezi
create table if not exists public.lessons (
  id uuid primary key default gen_random_uuid(),
  course_id uuid references public.courses(id) on delete cascade,
  title text not null,
  position int default 1,
  access text default 'free' check (access in ('free','premium')),
  is_published boolean default true,
  created_at timestamptz default now()
);

create table if not exists public.lesson_blocks (
  id uuid primary key default gen_random_uuid(),
  lesson_id uuid references public.lessons(id) on delete cascade,
  block_type text not null check (block_type in ('video','image','text','practice','quiz','download','sql','excel','powerbi','ia')),
  title text,
  content jsonb default '{}'::jsonb,
  position int default 1,
  created_at timestamptz default now()
);

alter table public.lessons enable row level security;
alter table public.lesson_blocks enable row level security;
create policy "lessons_public_select" on public.lessons for select using (is_published=true or exists(select 1 from public.profiles p where p.id=auth.uid() and p.role in ('admin','instructor')));
create policy "lesson_blocks_select" on public.lesson_blocks for select using (exists(select 1 from public.lessons l where l.id=lesson_id and l.is_published=true) or exists(select 1 from public.profiles p where p.id=auth.uid() and p.role in ('admin','instructor')));
create policy "lessons_admin_all" on public.lessons for all using (exists(select 1 from public.profiles p where p.id=auth.uid() and p.role in ('admin','instructor'))) with check (exists(select 1 from public.profiles p where p.id=auth.uid() and p.role in ('admin','instructor')));
create policy "blocks_admin_all" on public.lesson_blocks for all using (exists(select 1 from public.profiles p where p.id=auth.uid() and p.role in ('admin','instructor'))) with check (exists(select 1 from public.profiles p where p.id=auth.uid() and p.role in ('admin','instructor')));

-- 4) Recursos descargables
create table if not exists public.resources (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  category text,
  access text default 'free' check (access in ('free','premium')),
  price numeric(10,2) default 0,
  description text,
  file_url text,
  cover_url text,
  is_active boolean default true,
  created_at timestamptz default now()
);

alter table public.resources enable row level security;
create policy "resources_select_active" on public.resources for select using (is_active=true or exists(select 1 from public.profiles p where p.id=auth.uid() and p.role='admin'));
create policy "resources_admin_all" on public.resources for all using (exists(select 1 from public.profiles p where p.id=auth.uid() and p.role='admin')) with check (exists(select 1 from public.profiles p where p.id=auth.uid() and p.role='admin'));

-- 5) Suscripciones, ventas, descargas, progreso
create table if not exists public.subscriptions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.profiles(id) on delete cascade,
  plan text not null,
  status text default 'active' check (status in ('active','expired','cancelled','pending')),
  starts_at timestamptz default now(),
  ends_at timestamptz,
  amount numeric(10,2) default 0,
  created_at timestamptz default now()
);

create table if not exists public.sales (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.profiles(id),
  course_id uuid references public.courses(id),
  resource_id uuid references public.resources(id),
  amount numeric(10,2) not null default 0,
  payment_method text default 'manual',
  status text default 'pending' check (status in ('pending','paid','rejected','refunded')),
  created_at timestamptz default now()
);

create table if not exists public.downloads (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.profiles(id),
  resource_id uuid references public.resources(id),
  created_at timestamptz default now()
);

create table if not exists public.progress (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.profiles(id) on delete cascade,
  lesson_id uuid references public.lessons(id) on delete cascade,
  xp int default 0,
  completed boolean default false,
  updated_at timestamptz default now(),
  unique(user_id, lesson_id)
);

alter table public.subscriptions enable row level security;
alter table public.sales enable row level security;
alter table public.downloads enable row level security;
alter table public.progress enable row level security;
create policy "admin_subscriptions" on public.subscriptions for all using (exists(select 1 from public.profiles p where p.id=auth.uid() and p.role='admin')) with check (exists(select 1 from public.profiles p where p.id=auth.uid() and p.role='admin'));
create policy "admin_sales" on public.sales for all using (exists(select 1 from public.profiles p where p.id=auth.uid() and p.role='admin')) with check (exists(select 1 from public.profiles p where p.id=auth.uid() and p.role='admin'));
create policy "downloads_own_or_admin" on public.downloads for all using (auth.uid()=user_id or exists(select 1 from public.profiles p where p.id=auth.uid() and p.role='admin')) with check (auth.uid()=user_id or exists(select 1 from public.profiles p where p.id=auth.uid() and p.role='admin'));
create policy "progress_own_or_admin" on public.progress for all using (auth.uid()=user_id or exists(select 1 from public.profiles p where p.id=auth.uid() and p.role='admin')) with check (auth.uid()=user_id or exists(select 1 from public.profiles p where p.id=auth.uid() and p.role='admin'));

-- 6) Dashboard
create or replace view public.vw_dashboard_admin as
select
  (select count(*) from public.profiles) as total_usuarios,
  (select count(*) from public.subscriptions where status='active') as suscripciones_activas,
  (select coalesce(sum(amount),0) from public.sales where status='paid') as ventas_pagadas,
  (select count(*) from public.downloads) as total_descargas;

create or replace view public.vw_resource_stats as
select r.id,r.title,r.category,r.access,r.price,
  count(d.id) as descargas,
  coalesce(sum(s.amount) filter (where s.status='paid'),0) as ingresos
from public.resources r
left join public.downloads d on d.resource_id=r.id
left join public.sales s on s.resource_id=r.id
group by r.id;

-- 7) Storage bucket para archivos
insert into storage.buckets (id, name, public)
values ('recursos','recursos',true)
on conflict (id) do nothing;

-- Políticas storage: lectura pública; escritura solo admin/instructor
create policy "storage_recursos_read" on storage.objects for select using (bucket_id='recursos');
create policy "storage_recursos_admin_insert" on storage.objects for insert with check (bucket_id='recursos' and exists(select 1 from public.profiles p where p.id=auth.uid() and p.role in ('admin','instructor')));
create policy "storage_recursos_admin_update" on storage.objects for update using (bucket_id='recursos' and exists(select 1 from public.profiles p where p.id=auth.uid() and p.role in ('admin','instructor')));
create policy "storage_recursos_admin_delete" on storage.objects for delete using (bucket_id='recursos' and exists(select 1 from public.profiles p where p.id=auth.uid() and p.role in ('admin','instructor')));

-- 8) Datos iniciales
insert into public.courses(title,slug,description,category,level,access,price,is_published)
values
('Excel Básico Interactivo','excel-basico','Aprende Excel tocando, viendo y practicando.','Excel','Básico','free',0,true),
('Power BI desde cero','power-bi-basico','Crea dashboards con práctica guiada.','Power BI','Básico','premium',29,true),
('SQL para reportes','sql-reportes','Consultas SQL aplicadas al trabajo.','SQL','Básico','free',0,true),
('IA para oficina','ia-oficina','Prompts y automatización para productividad.','IA','Intermedio','premium',29,true)
on conflict (slug) do nothing;

-- Para convertirte en admin después de registrarte:
-- update public.profiles set role='admin' where email='TU_CORREO';

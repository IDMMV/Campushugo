-- CampusHugo Pro - Fase 1: estructura base Supabase
create table if not exists profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  role text default 'student' check (role in ('student','admin','instructor')),
  is_premium boolean default false,
  created_at timestamptz default now()
);
create table if not exists courses (
  id bigint generated always as identity primary key,
  title text not null,
  slug text unique not null,
  description text,
  level text default 'basico',
  category text,
  is_premium boolean default false,
  is_published boolean default true,
  created_at timestamptz default now()
);
create table if not exists templates (
  id bigint generated always as identity primary key,
  title text not null,
  description text,
  category text,
  price numeric(10,2) default 0,
  file_url text,
  is_published boolean default true,
  created_at timestamptz default now()
);
create table if not exists leads (
  id bigint generated always as identity primary key,
  name text,
  email text,
  phone text,
  interest text,
  message text,
  created_at timestamptz default now()
);
alter table profiles enable row level security;
alter table courses enable row level security;
alter table templates enable row level security;
alter table leads enable row level security;
create policy if not exists "Cursos visibles" on courses for select using (is_published = true);
create policy if not exists "Plantillas visibles" on templates for select using (is_published = true);
create policy if not exists "Registrar interesados" on leads for insert with check (true);
insert into courses (title,slug,description,category,is_premium) values
('Excel Básico','excel-basico','Aprende Excel desde cero.','Excel',false),
('Power BI Básico','power-bi-basico','Crea tus primeros dashboards.','Power BI',false),
('SQL Server Básico','sql-server-basico','Consultas y análisis de datos.','SQL',false),
('IA para oficina','ia-para-oficina','Productividad con IA aplicada.','IA',true)
on conflict (slug) do nothing;

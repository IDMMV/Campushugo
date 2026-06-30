-- CampusHugo Motor Interactivo - base Supabase
create table if not exists profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text unique,
  role text default 'alumno' check (role in ('alumno','admin','instructor')),
  full_name text,
  created_at timestamptz default now()
);
create table if not exists courses (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text,
  category text,
  level text,
  is_premium boolean default false,
  price numeric default 0,
  created_at timestamptz default now()
);
create table if not exists lessons (
  id uuid primary key default gen_random_uuid(),
  course_id uuid references courses(id) on delete cascade,
  title text not null,
  sort_order int default 0,
  xp int default 100,
  is_premium boolean default false,
  created_at timestamptz default now()
);
create table if not exists lesson_blocks (
  id uuid primary key default gen_random_uuid(),
  lesson_id uuid references lessons(id) on delete cascade,
  block_type text not null,
  sort_order int default 0,
  content jsonb not null default '{}'::jsonb,
  created_at timestamptz default now()
);
create table if not exists progress (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade,
  lesson_id uuid references lessons(id) on delete cascade,
  completed boolean default false,
  xp_earned int default 0,
  updated_at timestamptz default now(),
  unique(user_id, lesson_id)
);
alter table profiles enable row level security;
alter table courses enable row level security;
alter table lessons enable row level security;
alter table lesson_blocks enable row level security;
alter table progress enable row level security;
create policy if not exists "public courses" on courses for select using (true);
create policy if not exists "public lessons" on lessons for select using (true);
create policy if not exists "public lesson blocks" on lesson_blocks for select using (true);
create policy if not exists "own progress" on progress for select using (auth.uid()=user_id);
create policy if not exists "save own progress" on progress for insert with check (auth.uid()=user_id);
create policy if not exists "update own progress" on progress for update using (auth.uid()=user_id);

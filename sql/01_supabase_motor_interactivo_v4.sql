-- CampusHugo Motor Interactivo v4 - base Supabase
create table if not exists profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text unique,
  full_name text,
  role text default 'alumno' check (role in ('alumno','admin','instructor')),
  xp integer default 0,
  created_at timestamptz default now()
);
create table if not exists courses (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  slug text unique not null,
  category text not null,
  level text,
  is_premium boolean default false,
  price numeric default 0,
  published boolean default false,
  created_by uuid references profiles(id),
  created_at timestamptz default now()
);
create table if not exists lessons (
  id uuid primary key default gen_random_uuid(),
  course_id uuid references courses(id) on delete cascade,
  code text unique,
  title text not null,
  level text,
  objective text,
  scenario text,
  order_index integer default 0,
  xp integer default 50,
  published boolean default false,
  created_at timestamptz default now()
);
create table if not exists lesson_blocks (
  id uuid primary key default gen_random_uuid(),
  lesson_id uuid references lessons(id) on delete cascade,
  block_type text not null,
  content jsonb not null default '{}',
  order_index integer default 0
);
create table if not exists user_progress (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references profiles(id) on delete cascade,
  lesson_id uuid references lessons(id) on delete cascade,
  status text default 'started',
  score numeric default 0,
  xp_earned integer default 0,
  completed_at timestamptz,
  unique(user_id, lesson_id)
);
create table if not exists resources (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  category text,
  file_path text,
  price numeric default 0,
  is_premium boolean default false,
  downloads integer default 0,
  created_at timestamptz default now()
);
alter table profiles enable row level security;
alter table courses enable row level security;
alter table lessons enable row level security;
alter table lesson_blocks enable row level security;
alter table user_progress enable row level security;
alter table resources enable row level security;
create policy if not exists "Public read published courses" on courses for select using (published = true or auth.uid() = created_by);
create policy if not exists "Public read published lessons" on lessons for select using (published = true);
create policy if not exists "Public read blocks" on lesson_blocks for select using (true);
create policy if not exists "Own progress" on user_progress for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy if not exists "Own profile" on profiles for select using (auth.uid() = id);
create policy if not exists "Public resources" on resources for select using (true);

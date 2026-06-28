-- CAMPUSHUGO PRO - SQL FINAL INICIAL PARA SUPABASE
-- Ejecuta todo en Supabase SQL Editor.

create extension if not exists pgcrypto;

create table if not exists public.perfiles (
  id uuid primary key references auth.users(id) on delete cascade,
  nombre text,
  rol text default 'estudiante' check (rol in ('estudiante','admin','instructor')),
  plan text default 'gratis' check (plan in ('gratis','pro','empresa')),
  telefono text,
  avatar_url text,
  creado_en timestamptz default now(),
  actualizado_en timestamptz default now()
);

create table if not exists public.cursos (
  id uuid primary key default gen_random_uuid(),
  titulo text not null,
  categoria text not null,
  nivel text default 'Basico',
  descripcion text,
  duracion text,
  tipo text default 'gratis' check (tipo in ('gratis','pro')),
  portada text,
  activo boolean default true,
  orden int default 0,
  creado_en timestamptz default now()
);

create table if not exists public.lecciones (
  id uuid primary key default gen_random_uuid(),
  curso_id uuid references public.cursos(id) on delete cascade,
  titulo text not null,
  contenido text,
  video_url text,
  archivo_url text,
  orden int default 0,
  activo boolean default true,
  creado_en timestamptz default now()
);

create table if not exists public.plantillas (
  id uuid primary key default gen_random_uuid(),
  titulo text not null,
  categoria text not null,
  descripcion text,
  precio numeric(10,2) default 0,
  moneda text default 'USD',
  archivo_url text,
  portada text,
  activo boolean default true,
  descargas int default 0,
  creado_en timestamptz default now()
);

create table if not exists public.herramientas (
  id uuid primary key default gen_random_uuid(),
  titulo text not null,
  descripcion text,
  tipo text default 'demo',
  activo boolean default true,
  creado_en timestamptz default now()
);

create table if not exists public.progreso (
  id uuid primary key default gen_random_uuid(),
  usuario_id uuid references auth.users(id) on delete cascade,
  curso_id uuid references public.cursos(id) on delete cascade,
  leccion_id uuid references public.lecciones(id) on delete cascade,
  completado boolean default false,
  porcentaje int default 0,
  actualizado_en timestamptz default now(),
  unique(usuario_id, curso_id, leccion_id)
);

create table if not exists public.compras (
  id uuid primary key default gen_random_uuid(),
  usuario_id uuid references auth.users(id) on delete set null,
  producto_tipo text check (producto_tipo in ('curso','plantilla','plan')),
  producto_id uuid,
  monto numeric(10,2),
  moneda text default 'USD',
  estado text default 'pendiente' check (estado in ('pendiente','pagado','cancelado')),
  metodo text default 'whatsapp',
  creado_en timestamptz default now()
);

create table if not exists public.contactos (
  id uuid primary key default gen_random_uuid(),
  nombre text,
  email text,
  telefono text,
  mensaje text,
  estado text default 'nuevo',
  creado_en timestamptz default now()
);

alter table public.perfiles enable row level security;
alter table public.cursos enable row level security;
alter table public.lecciones enable row level security;
alter table public.plantillas enable row level security;
alter table public.herramientas enable row level security;
alter table public.progreso enable row level security;
alter table public.compras enable row level security;
alter table public.contactos enable row level security;

-- Lectura pública de contenido activo
create policy if not exists "Ver cursos activos" on public.cursos for select using (activo = true);
create policy if not exists "Ver lecciones activas" on public.lecciones for select using (activo = true);
create policy if not exists "Ver plantillas activas" on public.plantillas for select using (activo = true);
create policy if not exists "Ver herramientas activas" on public.herramientas for select using (activo = true);

-- Perfil propio
create policy if not exists "Ver mi perfil" on public.perfiles for select using (auth.uid() = id);
create policy if not exists "Actualizar mi perfil" on public.perfiles for update using (auth.uid() = id);
create policy if not exists "Crear mi perfil" on public.perfiles for insert with check (auth.uid() = id);

-- Progreso propio
create policy if not exists "Ver mi progreso" on public.progreso for select using (auth.uid() = usuario_id);
create policy if not exists "Guardar mi progreso" on public.progreso for insert with check (auth.uid() = usuario_id);
create policy if not exists "Actualizar mi progreso" on public.progreso for update using (auth.uid() = usuario_id);

-- Compras propias
create policy if not exists "Ver mis compras" on public.compras for select using (auth.uid() = usuario_id);
create policy if not exists "Crear compra" on public.compras for insert with check (auth.uid() = usuario_id or usuario_id is null);

-- Contacto público
create policy if not exists "Enviar contacto" on public.contactos for insert with check (true);

-- Datos iniciales
insert into public.cursos (titulo,categoria,nivel,descripcion,duracion,tipo,orden) values
('Excel Básico desde Cero','Excel','Básico','Aprende celdas, formatos y fórmulas simples.','2h 15m','gratis',1),
('Funciones Esenciales de Excel','Excel','Básico','SI, BUSCARV, BUSCARX, FILTRAR y funciones modernas.','3h 20m','gratis',2),
('Excel Avanzado con Dashboards','Excel','Avanzado','KPIs, segmentadores y reportes ejecutivos.','6h 30m','pro',3),
('Power BI Básico','Power BI','Básico','Crea tus primeros dashboards.','2h 45m','gratis',4),
('Power BI para Supervisores','Power BI','Intermedio','Indicadores de avance, productividad y cumplimiento.','5h 40m','pro',5),
('Power Query desde Cero','Power Query','Básico','Limpieza y transformación de datos.','2h 30m','gratis',6),
('DAX Básico','DAX','Básico','Medidas, columnas y CALCULATE.','2h 50m','gratis',7),
('DAX Avanzado para KPIs','DAX','Avanzado','Time intelligence, ranking y métricas complejas.','6h','pro',8),
('SQL Básico','SQL','Básico','SELECT, WHERE, JOIN y GROUP BY.','3h 10m','gratis',9),
('SQL Server para Reportes','SQL','Intermedio','Vistas, consultas y procedimientos.','5h 30m','pro',10),
('IA para Oficina','IA','Básico','Usa IA para redactar, analizar y automatizar.','2h','gratis',11),
('Apps Script para Automatizar','Automatización','Intermedio','Automatiza Google Sheets y formularios.','5h 20m','pro',12)
on conflict do nothing;

insert into public.plantillas (titulo,categoria,descripcion,precio) values
('Control de Trabajos Operativos','Excel','Estados, avance, observaciones y dashboard.',7),
('Dashboard de Ventas Power BI','Power BI','Ventas, margen, clientes y productos.',12),
('Control de Gastos Personales','Finanzas','Presupuesto mensual y alertas.',0),
('Inventario Avanzado','Excel','Stock, entradas, salidas y mínimos.',9),
('Cronograma de Mantenimiento','Operaciones','Programación, responsables y avance.',8),
('Reporte Diario de Supervisión','Operaciones','Formato listo para seguimiento diario.',6)
on conflict do nothing;

insert into public.herramientas (titulo,descripcion,tipo) values
('Generador de fórmulas Excel','Crea fórmulas a partir de una descripción.','ia'),
('Explicador de fórmulas','Explica fórmulas paso a paso.','ia'),
('Constructor SQL','Genera consultas SQL base.','ia'),
('Generador DAX','Crea medidas para Power BI.','ia'),
('Generador VBA','Crea macros iniciales.','ia')
on conflict do nothing;

# CampusHugo Pro - Versión Pro Final Final

Esta versión incluye una web completa inicial para vender cursos, plantillas y herramientas de productividad.

## Archivos

- `index.html`: página principal completa.
- `assets/styles.css`: diseño responsive.
- `assets/app.js`: lógica de cursos, plantillas, herramientas, login demo y admin demo.
- `assets/config.js`: configuración de Supabase.
- `sql/supabase_campushugo.sql`: SQL completo para crear tablas, políticas y datos iniciales.
- `docs/GUIA_INSTALACION.md`: pasos para publicar.

## Cómo usar

1. Sube todos los archivos a GitHub.
2. Publica el repositorio en Vercel.
3. Crea un proyecto en Supabase.
4. Ejecuta el SQL de `sql/supabase_campushugo.sql`.
5. Copia tu Supabase URL y anon key en `assets/config.js`.
6. Cambia el número de WhatsApp en `assets/config.js`.

## Qué trae listo

- Página moderna y responsive.
- 20 cursos demo distribuidos por categorías.
- 12 plantillas demo para vender o regalar.
- 6 herramientas demo.
- Panel administrador local de prueba.
- Login demo.
- Preparación para Supabase.
- SQL con tablas, RLS, políticas y datos iniciales.

## Próxima mejora recomendada

Conectar el frontend a Supabase para que cursos, plantillas y usuarios se carguen desde la base de datos en vez de estar en arrays demo.

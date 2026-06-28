# CampusHugo Pro Oficial

Versión unificada oficial para reemplazar el repositorio de GitHub.

## Incluye
- Página principal responsive.
- Cursos y recursos base.
- Login/registro preparado con Supabase.
- Panel administrador real condicionado por rol `admin`.
- Dashboard administrativo base.
- Subida de recursos a Supabase Storage.
- Constructor inicial de lecciones interactivas tipo Prezi.
- SQL único: `sql/01_schema_supabase_oficial.sql`.
- PWA básica (`manifest.webmanifest` y `sw.js`).

## Estructura
```
index.html
css/styles.css
js/app.js
sql/01_schema_supabase_oficial.sql
manifest.webmanifest
sw.js
assets/
README.md
```

## Pasos
1. Reemplaza TODO tu repositorio de GitHub por estos archivos.
2. En Supabase, entra a SQL Editor y ejecuta `sql/01_schema_supabase_oficial.sql`.
3. En Supabase, registra tu usuario desde la web.
4. Ejecuta:
```sql
update public.profiles set role='admin' where email='TU_CORREO';
```
5. En `js/app.js`, reemplaza:
```js
const SUPABASE_URL = 'PEGA_AQUI_TU_SUPABASE_URL';
const SUPABASE_ANON_KEY = 'PEGA_AQUI_TU_SUPABASE_ANON_KEY';
```
por tu URL y anon key de Supabase.
6. Publica en Vercel.

## Archivos permitidos en recursos
`.xlsx`, `.xls`, `.xlsm`, `.csv`, `.pbix`, `.pbit`, `.sql`, `.pdf`, `.docx`, `.pptx`, `.zip`, `.rar`, `.jpg`, `.png`, `.webp`, `.mp4`, `.webm`.

## Nota importante
Esta es la base oficial unificada. El constructor visual ya existe como módulo inicial. La siguiente mejora será guardar múltiples bloques por lección con orden, edición, eliminación y vista previa completa.

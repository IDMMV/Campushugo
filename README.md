# CampusHugo Pro

Plataforma web inicial para vender plantillas, publicar cursos gratuitos, captar leads, mostrar planes y preparar conexión con Supabase.

## Archivos principales
- `index.html`: página principal completa.
- `assets/styles.css`: diseño responsive.
- `assets/app.js`: lógica, tarjetas, herramientas, WhatsApp y configuración Supabase.
- `sql/supabase_campushugo.sql`: tablas y políticas para Supabase.
- `docs/GUIA_INSTALACION.txt`: pasos de instalación.

## Cambios obligatorios
En `assets/app.js`, cambia:

```js
const SUPABASE_URL = 'PEGA_AQUI_TU_SUPABASE_URL';
const SUPABASE_ANON_KEY = 'PEGA_AQUI_TU_SUPABASE_ANON_KEY';
const WHATSAPP = '51999999999';
```

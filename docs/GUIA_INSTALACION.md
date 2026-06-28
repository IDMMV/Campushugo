# Guía de instalación CampusHugo Pro

## 1. Subir a GitHub

Crea un repositorio llamado `campushugo-pro` y sube estos archivos:

- index.html
- assets/
- sql/
- docs/
- README.md

## 2. Publicar en Vercel

1. Entra a Vercel.
2. Add New Project.
3. Importa tu repositorio de GitHub.
4. Framework: Other.
5. Deploy.

## 3. Configurar Supabase

1. Crea un proyecto en Supabase.
2. Ve a SQL Editor.
3. Copia todo el contenido de `sql/supabase_campushugo.sql`.
4. Ejecuta el script.

## 4. Colocar credenciales

En Supabase ve a:

Project Settings > API

Copia:

- Project URL
- anon public key

Luego abre:

`assets/config.js`

Y reemplaza:

```js
SUPABASE_URL: 'https://TU-PROYECTO.supabase.co',
SUPABASE_ANON_KEY: 'TU_ANON_KEY'
```

## 5. Cambiar WhatsApp

En `assets/config.js` cambia:

```js
WHATSAPP_NUMBER: '51999999999'
```

Por tu número real con código de país.

## 6. Probar

Abre la web y revisa:

- Menú móvil.
- Cursos.
- Plantillas.
- Herramientas.
- Botón comprar por WhatsApp.
- Panel admin demo.
- Botón probar Supabase.

/* CAMPUSHUGO PRO - CONFIGURA AQUÍ SUPABASE */
const SUPABASE_URL = 'PEGA_AQUI_TU_SUPABASE_URL';
const SUPABASE_ANON_KEY = 'PEGA_AQUI_TU_SUPABASE_ANON_KEY';
const WHATSAPP = '51999999999'; // cambia por tu número con código de país
const supabaseClient = (SUPABASE_URL.startsWith('http')) ? supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY) : null;

const courses = [
 {cat:'Excel', icon:'🟩', title:'Excel Básico para Principiantes', desc:'Funciones, tablas y gráficos desde cero.', level:'Básico', price:'Gratis'},
 {cat:'Power BI', icon:'📊', title:'Power BI Básico', desc:'Crea tus primeros dashboards profesionales.', level:'Básico', price:'Gratis'},
 {cat:'Excel', icon:'🔎', title:'BUSCARV, XLOOKUP e ÍNDICE', desc:'Domina búsquedas y cruces de información.', level:'Intermedio', price:'Gratis'},
 {cat:'SQL', icon:'🗄️', title:'SQL Básico', desc:'Consulta y analiza datos con SELECT, WHERE y JOIN.', level:'Básico', price:'Gratis'},
 {cat:'IA', icon:'🤖', title:'IA para Oficina', desc:'Usa IA para reportes, correos y automatización.', level:'Básico', price:'Gratis'},
 {cat:'Power BI', icon:'⚡', title:'Power Query desde Cero', desc:'Limpia y transforma datos sin sufrir.', level:'Intermedio', price:'Gratis'},
 {cat:'Excel', icon:'📈', title:'Dashboards en Excel', desc:'Indicadores, KPIs y reportes ejecutivos.', level:'Intermedio', price:'Premium'},
 {cat:'SQL', icon:'🔗', title:'JOINs y reportes SQL', desc:'Une tablas y crea reportes útiles.', level:'Intermedio', price:'Premium'}
];
const templates = [
 {cat:'Excel', icon:'📦', title:'Control de Inventario Avanzado', desc:'Entradas, salidas, stock mínimo y dashboard.', price:'US$7'},
 {cat:'Power BI', icon:'📊', title:'Dashboard de Ventas Power BI', desc:'Ventas, metas, clientes y productos.', price:'US$10'},
 {cat:'Excel', icon:'💰', title:'Control de Gastos Personales', desc:'Presupuesto mensual y gráficos automáticos.', price:'US$5'},
 {cat:'Operaciones', icon:'🛠️', title:'Control de Trabajos Operativos', desc:'Pendiente, ejecutado, observado y avance.', price:'US$9'},
 {cat:'Excel', icon:'🧾', title:'Caja y Vuelto para Negocio', desc:'Ventas, IGV, efectivo y vuelto.', price:'US$6'},
 {cat:'Power BI', icon:'⚙️', title:'Dashboard de Mantenimiento', desc:'Incidencias, tiempos y productividad.', price:'US$12'},
 {cat:'RRHH', icon:'👥', title:'Asistencia y Horas Extras', desc:'Control mensual del personal.', price:'US$6'},
 {cat:'SQL', icon:'🗄️', title:'Pack Consultas SQL', desc:'Consultas listas para reportes frecuentes.', price:'US$5'}
];
let leads = JSON.parse(localStorage.getItem('ch_leads')||'[]');

document.getElementById('menuBtn').onclick=()=>document.getElementById('nav').classList.toggle('open');
document.querySelectorAll('nav a').forEach(a=>a.onclick=()=>document.getElementById('nav').classList.remove('open'));
document.getElementById('waPlan').href=wa('Hola, quiero comprar el plan Premium de CampusHugo Pro.');
document.getElementById('waCompany').href=wa('Hola, quiero información del plan Empresa de CampusHugo Pro.');
document.getElementById('waFooter').href=wa('Hola, quiero información de CampusHugo Pro.');

function wa(msg){return `https://wa.me/${WHATSAPP}?text=${encodeURIComponent(msg)}`}
function card(item,type){return `<article class="card" data-type="${type}" data-cat="${item.cat}"><div class="thumb"><span class="tag">${item.cat}</span>${item.icon}</div><div class="cardBody"><h3>${item.title}</h3><p>${item.desc}</p><div class="meta"><span>${item.level||'Producto digital'}</span><span class="price">${item.price}</span></div><a class="btn small" target="_blank" href="${wa('Hola, quiero '+(type==='curso'?'el curso ':'la plantilla ')+item.title)}">${item.price==='Gratis'?'Solicitar':'Comprar'}</a></div></article>`}
function render(){document.getElementById('coursesGrid').innerHTML=courses.map(x=>card(x,'curso')).join('');document.getElementById('templatesGrid').innerHTML=templates.map(x=>card(x,'plantilla')).join('');adminTab('stats')}
function filterCards(type,cat){document.querySelectorAll(`[data-type="${type}"]`).forEach(el=>el.classList.toggle('hidden',cat!=='all'&&el.dataset.cat!==cat))}
function generateFormula(){const v=document.getElementById('formulaInput').value.trim();document.getElementById('formulaOutput').textContent=v?`Ejemplo sugerido:\n=FILTRAR(A2:E100;A2:A100="criterio")\n\nPara último registro por fecha:\n=INDICE(ORDENARPOR(FILTRAR(A2:E100;A2:A100=G2);E2:E100;-1);1;)\n\nNota: ajusta rangos y columnas según tu archivo.`:'Escribe primero lo que necesitas resolver.'}
function generateSQL(){const v=document.getElementById('sqlInput').value.trim();document.getElementById('sqlOutput').textContent=v?`SELECT\n  DATE_TRUNC('month', fecha) AS mes,\n  SUM(monto) AS total_ventas,\n  COUNT(*) AS cantidad\nFROM ventas\nWHERE fecha >= CURRENT_DATE - INTERVAL '12 months'\nGROUP BY mes\nORDER BY mes;`:'Describe el reporte que deseas crear.'}
function calcPrice(){const c=Number(document.getElementById('cost').value),m=Number(document.getElementById('margin').value);document.getElementById('priceOutput').textContent=(c&&m)?`Precio sugerido: US$ ${(c*(1+m/100)).toFixed(2)}\nGanancia estimada: US$ ${(c*m/100).toFixed(2)}`:'Ingresa costo y margen.'}
function openAuth(){document.getElementById('authModal').style.display='flex'}function closeAuth(){document.getElementById('authModal').style.display='none'}
function loginDemo(){document.getElementById('authMsg').textContent='Sesión demo iniciada. Luego conectaremos autenticación real con Supabase.';setTimeout(closeAuth,900)}

document.getElementById('leadForm').addEventListener('submit',async(e)=>{e.preventDefault();const lead={nombre:leadName.value,email:leadEmail.value,interes:leadInterest.value,fecha:new Date().toISOString()};leads.unshift(lead);localStorage.setItem('ch_leads',JSON.stringify(leads));leadMsg.textContent='Registrado correctamente.';e.target.reset(); if(supabaseClient){await supabaseClient.from('leads').insert(lead)} });
function adminTab(tab){const p=document.getElementById('adminPanel');if(tab==='stats')p.innerHTML=`<h3>Resumen</h3><div class="metrics"><div><b>${courses.length}</b><small>Cursos</small></div><div><b>${templates.length}</b><small>Plantillas</small></div><div><b>${leads.length}</b><small>Leads locales</small></div></div><p>Para activar datos reales pega tu URL y anon key de Supabase en assets/app.js.</p>`;if(tab==='courses')p.innerHTML=`<h3>Cursos</h3><table class="table"><tr><th>Título</th><th>Categoría</th><th>Precio</th></tr>${courses.map(x=>`<tr><td>${x.title}</td><td>${x.cat}</td><td>${x.price}</td></tr>`).join('')}</table>`;if(tab==='templates')p.innerHTML=`<h3>Plantillas</h3><table class="table"><tr><th>Título</th><th>Categoría</th><th>Precio</th></tr>${templates.map(x=>`<tr><td>${x.title}</td><td>${x.cat}</td><td>${x.price}</td></tr>`).join('')}</table>`;if(tab==='leads')p.innerHTML=`<h3>Leads</h3><table class="table"><tr><th>Nombre</th><th>Email</th><th>Interés</th></tr>${leads.map(x=>`<tr><td>${x.nombre}</td><td>${x.email}</td><td>${x.interes}</td></tr>`).join('')||'<tr><td colspan="3">Aún no hay leads.</td></tr>'}</table>`}
render();

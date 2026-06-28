const cfg = window.CAMPUSHUGO_CONFIG || {};
let supabaseClient = null;
if (cfg.SUPABASE_URL && !cfg.SUPABASE_URL.includes('TU-PROYECTO') && cfg.SUPABASE_ANON_KEY && !cfg.SUPABASE_ANON_KEY.includes('TU_ANON')) {
  supabaseClient = window.supabase.createClient(cfg.SUPABASE_URL, cfg.SUPABASE_ANON_KEY);
}

const categories = ['Todos','Excel','Power BI','Power Query','DAX','SQL','IA','Automatización','Google Sheets','Python'];
const courses = [
  ['Excel Básico desde Cero','Excel','Gratis','Aprende celdas, formatos, fórmulas simples y ordenamiento.','📗','2h 15m'],
  ['Funciones Esenciales de Excel','Excel','Gratis','SUMA, SI, BUSCARV, BUSCARX, FILTRAR y fórmulas modernas.','🧮','3h 20m'],
  ['Excel Intermedio para Oficina','Excel','Pro','Tablas, validaciones, reportes y limpieza de datos.','📊','4h 10m'],
  ['Excel Avanzado con Dashboards','Excel','Pro','Tableros profesionales, KPIs, segmentadores y automatización.','📈','6h 30m'],
  ['Power BI Básico','Power BI','Gratis','Carga datos y crea tus primeros gráficos y dashboards.','🟨','2h 45m'],
  ['Power BI para Supervisores','Power BI','Pro','Indicadores de avance, productividad, cumplimiento y alertas.','📉','5h 40m'],
  ['Power Query desde Cero','Power Query','Gratis','Transforma datos sin fórmulas complicadas.','🔄','2h 30m'],
  ['Power Query Avanzado','Power Query','Pro','Unir archivos, parametrizar consultas y automatizar reportes.','⚙️','5h 10m'],
  ['DAX Básico','DAX','Gratis','Medidas, columnas calculadas, CALCULATE y filtros.','🧠','2h 50m'],
  ['DAX Avanzado para KPIs','DAX','Pro','Time intelligence, acumulados, ranking y métricas complejas.','🏆','6h 00m'],
  ['SQL Básico','SQL','Gratis','SELECT, WHERE, JOIN, GROUP BY y consultas prácticas.','🗄️','3h 10m'],
  ['SQL Server para Reportes','SQL','Pro','Vistas, procedimientos, consultas optimizadas y reporting.','💾','5h 30m'],
  ['IA para Oficina','IA','Gratis','Usa IA para redactar, analizar datos y crear fórmulas.','🤖','2h 00m'],
  ['IA para Excel y Power BI','IA','Pro','Prompts, análisis de datos, dashboards y automatización asistida.','✨','4h 50m'],
  ['Google Sheets Profesional','Google Sheets','Gratis','Funciones, validaciones, filtros y colaboración online.','🟩','2h 25m'],
  ['Apps Script para Automatizar','Automatización','Pro','Automatiza correos, formularios, hojas y reportes.','🧩','5h 20m'],
  ['Power Automate Básico','Automatización','Gratis','Crea flujos para ahorrar tiempo en procesos repetitivos.','🔌','2h 40m'],
  ['Python para Analizar Datos','Python','Pro','Pandas, archivos Excel, limpieza y gráficos básicos.','🐍','6h 15m'],
  ['Macros VBA desde Cero','Automatización','Pro','Botones, formularios, eventos y automatización en Excel.','⌨️','5h 45m'],
  ['Dashboard Ejecutivo Integral','Power BI','Pro','Proyecto completo desde datos crudos hasta tablero final.','🚀','8h 00m']
];
const templates = [
  ['Control de Trabajos Operativos','Excel','US$7','Estados, avance, observaciones y dashboard.','📋'],
  ['Dashboard de Ventas Power BI','Power BI','US$12','Ventas, margen, clientes, productos y tendencias.','🟨'],
  ['Control de Gastos Personales','Finanzas','Gratis','Presupuesto mensual, categorías y alertas.','💵'],
  ['Inventario Avanzado','Excel','US$9','Stock, entradas, salidas, mínimos y reporte.','📦'],
  ['Cronograma de Mantenimiento','Operaciones','US$8','Programación, responsables, vencimientos y avance.','🛠️'],
  ['Reporte Diario de Supervisión','Operaciones','US$6','Formato listo para seguimiento diario.','🦺'],
  ['Matriz de Riesgos','Excel','US$5','Probabilidad, impacto, criticidad y acciones.','⚠️'],
  ['Dashboard RRHH','Power BI','US$10','Personal, asistencia, rotación y productividad.','👥'],
  ['Flujo de Caja Simple','Finanzas','US$6','Ingresos, egresos, saldo y proyección.','🏦'],
  ['Base de Incidencias','Operaciones','US$7','Registro, prioridad, responsable y cierre.','🚨'],
  ['KPI de Producción','Power BI','US$12','Cumplimiento, tiempos, fallas y eficiencia.','🏭'],
  ['Registro de Capacitaciones','Excel','US$5','Asistencia, notas, certificados y vencimientos.','🎓']
];
const tools = [
  ['Generador de fórmulas Excel','Describe tu caso y recibe una fórmula sugerida con explicación.'],
  ['Explicador de fórmulas','Pega una fórmula y obtén explicación paso a paso.'],
  ['Constructor SQL','Convierte una necesidad en una consulta SELECT base.'],
  ['Generador de DAX','Crea medidas DAX para Power BI.'],
  ['Generador de macros VBA','Crea una macro base para tareas repetitivas.'],
  ['Prompt para IA','Convierte una idea en un buen prompt profesional.']
];
let activeCategory = 'Todos';
let activeTool = tools[0][0];

function renderTabs(){
  courseTabs.innerHTML = categories.map(c=>`<button class="tab ${c===activeCategory?'active':''}" onclick="setCategory('${c}')">${c}</button>`).join('');
}
function setCategory(c){ activeCategory=c; renderTabs(); renderCourses(); }
function renderCourses(){
  const q = courseSearch.value.toLowerCase();
  const list = courses.filter(x=>(activeCategory==='Todos'||x[1]===activeCategory) && x.join(' ').toLowerCase().includes(q));
  courseGrid.innerHTML = list.map(x=>`<article class="card"><div class="thumb">${x[4]}</div><span class="badge">${x[2]}</span><h3>${x[0]}</h3><p>${x[3]}</p><div class="meta"><span>${x[1]}</span><span>⭐ 4.8 · ${x[5]}</span></div></article>`).join('');
}
function renderTemplates(){
  const f = templateFilter.value;
  const list = templates.filter(x=>f==='todas'||x[1]===f);
  templateGrid.innerHTML = list.map(x=>`<article class="card"><div class="thumb">${x[4]}</div><span class="badge">${x[1]}</span><h3>${x[0]}</h3><p>${x[3]}</p><div class="meta"><span>${x[2]}</span><span>⬇️ Descargar</span></div></article>`).join('');
}
function renderTools(){
  toolList.innerHTML = tools.map(t=>`<button class="tool-item ${t[0]===activeTool?'active':''}" onclick="selectTool('${t[0]}')">${t[0]}<br><small>${t[1]}</small></button>`).join('');
}
function selectTool(t){ activeTool=t; toolTitle.textContent=t; renderTools(); }
function runTool(){
  const text = toolInput.value.trim() || 'Necesito resolver un problema de oficina.';
  const samples = {
    'Generador de fórmulas Excel': `Sugerencia:\n=FILTRAR(Tabla1,Tabla1[Codigo]=A2)\n\nExplicación: filtra los registros donde el código coincide con A2. Ajusta nombres de tabla y columnas según tu archivo.`,
    'Explicador de fórmulas': `La fórmula se debe leer por partes: primero identifica el rango, luego aplica el criterio y finalmente devuelve el resultado. Para revisarla, valida separadores ; o , según tu configuración regional.`,
    'Constructor SQL': `SELECT codigo, fecha, estado, responsable\nFROM reportes\nWHERE estado = 'Pendiente'\nORDER BY fecha DESC;`,
    'Generador de DAX': `Total Ejecutado = CALCULATE(COUNTROWS(Reportes), Reportes[Estado] = "Ejecutado")`,
    'Generador de macros VBA': `Sub LimpiarFiltros()\n  If ActiveSheet.AutoFilterMode Then ActiveSheet.ShowAllData\nEnd Sub`,
    'Prompt para IA': `Actúa como experto en Excel. Necesito que me ayudes con este caso: ${text}. Dame la fórmula, explicación y un ejemplo.`
  };
  toolOutput.textContent = samples[activeTool] + `\n\nTu solicitud: ${text}`;
}
function openLogin(){ loginModal.classList.add('show'); }
function closeLogin(){ loginModal.classList.remove('show'); }
function loginDemo(){ loginMsg.textContent = 'Ingreso demo correcto. Luego conectaremos autenticación real con Supabase.'; }
function testSupabase(){ supabaseStatus.textContent = supabaseClient ? 'Supabase configurado correctamente en el frontend.' : 'Aún falta colocar tu URL y anon key en assets/config.js'; }
function saveAdmin(e){
  e.preventDefault();
  const item = {title:adminTitle.value,type:adminType.value,desc:adminDesc.value,created:new Date().toLocaleString()};
  const items = JSON.parse(localStorage.getItem('campushugo_admin')||'[]');
  items.unshift(item); localStorage.setItem('campushugo_admin',JSON.stringify(items)); e.target.reset(); renderAdmin();
}
function renderAdmin(){
  const items = JSON.parse(localStorage.getItem('campushugo_admin')||'[]');
  adminItems.innerHTML = items.length ? items.map(i=>`<p><b>${i.type}:</b> ${i.title}<br><small>${i.desc}</small></p>`).join('') : '<p>No hay contenido demo agregado.</p>';
}
menuBtn.onclick=()=>mainNav.classList.toggle('open');
themeBtn.onclick=()=>document.body.classList.toggle('dark');
courseSearch.oninput=renderCourses; templateFilter.onchange=renderTemplates; adminForm.onsubmit=saveAdmin;
renderTabs(); renderCourses(); renderTemplates(); renderTools(); renderAdmin();

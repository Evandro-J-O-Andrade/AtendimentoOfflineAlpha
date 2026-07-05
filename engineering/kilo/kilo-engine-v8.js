#!/usr/bin/env node
// KILO ENGINE v8 — BASELINE GENERATOR
// Fonte canônica: Dump20260606.sql (congelado)
// Saída: engineering/kilo/snapshots/baseline-v8/

const fs = require('fs');
const path = require('path');

const DUMP_PATH = path.resolve('legacy/backend_antigo/sql/Dump20260606.sql');
const OUTPUT_DIR = path.resolve('engineering/kilo/snapshots/baseline-v8');
const PROCEDURES_DIR = path.resolve('docs/database/procedures_raw_texts');

if (fs.existsSync(OUTPUT_DIR)) {
  console.log(`⏭️  Baseline já existe em ${OUTPUT_DIR}`);
  process.exit(0);
}

fs.mkdirSync(OUTPUT_DIR, { recursive: true });

console.log('📥 Lendo dump:', DUMP_PATH);
const sql = fs.readFileSync(DUMP_PATH, 'utf8');
console.log(`📊 Dump carregado: ${sql.length} bytes`);

console.log('1/8 Extraindo tabelas...');
const tableRegex = /CREATE\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?`?(\w+)`?\s*\((.*?)\)\s*(?:ENGINE|DEFAULT|COLLATE|;)/gis;
const tables = new Map();
let tm;
while ((tm = tableRegex.exec(sql)) !== null) {
  tables.set(tm[1], tm[2]);
}
console.log(`🗂️ Tabelas extraídas: ${tables.size}`);

console.log('2/8 Extraindo chaves primárias...');
const pks = new Map();
for (const [name, body] of tables) {
  const m = body.match(/PRIMARY\s+KEY\s*\(`?(\w+)`?\)/i);
  if (m) pks.set(name, m[1]);
}

console.log('3/8 Extraindo chaves estrangeiras...');
const fks = [];
const fkRegex = /CONSTRAINT\s+`?\w+`?\s+FOREIGN\s+KEY\s*\(`?(\w+)`?\)\s*REFERENCES\s+`?(\w+)`?\s*\(`?(\w+)`?\)/gi;
for (const [name, body] of tables) {
  let fm;
  while ((fm = fkRegex.exec(body)) !== null) {
    fks.push({ from_table: name, from_col: fm[1], to_table: fm[2], to_col: fm[3] });
  }
}

console.log('4/8 Extraindo stored procedures...');
const spRegex = /CREATE\s+DEFINER=`[^`]+`\s+PROCEDURE\s+`(\w+)`\s*\(([\s\S]*?)\)\s*SQL\s+SECURITY\s+\w+[^`]*`[^`]+`\s*\n/gi;
const procedures = new Map();
let sm;
while ((sm = spRegex.exec(sql)) !== null) {
  const paramCount = (sm[2].match(/IN\s+|OUT\s+|INOUT\s+/gi) || []).length;
  procedures.set(sm[1], { name: sm[1], params: sm[2].trim(), param_count: paramCount });
}
if (fs.existsSync(PROCEDURES_DIR)) {
  console.log(`   📁 Adicionando procedures de ${PROCEDURES_DIR}...`);
  const files = fs.readdirSync(PROCEDURES_DIR).filter(f => f.endsWith('.sql'));
  for (const file of files) {
    const content = fs.readFileSync(path.join(PROCEDURES_DIR, file), 'utf8');
    const base = file.replace(/\.sql$/i, '');
    const paramCount = (content.match(/IN\s+|OUT\s+|INOUT\s+/gi) || []).length;
    procedures.set(base, { name: base, params: '', param_count: paramCount, source_file: file });
  }
}

console.log('5/8 Extraindo functions...');
const fnRegex = /CREATE\s+DEFINER=`[^`]+`\s+FUNCTION\s+`(\w+)`\s*\(([\s\S]*?)\)\s*\n\s*RETURNS\s+/gi;
const functions = new Map();
let fm2;
while ((fm2 = fnRegex.exec(sql)) !== null) {
  functions.set(fm2[1], { name: fm2[1], params: fm2[2].trim() });
}

console.log('6/8 Extraindo views...');
const viewRegex = /CREATE\s+(?:ALGORITHM\s*=\s*\w+\s+)?DEFINER=`[^`]+`\s+VIEW\s+`(\w+)`\s+AS\s+([\s\S]*?)(?=;\s*CREATE\s+DEFINER|$)/gi;
const views = new Map();
let vm;
while ((vm = viewRegex.exec(sql)) !== null) {
  let def = vm[2].trim();
  if (def.length > 200) def = def.slice(0, 200) + '...';
  views.set(vm[1], def);
}

console.log('7/8 Analisando relacionamentos e dependências...');
const calls = new Map();
const allNames = [...procedures.keys(), ...functions.keys()];
for (const name of allNames) {
  const escaped = name.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  const pattern = new RegExp(`CALL\\s+${escaped}\\b|\\b${escaped}\\s*\\(`, 'gi');
  const count = (sql.match(pattern) || []).length;
  if (count > 0) calls.set(name, count);
}

function resolveDomain(name) {
  const n = name.toLowerCase();
  if (/^(pessoa|usuario|sessao|portal|tenant|entidade|unidade|setor|sistema|perfil|permissao|grupo|papel|acl|login|auth|token|bloqueio|log_acesso|reset_senha|refresh|contexto|alocacao|profissional|vinculo|endereco|telefone|documento|email|alergia|conselho|identificador|logradouro|especialidade|funcionario|medico|colaborador|rh|registro_profissional)/.test(n)) return 'CORE';
  if (/^(senha|fila|triagem|totem|ffa|atendimento|internacao|triage|sumario|desfecho|movimentacao|pre_hospitalar|acompanhante|checagem|identidade|reabertura|evolucao|anamnese|exame|pedido|solicitacao_exame|prescricao|medicacao|administracao|aprazamento|diagnostico|sinais|vital|alta|obito|interconsulta|internacao|cuidados|dietas|dispositivos|ferida|braden|medicamento|dispensacao|reavaliacao|prescritor|ordem|procedimento|protocolo|protocolo_sequencia|lab|amostra|resultado|exame_fisico|historico_exame|pedido_medico|intercorrencia|transferencia|remocao|ambulancia|viatura|gaso|gasoterapia|cat|notificacao|epidemiologica|violencia|assinatura|documento|arquivo|emissao|tipo_documento|tipo_config|painel|config|local|dispositivo|tipo_local|tipo_sala|sala|capacidade|fila|turno|leito|leitos|tv|rotativo|display|painel|totem)/.test(n)) return 'HIS';
  if (/^(farmac|farm|estoque|almoxarifado|produto|lote|saldo|movimento|inventario|reserva|pipeline|conciliacao|fluxo_estoque|consumo|insumo|limpeza|manutencao|audit_stream|ledger|documento_execucao|execucao)/.test(n)) return 'FARMACY';
  if (/^(faturamento|conta|convenio|item|producao|sigtap|tuss|codigo|regra_validacao|sus|competencia|cnes|cid10|pdv|venda|pagamento|cliente|forma|caixa)/.test(n)) return 'BILLING';
  if (/^(financeiro|repasse|medico|faturamento|conta|pagamento|caixa|pdv|venda)/.test(n)) return 'FINANCE';
  if (/^(crm|chamado|manutencao|suporte|sac|ouvidoria|solicitacao|ticket|cliente)/.test(n)) return 'CRM';
  if (/^(agenda|agendamento|disponibilidade|escala|plantao|turno|alocacao)/.test(n)) return 'SCHEDULE';
  if (/^(bi|indicador|dashboard|relatorio|analytics|painel_monitoramento|painel_fila|painel_local|painel_lane|painel_grupo|painel_config|painel_evento|painel_mensagem|painel_consumo|painel_alertas)/.test(n)) return 'BI';
  if (/^(integracao|webhook|endpoint|mensageria|externa|n8n|api|sincronizacao|federada|reconciliacao|edge|evento)/.test(n)) return 'INTEGRATION';
  if (/^(automacao|workflow|fluxo|transicao|status|substatus|prioridade|evento|tempo|timeout|excecao|erro|cat)/.test(n)) return 'WORKFLOW';
  return 'GENERIC';
}

const byDomain = new Map();
for (const name of tables.keys()) {
  const d = resolveDomain(name);
  if (!byDomain.has(d)) byDomain.set(d, []);
  byDomain.get(d).push(name);
}

const moduleMap = [];
for (const [domain, tablesList] of byDomain) {
  let modules = [];
  if (domain === 'HIS') modules = ['auth','contexto','recepcao','triagem','consultorio','enfermagem','internacao','gpat','ffa','senha','fila','totem','painel','documentos'];
  else if (domain === 'CORE') modules = ['auth','tenant','context','portal','identity','professionals'];
  else if (domain === 'FARMACY') modules = ['farmacia','estoque','dispensacao'];
  else if (domain === 'BILLING') modules = ['faturamento','financeiro','sus'];
  else if (domain === 'FINANCE') modules = ['financeiro','faturamento','pdv'];
  else if (domain === 'CRM') modules = ['sac','ouvidoria','chamados'];
  else if (domain === 'SCHEDULE') modules = ['agenda','plantao','escala'];
  else if (domain === 'BI') modules = ['bi','dashboards','analytics'];
  else if (domain === 'INTEGRATION') modules = ['integracoes','n8n','webhooks'];
  else if (domain === 'WORKFLOW') modules = ['workflow','automacoes','fila'];
  else modules = ['generic'];
  moduleMap.push({ domain, table_count: tablesList.length, modules });
}

const uiMap = { devices: {}, flows: {} };
uiMap.devices['totem'] = ['senha','fila','totem'];
uiMap.devices['painel'] = ['fila','tv_rotativo','painel'];
uiMap.devices['mobile'] = ['recepcao','triagem','atendimento'];
uiMap.devices['tablet'] = ['enfermagem','medicacao'];
uiMap.devices['kiosk'] = ['atendimento','contexto'];
uiMap.devices['tv'] = ['tv_rotativo','painel'];
uiMap.flows['entrada_paciente'] = ['contexto','senha','fila','triagem'];
uiMap.flows['atendimento_medico'] = ['atendimento','prescricao','exame','internacao'];
uiMap.flows['triagem'] = ['triagem','classificacao_risco','senha'];
uiMap.flows['farmacia'] = ['farmacia','dispensacao','estoque'];
uiMap.flows['faturamento'] = ['faturamento','conta','convenio','producao'];
uiMap.flows['recepcao'] = ['recepcao','agendamento','contexto'];
uiMap.flows['laboratorio'] = ['lab','amostra','protocolo','resultado'];
uiMap.flows['internacao'] = ['internacao','leito','prescricao','enfermagem','evolucao'];
uiMap.flows['fila'] = ['fila','senha','chamada','timeout','retorno'];
uiMap.flows['ffa'] = ['ffa','item','gpat','prioridade','transicao'];

const callGraph = { nodes: [...calls.keys()], edges: [] };
const matrix = { edges: [], density: 0 };
const total = tables.size;
for (const fk of fks) {
  matrix.edges.push({ from: fk.from_table, to: fk.to_table, from_col: fk.from_col, to_col: fk.to_col });
}
const possible = total * (total - 1);
if (possible > 0) matrix.density = Number((matrix.edges.length / possible).toFixed(4));

const spDeps = [...calls.entries()].map(([sp, count]) => ({ sp, calls: count })).sort((a, b) => b.calls - a.calls);
const fkMap = new Map();
for (const fk of fks) {
  const key = `${fk.from_table}.${fk.from_col}`;
  if (!fkMap.has(key)) fkMap.set(key, []);
  fkMap.get(key).push({ table: fk.to_table, col: fk.to_col });
}
const contracts = [];
for (const [name, proc] of procedures) {
  const domain = resolveDomain(name);
  contracts.push({ sp: name, domain, params: proc.params, param_count: proc.param_count, tenant_required: true });
}

console.log('8/8 Exportando artefatos...');

function writeJson(name, data) {
  fs.writeFileSync(path.join(OUTPUT_DIR, name), JSON.stringify(data, null, 2), 'utf8');
}
function writeText(name, data) {
  fs.writeFileSync(path.join(OUTPUT_DIR, name), data, 'utf8');
}

const byDomainObj = Object.fromEntries(byDomain);
writeJson('kilo-tables-by-domain.json', byDomainObj);
writeJson('kilo-procedures-catalog.json', Object.fromEntries(procedures));
writeJson('kilo-functions-catalog.json', Object.fromEntries(functions));
writeJson('kilo-views.json', Object.fromEntries(views));

const domainMap = {
  generated_at: new Date().toISOString(),
  source: 'Dump20260606.sql',
  status: 'FROZEN',
  total_tables: tables.size,
  total_procedures: procedures.size,
  total_functions: functions.size,
  total_views: views.size,
  total_fks: fks.length,
  domains: [...byDomain.keys()].sort(),
  by_domain: byDomainObj,
  pks_count: pks.size,
  call_graph_nodes: callGraph.nodes.length,
  relationship_density: matrix.density
};
writeJson('kilo-domain-map.json', domainMap);
writeJson('kilo-callgraph.json', callGraph);
writeJson('kilo-sp-dependencies.json', spDeps);
writeJson('kilo-table-dependencies.json', matrix);
writeJson('kilo-fk-map.json', Object.fromEntries(fkMap));
writeJson('kilo-module-map.json', moduleMap);
writeJson('kilo-ui-map.json', uiMap);

const frontendContracts = { source: 'Dump20260606.sql', total_contracts: contracts.length, contracts };
writeJson('kilo-frontend-contracts.json', frontendContracts);

const endpoints = [];
for (const proc of procedures.values()) {
  const domain = resolveDomain(proc.name);
  const base = proc.name.replace(/^sp_/, '').replace(/_/g, '/');
  endpoints.push({ method: 'POST', path: `/api/${domain}/${base}`, procedure: proc.name, domain, params: proc.param_count });
}
writeJson('kilo-api-endpoints.json', endpoints);

const relTxt = [];
relTxt.push(`TABLES: ${tables.size}`);
relTxt.push(`PROCEDURES: ${procedures.size}`);
relTxt.push(`FUNCTIONS: ${functions.size}`);
relTxt.push(`VIEWS: ${views.size}`);
relTxt.push(`FOREIGN_KEYS: ${fks.length}`);
relTxt.push(`PRIMARY_KEYS: ${pks.size}`);
relTxt.push(`RELATIONSHIP_DENSITY: ${matrix.density}`);
relTxt.push('');
relTxt.push('BY DOMAIN:');
for (const d of [...byDomain.keys()].sort()) {
  relTxt.push(`  ${d} : ${byDomain.get(d).length} tables`);
}
relTxt.push('');
relTxt.push('TOP PROCEDURES BY CALL COUNT:');
for (const dep of spDeps.slice(0, 20)) {
  relTxt.push(`  ${dep.sp} => ${dep.calls}`);
}
relTxt.push('');
relTxt.push('TOP FK RELATIONSHIPS:');
for (const edge of matrix.edges.slice(0, 20)) {
  relTxt.push(`  ${edge.from}.${edge.from_col} -> ${edge.to}.${edge.to_col}`);
}
writeText('kilo-relationships.txt', relTxt.join('\n'));

const inv = [];
inv.push('=== KILO v8 CANONICAL INVENTORY ===');
inv.push('');
inv.push(`TABLES: ${tables.size}`);
inv.push(`PROCEDURES: ${procedures.size}`);
inv.push(`FUNCTIONS: ${functions.size}`);
inv.push(`VIEWS: ${views.size}`);
inv.push(`FKS: ${fks.length}`);
inv.push(`PKS: ${pks.size}`);
inv.push('');
inv.push('=== DOMAINS ===');
for (const d of [...byDomain.keys()].sort()) {
  inv.push(`${d} : ${byDomain.get(d).length} tables`);
}
inv.push('');
inv.push('=== TABLES ===');
for (const name of [...tables.keys()].sort()) {
  const pk = pks.get(name) || '';
  inv.push(`${name} | PK:${pk}`);
}
inv.push('');
inv.push('=== PROCEDURES ===');
for (const name of [...procedures.keys()].sort()) inv.push(name);
inv.push('');
inv.push('=== FUNCTIONS ===');
for (const name of [...functions.keys()].sort()) inv.push(name);
inv.push('');
inv.push('=== VIEWS ===');
for (const name of [...views.keys()].sort()) inv.push(name);
writeText('kilo-inventory.txt', inv.join('\n'));

const summaryMd = [];
summaryMd.push('# KILO ENGINE v8 — Frontend Summary');
summaryMd.push('');
summaryMd.push('> **Status:** FROZEN BASELINE  ');
summaryMd.push('> **Source:** `legacy/backend_antigo/sql/Dump20260606.sql`  ');
summaryMd.push(`> **Generated:** ${new Date().toISOString().slice(0, 19).replace('T', ' ')}`);
summaryMd.push('');
summaryMd.push('## Numbers');
summaryMd.push('');
summaryMd.push('| Metric | Count |');
summaryMd.push('|--------|-------|');
summaryMd.push(`| Tables | ${tables.size} |`);
summaryMd.push(`| Procedures | ${procedures.size} |`);
summaryMd.push(`| Functions | ${functions.size} |`);
summaryMd.push(`| Views | ${views.size} |`);
summaryMd.push(`| Foreign Keys | ${fks.length} |`);
summaryMd.push(`| Primary Keys | ${pks.size} |`);
summaryMd.push(`| Call Graph Nodes | ${callGraph.nodes.length} |`);
summaryMd.push(`| Relationship Density | ${matrix.density} |`);
summaryMd.push('');
summaryMd.push('## Domains');
summaryMd.push('');
summaryMd.push('| Domain | Tables | Modules |');
summaryMd.push('|--------|--------|---------|');
for (const entry of moduleMap.sort((a, b) => b.table_count - a.table_count)) {
  summaryMd.push(`| ${entry.domain} | ${entry.table_count} | ${entry.modules.join(', ')} |`);
}
summaryMd.push('');
summaryMd.push('## Top Procedures');
summaryMd.push('');
summaryMd.push('| Procedure | Calls |');
summaryMd.push('|-----------|-------|');
for (const dep of spDeps.slice(0, 15)) {
  summaryMd.push(`| ${dep.sp} | ${dep.calls} |`);
}
summaryMd.push('');
summaryMd.push('## Frontend Readiness');
summaryMd.push('');
summaryMd.push(`- Total front contracts extracted: **${contracts.length}**`);
summaryMd.push(`- Devices mapped: **${Object.keys(uiMap.devices).length}**`);
summaryMd.push(`- Clinical flows mapped: **${Object.keys(uiMap.flows).length}**`);
summaryMd.push('');
summaryMd.push('## Next Steps');
summaryMd.push('');
summaryMd.push('1. Validate this baseline against current running DB.');
summaryMd.push('2. Freeze artifacts in version control.');
summaryMd.push('3. Generate SP client SDKs from `kilo-frontend-contracts.json`.');
summaryMd.push('4. Generate backend controllers/routes from `kilo-procedures-catalog.json`.');
summaryMd.push('5. Generate React hooks/stores from `kilo-tables-by-domain.json`.');
summaryMd.push('');
summaryMd.push('---');
summaryMd.push('*Generated by KILO ENGINE v8*');
writeText('kilo-frontend-summary.md', summaryMd.join('\n'));

console.log('');
console.log('✅ KILO ENGINE v8 concluído com sucesso!');
console.log('');
console.log(`📁 Artefatos em: ${OUTPUT_DIR}`);
console.log('');
console.log('📄 Arquivos gerados:');
for (const file of fs.readdirSync(OUTPUT_DIR)) {
  const stat = fs.statSync(path.join(OUTPUT_DIR, file));
  console.log(`  - ${file} (${stat.size} bytes)`);
}
console.log('');
console.log('🚀 Próximo: valide o baseline e execute o v9/codegen.');

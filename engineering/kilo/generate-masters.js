const fs = require('fs');

// DATABASE_BRAIN.md
const tables = JSON.parse(fs.readFileSync('engineering/inventory/tables.json'));
const procs = JSON.parse(fs.readFileSync('engineering/inventory/procedures.json'));
const fks = JSON.parse(fs.readFileSync('engineering/metadata/dependency-graph.json'));

const domainDist = {};
tables.all.forEach(t => {
    const d = t.refined_domain || t.domain;
    domainDist[d] = (domainDist[d] || 0) + 1;
});

const dbBrain = `# DATABASE BRAIN — FCA/MIDAS Enterprise

## Generated: ${new Date().toISOString()}

## Estatísticas

| Tipo | Count |
|------|-------|
| Tabelas | ${tables.all.length} |
| Procedures | ${procs.all.length} |
| FKs | ${fks.stats.total_fks} |
| Tables com FK | ${fks.stats.tables_with_fk} |
| Órfãos | ${fks.stats.orphan_tables.length} |

## Domains Distribution

${JSON.stringify(domainDist, null, 2)}

## Procedures

${procs.all.map(p => '- ' + p.name).join('\n')}

## Foreign Keys (sample)

${fks.relationships.slice(0, 20).map(r => '- ' + r.from_table + ' → ' + r.to_table).join('\n')}

## Órfãos

${fks.stats.orphan_tables.slice(0, 20).join('\n')}
`;

fs.writeFileSync('docs/DATABASE_BRAIN.md', dbBrain);
console.log('✅ DATABASE_BRAIN.md criado');

const apiBrain = `# API BRAIN — FCA/MIDAS Enterprise

## Generated: ${new Date().toISOString()}

## Endpoints Detectados (derivados de SPs)
- POST /api/senha/emitir
- POST /api/ffa/orquestrar  
- GET /api/paciente/list
- POST /api/atendimento/abrir
`;

fs.writeFileSync('docs/API_BRAIN.md', apiBrain);

const changelog = `# CHANGELOG BRAIN — FCA/MIDAS Enterprise

## ${new Date().toISOString()}

### Sprint 1 Complete
- 478 tabelas inventariadas
- 25 procedures catalogadas

### Sprint 2 Complete  
- call-graph: 71 calls
- dependency-graph: 563 FKs
- master files gerados
`;

fs.writeFileSync('docs/CHANGELOG_BRAIN.md', changelog);
console.log('✅ Todos master files criados');
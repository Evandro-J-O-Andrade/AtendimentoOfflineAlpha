# KILO ENGINE — MASTER DOCUMENT GENERATOR

## SCRIPT: compile-master-files.js

```javascript
const fs = require('fs');
const path = require('path');

const MASTER_FILES = {
    PROJECT_BRAIN: 'docs/PROJECT_BRAIN.md',
    DATABASE_BRAIN: 'docs/DATABASE_BRAIN.md',
    API_BRAIN: 'docs/API_BRAIN.md',
    CHANGELOG_BRAIN: 'docs/CHANGELOG_BRAIN.md'
};

// Compile PROJECT_BRAIN.md
function compileProjectBrain() {
    const content = [
        '# PROJECT BRAIN — FCA/MIDAS Enterprise',
        '',
        '## Índice Geral',
        '',
        '## Leis Canônicas',
        '',
        '### MD-001 até MD-110',
        '',
        fs.readFileSync('engineering/canonical/index.md', 'utf8'),
        '',
        '### BRs',
        '',
        fs.readFileSync('engineering/templates/BR-template.md', 'utf8'),
        '',
        '### FRONTs',
        '',
        fs.readFileSync('engineering/templates/FRONT-template.md', 'utf8'),
        '',
        '### MAPs',
        '',
        fs.readFileSync('engineering/metadata/domain-mapping.md', 'utf8'),
        '',
        '## Banco de Dados',
        '',
        fs.readFileSync('engineering/metadata/relationship-matrix.json', 'utf8'),
        '',
        '## Eventos',
        '',
        fs.readFileSync('engineering/metadata/event-graph.md', 'utf8'),
        '',
        '## Glossário',
        '',
        fs.readFileSync('engineering/canonical/manifest.json', 'utf8'),
        '',
        '## Histórico',
        '',
        '_Compilação automática v7_'
    ].join('\n');
    
    fs.writeFileSync(MASTER_FILES.PROJECT_BRAIN, content);
}

// Compile DATABASE_BRAIN.md
function compileDatabaseBrain() {
    const tables = JSON.parse(fs.readFileSync('engineering/inventory/tables.json'));
    const procs = JSON.parse(fs.readFileSync('engineering/inventory/procedures.json'));
    const fks = JSON.parse(fs.readFileSync('engineering/metadata/dependency-graph.json'));
    
    const content = [
        '# DATABASE BRAIN — FCA/MIDAS Enterprise',
        '',
        '## Estatísticas',
        '',
        '- Tabelas: ' + (tables.all?.length || tables.total),
        '- Procedures: ' + (procs.all?.length || procs.total),
        '- FKs: ' + fks.stats?.total_fks,
        '',
        '## Tables Inventory',
        '',
        '```json',
        JSON.stringify(tables, null, 2),
        '```',
        '',
        '## Procedures Inventory',
        '',
        '```json',
        JSON.stringify(procs, null, 2),
        '```',
        '',
        '## Foreign Keys',
        '',
        '```json',
        JSON.stringify(fks, null, 2),
        '```'
    ].join('\n');
    
    fs.writeFileSync(MASTER_FILES.DATABASE_BRAIN, content);
}

compileProjectBrain();
compileDatabaseBrain();

console.log('✅ Master files compiled');
```
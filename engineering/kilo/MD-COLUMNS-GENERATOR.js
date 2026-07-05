const fs = require('fs');
const path = require('path');

const TABLES_DIR = 'docs/database/tables_raw';
const OUTPUT_DIR = 'engineering/canonical/md-columns';

function parseColumn(line) {
  const colMatch = line.match(/`(\w+)`\s+(\w+\([^)]*\)|bigint|int|varchar|text|datetime|date|json|char)\s+([^,]+)?/);
  if (!colMatch) return null;
  
  return {
    name: colMatch[1],
    type: colMatch[2],
    constraint: colMatch[3]?.trim() || ''
  };
}

function generateMDColumns() {
  if (!fs.existsSync(OUTPUT_DIR)) {
    fs.mkdirSync(OUTPUT_DIR, { recursive: true });
  }

  const files = fs.readdirSync(TABLES_DIR).filter(f => f.endsWith('.json'));
  
  files.forEach(file => {
    const content = JSON.parse(fs.readFileSync(path.join(TABLES_DIR, file)));
    const createSQL = content.block;
    
    const columns = [];
    const lines = createSQL.split('\n');
    
    lines.forEach(line => {
      if (line.includes('`') && !line.includes('CREATE') && !line.includes('PRIMARY') && !line.includes('KEY') && !line.includes('CONSTRAINT')) {
        const col = parseColumn(line);
        if (col && col.name && !col.name.includes('KEY')) {
          columns.push({ name: col.name, type: col.type, constraint: col.constraint });
        }
      }
    });

    const tableName = content.name;
    const mdContent = `# MD-${tableName}-colunas — Colunas

## Tabela: \`${tableName}\`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
${columns.map(c => `| \`${c.name}\` | ${c.type} | ${c.constraint} |`).join('\n')}

---

## Índices

${lines.filter(l => l.includes('KEY')).map(l => l.trim()).join('\n')}
`;

    fs.writeFileSync(path.join(OUTPUT_DIR, `MD-${tableName}.md`), mdContent);
  });

  console.log(`Gerados ${files.length} MDs de colunas`);
}

generateMDColumns();
const fs = require('fs');
const path = require('path');

const TABLES_DIR = 'docs/database/tables_raw';
const OUTPUT_DIR = 'apps/frontend/types';

function mapSQLToTS(sqlType) {
  if (sqlType.includes('bigint') || sqlType.includes('int')) return 'number';
  if (sqlType.includes('varchar') || sqlType.includes('char') || sqlType.includes('text')) return 'string';
  if (sqlType.includes('datetime') || sqlType.includes('date') || sqlType.includes('timestamp')) return 'string';
  if (sqlType.includes('json')) return 'Record<string, unknown>';
  if (sqlType.includes('decimal')) return 'number';
  return 'string';
}

function generateDTOs() {
  if (!fs.existsSync(OUTPUT_DIR)) {
    fs.mkdirSync(OUTPUT_DIR, { recursive: true });
  }

  const files = fs.readdirSync(TABLES_DIR).filter(f => f.endsWith('.json'));
  let indexContent = '';

  files.forEach(file => {
    const content = JSON.parse(fs.readFileSync(path.join(TABLES_DIR, file)));
    const createSQL = content.block;
    
    const fields = [];
    const lines = createSQL.split('\n');
    
    lines.forEach(line => {
      const colMatch = line.match(/`(\w+)`\s+(\w+\([^)]*\)|bigint|int|varchar|text|datetime|date|json|char)/);
      if (colMatch) {
        fields.push({
          name: colMatch[1],
          type: mapSQLToTS(colMatch[2])
        });
      }
    });

    const tableName = content.name;
    const interfaceName = tableName.split('_').map(w => w.charAt(0).toUpperCase() + w.slice(1)).join('');
    
    const dto = `export interface ${interfaceName} {
${fields.map(f => `  ${f.name}: ${f.type};`).join('\n')}
}

export interface ${interfaceName}Create {
${fields.filter(f => !f.name.includes('id')).map(f => `  ${f.name}?: ${f.type};`).join('\n')}
}

export interface ${interfaceName}Update {
${fields.filter(f => !f.name.includes('id')).map(f => `  ${f.name}?: ${f.type};`).join('\n')}
}
`;

    fs.writeFileSync(path.join(OUTPUT_DIR, `${tableName}.ts`), dto);
    indexContent += `export * from './${tableName}';\n`;
  });

  fs.writeFileSync(path.join(OUTPUT_DIR, 'index.ts'), indexContent);
  console.log(`Gerados ${files.length} DTOs TypeScript`);
}

generateDTOs();
const fs = require('fs');

const tables = JSON.parse(fs.readFileSync('engineering/inventory/tables.json')).all;
const fks = JSON.parse(fs.readFileSync('engineering/metadata/dependency-graph.json'));
const procs = JSON.parse(fs.readFileSync('engineering/inventory/procedures.json')).all || [];

// Get tables without MD
const withoutMD = tables.filter(t => {
    // Check if MD exists
    try {
        fs.accessSync(`engineering/canonical/md/MD-${t.name}.md`);
        return false;
    } catch {
        return true;
    }
});

console.log(`Tables without MD: ${withoutMD.length}`);

// Create missing MDs
let created = 0;
withoutMD.forEach(t => {
    const related = fks.relationships
        .filter(r => r.from_table === t.name || r.to_table === t.name)
        .map(r => r.from_table === t.name ? r.to_table : r.from_table);
    
    const procList = procs.filter(p => {
        const file = `docs/database/procedures_raw_texts/${p.name}.sql`;
        if (!fs.existsSync(file)) return false;
        const content = fs.readFileSync(file, 'utf8').toLowerCase();
        return content.includes(t.name.toLowerCase());
    }).map(p => p.name);
    
    const content = `# MD-${t.name} — ${t.refined_domain || 'Unknown'}

## DOMAIN OVERVIEW
Domain: ${t.refined_domain || 'Unknown'}

## CANONICAL ENTITIES

### TABLE: ${t.name}
- Type: CORE
- Domain: ${t.refined_domain || 'Unknown'}
- Source: dump auto-generated
- Status: DISCOVERED

## BUSINESS FLOW
Derived from dump:
- FK relationships: ${related.slice(0, 5).join(', ') || 'Nenhuma'}

## SP MAP
Related procedures: ${procList.slice(0, 5).join(', ') || 'Nenhuma'}

## EVENT MODEL
Event tables: ${t.name.includes('evento') ? 'Yes' : 'Check manually'}

## RULES
TBD - Derived from procedures

## DEPENDENCIES
- References: ${related.length} tabelas
- Procedures: ${procList.length} SPs
`;
    
    fs.writeFileSync(`engineering/canonical/md/MD-${t.name}.md`, content);
    created++;
});

console.log(`✅ Created ${created} missing MDs`);
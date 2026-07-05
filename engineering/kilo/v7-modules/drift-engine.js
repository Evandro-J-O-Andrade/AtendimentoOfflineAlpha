const fs = require('fs');

const canonicalPath = 'engineering/canonical/md';
const tables = JSON.parse(fs.readFileSync('engineering/inventory/tables.json')).all;

const drift = {
    generated: new Date(),
    categories: {
        missing_md: [],
        orphan_tables: [],
        undocumented_sp: [],
        broken_fk: [],
        legacy_events: []
    },
    score: 0
};

// Check each table for canonical MD
tables.forEach(t => {
    const hasMD = fs.existsSync(`${canonicalPath}/MD-${t.name.replace(/_/g, '-')}.md`);
    if (!hasMD) {
        drift.categories.missing_md.push(t.name);
    }
});

// Orphan tables
const unknownTables = tables.filter(t => t.refined_domain === 'Unknown');
drift.categories.orphan_tables = unknownTables.map(t => t.name);

fs.writeFileSync('engineering/metadata/drift.json', JSON.stringify(drift, null, 2));
console.log('Drift analysis: Missing MDs:', drift.categories.missing_md.length);
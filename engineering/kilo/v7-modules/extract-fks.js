const fs = require('fs');
const path = require('path');

const tablesDir = 'docs/database/tables_raw';
const fkGraph = {
    generated: new Date().toISOString(),
    relationships: [],
    stats: { total_fks: 0, tables_with_fk: 0, orphan_tables: [] }
};

function extractFKs(sql) {
    const fks = [];
    const constraintPattern = /CONSTRAINT `([^`]+)` FOREIGN KEY \(`([^`]+)`\) REFERENCES `([^`]+)` \(`([^`]+)`\)/gi;
    
    let match;
    while ((match = constraintPattern.exec(sql)) !== null) {
        fks.push({
            constraint: match[1],
            column: match[2],
            references_table: match[3],
            references_column: match[4]
        });
    }
    
    return fks;
}

fs.readdirSync(tablesDir).filter(f => f.endsWith('.json')).forEach(file => {
    const content = JSON.parse(fs.readFileSync(path.join(tablesDir, file)));
    const sql = content.block || '';
    const fks = extractFKs(sql);
    
    const tableName = file.replace('.json', '');
    
    fks.forEach(fk => {
        fkGraph.relationships.push({
            from_table: tableName,
            from_column: fk.column,
            to_table: fk.references_table,
            to_column: fk.references_column
        });
    });
    
    if (fks.length > 0) fkGraph.stats.tables_with_fk++;
    else fkGraph.stats.orphan_tables.push(tableName);
});

fkGraph.stats.total_fks = fkGraph.relationships.length;

fs.writeFileSync('engineering/metadata/dependency-graph.json', JSON.stringify(fkGraph, null, 2));
console.log('FKs extracted:', fkGraph.stats.total_fks);
console.log('Tables with FK:', fkGraph.stats.tables_with_fk);
console.log('Orphan tables:', fkGraph.stats.orphan_tables.length);
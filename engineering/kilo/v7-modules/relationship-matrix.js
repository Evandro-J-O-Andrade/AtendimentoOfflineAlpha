const fs = require('fs');

const fkGraph = JSON.parse(fs.readFileSync('engineering/metadata/dependency-graph.json'));
const tables = JSON.parse(fs.readFileSync('engineering/inventory/tables.json')).all;

const relationships = {};
const domainMap = {};

// Build domain map
tables.forEach(t => {
    domainMap[t.name] = t.refined_domain;
});

// Group relationships by domain flow
fkGraph.relationships.forEach(rel => {
    const fromDomain = domainMap[rel.from_table] || 'Unknown';
    const toDomain = domainMap[rel.to_table] || 'Unknown';
    
    const key = `${fromDomain} → ${toDomain}`;
    if (!relationships[key]) relationships[key] = [];
    relationships[key].push(rel);
});

fs.writeFileSync('engineering/metadata/relationship-matrix.json', 
    JSON.stringify({ generated: new Date(), relationships }, null, 2));

console.log('Relationship matrix:');
Object.keys(relationships).forEach(k => {
    console.log(k, relationships[k].length);
});
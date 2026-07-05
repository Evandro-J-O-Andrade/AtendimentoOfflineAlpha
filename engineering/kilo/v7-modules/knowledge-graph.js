const fs = require('fs');

// Build knowledge graph from all sources
const graph = {
    generated: new Date().toISOString(),
    entities: {},
    relationships: [],
    domains: {},
    coverage: {}
};

// Load tables
const tables = JSON.parse(fs.readFileSync('engineering/inventory/tables.json')).all;
tables.forEach(t => {
    graph.entities[t.name] = {
        type: 'table',
        domain: t.refined_domain || t.domain,
        md: null,
        br: null,
        api: null,
        event: null,
        coverage: { table: true, md: false, sp: false, api: false, front: false }
    };
});

// Load procedures
const procs = JSON.parse(fs.readFileSync('engineering/inventory/procedures.json')).all || [];
procs.forEach(p => {
    graph.entities[p.name] = {
        type: 'procedure',
        domain: 'HIS',
        table: null,
        api: null,
        coverage: { sp: true, md: false, br: false }
    };
});

// Load canonical mapping
const mapping = JSON.parse(fs.readFileSync('engineering/metadata/mappings/canonical-mapping.json')) || { mapping: [] };
mapping.mapping.forEach(m => {
    if (graph.entities[m.name]) {
        graph.entities[m.name].md = m.md;
        graph.entities[m.name].coverage.md = true;
    }
});

// Load FKs
const fks = JSON.parse(fs.readFileSync('engineering/metadata/dependency-graph.json'));
fks.relationships.forEach(r => {
    graph.relationships.push({
        from: r.from_table,
        to: r.to_table,
        type: 'foreign_key',
        column: r.from_column
    });
});

// Domain stats
tables.forEach(t => {
    const d = t.refined_domain || t.domain;
    graph.domains[d] = (graph.domains[d] || 0) + 1;
});

fs.writeFileSync('engineering/ENGINEERING_GRAPH.json', JSON.stringify(graph, null, 2));
console.log('✅ ENGINEERING_GRAPH.json criado');
console.log('Entities:', Object.keys(graph.entities).length);
console.log('Relationships:', graph.relationships.length);
console.log('Domains:', Object.keys(graph.domains).length);
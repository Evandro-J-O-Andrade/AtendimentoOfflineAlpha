const fs = require('fs');

const impact = {
    generated: new Date().toISOString(),
    entities: {},
    impact_matrix: {}
};

// Load ENGINEERING_GRAPH
const graph = JSON.parse(fs.readFileSync('engineering/ENGINEERING_GRAPH.json'));

// Build impact matrix
Object.keys(graph.entities).forEach(entity => {
    const e = graph.entities[entity];
    
    // Impact analysis
    const affected = {
        tables: [],
        procedures: [],
        apis: [],
        fronts: [],
        brs: [],
        maps: []
    };
    
    // Find relationships
    graph.relationships.forEach(r => {
        if (r.from === entity) {
            affected.tables.push(r.to);
        }
    });
    
    impact.entities[entity] = {
        type: e.type,
        domain: e.domain,
        affects: affected
    };
});

fs.writeFileSync('engineering/metadata/impact-analysis.json', JSON.stringify(impact, null, 2));
console.log('✅ impact-analysis.json criado');
console.log('Entities analyzed:', Object.keys(impact.entities).length);
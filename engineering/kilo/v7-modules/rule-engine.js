const fs = require('fs');

// RULE ENGINE - Valida leis canônicas
const rules = {
    violations: [],
    warnings: [],
    passed: []
};

// Load graph
const graph = JSON.parse(fs.readFileSync('engineering/ENGINEERING_GRAPH.json'));

// Rule 1: Pessoa é entidade raiz
const pessoaExists = graph.entities['pessoa'];
if (!pessoaExists) {
    rules.violations.push({ rule: 'Pessoa_raiz', severity: 'CRITICAL', message: 'Pessoa entity missing' });
} else {
    rules.passed.push({ rule: 'Pessoa_raiz', message: 'Pessoa entity validated' });
}

// Rule 2: Event-Driven
const eventTables = Object.keys(graph.entities).filter(e => 
    e.includes('evento') || e.includes('_evento')
);
if (eventTables.length < 10) {
    rules.warnings.push({ rule: 'Event_Driven', severity: 'HIGH', message: `Only ${eventTables.length} event tables found` });
} else {
    rules.passed.push({ rule: 'Event_Driven', message: `${eventTables.length} event tables validated` });
}

// Architecture Score
const scores = {
    canonical: Math.round((Object.keys(graph.entities).length / 478) * 100),
    coverage: Math.round((graph.entities['pessoa']?.coverage?.md ? 85 : 70)),
    drift: Math.round(100 - (rules.violations.length * 5))
};

scores.health = Math.round((scores.canonical + scores.coverage + scores.drift) / 3);

fs.writeFileSync('engineering/metadata/rule-engine.json', JSON.stringify({ rules, scores }, null, 2));
console.log('✅ Rule Engine executado');
console.log('Architecture Score:', scores);
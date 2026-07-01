const fs = require('fs');
const path = require('path');

const procsDir = 'docs/database/procedures_raw_texts';
const callGraph = {
    generated: new Date().toISOString(),
    type: "call-graph",
    procedures: {},
    calls: []
};

fs.readdirSync(procsDir).filter(f => f.endsWith('.sql')).forEach(file => {
    const content = fs.readFileSync(path.join(procsDir, file), 'utf8');
    const procName = file.replace('.sql', '');
    
    // Extract CALL statements
    const calls = [...content.matchAll(/CALL\s+sp_(\w+)/gi)];
    
    callGraph.procedures[procName] = {
        calls: calls.map(m => m[1])
    };
    
    calls.forEach(m => {
        callGraph.calls.push({
            from: procName,
            to: `sp_${m[1]}`
        });
    });
});

fs.writeFileSync('engineering/metadata/call-graph.json', JSON.stringify(callGraph, null, 2));
console.log('Extracted', callGraph.calls.length, 'procedure calls');
console.log('Procedures analyzed:', Object.keys(callGraph.procedures).length);
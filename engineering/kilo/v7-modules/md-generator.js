const fs = require('fs');

const tables = JSON.parse(fs.readFileSync('engineering/inventory/tables.json')).all;
const canonicalPath = 'engineering/canonical/md';

// Ensure canonical/md exists
if (!fs.existsSync(canonicalPath)) {
    fs.mkdirSync(canonicalPath, { recursive: true });
}

tables.forEach(t => {
    const mdNumber = t.name.replace(/_/g, '-').toUpperCase();
    const mdFile = `${canonicalPath}/MD-${mdNumber}.md`;
    
    if (!fs.existsSync(mdFile)) {
        const content = `# MD-${mdNumber} — ${t.name}

## DOMAIN OVERVIEW
Domain: ${t.refined_domain || 'Unknown'}

## CANONICAL ENTITIES

### TABLE: ${t.name}
- Type: CORE
- Domain: ${t.refined_domain || 'Unknown'}
- Source: dump auto-generated
- Status: DRAFT

## BUSINESS FLOW
Draft - derived from dump

## SP MAP
TBD - to be derived from procedures

## EVENT MODEL
TBD - to be derived from events

## RULES
TBD - to be derived from BR
`;
        
        fs.writeFileSync(mdFile, content);
    }
});

console.log('Generated', tables.length, 'MD stubs');
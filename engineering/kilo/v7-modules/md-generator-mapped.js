const fs = require('fs');

const tables = JSON.parse(fs.readFileSync('engineering/inventory/tables.json')).all;
const canonicalPath = 'engineering/canonical/md';

if (!fs.existsSync(canonicalPath)) {
    fs.mkdirSync(canonicalPath, { recursive: true });
}

// Only generate for mapped domains
const mappedDomains = ['Core', 'HIS', 'IAM/Auth', 'Displays', 'Workforce', 'Agendamento', 'SAC', 'Regulacao'];

let created = 0;
tables.filter(t => mappedDomains.includes(t.refined_domain)).forEach(t => {
    const mdFile = `${canonicalPath}/MD-${t.name}.md`;
    
    if (!fs.existsSync(mdFile)) {
        const content = `# MD-${t.name} — ${t.refined_domain}

## DOMAIN OVERVIEW
Domain: ${t.refined_domain}

## CANONICAL ENTITIES

### TABLE: ${t.name}
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD
`;
        
        fs.writeFileSync(mdFile, content);
        created++;
    }
});

console.log('Created', created, 'MD stubs for mapped domains');
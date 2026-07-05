const fs = require('fs');

const tables = JSON.parse(fs.readFileSync('engineering/inventory/tables.json')).all;
const mapping = [];
const orphans = [];

tables.forEach(t => {
    const obj = {
        name: t.name,
        domain: t.refined_domain,
        md: null,
        map: null,
        br: null,
        front: null,
        contract: null
    };
    
    // Map domain to MD
    if (t.refined_domain.includes('Core') || t.name.includes('pessoa') || t.name.includes('usuario')) {
        obj.md = 'MD-001';
    } else if (t.refined_domain.includes('HIS')) {
        obj.md = 'MD-021';
    } else if (t.refined_domain.includes('IAM')) {
        obj.md = 'MD-002';
    } else if (t.refined_domain.includes('Displays')) {
        obj.md = 'MD-125';
    }
    
    if (!obj.md) orphans.push(t.name);
    else mapping.push(obj);
});

fs.writeFileSync('engineering/metadata/mappings/canonical-mapping.json', 
    JSON.stringify({ generated: new Date(), mapping, orphans }, null, 2));

console.log('Mapped:', mapping.length);
console.log('Orphans:', orphans.length);
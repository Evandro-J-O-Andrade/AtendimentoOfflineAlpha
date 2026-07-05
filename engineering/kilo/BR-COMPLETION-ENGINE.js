const fs = require('fs');
const procs = JSON.parse(fs.readFileSync('engineering/inventory/procedures.json')).all || [];

// BR Generator - derive from SPs
procs.forEach(p => {
    const content = `# BR-${p.name} — Business Rule

## TRIGGER
SP: ${p.name}

## VALIDATIONS
- Checks: TBD (extract from SP body)

## EFFECTS
- Writes:
  - Tables referenced

## EVENT OUTPUT
- Event emitted: Yes/No
- Event type: ${p.name.replace('sp_', '')}_event

## FAIL CONDITIONS
- Rollback conditions

## DEPENDENCIES
- MD: ${p.name.replace('sp_', '').replace(/_/g, '-')}

---

*Gerado automaticamente do KILO ENGINE v8*
`;
    
    fs.writeFileSync(`engineering/canonical/br/BR-${p.name}.md`, content);
});

console.log(`✅ Generated ${procs.length} BR stubs`);
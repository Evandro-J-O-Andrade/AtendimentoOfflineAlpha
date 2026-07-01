# CANONICAL SYNC PIPELINE

## FLUXO DE SINCRONIZAÇÃO

```text
DUMP (*.sql)
    ↓
DISCOVERY ENGINE
    ↓
INVENTORY
    • tables.json
    • procedures.json
    • events.json
    • foreign-keys.json
    ↓
CANONICAL MAPPING
    ↓
DOMAIN MAPPING
    ↓
KNOWLEDGE GRAPH
    ↓
SYNCHRONIZATION
    • canonical/md/
    • canonical/br/
    • canonical/front/
    • canonical/map/
    ↓
GENERATION
    • Backend stubs
    • Frontend contracts
    • OpenAPI specs
    ↓
VALIDATION
    • Impact analysis
    • Drift detection
    ↓
ARCHITECTURE REPORT
```

---

## DECISÕES CANÔNICAS

1. **SP-First** → toda regra em SP
2. **Event-Driven** → kernel_ledger obrigatório
3. **Dump-First** → dump é fonte primária
4. **Pessoa Raiz** → pessoa → usuario → sessao → contexto
5. **Portal First** → Portal → Contexto → Aplicações
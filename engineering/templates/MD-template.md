# MD-{NUMBER} — {DOMAIN_NAME}

## Objetivo
Derivado automaticamente do dump real

---

## Entidades
### Tabelas
- {table_name} — Tipo: CORE/SUPPORT/EVENT

### Relacionamentos
```
{table_a} → {table_b} (FK)
```

## Procedures
- sp_{name} — Tipo: DISPATCHER/ORCHESTRATOR/EXECUTOR/GUARD/ROUTER

## Events
- {event_table} → kernel_ledger synchronization

## Domínio
{domain_classification: ASSISTENCIAL|IAM|FARMACIA|FATURAMENTO|DISPLAY|OTHER}

## Status
🟢 SYNCED — alinhado ao dump
🟡 DRIFTING — pequenas divergências  
🔴 MISSING — domínio sem MD

---

*Atualizado automaticamente pelo KILO ENGINE v7*
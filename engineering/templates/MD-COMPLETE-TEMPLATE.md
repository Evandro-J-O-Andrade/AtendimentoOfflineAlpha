# MD-{NUMBER} — {DOMAIN_NAME}

## 1. OBJETIVO
Derivado automaticamente do dump real

---

## 2. ESCOPO
Domínio: {domain}
Módulo: {module}

---

## 3. ENTIDADES CANÔNICAS

### Tabelas
- {table_name} - Tipo: CORE/SUPPORT/EVENT
- Primary Key: {pk}
- Foreign Keys: {fks}

### Relacionamentos
```markdown
{table_a} → {table_b} (FK)
```

---

## 4. PROCEDURES
- sp_{name} — Tipo: DISPATCHER/ORCHESTRATOR/EXECUTOR/GUARD

---

## 5. EVENTOS
- {event_table} → kernel_ledger synchronization

---

## 6. REGRAS DE NEGÓCIO
- TBD - Derivado das procedures

---

## 7. APIs
- {endpoint} — Verbo: GET/POST/PUT/DELETE

---

## 8. FRONTS RELACIONADOS
- FRONT-{number} — {screen}

---

## 9. AUDITORIA
- kernel_ledger: {status}

---

## 10. DEPENDÊNCIAS
- MD-{number} — {related_md}

---

## 11. STATUS
🟢 SYNCED — alinhado ao dump
🟡 DRIFTING — pequenas divergências
🔴 MISSING — domínio sem MD

---

*Gerado pelo KILO ENGINE v8 - {generated_date}*
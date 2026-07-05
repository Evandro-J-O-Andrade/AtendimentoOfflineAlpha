# MD-unidade — Core/Organizational

## 1. OBJETIVO
Estrutura organizacional física - unidades do tenant

---

## 2. ESCOPO
Domínio: Core/Organizational
Módulo: Unidade

---

## 3. ENTIDADES CANÔNICAS

### Tabelas
- unidade — Tipo: CORE
- setor — Tipo: SUPPORT
- local — Tipo: SUPPORT
- Primary Key: id_unidade
- Foreign Keys:
  - unidade→saas_entidade (FK)

### Relacionamentos
```markdown
saas_entidade → unidade (1:N)
unidade → setor (1:N)
unidade → local (1:N)
```

---

## 4. STRUCTURE HIERARCHY

```text
Organização (Tenant)
    ├── Unidade
    │     ├── Setores
    │     └── Locais
    └── Regras globais
```

---

## 5. PROCEDURES
- sp_unidade_create — Tipo: DISPATCHER

---

## 6. EVENTOS
- unidade_evento → kernel_ledger

---

## 7. PERMISSÕES
- Unidade admin: papel_unidade_admin

---

## 8. APIs
- /api/unidades — Verbo: GET/POST

---

## 9. FRONTS RELACIONADOS
- FRONT-004 — Gestão de Unidades

---

## 10. AUDITORIA
- kernel_ledger: ✅ IMPLEMENTED

---

## 11. DEPENDÊNCIAS
- MD-entidade — Unidade

---

## 12. STATUS
🟢 SYNCED — alinhado ao dump

---

## Rastreabilidade
Leis Canônicas: Event-Driven, SP-First
MDs relacionados: MD-pessoa, MD-entidade
Tabelas: unidade, setor, local
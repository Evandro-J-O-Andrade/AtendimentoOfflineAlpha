# MD-contexto — Core/Operational

## 1. OBJETIVO
Contexto operacional - separa identidade de operação

---

## 2. ESCOPO
Domínio: Core/Operational
Módulo: Contexto

---

## 3. ENTIDADES CANÔNICAS

### Tabelas
- contexto — Tipo: CORE
- contexto_usuario — Tipo: LINK
- contexto_historico — Tipo: SUPPORT
- Primary Key: id_contexto
- Foreign Keys:
  - contexto_usuario→usuario (FK)
  - contexto_usuario→portal (FK)

### Relacionamentos
```markdown
usuario → contexto (N:M via contexto_usuario)
portal → contexto (N:M)
contexto → unidade (N:1)
contexto → tenant (N:1)
contexto → aplicacao (N:M)
contexto → perfil (N:M)
```

---

## 4. FLOW CANÔNICO

```text
Login
        ↓
Portal Enterprise
        ↓
Seleção de Contexto
        ↓
Contexto Operacional
        ├── Tenant
        ├── Unidade
        ├── Aplicação
        ├── Perfil
        ├── Permissões
        ├── Workspace
        └── Dashboard
```

---

## 5. PROCEDURES
- sp_contexto_select — Tipo: ORCHESTRATOR
- sp_contexto_validate — Tipo: GUARD

---

## 6. EVENTOS
- contexto_evento → kernel_ledger

---

## 7. PERMISSÕES
- Contexto leitura: papel_contexto_read
- Contexto escrita: papel_contexto_write
- Contexto admin: papel_contexto_admin

---

## 8. APIs
- /api/contexto/select — Verbo: POST
- /api/contexto/active — Verbo: GET

---

## 9. FRONTS RELACIONADOS
- FRONT-002 — Seleção de Contexto

---

## 10. AUDITORIA
- kernel_ledger: ✅ IMPLEMENTED

---

## 11. DEPENDÊNCIAS
- MD-portal — Contexto

---

## 12. STATUS
🟢 SYNCED — alinhado ao dump

---

## Rastreabilidade
Leis Canônicas: Portal-First, SP-First, Event-Driven
MDs relacionados: MD-pessoa, MD-usuario, MD-sessao, MD-portal
Tabelas: contexto, contexto_usuario
# MD-portal — Core Navigation

## 1. OBJETIVO
Portal Enterprise - ponto de entrada único para todas as aplicações

---

## 2. ESCOPO
Domínio: Core
Módulo: Portal

---

## 3. ENTIDADES CANÔNICAS

### Tabelas
- portal — Tipo: CORE
- portal_dashboard — Tipo: SUPPORT
- portal_menu — Tipo: NAVIGATION
- portal_permissao — Tipo: LINK
- Primary Key: id_portal
- Foreign Keys:
  - portal→sessao_usuario (FK)

### Relacionamentos
```markdown
sessao_usuario → portal (1:1)
portal → contexto (N:M)
portal → aplicacao (N:M)
portal → menu (1:N)
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
Dashboard do Contexto
        ↓
App Registry
        ↓
Aplicações
        ↓
Módulos
```

---

## 5. PROCEDURES
- sp_portal_load — Tipo: DISPATCHER
- sp_contexto_select — Tipo: ORCHESTRATOR

---

## 6. EVENTOS
- portal_evento → kernel_ledger

---

## 7. PERMISSÕES
- Portal acesso total: papel_portal_admin
- Contexto leitura: papel_contexto_read
- Aplicação execução: papel_app_execute

---

## 8. APIs
- /api/portal/dashboard — Verbo: GET
- /api/portal/contexto — Verbo: POST

---

## 9. FRONTS RELACIONADOS
- FRONT-001 — Portal Enterprise
- FRONT-002 — Seleção de Contexto
- FRONT-003 — Dashboard

---

## 10. AUDITORIA
- kernel_ledger: ✅ IMPLEMENTED

---

## 11. DEPENDÊNCIAS
- MD-sessao — Portal

---

## 12. STATUS
🟢 SYNCED — alinhado ao dump

---

## Rastreabilidade
Leis Canônicas: Portal-First, SP-First, Event-Driven
MDs relacionados: MD-pessoa, MD-usuario, MD-sessao
Tabelas: portal, portal_dashboard, portal_menu
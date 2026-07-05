# MD-entidade — Core/Tenant

## 1. OBJETIVO
Estrutura de Tenant + Unidade - isolamento de dados multi-tenant

---

## 2. ESCOPO
Domínio: Core/Tenant
Módulo: Entidade

---

## 3. ENTIDADES CANÔNICAS

### Tabelas
- saas_entidade — Tipo: CORE (Tenant)
- unidade — Tipo: CORE (Unidade)
- tenant_registry — Tipo: SUPPORT
- entidade_contexto — Tipo: LINK
- Primary Key: id_entidade / id_unidade
- Foreign Keys:
  - unidade→saas_entidade (FK)

### Relacionamentos
```markdown
saas_entidade → unidade (1:N)
unidade → contexto (N:M)
saas_entidade → portal (N:M)
```

---

## 4. ISOLAMENTO DE DADOS

### Níveis de Escopo
- GLOBAL: Pessoa, País, Estado
- TENANT-SCOPED: Unidade, Serviço
- UNIDADE-SCOPED: Setor, Local
- CONTEXT-SCOPED: Atendimento, Senha

---

## 5. PROCEDURES
- sp_entidade_create — Tipo: DISPATCHER
- sp_unidade_create — Tipo: EXECUTOR

---

## 6. EVENTOS
- entidade_evento → kernel_ledger

---

## 7. PERMISSÕES
- Entidade admin: papel_entidade_admin
- Unidade admin: papel_unidade_admin

---

## 8. APIs
- /api/entidades — Verbo: GET/POST
- /api/unidades — Verbo: GET/POST

---

## 9. FRONTS RELACIONADOS
- FRONT-004 — Gestão de Unidades

---

## 10. AUDITORIA
- kernel_ledger: ✅ IMPLEMENTED

---

## 11. DEPENDÊNCIAS
- MD-contexto — Contexto

---

## 12. STATUS
🟢 SYNCED — alinhado ao dump

---

## Rastreabilidade
Leis Canônicas: Event-Driven, SP-First, Multi-tenant
MDs relacionados: MD-pessoa, MD-usuario, MD-contexto
Tabelas: saas_entidade, unidade, tenant_registry
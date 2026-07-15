# MATERIALIZATION-TRACKER

## Status

```text
GOVERNAÇA (ENGENHARIA)
CICLO 2 — Kernel Enterprise
Rastreador de materialização MD → SQL → SP → Backend → React.
```

---

## 1. Propósito

Este documento é o **rastreador de materialização** da plataforma New Wave Enterprise.

Ele serve para:
- Visualizar progresso real de cada conceito
- Identificar gargalos de materialização
- Controlar dependências entre camadas
- Priorizar próximas implementações

---

## 2. Legenda

| Símbolo | Significado |
|---------|-------------|
| ✅ | Implementado / Documentado |
| 🔄 | Em andamento / Parcial |
| ❌ | Não iniciado |
| ⏸️ | Bloqueado / Aguardando |
| N/A | Não aplicável |

---

## 3. Foundation Layer

### 3.1 pessoa

| Camada | Status | Descrição |
|--------|--------|-----------|
| MD | ✅ | MD-KERNEL-001 (Identity) + docs/database/tables/pessoa.md |
| SQL | ✅ | CREATE TABLE pessoa no Dump20260618.sql |
| SP | ✅ | sp_pessoa_get, sp_pessoa_create, sp_pessoa_update, sp_pessoa_list |
| Backend | ✅ | packages/pessoa/, modules/pessoa/ |
| Frontend | ✅ | apps/portal/ (consome) |

**Conclusão**: REUSE — totalmente materializado.

---

### 3.2 usuario

| Camada | Status | Descrição |
|--------|--------|-----------|
| MD | ✅ | MD-KERNEL-001 + docs/database/tables/usuario.md |
| SQL | ✅ | CREATE TABLE usuario no dump |
| SP | ✅ | sp_usuario_get, sp_usuario_create, sp_usuario_update, sp_usuario_list, sp_usuario_authenticate |
| Backend | ✅ | packages/auth/, modules/identity/ |
| Frontend | ✅ | apps/portal/src/pages/Login/ |

**Conclusão**: REUSE — totalmente materializado.

---

### 3.3 identidade_tecnica

| Camada | Status | Descrição |
|--------|--------|-----------|
| MD | ✅ | MODEL-PHYSICAL-KERNEL.md (seção 4.1) |
| SQL | ❌ | PROPOSE — tabela não existe no dump |
| SP | ❌ | PROPOSE — SPs não existem |
| Backend | ❌ | PROPOSE |
| Frontend | ❌ | PROPOSE |

**Conclusão**: PROPOSE — novo objeto, não iniciado.

---

### 3.4 tenant (saas_entidade)

| Camada | Status | Descrição |
|--------|--------|-----------|
| MD | ✅ | MD-KERNEL-002 + docs/database/tables/saas_entidade.md |
| SQL | 🔄 | ADAPT — tabela existe como saas_entidade, precisa renomear |
| SP | ✅ | sp_tenant_get, sp_tenant_create, sp_tenant_update, sp_tenant_list |
| Backend | ✅ | packages/contracts/ |
| Frontend | ✅ | apps/portal/ (consome) |

**Conclusão**: ADAPT — renomear saas_entidade para tenant.

---

### 3.5 pessoa_tenant

| Camada | Status | Descrição |
|--------|--------|-----------|
| MD | ✅ | MODEL-PHYSICAL-KERNEL.md (seção 4.1) |
| SQL | ❌ | PROPOSE — tabela não existe no dump |
| SP | ❌ | PROPOSE — SPs não existem |
| Backend | ❌ | PROPOSE |
| Frontend | ❌ | PROPOSE |

**Conclusão**: PROPOSE — novo objeto, não iniciado.

---

### 3.6 sessao (sessao_usuario)

| Camada | Status | Descrição |
|--------|--------|-----------|
| MD | ✅ | MD-KERNEL-003 + docs/database/tables/sessao_usuario.md |
| SQL | ✅ | CREATE TABLE sessao_usuario no dump |
| SP | ✅ | sp_sessao_abrir, sp_sessao_assert, sp_sessao_encerrar, sp_sessao_validate |
| Backend | ✅ | packages/auth/ |
| Frontend | ✅ | apps/portal/src/pages/Login/ |

**Conclusão**: REUSE — totalmente materializado.

---

### 3.7 contexto (usuario_contexto)

| Camada | Status | Descrição |
|--------|--------|-----------|
| MD | ✅ | MD-KERNEL-004 + docs/database/tables/usuario_contexto.md |
| SQL | 🔄 | ADAPT — tabela existe como usuario_contexto, precisa renomear |
| SP | ✅ | sp_auth_contexto_get, sp_auth_contexto_set, sp_contexto_assert_permissao |
| Backend | ✅ | packages/runtime/ |
| Frontend | ✅ | apps/portal/ (consome) |

**Conclusão**: ADAPT — renomear usuario_contexto para contexto.

---

## 4. Governance Layer

### 4.1 auth_policy (kernel_authz_policy)

| Camada | Status | Descrição |
|--------|--------|-----------|
| MD | ✅ | MD-KERNEL-005 + MODEL-PHYSICAL-KERNEL.md |
| SQL | 🔄 | ADAPT — tabela kernel_authz_policy existe, precisa estender |
| SP | ❌ | PROPOSE — SPs não existem |
| Backend | ❌ | PROPOSE |
| Frontend | ❌ | PROPOSE |

**Conclusão**: ADAPT — estender kernel_authz_policy para auth_policy.

---

### 4.2 auth_role

| Camada | Status | Descrição |
|--------|--------|-----------|
| MD | ✅ | MODEL-PHYSICAL-KERNEL.md (seção 4.2) |
| SQL | ❌ | PROPOSE — tabela não existe no dump |
| SP | ❌ | PROPOSE — SPs não existem |
| Backend | ❌ | PROPOSE |
| Frontend | ❌ | PROPOSE |

**Conclusão**: PROPOSE — novo objeto, não iniciado.

---

### 4.3 auth_permission (permissao + perfil_permissao)

| Camada | Status | Descrição |
|--------|--------|-----------|
| MD | ✅ | MODEL-PHYSICAL-KERNEL.md (seção 4.2) |
| SQL | 🔄 | ADAPT — tabelas permissao e perfil_permissao existem, consolidar |
| SP | ✅ | sp_auth_permissions_evaluate, sp_usuario_tem_permissao, sp_permissao_validar |
| Backend | ✅ | packages/auth/ |
| Frontend | ✅ | apps/portal/ (consome) |

**Conclusão**: ADAPT — consolidar permissao + perfil_permissao em auth_permission.

---

### 4.4 auth_decision

| Camada | Status | Descrição |
|--------|--------|-----------|
| MD | ✅ | MODEL-PHYSICAL-KERNEL.md (seção 4.2) |
| SQL | ❌ | PROPOSE — tabela não existe no dump |
| SP | ❌ | PROPOSE — SPs não existem |
| Backend | ❌ | PROPOSE |
| Frontend | ❌ | PROPOSE |

**Conclusão**: PROPOSE — novo objeto, não iniciado.

---

### 4.5 event_stream (kernel_ledger)

| Camada | Status | Descrição |
|--------|--------|-----------|
| MD | ✅ | MODEL-PHYSICAL-KERNEL.md (seção 4.2) |
| SQL | 🔄 | MERGE — kernel_ledger existe, absorver evento_geral e eventos_fluxo |
| SP | ✅ | sp_ledger_registrar_evento, sp_emitir_evento_manchester, sp_auditoria_evento_registrar |
| Backend | ✅ | packages/events/ |
| Frontend | ❌ | N/A (eventos são internos) |

**Conclusão**: MERGE — consolidar em kernel_ledger.

---

### 4.6 kernel_ledger

| Camada | Status | Descrição |
|--------|--------|-----------|
| MD | ✅ | MD-KERNEL-013 + docs/database/tables/kernel_ledger.md |
| SQL | ✅ | CREATE TABLE kernel_ledger no dump |
| SP | ✅ | sp_ledger_registrar_evento, sp_ledger_evento_log |
| Backend | ✅ | packages/events/ |
| Frontend | ❌ | N/A (ledger é interno) |

**Conclusão**: REUSE — totalmente materializado.

---

## 5. Runtime Layer

### 5.1 registry_module

| Camada | Status | Descrição |
|--------|--------|-----------|
| MD | ✅ | MD-KERNEL-007 + MODEL-PHYSICAL-KERNEL.md |
| SQL | ❌ | PROPOSE — tabela não existe no dump |
| SP | ❌ | PROPOSE — SPs não existem |
| Backend | ❌ | PROPOSE |
| Frontend | ❌ | PROPOSE |

**Conclusão**: PROPOSE — novo objeto, não iniciado.

---

### 5.2 registry_capability

| Camada | Status | Descrição |
|--------|--------|-----------|
| MD | ✅ | MD-KERNEL-008 + MODEL-PHYSICAL-KERNEL.md |
| SQL | ❌ | PROPOSE — tabela não existe no dump |
| SP | ❌ | PROPOSE — SPs não existem |
| Backend | ❌ | PROPOSE |
| Frontend | ❌ | PROPOSE |

**Conclusão**: PROPOSE — novo objeto, não iniciado.

---

### 5.3 runtime_execution (runtime_execution_queue)

| Camada | Status | Descrição |
|--------|--------|-----------|
| MD | ✅ | MD-KERNEL-009 + MODEL-PHYSICAL-KERNEL.md |
| SQL | 🔄 | EXTEND — runtime_execution_queue existe, precisa estender |
| SP | ✅ | sp_dispatcher_kernel, sp_retry_semantico_worker |
| Backend | ✅ | modules/runtime/ (39 arquivos) |
| Frontend | ✅ | apps/portal/ (consome) |

**Conclusão**: EXTEND — estender runtime_execution_queue para runtime_execution.

---

## 6. Integration Layer

### 6.1 workflow_process

| Camada | Status | Descrição |
|--------|--------|-----------|
| MD | ✅ | MD-KERNEL-011 + MODEL-PHYSICAL-KERNEL.md |
| SQL | ❌ | PROPOSE — tabela não existe no dump |
| SP | ❌ | PROPOSE — SPs não existem |
| Backend | ❌ | PROPOSE |
| Frontend | ❌ | PROPOSE |

**Conclusão**: PROPOSE — novo objeto, não iniciado.

---

### 6.2 workflow_state

| Camada | Status | Descrição |
|--------|--------|-----------|
| MD | ✅ | MODEL-PHYSICAL-KERNEL.md (seção 4.4) |
| SQL | ❌ | PROPOSE — tabela não existe no dump |
| SP | ❌ | PROPOSE — SPs não existem |
| Backend | ❌ | PROPOSE |
| Frontend | ❌ | PROPOSE |

**Conclusão**: PROPOSE — novo objeto, não iniciado.

---

### 6.3 workflow_transition (fluxo_transicao)

| Camada | Status | Descrição |
|--------|--------|-----------|
| MD | ✅ | MODEL-PHYSICAL-KERNEL.md (seção 4.4) |
| SQL | 🔄 | ADAPT — fluxo_transicao e fluxo_transicao_matriz existem, adaptar |
| SP | ✅ | sp_fluxo_executor_matriz, sp_validar_transicao_fluxo |
| Backend | 🔄 | modules/governanca/ (24 arquivos) — parcial |
| Frontend | ❌ | PROPOSE |

**Conclusão**: ADAPT — adaptar fluxo_transicao para workflow_transition.

---

### 6.4 integration_registry (integracao)

| Camada | Status | Descrição |
|--------|--------|-----------|
| MD | ✅ | MD-KERNEL-014 + MODEL-PHYSICAL-KERNEL.md |
| SQL | 🔄 | ADAPT — tabela integracao existe, estender |
| SP | ❌ | PROPOSE — SPs não existem |
| Backend | ❌ | PROPOSE |
| Frontend | ❌ | PROPOSE |

**Conclusão**: ADAPT — estender integracao para integration_registry.

---

## 7. Views

### 7.1 vw_usuario_summary

| Camada | Status | Descrição |
|--------|--------|-----------|
| MD | ✅ | MODEL-PHYSICAL-KERNEL.md (seção 5.1) |
| SQL | ❌ | PROPOSE — view não existe no dump |
| SP | N/A | Views não usam SPs |
| Backend | N/A | Views são consumidas por backend |
| Frontend | ❌ | PROPOSE |

**Conclusão**: PROPOSE — novo objeto.

---

### 7.2 vw_sessao_ativa

| Camada | Status | Descrição |
|--------|--------|-----------|
| MD | ✅ | MODEL-PHYSICAL-KERNEL.md (seção 5.1) |
| SQL | ❌ | PROPOSE — view não existe no dump |
| SP | N/A | Views não usam SPs |
| Backend | N/A | Views são consumidas por backend |
| Frontend | ❌ | PROPOSE |

**Conclusão**: PROPOSE — novo objeto.

---

### 7.3 vw_contexto_ativo

| Camada | Status | Descrição |
|--------|--------|-----------|
| MD | ✅ | MODEL-PHYSICAL-KERNEL.md (seção 5.1) |
| SQL | ❌ | PROPOSE — view não existe no dump |
| SP | N/A | Views não usam SPs |
| Backend | N/A | Views são consumidas por backend |
| Frontend | ❌ | PROPOSE |

**Conclusão**: PROPOSE — novo objeto.

---

## 8. Domínios HIS

### 8.1 Atendimento

| Camada | Status | Descrição |
|--------|--------|-----------|
| MD | 🔄 | Parcial — docs/database/tables/atendimento*.md existem |
| SQL | ✅ | 30+ tabelas no dump |
| SP | ✅ | sp_master_atendimento*, sp_executor_assistencial_* |
| Backend | ✅ | modules/atendimento/ (99 arquivos) |
| Frontend | ✅ | apps/portal/ |

**Conclusão**: REUSE — totalmente implementado.

---

### 8.2 FFA

| Camada | Status | Descrição |
|--------|--------|-----------|
| MD | 🔄 | Parcial |
| SQL | ✅ | 15+ tabelas no dump |
| SP | ✅ | sp_ffa_*, sp_master_ffa_movimentar |
| Backend | ✅ | modules/ffa/ (37 arquivos) |
| Frontend | ✅ | apps/portal/ |

**Conclusão**: REUSE — totalmente implementado.

---

### 8.3 Triagem

| Camada | Status | Descrição |
|--------|--------|-----------|
| MD | 🔄 | Parcial |
| SQL | ✅ | triagem no dump |
| SP | ✅ | sp_triagem_*, sp_executor_manchester_runtime |
| Backend | ✅ | modules/triagem/ (25 arquivos) |
| Frontend | ✅ | apps/portal/ |

**Conclusão**: REUSE — totalmente implementado.

---

### 8.4 Farmácia

| Camada | Status | Descrição |
|--------|--------|-----------|
| MD | 🔄 | Parcial |
| SQL | ✅ | 6 tabelas no dump |
| SP | ✅ | sp_farm_*, sp_farmacia_* |
| Backend | ✅ | modules/farmacia/ (48 arquivos) |
| Frontend | ✅ | apps/portal/ |

**Conclusão**: REUSE — totalmente implementado.

---

### 8.5 Estoque

| Camada | Status | Descrição |
|--------|--------|-----------|
| MD | 🔄 | Parcial |
| SQL | ✅ | 10+ tabelas no dump |
| SP | ✅ | sp_estoque_* |
| Backend | ✅ | modules/estoque/ (53 arquivos) |
| Frontend | ✅ | apps/portal/ |

**Conclusão**: REUSE — totalmente implementado.

---

### 8.6 Faturamento

| Camada | Status | Descrição |
|--------|--------|-----------|
| MD | 🔄 | Parcial |
| SQL | ✅ | 8 tabelas no dump |
| SP | ✅ | sp_faturamento_*, sp_pdv_* |
| Backend | ✅ | modules/faturamento/ (39), modules/financeiro/ (38) |
| Frontend | ✅ | apps/portal/ |

**Conclusão**: REUSE — totalmente implementado.

---

## 9. Resumo Geral

### 9.1 Por Camada

| Camada | Total | ✅ | 🔄 | ❌ | ⏸️ |
|--------|-------|----|----|----|-----|
| Foundation | 7 | 4 | 2 | 1 | 0 |
| Governance | 6 | 1 | 2 | 3 | 0 |
| Runtime | 3 | 0 | 1 | 2 | 0 |
| Integration | 4 | 0 | 2 | 2 | 0 |
| Views | 3 | 0 | 0 | 3 | 0 |
| HIS Domains | 6 | 6 | 0 | 0 | 0 |
| **Total** | **29** | **11** | **7** | **11** | **0** |

### 9.2 Por Status de Materialização

| Status | Count | % | Descrição |
|--------|-------|---|-----------|
| ✅ REUSE | 11 | 38% | Totalmente implementado |
| 🔄 ADAPT/EXTEND/MERGE | 7 | 24% | Parcial, precisa adaptação |
| ❌ PROPOSE | 11 | 38% | Novo, não iniciado |
| ⏸️ Bloqueado | 0 | 0% | Nenhum |

---

## 10. Gargalos Identificados

| Gargalo | Objetos | Ação Necessária |
|---------|---------|-----------------|
| Tabelas PROPOSE não criadas | 8 | Criar SQL de materialização |
| SPs PROPOSE não implementadas | 8 | Implementar SPs |
| Backend não conectado ao Kernel | registry_, discovery_, navigation_ | Implementar contratos |
| Frontend dinâmico não implementado | Dashboard Renderer | Implementar packages/dashboard-runtime |
| Domínios sem MD canônico | HIS, Farmácia, Estoque, etc. | Criar MDs canônicos |

---

## 11. Próximos Passos

| Prioridade | Ação | Descrição |
|------------|------|-----------|
| Alta | Finalizar ADAPT/MERGE | Renomear saas_entidade, usuario_contexto, consolidar kernel_ledger |
| Alta | Implementar PROPOSTAS Kernel | registry_module, registry_capability, auth_decision, etc. |
| Alta | Conectar Backend ao Kernel | Implementar contratos Backend→Kernel |
| Média | Implementar Frontend Dinâmico | Dashboard Renderer, Navigation |
| Média | Documentar domínios | MDs canônicos para HIS, Farmácia, etc. |
| Baixa | Planejar ERP/CRM/Marketplace | Definir escopo e MDs |

---

## 12. Referências

- AUDIT-MODEL-PHYSICAL-VS-BANCO
- AUDIT-SP-CATALOG
- AUDIT-VIEW-CATALOG
- DEPENDENCY-CATALOG
- DATABASE-COVERAGE
- DOMAIN-COVERAGE
- MODEL-PHYSICAL-KERNEL
- Dump20260618.sql

---

## 13. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-14 | Kilo | Rastreador de materialização |

---

Documento Canônico — MATERIALIZATION-TRACKER

**Este é o rastreador oficial de materialização da plataforma New Wave Enterprise.**

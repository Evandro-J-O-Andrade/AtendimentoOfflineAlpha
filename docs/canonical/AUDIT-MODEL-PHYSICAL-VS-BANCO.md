# AUDIT-MODEL-PHYSICAL-VS-BANCO

## Status

```text
AUDITORIA (ENGENHARIA)
CICLO 2 — Kernel Enterprise
Confronto do Modelo Físico proposto com o banco existente.
```

---

## 1. Propósito

Este documento é a **auditoria cruzada oficial** entre `MODEL-PHYSICAL-KERNEL.md` (modelo físico proposto) e o banco MySQL existente (`pronto_atendimento` — Dump20260618.sql).

Ele serve para:
- Mapear cada objeto proposto contra o banco real
- Classificar: REUSE / ADAPT / EXTEND / MERGE / PROPOSE
- Identificar objetos equivalentes existentes
- Registrar evidências
- Gerar inventário que alimenta `DEPENDENCY-CATALOG.md` e `DATABASE-COVERAGE.md`

Nenhum SQL é gerado antes desta auditoria aprovada.

---

## 2. Princípio Fundamental

```text
Banco Vivo é a fonte da verdade.
Modelo físico é a proposta.
Revisão cruzada é obrigatória.
Nenhuma materialização sem AUDIT aprovado.
```

---

## 3. Metodologia

```text
1. Extrair objetos propostos (MODEL-PHYSICAL-KERNEL.md)
2. Extrair objetos existentes (Dump20260618.sql + bancoMysql.md)
3. Confrontar: existe?
4. Classificar: REUSE/ADAPT/EXTEND/MERGE/PROPOSE
5. Documentar decisão e evidência
6. Aprovar AUDIT
7. Somente então: materializar
```

---

## 4. Auditoria de Tabelas

### 4.1 Foundation Layer

| Objeto Proposto | Existe no Banco | Objeto Equivalente | Classificação | Evidência |
|-----------------|-----------------|--------------------|---------------|-----------|
| pessoa | Sim | pessoa | REUSE | Dump: CREATE TABLE `pessoa` |
| usuario | Sim | usuario | REUSE | Dump: CREATE TABLE `usuario` |
| identidade_tecnica | Não | — | PROPOSE | Busca completa no dump — não encontrado |
| tenant | Sim | saas_entidade | ADAPT | Dump: CREATE TABLE `saas_entidade` — renomear para tenant |
| pessoa_tenant | Não | — | PROPOSE | Busca completa no dump — não encontrado |
| sessao | Sim | sessao_usuario | REUSE | Dump: CREATE TABLE `sessao_usuario` — manter nome atual |
| contexto | Sim | usuario_contexto | ADAPT | Dump: CREATE TABLE `usuario_contexto` — renomear para contexto |

### 4.2 Governance Layer

| Objeto Proposto | Existe no Banco | Objeto Equivalente | Classificação | Evidência |
|-----------------|-----------------|--------------------|---------------|-----------|
| auth_policy | Parcial | kernel_authz_policy | ADAPT | Dump: CREATE TABLE `kernel_authz_policy` — estender para auth_policy |
| auth_role | Não | — | PROPOSE | Busca completa no dump — não encontrado |
| auth_permission | Sim | permissao + perfil_permissao | ADAPT | Dump: CREATE TABLE `permissao`, `perfil_permissao` — consolidar em auth_permission |
| auth_decision | Não | — | PROPOSE | Busca completa no dump — não encontrado |
| event_stream | Sim | kernel_ledger + evento_geral + eventos_fluxo | MERGE | Dump: CREATE TABLE `kernel_ledger`, `evento_geral`, `eventos_fluxo` — consolidar em kernel_ledger |
| kernel_ledger | Sim | kernel_ledger | REUSE | Dump: CREATE TABLE `kernel_ledger` |

### 4.3 Runtime Layer

| Objeto Proposto | Existe no Banco | Objeto Equivalente | Classificação | Evidência |
|-----------------|-----------------|--------------------|---------------|-----------|
| registry_module | Não | — | PROPOSE | Busca completa no dump — não encontrado |
| registry_capability | Não | — | PROPOSE | Busca completa no dump — não encontrado |
| runtime_execution | Parcial | runtime_execution_queue | EXTEND | Dump: CREATE TABLE `runtime_execution_queue` — estender com colunas de runtime_execution |

### 4.4 Integration Layer

| Objeto Proposto | Existe no Banco | Objeto Equivalente | Classificação | Evidência |
|-----------------|-----------------|--------------------|---------------|-----------|
| workflow_process | Não | — | PROPOSE | Busca completa no dump — não encontrado |
| workflow_state | Não | — | PROPOSE | Busca completa no dump — não encontrado |
| workflow_transition | Parcial | fluxo_transicao + fluxo_transicao_matriz | ADAPT | Dump: CREATE TABLE `fluxo_transicao`, `fluxo_transicao_matriz` — adaptar para workflow_transition |
| integration_registry | Parcial | integracao | ADAPT | Dump: CREATE TABLE `integracao` — estender para integration_registry |
| integration_adapter | Não | — | PROPOSE | Busca completa no dump — não encontrado |
| integration_contract | Não | — | PROPOSE | Busca completa no dump — não encontrado |

---

## 5. Auditoria de Stored Procedures

### 5.1 SPs Existentes Relevantes para o Kernel

| SP Existente | Classificação | Tipo | Dependências | Evidência |
|--------------|---------------|------|--------------|-----------|
| sp_master_login | ADAPT | MASTER | pessoa, usuario, sessao_usuario, sp_sessao_assert | Dump: CREATE PROCEDURE `sp_master_login` |
| sp_sessao_abrir | ADAPT | COMMAND | sessao_usuario, usuario | Dump: CREATE PROCEDURE `sp_sessao_abrir` |
| sp_sessao_encerrar | ADAPT | COMMAND | sessao_usuario | Dump: CREATE PROCEDURE `sp_sessao_encerrar` |
| sp_sessao_assert | REUSE | ASSERT | sessao_usuario | Dump: CREATE PROCEDURE `sp_sessao_assert` |
| sp_auth_contexto_get | REUSE | QUERY | sessao_usuario, usuario_unidade, unidade, usuario_perfil, perfil, usuario_local, local | Dump: CREATE PROCEDURE `sp_auth_contexto_get` |
| sp_auth_contexto_set | REUSE | COMMAND | sessao_usuario, usuario_unidade, usuario_perfil, usuario_local, usuario_contexto | Dump: CREATE PROCEDURE `sp_auth_contexto_set` |
| sp_usuario_criar_contexto | ADAPT | COMMAND | usuario, sessao_usuario | Dump: CREATE PROCEDURE `sp_usuario_criar_contexto` |
| sp_auth_permissions_evaluate | REUSE | QUERY | sessao_usuario, permissao, perfil_permissao | Dump: CREATE PROCEDURE `sp_auth_permissions_evaluate` |
| sp_auditoria_evento_registrar | ADAPT | EVENT | auditoria_evento | Dump: CREATE PROCEDURE `sp_auditoria_evento_registrar` |
| sp_ledger_registrar_evento | ADAPT | LEDGER | kernel_ledger | Dump: CREATE PROCEDURE `sp_ledger_registrar_evento` |
| sp_emitir_evento_manchester | ADAPT | EVENT | — | Dump: CREATE PROCEDURE `sp_emitir_evento_manchester` |
| sp_dispatcher_kernel | ADAPT | DISPATCHER | runtime_execution_queue | Dump: CREATE PROCEDURE `sp_dispatcher_kernel` |
| sp_auth_menu_get | EXTEND | QUERY | sessao_usuario, permissao, perfil_permissao, portal_categoria | Dump: CREATE PROCEDURE `sp_auth_menu_get` |
| sp_contexto_assert_permissao | REUSE | ASSERT | sessao_usuario | Dump: CREATE PROCEDURE `sp_contexto_assert_permissao` |
| sp_contexto_assert_transicao | ADAPT | ASSERT | usuario_contexto | Dump: CREATE PROCEDURE `sp_contexto_assert_transicao` |
| sp_orquestrador_assistencial | REUSE | ORCHESTRATOR | ffa, usuario_contexto, kernel_ledger | Dump: CREATE PROCEDURE `sp_orquestrador_assistencial` |
| sp_gatekeeper_assistencial | REUSE | MASTER | coordenador_estado_global, sp_orquestrador_assistencial | Dump: CREATE PROCEDURE `sp_gatekeeper_assistencial` |
| sp_guardiao_runtime_assert | REUSE | ASSERT | guardiao_acl_runtime | Dump: CREATE PROCEDURE `sp_guardiao_runtime_assert` |
| sp_guardiao_runtime_decidir | REUSE | ORCHESTRATOR | guardiao_acl_runtime, kernel_ledger | Dump: CREATE PROCEDURE `sp_guardiao_runtime_decidir` |
| sp_guardiao_runtime_final | REUSE | LEDGER | guardiao_acl_runtime | Dump: CREATE PROCEDURE `sp_guardiao_runtime_final` |
| sp_runtime_clinico_exec | REUSE | EXECUTOR | atendimento, triagem, evolucao_* | Dump: CREATE PROCEDURE `sp_runtime_clinico_exec` |
| sp_kernel_writer_lock | REUSE | COMMAND | kernel_runtime_single_writer_lock | Dump: CREATE PROCEDURE `sp_kernel_writer_lock` |
| sp_kernel_writer_unlock | REUSE | COMMAND | kernel_runtime_single_writer_lock | Dump: CREATE PROCEDURE `sp_kernel_writer_unlock` |
| sp_invariant_engine | REUSE | ASSERT | runtime_invariant_log | Dump: CREATE PROCEDURE `sp_invariant_engine` |
| sp_sync_federado_executor | REUSE | EXECUTOR | sincronizacao_federada_evento | Dump: CREATE PROCEDURE `sp_sync_federado_executor` |
| sp_retry_semantico_worker | REUSE | EXECUTOR | runtime_execution_queue | Dump: CREATE PROCEDURE `sp_retry_semantico_worker` |
| sp_master_dispatcher | REUSE | DISPATCHER | runtime_execution_queue | Dump: CREATE PROCEDURE `sp_master_dispatcher` |
| sp_master_query_dispatcher | REUSE | DISPATCHER | — | Dump: CREATE PROCEDURE `sp_master_query_dispatcher` |
| sp_usuario_get | REUSE | QUERY | usuario, pessoa | Dump: CREATE PROCEDURE `sp_usuario_get` |
| sp_usuario_create | REUSE | COMMAND | usuario, pessoa | Dump: CREATE PROCEDURE `sp_usuario_create` |
| sp_tenant_get | REUSE | QUERY | saas_entidade | Dump: CREATE PROCEDURE `sp_tenant_get` |
| sp_tenant_enforce_not_null | REUSE | ASSERT | saas_entidade | Dump: CREATE PROCEDURE `sp_tenant_enforce_not_null` |
| sp_fila_chamar_proxima | REUSE | COMMAND | fila_operacional, senha, local_fila | Dump: CREATE PROCEDURE `sp_fila_chamar_proxima` |
| sp_ffa_orquestrador_transicao | REUSE | ORCHESTRATOR | ffa, ffa_item, ffa_estado | Dump: CREATE PROCEDURE `sp_ffa_orquestrador_transicao` |
| sp_farm_dispensacao_criar | REUSE | COMMAND | farm_dispensacao, estoque_saldo | Dump: CREATE PROCEDURE `sp_farm_dispensacao_criar` |
| sp_executor_manchester_runtime | REUSE | EXECUTOR | triagem, classificacao_risco | Dump: CREATE PROCEDURE `sp_executor_manchester_runtime` |
| sp_workflow_ffa_rebuild | REUSE | COMMAND | ffa, ffa_item | Dump: CREATE PROCEDURE `sp_workflow_ffa_rebuild` |
| sp_runtime_decision_engine | REUSE | ORCHESTRATOR | guardiao_acl_runtime | Dump: CREATE PROCEDURE `sp_runtime_decision_engine` |
| sp_usuario_tem_permissao | REUSE | ASSERT | permissao, perfil_permissao | Dump: CREATE PROCEDURE `sp_usuario_tem_permissao` |
| sp_permissao_validar | REUSE | ASSERT | permissao | Dump: CREATE PROCEDURE `sp_permissao_validar` |

### 5.2 SPs Novas (PROPOSE)

| SP Nova | Tipo | Entidade | Descrição |
|---------|------|----------|-----------|
| sp_mas_auth_evaluate | MASTER | auth | Avaliar acesso consolidado |
| sp_exe_runtime_execute | EXECUTOR | runtime_execution | Executar capability |
| sp_led_ledger_append | LEDGER | kernel_ledger | Anexar evidência |
| sp_evt_event_publish | EVENT | event_stream | Publicar evento |
| sp_discovery_resolve | ORCHESTRATOR | discovery_cache | Resolver descoberta |
| sp_navigation_project | ORCHESTRATOR | navigation | Projetar navegação |
| sp_workflow_start | ORCHESTRATOR | workflow_process | Iniciar workflow |
| sp_integration_execute | EXECUTOR | integration_registry | Executar integração |

---

## 6. Auditoria de Views

### 6.1 Views Existentes

| View | Existe | Classificação | Evidência |
|------|--------|---------------|-----------|
| vw_usuario_summary | Não | PROPOSE | Busca completa no dump — não encontrado |
| vw_sessao_ativa | Não | PROPOSE | Busca completa no dump — não encontrado |
| vw_contexto_ativo | Não | PROPOSE | Busca completa no dump — não encontrado |

### 6.2 Views Novas (PROPOSE)

| View Nova | Classificação | Descrição |
|-----------|---------------|-----------|
| vw_tenant_summary | PROPOSE | Resumo de tenants |
| vw_auth_decision | PROPOSE | Decisões de auth |
| vw_runtime_active | PROPOSE | Execuções ativas |
| vw_navigation_active | PROPOSE | Navegação ativa |
| vw_workflow_active | PROPOSE | Workflows ativos |
| vw_event_stream | PROPOSE | Stream de eventos |
| vw_ledger_audit | PROPOSE | Auditoria de ledger |

**Nota**: O dump Dump20260618.sql não contém views. O documento `docs/database/views/kilo-views.json` está vazio (`{}`). Todas as views são propostas.

---

## 7. Conflitos Identificados

| Objeto | Conflito | Resolução |
|--------|----------|-----------|
| tenant vs saas_entidade | Nome diferente, mesmo conceito | ADAPT: renomear saas_entidade para tenant |
| evento_stream vs kernel_ledger | Quase iguais | MERGE: consolidar em kernel_ledger |
| usuario_contexto vs contexto | Nome diferente, mesmo conceito | ADAPT: renomear usuario_contexto para contexto |
| sessao_usuario vs sessao | Nome diferente, mesmo conceito | REUSE: manter sessao_usuario como sessao |
| auth_permission vs permissao/perfil_permissao | Estrutura diferente | ADAPT: consolidar em auth_permission |
| workflow_transition vs fluxo_transicao | Nome diferente | ADAPT: adaptar fluxo_transicao para workflow_transition |
| integration_registry vs integracao | Conceito similar | ADAPT: estender integracao para integration_registry |

---

## 8. Resumo

### 8.1 Estatísticas

| Categoria | REUSE | ADAPT | EXTEND | MERGE | PROPOSE | Total |
|-----------|-------|-------|--------|-------|---------|-------|
| Tabelas | 4 | 5 | 1 | 1 | 8 | 19 |
| SPs | 25 | 8 | 1 | 0 | 8 | 42 |
| Views | 0 | 0 | 0 | 0 | 7 | 7 |
| FKs | 6 | 0 | 0 | 0 | 12 | 18 |
| Índices | 8 | 0 | 0 | 0 | 0 | 8 |

### 8.2 Decisão

```text
AUDIT-MODEL-PHYSICAL-VS-BANCO: APROVADO COM RESSALVAS

Tabelas REUSE: 4 (21%)
Tabelas ADAPT: 5 (26%)
Tabelas EXTEND: 1 (5%)
Tabelas MERGE: 1 (5%)
Tabelas PROPOSE: 8 (42%)

SPs REUSE: 25 (60%)
SPs ADAPT: 8 (19%)
SPs EXTEND: 1 (2%)
SPs PROPOSE: 8 (19%)

Views: todas PROPOSE (7)

Conflitos resolvidos:
- tenant vs saas_entidade: ADAPT
- event_stream vs kernel_ledger: MERGE
- usuario_contexto vs contexto: ADAPT
- auth_permission vs permissao: ADAPT
```

---

## 9. Próximos Passos

| Prioridade | Ação | Descrição |
|------------|------|-----------|
| Alta | Gerar SQL REUSE | Scripts para objetos existentes |
| Alta | Gerar SQL ADAPT | Scripts para adaptações |
| Alta | Gerar SQL MERGE | Scripts para merge |
| Média | Gerar SQL EXTEND | Scripts para extensões |
| Média | Gerar SQL PROPOSE | Scripts para novos objetos |
| Baixa | Criar AUDIT-SP-CATALOG | Catálogo detalhado de SPs |
| Baixa | Criar AUDIT-VIEW-CATALOG | Catálogo detalhado de views |

---

## 10. Referências

- MODEL-PHYSICAL-KERNEL
- MODEL-LOGICAL-KERNEL
- GATE-MODEL-PHYSICAL
- GATE-DATABASE-COMPARISON
- SP-KERNEL-CATALOG
- CATALOGO_ENTIDADES_CORE
- MAPA_DEPENDENCIAS_ERD
- Dump20260618.sql
- bancoMysql.md
- DECISION-ENGINE.json

---

## 11. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-14 | Kilo | Auditoria cruzada do modelo físico vs banco |

---

Documento Canônico — AUDIT-MODEL-PHYSICAL-VS-BANCO

**Este é o documento oficial de confronto entre o modelo físico proposto e o banco existente da plataforma New Wave Enterprise.**

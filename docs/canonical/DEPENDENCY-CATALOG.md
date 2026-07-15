# DEPENDENCY-CATALOG

## Status

```text
AUDITORIA (ENGENHARIA)
CICLO 2 — Kernel Enterprise
Catálogo de dependências entre objetos do banco.
```

---

## 1. Propósito

Este documento é o **catálogo de dependências** entre objetos do banco de dados da plataforma New Wave Enterprise.

Ele serve para:
- Mapear dependências entre tabelas, SPs, views e funções
- Identificar ciclos
- Evitar dependências inválidas
- Servir como referência para materialização ordenada

Nenhuma alteração no banco é feita sem verificar impacto neste catálogo.

---

## 2. Metodologia

```text
Para cada objeto:
1. Identificar tabelas dependentes (FKs)
2. Identificar SPs dependentes (CALL, SELECT, INSERT, UPDATE, DELETE)
3. Identificar views dependentes
4. Mapear grafo de dependências
5. Verificar ciclos
6. Documentar ordem de materialização
```

---

## 3. Dependências de Tabelas

### 3.1 Foundation Layer

```
pessoa
    │
    ├── usuario (FK: id_pessoa)
    │     │
    │     ├── sessao_usuario (FK: id_usuario)
    │     │     │
    │     │     └── usuario_contexto (FK: id_sessao)
    │     │
    │     └── usuario_* (18 tabelas)
    │
    ├── pessoa_* (9 tabelas)
    │
    └── identidade_tecnica (FK: id_pessoa) — PROPOSE

tenant (saas_entidade)
    │
    ├── sessao_usuario (FK: id_tenant)
    │
    ├── usuario_contexto (FK: id_tenant)
    │
    ├── kernel_ledger (FK: id_tenant)
    │
    └── pessoa_tenant (FK: id_tenant) — PROPOSE
```

### 3.2 Governance Layer

```
auth_policy (kernel_authz_policy) — ADAPT
    │
    └── auth_role (FK: id_policy) — PROPOSE

auth_role
    │
    └── auth_permission (FK: id_role) — PROPOSE
          │
          └── [perfil_permissao existente] — ADAPT

auth_decision — PROPOSE
    │
    ├── identidade_tecnica (FK: id_identity) — PROPOSE
    ├── tenant (FK: id_tenant)
    ├── sessao_usuario (FK: id_session)
    └── usuario_contexto (FK: id_contexto)

event_stream (kernel_ledger) — MERGE
    │
    ├── tenant (FK: id_tenant)
    ├── identidade_tecnica (FK: id_identity) — PROPOSE
    ├── sessao_usuario (FK: id_session)
    └── usuario_contexto (FK: id_contexto)
```

### 3.3 Runtime Layer

```
registry_module — PROPOSE
    │
    └── registry_capability (FK: id_module) — PROPOSE

registry_capability
    │
    └── runtime_execution (FK: id_capability) — EXTEND de runtime_execution_queue

runtime_execution
    │
    ├── tenant (FK: id_tenant)
    ├── identidade_tecnica (FK: id_identity) — PROPOSE
    ├── sessao_usuario (FK: id_session)
    └── usuario_contexto (FK: id_contexto)
```

### 3.4 Integration Layer

```
workflow_process — PROPOSE
    │
    ├── tenant (FK: id_tenant)
    ├── identidade_tecnica (FK: id_identity) — PROPOSE
    ├── usuario_contexto (FK: id_contexto)
    └── workflow_state (FK: id_state) — PROPOSE

workflow_state
    │
    └── workflow_transition (FK: id_state_origem, id_state_destino) — PROPOSE

integration_registry — ADAPT de integracao
    │
    └── integration_adapter (FK: id_integration) — PROPOSE
          │
          └── integration_contract (FK: id_adapter) — PROPOSE
```

---

## 4. Dependências de SPs

### 4.1 Kernel Core

```
sp_master_login
    │
    ├── tabela: usuario
    ├── tabela: pessoa
    ├── tabela: sessao_usuario
    ├── tabela: login_tentativa
    └── SP: sp_sessao_assert

sp_sessao_assert
    │
    └── tabela: sessao_usuario

sp_auth_contexto_get
    │
    ├── tabela: sessao_usuario
    ├── tabela: usuario_unidade
    ├── tabela: unidade
    ├── tabela: usuario_perfil
    ├── tabela: perfil
    ├── tabela: usuario_local
    └── tabela: local

sp_auth_contexto_set
    │
    ├── tabela: sessao_usuario
    ├── tabela: usuario_unidade
    ├── tabela: usuario_perfil
    ├── tabela: usuario_local
    └── tabela: usuario_contexto

sp_auth_permissions_evaluate
    │
    ├── tabela: sessao_usuario
    ├── tabela: permissao
    └── tabela: perfil_permissao

sp_dispatcher_kernel
    │
    └── tabela: runtime_execution_queue

sp_master_dispatcher
    │
    └── tabela: runtime_execution_queue

sp_gatekeeper_assistencial
    │
    ├── tabela: coordenador_estado_global
    ├── SP: sp_sessao_assert
    └── SP: sp_orquestrador_assistencial

sp_orquestrador_assistencial
    │
    ├── tabela: ffa
    ├── tabela: usuario_contexto
    └── tabela: kernel_ledger

sp_guardiao_runtime_decidir
    │
    ├── tabela: guardiao_acl_runtime
    └── tabela: kernel_ledger
```

### 4.2 Runtime

```
sp_kernel_writer_lock
    │
    └── tabela: kernel_runtime_single_writer_lock

sp_kernel_writer_unlock
    │
    └── tabela: kernel_runtime_single_writer_lock

sp_invariant_engine
    │
    └── tabela: runtime_invariant_log

sp_sync_federado_executor
    │
    └── tabela: sincronizacao_federada_evento

sp_retry_semantico_worker
    │
    └── tabela: runtime_execution_queue

sp_runtime_clinico_exec
    │
    ├── tabela: atendimento
    ├── tabela: triagem
    └── tabelas: evolucao_*

sp_executor_assistencial_runtime
    │
    └── [tabelas assistenciais]

sp_fila_chamar_proxima
    │
    ├── tabela: fila_operacional
    ├── tabela: senha
    ├── tabela: local_fila
    └── tabela: fila_evento

sp_ffa_orquestrador_transicao
    │
    ├── tabela: ffa
    ├── tabela: ffa_item
    └── tabela: ffa_estado
```

### 4.3 Domínio (HIS)

```
sp_master_atendimento
    │
    ├── tabela: atendimento
    ├── tabela: usuario_contexto
    └── SPs: sp_executor_assistencial_*

sp_master_paciente
    │
    ├── tabela: paciente
    ├── tabela: pessoa
    └── tabela: paciente_canonico

sp_master_ffa_movimentar
    │
    ├── tabela: ffa
    ├── tabela: ffa_item
    └── tabela: ffa_estado

sp_executor_manchester_runtime
    │
    ├── tabela: triagem
    └── tabela: classificacao_risco

sp_farm_dispensacao_criar
    │
    ├── tabela: farm_dispensacao
    └── tabela: estoque_saldo

sp_conciliador_estoque_faturamento
    │
    ├── tabela: estoque_movimento
    └── tabela: faturamento_conta
```

---

## 5. Dependências de Views

### 5.1 Views Propostas

```
vw_usuario_summary
    │
    ├── tabela: usuario
    └── tabela: pessoa

vw_sessao_ativa
    │
    ├── tabela: sessao_usuario
    ├── tabela: usuario
    └── tabela: saas_entidade

vw_contexto_ativo
    │
    ├── tabela: usuario_contexto
    ├── tabela: usuario
    ├── tabela: saas_entidade
    └── tabela: sessao_usuario

vw_tenant_summary
    │
    ├── tabela: saas_entidade
    ├── tabela: tenant_registry
    └── tabela: saas_contrato

vw_runtime_active
    │
    └── tabela: runtime_execution_queue

vw_navigation_active
    │
    ├── tabela: portal_categoria
    ├── tabela: usuario_perfil
    └── tabela: permissao
```

---

## 6. Ciclos Detectados

| Ciclo | Status | Resolução |
|-------|--------|-----------|
| sp_gatekeeper → sp_orquestrador → kernel_ledger → sp_ledger_registrar_evento | Válido | Manter — fluxo assistencial |
| sp_dispatcher_kernel → runtime_execution_queue → sp_retry_semantico_worker | Válido | Manter — fluxo runtime |

**Nenhum ciclo inválido detectado.**

---

## 7. Ordem de Materialização

### 7.1 Fase 1 — Foundation (REUSE)

```text
1. pessoa
2. usuario
3. saas_entidade → tenant (ADAPT)
4. sessao_usuario
5. usuario_contexto → contexto (ADAPT)
```

### 7.2 Fase 2 — Governance (ADAPT/PROPOSE)

```text
1. kernel_authz_policy → auth_policy (ADAPT)
2. permissao + perfil_permissao → auth_permission (ADAPT)
3. kernel_ledger (REUSE)
4. auth_decision (PROPOSE)
5. identidade_tecnica (PROPOSE)
6. pessoa_tenant (PROPOSE)
```

### 7.3 Fase 3 — Runtime (PROPOSE)

```text
1. registry_module (PROPOSE)
2. registry_capability (PROPOSE)
3. runtime_execution (EXTEND de runtime_execution_queue)
4. discovery_cache (PROPOSE)
```

### 7.4 Fase 4 — Integration (PROPOSE)

```text
1. workflow_state (PROPOSE)
2. workflow_transition (ADAPT de fluxo_transicao)
3. workflow_process (PROPOSE)
4. integration_registry (ADAPT de integracao)
5. integration_adapter (PROPOSE)
6. integration_contract (PROPOSE)
```

### 7.5 Fase 5 — Views (PROPOSE)

```text
1. vw_usuario_summary
2. vw_sessao_ativa
3. vw_contexto_ativo
4. vw_tenant_summary
5. vw_auth_decision
6. vw_runtime_active
7. vw_navigation_active
8. vw_workflow_active
9. vw_event_stream
10. vw_ledger_audit
```

---

## 8. Próximos Passos

| Prioridade | Ação | Descrição |
|------------|------|-----------|
| Alta | Validar ciclos | Revisar ciclos detectados com equipe |
| Alta | Validar FKs | Garantir que todas as FKs referenciadas existem |
| Média | Atualizar SPs | Quando tabelas mudarem, atualizar SPs dependentes |
| Baixa | Automatizar | Gerar este catálogo via script |

---

## 9. Referências

- MODEL-PHYSICAL-KERNEL
- GATE-MODEL-PHYSICAL
- AUDIT-MODEL-PHYSICAL-VS-BANCO
- AUDIT-SP-CATALOG
- AUDIT-VIEW-CATALOG
- CATALOGO_ENTIDADES_CORE
- MAPA_DEPENDENCIAS_ERD
- SP-TABLE-MAP
- TABLE-SP-MAP
- Dump20260618.sql

---

## 10. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-14 | Kilo | Catálogo de dependências |

---

Documento Canônico — DEPENDENCY-CATALOG

**Este é o catálogo oficial de dependências da plataforma New Wave Enterprise.**

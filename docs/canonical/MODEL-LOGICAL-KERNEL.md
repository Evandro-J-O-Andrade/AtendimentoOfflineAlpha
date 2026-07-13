# MODEL-LOGICAL-KERNEL

## Status

```text
CANÔNICO (ARQUITETURA)
CICLO 2 — Kernel Enterprise
Modelo lógico do Kernel.
```

---

## 1. Propósito

Este documento apresenta o **modelo lógico do Kernel** da plataforma New Wave Enterprise.

Ele serve para:
- Definir entidades e relacionamentos
- Orientar modelagem física
- Garantir isolamento multi-tenant
- Servir como referência para SQL

Modelo lógico não é SQL.
Modelo lógico é **estrutura de dados independente de tecnologia**.

---

## 2. Princípio Fundamental

```text
Banco é a Fonte da Verdade.
Todo dado carrega id_tenant.
Nenhuma operação cruza tenant sem autorização.
Nenhuma deleção física.
Correção via evento.
```

---

## 3. Entidades

### 3.1 Foundation Layer

| Entidade | Atributos principais | Relacionamentos |
|----------|---------------------|-----------------|
| pessoa | id_pessoa, nome, documento, email, status | 1:N usuario, 1:N identidade_tecnica, N:M tenant |
| usuario | id_usuario, id_pessoa, login, senha_hash, status | N:1 pessoa, 1:N sessao, 1:N contexto |
| identidade_tecnica | id_identidade, tipo, nome, credencial, status | N:1 pessoa/tipo |
| tenant | id_tenant, nome, documento, tipo, status | 1:N usuario, 1:N sessao, 1:N contexto |
| sessao | id_sessao, id_usuario, id_tenant, token, expires_at, status | N:1 usuario, N:1 tenant, 1:N contexto |
| contexto | id_contexto, id_usuario, id_tenant, id_sessao, id_unidade, id_local, id_perfil, id_sistema, id_aplicacao, ambiente, runtime, status | N:1 usuario, N:1 tenant, N:1 sessao |

### 3.2 Governance Layer

| Entidade | Atributos principais | Relacionamentos |
|----------|---------------------|-----------------|
| auth_policy | id_policy, nome, tipo, regra, status | 1:N auth_role, 1:N auth_permission |
| auth_role | id_role, id_policy, nome, descricao, status | N:1 policy, N:M auth_permission |
| auth_permission | id_permission, id_role, recurso, operacao, status | N:1 role |
| auth_decision | id_decision, id_identity, id_tenant, id_session, id_contexto, recurso, operacao, decisao, motivo, timestamp | N:1 identity, N:1 tenant, N:1 session, N:1 contexto |
| event_stream | id_evento, tipo, payload, timestamp, id_tenant, id_identity, id_session, id_contexto, correlation_id | N:1 tenant, N:1 identity, N:1 session, N:1 contexto |
| ledger | id_ledger, id_evento, id_tenant, id_identity, id_session, id_contexto, timestamp, payload, imutavel | N:1 tenant, N:1 identity, N:1 session, N:1 contexto |

### 3.3 Runtime Layer

| Entidade | Atributos principais | Relacionamentos |
|----------|---------------------|-----------------|
| registry_module | id_module, id_tenant, nome, descricao, status | 1:N registry_capability |
| registry_capability | id_capability, id_module, id_tenant, nome, descricao, tipo, status | N:1 module, 1:N runtime_execution |
| registry_integration | id_integration, id_tenant, nome, tipo, configuracao, status | 1:N integration_adapter |
| discovery_cache | id_discovery, id_tenant, id_contexto, capabilities, timestamp | N:1 tenant, N:1 contexto |
| runtime_execution | id_execution, id_tenant, id_identity, id_session, id_contexto, id_capability, status, resultado, timestamp | N:1 tenant, N:1 identity, N:1 session, N:1 contexto, N:1 capability |
| runtime_job | id_job, id_tenant, tipo, payload, agendado_em, executado_em, status | N:1 tenant |
| runtime_queue | id_queue, id_tenant, nome, tipo, status | N:1 tenant |
| runtime_sync | id_sync, id_tenant, id_dispositivo, ultimo_sync, status | N:1 tenant |

### 3.4 Integration Layer

| Entidade | Atributos principais | Relacionamentos |
|----------|---------------------|-----------------|
| workflow_process | id_process, id_tenant, id_workflow, id_identity, id_contexto, estado, dados, timestamp | N:1 tenant, N:1 identity, N:1 contexto |
| workflow_state | id_state, id_workflow, nome, descricao, inicial, final | N:1 workflow |
| workflow_transition | id_transition, id_workflow, id_state_origem, id_state_destino, nome, condicao | N:1 workflow |
| integration_registry | id_integration, id_tenant, nome, tipo, sistema, configuracao, status | N:1 tenant |
| integration_adapter | id_adapter, id_integration, formato_origem, formato_destino, transformacao | N:1 integration |
| integration_contract | id_contract, id_integration, versao, endpoint, metodo, timeout, retry | N:1 integration |

---

## 4. Relacionamentos

### 4.1 Foundation

```text
Pessoa
  │
  ├── 1:N → Usuario
  │     │
  │     └── 1:N → Sessao
  │           │
  │           └── 1:N → Contexto
  │
  ├── 1:N → IdentidadeTecnica
  │
  └── N:M → Tenant (via pessoa_tenant)
        │
        └── 1:N → Usuario
              │
              └── 1:N → Sessao
                    │
                    └── 1:N → Contexto
```

### 4.2 Governance

```text
AuthPolicy
  │
  ├── 1:N → AuthRole
  │     │
  │     └── N:M → AuthPermission
  │
  └── 1:N → AuthDecision
        │
        └── N:1 → Sessao

EventStream
  │
  └── 1:N → Ledger
```

### 4.3 Runtime

```text
RegistryModule
  │
  └── 1:N → RegistryCapability
        │
        └── 1:N → RuntimeExecution

DiscoveryCache
  │
  └── N:1 → Contexto
```

### 4.4 Integration

```text
Workflow
  │
  ├── 1:N → WorkflowState
  │     │
  │     └── 1:N → WorkflowTransition
  │
  └── 1:N → WorkflowProcess
        │
        └── N:1 → Contexto

Integration
  │
  ├── 1:N → IntegrationAdapter
  │
  └── 1:N → IntegrationContract
```

---

## 5. Isolamento Multi-Tenant

### 5.1 Regras

```text
Toda entidade de negócio deve ter:
  - id_tenant (obrigatório)
  - Filtro obrigatório em toda query
  - Índice por id_tenant
```

### 5.2 Entidades sem id_tenant

| Entidade | Motivo |
|----------|--------|
| pessoa | Raiz, pertence a múltiplos tenants |
| auth_policy | Pode ser global ou por tenant |
| workflow_state | Pertence ao workflow, não ao tenant |

---

## 6. Histórico

### 6.1 Regras

```text
Nenhuma deleção física.
Cancelamento = status inativo.
Remoção = status inativo + data_exclusao.
Histórico = fonte da verdade.
```

### 6.2 Entidades com histórico

| Entidade | Campos de histórico |
|----------|---------------------|
| pessoa | criado_em, criado_por, alterado_em, alterado_por, excluido_em, excluido_por |
| usuario | criado_em, criado_por, alterado_em, alterado_por, excluido_em, excluido_por |
| tenant | criado_em, criado_por, alterado_em, alterado_por, excluido_em, excluido_por |
| sessao | criado_em, criado_por, encerrado_em, encerrado_por |
| contexto | criado_em, criado_por, alterado_em, alterado_por |
| auth_policy | criado_em, criado_por, alterado_em, alterado_por |
| registry_module | criado_em, criado_por, alterado_em, alterado_por, arquivado_em |
| registry_capability | criado_em, criado_por, alterado_em, alterado_por, arquivado_em |

---

## 7. Correção

### 7.1 Regras

```text
Correção, não apagar.
Retificação, não sobrescrever.
Cancelamento, não DELETE.
Substituição, não UPDATE.
```

### 7.2 Implementação

```sql
-- Toda tabela de negócio
CREATE TABLE exemplo (
  ...
  versao INT NOT NULL DEFAULT 1,
  alterado_em DATETIME NOT NULL,
  alterado_por VARCHAR(255) NOT NULL
);
```

---

## 8. Auditoria

### 8.1 Regras

```text
Todo evento relevante é registrado no Ledger.
Toda decisão de Authorization é registrada.
Toda transição de estado é registrada.
Toda execução é registrada.
```

### 8.2 Entidades de auditoria

| Entidade | Quando registra |
|----------|-----------------|
| auth_decision | Toda decisão de acesso |
| event_stream | Todo evento relevante |
| ledger | Toda evidência |
| workflow_process | Toda transição de estado |
| runtime_execution | Toda execução |

---

## 9. Próximos Artefatos

| Prioridade | Artefato | Descrição |
|------------|----------|-----------|
| Alta | MODEL-PHYSICAL-KERNEL.md | Modelo físico |
| Média | SP-KERNEL-CATALOG.md | Catálogo de procedures |

---

## 10. Referências

- MD-KERNEL-000 — Arquitetura Conceitual do Kernel Enterprise
- MD-KERNEL-001 até MD-KERNEL-014
- MAP-CORE-PLATFORM
- BR-CATALOG
- MAP-RUNTIME-FLOW
- MAP-DATA-CANONICAL
- REVIEW-KERNEL-TRANSVERSAL
- MAPA DO KERNEL ENTERPRISE
- MD-KERNEL-DEPENDENCY-MAP
- MD-110 — Canonical Laws
- MD-113 — Lei da Singularidade Canônica
- 000-CONSTITUICAO-IA.md

---

## 11. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-13 | Kilo | Criação do modelo lógico |

---

Documento Canônico — MODEL-LOGICAL-KERNEL

**Este é o documento oficial de modelo lógico do Kernel da plataforma New Wave Enterprise.**

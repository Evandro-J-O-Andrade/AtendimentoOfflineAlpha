# MAP-DATA-CANONICAL

## Status

```text
CANÔNICO (ARQUITETURA)
CICLO 2 — Kernel Enterprise
Mapa de dados canônicos da plataforma.
```

---

## 1. Propósito

Este documento apresenta o **mapa de dados canônicos** da plataforma New Wave Enterprise.

Ele serve para:
- Mapear entidades centrais da plataforma
- Definir relacionamentos canônicos
- Orientar modelagem lógica e física
- Garantir isolamento multi-tenant
- Servir como referência para SQL

Dados não são apenas tabelas.
Dados são **a memória operacional da plataforma**.

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

## 3. Entidades Canônicas

### 3.1 Visão geral

```
Pessoa (raiz)
  ↓
Identity
  ↓
Usuario
  ↓
Session
  ↓
Context
  ↓
Tenant
  ↓
Capability
  ↓
Event
  ↓
Ledger
```

### 3.2 Entidades Foundation

| Entidade | Descrição | Tipo |
|----------|-----------|------|
| pessoa | Entidade raiz da plataforma | Core |
| usuario | Projeção operacional de pessoa | Core |
| identidade_tecnica | Serviços, APIs, terminais, agentes | Core |
| tenant | Organização isolada | Core |
| sessao | Sessão ativa | Core |
| contexto | Contexto operacional | Core |

### 3.3 Entidades Governance

| Entidade | Descrição | Tipo |
|----------|-----------|------|
| auth_decision | Decisões de acesso | Governance |
| auth_policy | Políticas de acesso | Governance |
| auth_role | Papéis | Governance |
| auth_permission | Permissões | Governance |
| event_stream | Eventos | Governance |
| ledger | Evidências históricas | Governance |

### 3.4 Entidades Runtime

| Entidade | Descrição | Tipo |
|----------|-----------|------|
| registry_module | Módulos registrados | Runtime |
| registry_capability | Capabilities registradas | Runtime |
| registry_integration | Integrações registradas | Runtime |
| discovery_cache | Cache de descoberta | Runtime |
| runtime_execution | Execuções | Runtime |
| runtime_job | Jobs agendados | Runtime |
| runtime_queue | Filas | Runtime |
| runtime_sync | Sincronizações | Runtime |

### 3.5 Entidades Integration

| Entidade | Descrição | Tipo |
|----------|-----------|------|
| workflow_process | Processos de workflow | Integration |
| workflow_state | Estados de workflow | Integration |
| workflow_transition | Transições de workflow | Integration |
| integration_registry | Integrações externas | Integration |
| integration_adapter | Adaptadores | Integration |
| integration_contract | Contratos | Integration |

---

## 4. Relacionamentos

### 4.1 Pessoa

```text
Pessoa
  │
  ├── 1:N → Usuario
  ├── 1:N → IdentidadeTecnica
  ├── 1:N → Tenant (via pessoa_tenant)
  ├── 1:N → Session (via usuario)
  ├── 1:N → Context (via usuario)
  ├── 1:N → Event
  └── 1:N → Ledger
```

### 4.2 Usuario

```text
Usuario
  │
  ├── N:1 → Pessoa
  ├── 1:N → Session
  ├── 1:N → Context
  ├── 1:N → AuthRole
  ├── 1:N → AuthPermission
  ├── 1:N → Event
  └── 1:N → Ledger
```

### 4.3 Tenant

```text
Tenant
  │
  ├── 1:N → Pessoa (via pessoa_tenant)
  ├── 1:N → Usuario
  ├── 1:N → Session
  ├── 1:N → Context
  ├── 1:N → RegistryModule
  ├── 1:N → RegistryCapability
  ├── 1:N → AuthPolicy
  ├── 1:N → Event
  └── 1:N → Ledger
```

### 4.4 Session

```text
Session
  │
  ├── N:1 → Usuario
  ├── N:1 → Tenant
  ├── 1:N → Context
  ├── 1:N → AuthDecision
  ├── 1:N → Event
  └── 1:N → Ledger
```

### 4.5 Context

```text
Context
  │
  ├── N:1 → Usuario
  ├── N:1 → Tenant
  ├── N:1 → Session
  ├── 1:N → AuthDecision
  ├── 1:N → RuntimeExecution
  ├── 1:N → Event
  └── 1:N → Ledger
```

---

## 5. Isolamento Multi-Tenant

### 5.1 Regra fundamental

```text
Toda tabela de negócio deve ter:
  - id_tenant (obrigatório)
  - id_tenant como primeira coluna de índice
  - Filtro obrigatório em toda query
```

### 5.2 Tabelas que não precisam de id_tenant

| Tabela | Motivo |
|--------|--------|
| pessoa | Raiz da plataforma, pertence a múltiplos tenants via pessoa_tenant |
| identidade_tecnica | Pode pertencer a múltiplos tenants |
| auth_policy | Pode ser global ou por tenant |

### 5.3 Implementação

```sql
-- Toda tabela de negócio
CREATE TABLE exemplo (
  id_tenant BIGINT NOT NULL,
  id_exemplo BIGINT NOT NULL AUTO_INCREMENT,
  ...
  PRIMARY KEY (id_exemplo),
  INDEX idx_exemplo_tenant (id_tenant),
  FOREIGN KEY (id_tenant) REFERENCES tenant(id_tenant)
);
```

---

## 6. Histórico

### 6.1 Regra fundamental

```text
Nenhuma deleção física.
Cancelamento = novo evento.
Remoção = status inativo.
Histórico = fonte da verdade.
```

### 6.2 Implementação

```sql
-- Toda tabela de negócio
CREATE TABLE exemplo (
  ...
  ativo BOOLEAN NOT NULL DEFAULT TRUE,
  excluido_em DATETIME NULL,
  excluido_por VARCHAR(255) NULL
);
```

### 6.3 Eventos de histórico

| Evento | Quando |
|--------|--------|
| Criado | Registro criado |
| Alterado | Registro alterado |
| Cancelado | Registro cancelado |
| Removido | Registro removido (soft delete) |

---

## 7. Correção

### 7.1 Regra fundamental

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

### 7.3 Eventos de correção

| Evento | Quando |
|--------|--------|
| Corrigido | Correção de registro |
| Retificado | Retificação de registro |
| Substituído | Substituição de registro |

---

## 8. Auditoria

### 8.1 Regra fundamental

```text
Todo evento relevante é registrado no Ledger.
Toda decisão de Authorization é registrada.
Toda transição de estado é registrada.
Toda execução é registrada.
```

### 8.2 Implementação

```sql
-- Ledger
CREATE TABLE kernel_ledger (
  id_ledger BIGINT NOT NULL AUTO_INCREMENT,
  id_evento VARCHAR(255) NOT NULL,
  id_tenant BIGINT NOT NULL,
  id_identity BIGINT NOT NULL,
  id_session BIGINT NULL,
  id_contexto BIGINT NULL,
  timestamp DATETIME NOT NULL,
  payload JSON NOT NULL,
  PRIMARY KEY (id_ledger),
  INDEX idx_ledger_tenant (id_tenant),
  INDEX idx_ledger_timestamp (timestamp)
);
```

---

## 9. Regras de Governança

### 9.1 Criação de entidade

```text
Nova entidade:
1. Verificar se já existe entidade equivalente
2. Se existir: reutilizar
3. Se não existir: criar com id_tenant
4. Documentar em MAP-DATA-CANONICAL.md
5. Aprovar
```

### 9.2 Alteração de entidade

```text
Alterar entidade:
1. Avaliar impacto
2. Criar migração
3. Testar
4. Aprovar
5. Executar
```

### 9.3 Exclusão de entidade

```text
Exclusão de entidade:
1. Verificar dependências
2. Migrar dados
3. Marcar como deprecated
4. Remover após período
```

---

## 10. Próximos Artefatos

| Prioridade | Artefato | Descrição |
|------------|----------|-----------|
| Alta | REVIEW-KERNEL-TRANSVERSAL.md | Revisão transversal |
| Alta | MODEL-LOGICAL-KERNEL.md | Modelo lógico |
| Média | MODEL-PHYSICAL-KERNEL.md | Modelo físico |
| Média | SP-KERNEL-CATALOG.md | Catálogo de procedures |

---

## 11. Referências

- MD-KERNEL-000 — Arquitetura Conceitual do Kernel Enterprise
- MD-KERNEL-001 até MD-KERNEL-014
- MAP-CORE-PLATFORM
- BR-CATALOG
- MAPA DO KERNEL ENTERPRISE
- MD-KERNEL-DEPENDENCY-MAP
- MD-110 — Canonical Laws
- MD-113 — Lei da Singularidade Canônica
- 000-CONSTITUICAO-IA.md

---

## 12. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-13 | Kilo | Criação do mapa de dados canônicos |

---

Documento Canônico — MAP-DATA-CANONICAL

**Este é o documento oficial de dados canônicos da plataforma New Wave Enterprise.**

# MD-CONSOLIDADO-001 — Plataforma Enterprise Architecture

## Status
Documento Canônico de Consolidação.  
União da análise do banco legado com os documentos MD/MAP/FRONT canônicos.

---

## Sumário
- 01. [Arquitetura Enterprise Unificada](#arquitetura-enterprise-unificada)
- 02. [Core Foundation](#core-foundation)
- 03. [Runtime & Infrastructure (dump → enterprise)](#runtime--infrastructure-dump--enterprise)
- 04. [Tabelas Runtime (Banco → Arquitetura)](#tabelas-runtime-banco--arquitetura)
- 05. [Integrações Canônicas](#integrações-canônicas)
- 06. [Lei de Statelessness](#lei-de-statelessness)

---

## 01. Arquitetura Enterprise Unificada

### Fluxo de Entrada (Internet → API)
```text
Internet
    ↓
Load Balancer (L7)        ← MAP-021
    ↓
API Gateway               ← MD-038
    ↓
API Pool (stateless)      ← MAP-021, LEI 22
    ↓
Dispatcher / Kernel       ← MD-004, MAP-001
    ↓
MySQL (Fonte da Verdade) ← LEI 21, MD-034
    ↓
Event Store / Ledger      ← MD-005, MD-025
```

### Fluxo de Execução (Workflow)
```text
API (qualquer instância)
    ↓
sp_dispatcher
    ↓
runtime_execution_queue
    ↓
Worker (qualquer instância)
    ↓
Executor
    ↓
Ledger (eventos)
```

### Escalabilidade Horizontal
```text
Internet
    ↓
Load Balancer
    ↓
API Pool (N instâncias stateless)
    ↓
Redis (cache opcional, não fonte da verdade) ← LEI 16, MD-065
    ↓
Dispatcher
    ↓
Workers (auto-scaling)
    ↓
MySQL Cluster
    ↓
Event Store
```

---

## 02. Core Foundation

### MD-110 — Canonical Laws (Leis Supremas)
- LEI 01 — Portal é a Porta (MD-006)
- LEI 02 — Apps Executam Negócio (MD-019)
- LEI 03 — IA Auxilia, Não Decide (MD-057)
- LEI 04 — Nenhum Dado Fica Isolado
- LEI 05 — Regra de Negócio Pertence à SP (MD-008)
- LEI 06 — Nenhuma App Roda Sem Registry
- LEI 07 — Nenhuma Integração Sem IAM (MD-034)
- LEI 08 — Automação Sem Governança é Risco (MD-089)
- LEI 09 — Expansão Sem Ilhas
- LEI 10 — A Experiência é Única
- LEI 11 — Authorization is Decision
- LEI 21 — Banco é a Fonte da Verdade
- LEI 22 — APIs são Stateless (MAP-021)

### MAP-001 — Enterprise Domain Architecture
| Camada | Domínios |
|--------|----------|
| CORE | HIS, CRM, RH, Finance |
| SUPPORTING | Documents, Workflow, Chat, Social, AVA |
| GENERIC | IAM, AI, Portal, Analytics, Integration, Marketplace |

---

## 03. Runtime & Infrastructure (dump → enterprise)

### Classificação (Regra 14 - MD-CANONICO-IA-001)
| Componente | Classificação |
|------------|---------------|
| runtime_contexto | INFRA |
| runtime_api_session_token | INFRA |
| runtime_execution_queue | INFRA |
| runtime_* tables | INFRA |
| sp_dispatcher | CORE |
| Event Store | CORE |
| Ledger | CORE |

### Pattern: Estado Compartilhado no DB
```text
API 1 → runtime_contexto → API 3 → continua fluxo
API 2 → runtime_execution_queue → Worker → Executor
```

---

## 04. Tabelas Runtime (Banco → Arquitetura)

### runtime_contexto (INFA)
```text
Objetivo: Estado da sessão runtime
Colunas-chave:
- id_runtime_contexto (PK)
- id_sessao_usuario (FK) - vínculo com sessão
- id_unidade, id_local_operacional - contexto operacional
- id_paciente, id_ffa - contexto assistencial
- contexto_clinico, estado_fluxo - estado do fluxo
- iniciado_em, finalizado_em, ativo

Usage:
- Criado quando sessão runtime inicia
- Permite recuperação de contexto
- Finalizado quando sessão encerra
- API stateful → lê runtime_contexto
```

### runtime_api_session_token (INFRA)
```text
Objetivo: Token de sessão para APIs runtime
Colunas-chave:
- id_token (PK)
- uuid_runtime - UUID único da sessão
- token_hash - validação segura
- expira_em - controle de expiração
- device_id - identificação do dispositivo
- tenant_id - multi-tenancy

Usage:
- Autenticação stateless
- UUID permite identificação sem estado em memória
- Tenant segregation natural
```

### runtime_execution_queue (INFRA)
```text
Objetivo: Fila de execução assíncrona
Colunas-chave:
- id (PK, UUID) - identificador único
- id_sessao, id_usuario - autoridade
- acao, contexto - ação a executar
- payload (JSON) - parâmetros
- status: PENDENTE, PROCESSANDO, CONCLUIDO, ERRO, CANCELADO
- prioridade, retry_count - controle de fluxo
- ultimo_erro, resultado - tracking

Usage:
- Dispatcher → insere na fila
- Workers → consomem ações
- Retry automático em falhas
- Prioridade para ações críticas
```

### runtime_sync_queue, runtime_sync_log (INFRA)
```text
Objetivo: Operação offline-first
Referência: MD-062, MD-063
```

### runtime_lock_semantico, runtime_kernel_locks (INFRA)
```text
Objetivo: Controle de concorrência
Referência: MD-064, Conflict Resolution
```

---

## 05. Integrações Canônicas

| Documento | Finalidade |
|-----------|------------|
| MD-001 | Núcleo da Plataforma |
| MD-004 | Dispatcher |
| MD-015 | Runtime Core |
| MD-034 | IAM |
| MD-038 | API Gateway |
| MD-065 | Observability |
| MD-066 | SRE Platform |
| MD-089 | Workflow Fabric (N8N) |
| MAP-001 | Enterprise Domain |
| MAP-007 | Event Architecture |
| MAP-008 | Workflow Architecture |
| MAP-021 | Platform Infrastructure Domain |

---

## 06. Lei de Statelessness

### LEI 22 (MD-110)
```text
APIs não guardam estado em memória.
Estado compartilhado reside no Banco.
Load Balancer distribui requisições entre instâncias.
Qualquer instância pode atender qualquer requisição.
Escala horizontal não requer sync de estado.
Redis é cache, nunca fonte da verdade.
```

### LC-RES-002 (MAP-021)
```text
APIs são stateless.
Load Balancer distribui requisições entre instâncias.
Qualquer instância pode atender qualquer requisição.
Escala horizontal não requer replicação de estado.
```

### LC-RES-003 (MAP-021)
```text
Se uma instância API cair, outra assume imediatamente.
Se um Worker morrer, job permanece na fila.
Se o Load Balancer falhar, standby assume.
Recovery automático via health checks.
```

---

## Status
Documento consolidado — Versão 2026-06-30.  
Validado contra dump do banco e documentos canônicos existentes.
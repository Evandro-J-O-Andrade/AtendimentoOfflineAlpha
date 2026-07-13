# MD-KERNEL-009 — Runtime

## Status

```text
CANÔNICO (ARQUITETURA)
CICLO 2 — Kernel Enterprise
Runtime Layer
Pré-requisito: MD-KERNEL-000 — Arquitetura Conceitual do Kernel Enterprise
Pré-requisito: MD-KERNEL-007 — Registry
Pré-requisito: MD-KERNEL-008 — Capability
Consumido por: MD-KERNEL-010 — Navigation
Consumido por: MD-KERNEL-011 — Workflow
Consumido por: MD-KERNEL-014 — Integration
```

---

## 1. Objetivo

Definir o conceito canônico de **Runtime** no Kernel Enterprise.

Runtime é a camada responsável por responder:

> **"Como o Kernel transforma uma capacidade resolvida em uma execução controlada?"**

Ele não é uma regra de negócio.
Ele não é um produto final.
Ele é o **resolvedor e coordenador da execução** do Kernel, garantindo que capacidades autorizadas sejam executadas dentro dos limites de identidade, tenant, sessão, contexto e política.

Sem Runtime, o Kernel tem estrutura, catálogo, descoberta e autorização, mas não executa nada.
Sem os demais domínios, o Runtime não tem base para operar.

---

## 2. Definição Canônica

```text
Runtime representa o ambiente de execução controlada
do Kernel Enterprise.

Runtime é:
  - um resolvedor de execução
  - um coordenador de fluxo
  - um aplicador de contexto
  - um encaminhador para executores apropriados
  - um garantidor do ciclo operacional do Kernel
  - independente de produto
  - independente de interface

Runtime não responde:
  "qual é a regra do negócio?"
  "quem pode acessar?"
  "o que existe?"
  "como aparece para o usuário?"

Runtime responde:
  "como executar esta capability
   respeitando todas as camadas do Kernel?"
```

### 2.1 Princípio fundamental

```text
Runtime executa.
Runtime não decide regra de negócio.
Runtime não decide acesso.
Runtime não define interface.
Runtime apenas coordena a execução
dentro dos limites definidos pelo Kernel.
```

### 2.2 Características obrigatórias

| Característica | Descrição |
|----------------|-----------|
| Coordenador | Orquestra a execução de capabilities autorizadas |
| Controlado | Executa dentro dos limites de identidade, tenant, sessão, contexto e autorização |
| Contextual | Aplica o contexto operacional resolvido em toda operação |
| Rastreável | Toda execução é registrada e auditável |
| Extensível | Novos executores podem ser adicionados sem alterar o núcleo |
| Transversal | Serve a todos os produtos da plataforma |
| Independente | Não depende de produto, interface ou tecnologia específica |
| Isolante | Garante que execuções não vazem entre tenants ou contextos |

### 2.3 Tipos de execução

| Tipo | Natureza | Observação |
|------|----------|------------|
| Síncrona | Execução imediata | Retorna resultado no mesmo fluxo |
| Assíncrona | Execução diferida | Retorna acknowledgment, executa posteriormente |
| Agendada | Execução programada | Triggerada por tempo ou evento |
| Stream | Execução contínua | Processamento contínuo de dados |
| Batch | Execução em lote | Processamento de múltiplas operações |
| Event-driven | Execução por evento | Triggerada por evento do Ledger |

---

## 3. Boundaries

### 3.1 Runtime É

- O coordenador de execução do Kernel.
- O resolvedor de "como executar" capabilities autorizadas.
- O aplicador de contexto e autorização em tempo de execução.
- O encaminhador para executores apropriados.
- O garantidor do ciclo operacional do Kernel.
- O ambiente de execução offline-first, sync e reconciliação.
- A camada que implementa o fluxo conceitual do Kernel em operação real.

### 3.2 Runtime NÃO é

- ❌ **Regra de negócio**: não define o que acontece na operação.
- ❌ **Produto final**: não é HIS, ERP, CRM ou qualquer aplicação.
- ❌ **Interface**: não exibe nada para o usuário.
- ❌ **Menu**: não projeta navegação.
- ❌ **Permissão**: não decide acesso.
- ❌ **Cadastro**: não publica capabilities.
- ❌ **Descoberta**: não filtra catálogo.
- ❌ **Autenticação**: não valida identidade.
- ❌ **Frontend**: não controla experiência do usuário.

### 3.3 Limites claros

```text
RUNTIME
  │
  ├── É responsável por: execução, coordenação, aplicação de contexto, rastreabilidade
  │
  └── NÃO é responsável por:
        ├── identidade (Identity)
        ├── organização (Tenant)
        ├── autenticação (Session)
        ├── escopo operacional (Context)
        ├── decisão de acesso (Authorization)
        ├── catálogo estrutural (Registry)
        ├── descoberta contextual (Discovery)
        ├── capacidade funcional (Capability)
        ├── navegação (Navigation)
        └── interface (Portal/Frontend)
```

---

## 4. Responsabilidades

4.1 Receber solicitação de execução contendo identity, tenant, session, contexto, capability e operação.
4.2 Validar que a execução está autorizada no momento da operação.
4.3 Aplicar o contexto operacional resolvido à execução.
4.4 Encaminhar a execução para o executor apropriado (SP, serviço, worker, integração).
4.5 Coordenar fluxos síncronos, assíncronos, agendados, stream, batch e event-driven.
4.6 Garantir isolamento entre tenants e contextos durante a execução.
4.7 Gerenciar transações, compensações e reconciliações.
4.8 Implementar retry, timeout, circuit breaker e resiliência.
4.9 Garantir rastreabilidade de toda execução.
4.10 Suportar execução offline-first com sync posterior.
4.11 Gerenciar filas, jobs e workers.
4.12 Garantir idempotência nas operações.
4.13 Gerenciar cache com invalidação por evento.
4.14 Gerar snapshots e locks quando necessário.

---

## 5. Produtores

| Papel | Responsabilidade |
|-------|------------------|
| Runtime Kernel | Executa o núcleo do Runtime |
| Executor | Executa operação específica (SP, serviço, worker) |
| Dispatcher | Roteia solicitações para executores apropriados |
| Orquestrador | Coordena múltiplas execuções em transação |
| Workflow Runtime | Executa fluxos automatizados |
| Integration Runtime | Executa integrações externas |
| Sync Engine | Gerencia sincronização offline-first |
| IA | Sugere otimizações de execução (não decide) |

---

## 6. Consumidores

| Consumidor | Como usa |
|------------|----------|
| Navigation | Consulta Runtime para projetar estado operacional |
| Portal | Consome Runtime para executar operações do usuário |
| Workflow | Utiliza Runtime para executar passos de fluxo |
| Integration | Utiliza Runtime para chamadas externas |
| Event | Registra eventos de execução no Ledger |
| Ledger | Persiste histórico de execuções |
| Authorization | Consulta Runtime para validar estado de execução |
| Discovery | Consulta Runtime para verificar capabilities disponíveis |
| Registry | Consulta Runtime para validar existência de capabilities |
| IA | Consulta Runtime para executar sugestões autorizadas |

---

## 7. Relacionamentos

### 7.1 Visão geral

```text
Runtime
  │
  ├── Identity (quem solicitou)
  │
  ├── Tenant (onde opera)
  │
  ├── Session (qual sessão)
  │
  ├── Context (qual contexto)
  │
  ├── Authorization (autorização válida)
  │
  ├── Capability (o que executar)
  │
  ├── Dispatcher (roteamento)
  │
  ├── Orquestrador (coordenação)
  │
  ├── Executor (execução)
  │
  ├── 1:N → Event (eventos gerados)
  │
  └── 1:N → Ledger (registros imutáveis)
```

### 7.2 Modelo conceitual

```text
Solicitação de Execução
  │
  ├── Identity
  ├── Tenant
  ├── Session
  ├── Context
  ├── Authorization
  ├── Capability
  └── Operação
        │
        ▼
  Runtime Engine
        │
        ├── Valida sessão ativa
        ├── Valida contexto resolvido
        ├── Valida authorization vigente
        ├── Carrega capability
        ├── Seleciona executor apropriado
        ├── Aplica contexto à execução
        ├── Executa via Dispatcher/Orquestrador/Executor
        ├── Gerencia transação e resiliência
        ├── Registra eventos no Ledger
        └── Retorna resultado
              │
              ▼
        Resultado
          ├── SUCESSO → Estado atualizado
          └── FALHA   → Compensação / Retry / Erro auditado
```

### 7.3 Runtime não é regra de negócio

```text
RUNTIME
  │
  ├── NÃO define regra de negócio
  │     └── Regra de negócio mora no domínio consumidor
  │
  ├── NÃO decide permissão
  │     └── Permissão é decidida por Authorization
  │
  ├── NÃO cria menu
  │     └── Menu é projetado por Navigation
  │
  ├── NÃO cadastra capability
  │     └── Capability é registrada por Registry
  │
  ├── NÃO descobre disponibilidade
  │     └── Discovery resolve disponibilidade
  │
  └── NÃO exibe interface
        └── Interface é responsabilidade do produto consumidor
```

### 7.4 Runtime como camada de execução

```text
RUNTIME
  │
  ├── Master (orquestrador principal)
  │     └── Coordena todo o ciclo de execução
  │
  ├── Dispatcher (roteador)
  │     └── Valida contrato, permissão e chama executor
  │
  ├── Orquestrador (coordenador)
  │     └── Coordena múltiplas execuções, gerencia transação
  │
  ├── Executor (executor)
  │     └── Executa operação específica (SP, serviço, worker)
  │
  ├── Sync Engine (sincronização)
  │     └── Gerencia offline-first, sync, reconciliação
  │
  ├── Queue Manager (filas)
  │     └── Gerencia filas, jobs, agendamento
  │
  ├── Cache Manager (cache)
  │     └── Gerencia cache invalidado por evento
  │
  └── Snapshot Manager (snapshots)
        └── Gerencia snapshots e locks
```

Esses são conceitos internos do Runtime.
Eles não são expostos como domínios independentes.

---

## 8. Dependências

### 8.1 Depende de

| Domínio | Como depende |
|---------|--------------|
| Registry | Runtime valida existência de capabilities no Registry |
| Discovery | Runtime consulta Discovery para disponibilidade |
| Capability | Runtime executa Capability autorizada |
| Authorization | Runtime valida Authorization antes de executar |
| Identity | Runtime executa em nome de uma Identity |
| Tenant | Runtime opera dentro de um Tenant |
| Session | Runtime valida Session ativa |
| Context | Runtime aplica Context resolvido |

### 8.2 É dependido por

| Domínio | Como depende de Runtime |
|---------|--------------------------|
| Navigation | Navigation projeta estado de Runtime |
| Workflow | Workflow executa passos via Runtime |
| Integration | Integration executa via Runtime |
| Portal | Portal consome Runtime para operações |
| Event | Evento registra execuções de Runtime |
| Ledger | Ledger persiste histórico de Runtime |

### 8.3 Matriz de dependência

| Domínio      | Identity | Tenant | Session | Context | Authorization | Discovery | Registry | Capability | Runtime |
| ------------ | -------- | ------ | ------- | ------- | ------------- | --------- | -------- | ---------- | ------- |
| Identity     | —        |        |         |         |               |           |          |            |         |
| Tenant       |          | —      |         |         |               |           |          |            |         |
| Session      | ✔        | ✔      | —       |         |               |           |          |            |         |
| Context      | ✔        | ✔      | ✔       | —       |               |           |          |            |         |
| Authorization| ✔        | ✔      | ✔       | ✔       | —             |           |          |            |         |
| Discovery    | ✔        | ✔      | ✔       | ✔       | ✔             | —         |          |            |         |
| Registry     |          |        |         |         |               | ✔         | —        |            |         |
| Capability   |          |        |         |         |               | ✔         | ✔        | —          |         |
| Runtime      |          |        |         |         |               | ✔         | ✔        | ✔          | —       |
| Navigation   |          |        |         |         |               | ✔         | ✔        | ✔          | ✔       |
| Workflow     |          |        |         |         |               | ✔         | ✔        | ✔          | ✔       |
| Event        |          |        |         |         |               | ✔         | ✔        | ✔          | ✔       |
| Ledger       |          |        |         |         |               | ✔         | ✔        | ✔          | ✔       |
| Integration  |          |        |         |         |               | ✔         | ✔        | ✔          | ✔       |

---

## 9. Estados Canônicos

### 9.1 Estados de Runtime

| Estado | Descrição |
|--------|-----------|
| IDLE | Aguardando solicitação de execução |
| VALIDATING | Validando sessão, contexto e autorização |
| RESOLVING | Resolvendo capability e executor |
| EXECUTING | Executando operação |
| WAITING | Aguardando recurso externo |
| COMPENSATING | Executando compensação de falha |
| SYNCING | Sincronizando estado offline |
| COMPLETED | Execução concluída com sucesso |
| FAILED | Execução falhou |
| CANCELLED | Execução cancelada |

### 9.2 Regras de transição

```text
IDLE → VALIDATING (solicitação recebida)
VALIDATING → RESOLVING (sessão, contexto e autorização válidos)
VALIDATING → FAILED (validação falhou)
RESOLVING → EXECUTING (capability e executor resolvidos)
RESOLVING → FAILED (capability não encontrada ou não autorizada)
EXECUTING → COMPLETED (operação concluída)
EXECUTING → WAITING (aguardando recurso externo)
EXECUTING → FAILED (erro na execução)
WAITING → EXECUTING (recurso disponível)
WAITING → FAILED (timeout ou recurso indisponível)
EXECUTING → COMPENSATING (falha detectada, iniciando compensação)
COMPENSATING → COMPLETED (compensação concluída)
COMPENSATING → FAILED (compensação falhou)
EXECUTING → CANCELLED (cancelamento solicitado)
COMPLETED → SYNCING (sincronização necessária)
SYNCING → COMPLETED (sincronização concluída)
FAILED → IDLE (após correção ou retry)
CANCELLED → IDLE (após limpeza)
```

### 9.3 Regras de negócio

- Toda execução de Runtime é sempre precedida por Authorization válida.
- Runtime nunca executa capability sem Registry publicado.
- Runtime nunca cruza tenant ou contexto sem autorização explícita.
- Runtime deve ser idempotente: mesma solicitação produz mesmo resultado.
- Runtime deve suportar retry, timeout e circuit breaker.
- Toda transição de estado de Runtime deve gerar evento no Ledger.
- Runtime é a única camada autorizada a executar operações no banco via SP.
- Nenhuma camada acima do Runtime pode executar operação diretamente.

---

## 10. Integração com o Kernel

### 10.1 Papel no Kernel

Runtime é o elemento central da **Runtime Layer**.

É a camada que transforma capacidades autorizadas em execuções controladas, fechando o ciclo operacional do Kernel.

```text
Cliente
  ↓
Identity (quem é?)
  ↓
Tenant (onde opera?)
  ↓
Session (está autorizado agora?)
  ↓
Context (em qual escopo operacional?)
  ↓
Authorization (pode?)
  ↓
Registry (o que existe?)
  ↓
Discovery (o que está disponível?)
  ↓
Capability (o que cada item representa?)
  ↓
Runtime (executa)
  ↓
Navigation (apresenta resultado)
```

### 10.2 Contratos

Runtime não é uma SP. Runtime é um conceito.

Sua materialização será:
- Tabelas: `runtime_execution`, `runtime_job`, `runtime_queue`, `runtime_sync`, `runtime_lock`, `runtime_snapshot`, etc.
- SPs: `sp_runtime_execute`, `sp_runtime_orchestrate`, `sp_runtime_dispatch`, `sp_runtime_compensate`, etc.
- Views: `vw_runtime_active`, `vw_runtime_history`, `vw_runtime_jobs`, etc.

Mas esses detalhes pertencem ao **Modelo Lógico** e **Modelo Físico**.

Neste documento, Runtime é apenas um conceito.

### 10.3 Integração com outros domínios

| Domínio | Integração |
|---------|------------|
| Identity | Runtime executa em nome de uma Identity |
| Tenant | Runtime opera dentro de um Tenant |
| Session | Runtime valida Session ativa |
| Context | Runtime aplica Context resolvido |
| Authorization | Runtime valida Authorization antes de executar |
| Discovery | Runtime consulta Discovery para disponibilidade |
| Registry | Runtime valida existência no Registry |
| Capability | Runtime executa Capability autorizada |
| Navigation | Navigation projeta estado de Runtime |
| Workflow | Workflow executa passos via Runtime |
| Event | Evento registra execuções de Runtime |
| Ledger | Ledger persiste histórico de Runtime |
| Integration | Integration executa via Runtime |

---

## 11. Impacto Arquitetural

### 11.1 Impactos positivos

- Centraliza a execução em um ponto único.
- Garante que todas as operações respeitem o Kernel.
- Torna a execução rastreável e auditável.
- Suporta multi-tenant e multi-contexto naturalmente.
- Permite composição de fluxos complexos.
- Cria base para offline-first e sync.
- Separa execução de regra de negócio.
- Habilita resiliência, retry e compensação.

### 11.2 Impactos negativos / Riscos

- Complexidade de orquestração: fluxos podem ser numerosos e complexos.
- Performance: Runtime é crítico em toda operação.
- Acoplamento: se Runtime cresce muito, vira monolito.
- Migração: produtos legados precisam migrar execução para Runtime.
- Governança: executores sem dono geram fragilidade.

### 11.3 Mitigações

- Arquitetura de executores plugáveis.
- Métricas de desempenho de Runtime.
- Política de versionamento de capabilities.
- Migração gradual por produto.
- Dashboard de health de Runtime por tenant.

---

## 12. Critérios de Materialização

12.1 Nenhuma tabela de runtime será criada sem justificar REUSE/ADAPT/EXTEND/MERGE/PROPOSE.
12.2 Nenhuma SP de runtime será criada sem classificação de tipo (MASTER, DISPATCHER, ORCHESTRATOR, EXECUTOR, ASSERT, QUERY, COMMAND, LEDGER, EVENT).
12.3 Toda FK de runtime deve estar coerente com as SPs que a consomem.
12.4 Todo índice de runtime deve suportar as consultas mais frequentes (busca por identity, tenant, capability, status).
12.5 Nenhuma operação do Kernel pode existir sem Runtime válido.
12.6 Toda execução de Runtime deve gerar evento no Ledger.
12.7 Runtime não pode conter regra de negócio; apenas coordenação de execução.
12.8 Runtime deve ser a única camada autorizada a executar operações no banco via SP.
12.9 A materialização depende da aprovação do MD-KERNEL-009 e do dossiê correspondente.

---

## 13. Referências

- MD-KERNEL-000 — Arquitetura Conceitual do Kernel Enterprise
- MD-KERNEL-001 — Identity
- MD-KERNEL-002 — Tenant
- MD-KERNEL-003 — Session
- MD-KERNEL-004 — Context
- MD-KERNEL-005 — Authorization
- MD-KERNEL-006 — Discovery
- MD-KERNEL-007 — Registry
- MD-KERNEL-008 — Capability
- MAPA DO KERNEL ENTERPRISE
- MD-KERNEL-DEPENDENCY-MAP
- MD-110 — Canonical Laws
- MD-113 — Lei da Singularidade Canônica
- MD-005 — Lei de Engenharia e Materialização
- GATE-DISCOVERY-REGISTRY-RUNTIME-DECISION
- DOSSIER-DISCOVERY-REGISTRY-RUNTIME

---

## 14. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-13 | Kilo | Criação do MD-KERNEL-009 — Runtime |

---

Documento Canônico — MD-KERNEL-009

**Este é o nono domínio do Kernel Enterprise. Pertence à Runtime Layer, depende de Registry, Capability e Foundation Layer, e é pré-requisito para Navigation, Workflow e Integration.**

# MAP-021 — Platform Infrastructure Domain

## Status
Documento Canônico de Arquitetura.
Arquitetura de infraestrutura e execução da plataforma SaaS Enterprise.

---

## Classificação
```text
Tipo: Platform Architecture
Camada: Plataforma
Prioridade: Crítica
Obrigatoriedade: Global
```

---

## Objetivo
Definir a arquitetura de infraestrutura de execução da plataforma Midas como SaaS Enterprise, habilitando escalabilidade horizontal, alta disponibilidade e tolerância a falhas sem perda de contexto.

---

## Problema que Resolve
```text
Escalabilidade limitada
Single point of failure
Estado em memória não compartilhado
Dificuldade de deploy/blue-green
Hot restart sem perda de contexto
```

---

## Arquitetura de Execução

### Layer 0 — Internet / Client
```text
Internet / Client Applications
```

### Layer 1 — Load Balancer (L7)
```text
Load Balancer (L7)
- SSL Termination
- Path-based routing
- Health checks
- Sticky sessions (opcional)
```

### Layer 2 — API Pool
```text
API Pool (N nodes)
- Stateless Node.js instances
- Shared session state via DB
- Shared workflow context via DB
- No in-memory state
```

### Layer 3 — Dispatcher / Kernel
```text
Dispatcher / Kernel
- sp_dispatcher
- Runtime orchestration
- Event routing
- Workflow coordination
```

### Layer 4 — Data Layer
```text
MySQL (Primary)
- runtime_* tables
- runtime_contexto
- runtime_api_session_token
- runtime_execution_queue
- Event/Ledger
```

---

## Design Pattern: Stateless APIs

### Lei Canônica MAP-021-001
```text
APIs são stateless. Estado compartilhado
reside no banco de dados.
```

### Lei Canônica MAP-021-002
```text
Nenhum contexto de usuário, sessão
ou workflow permanece em memória.
```

### Implementação
```text
API 1 → runtime_contexto → API 3 → continua processo
API 2 → runtime_execution_queue → Worker → Executor
```

---

## Componentes de Infraestrutura

### Load Balancer
```text
Responsabilidades:
- Distribuição HTTP/HTTPS
- Health checks automáticos
- Failover transparente
- SSL/TLS termination
- Rate limiting
```

### API Gateway
```text
Responsabilidades:
- Roteamento de requisições
- Auth middleware (integrado com IAM canônico)
- Request/response transformation
- Circuit breaker
- Retry logic
- Rate limiting
- Schema validation
- Versioning
```

Referência: MD-038 Integration Hub define o API Gateway como componente central.

### Pool de APIs Node.js
```text
Características:
- Horizontalmente escalável
- Número dinâmico de instâncias
- Deploy sem downtime
- Blue-green deployment
- Auto healing via orchestrator
```

### Dispatcher
```text
Tabela: runtime_execution_queue
Funções:
- sp_dispatcher
- Distribuição de tasks
- Retry automático
- Dead letter queue
- Priority handling
```

### Workers
```text
Tarefa:
- Consumir runtime_execution_queue
- Executar processos background
- Atualizar status
- Emitir eventos
```

### Cache Layer (Opcional)
```text
Redis (não fonte da verdade)
Uso:
- Cache de dados read-heavy
- Rate limiting
- Filas de baixa criticidade
- Session cache (não única fonte)
```

### Scheduler
```text
Funções:
- Cron jobs (segregados por tenant - ver MD-035)
- Delayed execution
- Re-entrancy control
- Timezone handling
- Distributed scheduling
- Job isolation guarantees
```

### Event Bus
```text
Tecnologias:
- Event Store Core
- Event-driven architecture
- Async processing
```

### Health Checks
```text
Endpoints:
- /health (liveness) - instância responde
- /ready (readiness) - DB/API conectado
- /metrics (Prometheus) - métricas para MD-065
- /ping (basic) - heartbeat
- /health/:tenant - isolated health check por tenant
```

Referência: MD-066 SLO 99.9% disponibilidade requer health checks em todas as APIs.

### Auto Scaling
```text
Triggers:
- CPU utilization > 70%
- Memory pressure
- Queue depth
- Response time > SLA
```

---

## Fluxo de Requisição

```text
Usuário
    ↓
Load Balancer
    ↓
API Pool (any instance)
    ↓
sp_dispatcher
    ↓
runtime_contexto (shared state)
    ↓
Response to client
```

## Fluxo de Workflow

```text
Node API (any)
    ↓
sp_dispatcher
    ↓
runtime_execution_queue
    ↓
Worker (any instance)
    ↓
Executor
    ↓
Ledger (events)
    ↓
runtime_contexto updated
```

---

## Resilience Patterns

### Failover de API
```text
Se API 1 cair:
- Load Balancer redireciona
- API 3 lê contexto do DB
- Sessão mantida via runtime_api_session_token
- Workflow mantido via runtime_execution_queue
```

### Failover de Worker
```text
Se Worker morre durante execução:
- Job permanece na fila
- Outro Worker pega o job
- Timeout detection
- Retry com backoff
```

---

## Escalabilidade Horizontal

### Scale Up
```text
Nova instância API:
- Conecta ao DB
- Pronta para atender
- Não precisa sync estado
```

### Scale Down
```text
Remover instância:
- Drain connections
- Jobs migrados
- Sem perda de dados
```

---

## Integrações
| MAP/MD | Finalidade |
|---------|-----------|
| MAP-001 — Enterprise Domain | Domínios da plataforma |
| MAP-007 — Event Architecture | Event Bus, Eventos |
| MAP-008 — Workflow Architecture | Workflows |
| MD-004 — Dispatcher | Dispatcher |
| MD-015 — Runtime | Runtime |
| MD-017 — Multi-Tenant | Multi-tenancy |
| MD-035 — Security Trust Architecture | Scheduler segregado por tenant |
| MD-038 — Integration Hub | API Gateway |
| MD-065 — Observability Platform | Observability |
| MD-066 — SRE Platform | SRE, SLI/SLO, Incident Management |
| MD-089 — Workflow Fabric | N8N Enterprise |

---

## Estrutura de Tabelas Runtime

### Contexto Compartilhado
```text
runtime_contexto
runtime_api_session_token
runtime_execution_queue
runtime_workflow_instance
runtime_workflow_step
```

---

## Diretrizes de Implementação

### Proibido
```text
Stores em memória para estado de usuário
Sessões não persistidas no DB
Workflows não registrados via SP
Jobs sem persistência garantida
```

### Obrigatório
```text
Toda operação via SP
Contexto sempre em DB
Health checks em todas as APIs
Tracing distribuído
Retry com circuit breaker
```

---

## Evolução Natural

```text
Internet
    ↓
Load Balancer
    ↓
API Pool
    ↓
Redis (cache)
    ↓
Dispatcher
    ↓
Workers
    ↓
MySQL Cluster
    ↓
Event Store
```

---

## Status Atual
Documento em elaboração. Aguardando validação da arquitetura de execução post-KiloCode.
# MAP-007 — Event Architecture

## Status
Documento Canônico de Arquitetura.
Arquitetura de eventos corporativos.

---

## Classificação
```text
Tipo: Foundation Architecture
Camada: Plataforma
Prioridade: Crítica
Obrigatoriedade: Global
```

---

## Objetivo
Definir arquitetura de eventos como fonte de verdade para todas as mudanças de estado.

---

## Lei Canônica MAP-007-001
```text
Todo fato importante é evento.
```

---

## Lei Canônica MAP-007-002
```text
Eventos são imutáveis.
```

---

## Lei Canônica MAP-007-003
```text
Eventos carregam contexto.
```

---

## Event Store Structure

### Event Stream
```text
event_id (UUID)
event_type
tenant_id
aggregate_id
aggregate_type
payload (JSON)
metadata (JSON)
timestamp
correlation_id
causation_id
user_id
```

### Event Metadata
```text
source_ip
user_agent
session_id
context_snapshot
version
```

---

## Event Types

### Created Events
```text
EntityCreated
```

### Updated Events
```text
EntityUpdated
```

### State Events
```text
EntityStateChanged
```

### Business Events
```text
BusinessProcessCompleted
```

---

## Event Contract

### Naming Convention
```text
[Entity][Verb][Time]
Ex: SenhaCriada, AtendimentoIniciado
```

### Idempotent Events
```text
event_id como chave única
retry seguro
```

---

## Stored Procedures

### sp_event_store
Persistir evento

### sp_event_replay
Replay de eventos

### sp_event_query
Consulta por aggregate

### sp_event_subscribe
Registrar handler

---

## Event Processing

### Outbox Pattern
```text
Transaction → Outbox table → Broker
```

### Inbox Pattern
```text
Broker → Inbox table → Processing
```

---

## Event Bus

### Supported Brokers
```text
RabbitMQ
Kafka
Redis Streams
```

### Message Format
```json
{
  "eventId": "uuid",
  "eventType": "SenhaCriada",
  "tenantId": "uuid",
  "payload": {},
  "metadata": {}
}
```

---

## Event Handlers

### Handler Registration
```text
Event Type → Handler Function
```

### Retry Policy
```text
Exponential backoff
Dead letter queue
Max retries
```

---

## Projections

### Read Models
```text
Materializada por eventos
Otimizada para query
Atualizada assincronamente
```

---

## Event Sourcing

### Aggregates Replay
```text
Event stream → Aggregate state
```

### Projections Update
```text
Event → Projection update
```

---

## Integrações
| MAP/MD | Finalidade |
|--------|-----------|
| MAP-001 — Domain | Domínios |
| MD-104 — Event Convergence | Eventos |
| MD-065 — Observability | Monitoramento |
| FRONT-058 — Universal Timeline | Timeline |
| FRONT-062 — Event Visualization | Visualização |
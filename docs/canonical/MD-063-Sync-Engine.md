# MD-063 — Sync Engine

## Status

Documento Canônico do Motor de Sincronização da Plataforma Enterprise.

---

## Objetivo

Sincronizar dados entre Runtime Local e Portal Cloud.

Universal, eficiente, confiável.

---

## Princípio Fundamental

```text
Evento local:
  CRIADO → FILA → VALIDADO → SINCRONIZADO → CONFIRMADO
```

---

## Sync Architecture

```text
Runtime Local                 Portal Cloud
┌──────────────┐         ┌──────────────┐
│ Local Queue  │────────▶│ Sync Gateway │
│ (IndexedDB)  │ WebSocket│              │
└──────────────┘         └──────┬───────┘
                                 │
                              ┌──┴──┐
                              │Dis  │
                              │atch │
                              │ er  │
                              └──┬──┘
                                 │
                              ┌──┴──┐
                              │Event│
                              │Store│
                              └─────┘
```

---

## Sync Flow

### Local to Cloud

```text
Local Event Created
    ↓
Queued (IndexedDB)
    ↓
Sync Triggered (online/timer/manual)
    ↓
Batch Assembled (50-100 events)
    ↓
Compressed (gzip/brotli)
    ↓
Sent via WebSocket/HTTP
    ↓
Cloud Validates (tenant, auth, rules)
    ↓
Cloud Persists (Event Store → DB)
    ↓
Confirmation (with server timestamps)
    ↓
Local Queue Cleaned
    ↓
Local Cache Updated
    ↓
UI Notified
```

### Cloud to Local

```text
Cloud Event Created
    ↓
Cloud Queue
    ↓
Sync Push (if device online)
    ↓
Device Receives via WebSocket
    ↓
Local Cache Updated
    ↓
UI Notified
```

---

## Sync Features

### Retry

```text
Exponential backoff
Max retries: 5
Base interval: 1s
Max interval: 5min
On network error
On 5xx error
On timeout
```

### Compressão

```text
gzip padrão
brotli para grandes batches
Threshold: >1KB por evento
Skip if already compressed
```

### Versionamento

```text
Schema version por entidade
Protocol version do sync
Backward compatibility garantida
Migration automática de schema local
```

### Conflitos

```text
Detecção automática por:
  - Timestamp do servidor vs local
  - Hash do conteúdo
  - Version number
  - User ID (last-write-wins por usuário)
```

### Reconciliação

```text
Merge automático quando seguro
Manual review quando ambíguo
Business rules determinam winner
Audit trail de toda reconciliação
```

---

## Sync Modes

### Full Sync

```text
Todas as entidades do tenant
Usado em: primeiro login, reset, mudança de device
Agendado: semanal para dados críticos
```

### Incremental Sync

```text
Apenas mudanças desde último sync
Delta por timestamp
Usado em: sync normal
Trigger: eventos + timer
```

### Selective Sync

```text
Usuário escolhe o que sincronizar
Por app
Por data type
Por período
```

---

## Queue Management

```text
Priority-based queue
  CRITICAL: auth, transações, financeiro
  HIGH: tickets, pedidos, ordens
  MEDIUM: CRM, SAC, chat
  LOW: analytics, social, feed

Max queue size: 5000 events
Overflow: drop LOW priority, notify user
```

---

## Integration with Other MDs

- **MD-061 (Edge Runtime)**: runtime local é a base.
- **MD-002 (Auth)**: autenticação para sync.
- **MD-004 (Dispatcher)**: actions no sync.
- **MD-005 (Event Store)**: eventos sincronizados.
- **MD-017 (MultiTenant)**: tenant isolation no sync.
- **MD-064 (Conflict Resolution)**: resolução de conflitos.
- **MD-035 (Security Trust Architecture)**: security do sync.

---

## Próximo MD recomendado

```text
MD-064 — Conflict Resolution Engine
```

Resolução de conflitos.
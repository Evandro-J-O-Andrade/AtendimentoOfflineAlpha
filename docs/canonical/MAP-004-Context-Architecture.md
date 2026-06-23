# MAP-004 — Context Architecture

## Status
Documento Canônico de Arquitetura.
Arquitetura de contexto operacional do Midas.

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
Definir a arquitetura oficial de contexto operacional, garantindo que toda operação ocorra dentro de um contexto válido.

---

## Problema que Resolve
```text
Operações sem escopo
Dados misturados entre unidades
Inconsistências de negócio
Falta de trilha de auditoria
Impossibilidade de multi-tenant
```

---

## Lei Canônica MAP-004-001
```text
Nenhuma operação ocorre
fora de contexto.
```

---

## Lei Canônica MAP-004-002
```text
Contexto é imutável durante operação.
```

---

## Lei Canônica MAP-004-003
```text
Contexto é passado explicitamente.
```

---

## Hierarquia de Contexto

```text
Tenant
    ↓
Organization
    ↓
Unit
    ↓
Sector
    ↓
Location
    ↓
Profile/Role
```

---

## Context Object

### Structure
```json
{
  "tenant_id": "uuid",
  "organization_id": "uuid",
  "unit_id": "uuid",
  "sector_id": "uuid",
  "location_id": "uuid",
  "profile_id": "uuid",
  "user_id": "uuid",
  "session_id": "uuid",
  "correlation_id": "uuid"
}
```

---

## Context Resolution

### Primary Source
```text
Session Context (cookie/headers)
```

### Fallback Sources
```text
User Default Context
Tenant Default Context
System Context
```

---

## Context Propagation Pattern

### API Headers
```text
X-Tenant-ID
X-Organization-ID
X-Unit-ID
X-Sector-ID
X-Location-ID
X-Profile-ID
X-Correlation-ID
```

### Event Enrichment
Todo evento deve carregar:
```text
tenant_id
user_id
context_snapshot
```

---

## Context Middleware

### Inject Context
```text
Extract from session/token
Validate against tenant
Enrich with defaults
Attach to request scope
```

### Validate Context
```text
User belongs to tenant
User belongs to organization/unit
Profile has permissions
Context not expired
```

---

## Context Switching

### Allowed When
```text
User has multiple roles
User can change units
System allows context switch
```

### Forbidden When
```text
Cross-tenant access
Without explicit permission
Outside business hours
```

---

## Stored Procedures

### sp_context_load
```sql
Retorna contexto completo da sessão
```

### sp_context_validate
```sql
Valida contexto contra tenant
```

### sp_context_switch
```sql
Altera contexto com auditoria
```

### sp_context_audit
```sql
Grava histórico de contextos
```

---

## Eventos Oficiais

### ContextLoaded
Contexto carregado na sessão

### ContextValidated
Contexto validado com sucesso

### ContextSwitched
Contexto alterado

### ContextExpired
Contexto expirado

---

## APIs Oficiais

### /api/v1/context
GET - Obter contexto atual

### /api/v1/context/validate
POST - Validar contexto

### /api/v1/context/switch
POST - Alterar contexto

---

## Context Scope Rules

### Read Operations
Contexto deve permitir leitura no escopo

### Write Operations
Contexto deve permitir escrita no escopo

### Delete Operations
Contexto deve permitir exclusão no escopo

---

## Context Cache

### Redis Structure
```text
context:{session_id} → JSON context
context:user:{user_id}:default → default context
context:tenant:{tenant_id}:defaults → tenant defaults
```

---

## Context Lifecycle

### Creation
```text
User login
Select organization/unit
Validate permissions
Create session context
```

### Validation
```text
Every request
Check tenant/user alignment
Check permissions
Update correlation
```

### Expiration
```text
Session end
Context timeout
Explicit switch
Security event
```

---

## Integração com IAM

## MAP-003 Integration
Contexto consome identidade de IAM

Contexto aplica papéis e permissões

---

## Context Builder Pattern

### Builder Steps
```text
1. Validate session
2. Load tenant context
3. Load user context
4. Apply role context
5. Merge with request context
6. Validate final context
7. Return Context object
```

---

## Integrações
| MAP/MD | Finalidade |
|--------|-----------|
| MAP-002 — Tenant | Tenant context |
| MAP-003 — Identity | Role/Permission |
| MD-108 — Operational Context | Context engine |
| FRONT-002 — Context Selection | UX |
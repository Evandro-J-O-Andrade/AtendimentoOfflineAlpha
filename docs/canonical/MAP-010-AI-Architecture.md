# MAP-010 — AI Architecture

## Status
Documento Canônico de Arquitetura.
Arquitetura de IA corporativa.

---

## Classificação
```text
Tipo: Domain Architecture
Camada: Plataforma
Prioridade: Alta
Obrigatoriedade: Global
```

---

## Objetivo
Definir arquitetura de IA como camada de serviços cognitivos.

---

## Lei Canônica MAP-010-001
```text
IA serve, não governa.
```

---

## Lei Canônica MAP-010-002
```text
IA é transparente e auditável.
```

---

## Componentes

### AI Service
```text
service_id (UUID)
tenant_id
name
type (chat/copilot/workflow)
model
provider
endpoint
api_key_ref
is_active
```

### AI Request
```text
request_id (UUID)
tenant_id
session_id
context
prompt
model
response
tokens
cost
duration
```

### AI Agent
```text
agent_id (UUID)
tenant_id
name
description
instructions
capabilities
tools
model
```

---

## AI Modes

### Corporate Assistant
IA corporativa geral

### Clinical Assistant
IA para HIS

### People Assistant
IA para RH

### Commercial Assistant
IA para CRM

---

## Providers

### Supported
```text
OpenAI
Gemini
Claude
Local Models
```

### Abstraction Layer
```text
Provider interface
Unified request/response
Cost tracking
Latency tracking
```

---

## Stored Procedures

### sp_ai_request_log
Log de requisição

### sp_ai_cost_calculate
Calcular custo

### sp_ai_agent_execute
Executar agente

### sp_ai_quota_check
Verificar quota

---

## Eventos Oficiais

### AIRequestStarted
Requisição iniciada

### AIRequestCompleted
Requisição completada

### AIRequestFailed
Requisição falhou

### AICostRecorded
Custo registrado

### AgentExecuted
Agente executado

---

## Governance

### Rate Limiting
```text
Per tenant
Per user
Per app
Per model
```

### Cost Control
```text
Budget limits
Alerts
Throttling
Blocking
```

---

## Integrações
| MAP/MD | Finalidade |
|--------|-----------|
| MD-081 — AI Copilot Framework | Copilot |
| MD-087 — Enterprise Search | Search |
| MAP-007 — Event Architecture | Eventos |
| FRONT-024 — AI Experience | UX |
| FRONT-025 — AI Command Center | Command |
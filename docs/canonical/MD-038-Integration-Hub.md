# MD-038 — Integration Hub

## Status

Documento Canônico do Hub de Integrações da Plataforma Enterprise.

---

## Objetivo

Centralizar todas as integrações externas e internas.

N8N como motor principal.

APIs, Webhooks, IA, ERP e Gov em uma única camada controlada.

---

## Lei Fundamental

```text
Sistema não é isolado.

Sistema é integrado.

Integração é controlada.

Controlada é segura.
```

---

## Integration Architecture

```text
Webhook Endpoints
API Gateway
N8N Workflows
External Connectors
Internal Adapters
Event Streams
Data Pipes
IA Connectors
ERP Bridges
Gov Integrations
```

---

## Webhook Engine

Gerencia:

```text
Webhook creation
Webhook signing
Webhook validation
Webhook retry
Webhook dead letter
Webhook monitoring
Webhook analytics
```

### Security

```text
Signature verification (HMAC-SHA256)
Timestamp validation (tolerance 5min)
Nonce replay protection (Redis)
Tenant isolation por webhook
Rate limiting por webhook
IP allowlist por tenant
Payload encryption opcional
Audit trail completo
```

---

## API Gateway

Centraliza:

```text
API endpoints
Rate limiting
Authentication
Authorization
Logging
Monitoring
Versioning
Caching
Schema validation
Circuit breaker
```

### Open API

```text
Public APIs (parceiros)
Partner APIs (integradores)
Internal APIs (apps internos)
Admin APIs (operadores)
System APIs (infraestrutura)
```

---

## N8N Integration

Workflows como serviço:

```text
Workflow registry
Workflow execution
Workflow monitoring
Workflow alerting
Workflow retry
Workflow versioning
Workflow scheduling
Workflow sandbox
```

### Modelo Canônico de Workflow

```json
{
  "workflow_uuid": "UUID",
  "tenant_id": 0,
  "name": "Sincronizar CRM",
  "trigger": "WEBHOOK|SCHEDULE|EVENT|WEBHOOK",
  "steps": [],
  "status": "ACTIVE|PAUSED|ERROR",
  "webhook_url": "string",
  "schedule": "cron expression",
  "retry_policy": {
    "max_retries": 3,
    "backoff": "exponential",
    "interval": 60
  },
  "created_at": "datetime",
  "updated_at": "datetime"
}
```

---

## IA Connectors

Integração com provedores de IA:

```text
OpenAI (GPT-4, GPT-4o, embeddings)
Gemini (Google)
Claude (Anthropic)
DeepSeek
Azure OpenAI
Local LLM (Ollama, vLLM)
```

### IA Gateway

```text
Unified API para todos provedores
Load balancing entre provedores
Failover automático
Cost tracking por tenant
Rate limiting por provedor
Prompt template management
Output sanitization
Audit de uso
```

---

## ERP Integration

Integrações externas:

```text
SAP
Oracle ERP
Totvs Protheus
Sankhya
Bling
NFe.io
Sintegra
```

### Padrão de Integração

```text
REST API principal
SOAP fallback para legados
Batch processing para volumes altos
Real-time via webhook quando disponível
DLQ (Dead Letter Queue) para falhas
Compensação em caso de erro parcial
Idempotência obrigatória
```

---

## Gov Integration

Integrações governamentais:

```text
Receita Federal (CNPJ, CPF, NFe)
CNES (estabelecimentos de saúde)
SIGTAP (procedimentos SUS)
eSocial (eventos trabalhistas)
SintegradoGov
Cartórios
INSS
```

### Segurança Gov

```text
Certificado digital obrigatório
Token de acesso por serviço
Rate limit respeitando regras de cada órgão
Cache de consultas estáticas
Retry com backoff exponencial
Audit trail obrigatório para cada requisição
PII masking em logs
```

---

## External Connectors

Tipos:

```text
REST API
SOAP
GraphQL
Database
File storage
Message queue
Email
SMS
WhatsApp
Payment gateway
ERP externo
CRM externo
Sistema legado
```

---

## Internal Adapters

Conectores internos:

```text
HIS
CRM
SAC
Financeiro
PDV
AVA
Operacional
Social
ITSM
Analytics
Security
Mobile PWA
```

---

## Event Streams

Streaming de eventos:

```text
Event publishing
Event subscription
Event filtering
Event routing
Event replay
Event archiving
Kafka topics por domínio
Schema registry
```

---

## Data Pipes

Movimentação de dados:

```text
ETL pipelines
Data sync
Data transform
Data validate
Data load
Data monitor
Change data capture (CDC)
Real-time streaming
Batch processing
Data quality checks
```

---

## Apps Registradas

```text
INTEGRATION_HUB
WEBHOOK_ENGINE
API_GATEWAY
WORKFLOW_MANAGER
N8N_BRIDGE
CONNECTORS
DATA_PIPES
STREAMING
ADAPTERS
EXTERNAL_SYNC
IA_GATEWAY
ERP_BRIDGE
GOV_BRIDGE
```

---

## Integração com Outros MDs

- **MD-002 (Auth Core)**: auth para integrações.
- **MD-003 (Operational Context)**: contexto integração.
- **MD-004 (Dispatcher)**: ações externas.
- **MD-005 (Event Store)**: eventos integração.
- **MD-010 (Security Core)**: security integração.
- **MD-014 / MD-019 (App Registry)**: apps integrados.
- **MD-020 (Portal Core)**: portal integração.
- **MD-027 (AI Orchestration Platform)**: IA workflows.
- **MD-031 (Marketplace & Ecosystem)**: integrações marketplace.
- **MD-034 (IAM)**: permissões integração.
- **MD-035 (Security Trust Architecture)**: security avançada.
- **MD-039 (Analytics Data Intelligence)**: métricas integração.

---

## Próximo MD recomendado

```text
MD-039 — Analytics Data Intelligence
```

Inteligência de dados.

---

## Regras Canônicas

1. Integração é transversal.
2. Portal é origem.
3. Todo webhook é assinado.
4. Todo webhook é validado.
5. Todo workflow é registrado.
6. Todo workflow é monitorado.
7. Integração respeita tenant.
8. Integração respeita security.
9. Integração respeita IA.
10. Integração respeita Analytics.
11. Webhooks têm retry.
12. Workflows têm alertas.
13. Connectors têm healthcheck.
14. Pipes têm monitoramento.
15. Integração gera eventos.
16. Integração é auditada.
17. Integração tem sandbox.
18. Integração tem staging.
19. Hub integra tudo.
20. Hub é a ponte.
21. N8N é motor principal.
22. APIs têm gateway.
23. IA tem gateway unificado.
24. ERP tem bridge.
25. Gov tem bridge.

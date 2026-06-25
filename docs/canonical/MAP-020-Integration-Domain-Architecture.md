# MAP-020 — Integration Domain Architecture

## Status
Documento Canônico de Arquitetura.
Arquitetura do domínio de integrações.

## Classificação
```text
Tipo: Domain Architecture
Camada: Domínio
Prioridade: Alta
Obrigatoriedade: Global
```

## Objetivo
Definir a arquitetura completa do Integration com bounded contexts, agregados, eventos e regras de negócio.

---

## Leis Canônicas Globais Aplicáveis

### LC-001 — Portal é a Entrada Oficial
```text
Portal → Integration → Canais Externos
```

### LC-019 — Integration sem ACL é Risco
```text
Toda integração exige conector oficial.
Nunca acesso direto ao banco.
```

### LC-006 — Tenant First
```text
Integração respeita hierarquia tenant.
```

---

## Hierarquia de Domínios
```text
Integration Domain
├── Conector Context
├── Sync Context
├── Falha Context
└── Monitoramento Context
```

---

## Fluxo Integration Oficial
```text
Trigger
↓
Connector
↓
Adapter
↓
Translator
↓
Validator
↓
Stored Procedure
```

---

## Bounded Contexts

### Conector Context
Responsável por: Conector, Tipo, Endpoint, Status, Configuração, Credenciais
Agregado: Conector

### Sync Context
Responsável por: Sync, Status, Erro, Retry, Last Run, Payload
Agregado: Sync

### Falha Context
Responsável por: Falha, Payload Original, Erro, Timestamp, Stacktrace
Agregado: Falha

### Monitoramento Context
Responsável por: Metric, Latência, Status, Throughput, Erros
Agregado: Metric

---

## Agregados Principais

### Conector Aggregate
```text
connector_id (PK)
tenant_id (FK)
tipo
nome
endpoint
config_json
ativo
criado_em
```

### Sync Aggregate
```text
sync_id (PK)
connector_id (FK)
status
last_success
last_error
retry_count
payload_size
criado_em
```

### Falha Aggregate
```text
falha_id (PK)
sync_id (FK)
connector_id (FK)
payload_original
erro
stacktrace
timestamp
```

---

## Conectores Oficiais

### Messaging
```text
WhatsApp
Email
SMS
Push
```

### Productivity
```text
Google Workspace
Microsoft 365
```

### Enterprise
```text
ERPs (SAP, Totvs, RM)
Pagamentos (Pix, Stripe, PayPal)
Gov (CNPJ, Receita)
```

### Genéricos
```text
Webhooks
APIs REST
FTP/SFTP
```

---

## Eventos Oficiais

### ConectorCriado
Payload: {connector_id, tipo, tenant_id}

### SyncIniciado
Payload: {sync_id, connector_id}

### SyncConcluido
Payload: {sync_id, registros_processados, duracao}

### SyncFalhou
Payload: {sync_id, erro, falha_id}

### FalhaDetectada
Payload: {falha_id, connector_id, payload}

---

## Stored Procedures

### sp_connector_criar
Input: {tipo, nome, config}
Output: {connector_id}

### sp_sync_executar
Input: {connector_id, payload}
Output: {sync_id}

### sp_sync_retry
Input: {sync_id}
Output: {status}

### sp_falha_registrar
Input: {sync_id, erro, payload}
Output: {falha_id}

---

## APIs Oficiais

### /api/v1/integration/connectors
POST - Criar conector
GET - Listar conectores

### /api/v1/integration/sync
POST - Executar sync

---

## Anti-Corruption Layer Pattern

Toda integração externa:
```text
Connector → Adapter → Translator → Validator → SP
```

Nunca:
```text
Acesso direto ao banco externo.
```

---

## Regras Arquiteturais

### Connector First Rule
Toda integração passa por conector registrado.

### SP First Rule
Toda escrita no banco passa por Stored Procedure.

### Tenant Isolation Rule
Conectores respeitam limites de tenant.

---

## Integrações
| MAP/MD | Finalidade |
|--------|-----------|
| MAP-005 — Portal | Acesso via Portal |
| MD-038 — Integration Hub | Hub patterns |
| FRONT-027 — Integration Hub | UX |
| FRONT-077 — Social Calendar | Calendar |
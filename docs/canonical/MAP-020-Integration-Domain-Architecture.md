# MAP-020 — Integration Domain Architecture

## Status
Documento Canônico de Arquitetura.
Arquitetura do domínio de integrações.

---

## Classificação
```text
Tipo: Domain Architecture
Camada: Domínio
Prioridade: Alta
Obrigatoriedade: Global
```

---

## Objetivo
Definir arquitetura de conectores e integrações externas.

---

## Bounded Contexts

### Conector Context
```text
Conector
Tipo
Endpoint
Status
Configuração
```

### Sync Context
```text
Sync
Status
Erro
Retry
Last Run
```

### Falha Context
```text
Falha
Payload
Erro
Timestamp
```

### Monitoramento Context
```text
Metric
Integração
Latência
Status
```

---

## Agregados

### Conector Aggregate
```text
connector_id
tenant_id
tipo
nome
config_json
ativo
```

### Sync Aggregate
```text
sync_id
connector_id
status
last_success
last_error
retry_count
```

---

## Conectores Oficiais

### WhatsApp
### Email
### Google Workspace
### Microsoft 365
### ERPs
### APIs Genéricas
### Webhooks

---

## Eventos Oficiais

### ConectorCriado
### SyncIniciado
### SyncConcluido
### SyncFalhou
### FalhaDetectada

---

## Stored Procedures

### sp_connector_criar
### sp_sync_executar
### sp_sync_retry
### sp_falha_registrar

---

## Integrações
| MAP/MD | Finalidade |
|--------|-----------|
| MAP-001 — Enterprise Domain | Foundation |
| MD-038 — Integration Hub | Hub |
| FRONT-027 — Integration Hub | UX |
| FRONT-077 — Social Calendar | Calendar |
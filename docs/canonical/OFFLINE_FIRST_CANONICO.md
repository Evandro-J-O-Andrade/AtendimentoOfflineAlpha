# OFFLINE_FIRST_CANONICO.md

## Arquitetura Offline-First

A plataforma deve operar sem internet de forma transparente.

```
Runtime Local
→ Fila
→ Reconciliação
→ Spine Central (backend)
```

## Componentes Canônicos

### 1. Runtime Local

Contexto e estado mantidos localmente.

```javascript
// localStorage
runtime: {
    id_saas_entidade,
    id_unidade,
    id_local_operacional,
    contexto_selecionado
}

fila_local: [
    { id, operacao, payload, status }
]
```

### 2. Fila Local

Operações enfileiradas para sincronização posterior.

```sql
fila_local (
    id_fila_local PK,
    operacao,
    payload_json,
    status (PENDENTE | PROCESSANDO | CONCLUIDO | ERRO),
    tentativas,
    data_criacao,
    data_sync
)
```

### 3. Reconciliação

Sincronização automática quando conectado.

- Polling automático a cada 5s
- Retry exponencial
- Conflito de versão detectado
- Resolução automática ou intervenção manual

### 4. Spine Central

Gateway único de entrada: `sp_master_dispatcher_runtime`

- Validação de idempotência via uuid_transacao
- Estado determinístico
- Auditoria obrigatória
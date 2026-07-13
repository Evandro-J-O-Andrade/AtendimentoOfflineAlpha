# API-CATALOG

## Status

```text
CANÔNICO (ARQUITETURA)
CICLO 2 — Kernel Enterprise
Catálogo de APIs do Kernel.
```

---

## 1. Propósito

Este documento é o **catálogo oficial de APIs** do Kernel Enterprise.

Ele serve para:
- Listar todos os endpoints do Kernel
- Definir contratos de request/response
- Garantir consistência entre frontend e backend
- Servir como referência para implementação

API não é apenas URL.
API é **contrato de comunicação entre Core e consumidores**.

---

## 2. Princípio Fundamental

```text
API é contrato.
API é versionada.
API é documentada.
API é governada.
Frontend consome API.
Backend expõe API.
Nenhum acesso direto a banco.
```

---

## 3. Versionamento

### 3.1 Formato

```text
/api/v1/{domínio}/{ação}

Exemplos:
  /api/v1/auth/login
  /api/v1/context/resolve
  /api/v1/runtime/execute
```

### 3.2 Política

```text
Major version: mudança incompatível
Minor version: nova funcionalidade compatível
Patch version: correção de bug

Nenhuma alteração incompatível sem nova versão.
Versões anteriores mantidas por período de deprecação.
```

---

## 4. Autenticação

### 4.1 Header

```text
Authorization: Bearer {token}
```

### 4.2 Refresh

```text
POST /api/v1/auth/refresh

Request:
  {
    "refreshToken": "string"
  }

Response 200:
  {
    "success": true,
    "data": {
      "token": "string",
      "expiresAt": "string (ISO8601)"
    }
  }
```

### 4.3 Revoke

```text
POST /api/v1/auth/revoke

Request:
  {
    "sessionId": "string"
  }

Response 200:
  {
    "success": true,
    "data": {
      "revoked": true
    }
  }
```

---

## 5. Endpoints

### 5.1 Auth

| Método | Endpoint | Descrição | SP |
|--------|----------|-----------|-----|
| POST | /auth/login | Autenticar | sp_mas_auth_login |
| POST | /auth/refresh | Renovar token | sp_mas_auth_refresh |
| POST | /auth/revoke | Revogar sessão | sp_cmd_sessao_revoke |
| GET | /auth/me | Obter sessão atual | sp_qry_sessao_get |

### 5.2 Context

| Método | Endpoint | Descrição | SP |
|--------|----------|-----------|-----|
| POST | /context/resolve | Resolver contexto | sp_orc_contexto_resolve |
| POST | /context/switch | Trocar contexto | sp_cmd_contexto_switch |
| GET | /context/options | Opções de contexto | sp_qry_contexto_options |
| GET | /context/active | Contexto ativo | sp_qry_contexto_get |

### 5.3 Runtime

| Método | Endpoint | Descrição | SP |
|--------|----------|-----------|-----|
| POST | /runtime/execute | Executar capability | sp_exe_runtime_execute |
| GET | /runtime/status/{id} | Status de execução | sp_qry_runtime_status |
| POST | /runtime/cancel | Cancelar execução | sp_cmd_runtime_cancel |

### 5.4 Navigation

| Método | Endpoint | Descrição | SP |
|--------|----------|-----------|-----|
| POST | /navigation/project | Projetar navegação | sp_orc_navigation_project |
| GET | /navigation/menu | Obter menu | sp_qry_navigation_menu |
| GET | /navigation/dashboard | Obter dashboard | sp_qry_navigation_dashboard |

### 5.5 Workflow

| Método | Endpoint | Descrição | SP |
|--------|----------|-----------|-----|
| POST | /workflow/start | Iniciar workflow | sp_orc_workflow_start |
| POST | /workflow/transition | Transicionar workflow | sp_exe_workflow_transition |
| GET | /workflow/state/{id} | Estado do workflow | sp_qry_workflow_state |
| POST | /workflow/compensate | Compensar workflow | sp_cmd_workflow_compensate |

### 5.6 Event

| Método | Endpoint | Descrição | SP |
|--------|----------|-----------|-----|
| POST | /event/publish | Publicar evento | sp_evt_event_publish |
| POST | /event/subscribe | Subscrever evento | sp_evt_event_subscribe |
| GET | /event/stream | Stream de eventos | sp_qry_event_stream |

### 5.7 Integration

| Método | Endpoint | Descrição | SP |
|--------|----------|-----------|-----|
| POST | /integration/auth | Autenticar sistema externo | sp_mas_integration_auth |
| GET | /integration/data/{resource} | Obter dados externos | sp_qry_integration_data |
| POST | /integration/execute | Executar integração | sp_exe_integration_execute |

---

## 6. Erros

### 6.1 Códigos

| Código | Significado | HTTP |
|--------|-------------|------|
| INVALID_CREDENTIALS | Credenciais inválidas | 401 |
| SESSION_EXPIRED | Sessão expirada | 401 |
| SESSION_REVOKED | Sessão revogada | 401 |
| CONTEXT_NOT_FOUND | Contexto não encontrado | 404 |
| CONTEXT_SWITCH_NOT_ALLOWED | Troca de contexto não permitida | 403 |
| EXECUTION_NOT_AUTHORIZED | Execução não autorizada | 403 |
| CAPABILITY_NOT_FOUND | Capability não encontrada | 404 |
| WORKFLOW_NOT_FOUND | Workflow não encontrado | 404 |
| TRANSITION_NOT_ALLOWED | Transição não permitida | 403 |
| INTEGRATION_NOT_AUTHORIZED | Integração não autorizada | 403 |
| RATE_LIMIT_EXCEEDED | Rate limit excedido | 429 |
| VALIDATION_ERROR | Erro de validação | 422 |
| INTERNAL_ERROR | Erro interno | 500 |

### 6.2 Formato

```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Mensagem legível",
    "details": {}
  }
}
```

---

## 7. Contratos TypeScript

### 7.1 Estrutura

```
packages/contracts/src/
  ├── auth/
  │   ├── login.ts
  │   ├── refresh.ts
  │   ├── revoke.ts
  │   └── me.ts
  ├── context/
  │   ├── resolve.ts
  │   ├── switch.ts
  │   └── options.ts
  ├── runtime/
  │   ├── execute.ts
  │   └── status.ts
  ├── navigation/
  │   ├── project.ts
  │   └── formats.ts
  ├── workflow/
  │   ├── start.ts
  │   ├── transition.ts
  │   └── state.ts
  ├── event/
  │   ├── publish.ts
  │   └── subscribe.ts
  ├── integration/
  │   ├── auth.ts
  │   └── data.ts
  └── base.ts
```

### 7.2 Exemplos

```typescript
// contracts/src/auth/login.ts
export interface LoginRequest {
  identity: string
  credentials: {
    password: string
    mfaCode?: string
  }
}

export interface LoginResponse {
  session: {
    id: string
    expiresAt: string
    tenant: {
      id: string
      name: string
    }
  }
  token: string
  identity: {
    id: string
    type: 'pessoa' | 'servico' | 'api' | 'terminal' | 'agente'
    name: string
    email: string
  }
}

// contracts/src/context/resolve.ts
export interface ContextResolveRequest {
  sessionId: string
  identityId: string
  tenantId: string
}

export interface ContextResponse {
  context: {
    id: string
    unidade: { id: string; nome: string }
    local: { id: string; nome: string }
    perfil: { id: string; nome: string }
    sistema: { id: string; nome: string }
    aplicacao: { id: string; nome: string }
    ambiente: 'producao' | 'homologacao' | 'treinamento'
    runtime: 'web' | 'mobile' | 'api' | 'display' | 'totem'
  }
}

// contracts/src/runtime/execute.ts
export interface RuntimeExecuteRequest {
  capabilityId: string
  operation: string
  contextId: string
  parameters: Record<string, any>
}

export interface RuntimeExecuteResponse {
  executionId: string
  status: 'completed' | 'failed' | 'pending'
  result: Record<string, any>
  metadata: Record<string, any>
}
```

---

## 8. Cliente HTTP

### 8.1 Configuração

```typescript
const client = createHttpClient({
  baseURL: '/api/v1',
  headers: {
    'Content-Type': 'application/json'
  },
  interceptors: {
    request: [
      (config) => {
        const token = getToken()
        if (token) {
          config.headers.Authorization = `Bearer ${token}`
        }
        return config
      }
    ],
    response: [
      (response) => response,
      (error) => {
        if (error.response?.status === 401) {
          // Refresh token
        }
        return Promise.reject(error)
      }
    ]
  }
})
```

### 8.2 Uso

```typescript
// GET
const { data } = await client.get('/auth/me')

// POST
const { data } = await client.post('/auth/login', {
  identity: 'user',
  credentials: { password: 'pass' }
})

// PUT
const { data } = await client.put('/context/switch', {
  contextId: 'ctx-123'
})

// DELETE
await client.delete('/auth/revoke', {
  data: { sessionId: 'sess-123' }
})
```

---

## 9. Regras de Governança

### 9.1 Criação de endpoint

```text
Novo endpoint:
1. Definir contrato TypeScript
2. Documentar em API-CATALOG.md
3. Implementar no backend
4. Implementar no frontend
5. Testar
6. Aprovar
```

### 9.2 Alteração de endpoint

```text
Alterar endpoint:
1. Criar nova versão
2. Manter versão anterior
3. Migrar consumidores gradualmente
4. Remover versão antiga após período
```

### 9.3 Exclusão de endpoint

```text
Excluir endpoint:
1. Verificar dependências
2. Migrar consumidores
3. Marcar como deprecated
4. Remover após período
```

---

## 10. Integração com SPs

### 10.1 Mapeamento

| Endpoint | SP | Tipo |
|----------|-----|------|
| POST /auth/login | sp_mas_auth_login | MASTER |
| POST /context/resolve | sp_orc_contexto_resolve | ORCHESTRATOR |
| POST /runtime/execute | sp_exe_runtime_execute | EXECUTOR |
| POST /event/publish | sp_evt_event_publish | EVENT |
| POST /ledger/append | sp_led_ledger_append | LEDGER |

### 10.2 Fluxo

```text
Frontend
  ↓
API
  ↓
Backend
  ↓
SP Master (valida contrato, permissão)
  ↓
SP Dispatcher (roteia)
  ↓
SP Executor (executa)
  ↓
Banco
  ↓
SP Event (registra evento)
  ↓
SP Ledger (registra evidência)
  ↓
Response
  ↓
Frontend
```

---

## 11. Próximos Artefatos

| Prioridade | Artefato | Descrição |
|------------|----------|-----------|
| Baixa | [Nenhum] | Catálogo completo |

---

## 12. Referências

- FRONT-CONTRACTS
- FRONTEND-API
- SP-KERNEL-CATALOG
- MODEL-PHYSICAL-KERNEL
- MAP-CORE-PLATFORM
- MD-KERNEL-000 — Arquitetura Conceitual do Kernel Enterprise
- MD-KERNEL-001 até MD-KERNEL-014
- BR-CATALOG
- MD-110 — Canonical Laws
- MD-113 — Lei da Singularidade Canônica
- 000-CONSTITUICAO-IA.md

---

## 13. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-13 | Kilo | Criação do catálogo de APIs |

---

Documento Canônico — API-CATALOG

**Este é o documento oficial de APIs do Kernel da plataforma New Wave Enterprise.**

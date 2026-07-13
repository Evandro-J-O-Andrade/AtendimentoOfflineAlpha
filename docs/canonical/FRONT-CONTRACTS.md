# FRONT-CONTRACTS

## Status

```text
CANÔNICO (ARQUITETURA)
CICLO 2 — Kernel Enterprise
Contratos entre frontend e Core/Backend.
```

---

## 1. Objetivo

Este documento define os **contratos oficiais entre frontend e Core/Backend** da plataforma New Wave Enterprise.

Ele serve para:
- Definir endpoints de API
- Definir tipos de request/response
- Garantir tipagem forte
- Evutar ambiguidade
- Servir como referência para implementação

Contratos não são implementação.
Contratos são **acordos de comunicação**.

---

## 2. Princípio Fundamental

```text
Frontend consome contratos.
Backend implementa contratos.
Contratos são imutáveis uma vez aprovados.
Qualquer alteração exige versionamento.
```

---

## 3. Padrão de Contrato

### 3.1 Estrutura

```text
POST /api/{domínio}/{ação}
Authorization: Bearer {token}
Content-Type: application/json

Request:
  {
    "campo": "valor"
  }

Response 200:
  {
    "success": true,
    "data": {},
    "meta": {}
  }

Response 400/401/403/404/500:
  {
    "success": false,
    "error": {
      "code": "ERROR_CODE",
      "message": "Mensagem legível"
    }
  }
```

### 3.2 Versionamento

```text
Formato: /api/v1/{domínio}/{ação}

Exemplos:
  /api/v1/auth/login
  /api/v1/context/resolve
  /api/v1/runtime/execute
  /api/v1/navigation/project
```

### 3.3 Erros

| Código | Significado |
|--------|-------------|
| 400 | Bad Request |
| 401 | Unauthorized |
| 403 | Forbidden |
| 404 | Not Found |
| 409 | Conflict |
| 422 | Unprocessable Entity |
| 429 | Too Many Requests |
| 500 | Internal Server Error |
| 503 | Service Unavailable |

---

## 4. Contratos de Auth

### 4.1 Login

```text
POST /api/v1/auth/login

Request:
  {
    "identity": "string",
    "credentials": {
      "password": "string",
      "mfaCode": "string" (opcional)
    }
  }

Response 200:
  {
    "success": true,
    "data": {
      "session": {
        "id": "string",
        "expiresAt": "string (ISO8601)",
        "tenant": {
          "id": "string",
          "name": "string"
        }
      },
      "token": "string",
      "identity": {
        "id": "string",
        "type": "pessoa|servico|api|terminal|agente",
        "name": "string",
        "email": "string"
      }
    }
  }

Response 401:
  {
    "success": false,
    "error": {
      "code": "INVALID_CREDENTIALS",
      "message": "Credenciais inválidas"
    }
  }
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

### 4.4 Me

```text
GET /api/v1/auth/me

Response 200:
  {
    "success": true,
    "data": {
      "identity": {
        "id": "string",
        "type": "pessoa|servico|api|terminal|agente",
        "name": "string",
        "email": "string"
      },
      "session": {
        "id": "string",
        "expiresAt": "string (ISO8601)"
      },
      "tenant": {
        "id": "string",
        "name": "string"
      }
    }
  }
```

---

## 5. Contratos de Context

### 5.1 Resolve

```text
POST /api/v1/context/resolve

Request:
  {
    "sessionId": "string",
    "identityId": "string",
    "tenantId": "string"
  }

Response 200:
  {
    "success": true,
    "data": {
      "context": {
        "id": "string",
        "unidade": {
          "id": "string",
          "nome": "string"
        },
        "local": {
          "id": "string",
          "nome": "string"
        },
        "perfil": {
          "id": "string",
          "nome": "string"
        },
        "sistema": {
          "id": "string",
          "nome": "string"
        },
        "aplicacao": {
          "id": "string",
          "nome": "string"
        },
        "ambiente": "producao|homologacao|treinamento",
        "runtime": "web|mobile|api|display|totem"
      }
    }
  }
```

### 5.2 Switch

```text
POST /api/v1/context/switch

Request:
  {
    "sessionId": "string",
    "contextId": "string",
    "targetUnidade": "string",
    "targetLocal": "string",
    "targetPerfil": "string"
  }

Response 200:
  {
    "success": true,
    "data": {
      "context": {
        "id": "string",
        "unidade": { "id": "string", "nome": "string" },
        "local": { "id": "string", "nome": "string" },
        "perfil": { "id": "string", "nome": "string" },
        "sistema": { "id": "string", "nome": "string" },
        "aplicacao": { "id": "string", "nome": "string" },
        "ambiente": "string",
        "runtime": "string"
      }
    }
  }

Response 403:
  {
    "success": false,
    "error": {
      "code": "CONTEXT_SWITCH_NOT_ALLOWED",
      "message": "Troca de contexto não permitida"
    }
  }
```

### 5.3 Options

```text
GET /api/v1/context/options

Response 200:
  {
    "success": true,
    "data": {
      "unidades": [
        { "id": "string", "nome": "string" }
      ],
      "locais": [
        { "id": "string", "nome": "string", "unidadeId": "string" }
      ],
      "perfis": [
        { "id": "string", "nome": "string" }
      ]
    }
  }
```

---

## 6. Contratos de Runtime

### 6.1 Execute

```text
POST /api/v1/runtime/execute

Request:
  {
    "capabilityId": "string",
    "operation": "string",
    "contextId": "string",
    "parameters": {}
  }

Response 200:
  {
    "success": true,
    "data": {
      "executionId": "string",
      "status": "completed|failed|pending",
      "result": {},
      "metadata": {}
    }
  }

Response 403:
  {
    "success": false,
    "error": {
      "code": "EXECUTION_NOT_AUTHORIZED",
      "message": "Execução não autorizada"
    }
  }
```

### 6.2 Status

```text
GET /api/v1/runtime/status/{executionId}

Response 200:
  {
    "success": true,
    "data": {
      "executionId": "string",
      "status": "completed|failed|pending|running",
      "result": {},
      "startedAt": "string (ISO8601)",
      "completedAt": "string (ISO8601)"
    }
  }
```

---

## 7. Contratos de Navigation

### 7.1 Project

```text
POST /api/v1/navigation/project

Request:
  {
    "contextId": "string",
    "consumer": "portal|mobile|display|totem|api",
    "format": "menu|dashboard|actions|list|flow|state"
  }

Response 200:
  {
    "success": true,
    "data": {
      "projection": {
        "menu": [
          {
            "id": "string",
            "label": "string",
            "icon": "string",
            "path": "string",
            "children": []
          }
        ],
        "dashboard": [
          {
            "id": "string",
            "type": "widget|chart|table",
            "title": "string",
            "data": {}
          }
        ],
        "actions": [
          {
            "id": "string",
            "label": "string",
            "capabilityId": "string",
            "variant": "primary|secondary|danger"
          }
        ]
      }
    }
  }
```

---

## 8. Contratos de Workflow

### 8.1 Start

```text
POST /api/v1/workflow/start

Request:
  {
    "workflowId": "string",
    "contextId": "string",
    "parameters": {}
  }

Response 200:
  {
    "success": true,
    "data": {
      "processId": "string",
      "state": "string",
      "nextTransitions": []
    }
  }
```

### 8.2 Transition

```text
POST /api/v1/workflow/transition

Request:
  {
    "processId": "string",
    "transitionId": "string",
    "parameters": {}
  }

Response 200:
  {
    "success": true,
    "data": {
      "processId": "string",
      "state": "string",
      "nextTransitions": []
    }
  }
```

### 8.3 State

```text
GET /api/v1/workflow/state/{processId}

Response 200:
  {
    "success": true,
    "data": {
      "processId": "string",
      "workflowId": "string",
      "state": "string",
      "history": [],
      "nextTransitions": []
    }
  }
```

---

## 9. Contratos de Event

### 9.1 Subscribe

```text
POST /api/v1/event/subscribe

Request:
  {
    "eventTypes": ["string"],
    "consumer": "string"
  }

Response 200:
  {
    "success": true,
    "data": {
      "subscriptionId": "string"
    }
  }
```

### 9.2 Publish (Admin)

```text
POST /api/v1/event/publish

Request:
  {
    "eventType": "string",
    "payload": {},
    "correlationId": "string"
  }

Response 200:
  {
    "success": true,
    "data": {
      "eventId": "string"
    }
  }
```

---

## 10. Contratos de Integration

### 10.1 External Auth

```text
POST /api/v1/integration/auth

Request:
  {
    "system": "string",
    "credentials": {}
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

### 10.2 External Data

```text
GET /api/v1/integration/data/{resource}

Response 200:
  {
    "success": true,
    "data": {}
  }
```

---

## 11. Tipos Compartilhados

### 11.1 Tipos base

```typescript
// contracts/src/base.ts

export interface ApiResponse<T> {
  success: boolean
  data: T
  error?: ApiError
  meta?: ApiMeta
}

export interface ApiError {
  code: string
  message: string
  details?: Record<string, any>
}

export interface ApiMeta {
  timestamp: string
  requestId: string
  correlationId?: string
}
```

### 11.2 Tipos de Auth

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
```

### 11.3 Tipos de Context

```typescript
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
```

### 11.4 Tipos de Runtime

```typescript
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

### 11.5 Tipos de Navigation

```typescript
// contracts/src/navigation/project.ts

export interface NavigationProjectRequest {
  contextId: string
  consumer: 'portal' | 'mobile' | 'display' | 'totem' | 'api'
  format: 'menu' | 'dashboard' | 'actions' | 'list' | 'flow' | 'state'
}

export interface NavigationProjectResponse {
  projection: {
    menu: MenuItem[]
    dashboard: DashboardWidget[]
    actions: ActionItem[]
  }
}

export interface MenuItem {
  id: string
  label: string
  icon: string
  path: string
  children: MenuItem[]
}

export interface DashboardWidget {
  id: string
  type: 'widget' | 'chart' | 'table'
  title: string
  data: Record<string, any>
}

export interface ActionItem {
  id: string
  label: string
  capabilityId: string
  variant: 'primary' | 'secondary' | 'danger'
}
```

---

## 12. Regras de Governança

### 12.1 Criação de contrato

```text
Novo contrato:
1. Verificar se já existe contrato equivalente
2. Se existir: reutilizar
3. Se não existir: criar com tipos completos
4. Documentar
5. Aprovar
6. Versionar
```

### 12.2 Alteração de contrato

```text
Alterar contrato:
1. Avaliar impacto em todos os consumidores
2. Criar nova versão
3. Manter versão anterior funcionando
4. Migrar consumidores gradualmente
5. Remover versão antiga após período
```

### 12.3 Exclusão de contrato

```text
Excluir contrato:
1. Verificar dependências
2. Migrar consumidores
3. Marcar como deprecated
4. Remover após período
```

---

## 13. Próximos Artefatos

| Prioridade | Artefato | Descrição |
|------------|----------|-----------|
| Média | FRONTEND-TESTING.md | Estratégia de testes |
| Baixa | FRONTEND-API.md | Documentação de API |

---

## 14. Referências

- FRONT-CATALOG
- FRONTEND-AUDIT
- ASSET-INVENTORY
- FRONT-DESIGN-SYSTEM
- FRONTEND-ARCHITECTURE
- FRONT-KERNEL-MAP
- MAP-CORE-PLATFORM
- MD-KERNEL-000 — Arquitetura Conceitual do Kernel Enterprise
- MD-KERNEL-001 até MD-KERNEL-014
- BR-CATALOG
- MD-110 — Canonical Laws
- MD-113 — Lei da Singularidade Canônica
- 000-CONSTITUICAO-IA.md

---

## 15. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-13 | Kilo | Criação dos contratos frontend |

---

Documento Canônico — FRONT-CONTRACTS

**Este é o documento oficial de contratos entre frontend e Core/Backend da plataforma New Wave Enterprise.**

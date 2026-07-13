# FRONTEND-API

## Status

```text
CANÔNICO (ARQUITETURA)
CICLO 2 — Kernel Enterprise
Documentação de API do frontend.
```

---

## 1. Objetivo

Este documento é a **documentação oficial de API** da plataforma New Wave Enterprise.

Ele serve para:
- Mapear todos os endpoints consumidos pelo frontend
- Definir contratos de request/response
- Documentar códigos de erro
- Servir como referência para implementação

API não é apenas URL.
API é **contrato de comunicação entre frontend e backend**.

---

## 2. Princípio Fundamental

```text
Frontend consome API.
Backend expõe API.
API é contrato.
API é versionada.
API é documentada.
```

---

## 3. Base URL

```text
Desenvolvimento: http://localhost:3000/api/v1
Homologação: https://api-hom.empresa.com/v1
Produção: https://api.empresa.com/v1
```

---

## 4. Autenticação

### 4.1 Header

```text
Authorization: Bearer {token}
```

### 4.2 Refresh

```text
Quando o token expira:
1. Frontend recebe 401
2. Frontend chama /auth/refresh
3. Se sucesso: repete requisição original
4. Se falha: redireciona para login
```

---

## 5. Endpoints

### 5.1 Auth

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| POST | /auth/login | Autenticar |
| POST | /auth/refresh | Renovar token |
| POST | /auth/revoke | Revogar sessão |
| GET | /auth/me | Obter sessão atual |

### 5.2 Context

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| POST | /context/resolve | Resolver contexto |
| POST | /context/switch | Trocar contexto |
| GET | /context/options | Opções de contexto |

### 5.3 Runtime

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| POST | /runtime/execute | Executar capability |
| GET | /runtime/status/{id} | Status de execução |

### 5.4 Navigation

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| POST | /navigation/project | Projetar navegação |

### 5.5 Workflow

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| POST | /workflow/start | Iniciar workflow |
| POST | /workflow/transition | Transicionar workflow |
| GET | /workflow/state/{id} | Estado do workflow |

### 5.6 Event

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| POST | /event/publish | Publicar evento |
| POST | /event/subscribe | Subscrever evento |

### 5.7 Integration

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| POST | /integration/auth | Autenticar sistema externo |
| GET | /integration/data/{resource} | Obter dados externos |

---

## 6. Erros

### 6.1 Códigos

| Código | Significado |
|--------|-------------|
| INVALID_CREDENTIALS | Credenciais inválidas |
| SESSION_EXPIRED | Sessão expirada |
| SESSION_REVOKED | Sessão revogada |
| CONTEXT_NOT_FOUND | Contexto não encontrado |
| CONTEXT_SWITCH_NOT_ALLOWED | Troca de contexto não permitida |
| EXECUTION_NOT_AUTHORIZED | Execução não autorizada |
| CAPABILITY_NOT_FOUND | Capability não encontrada |
| WORKFLOW_NOT_FOUND | Workflow não encontrado |
| TRANSITION_NOT_ALLOWED | Transição não permitida |
| INTEGRATION_NOT_AUTHORIZED | Integração não autorizada |
| RATE_LIMIT_EXCEEDED | Rate limit excedido |
| VALIDATION_ERROR | Erro de validação |
| INTERNAL_ERROR | Erro interno |

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

## 7. Cliente HTTP

### 7.1 Configuração

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

### 7.2 Uso

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

## 8. Contratos TypeScript

### 8.1 Estrutura

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

### 8.2 Exemplo

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

---

## 9. Regras de Governança

### 9.1 Criação de endpoint

```text
Novo endpoint:
1. Definir contrato TypeScript
2. Documentar em FRONTEND-API.md
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
3. Migrar consumidores
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

## 10. Referências

- FRONT-CATALOG
- FRONTEND-AUDIT
- ASSET-INVENTORY
- FRONT-DESIGN-SYSTEM
- FRONTEND-ARCHITECTURE
- FRONT-KERNEL-MAP
- FRONT-CONTRACTS
- MAP-CORE-PLATFORM
- MD-KERNEL-000 — Arquitetura Conceitual do Kernel Enterprise
- MD-KERNEL-001 até MD-KERNEL-014
- BR-CATALOG
- MD-110 — Canonical Laws
- MD-113 — Lei da Singularidade Canônica
- 000-CONSTITUICAO-IA.md

---

## 11. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-13 | Kilo | Criação da documentação de API |

---

Documento Canônico — FRONTEND-API

**Este é o documento oficial de API da plataforma New Wave Enterprise.**

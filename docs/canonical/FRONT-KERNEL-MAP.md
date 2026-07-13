# FRONT-KERNEL-MAP

## Status

```text
CANÔNICO (ARQUITETURA)
CICLO 2 — Kernel Enterprise
Mapa de relacionamento frontend × Kernel.
```

---

## 1. Objetivo

Este documento é o **mapa oficial de relacionamento entre frontend e Kernel** da plataforma New Wave Enterprise.

Ele serve para:
- Mapear quais domínios do Kernel são consumidos pelo frontend
- Definir como o frontend acessa cada domínio
- Evitar acesso direto a banco
- Evitar regra de negócio no frontend
- Garantir que o frontend seja apenas projeção

Frontend não é um sistema independente.
Frontend é a **camada de projeção do Kernel/Core**.

---

## 2. Princípio Fundamental

```text
Frontend consome Core Platform.
Frontend não acessa Kernel diretamente.
Frontend não acessa banco.
Frontend não contém regra de negócio.
Frontend apenas projeta o estado resolvido pelo Kernel.
```

---

## 3. Mapa de Consumo

### 3.1 Visão geral

| Domínio Kernel | Consumido por Frontend | Como | Quando |
|----------------|------------------------|------|--------|
| Identity | Auth Runtime | AuthProvider, guards | Login, sessão |
| Tenant | Context Runtime | ContextProvider | Seleção de contexto |
| Session | Auth Runtime | SessionProvider | Toda operação |
| Context | Context Runtime | ContextProvider | Toda operação |
| Authorization | Runtime Runtime | RuntimeProvider | Toda execução |
| Discovery | Navigation Runtime | NavigationProvider | Navegação |
| Registry | Navigation Runtime | NavigationProvider | Navegação |
| Capability | Runtime Runtime | RuntimeProvider | Execução |
| Runtime | Runtime Runtime | RuntimeProvider | Execução |
| Navigation | Navigation Runtime | NavigationProvider | Navegação |
| Workflow | Workflow Runtime | WorkflowProvider | Fluxos |
| Event | Event Runtime | EventProvider | Eventos |
| Ledger | Ledger Runtime | LedgerProvider | Auditoria |
| Integration | Integration Runtime | IntegrationProvider | Integrações |

### 3.2 Matriz de consumo

| Frontend | Identity | Tenant | Session | Context | Authorization | Discovery | Registry | Capability | Runtime | Navigation | Workflow | Event | Ledger | Integration |
|----------|----------|--------|---------|---------|---------------|-----------|----------|------------|---------|------------|---------|-------|--------|-------------|
| Portal Enterprise | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Mobile | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Display/TV | ✅ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Totem | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| API Gateway | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ✅ | ✅ | ❌ | ❌ | ✅ | ✅ | ✅ |

---

## 4. Contratos

### 4.1 Auth Contract

```text
Frontend → Backend
  Login: POST /api/auth/login
  Refresh: POST /api/auth/refresh
  Revoke: POST /api/auth/revoke

Backend → Frontend
  Session: AuthSessionContract
  Token: string
  Identity: UserContract
```

### 4.2 Context Contract

```text
Frontend → Backend
  Resolve: POST /api/context/resolve
  Switch: POST /api/context/switch

Backend → Frontend
  Context: ContextContract
  Options: ContextOption[]
```

### 4.3 Runtime Contract

```text
Frontend → Backend
  Execute: POST /api/runtime/execute
  Status: GET /api/runtime/status

Backend → Frontend
  Result: RuntimeResult
  Status: RuntimeStatus
```

### 4.4 Navigation Contract

```text
Frontend → Backend
  Project: POST /api/navigation/project

Backend → Frontend
  Projection: NavigationProjection
  Menu: MenuItem[]
  Dashboard: DashboardWidget[]
  Actions: ActionItem[]
```

---

## 5. Fluxos

### 5.1 Login

```text
Usuário
 ↓
Login Page
 ↓
AuthProvider.login()
 ↓
Auth Contract
 ↓
Backend
 ↓
Session criada
 ↓
ContextResolver.resolve()
 ↓
ContextProvider.set()
 ↓
Portal Runtime
 ↓
Navigation.projection()
 ↓
Portal UI
```

### 5.2 Seleção de Contexto

```text
Usuário
 ↓
Context Selection Page
 ↓
ContextProvider.resolve()
 ↓
Context Contract
 ↓
Backend
 ↓
Contexto resolvido
 ↓
Navigation.projection()
 ↓
Portal UI
```

### 5.3 Execução

```text
Usuário
 ↓
Ação na UI
 ↓
RuntimeProvider.execute()
 ↓
Runtime Contract
 ↓
Backend
 ↓
Authorization.validate()
 ↓
Runtime.execute()
 ↓
Resultado
 ↓
UI atualizada
```

### 5.4 Navegação

```text
Portal UI
 ↓
NavigationProvider.project()
 ↓
Navigation Contract
 ↓
Backend
 ↓
Discovery.resolve()
 ↓
Capability.list()
 ↓
Navigation.projection()
 ↓
Menu atualizado
```

---

## 6. Providers

### 6.1 AuthProvider

```text
Responsabilidades:
  - Autenticação
  - Sessão
  - Token
  - Refresh
  - Revoke

Consome:
  - Auth Contract
  - Session (Kernel)

Expõe:
  - login()
  - logout()
  - refresh()
  - session
  - identity
```

### 6.2 ContextProvider

```text
Responsabilidades:
  - Contexto operacional
  - Troca de contexto
  - Snapshots

Consome:
  - Context Contract
  - Context (Kernel)

Expõe:
  - resolve()
  - switch()
  - context
  - options
```

### 6.3 RuntimeProvider

```text
Responsabilidades:
  - Execução
  - Estado
  - Capacidades

Consome:
  - Runtime Contract
  - Runtime (Kernel)
  - Capability (Kernel)

Expõe:
  - execute()
  - status()
  - capabilities
```

### 6.4 NavigationProvider

```text
Responsabilidades:
  - Navegação
  - Menus
  - Projeção

Consome:
  - Navigation Contract
  - Discovery (Kernel)
  - Capability (Kernel)
  - Navigation (Kernel)

Expõe:
  - project()
  - menu
  - dashboard
  - actions
```

---

## 7. Guards

### 7.1 AuthGuard

```text
Responsabilidade:
  - Verificar sessão ativa
  - Redirecionar para login se necessário

Consome:
  - AuthProvider
  - Session (Kernel)
```

### 7.2 ContextGuard

```text
Responsabilidade:
  - Verificar contexto resolvido
  - Redirecionar para seleção de contexto se necessário

Consome:
  - ContextProvider
  - Context (Kernel)
```

### 7.3 GuestGuard

```text
Responsabilidade:
  - Permitir apenas usuários não autenticados
  - Redirecionar para portal se autenticado

Consome:
  - AuthProvider
  - Session (Kernel)
```

---

## 8. Componentes

### 8.1 Componentes que consomem Kernel

| Componente | Consome | Como |
|------------|---------|------|
| LoginForm | AuthProvider | Formulário de login |
| ContextSelector | ContextProvider | Seleção de contexto |
| NavigationMenu | NavigationProvider | Menu de navegação |
| Dashboard | RuntimeProvider | Dashboard widgets |
| CapabilityCard | RuntimeProvider | Card de capability |
| ActionButton | RuntimeProvider | Ação executável |

### 8.2 Componentes que NÃO consomem Kernel

| Componente | Responsabilidade |
|------------|------------------|
| Button | Visual |
| Input | Visual |
| Card | Visual |
| Modal | Visual |
| Table | Visual |
| Toast | Visual |

---

## 9. Regras

### 9.1 Frontend não pode

```text
❌ Acessar banco diretamente
❌ Executar SP diretamente
❌ Decidir permissão
❌ Conter regra de negócio
❌ Montar menu hardcoded
❌ Criar sessão sem Auth Runtime
❌ Resolver contexto sem Context Runtime
❌ Executar capacidade sem Runtime
```

### 9.2 Frontend deve

```text
✅ Consumir Core Platform via contratos
✅ Usar providers para estado
✅ Usar componentes do Design System
✅ Respeitar tokens
✅ Ser acessível
✅ Ser responsivo
✅ Ter testes
```

---

## 10. Integração com Core

### 10.1 Core Packages

```text
packages/
  ├── core/
  │   ├── auth/ → AuthProvider
  │   ├── context/ → ContextProvider
  │   ├── runtime/ → RuntimeProvider
  │   ├── navigation/ → NavigationProvider
  │   ├── workflow/ → WorkflowProvider
  │   ├── integration/ → IntegrationProvider
  │   ├── event/ → EventProvider
  │   └── ledger/ → LedgerProvider
  │
  ├── contracts/ → Tipos e contratos
  ├── api/ → Cliente HTTP
  ├── design-system/ → Tokens e componentes
  └── layout/ → Layouts
```

### 10.2 Fluxo de dados

```text
Frontend
  ↓
Core Packages
  ↓
Contracts
  ↓
API Client
  ↓
Backend
  ↓
Kernel/Core Runtime
  ↓
Banco
```

---

## 11. Próximos Artefatos

| Prioridade | Artefato | Descrição |
|------------|----------|-----------|
| Alta | FRONT-CONTRACTS.md | Contratos frontend detalhados |
| Média | FRONTEND-TESTING.md | Estratégia de testes |
| Baixa | FRONTEND-API.md | Documentação de API |

---

## 12. Referências

- FRONT-CATALOG
- FRONTEND-AUDIT
- ASSET-INVENTORY
- FRONT-DESIGN-SYSTEM
- FRONTEND-ARCHITECTURE
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
| 1.0 | 2026-07-13 | Kilo | Criação do mapa front-kernel |

---

Documento Canônico — FRONT-KERNEL-MAP

**Este é o documento oficial de relacionamento entre frontend e Kernel da plataforma New Wave Enterprise.**

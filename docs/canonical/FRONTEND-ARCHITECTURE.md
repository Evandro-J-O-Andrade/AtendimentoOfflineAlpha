# FRONTEND-ARCHITECTURE

## Status

```text
CANÔNICO (ARQUITETURA)
CICLO 2 — Kernel Enterprise
Arquitetura frontend da plataforma.
```

---

## 1. Objetivo

Este documento define a **arquitetura frontend oficial** da plataforma New Wave Enterprise.

Ele serve para:
- Definir a estrutura de pastas
- Definir a separação de camadas
- Estabelecer contratos com o Kernel/Core
- Garantir que o frontend seja consumidor, não fonte
- Orientar implementação

Frontend não é um sistema independente.
Frontend é a **camada de projeção do Kernel/Core**.

---

## 2. Princípio Fundamental

```text
Frontend consome Core Platform.
Frontend não duplica Kernel.
Frontend não contém regra de negócio.
Frontend não decide acesso.
Frontend apenas projeta o estado resolvido pelo Kernel.
```

---

## 3. Arquitetura

### 3.1 Visão geral

```
Frontend
  │
  ├── App Shell (container)
  │     └── Design System
  │
  ├── Providers (Kernel/Core)
  │     ├── AuthProvider
  │     ├── SessionProvider
  │     ├── ContextProvider
  │     ├── RuntimeProvider
  │     └── NavigationProvider
  │
  ├── Contracts (APIs)
  │     ├── Auth Contract
  │     ├── Context Contract
  │     ├── Runtime Contract
  │     └── Navigation Contract
  │
  ├── Features (capacidades)
  │     ├── Login
  │     ├── Context Selection
  │     ├── Portal
  │     ├── Dashboard
  │     └── Operational
  │
  ├── Components (reutilizáveis)
  │     ├── Cards
  │     ├── Tables
  │     ├── Forms
  │     └── Navigation
  │
  ├── Layouts (estrutura)
  │     ├── Portal Layout
  │     ├── Mobile Layout
  │     └── Display Layout
  │
  ├── Themes (visual)
  │     ├── Colors
  │     ├── Typography
  │     └── Spacing
  │
  ├── Assets (mídia)
  │     ├── Brand
  │     ├── Login
  │     ├── Portal
  │     └── Common
  │
  └── Services (comunicação)
        ├── Auth Service
        ├── Context Service
        ├── Runtime Service
        └── Navigation Service
```

### 3.2 Separação de conceitos

```text
FRONTEND
  │
  ├── NÃO é Kernel
  │     └── Kernel é conceitual; Frontend é projeção
  │
  ├── NÃO é Core
  │     └── Core é executável; Frontend consome Core
  │
  ├── NÃO é Produto
  │     └── Produto é domínio; Frontend é interface
  │
  ├── NÃO decide permissão
  │     └── Permissão é decidida por Authorization
  │
  ├── NÃO executa regra de negócio
  │     └── Regra de negócio mora no domínio consumidor
  │
  ├── NÃO acessa banco
  │     └── Acesso a banco é via Runtime/SP
  │
  └── NÃO monta menu hardcoded
        └── Menu é projetado por Navigation
```

---

## 4. Estrutura de Pastas

### 4.1 Estrutura atual

```
apps/portal/
  ├── src/
  │   ├── main.tsx
  │   ├── app/
  │   │   ├── config.ts
  │   │   ├── providers.tsx
  │   │   └── router.tsx
  │   ├── pages/
  │   │   ├── Login/
  │   │   │   ├── LoginPage.tsx
  │   │   │   └── LoginPage.module.css
  │   │   ├── Portal/
  │   │   │   └── PortalPage.tsx
  │   │   └── Context/
  │   │       └── ContextSelectionPage.tsx
  │   ├── workspaces/
  │   │   ├── README.md
  │   │   ├── ti/
  │   │   ├── recepcao/
  │   │   ├── paciente/
  │   │   ├── operador/
  │   │   ├── medico/
  │   │   ├── financeiro/
  │   │   ├── farmacia/
  │   │   └── administrador/
  │   ├── shell/
  │   │   ├── index.tsx
  │   │   ├── WidgetRenderer.tsx
  │   │   ├── PortalRuntime.tsx
  │   │   └── EnterpriseShell.tsx
  │   ├── shared/
  │   │   ├── index.ts
  │   │   ├── Toast.tsx
  │   │   ├── Tabs.tsx
  │   │   ├── Table.tsx
  │   │   ├── Modal.tsx
  │   │   ├── Input.tsx
  │   │   ├── Dialog.tsx
  │   │   ├── DatePicker.tsx
  │   │   ├── Card.tsx
  │   │   └── Calendar.tsx
  │   ├── runtime/
  │   │   └── usePortalRuntime.ts
  │   └── guards/
  │       ├── GuestGuard.tsx
  │       ├── ContextGuard.tsx
  │       └── AuthGuard.tsx
  ├── package.json
  ├── vite.config.ts
  ├── tsconfig.json
  └── index.html
```

### 4.2 Estrutura proposta

```
apps/portal/
  ├── src/
  │   ├── main.tsx
  │   ├── app/
  │   │   ├── config.ts
  │   │   ├── providers.tsx
  │   │   └── router.tsx
  │   │
  │   ├── core/
  │   │   ├── auth/
  │   │   │   ├── provider.tsx
  │   │   │   ├── hooks/
  │   │   │   ├── services/
  │   │   │   ├── types/
  │   │   │   └── index.ts
  │   │   ├── context/
  │   │   │   ├── provider.tsx
  │   │   │   ├── hooks/
  │   │   │   ├── services/
  │   │   │   ├── types/
  │   │   │   └── index.ts
  │   │   ├── runtime/
  │   │   │   ├── provider.tsx
  │   │   │   ├── hooks/
  │   │   │   ├── services/
  │   │   │   ├── types/
  │   │   │   └── index.ts
  │   │   ├── navigation/
  │   │   │   ├── provider.tsx
  │   │   │   ├── hooks/
  │   │   │   ├── services/
  │   │   │   ├── types/
  │   │   │   └── index.ts
  │   │   └── design-system/
  │   │       ├── tokens/
  │   │       │   ├── colors.ts
  │   │       │   ├── typography.ts
  │   │       │   ├── spacing.ts
  │   │       │   └── breakpoints.ts
  │   │       ├── themes/
  │   │       │   ├── light.ts
  │   │       │   ├── dark.ts
  │   │       │   └── index.ts
  │   │       ├── components/
  │   │       │   ├── Button/
  │   │       │   ├── Input/
  │   │       │   ├── Card/
  │   │       │   ├── Table/
  │   │       │   ├── Form/
  │   │       │   ├── Modal/
  │   │       │   ├── Navigation/
  │   │       │   └── Dashboard/
  │   │       ├── utils/
  │   │       │   ├── cn.ts
  │   │       │   └── accessibility.ts
  │   │       └── index.ts
  │   │
  │   ├── contracts/
  │   │   ├── auth/
  │   │   │   ├── login.ts
  │   │   │   ├── refresh.ts
  │   │   │   └── revoke.ts
  │   │   ├── context/
  │   │   │   ├── resolve.ts
  │   │   │   └── switch.ts
  │   │   ├── runtime/
  │   │   │   ├── execute.ts
  │   │   │   └── status.ts
  │   │   └── navigation/
  │   │       ├── project.ts
  │   │       └── formats.ts
  │   │
  │   ├── features/
  │   │   ├── login/
  │   │   │   ├── pages/
  │   │   │   ├── components/
  │   │   │   ├── hooks/
  │   │   │   ├── services/
  │   │   │   ├── types/
  │   │   │   └── index.ts
  │   │   ├── context-selection/
  │   │   │   ├── pages/
  │   │   │   ├── components/
  │   │   │   ├── hooks/
  │   │   │   ├── services/
  │   │   │   ├── types/
  │   │   │   └── index.ts
  │   │   ├── portal/
  │   │   │   ├── pages/
  │   │   │   ├── components/
  │   │   │   ├── hooks/
  │   │   │   ├── services/
  │   │   │   ├── types/
  │   │   │   └── index.ts
  │   │   └── workspace/
  │   │       ├── pages/
  │   │       ├── components/
  │   │       ├── hooks/
  │   │       ├── services/
  │   │       ├── types/
  │   │       └── index.ts
  │   │
  │   ├── layouts/
  │   │   ├── PortalLayout/
  │   │   │   ├── PortalLayout.tsx
  │   │   │   ├── PortalLayout.module.css
  │   │   │   └── index.ts
  │   │   ├── MobileLayout/
  │   │   ├── DisplayLayout/
  │   │   └── AdminLayout/
  │   │
  │   ├── components/
  │   │   ├── shared/
  │   │   │   ├── Toast.tsx
  │   │   │   ├── Tabs.tsx
  │   │   │   ├── Modal.tsx
  │   │   │   └── index.ts
  │   │   └── domain/
  │   │       └── [componentes específicos de domínio]
  │   │
  │   ├── hooks/
  │   │   ├── useAuth.ts
  │   │   ├── useContext.ts
  │   │   ├── useRuntime.ts
  │   │   └── useNavigation.ts
  │   │
  │   ├── services/
  │   │   ├── api/
  │   │   │   ├── client.ts
  │   │   │   ├── interceptors/
  │   │   │   └── endpoints/
  │   │   ├── storage/
  │   │   │   ├── session.ts
  │   │   │   └── context.ts
  │   │   └── events/
  │   │       ├── publisher.ts
  │   │       └── subscriber.ts
  │   │
  │   ├── assets/
  │   │   ├── brand/
  │   │   ├── login/
  │   │   ├── portal/
  │   │   └── common/
  │   │
  │   └── types/
  │       ├── auth.ts
  │       ├── context.ts
  │       ├── runtime.ts
  │       └── navigation.ts
  │
  ├── package.json
  ├── vite.config.ts
  ├── tsconfig.json
  └── index.html
```

### 4.3 Regras de estrutura

```text
apps/ não conhece outras apps.
apps/ consome core/.
core/ não conhece apps/.
core/ consome contracts/.
contracts/ define tipos e contratos.
layouts/ define estrutura visual.
assets/ é indexado e inventariado.
services/ é a única camada que acessa APIs.
```

---

## 5. Camadas

### 5.1 App Shell

Responsável por:
- Container principal
- Providers
- Rotas globais
- Configuração

### 5.2 Core

Responsável por:
- Lógica de Kernel/Core
- Providers de estado
- Hooks reutilizáveis
- Serviços base

### 5.3 Contracts

Responsável por:
- Tipos TypeScript
- Contratos de API
- Interfaces
- Tipos compartilhados

### 5.4 Features

Responsável por:
- Funcionalidades de negócio
- Páginas
- Componentes específicos
- Hooks específicos

### 5.5 Components

Responsável por:
- Componentes reutilizáveis
- Componentes de domínio
- Componentes compartilhados

### 5.6 Layouts

Responsável por:
- Estrutura visual
- Navegação
- Responsividade

### 5.7 Themes

Responsável por:
- Tokens de design
- Temas light/dark
- Multi-brand

### 5.8 Assets

Responsável por:
- Imagens
- Ícones
- Fontes
- Mídia

### 5.9 Services

Responsável por:
- Comunicação com APIs
- Storage
- Eventos

---

## 6. Providers

### 6.1 AuthProvider

Responsável por:
- Autenticação
- Sessão
- Token
- Refresh

### 6.2 SessionProvider

Responsável por:
- Estado da sessão
- Validação
- Expiração

### 6.3 ContextProvider

Responsável por:
- Contexto operacional
- Troca de contexto
- Snapshots

### 6.4 RuntimeProvider

Responsável por:
- Estado do Runtime
- Execuções
- Capacidades

### 6.5 NavigationProvider

Responsável por:
- Navegação
- Menus
- Rotas

---

## 7. Contratos

### 7.1 Auth Contract

```text
Endpoint: /api/auth/login
Método: POST
Input: identity, credentials
Output: session, token
Refresh: /api/auth/refresh
Revoke: /api/auth/revoke
```

### 7.2 Context Contract

```text
Endpoint: /api/context/resolve
Método: POST
Input: session, identity, tenant
Output: context (unidade, local, perfil, sistema, aplicação, ambiente, runtime)
Switch: /api/context/switch
```

### 7.3 Runtime Contract

```text
Endpoint: /api/runtime/execute
Método: POST
Input: capability, operation, context, authorization
Output: result, status
Query: /api/runtime/status
```

### 7.4 Navigation Contract

```text
Endpoint: /api/navigation/project
Método: POST
Input: context, discovery, capabilities
Output: projection (menu, dashboard, actions)
Formats: Portal, Mobile, Display, Totem, API
```

---

## 8. Fluxo de Dados

### 8.1 Login

```text
Usuário
 ↓
Login Experience
 ↓
AuthProvider
 ↓
Auth Contract
 ↓
Backend
 ↓
Session
 ↓
ContextResolver
 ↓
ContextProvider
 ↓
Portal Runtime
 ↓
Navigation
 ↓
Portal UI
```

### 8.2 Navegação

```text
Portal UI
 ↓
NavigationProvider
 ↓
Navigation Contract
 ↓
Backend
 ↓
Discovery
 ↓
Capability
 ↓
Navigation Projection
 ↓
Portal UI
```

### 8.3 Execução

```text
Usuário
 ↓
Ação
 ↓
RuntimeProvider
 ↓
Runtime Contract
 ↓
Backend
 ↓
Authorization
 ↓
Runtime
 ↓
Capability
 ↓
Resultado
 ↓
Portal UI
```

---

## 9. Regras de Implementação

### 9.1 Componentes

```text
Todo componente deve:
  - Ser genérico
  - Respeitar tokens
  - Ser acessível
  - Ter testes
  - Ser documentado
```

### 9.2 Hooks

```text
Todo hook deve:
  - Ter responsabilidade única
  - Ser tipado
  - Ter testes
  - Ser documentado
```

### 9.3 Services

```text
Todo serviço deve:
  - Ser a única camada que acessa API
  - Tratar erros
  - Ter timeout
  - Ter retry
```

### 9.4 Tipos

```text
Todo tipo deve:
  - Ser definido em contracts/
  - Ser reutilizável
  - Ser documentado
  - Ser versionado
```

---

## 10. Regras de Governança

### 10.1 Criação

```text
Novo componente:
1. Verificar se já existe
2. Se existir: reutilizar
3. Se não existir: criar com tokens
4. Documentar
5. Testar
6. Aprovar
```

### 10.2 Alteração

```text
Alterar componente:
1. Avaliar impacto
2. Testar
3. Documentar
4. Aprovar
```

### 10.3 Exclusão

```text
Excluir componente:
1. Verificar dependências
2. Migrar consumidores
3. Marcar como deprecated
4. Remover após período
```

---

## 11. Próximos Artefatos

| Prioridade | Artefato | Descrição |
|------------|----------|-----------|
| Alta | FRONT-KERNEL-MAP.md | Mapa front-kernel |
| Média | FRONT-CONTRACTS.md | Contratos frontend detalhados |
| Baixa | FRONTEND-TESTING.md | Estratégia de testes |

---

## 12. Referências

- FRONT-CATALOG
- FRONTEND-AUDIT
- ASSET-INVENTORY
- FRONT-DESIGN-SYSTEM
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
| 1.0 | 2026-07-13 | Kilo | Criação da arquitetura frontend |

---

Documento Canônico — FRONTEND-ARCHITECTURE

**Este é o documento oficial de arquitetura frontend da plataforma New Wave Enterprise.**

# FRONT-CATALOG

## Status

```text
CANÔNICO (ARQUITETURA)
CICLO 2 — Kernel Enterprise
Catálogo de frontends oficiais da plataforma.
```

---

## 1. Objetivo

Este documento é o **catálogo oficial de frontends** da plataforma New Wave Enterprise.

Ele serve para:
- Mapear todos os pontos de entrada visuais da plataforma
- Definir contratos entre frontend e Kernel/Core
- Evitar criação de telas isoladas
- Garantir que todo frontend seja consumidor do Core Platform

Frontend não é um sistema independente.
Frontend é a **camada de projeção do Kernel**.

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

## 3. Frontends Oficiais

### 3.1 Visão geral

| Frontend | Natureza | Consumidor | Dispositivo |
|----------|----------|------------|-------------|
| Portal Enterprise | Launcher principal | Todos os usuários | Desktop |
| Operacional | Apps de negócio | Usuários operacionais | Desktop |
| Admin | Administração | Administradores | Desktop |
| Mobile | Aplicativo móvel | Usuários móveis | Mobile |
| Display/TV | Painéis públicos | Todos | Display |
| Totem | Autoatendimento | Pacientes/Visitantes | Totem |
| API Gateway | Consumo programático | Sistemas externos | API |

### 3.2 Portal Enterprise

**Função:**
- Launcher oficial da plataforma
- Seleção de contexto
- Workspace unificado
- App Registry
- Navegação principal

**Contrato com Core:**
- Auth Runtime: autenticação
- Context Runtime: seleção de contexto
- Portal Runtime: launcher
- Navigation Runtime: projeção de menu
- Discovery: capabilities disponíveis
- Capability: módulos habilitados

**Depende de:**
- Kernel: Identity, Session, Context, Discovery, Navigation, Capability
- Core: Auth Runtime, Context Runtime, Portal Runtime, Navigation Runtime

**NÃO contém:**
- Regra de negócio
- Acesso direto a banco
- Decisão de permissão
- Menu hardcoded

### 3.3 Operacional

**Função:**
- Execução de capacidades operacionais
- Produtos específicos: HIS, ERP, CRM
- Interfaces de atendimento, prescrição, faturamento

**Contrato com Core:**
- Auth Runtime: sessão ativa
- Context Runtime: contexto operacional
- Runtime: execução de capabilities
- Workflow Runtime: fluxos operacionais
- Navigation Runtime: projeção de interface

**Depende de:**
- Kernel: Runtime, Workflow, Capability, Context, Authorization
- Core: Auth Runtime, Context Runtime, Workflow Runtime, Runtime Core

**NÃO contém:**
- Login próprio
- Contexto próprio
- Menu próprio
- Navegação própria

### 3.4 Admin

**Função:**
- Administração da plataforma
- Gestão de tenants, identidades, configurações
- Monitoramento e saúde

**Contrato com Core:**
- Auth Runtime: autenticação administrativa
- Context Runtime: contexto admin
- Integration Runtime: configurações
- Ledger Runtime: auditoria

**Depende de:**
- Kernel: Identity, Tenant, Session, Authorization, Ledger
- Core: Auth Runtime, Context Runtime, Integration Runtime, Ledger Runtime

**NÃO contém:**
- Regra de negócio operacional
- Execução de capabilities de produto

### 3.5 Mobile

**Função:**
- Aplicativo móvel da plataforma
- Acesso a capabilities essenciais
- Notificações push
- Sync offline

**Contrato com Core:**
- Auth Runtime: autenticação biométrica
- Context Runtime: contexto móvel
- Runtime: execução offline-first
- Navigation Runtime: projeção mobile
- Integration Runtime: push notifications

**Depende de:**
- Kernel: Runtime, Context, Discovery, Capability, Event
- Core: Auth Runtime, Context Runtime, Runtime Core, Integration Runtime

**NÃO contém:**
- Login próprio
- Regra de negócio
- Navegação própria

### 3.6 Display/TV

**Função:**
- Painéis públicos de informação
- Filas, chamadas, alertas
- Dashboard operacional

**Contrato com Core:**
- Auth Runtime: autenticação de dispositivo
- Navigation Runtime: projeção de dashboard
- Runtime: estado em tempo real
- Integration Runtime: atualização de displays

**Depende de:**
- Kernel: Navigation, Runtime, Capability, Event
- Core: Auth Runtime, Navigation Runtime, Runtime Core

**NÃO contém:**
- Interação complexa
- Regra de negócio
- Navegação própria

### 3.7 Totem

**Função:**
- Autoatendimento
- Triagem
- Emissão de senhas
- Informações públicas

**Contrato com Core:**
- Auth Runtime: autenticação de totem
- Context Runtime: contexto de totem
- Workflow Runtime: fluxo de autoatendimento
- Navigation Runtime: projeção touch

**Depende de:**
- Kernel: Workflow, Context, Authorization, Capability
- Core: Auth Runtime, Context Runtime, Workflow Runtime, Navigation Runtime

**NÃO contém:**
- Regra de negócio clínica
- Acesso a dados sensíveis

### 3.8 API Gateway

**Função:**
- Consumo programático da plataforma
- Integração externa
- Webhooks
- APIs REST/GraphQL

**Contrato com Core:**
- Auth Runtime: API keys, OAuth2
- Context Runtime: contexto de API
- Integration Runtime: transformação de dados
- Event Runtime: publicação de eventos

**Depende de:**
- Kernel: Integration, Authorization, Event, Ledger
- Core: Auth Runtime, Context Runtime, Integration Runtime, Event Runtime, Ledger Runtime

**NÃO contém:**
- Interface visual
- Regra de negócio de produto

---

## 4. Matriz de Contratos

### 4.1 Matriz completa

| Frontend | Auth Runtime | Context Runtime | Portal Runtime | Navigation Runtime | Integration Runtime | Workflow Runtime | Event Runtime | Ledger Runtime | Runtime Core |
|----------|--------------|-----------------|----------------|-------------------|---------------------|-----------------|---------------|----------------|--------------|
| Portal Enterprise | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Operacional | ✅ | ✅ | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Admin | ✅ | ✅ | ❌ | ✅ | ✅ | ❌ | ✅ | ✅ | ✅ |
| Mobile | ✅ | ✅ | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Display/TV | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ | ✅ |
| Totem | ✅ | ✅ | ❌ | ✅ | ❌ | ✅ | ❌ | ❌ | ✅ |
| API Gateway | ✅ | ✅ | ❌ | ❌ | ✅ | ❌ | ✅ | ✅ | ✅ |

---

## 5. Arquitetura Frontend

### 5.1 Princípio fundamental

```text
Frontend é projeção.
Frontend não é fonte.
Frontend consome Core.
Frontend não decide.
```

### 5.2 Camadas

```text
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

### 5.3 Separação de conceitos

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

## 6. Contratos Front ↔ Core

### 6.1 Auth Contract

```text
Endpoint: /api/auth/login
Método: POST
Input: identity, credentials
Output: session, token
Refresh: /api/auth/refresh
Revoke: /api/auth/revoke
```

### 6.2 Context Contract

```text
Endpoint: /api/context/resolve
Método: POST
Input: session, identity, tenant
Output: context (unidade, local, perfil, sistema, aplicação, ambiente, runtime)
Switch: /api/context/switch
```

### 6.3 Runtime Contract

```text
Endpoint: /api/runtime/execute
Método: POST
Input: capability, operation, context, authorization
Output: result, status
Query: /api/runtime/status
```

### 6.4 Navigation Contract

```text
Endpoint: /api/navigation/project
Método: POST
Input: context, discovery, capabilities
Output: projection (menu, dashboard, actions)
Formats: Portal, Mobile, Display, Totem, API
```

---

## 7. Estrutura de Projeto

### 7.1 Estrutura recomendada

```
frontend/
  ├── apps/
  │   ├── portal/
  │   │   ├── src/
  │   │   │   ├── pages/
  │   │   │   ├── components/
  │   │   │   ├── hooks/
  │   │   │   ├── services/
  │   │   │   ├── types/
  │   │   │   └── routes/
  │   │   ├── public/
  │   │   └── package.json
  │   │
  │   ├── operacional/
  │   │   ├── src/
  │   │   │   ├── pages/
  │   │   │   ├── components/
  │   │   │   ├── hooks/
  │   │   │   ├── services/
  │   │   │   ├── types/
  │   │   │   └── routes/
  │   │   ├── public/
  │   │   └── package.json
  │   │
  │   ├── admin/
  │   │   ├── src/
  │   │   │   ├── pages/
  │   │   │   ├── components/
  │   │   │   ├── hooks/
  │   │   │   ├── services/
  │   │   │   ├── types/
  │   │   │   └── routes/
  │   │   ├── public/
  │   │   └── package.json
  │   │
  │   ├── mobile/
  │   │   ├── src/
  │   │   │   ├── screens/
  │   │   │   ├── components/
  │   │   │   ├── hooks/
  │   │   │   ├── services/
  │   │   │   ├── types/
  │   │   │   └── navigation/
  │   │   ├── public/
  │   │   └── package.json
  │   │
  │   └── display/
  │       ├── src/
  │       │   ├── screens/
  │       │   ├── components/
  │       │   ├── hooks/
  │       │   ├── services/
  │       │   ├── types/
  │       │   └── navigation/
  │       │   ├── public/
  │       │   └── package.json
  │
  ├── core/
  │   ├── auth/
  │   │   ├── src/
  │   │   │   ├── provider.tsx
  │   │   │   ├── hooks/
  │   │   │   ├── services/
  │   │   │   ├── types/
  │   │   │   └── index.ts
  │   │   └── package.json
  │   │
  │   ├── context/
  │   │   ├── src/
  │   │   │   ├── provider.tsx
  │   │   │   ├── hooks/
  │   │   │   ├── services/
  │   │   │   ├── types/
  │   │   │   └── index.ts
  │   │   └── package.json
  │   │
  │   ├── runtime/
  │   │   ├── src/
  │   │   │   ├── provider.tsx
  │   │   │   ├── hooks/
  │   │   │   ├── services/
  │   │   │   ├── types/
  │   │   │   └── index.ts
  │   │   └── package.json
  │   │
  │   ├── navigation/
  │   │   ├── src/
  │   │   │   ├── provider.tsx
  │   │   │   ├── hooks/
  │   │   │   ├── services/
  │   │   │   ├── types/
  │   │   │   └── index.ts
  │   │   └── package.json
  │   │
  │   ├── workflow/
  │   │   ├── src/
  │   │   │   ├── provider.tsx
  │   │   │   ├── hooks/
  │   │   │   ├── services/
  │   │   │   ├── types/
  │   │   │   └── index.ts
  │   │   └── package.json
  │   │
  │   ├── integration/
  │   │   ├── src/
  │   │   │   ├── provider.tsx
  │   │   │   ├── hooks/
  │   │   │   ├── services/
  │   │   │   ├── types/
  │   │   │   └── index.ts
  │   │   └── package.json
  │   │
  │   ├── event/
  │   │   ├── src/
  │   │   │   ├── provider.tsx
  │   │   │   ├── hooks/
  │   │   │   ├── services/
  │   │   │   ├── types/
  │   │   │   └── index.ts
  │   │   └── package.json
  │   │
  │   ├── ledger/
  │   │   ├── src/
  │   │   │   ├── provider.tsx
  │   │   │   ├── hooks/
  │   │   │   ├── services/
  │   │   │   ├── types/
  │   │   │   └── index.ts
  │   │   └── package.json
  │   │
  │   └── design-system/
  │       ├── src/
  │       │   ├── components/
  │       │   │   ├── Button/
  │       │   │   ├── Input/
  │       │   │   ├── Card/
  │       │   │   ├── Table/
  │       │   │   ├── Form/
  │       │   │   ├── Modal/
  │       │   │   ├── Navigation/
  │       │   │   └── Dashboard/
  │       │   ├── tokens/
  │       │   │   ├── colors.ts
  │       │   │   ├── typography.ts
  │       │   │   ├── spacing.ts
  │       │   │   └── breakpoints.ts
  │       │   ├── themes/
  │       │   │   ├── light.ts
  │       │   │   ├── dark.ts
  │       │   │   └── brand.ts
  │       │   ├── utils/
  │       │   │   ├── cn.ts
  │       │   │   └── accessibility.ts
  │       │   └── index.ts
  │       └── package.json
  │
  ├── contracts/
  │   ├── auth/
  │   │   ├── login.ts
  │   │   ├── refresh.ts
  │   │   └── revoke.ts
  │   ├── context/
  │   │   ├── resolve.ts
  │   │   └── switch.ts
  │   ├── runtime/
  │   │   ├── execute.ts
  │   │   └── status.ts
  │   └── navigation/
  │       ├── project.ts
  │       └── formats.ts
  │
  ├── layouts/
  │   ├── PortalLayout/
  │   ├── MobileLayout/
  │   ├── DisplayLayout/
  │   └── AdminLayout/
  │
  ├── assets/
  │   ├── brand/
  │   │   ├── logo.svg
  │   │   ├── favicon.ico
  │   │   └── manifest.json
  │   ├── login/
  │   │   ├── backgrounds/
  │   │   ├── illustrations/
  │   │   └── images/
  │   ├── portal/
  │   │   ├── modules/
  │   │   ├── cards/
  │   │   └── icons/
  │   └── common/
  │       ├── icons/
  │       ├── images/
  │       └── fonts/
  │
  ├── services/
  │   ├── api/
  │   │   ├── client.ts
  │   │   ├── interceptors/
  │   │   └── endpoints/
  │   ├── storage/
  │   │   ├── session.ts
  │   │   └── context.ts
  │   └── events/
  │       ├── publisher.ts
  │       └── subscriber.ts
  │
  └── package.json
```

### 7.2 Regras de estrutura

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

## 8. Asset Inventory

### 8.1 Estrutura de assets

```
assets/
  ├── brand/
  │   ├── logo.svg
  │   ├── logo-dark.svg
  │   ├── favicon.ico
  │   └── manifest.json
  │
  ├── login/
  │   ├── backgrounds/
  │   │   ├── bg-login-desktop.jpg
  │   │   ├── bg-login-mobile.jpg
  │   │   └── bg-login-totem.jpg
  │   ├── illustrations/
  │   │   ├── illustration-login.svg
  │   │   └── illustration-welcome.svg
  │   └── images/
  │       ├── login-hero.png
  │       └── login-pattern.png
  │
  ├── portal/
  │   ├── modules/
  │   │   ├── module-assistencial.svg
  │   │   ├── module-administrativo.svg
  │   │   └── module-financeiro.svg
  │   ├── cards/
  │   │   ├── card-default.png
  │   │   └── card-hover.png
  │   └── icons/
  │       ├── icon-home.svg
  │       ├── icon-user.svg
  │       └── icon-settings.svg
  │
  └── common/
      ├── icons/
      │   ├── arrow-left.svg
      │   ├── arrow-right.svg
      │   ├── check.svg
      │   ├── error.svg
      │   └── warning.svg
      ├── images/
      │   ├── empty-state.png
      │   └── loading.gif
      └── fonts/
          ├── inter-regular.woff2
          ├── inter-medium.woff2
          └── inter-bold.woff2
```

### 8.2 Regras de assets

```text
Todo asset deve ter:
- nome canônico
- localização definida
- uso documentado
- formato otimizado
- fallback definido

Nenhum asset hardcoded em componente.
Todo asset referenciado por nome canônico.
```

---

## 9. Design System

### 9.1 Tokens

```text
colors/
  - primary
  - secondary
  - accent
  - success
  - warning
  - error
  - neutral

typography/
  - font-family
  - font-size
  - font-weight
  - line-height
  - letter-spacing

spacing/
  - xs, sm, md, lg, xl, 2xl

breakpoints/
  - mobile
  - tablet
  - desktop
  - wide
```

### 9.2 Componentes base

```text
Button
Input
Card
Table
Form
Modal
Navigation
Dashboard
```

### 9.3 Regras

```text
Nenhum componente duplicado.
Todo componente é genérico.
Todo componente respeita tokens.
Todo componente é acessível.
Todo componente suporta multi-brand.
```

---

## 10. Regras de Governança

### 10.1 Criação de frontend

```text
Novo frontend:
1. Verificar se já existe frontend equivalente
2. Se existir: reutilizar
3. Se não existir: criar com contrato definido
4. Nunca criar sem contrato com Core
```

### 10.2 Evolução

```text
Alteração de frontend:
1. Não alterar contratos sem aprovação
2. Não duplicar componentes
3. Não criar regra de negócio
4. Não acessar banco diretamente
```

### 10.3 Isolamento

```text
Frontend não acessa Kernel diretamente.
Frontend consome Core via contratos.
Core isola frontend do Kernel.
```

---

## 11. Próximos Artefatos

| Prioridade | Artefato | Descrição |
|------------|----------|-----------|
| Alta | FRONTEND-AUDIT.md | Auditoria da estrutura atual |
| Alta | ASSET-INVENTORY.md | Inventário de assets |
| Alta | FRONT-DESIGN-SYSTEM.md | Design System |
| Média | FRONTEND-ARCHITECTURE.md | Arquitetura frontend detalhada |
| Média | FRONT-KERNEL-MAP.md | Mapa front-kernel |
| Baixa | FRONT-CONTRACTS.md | Contratos frontend detalhados |

---

## 12. Referências

- MD-KERNEL-000 — Arquitetura Conceitual do Kernel Enterprise
- MD-KERNEL-001 até MD-KERNEL-014
- MAP-CORE-PLATFORM
- BR-CATALOG
- MAPA DO KERNEL ENTERPRISE
- MD-KERNEL-DEPENDENCY-MAP
- MD-110 — Canonical Laws
- MD-113 — Lei da Singularidade Canônica
- 000-CONSTITUICAO-IA.md

---

## 13. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-13 | Kilo | Criação do catálogo de frontends |

---

Documento Canônico — FRONT-CATALOG

**Este é o catálogo oficial de frontends da plataforma New Wave Enterprise.**

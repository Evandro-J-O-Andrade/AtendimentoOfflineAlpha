# FRONTEND-AUDIT

## Status

```text
CANÔNICO (ARQUITETURA)
CICLO 2 — Kernel Enterprise
Auditoria da estrutura frontend atual.
```

---

## 1. Objetivo

Este documento apresenta a **auditoria da estrutura frontend atual** da plataforma New Wave Enterprise.

Ele serve para:
- Mapear o que existe hoje
- Identificar o que está correto
- Identificar o que viola a arquitetura
- Definir o que deve ser mantido
- Definir o que deve ser refatorado

Não é objetivo deste documento criar código.
É objetivo documentar o estado atual antes de propor evolução.

---

## 2. Estrutura Atual

### 2.1 Visão geral

```
D:\AtendimentoOfflineAlpha\
  ├── apps/
  │   └── portal/
  │       ├── src/
  │       │   ├── main.tsx
  │       │   ├── app/
  │       │   │   ├── config.ts
  │       │   │   ├── providers.tsx
  │       │   │   └── router.tsx
  │       │   ├── pages/
  │       │   │   ├── Login/
  │       │   │   │   ├── LoginPage.tsx
  │       │   │   │   └── LoginPage.module.css
  │       │   │   └── Portal/
  │       │   │       └── PortalPage.tsx
  │       │   │   └── Context/
  │       │   │       └── ContextSelectionPage.tsx
  │       │   ├── workspaces/
  │       │   │   ├── README.md
  │       │   │   ├── ti/
  │       │   │   │   ├── settings.ts
  │       │   │   │   ├── routes.ts
  │       │   │   │   ├── layout.tsx
  │       │   │   │   └── dashboard.tsx
  │       │   │   ├── recepcao/
  │       │   │   │   ├── settings.ts
  │       │   │   │   ├── routes.ts
  │       │   │   │   ├── layout.tsx
  │       │   │   │   └── dashboard.tsx
  │       │   │   ├── paciente/
  │       │   │   │   ├── settings.ts
  │       │   │   │   ├── routes.ts
  │       │   │   │   ├── layout.tsx
  │       │   │   │   └── dashboard.tsx
  │       │   │   ├── operador/
  │       │   │   │   ├── settings.ts
  │       │   │   │   ├── routes.ts
  │       │   │   │   ├── layout.tsx
  │       │   │   │   └── dashboard.tsx
  │       │   │   ├── medico/
  │       │   │   │   ├── settings.ts
  │       │   │   │   ├── routes.ts
  │       │   │   │   ├── layout.tsx
  │       │   │   │   └── dashboard.tsx
  │       │   │   ├── financeiro/
  │       │   │   │   ├── settings.ts
  │       │   │   │   ├── routes.ts
  │       │   │   │   ├── layout.tsx
  │       │   │   │   └── dashboard.tsx
  │       │   │   ├── farmacia/
  │       │   │   │   ├── settings.ts
  │       │   │   │   ├── routes.ts
  │       │   │   │   ├── layout.tsx
  │       │   │   │   └── dashboard.tsx
  │       │   │   └── administrador/
  │       │   │       ├── settings.ts
  │       │   │       ├── routes.ts
  │       │   │       ├── layout.tsx
  │       │   │       └── dashboard.tsx
  │       │   ├── shell/
  │       │   │   ├── index.tsx
  │       │   │   ├── WidgetRenderer.tsx
  │       │   │   ├── PortalRuntime.tsx
  │       │   │   └── EnterpriseShell.tsx
  │       │   ├── shared/
  │       │   │   ├── index.ts
  │       │   │   ├── Toast.tsx
  │       │   │   ├── Tabs.tsx
  │       │   │   ├── Table.tsx
  │       │   │   ├── Modal.tsx
  │       │   │   ├── Input.tsx
  │       │   │   ├── Dialog.tsx
  │       │   │   ├── DatePicker.tsx
  │       │   │   ├── Card.tsx
  │       │   │   └── Calendar.tsx
  │       │   ├── runtime/
  │       │   │   └── usePortalRuntime.ts
  │       │   └── guards/
  │       │       ├── GuestGuard.tsx
  │       │       ├── ContextGuard.tsx
  │       │       └── AuthGuard.tsx
  │       ├── package.json
  │       ├── vite.config.ts
  │       ├── tsconfig.json
  │       └── index.html
  │       └── dist/
  │           ├── assets/
  │           │   └── index-mqYKyEbc.js
  │           └── index.html
  │
  ├── packages/
  │   ├── runtime/
  │   │   ├── package.json
  │   │   └── src/
  │   │       ├── index.ts
  │   │       ├── contracts/
  │   │       │   ├── RuntimeContracts.ts
  │   │       │   └── PermissionRuntimeContracts.ts
  │   │       ├── widget/
  │   │       │   ├── WidgetResolver.ts
  │   │       │   └── WidgetRenderer.ts
  │   │       ├── portal/
  │   │       │   ├── fetchPortalMetadata.ts
  │   │       │   ├── PortalRuntimeEngine.ts
  │   │       │   └── PortalRuntimeBuilder.ts
  │   │       ├── permission/
  │   │       │   └── PermissionResolver.ts
  │   │       ├── navigation/
  │   │       │   └── NavigationResolver.ts
  │   │       ├── context/
  │   │       │   └── ContextResolver.ts
  │   │       └── application/
  │   │           └── ApplicationResolver.ts
  │   │
  │   ├── contracts/
  │   │   ├── package.json
  │   │   └── src/
  │   │       ├── index.ts
  │   │       ├── widget/
  │   │       │   └── WidgetContract.ts
  │   │       ├── tenant/
  │   │       │   └── TenantContract.ts
  │   │       ├── portal/
  │   │       │   ├── PortalRuntimeContract.ts
  │   │       │   └── ManagementContract.ts
  │   │       ├── permission/
  │   │       │   ├── PermissionContract.ts
  │   │       │   └── index.ts
  │   │       ├── notification/
  │   │       │   └── NotificationContract.ts
  │   │       ├── navigation/
  │   │       │   └── NavigationContract.ts
  │   │       ├── identity/
  │   │       │   ├── UserContract.ts
  │   │       │   └── PersonContract.ts
  │   │       ├── dashboard/
  │   │       │   └── DashboardContract.ts
  │   │       ├── context/
  │   │       │   ├── ContextSelectionContract.ts
  │   │       │   └── ContextContract.ts
  │   │       ├── branding/
  │   │       │   └── BrandingContract.ts
  │   │       ├── auth/
  │   │       │   ├── index.ts
  │   │       │   ├── LoginRequestContract.ts
  │   │       │   ├── AuthSessionContract.ts
  │   │       │   └── AuthenticationState.ts
  │   │       └── application/
  │   │           └── ApplicationContract.ts
  │   │
  │   ├── auth/
  │   │   ├── package.json
  │   │   └── src/
  │   │       ├── index.ts
  │   │       ├── hooks/
  │   │       │   └── useAuth.ts
  │   │       ├── guards/
  │   │       │   └── AuthGuard.tsx
  │   │       ├── contracts/
  │   │       │   └── AuthSessionContract.ts
  │   │       └── SessionResolver.ts
  │   │
  │   ├── api/
  │   │   ├── package.json
  │   │   └── src/
  │   │       ├── index.ts
  │   │       ├── portal/
  │   │       │   ├── index.ts
  │   │       │   └── PortalApi.ts
  │   │       └── auth/
  │   │           ├── index.ts
  │   │           └── AuthApi.ts
  │   │
  │   ├── enterprise-theme/
  │   │   ├── package.json
  │   │   └── src/
  │   │
  │   ├── enterprise-shell/
  │   │   ├── package.json
  │   │   └── src/
  │   │
  │   ├── enterprise-sdk/
  │   │   ├── package.json
  │   │   └── src/
  │   │
  │   ├── enterprise-layout/
  │   │   ├── package.json
  │   │   └── src/
  │   │
  │   ├── enterprise-icons/
  │   │   ├── package.json
  │   │   └── src/
  │   │       └── index.ts
  │   │
  │   └── enterprise-components/
  │       ├── package.json
  │       └── src/
  │
  └── backend/
      └── src/
          ├── main.ts
          ├── core/
          │   ├── portal/
          │   │   └── PortalService.ts
          │   ├── permissions/
          │   │   └── PermissionService.ts
          │   └── auth/
          │       └── AuthService.ts
          ├── routes/
          │   ├── auth.ts
          │   └── portal.ts
          ├── database/
          │   ├── mysql/
          │   │   └── connection.ts
          │   └── contracts/
          │       └── kilo-procedures-catalog.json
          └── shared/
              └── types/
                  └── auth.ts
```

### 2.2 Stack tecnológico

| Camada | Tecnologia | Versão |
|--------|-----------|--------|
| Frontend | React + TypeScript | Inferida |
| Build | Vite | Inferida |
| Backend | Node.js + TypeScript | Inferida |
| Banco | MySQL | Confirmado |
| Gerenciamento de pacotes | npm/pnpm | Inferida |

---

## 3. Análise por Camada

### 3.1 App Principal (`apps/portal`)

**Pontos positivos:**
- Estrutura de workspaces por perfil (ti, recepcao, paciente, operador, medico, financeiro, farmacia, administrador)
- Shell conceitual (`EnterpriseShell.tsx`, `PortalRuntime.tsx`)
- Guards de autenticação e contexto
- Providers centralizados

**Problemas encontrados:**
- Workspaces são **perfis hardcoded**, não descobertos via Discovery
- Rotas estão dentro de cada workspace, não são projetadas por Navigation
- Falta separação clara entre `core` e `app`
- Falta camada de contratos tipados
- Falta inventário de assets

### 3.2 Packages (`packages/`)

**Pontos positivos:**
- Separação por domínio: `auth`, `runtime`, `contracts`, `api`
- Contracts existem como TypeScript interfaces
- Runtime tem resolvedores (`WidgetResolver`, `ContextResolver`, `NavigationResolver`)
- Enterprise packages preparam Design System

**Problemas encontrados:**
- `enterprise-theme`, `enterprise-shell`, `enterprise-sdk`, `enterprise-layout`, `enterprise-components` estão vazios ou incompletos
- `contracts` está fragmentado; falta centralização
- Falta package `core` que consuma Kernel
- Falta package `navigation` como Runtime

### 3.3 Backend (`backend/`)

**Pontos positivos:**
- Separação em `core`, `routes`, `database`
- Serviços: `AuthService`, `PortalService`, `PermissionService`
- Conexão MySQL isolada
- Procedures catalogadas em JSON

**Problemas encontrados:**
- Backend não é o único ponto de acesso; frontend ainda depende de estrutura
- Falta camada de Dispatcher/Orchestrator/Executor conforme arquitetura
- Falta integração com Event/Ledger

---

## 4. Problemas Arquiteturais

### 4.1 Críticos

| # | Problema | Impacto | Correção |
|---|----------|---------|----------|
| 1 | Workspaces hardcoded por perfil | Viola descoberta dinâmica | Mover para Discovery/Capability |
| 2 | Rotas por workspace | Viola Navigation projection | Mover para Navigation Runtime |
| 3 | Falta camada `core` frontend | Frontend acessa Kernel indiretamente | Criar `packages/core` |
| 4 | Enterprise packages vazios | Design System não existe | Implementar tokens e componentes |
| 5 | Assets sem inventário | Imagens duplicadas ou órfãs | Criar ASSET-INVENTORY.md |

### 4.2 Médios

| # | Problema | Impacto | Correção |
|---|----------|---------|----------|
| 1 | Contracts fragmentados | Dificulta manutenção | Centralizar em `packages/contracts` |
| 2 | Falta tipagem forte em runtime | Possível runtime error | Adotar contratos canônicos |
| 3 | Guards repetem lógica | Duplicação de auth/context | Centralizar em `packages/auth` |
| 4 | Falta camada de eventos frontend | Sem reatividade | Adicionar Event Runtime frontend |
| 5 | Falta cache strategy | Performance | Implementar cache invalidado por evento |

### 4.3 Baixos

| # | Problema | Impacto | Correção |
|---|----------|---------|----------|
| 1 | CSS Modules em LoginPage | Inconsistente com Design System | Migrar para tokens |
| 2 | Falta acessibilidade | UX | Implementar padrões de acessibilidade |
| 3 | Falta testes | Qualidade | Adicionar testes unitários |
| 4 | Falta documentação de componentes | Onboarding | Criar Storybook |

---

## 5. O que deve ser mantido

### 5.1 Estrutura de workspaces

A ideia de workspaces por perfil está correta, mas deve ser **descoberta**, não hardcoded.

```text
Hoje:
  workspaces/
    ├── ti/
    ├── recepcao/
    ├── medico/
    └── ...

Correto:
  workspaces/
    ├── [descobertos via Discovery]
    ├── [projetados via Navigation]
    └── [renderizados via Runtime]
```

### 5.2 Shell conceitual

`EnterpriseShell.tsx`, `PortalRuntime.tsx`, `WidgetRenderer.tsx` estão no caminho certo.

Eles representam o conceito de:
- Shell único
- Runtime de portal
- Renderização de widgets

Manter e alinhar com Kernel Navigation.

### 5.3 Guards

`AuthGuard.tsx`, `ContextGuard.tsx`, `GuestGuard.tsx` estão corretos.

Eles representam validação de:
- Autenticação
- Contexto
- Acesso não autenticado

Manter e mover para `packages/auth`.

### 5.4 Packages existentes

Manter:
- `packages/runtime` - resolvedores corretos
- `packages/contracts` - contratos existentes
- `packages/auth` - autenticação existente
- `packages/api` - comunicação com backend

---

## 6. O que deve ser refatorado

### 6.1 Estrutura de pastas

**De:**

```
apps/portal/src/
  ├── workspaces/ (hardcoded)
  ├── shell/
  ├── shared/
  ├── runtime/
  └── guards/
```

**Para:**

```
apps/portal/src/
  ├── core/
  │   ├── auth/
  │   ├── context/
  │   ├── runtime/
  │   ├── navigation/
  │   └── design-system/
  ├── contracts/
  ├── features/
  │   ├── login/
  │   ├── context-selection/
  │   ├── portal/
  │   └── workspace/
  ├── layouts/
  ├── components/
  ├── hooks/
  ├── services/
  ├── assets/
  └── types/
```

### 6.2 Packages

**De:**

```
packages/
  ├── runtime/
  ├── contracts/
  ├── auth/
  ├── api/
  ├── enterprise-theme/ (vazio)
  ├── enterprise-shell/ (vazio)
  ├── enterprise-sdk/ (vazio)
  ├── enterprise-layout/ (vazio)
  └── enterprise-components/ (vazio)
```

**Para:**

```
packages/
  ├── core/
  │   ├── auth/
  │   ├── context/
  │   ├── runtime/
  │   ├── navigation/
  │   ├── workflow/
  │   ├── integration/
  │   ├── event/
  │   └── ledger/
  ├── contracts/
  ├── api/
  ├── design-system/
  │   ├── tokens/
  │   ├── components/
  │   └── themes/
  ├── layout/
  └── hooks/
```

### 6.3 Backend

**De:**

```
backend/src/
  ├── core/
  │   ├── portal/
  │   ├── permissions/
  │   └── auth/
  ├── routes/
  └── database/
```

**Para:**

```
backend/src/
  ├── kernel/
  │   ├── identity/
  │   ├── tenant/
  │   ├── session/
  │   └── context/
  ├── core/
  │   ├── auth/
  │   ├── portal/
  │   ├── navigation/
  │   └── runtime/
  ├── governance/
  │   ├── authorization/
  │   ├── event/
  │   └── ledger/
  ├── runtime/
  │   ├── discovery/
  │   ├── registry/
  │   ├── capability/
  │   └── runtime/
  ├── integration/
  │   ├── workflow/
  │   └── integration/
  ├── dispatcher/
  ├── orchestrator/
  ├── executor/
  └── ledger/
```

---

## 7. Plano de Ação

### 7.1 Fase 1 — Inventário

| Tarefa | Prioridade | Responsável |
|--------|-----------|-------------|
| Mapear todos os assets | Alta | Frontend |
| Mapear todos os componentes | Alta | Frontend |
| Mapear todas as rotas | Alta | Frontend |
| Mapear todos os contracts | Alta | Frontend |
| Mapear todas as APIs | Alta | Backend |

### 7.2 Fase 2 — Correção

| Tarefa | Prioridade | Responsável |
|--------|-----------|-------------|
| Criar `packages/core` | Alta | Frontend |
| Centralizar contracts | Alta | Frontend |
| Implementar Design System | Alta | Frontend |
| Migrar workspaces para Discovery | Alta | Frontend |
| Migrar rotas para Navigation | Alta | Frontend |
| Implementar Enterprise packages | Média | Frontend |

### 7.3 Fase 3 — Evolução

| Tarefa | Prioridade | Responsável |
|--------|-----------|-------------|
| Adicionar Event Runtime frontend | Média | Frontend |
| Adicionar Ledger Runtime frontend | Média | Frontend |
| Implementar Storybook | Baixa | Frontend |
| Adicionar testes | Baixa | Frontend |
| Documentar componentes | Baixa | Frontend |

---

## 8. Conclusão

### 8.1 Estado atual

O frontend atual tem uma **base razoável**:
- Estrutura de workspaces funciona
- Shell conceitual existe
- Packages separados existem
- Contracts começam a existir

Mas ele **não consome o Kernel/Core** como deveria:
- Workspaces são hardcoded
- Rotas são estáticas
- Falta Design System
- Falta camada `core`
- Assets não são inventariados

### 8.2 Próximos passos

1. **ASSET-INVENTORY.md** — mapear todos os assets
2. **FRONT-DESIGN-SYSTEM.md** — definir tokens e componentes
3. **FRONTEND-ARCHITECTURE.md** — propor arquitetura detalhada
4. **Implementação faseada** — corrigir sem reescrever

### 8.3 Risco principal

Se o frontend continuar evoluindo sem alinhamento com Kernel/Core, teremos:
- Duplicação de lógica
- Regras de negócio no frontend
- Menu hardcoded
- Acesso direto a banco
- Quebra da arquitetura Enterprise

---

## 9. Referências

- FRONT-CATALOG
- MAP-CORE-PLATFORM
- MD-KERNEL-000 — Arquitetura Conceitual do Kernel Enterprise
- MD-KERNEL-001 até MD-KERNEL-014
- BR-CATALOG
- MD-110 — Canonical Laws
- MD-113 — Lei da Singularidade Canônica
- 000-CONSTITUICAO-IA.md

---

## 10. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-13 | Kilo | Criação da auditoria de frontend |

---

Documento Canônico — FRONTEND-AUDIT

**Este é o documento oficial de auditoria da estrutura frontend da plataforma New Wave Enterprise.**

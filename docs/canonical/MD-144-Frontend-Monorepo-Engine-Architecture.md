# MD-144 — Frontend Monorepo & Engine Architecture

## Status

Documento Canônico de Arquitetura Frontend.
Define a estrutura do monorepo e o princípio de **engines sobre components**.
Companheiro de: MD-020 (Portal Core), MD-143 (Management Center), KILO-ENGINE-v8 (Portal & MC Evolution).

---

## Objetivo

Definir a estrutura do monorepo frontend da plataforma e o princípio de que o reutilizável nasce em `packages/` como **engine**, nunca como componente pronto em `apps/`.

---

## Lei Canônica FE-001 — apps/ nunca compartilha código diretamente

```text
PROIBIDO:
apps/his/components
apps/workforce/components  (copiando do his)

CORRETO:
apps/* usam packages/components e packages/layout
```

Tudo compartilhável nasce em `packages/`.

---

## Lei Canônica FE-002 — Engines sobre Components

Não se compartilha componente pronto; compartilha-se **engine**.

```text
Sidebar     → SidebarEngine    (recebe menu/permissões/favoritos/contexto)
Dashboard   → Dashboard Framework
Header/Footer/Layout → Layout Engine
```

---

## Estrutura do Monorepo

```text
enterprise-saas/
├── apps/
├── packages/
├── canonical/
├── infrastructure/
├── tools/
├── scripts/
├── docker/
├── docs/
└── turbo.json
```

---

## apps/ — Apenas aplicações (nunca bibliotecas)

```text
portal
management
his
workforce
displays
intranet
chat
ava
crm
financeiro
marketplace
```

### Regra de separação

`management/` é app **separado** de `portal/`. Ele é outro produto, apenas aberto pelo Portal.

```text
PROIBIDO: portal/pages/management
CORRETO:  apps/management  (aberto a partir do Portal)
```

### Estrutura padrão de cada app

```text
apps/<app>/src/
  app/
  routes/
  pages/
  features/
  services/
  runtime/
  contracts/
  assets/
  main.tsx
```

Nada de componentes compartilhados dentro de `apps/`.

---

## packages/ — Tudo reutilizável

| Pacote | Responsabilidade |
|--------|------------------|
| `ui` | Componentes puros (Button, Input, Modal, Tabs, DataTable, Toast…). Não sabem o que é HIS/Portal. |
| `design-system` | Cores, tipografia, tokens, ícones, spacing, themes (dark/light/brand engine). |
| `layout` | Layout Engine: `PortalLayout`, `ManagementLayout`, `ModuleLayout`, `FullscreenLayout`, `AuthLayout`, `DisplayLayout` + headers/footers por ambiente. |
| `navigation` | `SidebarEngine`, `Breadcrumb`, `Topbar`, `QuickSearch`, `MenuEngine`, `Favorites`, `AppLauncher`, `Dock`, `NavigationTree`. Recebe metadados do backend. |
| `runtime` | Portal Runtime: monta Widgets, Cards, Containers, Apps, Menu, Theme, Branding. |
| `widgets` | Widgets reutilizáveis (Weather, Agenda, Tasks, Notifications, Calendar, Metrics, Chart, News, Shortcut…). |
| `dashboard` | Containers: `DashboardGrid`, `DashboardContainer`, `WidgetLoader`, `CardLoader`, `LayoutEngine`. |
| `module-sdk` | `defineModule({ id, name, icon, routes, management, runtime })` — contrato que todo módulo implementa. |
| `contracts` | DTOs: `PortalRuntime`, `ManagementRuntime`, `AppContract`, `ContextContract`, `NotificationContract`, `WidgetContract`. |
| `api` | Cliente HTTP centralizado (nada de axios espalhado). |
| `auth` | Autenticação. |
| `events` | Barramento de eventos. |
| `database` | Apenas contratos; nunca SQL. |
| `sdk` | SDK público. |
| `assets` | Ícones, logos, ilustrações, fontes, animações compartilhados. |

Cada app pode ainda ter `src/assets/` próprios para identidade visual específica (ex.: Portal diferente de HIS).

---

## Layout Engine

Um único Framework de Layout, múltiplos layouts exportados:

```tsx
<PortalLayout>      {/* Portal Enterprise */}
<ManagementLayout>  {/* Management Center */}
<ModuleLayout>      {/* HIS, AVA, CRM, ... */}
<AuthLayout>        {/* Login (exclusivo do Portal) */}
<DisplayLayout>     {/* Painéis / Totens (fase futura) */}
```

O Header/Footer também são frameworks por ambiente (`PortalHeader`, `ManagementHeader`, `ModuleHeader`, `DisplayHeader`).

---

## Module SDK

Todo módulo implementa a mesma interface. O Portal a lê automaticamente.

```ts
export default defineModule({
  id: "his",
  name: "Hospital",
  icon: "hospital",
  routes: [],
  management: {},   // subportal administrativo (MC-003 / LC-009)
  runtime: {}       // contratos de operação
})
```

---

## O que é compartilhado vs não compartilhado

### ✅ Compartilhado (packages)

Design system, componentes base, engines de layout/navegação/runtime, dashboard/widget framework, cliente de API, SDK, eventos, auth, contratos (DTOs), hooks genéricos, utilitários, i18n, assets compartilhados.

### ❌ Não compartilhado (apps)

Páginas, regras de negócio, dashboards, headers/footers específicos, menus específicos, rotas, features, casos de uso, configurações de cada produto.

---

## Login

Exclusivo do Portal (`apps/portal/authentication/`). Nenhum módulo implementa login.

---

## Proibições

```text
Componente de app em outro app
Componente pronto compartilhado em vez de engine
Header/Footer/Sidebar fixos em vez de framework
management/ dentro de portal/
axios fora de packages/api
SQL em packages/database
```

---

## Integrações

| MD / FRONT | Finalidade |
|------------|-----------|
| MD-020 — Portal Core | Núcleo do Portal |
| MD-143 — Management Center | MC interno |
| KILO-ENGINE-v8 | Leis do Portal & MC |
| MAP-006 — Application Registry | Registro de apps |
| FRONT-005 / MD-109 — Dashboard Framework | Framework de dashboard |

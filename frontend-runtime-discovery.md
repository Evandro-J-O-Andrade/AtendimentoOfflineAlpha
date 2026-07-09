# FASE 0.2 — Runtime Discovery (Descoberta do Runtime)

## Status

**CONCLUÍDO** (somente leitura — nenhum contrato, componente ou código criado)

## Origem da Evidência

Leitura direta da árvore real: `packages/contracts`, `packages/runtime`, `packages/api`,
`apps/portal/src`, `backend/src`. Complementar à FASE 0.1 (`frontend-inventory.md`).

---

## 1. Pipeline Real (Ponta a Ponta)

```text
backend/PortalService.runtime(idSessao)
        │  (monta navigation/applications/branding/dashboard/widgets/notifications/permissions)
        ▼
backend/routes/portal.ts  GET /portal/runtime/:idSessao  →  res.json(runtime)
        ▼
packages/api  PortalApi.runtime(idSessao)  →  api.get<PortalRuntimeContract>(...)
        ▼
apps/portal/src/app/providers.tsx  (PortalRuntimeComposer)
        │  busca portalApi.runtime(idSessao) e preenche estado
        ▼
apps/portal/src/shell/PortalRuntime.tsx  (PortalRuntimeProvider + usePortalRuntime)
        ▼
apps/portal/src/shell/EnterpriseShell.tsx  (consome usePortalRuntime)
```

O pipeline **existe e está conectado**. O que falta é a **renderização tipada de widgets** e a
**fonte de dados de widgets no backend**.

---

## 2. Contratos do Runtime (`packages/contracts/src`)

### `WidgetContract` (literal)

```ts
export interface WidgetContract {
  id: string
  type: string                 // string LIVRE — sem enumeração de tipos
  title: string
  config?: Record<string, unknown>
  order?: number
}
```

> **FATO CRÍTICO:** `WidgetContract.type` é `string` livre. **Não existe** nenhuma enumeração
> de tipos de widget (`metric` | `chart` | `table` | `calendar` | ...) em nenhum pacote ou app.
> (Busca por `metric`/`chart`/`table`/`calendar`/`WidgetType` no frontend retorna 0 ocorrências
> relevantes — só aparecem termos médicos `metrica` em `modules/kernel`.)

### `DashboardContract` (literal)

```ts
export interface DashboardContract {
  id: string
  title: string
  layout: string               // string livre ("grid") — sem grid system tipado
  widgets: WidgetContract[]
}
```

### `PortalRuntimeContract` (literal — resumo)

```ts
export interface PortalRuntimeContract {
  user: PersonContract | null
  tenant: TenantContract | null
  context: ContextContract | null
  applications: ApplicationContract[]
  navigation: NavigationContract[]
  widgets: WidgetContract[]
  dashboard?: DashboardContract
  branding: BrandingContract
  notifications?: NotificationContract[]
  management?: ManagementContract
  permissions: string[]
}
```

### Demais contratos (forma resumida)

| Contrato | Campos |
| :--- | :--- |
| `ApplicationContract` | `id, code, name, icon?, route, category?, enabled, licensed?, permission?` |
| `NavigationContract` | `id, label, items: NavigationItemContract[]` onde `NavigationItemContract = { id, label, route, permission? }` |
| `ManagementContract` | `enabled, containers: { id, name, route }[]` |
| `BrandingContract` | `name, logo?, primaryColor?, theme?: 'light' | 'dark' | 'tenant'` |

---

## 3. Engine / Resolvers (`packages/runtime/src`)

- **`PortalRuntimeEngine.compose(input)`**: mapeamento puro.
  - `applications` → `resolveApplications` (filtra `enabled` + por `permission` concedida)
  - `navigation` → `resolveNavigation` (filtra `items` por `permission` concedida)
  - `widgets` → `resolveWidgets` (apenas **ordena por `order`**)
  - `user = input.session.person`, `branding = input.tenant?.branding ?? default`
- **`PortalRuntimeBuilder`**: builder fluente com `withSession/withTenant/withContext/
  withApplications/withWidgets/withNavigation/withDashboard/withNotifications/
  withManagement/withPermissions` → `build()` chama `engine.compose`.
- **`WidgetResolver.resolveWidgets`**: **só ordena** por `order`. **Não** há mapeamento
  `type` → componente.
- **`ApplicationResolver`** / **`NavigationResolver`**: filtragem por permissão.
- **`ContextResolver`** e **`PermissionResolver`** (em `packages/runtime/src/context`,
  `packages/runtime/src/permission`): **existem mas NÃO são chamados** em `compose()`.
  Hoje as permissões vêm prontas do backend (`PermissionService`), não resolvidas no client.

---

## 4. API (`packages/api/src/portal/PortalApi.ts`)

| Endpoint | Retorno |
| :--- | :--- |
| `GET /portal/runtime/:idSessao` | `PortalRuntimeContract` (completo) |
| `GET /portal/permissions/:idSessao` | `{ permissions: string[] }` |
| `GET /portal/navigation/:idSessao` | `NavigationContract[]` |
| `GET /portal/applications/:idSessao` | `{ applications: ApplicationContract[] }` |
| `GET /portal/branding` | `BrandingContract` |
| `GET /portal/dashboard/:idSessao` | `DashboardContract` |
| `GET /portal/widgets/:idSessao` | `{ widgets: WidgetContract[] }` |
| `GET /portal/notifications/:idSessao` | `{ notifications: NotificationContract[] }` |

---

## 5. Provider / Render (`apps/portal/src`)

- **`shell/PortalRuntime.tsx`**: `PortalRuntimeContext` + `PortalRuntimeProvider` + `usePortalRuntime()`.
- **`app/providers.tsx`** (`PortalRuntimeComposer`): cria `ApiClient` + `PortalRuntimeEngine`,
  mas em produção usa `portalApi.runtime(idSessao)` e preenche `PortalRuntimeProvider` com o
  JSON do backend diretamente (não recompõe via engine para o dado buscado).
- **`shell/EnterpriseShell.tsx`**: renderiza `rt.widgets` como `<div>` **genérico**
  (mostra `title` / `type`). **Não existe** `WidgetRenderer` que mapeie `widget.type`
  → `MetricWidget` / `ChartWidget` / `TableWidget` / `CalendarWidget`.

---

## 6. Backend — Serialização Real (`backend/src`)

### `routes/portal.ts`
Espelha 1:1 os endpoints de `PortalApi` (seção 4).

### `core/portal/PortalService.ts` — o que é entregue HOJE

| Campo | Origem real | Conteúdo hoje |
| :--- | :--- | :--- |
| `navigation` | `sp_auth_menu_get(...)` | grupos `modulos` → `{ id, label, items:[{id,label,route,permission}] }` |
| `applications` | **derivado de `navigation`** | 1 application por grupo de navegação (`icon:undefined`, `category:'Enterprise'`) |
| `branding` | hardcoded | `{ name:'Enterprise Portal', theme:'light' }` |
| `dashboard` | hardcoded | `{ id:'dashboard-default', title:'Dashboard', layout:'grid', widgets:[] }` |
| `widgets` | `widgets(idSessao)` | **`[]` (vazio)** |
| `notifications` | `notifications(idSessao)` | **`[]` (vazio)** |
| `management` | hardcoded | `{ enabled:false, containers:[] }` |
| `permissions` | `PermissionService.evaluate` | chama `sp_auth_permissions_evaluate` |
| `user` / `tenant` / `context` | hardcoded | `null` |

> **FATO CRÍTICO:** o backend **entrega `widgets: []`** hoje. A fonte de dados de widgets
> **não está populada**. O runtime está pronto para receber widgets; falta o preenchimento.

> **BLOQUEIO CORE-005 (já conhecido):** `sp_auth_permissions_evaluate` é chamada por
> `PermissionService` mas **ainda não está aplicada no banco** (ver `DOSSIER-CORE-005`,
> `DIVIDA-TECNICA.md` DT-001). Isso afeta `permissions`, não o pipeline de widgets.

---

## 7. Exemplo de JSON entregue hoje (`GET /portal/runtime/:idSessao`)

```json
{
  "user": null,
  "tenant": null,
  "context": null,
  "navigation": [
    { "id": "modulo_x", "label": "Módulo X",
      "items": [ { "id": "acao_y", "label": "Ação Y", "route": "/modulo_x/acao_y", "permission": "acao_y" } ] }
  ],
  "applications": [
    { "id": "modulo_x", "code": "modulo_x", "name": "Módulo X", "icon": null, "route": "/modulo_x", "category": "Enterprise", "enabled": true, "permission": "acao_y" }
  ],
  "branding": { "name": "Enterprise Portal", "logo": null, "primaryColor": null, "theme": "light" },
  "dashboard": { "id": "dashboard-default", "title": "Dashboard", "layout": "grid", "widgets": [] },
  "widgets": [],
  "notifications": [],
  "management": { "enabled": false, "containers": [] },
  "permissions": [ "..." ]
}
```

---

## 8. Gaps Críticos (para FASE 1 → FASE 2)

1. **Sem taxonomia de widget:** `WidgetContract.type` é string livre. Precisa de um catálogo
   de tipos (`metric`, `chart`, `table`, `calendar`, ...) — provavelmente em `packages/contracts`.
2. **Sem `WidgetRenderer`:** `EnterpriseShell` renderiza `<div>` genérico. Falta o componente
   que resolve `type` → componente visual.
3. **Backend sem widgets:** `PortalService.widgets()` retorna `[]`. Fonte de dados pendente.
4. **`DashboardContract.layout`** é string livre (sem grid system).
5. **`workspaces/*/dashboard.tsx`** continuam `export default {}` (stubs).
6. **`applications` derivados de `navigation`** — acoplamento: aplicação não tem fonte própria.

---

## 9. Implicações para a FASE 1 (Análise de Imagem)

A imagem NÃO deve gerar componentes (`MetricCard`). Deve gerar **widgets** que se encaixam no
contrato já existente:

```text
Imagem (requisito visual)
        ▼
WidgetContract: { type, title, config, order }
        ▼
PortalApi.widgets(idSessao)  →  backend popula (HOJE: [])
        ▼
WidgetResolver (ordena por order)   [REUSE]
        ▼
WidgetRenderer (type → componente)  [EXTEND — não existe]
        ▼
MetricWidget | ChartWidget | TableWidget | CalendarWidget
```

O JSON que o backend precisa passar a entregar (compatível com `WidgetContract`):

```json
{ "widgets": [
  { "id": "w1", "type": "metric", "title": "Pacientes", "config": { "source": "fila.pacientes" }, "order": 1 },
  { "id": "w2", "type": "table",  "title": "Fila",      "config": { "source": "fila.atendimento" }, "order": 2 }
] }
```

---

## Conclusão (Apenas Fatos)

- O **Kernel de runtime existe** (`PortalRuntimeContract`, `PortalRuntimeEngine`, `PortalRuntimeBuilder`,
  `PortalApi`, `PortalRuntimeProvider`) e está **conectado ponta a ponta**.
- O que falta para materializar dashboards por imagem:
  1. **Taxonomia de `widget.type`** (em `packages/contracts`) — REUSE do contrato, EXTEND do tipo.
  2. **`WidgetRenderer`** em `apps/portal` (ou `packages/ui`) — EXTEND (não existe).
  3. **Fonte de widgets no backend** (`PortalService.widgets`) — hoje vazia.
- `workspaces/*` são stubs; a renderização deve ser **runtime-driven** (Opção B), não por
  arquivo de dashboard fixo por papel.

**Próximo passo (após aprovação): FASE 1 — análise das imagens (`docs/design/dashboard/`)
→ FASE 2 `frontend-analysis.md` (REUSE / ADAPT / EXTEND / PROPOSE).**

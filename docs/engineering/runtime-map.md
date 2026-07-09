# runtime-map.md — Mapa Técnico do Runtime (Frontend)

> Documento de engenharia (NÃO canônico). Espinha dorsal do frontend, análogo ao
> call graph / dependency graph do banco. Mantém-se sincronizado com a árvore real.
> Gerado por FASE 0.1 + FASE 0.2. Não cria código.

---

## 1. Fluxo do Runtime (Portal)

```text
PortalApi.runtime(idSessao)
  packages/api/src/portal/PortalApi.ts:17   GET /portal/runtime/:idSessao
        │
        ▼
backend/src/routes/portal.ts:6              route handler
        │
        ▼
backend/src/core/portal/PortalService.ts:89 runtime()
        │  monta: navigation (sp_auth_menu_get) · applications (derivado) ·
        │         branding (hardcoded) · dashboard (hardcoded, widgets:[]) ·
        │         widgets (→ []) · notifications (→ []) · permissions
        ▼
PortalRuntimeContract
  packages/contracts/src/portal/PortalRuntimeContract.ts
        │
        ▼
apps/portal/src/app/providers.tsx:109      portalApi.runtime(idSessao) → setPortalRuntime
        │
        ▼
apps/portal/src/shell/PortalRuntime.tsx:19 PortalRuntimeProvider
        │
        ▼
apps/portal/src/shell/EnterpriseShell.tsx  usePortalRuntime()
        │
        ▼
render: header (branding/tenant/context/user/logout) · aside (navigation+management) ·
       main (applications · WIDGETS · notifications)
```

> **GAP-1:** `widgets` são renderizados como `<div>` genérico (`EnterpriseShell.tsx:113-129`).
> Não existe `WidgetRenderer` que mapeie `widget.type` → componente visual.

---

## 2. Fluxo de Resolução de Widget

```text
PortalRuntimeEngine.compose(input)
  packages/runtime/src/portal/PortalRuntimeEngine.ts:19
        │
        ▼
resolveWidgets(widgets)
  packages/runtime/src/widget/WidgetResolver.ts:3   → apenas ORDENA por `order`
        │
        ▼
WidgetContract  (packages/contracts/src/widget/WidgetContract.ts)
        │  { id, type: string livre, title, config?, order? }
        ▼
[GAP-2] WidgetRenderer INEXISTENTE
        │
        ▼
EnterpriseShell → <div>{title} / {type}</div>
```

> **GAP-2:** `WidgetContract.type` é `string` livre. Não há taxonomia
> (`metric`/`chart`/`table`/`calendar`). O `WidgetRenderer` (type→componente) não existe.

---

## 3. Fluxo de Auth

```text
LoginPage
  apps/portal/src/pages/Login/LoginPage.tsx:7   useAuth()
  apps/portal/src/pages/Login/LoginPage.tsx:26  login(request: LoginRequestContract)
        │
        ▼
AuthProvider.login
  packages/auth/src/AuthProvider.tsx:11 (sig) · :36 (impl)
        │  authApi.login(request)
        ▼
SessionResolver
  packages/auth/src/SessionResolver.ts:5         GET /auth/session
        │
        ▼
AuthSessionContract
  packages/contracts/src/auth/AuthSessionContract.ts
        │
        ▼
AuthProvider context → { session, authenticated, login, refresh, logout, selectContext }
  packages/auth/src/AuthProvider.tsx:78
        │
        ▼
PortalRuntimeComposer (apps/portal/src/app/providers.tsx:59) consome `session`
```

> **GAP-3:** `AuthProvider` expõe `context: null` fixo (`AuthProvider.tsx:78`). O contexto
> não é resolvido no AuthProvider — flui por fora (ver fluxo 4).

---

## 4. Fluxo de Contexto

```text
ContextSelectionPage
  apps/portal/src/pages/Context/ContextSelectionPage.tsx:8   useAuth().selectContext
  apps/portal/src/pages/Context/ContextSelectionPage.tsx:18  fetch('/auth/context/...')  ⚠️
        │
        ▼
AuthProvider.selectContext(idUnidade, idPerfil, idLocal?)
  packages/auth/src/AuthProvider.tsx:14 (sig) · :60 (impl)
        │  authApi.selectContext(...) → setSession(response.session)
        ▼
ContextGuard
  apps/portal/src/guards/ContextGuard.tsx:6   Boolean(rt.context)
        │
        ▼
ContextContract (packages/contracts/src/context/ContextContract.ts)
  ← vem do PortalRuntimeContract.context (backend hoje: null)
```

> **DESVIO-1 (FRONT-001 §7/§11):** `ContextSelectionPage.tsx:18` usa `fetch()` direto em vez de
> `packages/api`. Viola a regra "toda comunicação passa por `packages/api`". Corrigir para
> `createAuthApi(...).context(idSessao)` (ou equivalente) antes da FASE de implementação.

---

## 5. Fluxo de Permissão

```text
PortalApi.permissions(idSessao)
  packages/api/src/portal/PortalApi.ts:20   GET /portal/permissions/:idSessao
        │
        ▼
backend PermissionService.evaluate
  backend/src/core/permissions/PermissionService.ts:17   CALL sp_auth_permissions_evaluate(?, @permissions)
        │
        ▼
PortalRuntimeContract.permissions: string[]
        │
        ▼
resolveApplications  (packages/runtime/src/application/ApplicationResolver.ts:3)  filtra enabled + permission
resolveNavigation    (packages/runtime/src/navigation/NavigationResolver.ts:3)    filtra items por permission
```

> **BLOQUEIO CORE-005:** `sp_auth_permissions_evaluate` é chamada mas **ainda não aplicada no
> banco** (DT-001). Afeta `permissions`, não o pipeline de widgets.

---

## 6. Portal → Aplicações → Dashboard → Widgets

```text
PortalRuntimeContract.applications  ApplicationContract[]
        │  EnterpriseShell renderiza applications habilitados (filtrados por permission)
        ▼
PortalRuntimeContract.dashboard     DashboardContract { id, title, layout:string, widgets:[] }
        │
        ▼
PortalRuntimeContract.widgets       WidgetContract[]   (backend hoje: [])
        │
        ▼
EnterpriseShell → <div> genérico  ← [GAP-1] sem WidgetRenderer
```

> `applications` são **derivados de `navigation`** no backend (`PortalService.applications`,
> `PortalService.ts:44`), não têm fonte própria.

---

## 7. Resumo de Gaps (para FASE 1 → FASE 2)

| # | Gap | Onde | Classificação sugerida |
| - | :-- | :--- | :--------------------- |
| 1 | Sem `WidgetRenderer` (type→componente) | `EnterpriseShell` | EXTEND (runtime existe) |
| 2 | `WidgetContract.type` sem taxonomia | `packages/contracts` | REUSE contrato + EXTEND tipo |
| 3 | `AuthProvider.context` sempre `null` | `AuthProvider.tsx:78` | ADAPT |
| 4 | Backend entrega `widgets: []` | `PortalService.ts:77` | PROPOSE/ADAPT (fonte de dados) |
| 5 | `DashboardContract.layout` string livre | `packages/contracts` | EXTEND (grid system) |
| 6 | `fetch()` direto em `ContextSelectionPage` | `ContextSelectionPage.tsx:18` | ADAPT (usar `packages/api`) |
| 7 | `workspaces/*/dashboard.tsx` stubs | `apps/portal/src/workspaces` | REUSE runtime, não fixo por papel |

---

## 8. Como este mapa é usado

- **Gemini (arquiteto/analista visual):** lê este mapa antes de propor evolução; propõe
  `WidgetContract`/`WidgetRenderer` alinhados ao runtime existente.
- **Kilo (materializador):** valida REUSE/ADAPT/EXTEND contra estes fluxos reais; não cria
  arquitetura por suposição.
- **Projeto/Dump:** fonte da verdade; diverge deste mapa → o mapa é atualizado, não o projeto.

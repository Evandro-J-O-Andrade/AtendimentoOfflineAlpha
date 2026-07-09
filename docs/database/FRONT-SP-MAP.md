# FRONTEND.md — Inventário Vivo do Frontend

> Seed 2026-07-09. Fonte: `frontend-runtime-discovery.md` + `runtime-map.md` + `frontend-inventory.md`.
> Sempre que criar/alterar um TSX, atualize este arquivo e registre em `CHANGELOG.md`.

## Pipeline obrigatório (não criar fora dele)

```text
<Page>.tsx
  → useAuth() / usePortalRuntime()        (packages/auth · apps/portal/src/shell/PortalRuntime.tsx)
    → PortalRuntimeProvider               (shell/PortalRuntime.tsx:19)
      → PortalApi.{runtime,permissions,...} (packages/api)
        → backend GET /portal/*            (backend/src/routes/portal.ts · auth.ts)
          → PortalService / AuthService / PermissionService
            → SP (ver PROCEDURES.md / CALL-GRAPH.md)
```

## Páginas (apps/portal/src/pages)

| Arquivo | Consome | SP | Status |
| :--- | :--- | :--- | :--- |
| `Login/LoginPage.tsx` | `useAuth().login` | `sp_master_login` | REUSE |
| `Context/ContextSelectionPage.tsx` | `useAuth().selectContext` + `fetch /auth/context` ⚠️ | `sp_auth_contexto_get/set` | REUSE (R4: usar packages/api) |
| `Portal/PortalPage.tsx` | `PortalRuntimeContract` | (via runtime) | REUSE |

## Contratos (packages/contracts/src) — fonte de tipos

`PortalRuntimeContract`, `WidgetContract`, `DashboardContract`, `ApplicationContract`,
`NavigationContract`, `ManagementContract`, `BrandingContract`. **Toda tela consome tipos daqui**
(FRONT-001 §6).

## Gaps conhecidos (não criar contorno — estender o runtime)

- **Sem `WidgetRenderer`** (`EnterpriseShell` renderiza `<div>` genérico) → EXTEND (runtime existe)
- **`WidgetContract.type` sem taxonomia** → REUSE contrato + EXTEND tipo (em `packages/contracts`)
- **Backend entrega `widgets:[]`** → fonte de dados pendente (PROPOSE/ADAPT no backend)
- **`AuthProvider.context` sempre `null`** (ADAPT)
- **`workspaces/*/dashboard.tsx` são stubs** → usar runtime, não fixo por papel

## Regra para IA

Ao criar dashboard por imagem: gerar `WidgetContract` (`type`+`config`), não componente `MetricCard`.
O renderizador (`WidgetRenderer`) e a taxonomia de `widget.type` devem ser discutidos em FASE 1→2.

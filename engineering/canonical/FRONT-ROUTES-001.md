# FRONT-ROUTES-001 — Inventário de Rotas Frontend

- **Status:** Ativo (2026-08-04)
- **Base:** GATE-FUNC-001

---

## Portal (`apps/portal/src`)

| Rota | Arquivo | Status | Observação |
|---|---|---|---|
| `/login` | `pages/Login/LoginPage.tsx` | ✅ Implementado | Login via AuthProvider |
| `/context` | `pages/Context/ContextSelectionPage.tsx` | ✅ Implementado | Seleção de unidade/local |
| `/portal` | `pages/Portal/PortalPage.tsx` | ✅ Implementado | Página principal |
| `/` (raiz) | `app/providers.tsx` | ✅ Implementado | RouterProvider controla navegação |
| `/domain/{workspace}` | `workspaces/*/dashboard.tsx` | 🟡 Scaffold | Workspaces: farmacia, financeiro, medico, operador, paciente, administrador, ti, recepcao |

### Arquitetura Portal
```text
main.tsx
  → ProviderStack
    → AuthProvider
      → PortalRuntimeComposer
        → RouterProvider
          → NavigationController
            → LoginPage / ContextSelectionPage / EnterpriseShell
```

---

## Totem (`apps/totem/src`)

| Rota | Arquivo | Status | Observação |
|---|---|---|---|
| `/` | `App.tsx` | ✅ Implementado | TotemRouter controla navegação interna |
| `/senha` | `pages/TotemSenha/TotemSenha.tsx` | ✅ Implementado | Tela de geração de senhas |
| `/satisfacao` | `pages/TotemSatisfacao/TotemSatisfacao.tsx` | ✅ Implementado | Tela de feedback |

### Arquitetura Totem
```text
main.tsx
  → App
    → TotemRouter
      → TotemSenha.tsx  (default)
      → TotemSatisfacao.tsx (rota interna)
```

---

## Módulos Frontend (`modules/`)

| Módulo | Rotas | Status | Observação |
|---|---|---|---|
| `modules/painel` | `/display/painel` → DisplayBoard | ⚪ Vazio | Procedures vazias |
| `modules/display` | `/display/display` → DisplayBoard | ⚪ Vazio | Procedures vazias |
| 27 módulos (atendimento, auditoria, farmacia, etc.) | `/display/{module}` → DisplayBoard | ⚪ Boilerplate | Component DisplayBoard não implementado |

### Observação sobre displayRoutes
Todos os 27 módulos exportam:
```typescript
export const displayRoutes: RouteConfig[] = [
  { path: '/display/[module]', component: 'DisplayBoard', label: '[module] Display' }
]
```
- Componente `DisplayBoard` não existe no codebase
- É apenas declaração de rota, sem implementação

---

## Backend (`backend/src/routes`)

| Rota | Controller | Status | Observação |
|---|---|---|---|
| `/dispatcher/` | `DispatcherController.ts` | ✅ Implementado | POST único, chama sp_master_dispatcher |
| `/totem` | `TotemController.ts` | ✅ Implementado | Standalone, 3 endpoints |
| `/auth` | — | ? | Rotas de autenticação |
| `/portal` | — | ? | Rotas do portal |
| `/contexto` | — | ? | Rotas de contexto |

### Observação sobre rotas de display
- **Não existe** `/painel` ou `/display` no backend
- `/totem` é a única rota de display implementada
- Dispatcher é o entry-point único para business logic

---

## Status do Sistema

| Componente | Status | Critério GATE-FUNC-001 |
|---|---|---|
| Banco sobe | ✅ | ✅ |
| Backend conecta | ✅ | ✅ |
| Login funciona | 🟡 | Precisa validar |
| Sessão funciona | 🟡 | Precisa validar |
| Portal abre | 🟡 | Página implementada, mas backend parcial |
| Rotas carregam | 🟡 | Workgroups como scaffold |
| Totem abre | 🟡 | App standalone funcional |
| Logs básicos funcionam | 🟡 | Precisa validar |

---

## Referências

- `apps/portal/src/main.tsx`
- `apps/portal/src/app/providers.tsx`
- `apps/portal/src/app/router.tsx`
- `apps/totem/src/main.tsx`
- `apps/totem/src/App.tsx`
- `backend/src/main.ts`
- `backend/src/routes/dispatcher.ts`
- `backend/src/routes/totem.ts`
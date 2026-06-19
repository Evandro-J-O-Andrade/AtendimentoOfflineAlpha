# RELATORIO DEPENDENCIAS - FASE 2
**Data:** 2026-06-17
**Escopo:** Cadeia main.tsx → API

---

## CADEIA PRINCIPAL

```
main.tsx
├─ imports: ./App.tsx
├─ imports: ./index.css (globals)
└─ imports: ./themes/ (globals, variables)

App.tsx
├─ imports: @/app/providers/AuthProvider
├─ imports: @/app/providers/TenantProvider
├─ imports: @/app/providers/RuntimeContext
├─ imports: @/apps/portal/pages/login/LoginPage (lazy)
├─ imports: @/apps/portal/routes/PortalRoutes (lazy)
├─ imports: @/apps/contexto/pages/ContextSelectionPage (lazy)
├─ imports: @/features/atendimento/AppOperacional (lazy) ← PROBLEMA: features/ é órfão
├─ imports: react-router-dom
└─ exports: PrivateRoute component

PortalRoutes.tsx
├─ imports: react-router-dom
├─ imports: ./layouts/PortalLayout
├─ imports: ./pages/PortalHomePage
├─ imports: ./pages/IntranetPage
├─ imports: ./pages/ManagementDashboardPage
├─ imports: ./components/PortalModuleGate
├─ imports: ./pages/integrations/IntegracoesPage (novo)
└─ exports: PortalRoutes component

PortalLayout.tsx
├─ imports: @/shell/Footer
├─ imports: react-router-dom (Outlet)
├─ imports: @/app/providers/AuthProvider (useAuth)
├─ imports: @/app/providers/TenantProvider (useTenant)
└─ exports: PortalLayout component

AppOperacional.jsx (FEATURES - MORTO)
├─ imports: ./pages/* (todos .jsx com imports quebrados)
└─ exports: AppOperacional (ÓRFÃO)

AppOperacional.jsx (APPS - ATIVO)
├─ imports: ./security/RequireContext
├─ imports: react-router-dom
├─ imports: Lucide icons
├─ imports: Stub pages (placeholders html)
└─ exports: AppOperacional

main.tsx (atual)
├─ imports: @/apps/operacional/AppOperacional (lazy) ← CORRETO
└─ usa features/ APAGADO
```

---

## COMPONENTES MORTOS

1. `frontend/src/features/` - TODOS (26 arquivos)
   - Motivo: Importados apenas por `features/atendimento/AppOperacional.tsx` que não é mais importado por main.tsx
2. `frontend/src/components/auth/LoginForm.tsx` - ÓRFÃO
3. `frontend/src/components/portal/ModuleCard.tsx` - DUPLICADO (existe em apps/portal/components/)
4. `frontend/src/components/portal/ModuleGrid.tsx` - DUPLICADO
5. `frontend/src/components/portal/PortalHeader.tsx` - DUPLICADO (versão mais rica em apps/)
6. `frontend/src/components/layout/DynamicSidebar.tsx` - ÓRFÃO
7. `frontend/src/components/guards/RequireContext.tsx` - DUPLICADO (existe em apps/operacional/security/)

---

## LAYOUTS MORTOS

1. `frontend/src/layouts/LoginLayout.tsx` - NÃO importado por qualquer rota ativa
2. `frontend/src/apps/operacional/layout/Layout.tsx` - Importa AuthProvider quebrado

---

## PAGES MORTAS

1. `pages/auth/LoginPage.tsx`
2. `pages/dashboard/Dashboard.tsx` + `DashboardBase.tsx` (cadeia morta)
3. `pages/portal/Portal.css`
4. `pages/Dashboard.css`
5. `apps/portal/pages/HomePage.tsx` (import quebrado)
6. `apps/contexto/context/ContextProvider.tsx` (sobrepõe RuntimeContext)
7. `apps/auth/pages/LoginPage.tsx` + `LoginForm.tsx` (import quebrado)

---

## PROVIDERS MORTOS/DUPLICADOS

1. `app/providers/RuntimeContext.tsx` - CANÔNICO
2. `apps/contexto/context/ContextProvider.tsx` - DUPLICADO (mesmo propósito)
3. `apps/operacional/context/ContextContext.tsx` - SHIM MORTO (re-exporta RuntimeContext)
4. `app/providers/authProvider.tsx` - CANÔNICO

---

## HOOKS MORTOS/DUPLICADOS

1. `hooks/useApp.js` - Importa contexto que não existe
2. `hooks/useAuth.js` - Re-export do .ts (morto)
3. `hooks/useDispatch.js` - Duplicado não tipado

---

## STORES MORTOS

1. `shared/stores/auth.store.ts` (Zustand) - Nunca importado

---

## SERVIÇOS MORTOS/DUPLICADOS

1. `services/api.ts` - Duplicado de `api/api.js`
2. `services/FilaService.ts` - Mock stub, duplicado de `.js`
3. `services/runtimeService.js` - Duplicado de `runtime.service.js`
4. `services/index.js` - Importa AuthService que não existe

---

## HOOKS ATIVOS (CANÔNICOS)

1. `hooks/useAuth.ts` - ATIVO
2. `hooks/useDispatch.ts` - ATIVO
3. `hooks/useRuntime.ts` - ATIVO
4. `hooks/useTenant.ts` - ATIVO
5. `hooks/useFilaRealtime.js` - ATIVO
6. `hooks/useMenu.js` - ATIVO

---

## PROVEDORES ATIVOS (CANÔNICOS)

1. `app/providers/index.ts` - ATIVO
2. `app/providers/AuthProvider.tsx` - ATIVO
3. `app/providers/TenantProvider.tsx` - ATIVO
4. `app/providers/RuntimeContext.tsx` - ATIVO
5. `app/providers/types.ts` - ATIVO

FIM DO RELATÓRIO FASE 2

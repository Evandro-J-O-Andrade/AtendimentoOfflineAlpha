# ESTRUTURA FINAL ALVO - FASE 9
Data: 2026-06-17

---

## FRONTEND

frontend/src/
├── main.tsx
├── App.tsx
├── api/
│   ├── api.js
│   └── spApi.js
├── app/
│   └── providers/
│       ├── index.ts
│       ├── AuthProvider.tsx
│       ├── RuntimeContext.tsx
│       ├── TenantProvider.tsx
│       └── types.ts
├── apps/
│   ├── portal/
│   │   ├── layouts/
│   │   ├── routes/
│   │   ├── components/
│   │   ├── hooks/
│   │   ├── pages/
│   │       ├── login/
│   │       ├── PortalHomePage.tsx
│   │       ├── IntranetPage.tsx
│   │       ├── ManagementDashboardPage.tsx
│   │       ├── IntegracoesPage.tsx
│   ├── operacional/
│   │   ├── AppOperacional.tsx
│   │   ├── components/
│   │   ├── layout/
│   │   ├── pages/
│   │   └── services/
│   ├── painel/
│   │   ├── AppPainel.tsx
│   │   └── pages/
│   ├── totem/
│   │   ├── AppTotem.tsx
│   │   └── pages/
│   ├── admin/
│   │   ├── pages/
│   │   └── security/
│   ├── contexto/
│   │   └── pages/
│   ├── social/
│   ├── chat/
│   ├── wiki/
│   └── analytics/
├── services/
│   ├── FilaService.js
│   ├── AssistencialService.js
│   ├── loginService.js
│   ├── PermissionService.js
│   ├── PacienteService.js
│   ├── UserService.js
│   ├── sessionService.js
│   ├── syncService.js
│   └── runtime.service.js
├── hooks/
│   ├── useAuth.ts
│   ├── useDispatch.ts
│   ├── useRuntime.ts
│   ├── useTenant.ts
│   ├── useFilaRealtime.js
│   └── useMenu.js
├── components/
│   ├── guards/
│   │   └── RequireContext.tsx
│   └── layout/
│       └── DynamicSidebar.tsx
├── shell/
│   └── Footer.tsx
├── themes/
│   ├── globals.css
│   └── variables.css
├── types/
│   ├── auth.ts
│   └── portal.ts
└── assets/

---

## BACKEND

backend/src/
├── app.js
├── config/
│   ├── database.js
│   └── jwt.js
├── auth/
│   ├── authController.js
│   ├── authMiddleware.js
│   ├── authRoutes.js
│   ├── authService.js
│   ├── loginContextService.js
│   ├── permissionMiddleware.js
│   ├── permissionService.js
│   └── runtimeContextMiddleware.js
├── kernel/
│   ├── dispatcher_gateway.js
│   ├── config/
│   │   └── kernel_auth_config.js
│   ├── auth/
│   │   ├── auth_login_service.js
│   │   ├── auth_guardian_assert.js
│   │   ├── auth_password_hash.js
│   │   ├── auth_runtime_dispatcher.js
│   │   └── auth_session_validator.js
│   ├── authz_client.js
│   ├── ledger_client.js
│   └── worker/
│       ├── runtime_worker_processor.js
│       └── worker_runner.js
├── integrations/
│   └── n8n/
│       ├── routes/
│       │   └── n8nRoutes.js
│       └── webhooks/
│           └── n8nWebhookHandler.js
├── routes/
│   ├── contextoRoutes.js
│   ├── dispatcherRoutes.js
│   ├── farmaciaRoutes.js
│   ├── filaRoutes.js
│   ├── operacionalRoutes.js
│   ├── painelRoutes.js
│   ├── permissaoRoutes.js
│   ├── portalRoutes.js
│   ├── sessionRoutes.js
│   ├── spRoutes.js
│   ├── totemRoutes.js
│   └── triagemRoutes.js
├── services/
│   ├── spMasterService.js
│   ├── spService.js
│   ├── auditoria_service.js
│   ├── farmacia_service.js
│   ├── triagem_service.js
│   ├── senha_service.js
│   └── atendimento_service.js
├── runtime/
│   ├── runtimeGuard.js
│   ├── sessionGuard.js
│   ├── snapshotValidator.js
│   ├── syncQueueManager.js
│   └── oracleEngine.js
├── context/
│   └── contextService.js
├── ledger/
│   ├── ledgerRoutes.js
│   └── ledgerService.js
└── [futuro] infrastructure/
    └── config/
    └── database/
    └── cache/

---

## DATABASE

database/
├── stages/
│   ├── Stage100.sql
│   ├── Stage200.sql
│   ├── Stage201.sql
│   └── Stage202.sql
└── dispatchers/
    └── sp_master_dispatcher.js

backend/sql/
├── Dump20260606.sql
├── portal_schema.sql
├── BANCO_DADOS_INVENTARIO.md
└── STORED_PROCEDURES_MAP.md

---

## ESTRUTURA FINAL ESPERADA VS REAL

### Frontend
- shell: ✅ existe parcial (Footer.tsx)
- core: ❌ não existe (futuro)
- shared: ✅ existe mas com arquivos mortos
- themes: ✅ existe
- assets: ✅ existe
- apps: ✅ existe com duplicatas

### Backend
- api: ❌ não existe (rotas estão em src/routes/)
- kernel: ✅ existe
- services: ✅ existe
- integrations: ✅ existe
- runtime: ✅ existe
- infrastructure: ❌ não existe (config/ está na raiz)

---

## PRÓXIMOS PASSOS APÓS LIMPEZA

1. Criar backend/infrastructure/config/
2. Mover backend/src/config/ para backend/infrastructure/config/
3. Atualizar imports que usam ../config/
4. Criar backend/api/ agrupando rotas por domínio
5. Remover backend/core/ após confirmar que nada importa dele
6. Atualizar tsconfig paths do frontend para refletir estrutura canônica
7. Unificar main.tsx e App.tsx em uma entry point única
8. Remover features/ inteira
9. Remover .jsx duplicados em operacional/pages/
10. Remover duplicatas de API/services/hooks

FIM DO RELATÓRIO FASE 9

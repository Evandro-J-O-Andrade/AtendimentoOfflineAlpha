# RELATORIO INVENTARIO REAL - FASE 1
**Data:** 2026-06-17
**Escopo:** frontend/ + backend/ + database/ + docs/
**Status:** INVENTÁRIO COMPLETO

---

## 1. ÁRVORE DE DIRETÓRIOS

### frontend/src/
```
frontend/src/
├── api/                          [3 arquivos]
│   ├── api.js
│   ├── spApi.js
│   └── spApi.ts
├── app/
│   └── providers/                [5 arquivos]
│       ├── index.ts
│       ├── AuthProvider.tsx
│       ├── RuntimeContext.tsx
│       ├── TenantProvider.tsx
│       └── types.ts
├── apps/
│   ├── admin/                    [7 arquivos]
│   │   ├── pages/                [4 arquivos .tsx/.css]
│   │   └── security/             [2 arquivos .tsx/.jsx]
│   ├── agenda/pages/             [1 arquivo .tsx]
│   ├── auth/pages/               [2 arquivos .tsx - ÓRFÃOS]
│   ├── ava/pages/                [1 arquivo .tsx]
│   ├── bi/pages/                 [1 arquivo .tsx]
│   ├── chamados/pages/           [1 arquivo .tsx]
│   ├── chat/pages/               [1 arquivo .tsx]
│   ├── contexto/                 [4 arquivos]
│   │   ├── context/              [1 arquivo .tsx - DUPLICADO]
│   │   ├── pages/                [1 arquivo .tsx - ATIVO]
│   │   └── types/                [1 arquivo .ts]
│   ├── crm/pages/                [1 arquivo .tsx]
│   ├── documentos/pages/         [1 arquivo .tsx]
│   ├── financeiro/pages/         [1 arquivo .tsx]
│   ├── intranet/pages/           [1 arquivo .tsx]
│   ├── operacional/              [50+ arquivos]
│   │   ├── AppOperacional.jsx   [ATIVO - .tsx também existe em features/]
│   │   ├── components/
│   │   ├── context/              [1 arquivo .tsx - SHIM MORTO]
│   │   ├── layout/
│   │   ├── pages/                [26+ subdirs com .tsx/.jsx/.css duplicados]
│   │   ├── security/
│   │   └── services/
│   ├── ouvidoria/pages/          [1 arquivo .tsx]
│   ├── painel/                   [7 arquivos .tsx + .jsx duplicados]
│   ├── portal/                   [20+ arquivos]
│   │   ├── components/
│   │   ├── hooks/
│   │   ├── layouts/
│   │   ├── pages/                [4 páginas + login/ + HomePage.tsx ÓRFÃO]
│   │   ├── routes/               [2 arquivos - DUPLICADO]
│   │   └── services/
│   ├── ramal/pages/              [1 arquivo .tsx]
│   ├── rh/pages/                 [1 arquivo .tsx]
│   ├── totem/                    [6 arquivos .tsx + .jsx]
│   └── wiki/pages/               [1 arquivo .tsx]
├── assets/
│   └── branding/                 [1 arquivo .png]
├── components/                   [7 arquivos - DUPLICADOS de apps/]
│   ├── auth/
│   ├── guards/
│   ├── layout/
│   └── portal/
├── features/                     [26 arquivos - TODOS ÓRFÃOS]
│   ├── administracao/
│   ├── atendimento/
│   ├── estoque/
│   ├── farmacia/
│   └── faturamento/
├── hooks/                        [8 arquivos - 2 duplicados]
├── layouts/                      [1 arquivo - MORTO]
├── pages/                        [5 arquivos - TODOS MORTOS]
├── services/                     [14 arquivos - 3 duplicados, 1 morto]
├── shared/                       [7 arquivos]
├── shell/                        [1 arquivo]
├── themes/                       [2 arquivos]
└── types/                        [2 arquivos]

### backend/src/
```
backend/src/
├── app.js                        [ENTRY POINT]
├── config/
│   ├── database.js
│   └── jwt.js
├── auth/                         [10 arquivos - PRODUÇÃO]
│   ├── authController.js
│   ├── authController_bkp.js     [BACKUP MORTO]
│   ├── authMiddleware.js
│   ├── authRoutes.js
│   ├── authService.js
│   ├── loginContextService.js
│   ├── permissionMiddleware.js
│   ├── permissionService.js
│   └── runtimeContextMiddleware.js
├── controllers/
│   └── auth/
│       └── loginController.js    [MORTO]
├── core/                         [11 arquivos - DUPLICADO MORTO]
│   ├── dispatcher_gateway.js
│   ├── auth_login_service.js
│   ├── auth_guardian_assert.js
│   ├── auth_password_hash.js
│   ├── auth_runtime_dispatcher.js
│   ├── auth_session_validator.js
│   ├── kernel_auth_config.js
│   ├── ledger_client.js
│   ├── authz_client.js
│   ├── runtime_worker_processor.js
│   └── worker_runner.js
├── kernel/                       [11 arquivos - ATIVO]
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
│   └── n8n/                      [2 arquivos]
│       ├── routes/
│       │   └── n8nRoutes.js
│       └── webhooks/
│           └── n8nWebhookHandler.js
├── middlewares/
│   └── authMiddleware.js         [LEGACY]
├── routes/                       [12 arquivos]
│   ├── authRoutes.js             [RECÉM-CRIADO - CONFLITO]
│   ├── contextoRoutes.js
│   ├── dispatcherRoutes.js
│   ├── farmaciaRoutes.js
│   ├── fila.js                   [LEGACY]
│   ├── filaRoutes.js
│   ├── operacionalRoutes.js
│   ├── painelRoutes.js
│   ├── permissaoRoutes.js
│   ├── portalRoutes.js
│   ├── sessionRoutes.js
│   ├── spRoutes.js
│   └── totemRoutes.js
│   └── triagemRoutes.js
├── services/                     [8 arquivos]
│   ├── spMasterService.js
│   ├── spService.js
│   ├── auditoria_service.js
│   ├── farmacia_service.js
│   ├── triagem_service.js
│   ├── senha_service.js
│   ├── atendimento_service.js
│   └── [faltam demais services]
├── runtime/                      [5 arquivos]
│   ├── runtimeGuard.js
│   ├── sessionGuard.js
│   ├── snapshotValidator.js
│   ├── syncQueueManager.js
│   └── oracleEngine.js
├── context/
│   └── contextService.js
├── ledger/                       [2 arquivos]
│   ├── ledgerRoutes.js
│   └── ledgerService.js
└── [demais]
```

### database/
```
database/
├── dispatchers/
│   └── sp_master_dispatcher.js   [STUB - não implementado]
└── stages/
    ├── Stage100.sql              [Core: pessoa, usuario, sessao, sistema, unidade, local]
    ├── Stage200.sql              [Portal: noticias, comunicados, calendario, documentos]
    ├── Stage201.sql              [Social: perfil, postagem, grupo, membro]
    └── Stage202.sql              [Integracoes: integracao, credencial, webhook]

backend/sql/
├── Dump20260606.sql              [478 tabelas - BANCO REAL]
├── portal_schema.sql
├── BANCO_DADOS_INVENTARIO.md
└── STORED_PROCEDURES_MAP.md
```

---

## 2. ARQUIVOS TOTAIS

| Categoria | Count |
|-----------|-------|
| Frontend .tsx | 80+ |
| Frontend .ts | 30+ |
| Frontend .jsx | 30+ |
| Frontend .js | 25+ |
| Frontend .css | 15+ |
| Backend .js | 52 |
| Database .sql | 4 |
| Docs .md | 60+ |

---

## 3. ARQUIVOS ÓRFÃOS CONFIRMADOS

### Frontend órfãos (sem importador):
1. `frontend/src/features/` - TODOS os 26 arquivos (importados apenas por `features/atendimento/AppOperacional.tsx` que não é usado por rota ativa)
2. `frontend/src/apps/auth/pages/LoginPage.tsx`
3. `frontend/src/apps/auth/pages/LoginForm.tsx`
4. `frontend/src/pages/auth/LoginPage.tsx`
5. `frontend/src/pages/dashboard/Dashboard.tsx`
6. `frontend/src/pages/dashboard/DashboardBase.tsx`
7. `frontend/src/pages/portal/Portal.css`
8. `frontend/src/pages/Dashboard.css`
9. `frontend/src/apps/portal/pages/HomePage.tsx`
10. `frontend/src/apps/portal/routes/portal.routes.tsx`
11. `frontend/src/hooks/useApp.js`
12. `frontend/src/layouts/LoginLayout.tsx`
13. `frontend/src/shared/stores/auth.store.ts`
14. `frontend/src/services/index.js`
15. `frontend/src/apps/operacional/context/ContextContext.tsx`
16. `frontend/src/apps/contexto/context/ContextProvider.tsx`

### Backend órfãos:
1. `backend/src/controllers/auth/loginController.js`
2. `backend/src/auth/authController_bkp.js`
3. `backend/core/` - TODOS os 11 arquivos (duplicados quebrados)

---

## 4. ARQUIVOS DUPLICADOS

### Duplicatas .tsx + .jsx (mesmo nome):
| Arquivo canônico (.tsx) | Duplicata (.jsx) | Status |
|------------------------|------------------|--------|
| apps/admin/pages/Admin.tsx | Admin.jsx | REMOVER .jsx |
| apps/admin/pages/AdminModulePage.tsx | AdminModulePage.jsx | REMOVER .jsx |
| apps/admin/security/AdminGuard.tsx | AdminGuard.jsx | REMOVER .jsx |
| apps/operacional/AppOperacional.tsx (features/) | AppOperacional.jsx (apps/) | REMOVER .jsx |
| apps/painel/AppPainel.tsx | AppPainel.jsx | REMOVER .jsx |
| apps/painel/pages/Painel.tsx | Painel.jsx | REMOVER .jsx |
| apps/painel/pages/PainelUsuario.tsx | PainelUsuario.jsx | REMOVER .jsx |
| apps/totem/AppTotem.tsx | AppTotem.jsx | REMOVER .jsx |
| apps/totem/pages/Totem.tsx | Totem.jsx | REMOVER .jsx |
| apps/operacional/pages/triagem/Triagem.tsx | Triagem.jsx | REMOVER .jsx |
| apps/operacional/pages/recepcao/Recepcao.tsx | Recepcao.jsx | REMOVER .jsx |
| apps/operacional/pages/medico/Medico.tsx | Medico.jsx | REMOVER .jsx |
| + 14 outras páginas operacionais | .jsx correspondentes | REMOVER .jsx |

### Duplicatas de API/Services:
| Arquivo canônico | Duplicata | Ação |
|------------------|-----------|------|
| api/api.js | services/api.ts | EXCLUIR services/api.ts |
| api/spApi.js | api/spApi.ts | EXCLUIR api/spApi.ts |
| services/FilaService.js | services/FilaService.ts | EXCLUIR .ts |
| runtime.service.js | runtimeService.js | MANTER .service.js, EXCLUIR .js |
| services/index.js | (nenhum) | EXCLUIR (ref. arquivo morto) |

### Duplicatas Hooks:
| Arquivo canônico | Duplicata | Ação |
|------------------|-----------|------|
| hooks/useAuth.ts | hooks/useAuth.js | EXCLUIR .js |
| hooks/useDispatch.ts | hooks/useDispatch.js | EXCLUIR .js |

### Duplicatas Backend:
| Arquivo canônico | Duplicata | Ação |
|------------------|-----------|------|
| backend/src/kernel/ (11 arquivos) | backend/core/ (11 arquivos) | EXCLUIR backend/core/ |

---

## 5. IMPORTS QUEBRADOS

### Frontend:
1. `apps/admin/pages/Admin.tsx` → `../../operacional/auth/AuthProvider` (não existe)
2. `apps/admin/pages/Admin.jsx` → mesmo erro
3. `apps/admin/pages/AdminModulePage.tsx` → mesmo erro
4. `apps/admin/security/AdminGuard.tsx` → mesmo erro
5. `apps/operacional/pages/Painel.jsx` → `../../../contexts/AuthContext` (não existe)
6. `apps/operacional/layout/Layout.tsx` → `../../../context/AuthProvider` (não existe)
7. `apps/operacional/pages/*.jsx` (21 arquivos) → `../../../../context/AuthProvider` (não existe)
8. `apps/portal/pages/HomePage.tsx` → `@/services/api/dispatcher` (não existe)
9. `hooks/useApp.js` → `../context/AppContext` (não existe)
10. `services/index.js` → `./AuthService` (não existe)
11. `apps/auth/pages/LoginPage.tsx` → `../../context/AuthContext` (não existe)

### Backend (já corrigidos parcialmente):
- `backend/src/core/*` → caminhos relativos quebrados (apontam para backend/config/ que não existe)

---

## 6. ARQUIVOS SEM IMPORTAÇÃO ATIVA

### Frontend:
1. `apps/auth/pages/LoginPage.tsx`
2. `apps/auth/pages/LoginForm.tsx`
3. `pages/auth/LoginPage.tsx`
4. `pages/dashboard/Dashboard.tsx`
5. `pages/dashboard/DashboardBase.tsx`
6. `pages/portal/Portal.css`
7. `pages/Dashboard.css`
8. `apps/portal/pages/HomePage.tsx`
9. `apps/portal/routes/portal.routes.tsx`
10. `apps/operacional/context/ContextContext.tsx`
11. `apps/contexto/context/ContextProvider.tsx`
12. `hooks/useApp.js`
13. `layouts/LoginLayout.tsx`
14. `shared/stores/auth.store.ts`
15. `services/index.js`
16. Toda a pasta `features/` (26 arquivos)
17. `apps/operacional/pages/*.jsx` raiz (arquivos .jsx duplicados)

### Backend:
1. `auth/authController_bkp.js`
2. `controllers/auth/loginController.js`
3. `core/` (todos os 11)
4. `middlewares/authMiddleware.js` (legacy, apenas fila.js importa)

---

FIM DO RELATÓRIO FASE 1

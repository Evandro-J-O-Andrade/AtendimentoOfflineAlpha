# MAPA_BACKEND - FASE 4
**Data:** 2026-06-17

---

## ESTRUTURA BACKEND REAL

```
backend/src/
├── app.js                          [Entry point]
├── config/
│   ├── database.js                 [Conexão MySQL]
│   └── jwt.js                      [JWT config]
├── auth/                           [PRODUÇÃO - Autenticação]
│   ├── authController.js           [470 linhas - ATIVO]
│   ├── authController_bkp.js       [427 linhas - MORTO]
│   ├── authMiddleware.js           [ATIVO - importado por 9 rotas]
│   ├── authRoutes.js               [ATIVO - montado em app.js]
│   ├── authService.js              [ATIVO]
│   ├── loginContextService.js      [ATIVO]
│   ├── permissionMiddleware.js     [ATIVO]
│   ├── permissionService.js        [ATIVO]
│   └── runtimeContextMiddleware.js [ATIVO]
├── controllers/
│   └── auth/
│       └── loginController.js      [60 linhas - MORTO]
├── core/                           [11 arquivos - MORTO/DUPLICADO]
│   ├── dispatcher_gateway.js       [EXCLUIR - duplicado quebrado]
│   ├── auth_guardian_assert.js     [EXCLUIR]
│   ├── auth_login_service.js       [EXCLUIR]
│   ├── auth_password_hash.js       [EXCLUIR]
│   ├── auth_runtime_dispatcher.js  [EXCLUIR]
│   ├── kernel_auth_config.js       [EXCLUIR]
│   ├── ledger_client.js            [EXCLUIR]
│   ├── authz_client.js             [EXCLUIR]
│   ├── worker_runner.js            [EXCLUIR]
│   └── worker/
│       └── runtime_worker_processor.js [EXCLUIR]
├── kernel/                         [ATIVO - 11 arquivos]
│   ├── dispatcher_gateway.js       [ATIVO]
│   ├── auth/                       [5 arquivos ativos]
│   │   ├── auth_login_service.js
│   │   ├── auth_guardian_assert.js
│   │   ├── auth_password_hash.js
│   │   ├── auth_runtime_dispatcher.js
│   │   └── auth_session_validator.js
│   ├── authz_client.js             [ATIVO]
│   ├── ledger_client.js            [ATIVO]
│   ├── runtime_worker_processor.js [ATIVO]
│   ├── worker_runner.js            [ATIVO]
│   └── config/
│       └── kernel_auth_config.js   [ATIVO]
├── middlewares/
│   └── authMiddleware.js           [LEGACY - 18 linhas, usado por fila.js]
├── routes/                         [13 arquivos]
│   ├── contextoRoutes.js           [ATIVO]
│   ├── dispatcherRoutes.js         [ATIVO]
│   ├── farmaciaRoutes.js           [ATIVO]
│   ├── fila.js                     [LEGACY - imports authMiddleware]
│   ├── filaRoutes.js               [ATIVO]
│   ├── operacionalRoutes.js        [ATIVO]
│   ├── painelRoutes.js             [ATIVO]
│   ├── permissaoRoutes.js          [ATIVO]
│   ├── portalRoutes.js             [ATIVO]
│   ├── sessionRoutes.js            [ATIVO]
│   ├── spRoutes.js                 [ATIVO]
│   ├── totemRoutes.js              [ATIVO]
│   ├── triagemRoutes.js            [ATIVO]
│   └── authRoutes.js               [NOVO - CONFLITO com auth/authRoutes.js]
├── services/                       [8 arquivos]
│   ├── spMasterService.js          [ATIVO - sp_master_dispatcher]
│   ├── spService.js                [ATIVO - múltiplas SPs]
│   ├── auditoria_service.js        [ATIVO]
│   ├── farmacia_service.js         [ATIVO]
│   ├── triagem_service.js          [ATIVO]
│   ├── senha_service.js            [ATIVO]
│   └── atendimento_service.js      [ATIVO]
├── runtime/                        [5 arquivos]
│   ├── runtimeGuard.js             [ATIVO]
│   ├── sessionGuard.js             [ATIVO]
│   ├── snapshotValidator.js        [ATIVO]
│   ├── syncQueueManager.js         [ATIVO]
│   └── oracleEngine.js             [ATIVO]
├── context/
│   └── contextService.js           [ATIVO]
├── ledger/
│   ├── ledgerRoutes.js             [ATIVO]
│   └── ledgerService.js            [ATIVO]
└── integrations/
    └── n8n/
        ├── routes/
        │   └── n8nRoutes.js        [ATIVO]
        └── webhooks/
            └── n8nWebhookHandler.js [ATIVO]
```

---

## ANÁLISE POR CATEGORIA

### Controllers ativos vs mortos

| Arquivo | Status | Motivo |
|---------|--------|--------|
| auth/authController.js | ATIVO | 470 linhas, produção completa, importado por authRoutes.js |
| controllers/auth/loginController.js | MORTO | 60 linhas, usa req.app.locals.db (nunca setado), não importado |

### Middlewares ativos vs mortos

| Arquivo | Status | Motivo |
|---------|--------|--------|
| auth/authMiddleware.js | ATIVO | 168 linhas, importado por 9 rotas, valida sessão no banco |
| middlewares/authMiddleware.js | LEGACY | 18 linhas, importado apenas por routes/fila.js, JWT simples |

### Routes ativas vs mortas

| Arquivo | Status | Motivo |
|---------|--------|--------|
| routes/triagemRoutes.js | ATIVO | Montado em app.js |
| routes/sessionRoutes.js | ATIVO | Montado em app.js |
| routes/permissaoRoutes.js | ATIVO | Montado em app.js |
| routes/operacionalRoutes.js | ATIVO | Montado em app.js |
| routes/filaRoutes.js | ATIVO | Montado em app.js |
| routes/farmaciaRoutes.js | ATIVO | Montado em app.js |
| routes/contextoRoutes.js | ATIVO | Montado em app.js |
| routes/dispatcherRoutes.js | ATIVO | Montado em app.js |
| routes/portalRoutes.js | ATIVO | Montado em app.js |
| routes/painelRoutes.js | ATIVO | Montado em app.js |
| routes/totemRoutes.js | ATIVO | Montado em app.js |
| routes/spRoutes.js | ATIVO | Montado em app.js |
| routes/authRoutes.js | CONFLITO | Criado recentemente, conflita com auth/authRoutes.js |

### Services ativos

| Arquivo | Status | Importado por |
|---------|--------|---------------|
| spMasterService.js | ATIVO | filaRoutes, dispatcherRoutes |
| spService.js | ATIVO | spRoutes |
| auditoria_service.js | ATIVO | authController |
| farmacia_service.js | ATIVO | farmaciaController |
| triagem_service.js | ATIVO | rotas triagem |
| senha_service.js | ATIVO | rotas |
| atendimento_service.js | ATIVO | rotas operacional |

### Core vs Kernel

| Diretório | Status | Motivo |
|-----------|--------|--------|
| kernel/ | ATIVO | Caminhos corretos, importado por services |
| core/ | MORTO | Caminhos quebrados (apontam para config/ inexistente), byte-for-byte idêntico a kernel/ |

---

## CONFLITO CRÍTICO: authRoutes.js

**Problema:**
- `backend/src/auth/authRoutes.js` existe E é montado em `app.js` linha 4: `require("./auth/authRoutes")`
- `backend/src/routes/authRoutes.js` foi criado recentemente (não existia no commit anterior)

**Ação:**
- EXCLUIR `backend/src/routes/authRoutes.js`
- MANTER `backend/src/auth/authRoutes.js`

---

## ESTRUTURA ESPERADA vs REAL

### Esperada (canônica):
```
backend/src/
├── api/                    ← NÃO EXISTE
├── kernel/                 ← EXISTE (ok)
├── services/               ← EXISTE (ok)
├── integrations/           ← EXISTE (ok)
├── runtime/                ← EXISTE (ok)
├── infrastructure/         ← NÃO EXISTE
├── routes/                 ← EXISTE (ok)
├── middlewares/            ← EXISTE (ok)
└── config/                 ← EXISTE mas deveria ser infrastructure/config
```

### Real (atual):
- Falta: `backend/api/` (rotas agrupadas por domínio)
- Falta: `backend/infrastructure/`
- `config/` está na raiz de src/ mas deveria estar em infrastructure/

---

## SERVIÇOS QUE IMPORTAM DE KERNEL

4 services importam `"../kernel/dispatcher_gateway"`:
1. `services/farmacia_service.js`
2. `services/triagem_service.js`
3. `services/senha_service.js`
4. `services/atendimento_service.js`

**Status:** Funcionam corretamente (caminho resolve para src/kernel/)

---

## ARQUIVOS PARA EXCLUIR (BACKEND)

1. `backend/core/` (todos os 11 arquivos)
2. `backend/src/auth/authController_bkp.js`
3. `backend/src/controllers/auth/loginController.js`
4. `backend/src/routes/authRoutes.js` (o novo, não o de auth/)
5. `backend/src/middlewares/authMiddleware.js` (se fila.js for removido)

FIM DO RELATÓRIO FASE 4

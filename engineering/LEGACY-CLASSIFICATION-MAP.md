# LEGACY INVENTORY - CLASSIFICATION MAP

## 🔐 AUTH DOMAIN (KEEP)
- legacy/backend_antigo/src/kernel/auth/auth_login_service.js → SP auth flow existente
- legacy/backend_antigo/src/routes/sessionRoutes.js → Sessão JWT

## 🏢 CONTEXT DOMAIN (WRAP)
- legacy/backend_antigo/src/routes/contextoRoutes.js → sp_auth_contexto_get/set
- legacy/backend_antigo/src/services/atendimento_service.js → Context logic

## 🏥 HIS DOMAIN (WRAP)
- legacy/backend_antigo/src/services/senha_service.js → Geração de senhas
- legacy/backend_antigo/src/services/triagem_service.js → Triagem
- legacy/backend_antigo/src/routes/triagemRoutes.js
- legacy/backend_antigo/src/routes/filaRoutes.js

## 💰 FINANCEIRO DOMAIN (ANALYZE)
- legacy/backend_antigo/src/routes/farmaciaRoutes.js
- legacy/backend_antigo/src/services/farmacia_service.js

## 📊 DASHBOARD (KEEP)
- legacy/backend_antigo/src/routes/painelRoutes.js
- legacy/backend_antigo/src/services/spMasterService.js

## 🔌 ADAPTER ENDPOINTS MAP
```
/api/contextos → contextAdapter.getContexts()
/api/contextos (POST) → contextAdapter.selectContext()
/api/auth/login → authService.login()
```

## 📋 DECISÃO
- KEEP: Auth + Session (funcional)
- WRAP: Context + HIS + Painel (conectar via adapter)
- ANALYZE: Farmacia/Financeiro (avaliar reuso)
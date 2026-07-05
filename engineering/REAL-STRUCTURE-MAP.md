# LEGACY → NEW WAVE - ESTRUTURA REAL CONSOLIDADA

## 📁 RAIZ DO PROJETO
```
AtendimentoOfflineAlpha/
├── apps/
│   └── backend/
│       └── auth/index.js (stub - conectar ao legacy)
├── legacy/
│   ├── backend_antigo/ (Node.js + Express + MySQL)
│   │   ├── src/kernel/auth/auth_login_service.js (auth real)
│   │   ├── src/routes/contextoRoutes.js (contexto real)
│   │   └── src/routes/sessionRoutes.js (sessão real)
│   └── frontend_rebuild_candidate/ (React + Router + Providers)
│       ├── src/App.tsx (router real)
│       ├── src/app/providers/AuthProvider.tsx (auth real)
│       └── src/apps/portal/pages/PortalHomePage.tsx (portal real)
├── src/ (arquivos que criei - pode integrar ao rebuild)
└── engineering/canonical/md/ (488 MDs - fonte de verdade)
```

## 🔌 ENDPOINTS LEGACY REAIS
```
/auth/login → auth_login_service.authenticate()
/auth/refresh
/auth/me
/contextos (GET) → sp_auth_contexto_get
/contextos (POST) → sp_auth_contexto_set
/contextos/atual
```

## 🎯 ESTRATÉGIA
1. Usar legacy/frontend_rebuild_candidate como base
2. Adaptar providers existentes
3. Manter rotas existentes
4. Integrar com backend_antigo
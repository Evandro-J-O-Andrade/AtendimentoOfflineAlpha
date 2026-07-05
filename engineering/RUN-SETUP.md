# NEW WAVE PORTAL OS - SETUP PRONTO

## 🔧 OPÇÃO 1: FRONTEND ANTIGO (FUNCIONAL)
```bash
cd legacy/frontend_antigo
npm run dev
# http://localhost:5173
```

## 🔧 OPÇÃO 2: FRONTEND NOVO (apps/frontend)
```bash
npm run dev
# http://localhost:3000
```

## 📁 ESTRUTURA apps/frontend
- components/ (PortalShell, TopBar, SidePanel, Guards)
- pages/ (LoginPage, PortalHome, Dashboard)
- services/ (authService, contextAdapter)
- hooks/ (useAuth)
- store/ (useAuthStore)
- styles/ (global.css, PortalShell.css)

## 🔌 INTEGRAÇÃO LEGACY
authService → backend_antigo auth_login_service.js
- /api/auth/login
- /api/auth/session  
- /api/contextos
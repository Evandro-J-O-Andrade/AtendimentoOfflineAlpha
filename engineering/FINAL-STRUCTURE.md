# NEW WAVE Portal OS - ESTRUTURA FINAL

## 📁 APPROVED STRUCTURE
```
apps/
├── backend/
│   └── auth/index.js (stub)
├── frontend/
│   ├── components/
│   │   ├── AppRouter.tsx
│   │   ├── AuthGuard.tsx
│   │   ├── ContextGuard.tsx
│   │   ├── PortalShell.tsx
│   │   ├── SidePanel.tsx
│   │   └── TopBar.tsx
│   ├── hooks/
│   │   └── useAuth.ts
│   ├── pages/
│   │   ├── Dashboard.tsx
│   │   ├── LoginForm.tsx
│   │   ├── LoginPage.tsx
│   │   ├── PortalHome.tsx
│   │   ├── PortalPage.tsx
│   │   ├── AppLauncher.tsx
│   │   ├── AppTile.tsx
│   │   └── AppRegistry.tsx
│   ├── services/
│   │   ├── authService.ts
│   │   ├── contextAdapter.ts
│   │   └── httpClient.ts
│   ├── store/
│   │   └── useAuthStore.ts
│   ├── styles/
│   │   ├── AppLauncher.css
│   │   ├── global.css
│   │   ├── PortalShell.css
│   │   ├── SidePanel.css
│   │   ├── TilesGrid.css
│   │   └── TopBar.css
│   ├── main.tsx
│   └── index.html
```

## 🚀 COMO RODAR
```bash
npm run dev
# Acesse: http://localhost:3000
```

## 🔌 INTEGRAÇÃO LEGACY
- authService → legacy/backend_antigo/src/routes/sessionRoutes.js
- authService → legacy/backend_antigo/src/kernel/auth/auth_login_service.js
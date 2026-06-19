# PLANO DE LIMPEZA - FASE 8
Data: 2026-06-17
Ação: Somente lista. Nenhuma alteração executada aqui.

---

## 1. ARQUIVOS PARA EXCLUIR

### Frontend
- frontend/src/features/**/*
- frontend/src/apps/auth/pages/LoginPage.tsx
- frontend/src/apps/auth/pages/LoginForm.tsx
- frontend/src/pages/auth/LoginPage.tsx
- frontend/src/pages/dashboard/Dashboard.tsx
- frontend/src/pages/dashboard/DashboardBase.tsx
- frontend/src/pages/portal/Portal.css
- frontend/src/pages/Dashboard.css
- frontend/src/layouts/LoginLayout.tsx
- frontend/src/shared/stores/auth.store.ts
- frontend/src/hooks/useApp.js
- frontend/src/hooks/useAuth.js
- frontend/src/hooks/useDispatch.js
- frontend/src/services/index.js
- frontend/src/services/api.ts
- frontend/src/services/FilaService.ts
- frontend/src/services/runtimeService.js
- frontend/src/api/spApi.ts
- frontend/src/apps/operacional/context/ContextContext.tsx
- frontend/src/apps/contexto/context/ContextProvider.tsx
- frontend/src/apps/operacional/pages/[substituir .jsx por .tsx e remover .jsx]

### Backend
- backend/core/**/*
- backend/src/controllers/auth/loginController.js
- backend/src/auth/authController_bkp.js
- backend/src/routes/authRoutes.js (somente o novo em routes/, não o de auth/)
- backend/src/middlewares/authMiddleware.js (apenas se fila.js também for removido)

---

## 2. ARQUIVOS PARA MOVER

Não aplicável na Fase 0. Mover pastas inteiras seria reestruturação maior.

---

## 3. ARQUIVOS PARA RENOMEAR

Não aplicável na Fase 0.

---

## 4. ARQUIVOS PARA MESCLAR

- services/runtime.service.js + services/runtimeService.js → manter apenas runtime.service.js

---

## 5. AÇÕES ESPECIAIS

- Confirmar qual AppOperacional é canônico: apps/operacional/AppOperacional.jsx ou features/atendimento/AppOperacional.tsx
- Confirmar qual LoginForm é canônico: apps/portal/pages/login/LoginForm.tsx ou components/auth/LoginForm.tsx
- Resolver conflito de authRoutes.js antes de excluir
- Validar backend/src/routes/fila.js dependendo da manutenção de middlewares/authMiddleware.js

FIM DO RELATÓRIO FASE 8

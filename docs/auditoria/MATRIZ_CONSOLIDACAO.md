# MATRIZ DE CONSOLIDAÇÃO - FASE 7
Data: 2026-06-17
Formato: CAMINHO | AÇÃO | MOTIVO

---

## FRONTEND

### Excluir
frontend/src/features/administracao/Admin.tsx | EXCLUIR | Órfão, não importado por rota ativa
frontend/src/features/administracao/AdminModulePage.tsx | EXCLUIR | Órfão
frontend/src/features/administracao/Cat.tsx | EXCLUIR | Órfão
frontend/src/features/administracao/Manutencao.tsx | EXCLUIR | Órfão
frontend/src/features/atendimento/Ambulancia.tsx | EXCLUIR | Órfão
frontend/src/features/atendimento/AppOperacional.tsx | EXCLUIR | O AppOperacional canônico está em apps/operacional; features/ é órfão
frontend/src/features/atendimento/AssistenciaSocial.tsx | EXCLUIR | Órfão
frontend/src/features/atendimento/Enfermagem.tsx | EXCLUIR | Órfão
frontend/src/features/atendimento/Gasoterapia.tsx | EXCLUIR | Órfão
frontend/src/features/atendimento/Interconsulta.tsx | EXCLUIR | Órfão
frontend/src/features/atendimento/Internacao.tsx | EXCLUIR | Órfão
frontend/src/features/atendimento/Laboratorio.tsx | EXCLUIR | Órfão
frontend/src/features/atendimento/Medico.tsx | EXCLUIR | Órfão
frontend/src/features/atendimento/Nutricao.tsx | EXCLUIR | Órfão
frontend/src/features/atendimento/Obito.tsx | EXCLUIR | Órfão
frontend/src/features/atendimento/Recepcao.tsx | EXCLUIR | Órfão
frontend/src/features/atendimento/Triagem.tsx | EXCLUIR | Órfão
frontend/src/features/estoque/Estoque.tsx | EXCLUIR | Órfão
frontend/src/features/estoque/Pdv.tsx | EXCLUIR | Órfão
frontend/src/features/estoque/Remocao.tsx | EXCLUIR | Órfão
frontend/src/features/farmacia/Farmacia.tsx | EXCLUIR | Órfão
frontend/src/features/faturamento/Faturamento.tsx | EXCLUIR | Órfão
frontend/src/apps/auth/pages/LoginPage.tsx | EXCLUIR | Duplicata/órfã
frontend/src/apps/auth/pages/LoginForm.tsx | EXCLUIR | Duplicata/órfã
frontend/src/pages/auth/LoginPage.tsx | EXCLUIR | Órfã
frontend/src/pages/dashboard/Dashboard.tsx | EXCLUIR | Cadeia morta
frontend/src/pages/dashboard/DashboardBase.tsx | EXCLUIR | Cadeia morta
frontend/src/pages/portal/Portal.css | EXCLUIR | Não importado
frontend/src/pages/Dashboard.css | EXCLUIR | Não importado
frontend/src/layouts/LoginLayout.tsx | EXCLUIR | Não importado
frontend/src/shared/stores/auth.store.ts | EXCLUIR | Nunca importado
frontend/src/hooks/useApp.js | EXCLUIR | Importa contexto inexistente
frontend/src/hooks/useAuth.js | EXCLUIR | Re-export de .ts
frontend/src/hooks/useDispatch.js | EXCLUIR | Duplicata de .ts
frontend/src/services/index.js | EXCLUIR | Importa AuthService inexistente
frontend/src/services/api.ts | EXCLUIR | Duplicata de api/api.js
frontend/src/services/FilaService.ts | EXCLUIR | Stub de FilaService.js
frontend/src/services/runtimeService.js | EXCLUIR | Duplicata de runtime.service.js
frontend/src/api/spApi.ts | EXCLUIR | Stub de spApi.js
frontend/src/apps/operacional/context/ContextContext.tsx | EXCLUIR | Re-export do provider canônico

### Manter
frontend/src/apps/operacional/AppOperacional.jsx | MANTER | Entrada usada por rota ativa
frontend/src/apps/operacional/pages/*.jsx (duplicatas raiz) | EXCLUIR | Mesma página já existe em subpasta .tsx

---

## BACKEND

### Excluir
backend/core/auth_guardian_assert.js | EXCLUIR | Duplicado quebrado de src/kernel/
backend/core/auth_login_service.js | EXCLUIR | Duplicado quebrado
backend/core/auth_password_hash.js | EXCLUIR | Duplicado quebrado
backend/core/auth_runtime_dispatcher.js | EXCLUIR | Duplicado quebrado
backend/core/auth_session_validator.js | EXCLUIR | Duplicado quebrado
backend/core/authz_client.js | EXCLUIR | Duplicado quebrado
backend/core/dispatcher_gateway.js | EXCLUIR | Duplicado quebrado
backend/core/kernel_auth_config.js | EXCLUIR | Duplicado quebrado
backend/core/ledger_client.js | EXCLUIR | Duplicado quebrado
backend/core/runtime_worker_processor.js | EXCLUIR | Duplicado quebrado
backend/core/worker_runner.js | EXCLUIR | Duplicado quebrado
backend/src/controllers/auth/loginController.js | EXCLUIR | Não importado e usa req.app.locals.db
backend/src/auth/authController_bkp.js | EXCLUIR | Backup não importado

FIM DO RELATÓRIO FASE 7

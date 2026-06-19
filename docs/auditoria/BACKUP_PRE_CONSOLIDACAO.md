# BACKUP_PRE_CONSOLIDACAO.md
**Data:** 2026-06-17  
**Status:** PRÉ-CONSOLIDAÇÃO — FASE 12 BLOQUEADA POR VALIDAÇÃO DE RUNTIME  
**Base:** Fases 1-9 + Snapshot git atual

---

## BLOQUEIOS TEMPORÁRIOS (não remover sem validação adicional)

Estes arquivos estão modificados no `git status` atual e **não entrarão na lista de remoção** até serem auditados na Fase 11:

```
frontend/src/app/providers/AuthProvider.tsx
frontend/src/app/providers/index.ts
frontend/src/app/providers/RuntimeContext.tsx
frontend/src/app/providers/TenantProvider.tsx
frontend/src/app/providers/types.ts
frontend/src/apps/contexto/pages/ContextSelectionPage.tsx
frontend/src/apps/operacional/security/RequireContext.tsx
frontend/src/apps/operacional/security/SecurityGuard.tsx
frontend/src/apps/portal/layouts/PortalLayout.tsx
frontend/src/apps/portal/pages/IntegracoesPage.tsx
frontend/src/apps/portal/pages/IntranetPage.tsx
frontend/src/apps/portal/pages/ManagementDashboardPage.tsx
frontend/src/apps/portal/pages/PortalHomePage.tsx
frontend/src/apps/portal/portal.css
frontend/src/apps/portal/routes/PortalRoutes.tsx
frontend/src/main.tsx
frontend/src/services/api.ts
frontend/src/shell/Footer.tsx
frontend/src/themes/globals.css
frontend/src/themes/variables.css
```

**Motivo do bloqueio:** Arquivos modificados recentemente (`M` no git status) podem conter refatorações em andamento. Removê-los sem validação cruzada pode perder trabalho.

---

## FASE 11A — VALIDAÇÃO DE RUNTIME

**Status:** CONCLUÍDA  
**Arquivo de evidência:** `MATRIZ_IMPORTADORES_REAIS.md`  
**Conclusão principal:** a Fase 12 permanece bloqueada.

### 11A.1 Entry point real

| ARQUIVO | IMPORTADO POR | STATUS |
|---|---|---|
| `frontend/index.html` | Vite | ENTRY HTML |
| `frontend/src/main.tsx` | `frontend/index.html` | ENTRY TSX REAL |
| `frontend/src/App.tsx` | `frontend/src/main.tsx` | ROOT APP REAL |
| `frontend/src/main.tsx` | nenhum outro módulo | contém `ReactDOM.createRoot(...)` |

Conclusão: o runtime atual monta `main.tsx`, que renderiza `App.tsx`.

### 11A.2 AppOperacional real

| ARQUIVO | IMPORTADO POR | STATUS |
|---|---|---|
| `frontend/src/features/atendimento/AppOperacional.tsx` | `frontend/src/App.tsx`; `frontend/src/main.tsx` | ATIVO |
| `frontend/src/apps/operacional/AppOperacional.jsx` | nenhum importador encontrado | INATIVO |
| `frontend/src_legacy/apps/operacional/AppOperacional.tsx` | nenhum importador encontrado | LEGACY INATIVO |

Conclusão: `features/atendimento/AppOperacional.tsx` está na árvore React. A pasta `features/` não pode ser removida sem quebrar `/operacional/*`.

### 11A.3 LoginPage real

| ARQUIVO | IMPORTADO POR | STATUS |
|---|---|---|
| `frontend/src/apps/portal/pages/login/LoginPage.tsx` | `frontend/src/App.tsx`; `frontend/src/main.tsx` | LOGIN REAL |
| `frontend/src/apps/auth/pages/LoginPage.tsx` | nenhum importador encontrado | INATIVO |
| `frontend/src/pages/auth/LoginPage.tsx` | nenhum importador encontrado | INATIVO |

### 11A.4 PortalRoutes real

| ARQUIVO | IMPORTADO POR | STATUS |
|---|---|---|
| `frontend/src/apps/portal/routes/PortalRoutes.tsx` | `frontend/src/App.tsx`; `frontend/src/main.tsx` | ROTAS PORTAL REAIS |
| `frontend/src/apps/portal/routes/portal.routes.tsx` | nenhum importador encontrado | INATIVO |

### 11A.5 API real

| ARQUIVO | IMPORTADO POR | STATUS |
|---|---|---|
| `frontend/src/services/api.ts` | `frontend/src/app/providers/AuthProvider.tsx`; `frontend/src/hooks/useDispatch.ts`; `frontend/src/hooks/useDispatch.js`; `frontend/src/apps/operacional/pages/recepcao/RecepcaoNew.jsx`; `frontend/src/apps/operacional/pages/medico/FilaMedica.tsx` | ATIVO |
| `frontend/src/apps/operacional/services/api.ts` | `frontend/src/apps/portal/services/portalService.ts`; `frontend/src/apps/painel/pages/PainelUsuario.tsx`; `frontend/src/apps/contexto/context/ContextProvider.tsx`; `frontend/src/api/spApi.ts` | ATIVO |
| `frontend/src/api/api.js` | `frontend/src/services/sessionService.js`; `frontend/src/services/runtimeService.js`; `frontend/src/services/loginService.js`; `frontend/src/services/PacienteService.js` | ATIVO |
| `frontend/src/services/api/dispatcher.ts` | `frontend/src/apps/portal/pages/HomePage.tsx` | ATIVO |
| `frontend/services/api/dispatcher.ts` | nenhum importador; conteúdo movido para `frontend/src/services/api/dispatcher.ts` | LEGACY MOVIDO |

Conclusão: não existe hoje um único canônico seguro para remover os demais.

### 11A.6 Aliases corrigidos

| ALIAS | SITUAÇÃO ANTERIOR | SITUAÇÃO ATUAL | STATUS |
|---|---|---|---|
| `@/services/api/dispatcher` | inexistente; import quebrado | aponta para `frontend/src/services/api/dispatcher.ts` | CORRIGIDO |
| `@/shell/*` | `frontend/shell/*` | `frontend/src/shell/*` | CORRIGIDO |
| `@/providers/*` | `frontend/providers/*` | `frontend/src/app/providers/*` | CORRIGIDO |
| `@/stores/*` | `frontend/stores/*` | `frontend/src/shared/stores/*` | CORRIGIDO |
| `@/assets/*` | `frontend/assets/*` | `frontend/src/assets/*` | CORRIGIDO |
| `@/themes/*` | `frontend/themes/*` | `frontend/src/themes/*` | CORRIGIDO |
| `@/context/*` | `frontend/src/context/*`, inexistente | removido | SEM IMPORTADORES |
| `@/routes/*` | `frontend/routes/*`, inexistente | removido | SEM IMPORTADORES |
| `@/config/*` | `frontend/config/*`, inexistente | removido | SEM IMPORTADORES |
| `@/constants/*` | `frontend/constants/*`, inexistente | removido | SEM IMPORTADORES |

### 11A.7 Validação executada

| COMANDO | RESULTADO |
|---|---|
| `npm run build` | PASSOU |
| `npm run lint` | FALHOU com erros existentes em páginas operacionais: `Estoque.jsx`, `Internacao.jsx`, `Laboratorio.jsx`, `TriagemNew.jsx` |
| `npx tsc --noEmit` | FALHOU com erros TypeScript existentes espalhados por providers, apps, features e tipos |

---

## BLOQUEIOS ATUALIZADOS APÓS FASE 11A

A Fase 12 não deve ser executada até nova decisão documentando:

1. Qual módulo API será canônico entre:
   - `frontend/src/services/api.ts`
   - `frontend/src/apps/operacional/services/api.ts`
   - `frontend/src/api/api.js`
   - `frontend/src/services/api/dispatcher.ts`

2. Qual árvore operacional será canônica:
   - `frontend/src/features/atendimento/AppOperacional.tsx`
   - `frontend/src/apps/operacional/AppOperacional.jsx`

3. Como a pasta `features/` será migrada, substituída ou removida sem quebrar `/operacional/*`.

---

## ARQUIVOS PARA EXCLUSÃO — FRONTEND

### 1. PASTA `features/` INTEIRA — BLOQUEADA PELA FASE 11A

**CAMINHO:** `frontend/src/features/`  
**STATUS:** NÃO REMOVER — ATIVA EM RUNTIME  
**MOTIVO:** `features/atendimento/AppOperacional.tsx` é importado por `App.tsx` e `main.tsx`. O runtime atual monta `main.tsx`, que renderiza `App.tsx`, portanto `/operacional/*` usa essa árvore.  
**DEPENDÊNCIAS:** Cadeia ativa via `features/atendimento/AppOperacional.tsx`; build validou o chunk `AppOperacional`.  
**SUBSTITUTO CANÔNICO:** ainda não decidido. `frontend/src/apps/operacional/AppOperacional.jsx` não possui importadores.  
**RISCO:** Alto — remover `features/` agora quebra o sistema.

ARQUIVOS:
```
features/administracao/Admin.tsx
features/administracao/AdminModulePage.tsx
features/administracao/Cat.tsx
features/administracao/Manutencao.tsx
features/atendimento/Ambulancia.tsx
features/atendimento/AppOperacional.tsx
features/atendimento/AssistenciaSocial.tsx
features/atendimento/Enfermagem.tsx
features/atendimento/Gasoterapia.tsx
features/atendimento/Interconsulta.tsx
features/atendimento/Internacao.tsx
features/atendimento/Laboratorio.tsx
features/atendimento/Medico.tsx
features/atendimento/Nutricao.tsx
features/atendimento/Obito.tsx
features/atendimento/Recepcao.tsx
features/atendimento/Triagem.tsx
features/estoque/Estoque.tsx
features/estoque/Pdv.tsx
features/estoque/Remocao.tsx
features/farmacia/Farmacia.tsx
features/faturamento/Faturamento.tsx
```

---

### 2. PASTA `apps/auth/` INTEIRA (2 arquivos)

**CAMINHO:** `frontend/src/apps/auth/pages/LoginPage.tsx`  
**STATUS:** ÓRFÃO + IMPORTS QUEBRADOS  
**MOTIVO:** Importa `../../context/AuthContext` — diretório `context/` não existe. Nunca importado por rota ativa.  
**DEPENDÊNCIAS:** Nenhuma  
**SUBSTITUTO CANÔNICO:** `frontend/src/apps/portal/pages/login/LoginPage.tsx`  
**RISCO:** Baixo

**CAMINHO:** `frontend/src/apps/auth/pages/LoginForm.tsx`  
**STATUS:** ÓRFÃO  
**MOTIVO:** Mesmo que acima, nunca importado.  
**SUBSTITUTO CANÔNICO:** `frontend/src/apps/portal/pages/login/LoginForm.tsx`  
**RISCO:** Baixo

---

### 3. PASTA `pages/` INTEIRA (5 arquivos)

**CAMINHO:** `frontend/src/pages/auth/LoginPage.tsx`  
**STATUS:** ÓRFÃO  
**MOTIVO:** Não importado por nenhuma rota ativa.  
**SUBSTITUTO:** `apps/portal/pages/login/LoginPage.tsx`  
**RISCO:** Baixo

**CAMINHO:** `frontend/src/pages/dashboard/Dashboard.tsx`  
**STATUS:** ÓRFÃO (cadeia morta)  
**MOTIVO:** Importa `DashboardBase.tsx`, que não é importado por ninguém.  
**SUBSTITUTO:** Nenhum (dashboard será recriado)  
**RISCO:** Baixo

**CAMINHO:** `frontend/src/pages/dashboard/DashboardBase.tsx`  
**STATUS:** ÓRFÃO  
**MOTIVO:** Apenas importado por `Dashboard.tsx` (também morto).  
**SUBSTITUTO:** Nenhum  
**RISCO:** Baixo

**CAMINHO:** `frontend/src/pages/portal/Portal.css`  
**STATUS:** NÃO UTILIZADO  
**MOTIVO:** Nenhum `.tsx` importa este CSS.  
**SUBSTITUTO:** `apps/portal/portal.css` (ativo)  
**RISCO:** Baixo

**CAMINHO:** `frontend/src/pages/Dashboard.css`  
**STATUS:** NÃO UTILIZADO  
**MOTIVO:** Nenhum `.tsx` importa este CSS.  
**SUBSTITUTO:** Nenhum  
**RISCO:** Baixo

---

### 4. LAYOUTS ÓRFÃOS

**CAMINHO:** `frontend/src/layouts/LoginLayout.tsx`  
**STATUS:** ÓRFÃO  
**MOTIVO:** Não importado por nenhuma rota ativa. O login atual usa `apps/portal/pages/login/LoginPage.tsx` diretamente.  
**DEPENDÊNCIAS:** Nenhuma  
**SUBSTITUTO:** `apps/portal/pages/login/LoginForm.tsx` (canônico)  
**RISCO:** Baixo

---

### 5. COMPONENTES DUPLICADOS/ÓRFÃOS

**CAMINHO:** `frontend/src/components/auth/LoginForm.tsx`  
**STATUS:** ÓRFÃO + DUPLICADO  
**MOTIVO:** Existe versão canônica em `apps/portal/pages/login/LoginForm.tsx`. Este não é importado por nenhuma rota ativa.  
**SUBSTITUTO:** `apps/portal/pages/login/LoginForm.tsx`  
**RISCO:** Baixo

**CAMINHO:** `frontend/src/components/portal/ModuleCard.tsx`  
**STATUS:** DUPLICADO  
**MOTIVO:** Versão mais completa existe em `apps/portal/components/ModuleCard.tsx`.  
**SUBSTITUTO:** `apps/portal/components/ModuleCard.tsx`  
**RISCO:** Baixo

**CAMINHO:** `frontend/src/components/portal/ModuleGrid.tsx`  
**STATUS:** DUPLICADO  
**MOTIVO:** Duplicata de `apps/portal/components/ApplicationGrid.tsx`.  
**SUBSTITUTO:** `apps/portal/components/ApplicationGrid.tsx`  
**RISCO:** Baixo

**CAMINHO:** `frontend/src/components/portal/PortalHeader.tsx`  
**STATUS:** DUPLICADO  
**MOTIVO:** Versão mais rica existe em `apps/portal/components/PortalHeader.tsx`.  
**SUBSTITUTO:** `apps/portal/components/PortalHeader.tsx`  
**RISCO:** Baixo

**CAMINHO:** `frontend/src/components/layout/DynamicSidebar.tsx`  
**STATUS:** ÓRFÃO  
**MOTIVO:** Nunca importado por rota ativa.  
**SUBSTITUTO:** `apps/operacional/components/Sidebar.tsx`  
**RISCO:** Baixo

**CAMINHO:** `frontend/src/components/guards/RequireContext.tsx`  
**STATUS:** DUPLICADO + CONFLITANTE  
**MOTIVO:** Duplicata de `apps/operacional/security/RequireContext.tsx` e `apps/operacional/security/SecurityGuard.tsx`.  
**SUBSTITUTO:** `apps/operacional/security/RequireContext.tsx`  
**RISCO:** Baixo

---

### 6. HOOKS DUPLICADOS/MORTOS

**CAMINHO:** `frontend/src/hooks/useApp.js`  
**STATUS:** MORTO + IMPORTS QUEBRADOS  
**MOTIVO:** Importa `../context/AppContext` — diretório não existe.  
**DEPENDÊNCIAS:** Nenhuma  
**SUBSTITUTO:** Nenhum (não é necessário)  
**RISCO:** Baixo

**CAMINHO:** `frontend/src/hooks/useAuth.js`  
**STATUS:** DUPLICADO  
**MOTIVO:** Apenas re-export de `useAuth.ts`.  
**DEPENDÊNCIAS:** `hooks/useAuth.ts`  
**SUBSTITUTO:** `hooks/useAuth.ts`  
**RISCO:** Baixo

**CAMINHO:** `frontend/src/hooks/useDispatch.js`  
**STATUS:** DUPLICADO  
**MOTIVO:** Versão não tipada de `useDispatch.ts`.  
**DEPENDÊNCIAS:** Nenhuma direta  
**SUBSTITUTO:** `hooks/useDispatch.ts`  
**RISCO:** Baixo

---

### 7. STORES MORTAS

**CAMINHO:** `frontend/src/shared/stores/auth.store.ts`  
**STATUS:** MORTO  
**MOTIVO:** Usa Zustand. Nunca importado por nenhum componente ou provider.  
**DEPENDÊNCIAS:** Nenhuma  
**SUBSTITUTO:** `app/providers/AuthProvider.tsx` (canônico)  
**RISCO:** Baixo

---

### 8. SERVICES DUPLICADOS/MORTOS

**CAMINHO:** `frontend/src/services/api.ts`  
**STATUS:** BLOQUEADO — ATIVO EM RUNTIME  
**MOTIVO:** Importado por `app/providers/AuthProvider.tsx`, `hooks/useDispatch.ts`, `hooks/useDispatch.js`, `apps/operacional/pages/recepcao/RecepcaoNew.jsx` e `apps/operacional/pages/medico/FilaMedica.tsx`. Não é órfão.  
**DEPENDÊNCIAS:** Ativo na árvore de autenticação e operacional.  
**SUBSTITUTO:** ainda não decidido.  
**RISCO:** Alto — remover sem migração quebra login/refresh e telas operacionais.

**CAMINHO:** `frontend/src/services/FilaService.ts`  
**STATUS:** DUPLICADO + STUB  
**MOTIVO:** Apenas mock stubs. Implementação real em `FilaService.js`.  
**DEPENDÊNCIAS:** Nenhuma  
**SUBSTITUTO:** `services/FilaService.js`  
**RISCO:** Baixo

**CAMINHO:** `frontend/src/services/runtimeService.js`  
**STATUS:** DUPLICADO  
**MOTIVO:** Versão mínima de `runtime.service.js`.  
**SUBSTITUTO:** `services/runtime.service.js`  
**RISCO:** Baixo

**CAMINHO:** `frontend/src/services/index.js`  
**STATUS:** MORTO  
**MOTIVO:** Exporta `AuthService` (arquivo não existe). Barrel file quebrado.  
**DEPENDÊNCIAS:** Nenhuma  
**SUBSTITUTO:** Nenhum  
**RISCO:** Baixo

**CAMINHO:** `frontend/src/api/spApi.ts`  
**STATUS:** DUPLICADO + STUB  
**MOTIVO:** 7 linhas, re-export incompleto.  
**DEPENDÊNCIAS:** Nenhuma  
**SUBSTITUTO:** `api/spApi.js` (canônico)  
**RISCO:** Baixo

---

### 9. CONTEXTOS DUPLICADOS

**CAMINHO:** `frontend/src/apps/contexto/context/ContextProvider.tsx`  
**STATUS:** DUPLICADO  
**MOTIVO:** Provê contexto de unidade/local, mas sobrepõe `app/providers/RuntimeContext.tsx` (canônico).  
**DEPENDÊNCIAS:** Verificar imports em `apps/contexto/`  
**SUBSTITUTO:** `app/providers/RuntimeContext.tsx`  
**RISCO:** Médio — pode ser usado por `ContextSelectionPage.tsx`

**CAMINHO:** `frontend/src/apps/operacional/context/ContextContext.tsx`  
**STATUS:** SHIM MORTO  
**MOTIVO:** Apenas re-exporta `RuntimeContext.tsx`. Não agrega valor.  
**DEPENDÊNCIAS:** `apps/operacional/security/RequireContext.tsx`, `SecurityGuard.tsx`  
**SUBSTITUTO:** `app/providers/RuntimeContext.tsx`  
**RISCO:** Baixo

---

### 10. ROTAS DUPLICADAS

**CAMINHO:** `frontend/src/apps/portal/routes/portal.routes.tsx`  
**STATUS:** ÓRFÃO  
**MOTIVO:** Arquivo de rotas legado (RouteObject array). Não importado por nenhuma rota ativa.  
**DEPENDÊNCIAS:** Nenhuma  
**SUBSTITUTO:** `apps/portal/routes/PortalRoutes.tsx` (canônico)  
**RISCO:** Baixo

---

### 11. PAGES ÓRFÃAS

**CAMINHO:** `frontend/src/apps/portal/pages/HomePage.tsx`  
**STATUS:** ÓRFÃO, MAS IMPORT CORRIGIDO  
**MOTIVO:** Não está em nenhuma rota. O import `@/services/api/dispatcher` foi corrigido movendo o dispatcher para `frontend/src/services/api/dispatcher.ts` e adicionando alias explícito.  
**DEPENDÊNCIAS:** `frontend/src/services/api/dispatcher.ts` ativo via HomePage.  
**SUBSTITUTO:** `apps/portal/pages/PortalHomePage.tsx`  
**RISCO:** Baixo para remoção como página, mas não remover `services/api/dispatcher.ts` enquanto HomePage existir.

---

## ARQUIVOS PARA EXCLUSÃO — BACKEND

### 12. DIRETÓRIO `core/` INTEIRO (11 arquivos)

**CAMINHO:** `backend/core/`  
**STATUS:** DUPLICADO MORTO  
**MOTIVO:** Cópia idêntica de `backend/src/kernel/`, mas com caminhos relativos quebrados (apontam para `backend/config/` que não existe). Nunca importado.  
**DEPENDÊNCIAS:** Nenhuma  
**SUBSTITUTO:** `backend/src/kernel/` (canônico)  
**RISCO:** Baixo

ARQUIVOS:
```
backend/core/auth_guardian_assert.js
backend/core/auth_login_service.js
backend/core/auth_password_hash.js
backend/core/auth_runtime_dispatcher.js
backend/core/auth_session_validator.js
backend/core/authz_client.js
backend/core/dispatcher_gateway.js
backend/core/kernel_auth_config.js
backend/core/ledger_client.js
backend/core/runtime_worker_processor.js
backend/core/worker_runner.js
```

---

### 13. CONTROLLERS MORTOS

**CAMINHO:** `backend/src/controllers/auth/loginController.js`  
**STATUS:** MORTO  
**MOTIVO:** Usa `req.app.locals.db` que nunca é setado no código. Não importado por nenhuma rota ativa.  
**DEPENDÊNCIAS:** Nenhuma  
**SUBSTITUTO:** `backend/src/auth/authController.js` (canônico)  
**RISCO:** Baixo

---

### 14. BACKUPS/LEGACY

**CAMINHO:** `backend/src/auth/authController_bkp.js`  
**STATUS:** MORTO  
**MOTIVO:** Arquivo de backup não importado.  
**DEPENDÊNCIAS:** Nenhuma  
**SUBSTITUTO:** `backend/src/auth/authController.js`  
**RISCO:** Baixo

---

### 15. ROUTES CONFLITANTES

**CAMINHO:** `backend/src/routes/authRoutes.js`  
**STATUS:** CONFLITO  
**MOTIVO:** Criado recentemente, conflita com `backend/src/auth/authRoutes.js` (montado em `app.js`).  
**DEPENDÊNCIAS:** Nenhuma (não importado)  
**SUBSTITUTO:** `backend/src/auth/authRoutes.js`  
**RISCO:** Baixo

---

### 16. MIDDLEWARE LEGACY (CONDICIONAL)

**CAMINHO:** `backend/src/middlewares/authMiddleware.js`  
**STATUS:** LEGACY  
**MOTIVO:** 18 linhas, JWT simples. Usado apenas por `routes/fila.js`. Se `fila.js` for removido, este também pode ser removido.  
**DEPENDÊNCIAS:** `backend/src/routes/fila.js`  
**SUBSTITUTO:** `backend/src/auth/authMiddleware.js` (canônico, 168 linhas)  
**RISCO:** Baixo (condicional)

---

## RESUMO

### Frontend — Resumo pré-Fase 11A

O relatório anterior listava 53 arquivos frontend para exclusão. Esse número está desatualizado para consolidação destrutiva porque a Fase 11A encontrou dependências reais de runtime.

### Frontend — Bloqueios críticos pós-Fase 11A

- Pasta `features/`: não remover. `features/atendimento/AppOperacional.tsx` é ativo via `App.tsx` e `main.tsx`.
- `frontend/src/services/api.ts`: não remover. Ativo via `AuthProvider`, hooks e páginas operacionais.
- `frontend/src/apps/operacional/services/api.ts`: não remover sem decisão de migração. Ativo via portal, contexto, painel e `spApi`.
- `frontend/src/api/api.js`: não remover sem decisão de migração. Ativo via services legados.
- `frontend/src/services/api/dispatcher.ts`: não remover. Ativo via `HomePage.tsx`.

### Backend — Arquivos para exclusão

- Diretório `core/`: 11 arquivos
- Controllers mortos: 1 arquivo
- Backups/legacy: 1 arquivo
- Routes conflitantes: 1 arquivo
- Middleware legacy (condicional): 1 arquivo

**Total backend: 14 arquivos (15 com middleware condicional)**

**TOTAL GERAL PARA FASE 12:** 0 frontend removível até nova decisão de canonicidade + backend pendente de nova validação.

---

## BLOQUEIOS ATIVOS (não remover)

```
frontend/src/app/providers/AuthProvider.tsx
frontend/src/app/providers/index.ts
frontend/src/app/providers/RuntimeContext.tsx
frontend/src/app/providers/TenantProvider.tsx
frontend/src/app/providers/types.ts
frontend/src/apps/contexto/pages/ContextSelectionPage.tsx
frontend/src/apps/operacional/security/RequireContext.tsx
frontend/src/apps/operacional/security/SecurityGuard.tsx
frontend/src/apps/operacional/services/api.ts
frontend/src/apps/portal/layouts/PortalLayout.tsx
frontend/src/apps/portal/pages/IntegracoesPage.tsx
frontend/src/apps/portal/pages/IntranetPage.tsx
frontend/src/apps/portal/pages/ManagementDashboardPage.tsx
frontend/src/apps/portal/pages/PortalHomePage.tsx
frontend/src/apps/portal/portal.css
frontend/src/apps/portal/routes/PortalRoutes.tsx
frontend/src/api/api.js
frontend/src/features/
frontend/src/main.tsx
frontend/src/services/api.ts
frontend/src/services/api/dispatcher.ts
frontend/src/shell/Footer.tsx
frontend/src/themes/globals.css
frontend/src/themes/variables.css
```

**Total bloqueados:** 24 entradas/arquivos (incluindo `frontend/src/features/` como pasta)

---

## PRÓXIMA ETAPA

Após a Fase 11A:
1. Decidir canônico de API entre `frontend/src/services/api.ts`, `frontend/src/apps/operacional/services/api.ts`, `frontend/src/api/api.js` e `frontend/src/services/api/dispatcher.ts`.
2. Decidir canônico operacional entre `frontend/src/features/atendimento/AppOperacional.tsx` e `frontend/src/apps/operacional/AppOperacional.jsx`.
3. Migrar importadores para o canônico escolhido antes de remover duplicatas.
4. Só então reabrir a FASE 12 — Consolidação física.

FIM DO BACKUP PRÉ-CONSOLIDAÇÃO

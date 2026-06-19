# MATRIZ_IMPORTADORES_REAIS.md
**Data:** 2026-06-17  
**Fase:** 11A — Validação de Runtime  
**Conclusão:** Fase 12 permanece bloqueada.

---

## 1. Entry point real

| ARQUIVO | IMPORTADO POR | STATUS |
|---|---|---|
| `frontend/index.html` | Vite | ENTRY HTML |
| `frontend/src/main.tsx` | `frontend/index.html` linha 14 | ENTRY TSX REAL |
| `frontend/src/App.tsx` | `frontend/src/main.tsx` linha 44 | ROOT APP REAL |
| `frontend/src/main.tsx` | não importado por outro módulo | contém `ReactDOM.createRoot(...)` |

Conclusão: o runtime atual monta `main.tsx`, que renderiza `App.tsx`.

---

## 2. AppOperacional real

| ARQUIVO | IMPORTADO POR | STATUS |
|---|---|---|
| `frontend/src/features/atendimento/AppOperacional.tsx` | `frontend/src/App.tsx` linha 10; `frontend/src/main.tsx` linha 13 | ATIVO |
| `frontend/src/apps/operacional/AppOperacional.jsx` | nenhum importador encontrado | INATIVO |
| `frontend/src_legacy/apps/operacional/AppOperacional.tsx` | nenhum importador encontrado | LEGACY INATIVO |

Conclusão: `features/atendimento/AppOperacional.tsx` está na árvore React. A pasta `features/` não pode ser removida sem quebrar `/operacional/*`.

---

## 3. LoginPage real

| ARQUIVO | IMPORTADO POR | STATUS |
|---|---|---|
| `frontend/src/apps/portal/pages/login/LoginPage.tsx` | `frontend/src/App.tsx` linha 7; `frontend/src/main.tsx` linha 10 | LOGIN REAL |
| `frontend/src/apps/auth/pages/LoginPage.tsx` | nenhum importador encontrado | INATIVO |
| `frontend/src/pages/auth/LoginPage.tsx` | nenhum importador encontrado | INATIVO |

Conclusão: o login ativo é `apps/portal/pages/login/LoginPage.tsx`.

---

## 4. PortalRoutes real

| ARQUIVO | IMPORTADO POR | STATUS |
|---|---|---|
| `frontend/src/apps/portal/routes/PortalRoutes.tsx` | `frontend/src/App.tsx` linha 8; `frontend/src/main.tsx` linha 11 | ROTAS PORTAL REAIS |
| `frontend/src/apps/portal/routes/portal.routes.tsx` | nenhum importador encontrado | INATIVO |

Conclusão: as rotas ativas do portal estão em `apps/portal/routes/PortalRoutes.tsx`.

---

## 5. API real

### 5.1 Comparação dos módulos API

| ARQUIVO | baseURL | Headers | Auth | Interceptor response | Timeout | Wrappers | STATUS |
|---|---|---|---|---|---|---|---|
| `frontend/src/services/api.ts` | `/api` | `Content-Type: application/json` | `accessToken` em memória via `setAccessToken` | não possui | não possui | `callSP`, `api`, default | ATIVO |
| `frontend/src/apps/operacional/services/api.ts` | `/api` | `Content-Type: application/json` | `accessToken` em memória via `setAccessToken` | não possui | não possui | `callSP`, `api`, default | ATIVO |
| `frontend/src/api/api.js` | `/api` | `Content-Type: application/json` | `localStorage.token_his` | trata 401/TOKEN_EXPIRADO e redireciona `/login` | não possui | `apiGet`, `apiPost`, `apiPut`, `apiDelete`, default | ATIVO |
| `frontend/src/services/api/dispatcher.ts` | `/api` | `Content-Type: application/json` | `accessToken` em memória via `setAccessToken` | não possui | não possui | `dispatcher`, default | ATIVO |

### 5.2 Importadores reais

| ARQUIVO | IMPORTADO POR | STATUS |
|---|---|---|
| `frontend/src/services/api.ts` | `frontend/src/app/providers/AuthProvider.tsx`; `frontend/src/hooks/useDispatch.ts`; `frontend/src/hooks/useDispatch.js`; `frontend/src/apps/operacional/pages/recepcao/RecepcaoNew.jsx`; `frontend/src/apps/operacional/pages/medico/FilaMedica.tsx` | ATIVO |
| `frontend/src/apps/operacional/services/api.ts` | `frontend/src/apps/portal/services/portalService.ts`; `frontend/src/apps/painel/pages/PainelUsuario.tsx`; `frontend/src/apps/contexto/context/ContextProvider.tsx`; `frontend/src/api/spApi.ts` | ATIVO |
| `frontend/src/api/api.js` | `frontend/src/services/sessionService.js`; `frontend/src/services/runtimeService.js`; `frontend/src/services/loginService.js`; `frontend/src/services/PacienteService.js` | ATIVO |
| `frontend/src/services/api/dispatcher.ts` | `frontend/src/apps/portal/pages/HomePage.tsx` | ATIVO |
| `frontend/services/api/dispatcher.ts` | nenhum importador; conteúdo movido para `frontend/src/services/api/dispatcher.ts` | LEGACY MOVIDO |

Conclusão: não existe hoje um único canônico seguro para remover os demais. Todos os quatro módulos API listados acima têm importadores ou função de runtime.

---

## 6. Aliases Vite + TypeScript

| ALIAS | SITUAÇÃO ANTERIOR | SITUAÇÃO ATUAL | STATUS |
|---|---|---|---|
| `@` | `frontend/src` | `frontend/src` | OK |
| `@/apps/*` | `frontend/src/apps/*` | `frontend/src/apps/*` | OK |
| `@/app/*` | `frontend/src/app/*` | `frontend/src/app/*` | OK |
| `@/services/*` | `frontend/src/services/*` | `frontend/src/services/*` | OK |
| `@/services/api` | resolvido por `@/services/*` | explícito para `frontend/src/services/api.ts` | OK |
| `@/services/api/dispatcher` | inexistente; importava `frontend/src/services/api/dispatcher`, que não existia | explícito para `frontend/src/services/api/dispatcher.ts` | CORRIGIDO |
| `@/shell/*` | `frontend/shell/*` | `frontend/src/shell/*` | CORRIGIDO |
| `@/providers/*` | `frontend/providers/*` | `frontend/src/app/providers/*` | CORRIGIDO |
| `@/stores/*` | `frontend/stores/*` | `frontend/src/shared/stores/*` | CORRIGIDO |
| `@/assets/*` | `frontend/assets/*` | `frontend/src/assets/*` | CORRIGIDO |
| `@/themes/*` | `frontend/themes/*` | `frontend/src/themes/*` | CORRIGIDO |
| `@/context/*` | `frontend/src/context/*`, inexistente | removido | SEM IMPORTADORES |
| `@/routes/*` | `frontend/routes/*`, inexistente | removido | SEM IMPORTADORES |
| `@/config/*` | `frontend/config/*`, inexistente | removido | SEM IMPORTADORES |
| `@/constants/*` | `frontend/constants/*`, inexistente | removido | SEM IMPORTADORES |

---

## 7. Validação executada

| COMANDO | RESULTADO |
|---|---|
| `npm run build` | PASSOU |
| `npm run lint` | FALHOU com erros existentes em páginas operacionais: `Estoque.jsx`, `Internacao.jsx`, `Laboratorio.jsx`, `TriagemNew.jsx` |
| `npx tsc --noEmit` | FALHOU com erros TypeScript existentes espalhados por providers, apps, features e tipos |

---

## 8. Bloqueio da Fase 12

A Fase 12 não deve ser executada até que uma nova decisão documente:

1. Qual módulo API será canônico entre:
   - `frontend/src/services/api.ts`
   - `frontend/src/apps/operacional/services/api.ts`
   - `frontend/src/api/api.js`
   - `frontend/src/services/api/dispatcher.ts`

2. Qual árvore operacional será canônica:
   - `frontend/src/features/atendimento/AppOperacional.tsx`
   - `frontend/src/apps/operacional/AppOperacional.jsx`

3. Como a pasta `features/` será migrada, substituída ou removida sem quebrar `/operacional/*`.

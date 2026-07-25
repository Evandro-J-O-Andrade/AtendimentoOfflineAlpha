# Mapa de Rastreabilidade — Frontend → Backend → Dispatcher → SP

**Data:** 2026-07-25  
**Marco:** Ciclo 2 — Governança + Integração Kernel  
**Fonte primária:** código frontend + backend + bancoMysql.md  
**Documento canônico:** [MD-000 — Constituição Arquitetural da Plataforma Enterprise](canonical/MD-000-Constituicao-Arquitetural.md)

> **Nota:** Este documento é derivado do MD-000. Em caso de conflito, o MD-000 prevalece.

---

## ⚠️ Achados Críticos

### Achado 1 — Backend tem rotas paralelas ao Dispatcher

O backend expõe rotas legacy (`/auth/*`, `/portal/*`, `/contexto/*`, `/eventos/*`, `/auditoria/*`, `/integracoes/*`) que chamam SPs diretamente, sem passar pelo `sp_master_dispatcher`.

Ele tem dois padrões paralelos:

| Padrão | Rotas | Fluxo |
|--------|-------|-------|
| **Legacy** | `/auth/*`, `/portal/*`, `/contexto/*`, `/eventos/*`, `/auditoria/*`, `/integracoes/*` | Controller → Service → SP direto |
| **Dispatcher** | `/dispatcher/*` | Controller → DispatcherService → `sp_master_dispatcher` |

**Total:** 14 endpoints bypassam o Dispatcher. Apenas 1 (`POST /dispatcher`) usa o Dispatcher.

### Achado 2 — Inconsistência Crítica: Backend vs Banco

O backend chama `sp_master_dispatcher` com uma assinatura que **não bate** com a definição no banco:

| Parâmetro SP | Valor do Backend | Tipo Esperado | Tipo Recebido |
|-------------|------------------|---------------|---------------|
| `p_id_sessao` | `request.modulo` (string) | BIGINT | STRING ❌ |
| `p_uuid_transacao` | `request.acao` (string) | CHAR(36) | STRING ❌ |
| `p_dominio` | `JSON.stringify(request.payload)` (string JSON) | VARCHAR(50) | JSON STRING ❌ |
| `p_acao` | `request.id_sessao` (number) | VARCHAR(100) | NUMBER ❌ |
| `p_id_referencia` | `@p_resultado` (OUT) | BIGINT | VARIÁVEL OUT ❌ |
| `p_payload` | `@p_sucesso` (OUT) | JSON | VARIÁVEL OUT ❌ |

**Faltam:** `p_uuid_transacao` (CHAR), `@p_mensagem` (OUT)

**Classificação:** 🚨 BUG CRÍTICO

### Achado 3 — sp_master_orquestradora existe mas não é chamada

O banco tem `sp_master_orquestradora`, o orquestrador de alto nível que dispatcha para SPs específicas por módulo (LOGIN, ASSISTENCIAL, ESTOQUE, FATURAMENTO, QUERIES). O backend **nunca** a chama.

---

## 1. Mapa Completo de Rastreabilidade

### 1.1 Login / Auth

| # | Origem (React) | Arquivo/Função | Gateway/Endpoint | Controller | Service | Dispatcher? | SP | Status |
|---|---|---|---|---|---|---|---|---|
| 1 | `LoginPageInner.handleSubmit` | `apps/portal/src/pages/Login/LoginPage.tsx:48` | `POST /auth/login` | `authRouter.post('/login')` | `AuthService.authenticate()` | ❌ Não | `sp_master_login` | ❌ BYPASS |
| 2 | `AuthProvider.refresh` | `packages/auth/src/AuthProvider.tsx:73` | `POST /auth/refresh` | `authRouter.post('/refresh')` | ❌ Não implementado | ❌ Não | ❌ Não existe | ❌ 501 |
| 3 | `AuthProvider.logout` | `packages/auth/src/AuthProvider.tsx:83` | `POST /auth/logout` | `authRouter.post('/logout')` | ❌ Apenas 204 | ❌ Não | ❌ Não | ⚠️ BYPASS |
| 4 | `resolveSession` | `packages/auth/src/SessionResolver.ts` | `GET /auth/session/:id` | `authRouter.get('/session/:idSessao')` | `AuthService.session()` | ❌ Não | `sp_sessao_contexto_get` | ⚠️ BYPASS |
| 5 | `AuthProvider.selectContext` | `packages/auth/src/AuthProvider.tsx:88` | `POST /auth/context/select` | `authRouter.post('/context/select')` | `AuthService.selectContext()` | ❌ Não | `sp_auth_contexto_set` | ⚠️ BYPASS |

### 1.2 Context

| # | Origem (React) | Arquivo/Função | Gateway/Endpoint | Controller | Service | Dispatcher? | SP | Status |
|---|---|---|---|---|---|---|---|---|
| 6 | `ContextSelectionPage` | `apps/portal/src/pages/Context/ContextSelectionPage.tsx:37` | `GET /auth/context/:id` (fetch direto) | `authRouter.get('/context/:idSessao')` | `AuthService.context()` | ❌ Não | `sp_auth_contexto_get` | ❌ BYPASS + fetch direto |

### 1.3 Portal Runtime

| # | Origem (React) | Arquivo/Função | Gateway/Endpoint | Controller | Service | Dispatcher? | SP | Status |
|---|---|---|---|---|---|---|---|---|
| 7 | `PortalRuntimeComposer` | `apps/portal/src/app/providers.tsx:128` | `POST /dispatcher` | `dispatcherRouter.post('/')` | `DispatcherService.dispatch()` | ✅ Sim | `sp_master_dispatcher` | ✅ CONFORME |
| 8 | `PortalRuntimeComposer` (fallback) | `apps/portal/src/app/providers.tsx:95` | N/A (compose local) | N/A | N/A | N/A | N/A | ⚠️ Fallback local |

### 1.4 Portal API (não utilizada no fluxo principal)

| # | Origem (React) | Arquivo/Função | Gateway/Endpoint | Controller | Service | Dispatcher? | SP | Status |
|---|---|---|---|---|---|---|---|---|
| 9 | `PortalApi.runtime` | `packages/api/src/portal/PortalApi.ts:17` | `GET /portal/runtime/:id` | `portalRouter.get('/runtime/:id')` | `PortalService.runtime()` | ❌ Não | ❌ Não mapeado | ⚠️ BYPASS |
| 10 | `PortalApi.permissions` | `packages/api/src/portal/PortalApi.ts:20` | `GET /portal/permissions/:id` | `portalRouter.get('/permissions/:id')` | `PortalService.permissions()` | ❌ Não | `sp_auth_permissions_evaluate` | ⚠️ BYPASS |
| 11 | `PortalApi.navigation` | `packages/api/src/portal/PortalApi.ts:24` | `GET /portal/navigation/:id` | `portalRouter.get('/navigation/:id')` | `PortalService.navigation()` | ❌ Não | `sp_auth_menu_get` | ⚠️ BYPASS |
| 12 | `PortalApi.applications` | `packages/api/src/portal/PortalApi.ts:28` | `GET /portal/applications/:id` | `portalRouter.get('/applications/:id')` | `PortalService.applications()` | ❌ Não | Derivado de navigation | ⚠️ BYPASS |
| 13 | `PortalApi.branding` | `packages/api/src/portal/PortalApi.ts:31` | `GET /portal/branding` | `portalRouter.get('/branding')` | `PortalService.branding()` | ❌ Não | ❌ Hardcoded | ⚠️ BYPASS |
| 14 | `PortalApi.dashboard` | `packages/api/src/portal/PortalApi.ts:35` | `GET /portal/dashboard/:id` | `portalRouter.get('/dashboard/:id')` | `PortalService.dashboard()` | ❌ Não | ❌ Hardcoded | ⚠️ BYPASS |
| 15 | `PortalApi.widgets` | `packages/api/src/portal/PortalApi.ts:38` | `GET /portal/widgets/:id` | `portalRouter.get('/widgets/:id')` | `PortalService.widgets()` | ❌ Não | ❌ Retorna [] | ⚠️ BYPASS |
| 16 | `PortalApi.notifications` | `packages/api/src/portal/PortalApi.ts:42` | `GET /portal/notifications/:id` | `portalRouter.get('/notifications/:id')` | `PortalService.notifications()` | ❌ Não | ❌ Retorna [] | ⚠️ BYPASS |

---

## 2. Chamadas que Bypassam o Dispatcher

### 2.1 Lista Completa

| # | Endpoint | Método | Arquivo | Função | Problema |
|---|----------|--------|---------|--------|----------|
| 1 | `/auth/login` | POST | `AuthProvider.tsx` | `login()` | Chama authApi diretamente |
| 2 | `/auth/session/:id` | GET | `SessionResolver.ts` | `resolveSession()` | Chama api diretamente |
| 3 | `/auth/refresh` | POST | `AuthProvider.tsx` | `refresh()` | Chama authApi diretamente |
| 4 | `/auth/logout` | POST | `AuthProvider.tsx` | `logout()` | Chama authApi diretamente |
| 5 | `/auth/context/:id` | GET | `ContextSelectionPage.tsx` | `useEffect` | fetch direto |
| 6 | `/auth/context/select` | POST | `AuthProvider.tsx` | `selectContext()` | Chama authApi diretamente |
| 7 | `/portal/runtime/:id` | GET | `PortalApi.ts` | `runtime()` | Chama api diretamente |
| 8 | `/portal/permissions/:id` | GET | `PortalApi.ts` | `permissions()` | Chama api diretamente |
| 9 | `/portal/navigation/:id` | GET | `PortalApi.ts` | `navigation()` | Chama api diretamente |
| 10 | `/portal/applications/:id` | GET | `PortalApi.ts` | `applications()` | Chama api diretamente |
| 11 | `/portal/branding` | GET | `PortalApi.ts` | `branding()` | Chama api diretamente |
| 12 | `/portal/dashboard/:id` | GET | `PortalApi.ts` | `dashboard()` | Chama api diretamente |
| 13 | `/portal/widgets/:id` | GET | `PortalApi.ts` | `widgets()` | Chama api diretamente |
| 14 | `/portal/notifications/:id` | GET | `PortalApi.ts` | `notifications()` | Chama api diretamente |

**Total:** 14 endpoints bypassam o Dispatcher. Apenas 1 (`POST /dispatcher`) usa o Dispatcher.

### 2.2 Classificação

| Tipo | Quantidade | Endpoints |
|------|------------|-----------|
| Auth | 6 | `/auth/login`, `/auth/session`, `/auth/refresh`, `/auth/logout`, `/auth/context`, `/auth/context/select` |
| Portal | 8 | `/portal/runtime`, `/portal/permissions`, `/portal/navigation`, `/portal/applications`, `/portal/branding`, `/portal/dashboard`, `/portal/widgets`, `/portal/notifications` |

---

## 2. Arquitetura Real do Banco de Dados

### 2.1 Camada Master (Orquestradores)

| SP | Assinatura | Função | Chamada no Backend |
|----|-----------|--------|-------------------|
| `sp_master_orquestradora` | `(p_id_sessao, p_modulo, p_acao, p_payload)` | Orquestrador de alto nível. Dispatch por módulo: LOGIN → sp_master_login, ASSISTENCIAL → sp_master_assistencial, ESTOQUE → sp_master_estoque, FATURAMENTO → sp_master_faturamento, PACIENTE/TRIAGEM/FILA → sp_master_query_dispatcher | ❌ **NÃO CHAMADA** |
| `sp_master_dispatcher` | `(p_id_sessao, p_uuid_transacao, p_dominio, p_acao, p_id_referencia, p_payload)` | Dispatcher de baixo nível. Resolve executor na tabela `permissao` por `codigo = CONCAT(UPPER(p_dominio), '.', UPPER(p_acao))`. Executa dinamicamente `sp_executor_*` via PREPARE/EXECUTE. | ⚠️ Chamada com assinatura ERRADA |

### 2.2 SPs Mestre por Domínio

| SP | Domínio | Assinatura |
|----|---------|-----------|
| `sp_master_login` | Auth | `(p_acao, p_payload, OUT p_resultado, OUT p_sucesso, OUT p_mensagem)` |
| `sp_master_assistencial` | Assistencial | Chama executores específicos |
| `sp_master_estoque` | Estoque | Chama executores específicos |
| `sp_master_faturamento` | Faturamento | Chama executores específicos |
| `sp_master_query_dispatcher` | Queries | Resolve queries por domínio |
| `sp_master_paciente` | Paciente | `(p_id_sessao, p_id_usuario, p_payload, OUT p_resultado)` |
| `sp_master_ffa_movimentar` | Workflow | `(p_id_sessao, p_id_usuario, p_id_ffa, p_novo_status, OUT p_resultado)` |

### 2.3 SPs de Infraestrutura

| SP | Função |
|----|--------|
| `sp_master_registrar_evento` | Ledger de eventos |
| `sp_master_registrar_alerta` | Alertas |
| `sp_master_registrar_erro` | Log de erros |
| `sp_master_routes` | Rotas/navegação |
| `sp_sessao_assert` | Validação de sessão |

### 2.4 Inconsistência Crítica: Backend vs Banco

**O backend chama `sp_master_dispatcher` com assinatura ERRADA:**

```javascript
// DispatcherService.ts (backend)
'CALL sp_master_dispatcher(?, ?, ?, ?, @p_resultado, @p_sucesso, @p_mensagem)',
[request.modulo, request.acao, JSON.stringify(request.payload), request.id_sessao]
```

**Mas a SP no banco espera:**

```sql
CREATE PROCEDURE `sp_master_dispatcher`(
    IN p_id_sessao BIGINT,
    IN p_uuid_transacao CHAR(36),
    IN p_dominio VARCHAR(50),
    IN p_acao VARCHAR(100),
    IN p_id_referencia BIGINT,
    IN p_payload JSON
)
```

**Mapeamento errado:**
| Parâmetro SP | Valor do Backend | Tipo Esperado | Tipo Recebido |
|-------------|------------------|---------------|---------------|
| `p_id_sessao` | `request.modulo` (string) | BIGINT | STRING ❌ |
| `p_uuid_transacao` | `request.acao` (string) | CHAR(36) | STRING ❌ |
| `p_dominio` | `JSON.stringify(request.payload)` (string JSON) | VARCHAR(50) | JSON STRING ❌ |
| `p_acao` | `request.id_sessao` (number) | VARCHAR(100) | NUMBER ❌ |
| `p_id_referencia` | `@p_resultado` (OUT) | BIGINT | VARIÁVEL OUT ❌ |
| `p_payload` | `@p_sucesso` (OUT) | JSON | VARIÁVEL OUT ❌ |

**Faltam:** `p_uuid_transacao` (CHAR), `@p_mensagem` (OUT)

**Classificação:** 🚨 BUG CRÍTICO — O backend está usando uma assinatura desatualizada ou a SP foi alterada sem atualizar o backend.

### 2.5 SPs de Executores (Identificadas na tabela permissao)

A `sp_master_dispatcher` resolve executores na tabela `permissao`:
- Formato do código: `CONCAT(UPPER(p_dominio), '.', UPPER(p_acao))`
- Filtro: `nome_procedure LIKE 'sp_executor_%'`
- Execução dinâmica via `PREPARE`/`EXECUTE`

Exemplos esperados:
- `ASSISTENCIAL.ATENDIMENTO` → `sp_executor_assistencial_atendimento`
- `ESTOQUE.MOVIMENTAR` → `sp_executor_estoque_movimentar`
- `FATURAMENTO.FATURAR` → `sp_executor_faturamento_faturar`

---

---

## 4. Gaps na Cadeia

### 4.1 Gap 1 — Backend chama sp_master_dispatcher com assinatura errada (BUG CRÍTICO)

**Problema:** `DispatcherService.ts` chama `sp_master_dispatcher` com 4 parâmetros, mas a SP no banco espera 6 parâmetros com tipos completamente diferentes.

**Causa raiz:** O backend está desatualizado em relação à definição da SP no banco.

**Impacto:**
- Chamada provavelmente falha em tempo de execução
- Dados corrompidos (strings no lugar de números, JSON no lugar de domínio)
- Auditoria inconsistente

**Classificação:** 🚨 BUG CRÍTICO (backend)

**Correção:** Atualizar `DispatcherService.ts` para assinatura correta.

---

### 4.2 Gap 2 — sp_master_orquestradora existe mas não é chamada

**Problema:** O banco tem `sp_master_orquestradora`, mas o backend nunca a chama.

**Causa raiz:** O backend foi implementado para chamar apenas `sp_master_dispatcher`, ignorando o orquestrador de alto nível.

**Impacto:**
- Orquestração por módulo não funciona
- SPs como `sp_master_assistencial`, `sp_master_estoque`, `sp_master_faturamento` são ignoradas
- Frontend não consegue usar módulos específicos

**Classificação:** ADAPT (backend)

---

### 4.3 Gap 3 — Backend tem rotas paralelas ao Dispatcher

**Problema:** O backend expõe rotas legacy (`/auth/*`, `/portal/*`) que chamam SPs diretamente, sem passar pelo `sp_master_dispatcher`.

**Causa raiz:** O backend foi implementado com arquitetura de endpoints específicos (Controller → Service → SP), não como fachada do Dispatcher.

**Impacto:**
- Frontend conhece endpoints específicos
- Não há orquestração centralizada
- Viola a arquitetura "Dispatcher como único ponto de entrada"

**Classificação:** ADAPT (backend) + ADAPT (frontend)

---

### 4.4 Gap 4 — Frontend consome APIs específicas

**Problema:** Frontend chama `/auth/*` e `/portal/*` diretamente, em vez de usar apenas `/dispatcher`.

**Causa raiz:** Backend expõe essas rotas, e frontend as consome diretamente.

**Impacto:**
- Frontend conhece estrutura de endpoints
- Não há contrato único de comunicação

**Classificação:** ADAPT (frontend) — depende do Gap 3

---

### 4.5 Gap 5 — ContextSelection com fetch direto

**Problema:** `ContextSelectionPage` usa `fetch('/auth/context/:id')` diretamente.

**Causa raiz:** Falta de integração entre AuthProvider e Dispatcher.

**Impacto:**
- Bypassa validação de sessão
- Frontend conhece estrutura de URL

**Classificação:** ADAPT (frontend)

---

### 4.6 Gap 6 — Session não persistente

**Problema:** Session armazenada em `useState`, perdida ao reload.

**Causa raiz:** Backend não envia HttpOnly Cookie. Frontend não persiste session.

**Impacto:**
- Usuário precisa fazer login novamente
- Sem refresh automático

**Classificação:** PROPOSE (backend) + PROPOSE (frontend)

---

### 4.7 Gap 7 — Refresh não implementado

**Problema:** `POST /auth/refresh` retorna 501.

**Causa raiz:** Backend não implementou refresh. Frontend não chama automaticamente.

**Impacto:**
- Sem renovação de sessão
- Logout forçado após expiração

**Classificação:** PROPOSE (backend) + PROPOSE (frontend)

---

### 4.8 Gap 8 — Código morto arquitetural

**Problema:** Arquivos criados como parte da arquitetura, mas não integrados.

**Lista:**
- `SessionStore.ts` — não usado pelo `AuthProvider`
- `WorkflowEngine.ts` — não usado
- `UiStateManager.ts` — não usado
- `EventClient.ts` — não usado
- `KernelIntegration.ts` — não importado
- `FetchHttpClient.ts` — não usado
- `useDispatcher.ts` — não usado
- `useDomainNavigation.ts` — não usado

**Classificação:** DORMANT INFRASTRUCTURE (manter para futura integração)

---

## 5. Plano de Correção Priorizado

### Fase 1 — Corrigir Bug Crítico do Dispatcher (URGENTE)

**Objetivo:** Corrigir a assinatura da chamada `sp_master_dispatcher` no backend.

**Passos:**
1. Atualizar `DispatcherService.ts` para usar a assinatura correta:
   - `p_id_sessao` (BIGINT)
   - `p_uuid_transacao` (CHAR36)
   - `p_dominio` (VARCHAR)
   - `p_acao` (VARCHAR)
   - `p_id_referencia` (BIGINT)
   - `p_payload` (JSON)
2. Verificar se `request.modulo` deve mapear para `p_dominio`
3. Verificar se `request.acao` deve mapear para `p_acao`
4. Gerar `p_uuid_transacao` se não fornecido
5. Testar a chamada com dados reais

**Arquivos:**
- Backend: `backend/src/core/dispatcher/DispatcherService.ts`
- Backend: `backend/src/core/dispatcher/DispatcherController.ts`

**Classificação:** 🚨 BUG CRÍTICO

---

### Fase 2 — Integrar sp_master_orquestradora

**Objetivo:** Backend deve usar o orquestrador de alto nível para módulos específicos.

**Passos:**
1. Implementar rota `/orchestrator` no backend
2. Implementar `OrchestratorService` que chama `sp_master_orquestradora`
3. Mapear fluxos:
   - LOGIN → `sp_master_login`
   - ASSISTENCIAL → `sp_master_assistencial`
   - ESTOQUE → `sp_master_estoque`
   - FATURAMENTO → `sp_master_faturamento`
   - QUERIES → `sp_master_query_dispatcher`

**Resultado esperado:**
```
Frontend → Backend → sp_master_orquestradora → sp_master_* → sp_executor_*
```

**Arquivos:**
- Backend: `backend/src/core/orchestrator/`
- Banco: `sp_master_orquestradora` já existe

**Classificação:** ADAPT (backend)

---

### Fase 3 — Unificar Backend via Dispatcher/Orchestrator (ADAPT backend)

**Objetivo:** Rotas legacy (`/auth/*`, `/portal/*`) se tornam fachadas do Dispatcher/Orchestrator.

**Passos:**
1. Modificar `AuthService` para usar `DispatcherService` ou `OrchestratorService`
2. Modificar `PortalService` para usar `DispatcherService` ou `OrchestratorService`
3. Modificar `ContextService` para usar `DispatcherService` ou `OrchestratorService`

**Resultado esperado:**
```
POST /auth/login
    ↓
AuthController
    ↓
OrchestratorService
    ↓
sp_master_orquestradora
    ↓
sp_master_login
```

**Arquivos:**
- Backend: `backend/src/core/auth/AuthService.ts`, `backend/src/core/portal/PortalService.ts`, `backend/src/core/contexto/ContextService.ts`

---

### Fase 4 — Migrar Frontend para Dispatcher (ADAPT frontend)

**Objetivo:** Frontend chama apenas endpoints do Dispatcher/Orchestrator.

**Passos:**
1. Substituir `AuthApi` por `DispatcherClient`
2. Substituir `PortalApi` por `DispatcherClient`
3. Remover `fetch` direto de `ContextSelectionPage`
4. Integrar `SessionStore`, `WorkflowEngine`, `EventClient`

**Arquivos:**
- Frontend: `AuthProvider.tsx`, `ContextSelectionPage.tsx`, `PortalRuntimeComposer`
- Remover: `AuthApi.ts`, `PortalApi.ts` (após migração)

---

### Fase 5 — Fechar Validação do Login

**Objetivo:** Fazer o login funcionar completamente, incluindo MFA e persistência.

**Passos:**
1. Implementar `POST /auth/refresh` no backend
2. Implementar HttpOnly Cookie para session
3. Adicionar refresh automático no frontend
4. Fechar fluxo MFA real (endpoint + validação)

**Arquivos:**
- Backend: `backend/src/routes/auth.ts`, `backend/src/core/auth/AuthService.ts`
- Frontend: `packages/auth/src/AuthProvider.tsx`, `LoginPage.tsx`

---

### Fase 6 — Integrar Kernel Runtimes

**Objetivo:** Frontend consome runtimes do Kernel.

**Passos:**
1. Integrar `IdentityRuntime` no login
2. Integrar `TenantRuntime` no PortalRuntimeComposer
3. Integrar `ContextRuntime` no ContextSelectionPage
4. Integrar `AuthorizationRuntime` nos guards
5. Integrar `NavigationRuntime` no EnterpriseShell
6. Integrar `EventRuntime` para rastreabilidade

**Arquivos:**
- Frontend: `AuthProvider.tsx`, `ContextSelectionPage.tsx`, `EnterpriseShell.tsx`, guards
- Pacote: `packages/kernel/src/runtimes/*`

---

## 6. Decisões Pendentes

### 6.1 Sessão: HttpOnly Cookie ou outra abordagem?

**Recomendação:** HttpOnly Cookie + refresh automático via interceptor.

**Motivo:**
- Stateless
- Seguro (XSS protection)
- Refresh automático transparente

---

### 6.2 Rotas legacy devem ser mantidas?

**Opções:**
1. **Manter como fachada do Dispatcher** (recomendado) — rotas `/auth/*` e `/portal/*` apenas repassam para Dispatcher
2. **Remover e migrar tudo para Dispatcher** — mais limpo, mas quebra clientes existentes

**Recomendação:** Opção 1 (fachada) para manter compatibilidade.

---

### 6.3 Código morto: remover ou manter?

**Recomendação:** Manter por enquanto. São peças arquiteturais que serão integradas nas Fases 3 e 4.

**Classificação:** DORMANT INFRASTRUCTURE (infraestrutura dormante)

**Exceção:** `KernelIntegration.ts` pode ser removido pois usa `require()` dinâmico não compatível com ES modules.

---

## 7. Status da Conformidade Arquitetural

### Classificação

| Status | Significado |
|--------|-------------|
| ✅ Conforme | Implementação alinhada com MD-000 |
| 🟡 Parcial | Implementação parcial, precisa de ajustes |
| 🔴 Divergente | Implementação contraria MD-000 |
| ⚪ Não materializado | Arquitetura definida mas não implementada |

### Avaliação por Critério

| Critério | Status | Observação |
|----------|--------|------------|
| React é Operating Client puro? | 🟡 Parcial | Frontend evoluiu, mas ainda chama endpoints específicos |
| Dispatcher é único ponto de entrada? | 🔴 Divergente | 14 endpoints bypassam o Dispatcher |
| Backend usa Dispatcher como master? | 🟢 Conforme | Assinatura corrigida; aguardando smoke test |
| Session gerenciada pelo Kernel? | 🟡 Parcial | Session em useState, sem HttpOnly Cookie |
| Context resolvido pelo Dispatcher? | 🔴 Divergente | ContextSelection usa fetch direto |
| Authorization centralizada? | 🟡 Parcial | Permissões por SP, mas não integradas ao Dispatcher |
| Runtime respeita arquitetura? | 🟡 Parcial | Runtime evoluiu, mas não usa Dispatcher |
| Navigation dinâmica? | 🟡 Parcial | Navegação por hash removida, mas ainda não dinâmica |
| Workflow orquestrado? | ⚪ Não materializado | Orquestradores definidos no banco, não usados |
| Event rastreável? | 🟡 Parcial | Eventos existem, mas não integrados ao Kernel |

---

## 8. Resumo da Auditoria

### Arquitetura Real Identificada no Banco

O banco de dados segue uma arquitetura em **3 camadas**:

1. **Orquestrador** (`sp_master_orquestradora`)
   - Recebe módulo + ação + payload
   - Dispatch por módulo para SPs mestre específicas

2. **Dispatcher** (`sp_master_dispatcher`)
   - Recebe domínio + ação + payload
   - Resolve executor na tabela `permissao`
   - Executa dinamicamente `sp_executor_*`

3. **Executores** (`sp_executor_*`)
   - Implementam regras de negócio por domínio

### Problemas Críticos Encontrados

| # | Problema | Severidade | Status |
|---|----------|-----------|--------|
| 1 | Backend chama `sp_master_dispatcher` com assinatura errada | 🚨 CRÍTICO | ✅ Resolvido |
| 2 | `sp_master_orquestradora` existe no banco mas não é chamada | 🔴 ALTO | ❌ Não resolvido |
| 3 | 14 endpoints bypassam o Dispatcher | 🟡 MÉDIO | ❌ Não resolvido |
| 4 | Frontend consome APIs específicas | 🟡 MÉDIO | ❌ Não resolvido |
| 5 | Session não persistente | 🟡 MÉDIO | ❌ Não resolvido |
| 6 | Refresh não implementado | 🟡 MÉDIO | ❌ Não resolvido |
| 7 | Código morto arquitetural | 🟢 BAIXO | ⚠️ Dormant |

### Próximos Passos Recomendados

1. **URGENTE:** Executar smoke test do Dispatcher (`docs/DISPATCHER_SMOKE_TEST.md`)
2. Implementar rota `/orchestrator` no backend
3. Unificar backend via Dispatcher/Orchestrator
4. Migrar frontend para usar apenas Dispatcher/Orchestrator
5. Implementar refresh e persistência de sessão

### Fontes da Verdade

| Documento | Caminho | Descrição |
|-----------|---------|-----------|
| **Constituição** | `docs/canonical/MD-000-Constituicao-Arquitetural.md` | Lei máxima da plataforma |
| **Prompt de Auditoria** | `docs/AUDITORIA-PROMPT.md` | Prompt padrão para auditorias |
| **Auditoria Master SP** | `docs/MASTER_SP_ARCHITECTURE_MAP.md` | Mapeamento das SPs mestres |
| **Análise Contrato Dispatcher** | `docs/DISPATCHER_CONTRACT_ANALYSIS.md` | Contrato Backend ↔ Banco |
| **Resultado Implementação** | `docs/DISPATCHER_IMPLEMENTATION_RESULT.md` | Resultado da correção do Dispatcher |
| **Smoke Test Dispatcher** | `docs/DISPATCHER_SMOKE_TEST.md` | Testes de validação ponta a ponta |
| MYSQLBANCO.md | `MYSQLBANCO.md` | Especificação do banco |
| Banco | `database/dump/Dump20260618.sql` | DDL + DML completo |
| Backend | `backend/src/` | Código TypeScript |
| Frontend | `packages/` | Código React/TypeScript |
| MDs | `docs/canonical/` | Documentação arquitetural |

---

**Fim do documento.**

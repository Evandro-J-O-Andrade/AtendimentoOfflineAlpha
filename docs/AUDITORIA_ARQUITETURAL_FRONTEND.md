# Auditoria Arquitetural — Frontend vs Kernel Canônico

**Data:** 2026-07-25
**Marco:** Ciclo 2 — Governança + Integração Kernel
**Fonte primária:** `bancoMysql.md` + MDs do Kernel + código frontend

---

## Resumo Executivo

| Dimensão | Nota | Avaliação |
|----------|------|-----------|
| **Estrutura do React** | 9,5/10 | Excelente organização, padrões consistentes |
| **Levantamento técnico** | 9/10 | Cobertura completa de arquivos e dependências |
| **Aderência à arquitetura canônica** | 6/10 | **Divergências significativas** em relação aos MDs do Kernel |

### Achado Principal

O frontend **não está operando como um "Operating Client" puro**. Ele contém:
- Lógica de composição de runtime que deveria estar no backend
- Chamadas diretas a endpoints específicos (bypass do Dispatcher)
- Gerenciamento de sessão local que conflita com o Kernel
- Código morto que parece ser stub, mas parte dele é **infraestrutura arquitetural planejada**

---

## Fase 1 — Arquitetura (MDs × React)

### MD-KERNEL-001 — Identity

**Conceito:** Pessoa é a identidade raiz. Usuário é a identidade operacional.

**Materializado no frontend:**
- `packages/auth/src/AuthProvider.tsx` gerencia `session` com `id_usuario`, `id_entidade`
- `packages/contracts/src/auth/` define contratos de login/session
- **Parcialmente materializado:** falta `IdentityRuntime` ativo no fluxo

**Consumido:**
- `AuthProvider` consome indiretamente via `session`
- `EnterpriseShell` exibe `rt.user?.name`

**Conforme:**
- ⚠️ **Parcial** — Usuário existe, mas Pessoa não é representada no frontend
- O `AuthSessionContract` não inclui dados de Pessoa (nome, documento, email)

**Classificação:** ADAPT

---

### MD-KERNEL-002 — Tenant

**Conceito:** Tenant representa a organização. Multi-tenant obrigatório.

**Materializado no frontend:**
- `AuthProvider.selectContext()` recebe `idUnidade` (que é o Tenant operacional)
- `PortalRuntimeComposer` carrega `tenant` via dispatcher
- **Parcial:** não há `TenantRuntime` ativo

**Consumido:**
- `EnterpriseShell` exibe `rt.tenant?.name`
- `ContextSelectionPage` carrega unidades (`id_unidade`)

**Conforme:**
- ⚠️ **Parcial** — O conceito existe, mas o frontend não tem um runtime de Tenant dedicado
- A relação `saas_entidade` → `unidade` não é explicitamente modelada

**Classificação:** ADAPT

---

### MD-KERNEL-003 — Session

**Conceito:** Session é a prova operacional de que uma Identity está autorizada. Instância controlada de interação.

**Materializado no frontend:**
- `AuthProvider` gerencia session em `useState` local
- `SessionStore.ts` existe mas **não é usado**
- **NÃO há HttpOnly Cookie** — session é perdida ao reload

**Consumido:**
- `NavigationController` usa `authenticated`
- `PortalRuntimeComposer` usa `session.id_sessao_usuario`

**Conforme:**
- ❌ **NÃO CONFORME** — Session não é persistente, não há refresh automático
- O `SessionStore` foi criado mas abandonado
- O frontend assume sessão em memória, quebrando o princípio de "instância autorizada"

**Classificação:** PROPOSE (sessão stateless com HttpOnly Cookie + refresh automático)

---

### MD-KERNEL-004 — Context

**Conceito:** Context é onde a sessão está operando: Unidade + Perfil + Local.

**Materializado no frontend:**
- `ContextSelectionPage.tsx` carrega unidades via `fetch('/auth/context/:id')`
- `AuthProvider.selectContext()` envia `idUnidade, idPerfil, idLocal`
- **Parcial:** não há `ContextRuntime` ativo

**Consumido:**
- `EnterpriseShell` exibe `rt.context?.name`
- `PortalRuntimeComposer` carrega context via dispatcher

**Conforme:**
- ⚠️ **Parcial** — O fluxo funciona, mas:
  1. `ContextSelectionPage` faz `fetch` direto (bypass do Dispatcher)
  2. Não há validação de permissão no frontend para seleção de contexto
  3. O contexto não é persistido de forma canônica

**Classificação:** ADAPT

---

### MD-KERNEL-005 — Authorization

**Conceito:** Authorization decide permissões. Centralizada, auditável, determinística.

**Materializado no frontend:**
- `PortalRuntimeComposer` carrega `permissions` via dispatcher
- `ApplicationResolver` filtra apps por permissão
- `NavigationResolver` filtra navigation por permissão
- `WidgetRenderer` filtra widgets por permissão
- **NÃO há `AuthorizationRuntime` ativo**

**Consumido:**
- `EnterpriseShell` exibe apps/widgets/navigation filtrados
- `AuthGuard` verifica `authenticated` mas não permissões específicas

**Conforme:**
- ⚠️ **Parcial** — A filtragem existe, mas:
  1. Não há validação de permissão no frontend antes de ações
  2. `AuthGuard` é apenas boolean (autenticado/não)
  3. Filtragem é feita no compose, não em runtime

**Classificação:** ADAPT

---

### MD-KERNEL-006 — Discovery

**Conceito:** Discovery descobre serviços e capacidades disponíveis.

**Materializado no frontend:**
- ❌ **NÃO MATERIALIZADO** — não há `DiscoveryRuntime`
- `DOMAIN_REGISTRY` é hardcoded (não descoberto)

**Consumido:**
- Nenhum consumo

**Conforme:**
- ❌ **NÃO CONFORME** — Nenhuma descoberta dinâmica de serviços

**Classificação:** PROPOSE

---

### MD-KERNEL-007 — Registry

**Conceito:** Registry registra capacidades e funcionalidades.

**Materializado no frontend:**
- ❌ **NÃO MATERIALIZADO** — não há `RegistryRuntime`
- `WidgetRegistry` existe mas é específico para widgets, não registry genérico

**Consumido:**
- Nenhum consumo

**Conforme:**
- ❌ **NÃO CONFORME**

**Classificação:** PROPOSE

---

### MD-KERNEL-008 — Capability

**Conceito:** Capability registra funcionalidades instaladas e habilitadas.

**Materializado no frontend:**
- ❌ **NÃO MATERIALIZADO** — não há `CapabilityRuntime`
- `WidgetRegistry` + `DOMAIN_REGISTRY` fazem papel parcial

**Consumido:**
- Nenhum consumo

**Conforme:**
- ❌ **NÃO CONFORME**

**Classificação:** PROPOSE

---

### MD-KERNEL-009 — Runtime

**Conceito:** Runtime é quem mantém tudo vivo. Motor central da plataforma.

**Materializado no frontend:**
- `PortalRuntimeProvider` + `PortalRuntimeEngine` + `PortalRuntimeBuilder`
- `PortalRuntimeComposer` carrega runtime via dispatcher
- **Parcial:** não há `RuntimeEngine` canônico

**Consumido:**
- `EnterpriseShell` consome `usePortalRuntime()`
- `ContextGuard` consome `usePortalRuntime()`

**Conforme:**
- ⚠️ **Parcial** — O runtime existe, mas:
  1. Não há validação de sessão antes de executar operações
  2. Não há orquestração de workflow
  3. Não há integração com Event Runtime

**Classificação:** ADAPT

---

### MD-KERNEL-010 — Navigation

**Conceito:** Navigation monta a experiência do usuário. Baseado em permissões.

**Materializado no frontend:**
- `NavigationResolver` filtra items por permissão
- `NavigationRuntime` existe em `packages/kernel` mas **não é usado**
- `DOMAIN_REGISTRY` hardcoded
- `EnterpriseShell` renderiza sidebar manualmente

**Consumido:**
- `EnterpriseShell` exibe navigation
- `NavigationController` controla roteamento

**Conforme:**
- ⚠️ **Parcial** — Navegação existe, mas:
  1. Não é dinâmica/baseada em registry
  2. Sidebar usa `window.location.hash` (bypass do router)
  3. `NavigationRuntime` do kernel não é integrado

**Classificação:** ADAPT

---

### MD-KERNEL-011 — Workflow

**Conceito:** Workflow orquestra processos. State machine.

**Materializado no frontend:**
- ❌ **NÃO MATERIALIZADO** — não há workflow engine ativo
- `WorkflowEngine.ts` existe mas **não é usado**
- Não há state machine para fluxos

**Consumido:**
- Nenhum consumo

**Conforme:**
- ❌ **NÃO CONFORME**

**Classificação:** PROPOSE

---

### MD-KERNEL-012 — Event

**Conceito:** Event registra fatos. Rastreabilidade. Auditoria.

**Materializado no frontend:**
- ❌ **NÃO MATERIALIZADO** — não há Event Runtime ativo
- `EventClient.ts` existe mas **não é usado**
- Não há rastreamento de ações do usuário
- Não há replay de eventos

**Consumido:**
- Nenhum consumo

**Conforme:**
- ❌ **NÃO CONFORME**

**Classificação:** PROPOSE

---

## Fase 2 — Fluxos

### Fluxo de Login

```
[LoginPage]
    ↓
handleSubmit
    ↓
useAuth.login()
    ↓
authApi.login()
    ↓
POST /auth/login
    ↓
Backend valida
    ↓
Response → setSession()
    ↓
NavigationController detecta authenticated=true
    ↓
navigate('context')
```

**Avaliação arquitetural:**

| Aspecto | Status | Divergência |
|---------|--------|-------------|
| Quem valida login? | Backend | ✅ Conforme |
| Frontend tem regra de negócio? | Não | ✅ Conforme |
| Frontend acessa dados sensíveis? | Não | ✅ Conforme |
| Session é estabelecida? | Sim, em memória | ❌ Não conforme (sem HttpOnly Cookie) |
| MFA | UI only | ❌ Não conforme (sem fluxo real) |

**Classificação:** ADAPT (precisa HttpOnly Cookie + refresh automático)

---

### Fluxo de Context Selection

```
[ContextSelectionPage]
    ↓
useEffect
    ↓
fetch('/auth/context/:id') ← BYPASS DO DISPATCHER
    ↓
Mapeia unidades
    ↓
handleSelect
    ↓
selectContext() ← Via AuthProvider, não Dispatcher
    ↓
POST /auth/context/select
    ↓
navigate('portal')
```

**Avaliação arquitetural:**

| Aspecto | Status | Divergência |
|---------|--------|-------------|
| Quem resolve contexto? | Frontend + Backend | ⚠️ Parcial |
| Bypass do Dispatcher? | Sim (`fetch` direto) | ❌ Violação arquitetural |
| Frontend conhece estrutura do banco? | Não | ✅ Conforme |
| Validação de permissão? | Não | ❌ Ausente |

**Classificação:** ADAPT + violação arquitetural (fetch direto)

---

### Fluxo de Portal Runtime

```
[PortalRuntimeComposer]
    ↓
useEffect (session.id_sessao_usuario)
    ↓
ApiDispatcherClient.send({
  modulo: 'PORTAL',
  acao: 'RUNTIME.LOAD',
  payload: {},
  idSessao: session.id_sessao_usuario
})
    ↓
Backend carrega runtime
    ↓
setPortalRuntime(response.resultado)
    ↓
PortalRuntimeProvider
    ↓
EnterpriseShell
```

**Avaliação arquitetural:**

| Aspecto | Status | Divergência |
|---------|--------|-------------|
| Único ponto de entrada? | Sim (Dispatcher) | ✅ Conforme |
| Runtime composto no frontend? | Sim (fallback) | ⚠️ Parcial |
| Quem decide o que o usuário vê? | Backend (via dispatcher) | ✅ Conforme |
| Regra de negócio no compose? | Não | ✅ Conforme |

**Classificação:** ADAPT (fallback local pode ser removido)

---

## Fase 3 — Dispatcher

### Único Ponto de Entrada?

**Esperado (arquitetura):**
```
React → Dispatcher → Backend → SP
```

**Real:**
| Chamada | Arquivo | Método | Conforme? |
|---------|---------|--------|-----------|
| Login | `AuthProvider` | `authApi.login()` → `POST /auth/login` | ❌ Bypass |
| Session | `SessionResolver` | `GET /auth/session` | ❌ Bypass |
| Refresh | `AuthProvider` | `authApi.refresh()` → `POST /auth/refresh` | ❌ Bypass |
| Logout | `AuthProvider` | `authApi.logout()` → `POST /auth/logout` | ❌ Bypass |
| Context | `ContextSelectionPage` | `fetch('/auth/context/:id')` | ❌ Bypass |
| Context Select | `AuthProvider` | `authApi.selectContext()` → `POST /auth/context/select` | ❌ Bypass |
| Runtime Load | `PortalRuntimeComposer` | `ApiDispatcherClient.send()` → `POST /dispatcher` | ✅ Conforme |
| Navigation | `EnterpriseShell` | `window.location.hash` | ❌ Bypass |

**Avaliação:** Apenas **1 de 8** chamadas usa o Dispatcher. As outras 7 bypassam.

**Classificação:** ❌ NÃO CONFORME — Violação grave da arquitetura

---

## Fase 4 — Regras de Negócio

### Regra de Negócio no React?

| Arquivo | Regra Encontrada | Conforme? |
|---------|------------------|-----------|
| `LoginPage.tsx` | Nenhuma (apenas validação de formulário) | ✅ Conforme |
| `ContextSelectionPage.tsx` | Nenhuma (apenas mapeamento de dados) | ✅ Conforme |
| `AuthProvider.tsx` | Nenhuma (apenas gerenciamento de estado) | ✅ Conforme |
| `EnterpriseShell.tsx` | Nenhuma (apenas renderização) | ✅ Conforme |
| `PortalRuntimeComposer` | Nenhuma (apenas compose) | ✅ Conforme |

**Avaliação:** ✅ **Conforme** — Nenhuma regra de negócio no React.

---

## Fase 5 — Materialização

### Matriz de Materialização (MD × Implementação)

| MD | Conceito | Materializado | Consumido | Conforme | Classificação |
|----|----------|---------------|-----------|----------|---------------|
| MD-KERNEL-001 | ✅ | 🟡 Parcial | 🟡 Parcial | ⚠️ Parcial | ADAPT |
| MD-KERNEL-002 | ✅ | 🟡 Parcial | 🟡 Parcial | ⚠️ Parcial | ADAPT |
| MD-KERNEL-003 | ✅ | 🟡 Parcial | 🟡 Parcial | ❌ Não | PROPOSE |
| MD-KERNEL-004 | ✅ | 🟡 Parcial | 🟡 Parcial | ⚠️ Parcial | ADAPT |
| MD-KERNEL-005 | ✅ | 🟡 Parcial | 🟡 Parcial | ⚠️ Parcial | ADAPT |
| MD-KERNEL-006 | ✅ | ❌ Não | ❌ Não | ❌ Não | PROPOSE |
| MD-KERNEL-007 | ✅ | ❌ Não | ❌ Não | ❌ Não | PROPOSE |
| MD-KERNEL-008 | ✅ | ❌ Não | ❌ Não | ❌ Não | PROPOSE |
| MD-KERNEL-009 | ✅ | 🟡 Parcial | 🟡 Parcial | ⚠️ Parcial | ADAPT |
| MD-KERNEL-010 | ✅ | 🟡 Parcial | 🟡 Parcial | ⚠️ Parcial | ADAPT |
| MD-KERNEL-011 | ✅ | ❌ Não | ❌ Não | ❌ Não | PROPOSE |
| MD-KERNEL-012 | ✅ | ❌ Não | ❌ Não | ❌ Não | PROPOSE |

---

## Divergências Críticas

### 1. ❌ Bypass do Dispatcher (VIOLAÇÃO GRAVE)

**Problema:** 7 de 8 chamadas do frontend bypassam o `sp_master_dispatcher`.

**Impacto:**
- Quebra a regra "React só fala com Dispatcher"
- Frontend conhece endpoints específicos
- Viola a arquitetura de camadas

**Evidência:**
- `AuthProvider` usa `authApi.login()`, `authApi.refresh()`, `authApi.logout()`, `authApi.selectContext()`
- `ContextSelectionPage` usa `fetch('/auth/context/:id')`
- Apenas `PortalRuntimeComposer` usa `ApiDispatcherClient`

**Classificação:** REJECT (não pode ser mantido)

---

### 2. ❌ Session Não Persistent (VIOLAÇÃO)

**Problema:** Session é armazenada em `useState` local. Ao reload, sessão é perdida.

**Impacto:**
- Usuário precisa fazer login novamente após reload
- Não há refresh automático
- Quebra o conceito de "instância autorizada de operação"

**Evidência:**
- `AuthProvider` usa `useState<AuthSessionContract | null>(null)`
- `SessionStore.ts` existe mas não é usado
- Não há `localStorage`, `sessionStorage` ou HttpOnly Cookie

**Classificação:** PROPOSE (implementar HttpOnly Cookie + refresh automático)

---

### 3. ❌ Context Selection Bypassa Dispatcher

**Problema:** `ContextSelectionPage` faz `fetch` direto para `/auth/context/:id`.

**Impacto:**
- Bypassa validação de sessão do Dispatcher
- Frontend conhece endpoint específico
- Viola arquitetura

**Evidência:**
```tsx
// ContextSelectionPage.tsx linha 37
fetch(`/auth/context/${session.id_sessao_usuario}`)
```

**Classificação:** ADAPT (migrar para Dispatcher)

---

### 4. ❌ Código Morto Arquitetural

**Problema:** Arquivos criados como parte da arquitetura, mas não utilizados.

**Lista:**
| Arquivo | Propósito | Status |
|---------|-----------|--------|
| `SessionStore.ts` | Gerenciamento de sessão com pub/sub | ❌ Não usado |
| `WorkflowEngine.ts` | Motor de fluxo UI | ❌ Não usado |
| `UiStateManager.ts` | Gerenciador de estado UI | ❌ Não usado |
| `EventClient.ts` | Rastreamento local | ❌ Não usado |
| `KernelIntegration.ts` | Bridge Portal ↔ Kernel | ❌ Não usado |
| `FetchHttpClient.ts` | HTTP wrapper | ❌ Não usado |
| `useDispatcher.ts` | Hook dispatcher | ❌ Não usado |
| `useDomainNavigation.ts` | Hook navegação domínio | ❌ Não usado |

**Impacto:**
- Código morto aumenta complexidade
- Dúvida sobre o papel de cada componente
- Dificulta manutenção

**Classificação:** REUSE (manter SessionStore, WorkflowEngine, EventClient) / REMOVE (KernelIntegration, FetchHttpClient, hooks não usados)

---

### 5. ❌ Navegação Inconsistente

**Problema:** Sidebar usa `window.location.hash`, mas router é state-based.

**Impacto:**
- Quebra o fluxo de navegação
- Não há histórico de navegação
- Domínios não são rotas reais

**Evidência:**
```tsx
// EnterpriseShell.tsx
onClick={() => { window.location.hash = domain.rota }}
```

**Classificação:** ADAPT (integrar com RouterProvider)

---

### 6. ❌ MFA Incompleto

**Problema:** UI de MFA existe, mas não há fluxo real de validação.

**Impacto:**
- Estado `MFA_REQUIRED` existe no contrato
- Mas não há endpoint de validação de código MFA
- Usuário não consegue completar login com MFA

**Evidência:**
- `LoginPage.tsx` renderiza modo MFA
- `handleSubmit` envia `mfaCode` no mesmo request de login
- Não há chamada separada para validação MFA

**Classificação:** EXTEND (implementar fluxo MFA real)

---

## Código Morto / Legacy

### Código Morto Identificado

| Arquivo | Motivo | Ação |
|---------|--------|-------|
| `SessionStore.ts` | Não usado pelo AuthProvider | Manter (REUSE) |
| `KernelIntegration.ts` | Não importado | Remover (DELETE) |
| `WorkflowEngine.ts` | Não usado | Manter (REUSE para futuro) |
| `UiStateManager.ts` | Não usado | Manter (REUSE para futuro) |
| `EventClient.ts` | Não usado | Manter (REUSE para futuro) |
| `FetchHttpClient.ts` | Não usado | Remover (DELETE) |
| `useDispatcher.ts` | Não usado | Remover (DELETE) |
| `useDomainNavigation.ts` | Não usado | Remover (DELETE) |
| `workspaces/` | Documentado como LEGACY | Remover (DELETE) |
| `shared/index.ts` | Exporta stubs não usados | Manter (REUSE para design system futuro) |

### Legacy Identificado

| Item | Motivo | Ação |
|------|--------|-------|
| `workspaces/` | Scaffolding por role, documentado como LEGACY | Remover após migração para domains/ |
| `ContextSelectionPage.tsx` fetch direto | Bypassa Dispatcher | Migrar para Dispatcher |

---

## Matriz de Conformidade Arquitetural

| Critério | Status | Severidade |
|----------|--------|------------|
| React é Operating Client puro? | ❌ Não | Alta |
| Dispatcher é único ponto de entrada? | ❌ Não (1/8) | Alta |
| Session é gerenciada pelo Kernel? | ❌ Não | Alta |
| Context é resolvido pelo Dispatcher? | ❌ Não | Média |
| Authorization é centralizada? | ⚠️ Parcial | Média |
| Runtime respeita arquitetura? | ⚠️ Parcial | Média |
| Navigation é dinâmica? | ❌ Não | Baixa |
| Workflow é orquestrado? | ❌ Não | Baixa |
| Event é rastreável? | ❌ Não | Baixa |
| Sem regra de negócio no React? | ✅ Sim | - |
| Sem acesso direto a banco? | ✅ Sim | - |
| Contracts-first? | ✅ Sim | - |

---

## Classificação ADAPT/EXTEND/REUSE/MERGE/PROPOSE

### Por Runtime

| Runtime | Classificação | Ação |
|---------|--------------|------|
| Identity | ADAPT | Integrar `IdentityRuntime` no fluxo de login |
| Tenant | ADAPT | Integrar `TenantRuntime` no PortalRuntimeComposer |
| Session | PROPOSE | Implementar HttpOnly Cookie + refresh automático |
| Context | ADAPT | Migrar `fetch` direto para Dispatcher |
| Authorization | ADAPT | Integrar `AuthorizationRuntime` nos guards |
| Discovery | PROPOSE | Implementar `DiscoveryRuntime` + descoberta dinâmica |
| Registry | PROPOSE | Implementar `RegistryRuntime` para capabilities |
| Capability | PROPOSE | Implementar `CapabilityRuntime` |
| Navigation | ADAPT | Integrar `NavigationRuntime` + remover hash navigation |
| Workflow | PROPOSE | Implementar `WorkflowRuntime` |
| Event | PROPOSE | Implementar `EventRuntime` + rastreamento |

---

## Recomendação Priorizada

### Fase 1 — Fechar Validação do Login (sem alterar arquitetura)

1. **Implementar HttpOnly Cookie + refresh automático**
   - Modificar backend para enviar session via HttpOnly Cookie
   - Adicionar interceptor no frontend para refresh automático
   - **Arquivos:** `AuthProvider.tsx`, `ApiClient`, backend auth routes

2. **Fechar fluxo MFA real**
   - Implementar endpoint de validação MFA
   - Integrar com `AuthenticationState.MFA_REQUIRED`
   - **Arquivos:** `LoginPage.tsx`, backend auth routes

3. **Integrar ContextSelectionPage com Dispatcher**
   - Substituir `fetch('/auth/context/:id')` por `dispatcher.send()`
   - **Arquivos:** `ContextSelectionPage.tsx`

### Fase 2 — Integração com Kernel (após Fase 1)

4. **Migrar AuthProvider para usar Dispatcher**
   - Substituir `authApi.*` por `dispatcher.send()`
   - Integrar `SessionRuntime`, `IdentityRuntime`, `TenantRuntime`
   - **Arquivos:** `AuthProvider.tsx`, `SessionStore.ts`

5. **Integrar NavigationRuntime**
   - Substituir `window.location.hash` por navegação via router
   - Carregar navigation via Dispatcher
   - **Arquivos:** `EnterpriseShell.tsx`, `router.tsx`

6. **Implementar EventRuntime**
   - Adicionar rastreamento de ações do usuário
   - Integrar com `EventClient.ts`
   - **Arquivos:** `EventClient.ts`, `AuthProvider.tsx`

### Fase 3 — Arquitetura Avançada (após Fase 2)

7. **Implementar DiscoveryRuntime**
8. **Implementar RegistryRuntime**
9. **Implementar CapabilityRuntime**
10. **Implementar WorkflowRuntime**

---

## Decisão Arquitetural Pendente

**Sessão deve ser persistida no frontend ou backend?**

Opções:
1. **HttpOnly Cookie** (recomendado) — Stateless, seguro, refresh automático
2. **SessionStorage** — Menos seguro, mas funciona
3. **LocalStorage** — Menos seguro, persistente

Recomendo **HttpOnly Cookie** + refresh automático via interceptor.

---

## Próximo Passo

Antes de implementar qualquer item do roadmap, preciso de sua decisão sobre:

1. **Persistência de sessão:** HttpOnly Cookie ou outra abordagem?
2. **Ordem de implementação:** Quer seguir a ordem sugerida acima?
3. **Código morto:** Posso remover `KernelIntegration.ts`, `FetchHttpClient.ts`, `useDispatcher.ts`, `useDomainNavigation.ts`?

Não vou alterar nada sem sua autorização.

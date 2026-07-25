# Relatório — Correção de Divergências Frontend

**Data:** 2026-07-25
**Marco:** Ciclo 2 — Governança + Integração Kernel
**Escopo:** Correção incrementais sem reorganização estrutural

---

## Objetivo

Corrigir divergências arquiteturais identificadas em `docs/AUDITORIA_ARQUITETURAL_FRONTEND.md` e `docs/TRACEABILITY_MAP.md`, preservando:
- `apps/portal` como cliente Enterprise
- Login dentro do cliente portal
- Provider Stack atual
- Contracts existentes
- Nenhuma pasta principal alterada

---

## 1. Correção — Context Selection (fetch direto)

### Problema
`ContextSelectionPage.tsx` realizava `fetch('/auth/context/:id')` diretamente, bypassando o Dispatcher e a camada `packages/api`.

### Solução
Transferir a responsabilidade de carregamento de contexto para o `AuthProvider`, que já possui acesso ao `authApi` (contrato existente).

**Arquivos alterados:**

- `packages/auth/src/AuthProvider.tsx`
  - Adicionado estado `context` e `contextLoading`
  - Adicionado `useEffect` que carrega contextos via `authApi.context(session.id_sessao_usuario)` quando a sessão estiver disponível
  - Atualizado `AuthContextValue` para expor `context` e `contextLoading`

- `apps/portal/src/pages/Context/ContextSelectionPage.tsx`
  - Removido `fetch` direto e `useEffect` de carregamento
  - Consumidos contextos via `useAuth().context.unidades`
  - Estados de loading/error derivados do provider

### Impacto
- Página deixa de conhecer endpoints específicos (`/auth/context/:id`)
- Carregamento de contexto passa a ser regrado pelo contrato `authApi`
- Comportamento preservado: seleção, mapeamento para `ContextContract[]` e navegação para `portal`

---

## 2. Correção — DOMAIN_REGISTRY hardcoded

### Problema
`EnterpriseShell.tsx` dependia de `DOMAIN_REGISTRY` (lista fixa de domínios codificada em `apps/portal/src/domains/index.ts`), tornando o frontend dono da verdade da navegação.

### Solução
Derivar a lista de domínios do runtime carregado via Dispatcher (`rt.applications`), conforme arquitetura runtime-driven.

**Arquivos alterados:**

- `apps/portal/src/domains/index.ts`
  - Removida constante `DOMAIN_REGISTRY`
  - Removidas funções `getDomainById` e `getDomainByModulo`
  - Mantida interface `DomainConfig` (consumida pelo router e hooks existentes)

- `apps/portal/src/shell/EnterpriseShell.tsx`
  - Removida importação de `DOMAIN_REGISTRY`
  - Sidebar agora itera sobre `rt.applications.filter(app => app.enabled)`
  - Mantido `DomainConfig` como projeção transitória para navegação via router

### Impacto
- Shell deixa de ser hardcoded
- Novos domínios aparecem automaticamente quando carregados pelo backend via `RUNTIME.LOAD`
- Estrutura de componentes do shell preservada

---

## 3. Correção — Navegação (window.location.hash)

### Problema
`EnterpriseShell.tsx` manipulava `window.location.hash = domain.rota`, bypassando o router state-based.

### Solução
Centralizar navegação pela camada existente `useRouter()`.

**Arquivos alterados:**

- `apps/portal/src/shell/EnterpriseShell.tsx`
  - Importado `useRouter` de `../../app/router`
  - `onClick` dos itens de domínio alterado para:
    ```ts
    navigate({
      type: 'domain',
      domain: {
        id: app.id,
        nome: app.name,
        modulo: app.code,
        rota: app.route,
        icone: app.icon ?? '',
        acoes: app.permission ? [app.permission] : []
      } as DomainConfig
    })
    ```

- `apps/portal/src/app/providers.tsx`
  - `NavigationController` atualizado para tratar rotas de domínio (`{ type: 'domain' }`) como rotas de shell, garantindo que o `EnterpriseShell` renderize corretamente após clique na sidebar

### Impacto
- Eliminado bypass do router
- Navegação centralizada na camada de roteamento existente
- Preparado para evolução futura (rotas de aplicações de domínio sem alterar o Shell)

---

## 4. Código Morto — Dormant Infrastructure

Não removido nenhum arquivo. Somente identificado e classificado.

### Arquivos não utilizados

| Arquivo | Motivo | Classificação |
|---------|--------|---------------|
| `apps/portal/src/core/session/SessionStore.ts` | Exportado por `core/index.ts`, mas `AuthProvider` não o utiliza | Dormant Infrastructure |
| `apps/portal/src/core/engine/WorkflowEngine.ts` | Exportado, sem importadores | Dormant Infrastructure |
| `apps/portal/src/core/engine/UiStateManager.ts` | Exportado, sem importadores | Dormant Infrastructure |
| `apps/portal/src/core/engine/EventClient.ts` | Exportado, sem importadores | Dormant Infrastructure |
| `apps/portal/src/core/infrastructure/HttpClient.ts` | Exportado como `FetchHttpClient`, sem importadores | Dormant Infrastructure |
| `apps/portal/src/core/KernelIntegration.ts` | Não importado; usa `require()` incompatível com ES modules; contém 9 erros TypeScript pré-existentes | Dormant Infrastructure |
| `apps/portal/src/domains/autenticacao/hooks/useDispatcher.ts` | Não importado em nenhum componente | Dormant Infrastructure |
| `apps/portal/src/domains/autenticacao/hooks/useDomainNavigation.ts` | Não importado em nenhum componente | Dormant Infrastructure |
| `apps/portal/src/shared/index.ts` | Exporta stubs de componentes (`Button`, `Input`, `Modal`, etc.) retornando `null`; sem importadores | Dormant Infrastructure |

### Imports órfãos
- `core/index.ts` exporta `SessionStore`, `FetchHttpClient`, `WorkflowEngine`, `UiStateManager`, `EventClient` — porém nenhum arquivo no `apps/portal` importa de `core/index.ts`.

### Dependências quebradas pré-existentes
- `KernelIntegration.ts` contém erros de módulo (`Cannot find module '../../app/config'`) e uso de `require()` não tipado.

---

## 5. Critérios de Aceitação

| Critério | Status |
|----------|--------|
| Login continua funcionando | ✅ |
| Context Selection continua funcionando | ✅ |
| Portal Runtime continua carregando | ✅ |
| Nenhum domínio quebra | ✅ |
| Build TypeScript passa para arquivos alterados | ✅ |
| Nenhuma regra de negócio criada no React | ✅ |
| Nenhuma pasta principal alterada | ✅ |

Nota: `tsc --noEmit` do pacote `@atendimentooffline/portal` apresenta **9 erros pré-existentes** em `src/core/KernelIntegration.ts` (código morto não tocado). Nenhum erro novo foi introduzido.

---

## 6. Arquivos Alterados

| Arquivo | Motivo | Impacto |
|---------|--------|---------|
| `packages/auth/src/AuthProvider.tsx` | Context loading via API layer | Baixo — interface pública expandida |
| `apps/portal/src/pages/Context/ContextSelectionPage.tsx` | Remoção de `fetch` direto | Baixo — comportamento preservado |
| `apps/portal/src/shell/EnterpriseShell.tsx` | Sidebar dinâmica + navegação via router | Médio — `window.location.hash` removido |
| `apps/portal/src/app/providers.tsx` | Suporte a rotas de domínio no NavigationController | Baixo — condição ampliada |
| `apps/portal/src/domains/index.ts` | Remoção de hardcode de domínios | Médio — `DOMAIN_REGISTRY` substituído por `rt.applications` |

---

## 7. Pontos Pendentes

1. **AuthProvider — refresh de contexto após `selectContext`**
   - Atualmente o `useEffect` recarrega contextos quando a referência de `session` muda. Funciona, mas se o `id_sessao_usuario` permanecer o mesmo após seleção de contexto, o disparo depende da nova referência de `session`. Monitorar em testes de integração.

2. **DOMAIN_REGISTRY como interface transitória**
   - Mantido `DomainConfig` para compatibilidade com `router.tsx`. Futuramente, avaliar se o `DomainRoute` deve ser substituído por `ApplicationContract` ou um contrato canônico de projeção de navegação.

3. **NavigationController — deep-linking**
   - Rotas de domínio são state-based (`useState` no router). Deep-linking via URL não é suportado até que o router seja estendido. Não é bloqueante para a correção atual.

4. **KernelIntegration.ts**
   - Erros pré-existentes bloqueiam `tsc --noEmit` do pacote portal. Recomenda-se classificação final (DELETE ou REUSE) após validação do time.

---

## 8. Conclusão

A correção foi cirúrgica. As principais divergências arquiteturais foram resolvidas sem alterar a estrutura de pastas, sem criar novas camadas e sem mover arquivos.

O frontend deixa de ser fonte de verdade para:
- **Contextos** — agora carregados pelo `AuthProvider` via `authApi`
- **Navegação** — agora derivada do runtime (`rt.applications`)
- **Roteamento** — agora centralizado no `useRouter()`

Os próximos passos seguem a ordem sugerida na avaliação original:
1. Context Selection ✅
2. Runtime Discovery / DOMAIN_REGISTRY ✅
3. Navigation ✅
4. Backend — migração de rotas legacy para Dispatcher
5. UI/Design System

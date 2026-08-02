# AUDITORIA DO FLUXO FRONTEND — LOGIN → CONTEXTO → PORTAL

**Data:** 2026-07-27  
**Objetivo:** Comprovar se o frontend executa integralmente o fluxo canônico de autenticação.  
**Escopo:** Apenas leitura. Não alterar código.

---

## 1. Mapa de Arquivos Auditados

| Arquivo | Responsabilidade |
|---------|------------------|
| `apps/portal/src/pages/Login/LoginPage.tsx` | Tela de login |
| `packages/auth/src/AuthProvider.tsx` | Gerenciamento de sessão e contexto |
| `apps/portal/src/pages/Context/ContextSelectionPage.tsx` | Seleção de contexto operacional |
| `apps/portal/src/app/providers.tsx` | Orquestração de providers e navegação |

---

## 2. Fluxo Observado no Código

### Passo 1 — Login

**Arquivo:** `LoginPage.tsx:48-67`  
**Ação:** `handleSubmit()` chama `login(request)`

**Arquivo:** `AuthProvider.tsx:95-101`  
**Ação:** `login()` chama `authApi.login(request)`

**Endpoint:** `POST /auth/login`  
**Backend:** `AuthService.authenticate()` → `sp_master_login`

**Evidência:**
```tsx
// LoginPage.tsx:60
const response = await login(request)
setAuthState(response.state)
```

```tsx
// AuthProvider.tsx:97-100
const response = await authApi.login(request)
if (response.authenticated && response.session) {
  setSession(response.session)  // ← Sessão incompleta (ids zerados)
}
```

**Status:** ✅ Executado

---

### Passo 2 — Carregamento de Contextos

**Arquivo:** `AuthProvider.tsx:67-93`  
**Ação:** `useEffect` disparado quando `session` muda

**Endpoint:** `GET /auth/context/:idSessao`  
**Backend:** `AuthService.context()` → `sp_auth_contexto_get`

**Evidência:**
```tsx
// AuthProvider.tsx:74
authApi.context(session.id_sessao_usuario)
  .then((res) => setContext(res))
```

**Status:** ✅ Executado automaticamente após login

---

### Passo 3 — Seleção de Contexto

**Arquivo:** `ContextSelectionPage.tsx:40-48`  
**Ação:** Usuário clica em um contexto → `handleSelect()`

**Endpoint:** `POST /auth/context/select`  
**Backend:** `AuthService.selectContext()` → `sp_auth_contexto_set`

**Evidência:**
```tsx
// ContextSelectionPage.tsx:43
await selectContext(Number(context.id), 1, 0)
navigate('portal')
```

```tsx
// AuthProvider.tsx:126-129
const response = await authApi.selectContext(...)
if (response.session) {
  setSession(response.session)  // ← Retorno de sp_auth_contexto_set (contexto_definido: true)
}
```

**Status:** ✅ Executado, mas com problema (ver seção 4)

---

### Passo 4 — Carregamento da Sessão Completa

**Arquivo:** `AuthProvider.tsx`  
**Ação:** NÃO EXISTE

**Endpoint que deveria ser chamado:** `GET /auth/session/:idSessao`  
**Backend:** `AuthService.session()` → `sp_sessao_contexto_get`

**Evidência da ausência:**
- `AuthProvider.tsx` não chama `authApi.session()` após `selectContext()`
- `ContextSelectionPage.tsx` não chama `session()` após selecionar contexto
- Nenhum arquivo do frontend chama `GET /auth/session/:idSessao` após contexto

**Status:** ❌ NÃO EXECUTADO

---

### Passo 5 — Navegação para Portal

**Arquivo:** `providers.tsx:38-51`  
**Ação:** `NavigationController` gerencia navegação

**Evidência:**
```tsx
// providers.tsx:46-50
if (route === 'login') {
  navigate('context')
} else if (route === 'context') {
  navigate('portal')  // ← Navega AUTOMATICAMENTE para portal
}
```

**Status:** ✅ Navega, mas com problema (ver seção 4)

---

## 3. Matriz de Execução do Fluxo

| Passo | Fluxo Canônico | Frontend Executa? | Evidência |
|-------|---------------|-------------------|-----------|
| 1. Login | `POST /auth/login` → `sp_master_login` | ✅ Sim | `AuthProvider.tsx:97` |
| 2. Carregar contextos | `GET /auth/context/:idSessao` → `sp_auth_contexto_get` | ✅ Sim | `AuthProvider.tsx:74` |
| 3. Selecionar contexto | `POST /auth/context/select` → `sp_auth_contexto_set` | ✅ Sim | `ContextSelectionPage.tsx:43` |
| 4. Sessão completa | `GET /auth/session/:idSessao` → `sp_sessao_contexto_get` | ❌ Não | Nenhuma chamada encontrada |
| 5. Portal | Carregar runtime com sessão completa | 🟡 Parcial | `providers.tsx:133` carrega runtime, mas com sessão incompleta |

---

## 4. Problemas Identificados

### Problema 1 — Sessão incompleta após login

**Evidência:** `AuthService.login()` retorna JSON de `sp_master_login` que contém apenas:
```json
{
  "id_sessao_usuario": 273,
  "uuid_sessao": "...",
  "contexto_definido": false
}
```

**Impacto:** `AuthProvider` armazena sessão com `id_usuario: 0`, `id_entidade: 0`, etc.

---

### Problema 2 — Ausência de `sp_sessao_contexto_get` no fluxo

**Evidência:** Nenhum arquivo do frontend chama `GET /auth/session/:idSessao` após o contexto ser definido.

**Impacto:** A sessão nunca é enriquecida com os dados completos do banco.

---

### Problema 3 — Navegação automática sem validação

**Evidência:** `providers.tsx:49`
```tsx
} else if (route === 'context') {
  navigate('portal')  // ← Navega automaticamente
}
```

**Impacto:** O `NavigationController` navega de `context` para `portal` automaticamente, sem esperar o usuário selecionar o contexto. Isso pode causar:
- Acesso ao portal sem contexto definido
- Loop de navegação se `ContextSelectionPage` não renderizar

---

### Problema 4 — `selectContext` não enriquece a sessão

**Evidência:** `sp_auth_contexto_set` retorna apenas:
```json
{
  "contexto_definido": true
}
```

**Impacto:** `AuthProvider` atualiza a sessão com esse objeto, que não contém `id_usuario`, `id_entidade`, etc.

---

## 5. Conclusão

### Classificação

🟡 **O frontend interrompe o fluxo após o login.**

### Evidência da interrupção

O fluxo executado é:
```text
Login
    ↓
sp_master_login
    ↓
sp_auth_contexto_get (carrega contextos)
    ↓
sp_auth_contexto_set (usuário seleciona)
    ↓
Portal  ← FALTA: sp_sessao_contexto_get para enriquecer sessão
```

O fluxo canônico completo é:
```text
Login
    ↓
sp_master_login
    ↓
sp_auth_contexto_get
    ↓
sp_auth_contexto_set
    ↓
sp_sessao_contexto_get  ← AUSENTE NO FRONTEND
    ↓
Portal
```

### Responsabilidade

A correção deve ser feita no **AuthProvider** (`packages/auth/src/AuthProvider.tsx`), não no `AuthService`.

O `AuthProvider` deve, após `selectContext()`, chamar `authApi.session()` para carregar a sessão completa via `sp_sessao_contexto_get`.

### Próximo Passo

Implementar no `AuthProvider`:

```tsx
// Após selectContext()
const response = await authApi.selectContext(...)
if (response.session) {
  // ENRIQUECER sessão com dados completos
  const fullSession = await authApi.session(session.id_sessao_usuario)
  setSession(fullSession)
}
```

Isso mantém a responsabilidade de cada camada:
- **SPs:** fornecem dados
- **Backend:** expõe endpoints
- **Frontend:** orquestra o fluxo canônico

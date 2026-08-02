# AUDITORIA DO FLUXO LOGIN → CONTEXTO → PORTAL

**Data:** 2026-07-27  
**Objetivo:** Determinar, com evidência do dump e banco vivo, qual SP é responsável por preencher cada campo da sessão.  
**Regra:** Não alterar código. Apenas provar.

---

## 1. SPs Auditadas

| SP | Arquivo no dump | Linha aproximada |
|----|-----------------|------------------|
| `sp_master_login` | `database/dump/Dump20260726.sql` | CREATE em ~linha 268 |
| `sp_auth_contexto_get` | `database/dump/Dump20260726.sql` | Após `sp_master_login` |
| `sp_auth_contexto_set` | `database/dump/Dump20260726.sql` | Após `sp_auth_contexto_get` |
| `sp_sessao_contexto_get` | `database/dump/Dump20260726.sql` | Após `sp_auth_contexto_set` |
| `sp_sessao_contexto_set` | `database/dump/Dump20260726.sql` | Após `sp_sessao_contexto_get` |

---

## 2. Matriz de Responsabilidade por Campo

| Campo da Sessão | Responsável canônico | Evidência no dump | Observação |
|-----------------|---------------------|-------------------|------------|
| `id_sessao_usuario` | **sp_master_login** | `SET v_id_sessao = LAST_INSERT_ID()` | Criado no INSERT de `sessao_usuario` |
| `uuid_sessao` | **sp_master_login** | `SET v_uuid_sessao = UUID()` | Gerado no fluxo `AUTH.LOGIN.REQUEST` |
| `contexto_definido` | **sp_master_login** | `SET p_resultado = JSON_OBJECT('contexto_definido', FALSE)` | Inicializado como FALSE no login |
| `id_usuario` | **sp_master_login** | `SELECT id_usuario INTO v_id_usuario FROM usuario WHERE login = v_login` | Preenchido no INSERT de `sessao_usuario` |
| `id_entidade` | **sp_master_login** | `SELECT id_usuario, ativo, id_entidade INTO ... FROM usuario` | Preenchido no INSERT de `sessao_usuario` |
| `id_unidade` | **sp_auth_contexto_set** | `UPDATE sessao_usuario SET id_unidade = v_id_unidade WHERE id_sessao_usuario = v_id_sessao` | Preenchido no fluxo `AUTH.CONTEXTO.SET` |
| `id_local` | **sp_auth_contexto_set** | `UPDATE sessao_usuario SET id_local = v_id_local WHERE id_sessao_usuario = v_id_sessao` | Preenchido no fluxo `AUTH.CONTEXTO.SET` |
| `id_perfil` | **sp_auth_contexto_set** | `UPDATE sessao_usuario SET id_perfil = v_id_perfil WHERE id_sessao_usuario = v_id_sessao` | Preenchido no fluxo `AUTH.CONTEXTO.SET` |
| `token_jwt` | **sp_master_login** | Recebido via `p_payload.$.token_jwt` e inserido em `sessao_usuario.token_jwt` | Frontend deve enviar no payload |
| `refresh_token` | **sp_master_login** | Recebido via `p_payload.$.refresh_token` | Frontend deve enviar no payload |
| `ip_origem` | **sp_master_login** | Recebido via `p_payload.$.ip` | Frontend deve enviar no payload |
| `user_agent` | **sp_master_login** | Recebido via `p_payload.$.device` | Frontend deve enviar no payload |
| `device_fingerprint` | **sp_master_login** | Recebido via `p_payload.$.fingerprint` | Frontend deve enviar no payload |

---

## 3. Fluxo Canônico Comprovado

```text
sp_master_login (AUTH.LOGIN.REQUEST)
    ↓
INSERT em sessao_usuario com:
  - id_usuario (da tabela usuario)
  - id_entidade (da tabela usuario)
  - id_unidade = NULL
  - id_local = NULL
  - id_perfil = NULL
    ↓
Retorna: id_sessao_usuario, uuid_sessao, contexto_definido = FALSE
    ↓
sp_auth_contexto_get (AUTH.CONTEXTO.GET)
    ↓
Retorna: unidades, locais, perfis disponíveis para o usuário
    ↓
Usuário seleciona contexto (unidade, perfil, local)
    ↓
sp_auth_contexto_set (AUTH.CONTEXTO.SET)
    ↓
UPDATE em sessao_usuario com:
  - id_unidade
  - id_local
  - id_perfil
    ↓
Retorna: contexto_definido = TRUE
    ↓
sp_sessao_contexto_get
    ↓
Retorna: sessao_usuario completa (todos os campos)
```

---

## 4. Divergência Identificada no Código Atual

### 4.1 AuthService.authenticate()

**Arquivo:** `backend/src/core/auth/AuthService.ts:62-88`

```typescript
async authenticate(username, password, ip, device) {
    // SELECT DIRETO em usuario (bypass de SP)
    const [rows] = await conn.query(
        'SELECT id_usuario, senha_hash, ativo FROM usuario WHERE login = ? LIMIT 1',
        [username]
    )
    // ... validação bcrypt ...
    const token = jwt.sign(...)
    return this.login(username, token, '', ip, device)
}
```

**Problema:** Faz SELECT direto em `usuario` antes de chamar `sp_master_login`.

**Impacto:** 
- Quebra LC-007 (SP-First Architecture)
- Não registra tentativa de login no Event Store antes da SP
- A SP `sp_master_login` também valida usuário/ativo/tentativas, mas o código já fez isso antes

**Responsável pela correção:** Backend (AuthService)

---

### 4.2 AuthService.login()

**Arquivo:** `backend/src/core/auth/AuthService.ts:9-60`

```typescript
async login(login, tokenJwt, refreshToken, ip, device) {
    const payload = JSON.stringify({
        login,
        token_jwt: tokenJwt,
        refresh_token: refreshToken,
        ip,
        device,
        fingerprint: device
    })
    await conn.query('CALL sp_master_login(?, ?, @p_resultado, @p_sucesso, @p_mensagem)', [
        'AUTH.LOGIN.REQUEST',
        payload
    ])
    const [outRows] = await conn.query('SELECT @p_resultado AS resultado, ...')
    const parsed = typeof resultado?.resultado === 'string'
        ? JSON.parse(resultado.resultado)
        : (resultado?.resultado ?? {})
    const sessao = parsed?.sessao ?? {}
    const session = {
        id_sessao_usuario: Number(sessao?.id_sessao_usuario ?? 0),
        id_usuario: Number(sessao?.id_usuario ?? 0),  // ← SEMPRE 0
        id_entidade: Number(sessao?.id_entidade ?? 0),  // ← SEMPRE 0
        // ...
    }
}
```

**Problema:** O `session` retornado tem `id_usuario: 0` e `id_entidade: 0` porque `sp_master_login` não retorna esses campos no JSON de resultado.

**Evidência no dump:** `sp_master_login` linha 124-130:
```sql
SET p_resultado = JSON_OBJECT(
    'sessao', JSON_OBJECT(
        'id_sessao_usuario', v_id_sessao,
        'uuid_sessao', v_uuid_sessao,
        'contexto_definido', FALSE
    )
);
```

**Impacto:** O frontend recebe sessão com IDs zerados.

**Responsável pela correção:** Backend (AuthService) deve enriquecer a sessão após o login.

---

### 4.3 AuthProvider — não enriquece sessão após login

**Arquivo:** `packages/auth/src/AuthProvider.tsx:95-101`

```typescript
const login = useCallback(async (request) => {
    setLoading(true)
    const response = await authApi.login(request)
    if (response.authenticated && response.session) {
        setSession(response.session)  // ← Sessão incompleta
    }
    return response
}, [authApi])
```

**Problema:** Não chama `session()` ou `context()` após login para enriquecer a sessão.

**Impacto:** Frontend opera com sessão incompleta.

**Responsável pela correção:** Frontend (AuthProvider) ou Backend (AuthService.login() deve retornar sessão completa).

---

## 5. Qual a Correção Canônica?

### Cenário A — sp_master_login retorna sessão completa

**Evidência:** Não. O dump mostra claramente que `sp_master_login` retorna apenas:
- `id_sessao_usuario`
- `uuid_sessao`
- `contexto_definido`

**Conclusão:** **Cenário A descartado.**

---

### Cenário B — Fluxo canônico: Login → Contexto → Sessão completa

**Evidência:**

1. **sp_master_login** cria sessão com `id_usuario` e `id_entidade` (INSERT em `sessao_usuario`)
2. **sp_auth_contexto_get** retorna contextos disponíveis
3. **sp_auth_contexto_set** atualiza `id_unidade`, `id_local`, `id_perfil`
4. **sp_sessao_contexto_get** retorna sessão completa

**Fluxo esperado:**
```text
Frontend: login()
    ↓
Backend: AuthService.authenticate()
    ↓
sp_master_login (AUTH.LOGIN.REQUEST)
    ↓
Retorna: id_sessao_usuario, uuid_sessao
    ↓
Frontend: carrega contextos (sp_auth_contexto_get)
    ↓
Frontend: usuário escolhe contexto
    ↓
Frontend: selectContext()
    ↓
Backend: AuthService.selectContext()
    ↓
sp_auth_contexto_set (AUTH.CONTEXTO.SET)
    ↓
Backend: AuthService.session() (sp_sessao_contexto_get)
    ↓
Retorna: sessão completa
```

**Conclusão:** **Cenário B é o fluxo canônico.**

---

## 6. Responsabilidade por Camada

| Camada | Responsabilidade | Evidência |
|--------|------------------|-----------|
| **SP** | `sp_master_login` cria sessão com `id_usuario` + `id_entidade` | Dump: INSERT em `sessao_usuario` |
| **SP** | `sp_auth_contexto_set` preenche `id_unidade` + `id_local` + `id_perfil` | Dump: UPDATE em `sessao_usuario` |
| **SP** | `sp_sessao_contexto_get` retorna sessão completa | Dump: SELECT de `sessao_usuario` |
| **Backend** | `AuthService.login()` deve retornar sessão COMPLETA, não apenas o JSON da SP | Código: `AuthService.ts:43-53` |
| **Frontend** | `AuthProvider` deve chamar `session()` após login para enriquecer sessão | Código: `AuthProvider.tsx:95-101` |

---

## 7. Conclusão

A responsabilidade por preencher os campos da sessão é **compartilhada**:

| Campo | Responsável |
|-------|-------------|
| `id_sessao_usuario` | `sp_master_login` |
| `uuid_sessao` | `sp_master_login` |
| `id_usuario` | `sp_master_login` (INSERT) |
| `id_entidade` | `sp_master_login` (INSERT) |
| `id_unidade` | `sp_auth_contexto_set` (UPDATE) |
| `id_local` | `sp_auth_contexto_set` (UPDATE) |
| `id_perfil` | `sp_auth_contexto_set` (UPDATE) |

**O que está faltando:**

1. `AuthService.login()` não enriquece a sessão após `sp_master_login`
2. `AuthProvider` não chama `session()` após login
3. O fluxo de contexto existe no backend, mas não está integrado ao fluxo de login do frontend

**Próximo passo (sem alterar código ainda):**

Validar se o frontend realmente segue o fluxo canônico:
1. Login → `sp_master_login`
2. Carrega contextos → `sp_auth_contexto_get`
3. Usuário escolhe contexto → `sp_auth_contexto_set`
4. Carrega sessão completa → `sp_sessao_contexto_get`

Se o frontend já faz isso, o problema é apenas que `AuthService.login()` não retorna a sessão completa após o passo 3.

Se o frontend não faz isso, precisamos implementar o fluxo completo no `AuthProvider`.

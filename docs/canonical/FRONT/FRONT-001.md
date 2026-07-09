# FRONT-001 — Canonical Login Experience

> **Status:** Canônico  
> **Domínio:** FRONT  
> **Tipo:** Experiência de Autenticação  
> **Companheiro:** FRONT-000 (Constituição), MD-020 (Portal Core), MD-123 (Portal Canonical Experience), MD-120 (Party Identity Architecture), MD-124 (Context First Architecture)

---

## 1. Objetivo

Define a experiência canônica de autenticação da plataforma SaaS Enterprise.

Todo usuário humano inicia obrigatoriamente por este fluxo. A Login Experience é a porta de entrada exclusiva do ecossistema e não possui conhecimento de módulos de negócio.

Fluxo canônico:

```text
Pessoa
    ↓
Login
    ↓
Identity Resolution
    ↓
Session Validation
    ↓
Context Selection (se necessário)
    ↓
Portal Enterprise
```

Nenhuma aplicação quebra essa ordem (MD-CANONICO-IA-001 Regra 21).

---

## 2. Escopo

A Login Experience é responsável apenas por:

- autenticar a identidade;
- restaurar sessão existente;
- iniciar uma nova sessão;
- encerrar sessão.

A Login Experience **não**:

- escolhe contexto;
- resolve permissões;
- conhece aplicações;
- conhece HIS;
- conhece Workforce;
- conhece Displays;
- conhece módulos de domínio.

Qualquer violação desse escopo é bloqueada pela governança arquitetural.

---

## 3. Fluxo Canônico

```text
GET /login
    ↓
SessionResolver
    ↓
Existe sessão válida?
    │
    ├─ NÃO ──► Tela de Login
    │              ↓
    │         Credenciais
    │              ↓
    │         POST /auth/login
    │              ↓
    │         LoginRequestContract
    │              ↓
    │         AuthProvider
    │              ↓
    │         AuthSessionContract
    │              ↓
    │         ContextResolver
    │              ↓
    │         CONTEXT_SELECTION_REQUIRED?
    │            ├─ SIM ──► Context Selection Experience (FRONT-002)
    │            └─ NÃO ──► Portal Enterprise
    │
    └─ SIM ──► Validar sessão
                   ↓
              AuthSessionContract
                   ↓
              ContextResolver
                   ↓
              CONTEXT_SELECTION_REQUIRED?
                 ├─ SIM ──► Context Selection Experience (FRONT-002)
                 └─ NÃO ──► Portal Enterprise
```

Regras do fluxo:

- Nenhuma regra de permissão é aplicada na Login Experience.
- Nenhum catálogo de aplicações é carregado na Login Experience.
- Nenhum widget é carregado na Login Experience.
- Nenhuma navegação é carregada na Login Experience.

---

## 4. Estados

A Login Experience possui os seguintes estados canônicos:

```text
UNAUTHENTICATED
AUTHENTICATING
AUTHENTICATED
SESSION_RESTORED
SESSION_EXPIRED
PASSWORD_EXPIRED
ACCOUNT_LOCKED
MFA_REQUIRED
ERROR
```

Transições válidas:

```text
UNAUTHENTICATED
    ↓ (submissão do formulário)
AUTHENTICATING
    ↓ (sucesso)
AUTHENTICATED
    ↓ (sessão anterior válida)
SESSION_RESTORED
    ↓ (qualquer falha)
ERROR
    ↓ (credenciais expiradas)
PASSWORD_EXPIRED
    ↓ (conta bloqueada)
ACCOUNT_LOCKED
    ↓ (MFA pendente)
MFA_REQUIRED
    ↓ (sessão válida removida)
SESSION_EXPIRED
```

Nenhum estado pode ser omitido ou substituído por valores ad-hoc.

---

## 5. Eventos

Eventos padronizados emitidos pela Login Experience:

```text
LOGIN_STARTED
LOGIN_SUCCEEDED
LOGIN_FAILED
SESSION_RESTORED
LOGOUT
SESSION_EXPIRED
```

Esses eventos são publicados no barramento de eventos da plataforma e estarão disponíveis para integração futura com o Event Store.

Nenhum evento específico de domínio (ex.: `HIS_LOGIN`, `FINANCEIRO_LOGIN`) pode ser criado na Login Experience.

---

## 6. Contratos

Todos os tipos são exclusivos de `packages/contracts`. Nenhum tipo pode ser declarado dentro da `LoginPage` ou de componentes da Login Experience.

### 6.1 Contratos existentes (consumidos)

```typescript
PersonContract
UserContract
AuthSessionContract
```

Local: `packages/contracts/src/auth/`, `packages/contracts/src/identity/`

### 6.2 Contratos novos (criar em `packages/contracts/src/auth/`)

```typescript
LoginRequestContract
LoginResponseContract
AuthenticationState
```

Definição conceitual — implementação exata fica a cargo da criação dos contratos:

```typescript
interface LoginRequestContract {
  username: string
  password: string
  tenant?: string
  mfaCode?: string
}

interface LoginResponseContract {
  authenticated: boolean
  session?: AuthSessionContract
  state: AuthenticationState
  message?: string
}

type AuthenticationState =
  | 'UNAUTHENTICATED'
  | 'AUTHENTICATING'
  | 'AUTHENTICATED'
  | 'SESSION_RESTORED'
  | 'SESSION_EXPIRED'
  | 'PASSWORD_EXPIRED'
  | 'ACCOUNT_LOCKED'
  | 'MFA_REQUIRED'
  | 'ERROR'
```

---

## 7. API

Toda comunicação de autenticação passa por `packages/api`. Nunca `fetch()`/`axios()` espalhado nas telas.

Contratos esperados pela camada `packages/api`:

```text
POST /auth/login
    Body: LoginRequestContract
    Return: LoginResponseContract

GET /auth/session
    Return: AuthSessionContract

POST /auth/logout
    Return: void

POST /auth/refresh
    Return: AuthSessionContract
```

Nenhuma referência a Stored Procedures pode aparecer em `packages/api` ou na Login Experience.

---

## 8. Runtime

O Runtime (`packages/runtime`) apenas consome o resultado do Auth.

Fluxo:

```text
AuthProvider
    ↓
SessionResolver
    ↓
AuthSessionContract
    ↓
PortalRuntimeEngine
    ↓
PortalRuntimeContract
```

O Login Experience não invoca `PortalRuntimeEngine` diretamente. O consumo do runtime é responsabilidade do `PortalRuntimeProvider`, conforme arquitetura canônica.

---

## 9. UX

Requisitos mínimos não-negociáveis:

- tela limpa e sem distrações;
- branding por Tenant;
- suporte a temas (`light` | `dark` | `tenant`);
- loading durante autenticação;
- mensagens de erro padronizadas;
- acessibilidade (navegação por teclado, leitores de tela);
- responsividade.

Não são definidos layout fixo, tipografia específica ou componentes visuais herdados. A implementação visual segue o guia de experiência canônico FRONT-000.

---

## 10. Critérios de Aceitação

A Login Experience é aprovada somente quando:

- Login restaura sessão existente automaticamente;
- nenhum token é armazenado no frontend;
- todo acesso passa pelo `AuthProvider`;
- Login funciona independentemente de módulo de negócio;
- contexto não é resolvido na Login Experience;
- permissões não são avaliadas na Login Experience;
- a implementação respeita os estados canônicos;
- todos os tipos vêm de `packages/contracts`.

---

## 11. Critérios de Rejeição

O KILO rejeita implementações que:

- usem `localStorage` ou `sessionStorage` para tokens;
- acessem banco diretamente;
- chamem Stored Procedures do frontend;
- implementem lógica de contexto no Login;
- implementem permissões no Login;
- acoplem a tela de Login ao Portal ou a qualquer módulo de domínio;
- declarem tipos dentro da `LoginPage` ou de componentes da Login Experience;
- ignorem `packages/api` e chamem `fetch()`/`axios()` diretamente;
- utilizem eventos específicos de domínio.

---

## 12. Dependências

### Permitidas

```text
packages/contracts
packages/api
packages/auth
packages/runtime
```

### Proibidas

```text
apps/his
apps/workforce
apps/displays
apps/management
database/
modules/
```

---

## Integrações

| FRONT / MD | Finalidade |
|---|
| FRONT-000 — Frontend Platform Architecture Constitution | Constituição |
| MD-020 — Portal Core | Núcleo do Portal |
| MD-123 — Portal Canonical Experience | Experiência do Portal |
| MD-120 — Party Identity Architecture | Identidade |
| MD-124 — Context First Architecture | Contexto |
| FRONT-002 — Context Selection Experience | Seleção de contexto |

---

*Última atualização: 2026-07-07*

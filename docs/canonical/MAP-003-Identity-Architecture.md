# MAP-003 — Identity Architecture

## Status
Documento Canônico de Arquitetura.
Arquitetura de identidade e autorização do Midas.

---

## Classificação
```text
Tipo: Foundation Architecture
Camada: Plataforma
Prioridade: Crítica
Obrigatoriedade: Global
```

---

## Objetivo
Definir a arquitetura oficial de identidade, autenticação, autorização e contexto operacional do Midas.

---

## Entidades Canônicas

### User
```text
user_id (UUID)
tenant_id
organization_id
unit_id
email
phone
name
status
created_at
updated_at
```

### Role
```text
role_id (UUID)
tenant_id
name
description
type (system/business/custom)
priority
```

### Permission
```text
permission_id (UUID)
tenant_id
resource
action
scope
```

### Policy
```text
policy_id (UUID)
tenant_id
name
rules (JSON)
effect (allow/deny)
```

### Session
```text
session_id (UUID)
user_id
tenant_id
context_json
expires_at
ip_address
user_agent
```

### Context
```text
tenant_id
organization_id
unit_id
sector_id
location_id
profile_id
```

---

## Lei Canônica MAP-003-001
```text
Identidade ≠ Contexto Operacional.
```

---

## Lei Canônica MAP-003-002
```text
Usuário existe no tenant.
Contexto existe na sessão.
```

---

## Lei Canônica MAP-003-003
```text
Autenticação valida identidade.
Autorização valída contexto.
```

---

## Modelo RBAC + ABAC Híbrido

### RBAC
Relaciona usuário ao papel:
```text
user → role → permission
```

### ABAC
Atributos dinâmicos:
```text
tenant_id
unit_id
sector_id
time_of_day
day_of_week
```

---

## Fluxo de Autenticação

### Login
```text
1. Validar credenciais
2. Buscar identidade
3. Montar contexto
4. Gerar token/session
5. Retornar contexto
```

### Session Check
```text
1. Validar session_id
2. Verificar expiração
3. Carregar contexto
4. Verificar permissões
5. Permitir acesso
```

---

## Fluxo de Autorização

### Verificação
```text
1. Receber requisição
2. Extrair tenant_id
3. Extraír user_id
4. Verificar role
5. Verificar permission
6. Aplicar policy ABAC
7. Decidir allow/deny
```

---

## Token Strategy

### JWT Structure
Header:
```text
alg: HS256/RS256
typ: JWT
```

Payload:
```text
sub: user_id
tid: tenant_id
ctx: {organization_id, unit_id}
roles: [role_id, ...]
permissions: [permission_id, ...]
exp: timestamp
iat: timestamp
```

---

## HttpOnly Cookies

### Cookie Names
```text
midas_session (session_id)
midas_context (encrypted context)
midas_csrf (csrf_token)
```

### Security Flags
```text
HttpOnly: true
Secure: true
SameSite: Strict
Path: /
```

---

## SSO Integration

### Providers
```text
Microsoft Entra ID
Google Workspace
SAML
OIDC
LDAP
```

### Mapping
```text
Provider User → Midas User
Provider Group → Midas Role
Provider Permission → Midas Permission
```

---

## MFA Strategy

### Factors
```text
Email OTP
SMS OTP
Authenticator App
Hardware Key
Biometrics
```

### Enforcement
```text
Admin enforced
Role based
Context sensitive
```

---

## Identity Provider Pattern

### Internal IdP
Para tenants que não usam SSO externo.

### External IdP
Para integração com provedores externos.

### Hybrid IdP
Para migração gradual.

---

## Database Schema

### users
```text
user_id (PK)
tenant_id (FK)
email (unique)
password_hash
name
status
mfa_enabled
created_at
```

### user_roles
```text
user_id (FK)
role_id (FK)
tenant_id (FK)
assigned_at
```

### roles
```text
role_id (PK)
tenant_id (FK)
name
type
priority
```

### permissions
```text
permission_id (PK)
tenant_id (FK)
resource
action
scope
```

### role_permissions
```text
role_id (FK)
permission_id (FK)
```

### policies
```text
policy_id (PK)
tenant_id (FK)
name
rules
effect
priority
```

---

## Eventos Oficiais

### UserCreated
Novo usuário criado

### UserAuthenticated
Autenticação bem-sucedida

### UserUnauthorized
Tentativa de acesso negada

### SessionCreated
Sessão iniciada

### SessionExpired
Sessão expirada

### SessionTerminated
Sessão terminada

---

## APIs Oficiais

### /api/v1/auth/login
POST - Autenticar usuário

### /api/v1/auth/logout
POST - Terminar sessão

### /api/v1/auth/refresh
POST - Renovar token

### /api/v1/auth/context
GET - Obter contexto atual

### /api/v1/users/{id}/roles
GET - Listar papéis

### /api/v1/roles/{id}/permissions
GET - Listar permissões

---

## Stored Procedures

### sp_auth_login
Autenticação completa com validação

### sp_auth_check_permission
Verificação de permissão contextual

### sp_auth_load_context
Carregar contexto da sessão

### sp_user_assign_role
Atribuir papel ao usuário

### sp_role_grant_permission
Conceder permissão ao papel

---

## Cache Strategy

### Session Cache
Redis por tenant com TTL

### Permission Cache
Cache por role combinando com ABAC

### User Cache
Cache curto para dados do usuário

---

## Security Controls

### Brute Force Protection
```text
Rate limiting
Account lockout
IP blocking
```

### Session Security
```text
Concurrent session limit
Session hijacking detection
Context change detection
```

---

## Integrações
| MAP/MD | Finalidade |
|--------|-----------|
| MAP-002 — Tenant Architecture | Tenant |
| MD-098 — Risk Management | Security |
| MD-086 — Digital Identity Wallet | Identity |
| FRONT-001 — Login Experience | Login UX |
| FRONT-081 — Identity Access | IAM UX |
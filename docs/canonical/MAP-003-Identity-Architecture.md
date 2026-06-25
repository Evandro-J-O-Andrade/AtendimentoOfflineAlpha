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

## Leis Canônicas Globais Aplicáveis

### LC-001 — Portal é a Entrada Oficial
```text
Portal é a entrada oficial da plataforma.
Fluxo: Login → Portal → Container/App → Contexto Operacional → Dashboard → Operação
```

### LC-002 — Identity ≠ Operational Context
```text
Identity responde: Quem é você?
Contexto responde: Onde você está operando?
```

### LC-003 — Toda Operação Depende de Contexto Ativo
```text
Session → Context → Authorization → Operation
```

### LC-004 — JWT não é Fonte da Verdade
```text
JWT é mecanismo de transporte.
Fonte da Verdade: Database + Session Store
Estratégia: HttpOnly Cookie
Proibido: localStorage, sessionStorage
```

### LC-005 — SP First Architecture
```text
Frontend → API → Service → Dispatcher → Stored Procedure → Database
Nunca CRUD direto.
```

### LC-006 — Tenant First
```text
Toda operação executa dentro de tenant.
Tenant é fronteira máxima de dados.
```

### LC-007 — LGPD First
```text
Toda entidade deve possuir:
Finalidade, Consentimento, Retenção, Auditoria, Anonimização
```

### LC-008 — Audit First
```text
Toda ação crítica gera evento e auditoria.
Toda operação é rastreável.
```

### LC-009 — IA é Transversal
```text
AI Core atravessa toda plataforma.
Portal AI, HIS AI, CRM AI, RH AI, Finance AI, Analytics AI, Workflow AI.
IA não é módulo isolado.
```

### LC-010 — Dispatcher Layer é Obrigatório
```text
Controller → Application Service → Dispatcher → Stored Procedure → Database
Dispatcher orquestra, SP executa.
```

### LC-011 — Dashboard por Domínio
```text
HIS: Dashboard Assistencial
CRM: Dashboard Comercial
RH: Dashboard Pessoas
Financeiro: Dashboard Financeiro
Farmácia: Dashboard Farmacêutico
Analytics: Dashboard Executivo
```

### LC-012 — Senha é Núcleo Operacional
```text
Senha é o núcleo operacional assistencial.
Fluxo: Senha → Fila → FFA → Atendimento → Execução → Farmácia → Faturamento
```

### LC-013 — Application Registry é Obrigatório
```text
Nenhum módulo existe sem registro.
Registro mínimo: ID, Nome, Domínio, Permissões, Rotas, Versão, Owner
Portal não conhece apps diretamente.
Sempre via Registry.
```

### LC-014 — Portal = Hub Corporativo
```text
Portal não é dashboard.
Portal não é intranet.
Portal é o orquestrador da experiência.
Portal consolida: Intranet, Chat, AVA, Analytics, Documentos, CRM, HIS, RH
```

### LC-015 — Intranet é Aplicação
```text
Intranet = Aplicação
Chat = Aplicação
AVA = Aplicação
HIS = Aplicação
CRM = Aplicação
RH = Aplicação
Financeiro = Aplicação
```

### LC-016 — AI Command Center
```text
Governando prompts, agentes, custos, tokens, modelos, execuções, treinamentos, knowledge base.
```

### LC-017 — Cada Domínio Possui Dashboard
```text
Todo domínio possui dashboard próprio.
Dashboard é entrada do domínio.
```

### LC-018 — Context Architecture Layer
```text
Identity Layer → Portal Layer → Application Layer → Operational Context Layer → Domain Dashboard Layer → Operational Layer
Contexto não acontece antes do Portal.
```

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
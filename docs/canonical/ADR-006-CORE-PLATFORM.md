# ADR-006-CORE-PLATFORM.md
# ADR-006 — CORE Platform Decision

> Status do ADR:
> - DRAFT: ✅ Concluído
> - REVIEW: ✅ Concluído
> - APPROVED: ✅ Aprovado em 2026-07-07
> - IMPLEMENTING: 🚀 Iniciado — KILO ENGINE v8 — CORE Platform Implementation
>
> Fase: KILO ENGINE v7.1
> Fontes: AUTH_CORE_COVERAGE.md, ADR-006-Database-Evolution.md, MD-100, MD-101, MD-102, MD-103, MD-104, MD-105, MD-108, MD-120, MD-123, MD-124, FRONT-000/001/002/003/004/005, Dump20260618.sql
> Regra: ADR-006-Database-Evolution.md — dump é somente leitura; ausências geram PROPOSED em database/migrations/proposed/

---

## 1. Objetivo

Transformar todos os gaps AUTH/CORE identificados em AUTH_CORE_COVERAGE.md em decisões arquiteturais aprovadas, sem criar código, SQL ou endpoints.

---

## 2. Classificação REUSE

Objetos já existentes no dump e compatíveis com os conceitos canônicos.

### 2.1 Pessoa
- Dump: `pessoa`
- Decisão: REUSE
- Motivo: representa a identidade natural já prevista em MD-120 Party Identity Architecture.
- Frontend: `PersonContract` já previsto.
- Backend: consumir diretamente pela camada de API/identity.

### 2.2 Usuário
- Dump: `usuario`
- Decisão: REUSE
- Motivo: representa a identidade de autenticação/sistema já prevista em MD-120.
- Frontend: `UserContract` já previsto.
- Backend: consumir diretamente pela camada de API/identity.

### 2.3 Tenant
- Dump: `tenant_registry`
- Decisão: REUSE
- Motivo: já existe no dump com vínculo a entidade/sistema.
- Frontend: `TenantContract` já previsto.
- Backend: expor via contexto de sessão.

### 2.4 Unidade
- Dump: `unidade`
- Decisão: REUSE
- Motivo: tabela existente no dump.
- Frontend: parte de Context/Tenant.
- Backend: consumir diretamente.

### 2.5 Sessão
- Dump: `sessao_usuario`
- Decisão: REUSE
- Motivo: tabela já mapeada no dump com chaves para usuario/unidade/local/perfil e expiração.
- Frontend: `AuthSessionContract` já previsto.
- Backend: manter como base de sessão real.

### 2.6 Permissão / Perfil
- Dump: `permissao`, `perfil`, `perfil_permissao`
- Decisão: REUSE
- Motivo: tabelas existentes com relacionamento canônico.
- Frontend: `ApplicationContract.permission`, `NavigationItemContract.permission` já previstos.
- Backend: consumir pela camada de permissionamento.

---

## 3. Classificação ADAPT

Objetos existentes, mas necessitam camada de contrato/API/runtime para não expor legado diretamente ao frontend.

### 3.1 Contexto operacional
- Dump: `contexto_atendimento`, `usuario_contexto`
- SPs: `sp_auth_contexto_get`, `sp_auth_contexto_set`, `sp_sessao_contexto_get`, `sp_sessao_contexto_set`, `sp_contexto_assert_permissao`, `sp_contexto_assert_transicao`
- Decisão: ADAPT
- Motivo: objeto existe, mas precisa ser servido via API canônica `/context/*` e normalizado em `ContextContract`/`ContextSelectionContract`.
- Frontend: `ContextGuard` + `ContextSelectionPage` já previstos em FRONT-002.
- Backend: criar endpoints `/auth/context/me`, `/auth/context/available`, `/auth/context/select`.

### 3.2 Menu/Navigation metadata
- Dump: `permissao`, `perfil_permissao`, `perfil`, `usuario_perfil`
- SP: `sp_auth_menu_get`
- Decisão: ADAPT
- Motivo: legado já monta JSON de módulos/acoes, mas expor diretamente viola a camada de API canônica.
- Frontend: `NavigationContract`, `NavigationItemContract` já previstos.
- Backend: endpoint `/portal/navigation` consumindo `sp_auth_menu_get` e mapeando para contratos.

### 3.3 Sessão auth
- Dump: `auth_sessao`, `auth_token`, `sessao_usuario`, `sessao_ativa`, `sessao_evento`, `auth_tentativa_login`, `usuario_refresh`
- SPs: `sp_master_login`, `sp_sessao_abrir`, `sp_sessao_assert`
- Decisão: ADAPT
- Motivo: estruturas existentes, mas a plataforma canônica espera sessão normalizada em `AuthSessionContract`.
- Frontend: `AuthProvider`, `SessionResolver`, `AuthApi` já previstos.
- Backend: endpoints `/auth/login`, `/auth/session`, `/auth/logout`, `/auth/refresh`.

### 3.4 Branding por tenant
- Dump: nenhuma tabela específica identificada para branding
- Decisão: ADAPT com possível PROPOSE downstream
- Motivo: `sp_auth_menu_get` não inclui branding.
- Frontend: `BrandingContract` já previsto.
- Backend: inicialmente extrair branding de metadata existente ou fallback; se não houver, propor nova entidade em migrations/proposed.

### 3.5 Application Registry metadata
- Dump: nenhuma tabela específica identificada para registry/app metadata
- Decisão: ADAPT inicial + PROPOSE se ausente
- Motivo: conceito de `ApplicationContract` é novo frente ao dump.
- Frontend: `ApplicationContract`, `WidgetContract`, `DashboardContract`, `ManagementContract` já previstos.
- Backend: se não existir entidade equivalente, propor registry em migrations/proposed; enquanto isso, endpoints podem retornar defaults/mocks controlados por backend.

---

## 4. Classificação PROPOSE

Somente itens inexistentes no dump e necessários à arquitetura canônica.

### 4.1 Nenhum item PROPOSE obrigatório nesta fase
- Após auditoria do dump, nenhuma tabela/SP crítica do núcleo AUTH/CORE está ausente.
- Todos os fluxos canônicos de Login, Contexto, Sessão e Permissão têm representação no legado.
- Registries de metadata de Portal podem ser futuramente propostos, mas não bloqueiam o núcleo CORE.

### 4.2 PROPOSTAS CONDICIONAIS (futuras, não obrigatórias)
- **AUTH-CORE-004**: se branding por tenant não puder ser derivado de entidade existente, propor tabela `tenant_branding` via ADR-006 em `database/migrations/proposed/`.
- **AUTH-CORE-005**: se dashboard metadata não for derivada de registry configurado existente, propor tabela/entidade de dashboard metadata via ADR-006 em `database/migrations/proposed/`.
- Essas propostas não são obrigatórias para fechar Login, Context e Portal.

---

## 5. Matriz de decisão

| Item | Dump | SP | Decisão | Documento relacionado | Impacto Frontend | Impacto Backend |
|------|------|----|---------|------------------------|------------------|-----------------|
| Pessoa | REUSE | — | REUSE | MD-120, PersonContract | PersonContract | API identity |
| Usuário | REUSE | — | REUSE | MD-120, UserContract | UserContract | API identity |
| Tenant | REUSE | — | REUSE | MD-107, TenantContract | TenantContract | API context |
| Unidade | REUSE | — | REUSE | MD-108, ContextContract | ContextContract | API context |
| Sessão | REUSE | sp_sessao_abrir, sp_sessao_assert | ADAPT | FRONT-001, AuthSessionContract | AuthProvider, SessionResolver | POST /auth/login, GET /auth/session |
| Contexto | REUSE | sp_auth_contexto_get/set | ADAPT | FRONT-002, ContextContract | ContextSelectionPage | GET/POST /auth/context |
| Navigation | ADAPT | sp_auth_menu_get | ADAPT | FRONT-003, NavigationContract | Portal Enterprise | GET /portal/navigation |
| Branding | ADAPT | — | ADAPT/PROPOSE | FRONT-003, BrandingContract | EnterpriseShell | GET /portal/branding |
| Registry Metadata | ADAPT | — | ADAPT/PROPOSE | FRONT-004/005 | ApplicationLauncher/Dashboard | GET /portal/applications, /dashboard/* |
| HIS/Domain | fora do escopo | fora do escopo | — | FRONT-003 Rejeição | Nenhum | Nenhum |

---

## 6. Regras operacionais

1. Nenhuma tabela/SP do CORE será criada sem decisão aprovada neste ADR.
2. Endpoints CORE seguirão exclusivamente a ordem:
   - `/auth/login`
   - `/auth/session`
   - `/auth/logout`
   - `/auth/refresh`
   - `/auth/context`
   - `/portal/navigation`
   - `/portal/branding`
   - `/portal/applications`
   - `/dashboard/*`
3. Nenhum endpoint de domínio (HIS, Workforce, Displays, Financeiro, etc.) será implementado antes do fechamento do CORE.
4. Qualquer ausência nova identificada após este ADR deve gerar proposta em `docs/canonical/` antes da implementação.

---

## 7. Pendência formal

- Aguardando aprovação deste ADR pelo responsável pela arquitetura.
- Após aprovação, iniciar implementação dos endpoints CORE na ordem definida.
- Nada além do CORE deve ser implementado enquanto este ADR estiver em aberto.

---

*Última atualização: 2026-07-07*

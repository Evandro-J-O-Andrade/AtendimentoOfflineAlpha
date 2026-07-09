# AUTH_CORE_COVERAGE — Auditoria CORE

Modo: AUDIT ONLY  
Fase: KILO ENGINE v7.1  
Escopo: AUTH + CORE  
Fontes: database/dump/Dump20260618.sql, docs/canonical, packages/contracts, packages/api, packages/auth, packages/runtime, apps/portal  
Status: EOL — documento rastreado; delays não devem reabrir este ciclo

---

## 1. Objetivo

Mapear o caminho real do núcleo da plataforma:

```text
Login
    ↓
Sessão
    ↓
Pessoa
    ↓
Usuário
    ↓
Tenant
    ↓
Contexto
    ↓
Permissão
```

Gerar cobertura entre legado e arquitetura canônica, sem criar código novo.

---

## 2. Escopo

Auditado:

* dump MySQL congelado `Dump20260618.sql`
* documentos canônicos em `docs/canonical/`
* contratos em `packages/contracts`
* API em `packages/api`
* auth em `packages/auth`
* runtime em `packages/runtime`
* app `portal`

Não alterado:

* contratos
* APIs
* runtime
* telas
* banco

---

## 3. Tabelas CORE auditadas no dump

Todas as tabelas abaixo existem no dump e são necessárias para AUTH/CORE:

* `usuario`
* `pessoa`
* `perfil`
* `permissao`
* `usuario_perfil`
* `tenant_registry`
* `unidade`
* `contexto_atendimento`
* `usuario_contexto`
* `sistema`
* `sessao_usuario`
* `sessao_ativa`
* `sessao_evento`
* `sessao_contexto_historico`
* `auth_sessao`
* `auth_token`
* `auth_sessao_dispositivo`
* `auth_tentativa_login`
* `usuario_refresh`
* `usuario_local`
* `usuario_unidade`
* `usuario_sistema`
* `usuario_sistema_acl_evento`
* `usuario_profissional_registro`

---

## 4. Chaves e relacionamentos relevantes

Chaves diretas observadas no dump:

* `auth_sessao.id_usuario -> usuario.id_usuario`
* `auth_token.id_usuario -> usuario.id_usuario`
* `sessao_usuario.id_usuario -> usuario.id_usuario`
* `usuario_perfil.id_usuario -> usuario.id_usuario`
* `usuario_perfil.id_perfil -> perfil.id_perfil`
* `perfil_permissao.id_perfil -> perfil.id_perfil`
* `perfil_permissao.id_permissao -> permissao.id_permissao`
* `usuario_unidade.id_usuario -> usuario.id_usuario`
* `usuario_unidade.id_unidade -> unidade.id_unidade`
* `usuario_local.id_usuario -> usuario.id_usuario`
* `usuario_local.id_unidade -> unidade.id_unidade`
* `usuario_contexto.id_usuario -> usuario.id_usuario`
* `usuario_contexto.id_unidade -> unidade.id_unidade`
* `tenant_registry` vinculado a entidade/sistema em múltiplas tabelas

---

## 5. SPs CORE descobertas

As SPs abaixo existem no dump e são diretamente relacionadas ao fluxo AUTH/CORE:

* `sp_master_login`
* `sp_sessao_abrir`
* `sp_sessao_assert`
* `sp_sessao_contexto_get`
* `sp_sessao_contexto_set`
* `sp_auth_contexto_get`
* `sp_auth_contexto_set`
* `sp_auth_menu_get`
* `sp_permissao_validar`
* `sp_permissao_assert`
* `sp_contexto_assert_permissao`
* `sp_contexto_assert_transicao`

---

## 6. Call graph CORE

```text
Login
    ↓
sp_master_login
    ↓
sessao_usuario
    ↓
sp_sessao_assert
    ↓
usuario_perfil + perfil_permissao + permissao
    ↓
sp_permissao_validar / sp_permissao_assert
    ↓
sp_auth_contexto_get
    ↓
usuario_unidade + unidade + usuario_perfil + perfil + usuario_local + local
    ↓
sp_auth_contexto_set
    ↓
sessao_usuario + usuario_contexto + auditoria_evento
    ↓
sp_sessao_contexto_get
    ↓
sessao_usuario
```

Fluxo do dispatcher/executor:

```text
sp_master_dispatcher
    ↓
sessao_usuario
    ↓
permissao
    ↓
sp_gatekeeper_assistencial
    ↓
sp_orquestrador_assistencial
    ↓
sp_fluxo_guardiao_transicao
    ↓
sp_fluxo_executor_matriz
    ↓
sp_executor_*
```

---

## 7. Contratos CORE existentes

Contratos canônicos atuais em `packages/contracts`:

* `PersonContract`
* `UserContract`
* `AuthSessionContract`
* `TenantContract`
* `ContextContract`
* `ContextSelectionContract`
* `LoginRequestContract`
* `LoginResponseContract`
* `AuthenticationState`
* `PortalRuntimeContract`

---

## 8. Gaps

* `AuthApi` ainda não consome SPs reais; endpoints `/auth/login`, `/auth/session`, `/auth/logout`, `/auth/refresh` são placeholders.
* `ContextSelectionPage` ainda mockada; não há integração com `sp_auth_contexto_get` / `sp_auth_contexto_set`.
* `PortalRuntimeComposer` ainda mockado; metadata do Portal não é originada de SP real.
* Nenhum contrato/runtime frontend cobre:
  * metadata do Portal
  * menu dinâmico
  * branding por tenant
  * dashboard metadata
* SPs `sp_master_login`, `sp_sessao_abrir` e `sp_auth_menu_get` existem, mas ainda não são referenciadas por contratos/API.

---

## 9. Propostas ADR-006

Propostas pendentes, sem criação de código:

1. **AUTH-CORE-001**  
   Mapear endpoints `/auth/login`, `/auth/session`, `/auth/logout`, `/auth/refresh` para `sp_master_login`, `sp_sessao_assert` e tabelas `sessao_usuario` / `auth_token`.

2. **AUTH-CORE-002**  
   Mapear `/context/available` para `sp_auth_contexto_get` e `/context/select` para `sp_auth_contexto_set`.

3. **AUTH-CORE-003**  
   Mapear `/portal/menu` para `sp_auth_menu_get` e normalizar retorno JSON em contratos `NavigationContract`.

4. **AUTH-CORE-004**  
   Introduzir `TenantBrandingContract` e mapear origem de branding por tenant.

5. **AUTH-CORE-005**  
   Mapear dashboard metadata para SP/entidade própria ou registry configurada.

---

## 10. Status canônico

| Camada | Status |
|--------|--------|
| Banco CORE | Mapeado |
| SPs CORE | Existentes |
| Contratos CORE | Parciais |
| API CORE | Placeholder |
| Runtime CORE | Mock |
| Frontend CORE | Mock + estrutura |

Próxima ação canônica:

Fechar `AUTH-CORE-001`..`AUTH-CORE-005` via ADR-006 antes de conectar qualquer módulo de domínio.

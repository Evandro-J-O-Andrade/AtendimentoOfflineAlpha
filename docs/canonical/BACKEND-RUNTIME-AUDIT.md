# BACKEND-RUNTIME-AUDIT

```text
Tipo:           Auditoria de GATE (camada de serviços)
Status:         READ ONLY
Origem:         Backend (src/core) + Banco Vivo (bancoMysql.md) + Canon
Classificação:  REUSE / ADAPT / PROPOSE
Implementação:  NÃO
```

> Conecta o código do Backend ao Banco Vivo e ao Canon. Para cada serviço: responsabilidade
> atual, SPs utilizadas, divergências e busca de equivalente no Kernel. Regra aplicada: **sempre
> procurar por similar / papel equivalente no Banco Vivo antes de PROPOSE**. Vinculado a
> `GATE-RUNTIME-CHAIN`, `GATE-CONTEXT-RESOLVER` e `CONTEXT-RESOLUTION-FLOW`.

## Visão geral dos serviços

| Serviço | Existe? | SPs chamadas | Kernel consumido? |
|---|---|---|---|
| `AuthService` | ✅ | `sp_master_login`, `sp_sessao_contexto_get`, `sp_auth_contexto_get`, `sp_auth_contexto_set` (mais SQL direto) | Parcial |
| `PortalService` | ✅ | `sp_auth_menu_get` | Não (descarta tenant/contexto) |
| `PermissionService` | ✅ | `sp_auth_permissions_evaluate` (ausente no banco) | Não (SP inexistente) |
| `SessionService` | ❌ | — | — |
| `RuntimeService` | ❌ | — | — (Kernel órfão de consumo) |
| `ContextResolver` | ❌ | — | — (lógica espalhada em Auth/Portal) |

## AuthService (`src/core/auth/AuthService.ts`)

- **Responsabilidade atual:** login, sessão, contexto.
- **SPs utilizadas:** `sp_master_login` (11), `sp_sessao_contexto_get` (87), `sp_auth_contexto_get` (108), `sp_auth_contexto_set` (128).
- **Divergências:**
  - `authenticate()` faz **SQL direto** `SELECT id_usuario, senha, ativo FROM usuario` (59) e emite JWT próprio via `jsonwebtoken` — **bypass do Kernel** (`sp_master_login`). Viola SP-First e "IA não acessa SQL diretamente".
  - `session()` mapeia `id_entidade ← id_sistema` (97) — **erro semântico de tenant** (id_sistema ≠ id_entidade).
  - `login()` lê `id_saas_entidade` (40) — nome possivelmente inexistente no retorno do `sp_master_login` (banco usa `id_entidade`).
  - `session()` lê `id_local_operacional` (99) — espelha o bug de `sp_sessao_contexto_get` (coluna inexistente em `sessao_usuario`).
- **Equivalente no Banco Vivo:** `sp_master_login` + `sp_sessao_assert` + `sp_auth_contexto_*` já cobrem login/sessão/contexto.
- **Classificação:** ADAPT (consolidar `authenticate` em `sp_master_login`; corrigir mapeamento id_entidade/id_local).

## PortalService (`src/core/portal/PortalService.ts`)

- **Responsabilidade atual:** navegação, aplicações, branding, runtime do portal.
- **SPs utilizadas:** `sp_auth_menu_get` (10).
- **Divergências:**
  - `runtime()` retorna **`tenant: null, context: null`** (92–95) — **descarta tenant/contexto**. É o "bloqueio" do Discovery Runtime.
- **Equivalente no Banco Vivo:** `sp_sessao_assert` + `sp_auth_contexto_get` retornam tenant/contexto; basta consumi-los.
- **Classificação:** ADAPT (popular tenant/contexto a partir da sessão resolvida).

## PermissionService (`src/core/permissions/PermissionService.ts`)

- **Responsabilidade atual:** avaliar/afirmar permissões.
- **SPs utilizadas:** `sp_auth_permissions_evaluate` (9).
- **Divergências:**
  - `sp_auth_permissions_evaluate` **NÃO EXISTE no Banco Vivo** (CORE-005, AUSENTE). Chamada falharia em runtime. Código está à frente do banco.
- **Equivalente no Banco Vivo:** `sp_sessao_assert(p_id_sessao, p_permissao)` valida permissão por código (REUSE); `sp_guardiao_runtime_assert` cobre runtime.
- **Classificação:** EXTEND / PROPOSE (materializar `sp_auth_permissions_evaluate` via CORE-005 antes de consumir).

## SessionService / RuntimeService / ContextResolver (ausentes)

- **Busca de equivalente no Banco Vivo:** Não há classes; o papel de Runtime/Contexto já está materializado no Kernel (`sp_dispatcher_kernel`, `sp_guardiao_runtime_assert`, `sp_sessao_assert`, `sp_auth_contexto_*`).
- **Classificação:** ADAPT (concentrar a resolução de contexto num `ContextResolver` que **reutiliza** essas SPs — não criar RuntimeService paralelo).

## CONCLUSÃO

```text
REUSE    0   (nenhum serviço consome o Kernel de Runtime/Guardião corretamente hoje)
ADAPT    4   (AuthService tenant/id_local · PortalService tenant/context null · ContextResolver concentrar · Guardian/Dispatcher conectar)
EXTEND   1   (sp_auth_permissions_evaluate — CORE-005)
PROPOSE  0   (sem novo componente; tudo já existe no Kernel)

DECISÃO
Backend hoje NÃO é consumidor disciplinado do Kernel: faz SQL direto, descarta tenant/contexto,
chama SP ausente e não usa Guardian/Dispatcher. Adaptar para consumir o Kernel existente
(ver BACKEND-CONTEXT-ADAPT-PLAN). Nenhum SQL novo; nenhum serviço novo.
```

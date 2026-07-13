# GATE-BACKEND-RUNTIME

```text
Status:  READ ONLY
Tipo:    Validação Arquitetural (contrato de aceitação do ADAPT)
Origem:  Banco Vivo (bancoMysql.md) · Canon · Backend (src/core)
```

> Não valida código; valida **comportamento arquitetural**. Pergunta do GATE:
> **"O Backend consome o Kernel Runtime exatamente como definido pelo Banco Vivo?"**
> Vinculado a `GATE-RUNTIME-CHAIN`, `GATE-CONTEXT-RESOLVER`, `CONTEXT-RESOLUTION-FLOW`,
> `BACKEND-RUNTIME-AUDIT` e `BACKEND-CONTEXT-ADAPT-PLAN`.

## Bloco 1 — Cadeia obrigatória

| Elo | Existe | Conforme | Classificação | Evidência |
| --- | --- | --- | --- | --- |
| Cliente → AuthService | ✅ | ⚠️ | REUSE/ADAPT | `AuthService.ts:9` |
| `sp_master_login` | ✅ | ⚠️ | ADAPT | `bancoMysql.md:25668` (não popula `id_entidade`/`id_unidade`) |
| `sessao_usuario` | ✅ | ✅ | REUSE | `bancoMysql.md:14785` |
| `sp_auth_contexto_get` | ✅ | ✅ | REUSE | `bancoMysql.md:17380` |
| `sp_auth_contexto_set` | ✅ | ✅ | REUSE | `bancoMysql.md:17479` |
| `sp_sessao_assert` | ✅ | ✅ | REUSE | `bancoMysql.md:32115` (Backend **não chama**) |
| `sp_guardiao_runtime_assert` | ✅ | ❌ | REUSE | `bancoMysql.md:22696` (Backend **não chama**) |
| `sp_dispatcher_kernel` | ✅ | ❌ | REUSE | `bancoMysql.md:18834` (Backend **não chama**) |
| `sp_executor_*` | ✅ | ❌ | REUSE | `bancoMysql.md:19732` (Backend **não chama**) |
| Banco | ✅ | ✅ | REUSE | — |

## Bloco 2 — Consumo do Kernel (checklist)

```text
□ Backend nunca autentica fora do Kernel        ❌ (AuthService.authenticate SQL direto :59)
□ Backend nunca resolve ACL sozinho             ⚠️
□ Backend nunca consulta permissões diretamente  ❌ (SELECT usuario.senha :59)
□ Backend usa sp_sessao_assert                  ❌ (não invocado)
□ Backend usa Guardian                          ❌ (sp_guardiao_runtime_assert não invocado)
□ Backend usa Dispatcher                        ❌ (sp_dispatcher_kernel não invocado)
□ Backend nunca executa Executor diretamente     ✅
□ Backend nunca acessa Registry diretamente      ✅ (registry inexistente)
□ Backend nunca mantém contexto próprio         ⚠️ (PortalService zera; AuthService id_local_operacional)
□ Backend nunca duplica sessão                   ✅
```

## Bloco 3 — Divergências

```text
Objeto:      AuthService.authenticate
Situação:    SQL direto em usuario + JWT próprio (bypass do Kernel)
Kernel:      sp_master_login
Classificação: ADAPT
Prioridade:  ALTA
Impacto:     CORE-001 · CORE-005 · Discovery

Objeto:      AuthService.session (id_entidade ← id_sistema)
Situação:    mapeia tenant de id_sistema (erro semântico)
Kernel:      sp_sessao_assert (retorna id_entidade correto)
Classificação: ADAPT
Prioridade:  ALTA
Impacto:     Context Resolver · Discovery

Objeto:      AuthService.session (id_local_operacional)
Situação:    lê coluna inexistente em sessao_usuario
Kernel:      sp_sessao_contexto_get (id_local)
Classificação: ADAPT
Prioridade:  MÉDIA
Impacto:     Context Resolver

Objeto:      PortalService.runtime
Situação:    retorna tenant: null, context: null
Kernel:      sp_sessao_assert + sp_auth_contexto_get
Classificação: ADAPT
Prioridade:  ALTA
Impacto:     Discovery Runtime

Objeto:      PermissionService.evaluate
Situação:    chama sp_auth_permissions_evaluate (ausente no banco)
Kernel:      sp_sessao_assert(p_permissao) · sp_guardiao_runtime_assert
Classificação: EXTEND / PROPOSE (CORE-005)
Prioridade:  ALTA
Impacto:     CORE-005

Objeto:      Guardian / Dispatcher
Situação:    não consumidos pelo Backend (Kernel órfão de consumo)
Kernel:      sp_guardiao_runtime_assert · sp_dispatcher_kernel
Classificação: ADAPT
Prioridade:  ALTA
Impacto:     Infrastructure Runtime
```

## Bloco 4 — Bloqueadores

```text
BLOCKER-001
  Tenant não resolvido
  Origem:    sp_master_login (não popula id_entidade/id_unidade) + AuthService.session (id_entidade←id_sistema)
  Impacto:   Portal Runtime · Discovery
  Classificação: ADAPT

BLOCKER-002
  Guardian / Dispatcher órfãos
  Origem:    Backend não invoca sp_guardiao_runtime_assert / sp_dispatcher_kernel
  Impacto:   Runtime Authorization
  Classificação: ADAPT

BLOCKER-003
  sp_auth_permissions_evaluate ausente
  Origem:    CORE-005 (ADR existe; SP não materializada)
  Impacto:   PermissionService
  Classificação: EXTEND / PROPOSE
```

## Bloco 5 — Critérios de aceite

```text
ACCEPTED  quando:
  Backend → não possui bypass → usa Kernel → usa Guardian → usa Dispatcher
          → usa Context Resolver → não duplica Runtime

REJECTED  se qualquer critério falhar (status atual: REJECTED — blockers presentes)
```

## Índice de Aderência ao Kernel (Kernel Compliance)

| Componente | Aderência | Evidência |
| --- | ---: | --- |
| AuthService | 35% | SQL direto `:59`; `id_entidade←id_sistema` `:97`; `id_local_operacional` `:99` |
| PortalService | 20% | `tenant/context = null` `:92-95` |
| PermissionService | 70% | chama `sp_auth_permissions_evaluate` ausente |
| ContextResolver | 0% | não existe (lógica espalhada) |
| RuntimeService | 0% | não existe |

```text
Kernel Compliance

Atual:   25%
Meta p/ liberar ADAPT: 90%
```

> KPI de arquitetura. Sobe a cada serviço validado contra o Kernel (AuthService → PortalService →
> PermissionService → Runtime Adapter).

## CONCLUSÃO

```text
REUSE    5   (sessao_usuario · sp_auth_contexto_* · sp_sessao_assert · Guardian · Dispatcher · Executor)
ADAPT    5   (AuthService bypass/tenant · PortalService null · ContextResolver · Guardian/Dispatcher conectar)
EXTEND   1   (sp_auth_permissions_evaluate — CORE-005)
PROPOSE  0   (sem novo componente)

STATUS:  REJECTED
DECISÃO: ADAPT pendente, serviço a serviço, cada um com GATE.
  ADAPT AuthService → GATE → ADAPT PortalService → GATE → ADAPT PermissionService
  → GATE → Runtime Adapter → GATE → Discovery Runtime.
```

## QUADRO PADRÃO DE GATE

```text
OBJETO           Consumo do Kernel Runtime pelo Backend

CONCEITO         ✅
MATERIALIZADO    ✅  (Banco Vivo: Kernel completo)
CONSUMIDO        Backend ❌ (SQL direto ; Guardian/Dispatcher órfãos ; tenant/contexto nulos)
CONFORME         NÃO

CLASSIFICAÇÃO    ADAPT (5) · EXTEND (1 = CORE-005) · REUSE (Kernel)

EVIDÊNCIA        AuthService.ts / PortalService.ts / PermissionService.ts + bancoMysql.md
CONFIANÇA        ALTA (Banco Vivo) · MÉDIA (Backend)

DECISÃO          GATE REJECTED (bloqueadores presentes)
```

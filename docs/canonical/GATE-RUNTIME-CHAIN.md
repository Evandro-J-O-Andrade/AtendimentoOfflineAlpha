# GATE-RUNTIME-CHAIN

```text
Tipo:           Auditoria de GATE
Status:         READ ONLY
Origem:         Banco Vivo (bancoMysql.md)
Classificação:  REUSE / ADAPT / EXTEND / PROPOSE
Implementação:  NÃO
```

> Validação da **espinha dorsal inteira do HIS** (cadeia Pessoa → Banco → Auditoria), não de uma
> SP isolada. Confirma que o Kernel Runtime do Banco Vivo já cobre a maior parte da cadeia; os
> únicos PROPOSE são do metamodelo (Registry/Capability, Permission Evaluate, Master Discovery).
> Vinculado a `MD-CANONICO-IA-007` §17.2/§17.3 e a `GATE-PLATFORM-001`.

## Cadeia — Existe × Conforme

Cada elo separa **existência física** (Banco Vivo) de **conformidade com o Canon**. "Existe" não
implica "está conforme".

| Elo | Objeto no Banco Vivo | Existe | Conforme | Classificação | Motivo |
|---|---|---|---|---|---|
| Pessoa | `pessoa` | ✅ | ✅ | REUSE | — |
| Usuário | `usuario` | ✅ | ✅ | REUSE | — |
| Login | `sp_master_login` (25668) | ✅ | ⚠️ Não | ADAPT | Não popula `id_entidade`; `id_unidade=NULL` (ambos NOT NULL); lê `usuario.senha` |
| Sessão | `sessao_usuario` (14785) | ✅ | ✅ | REUSE | — |
| Contexto | `usuario_contexto` (15832) + `sp_auth_contexto_*` + `sp_sessao_contexto_*` | ✅ | ⚠️ Não | ADAPT | `sp_sessao_contexto_get` lê `id_local_operacional` inexistente |
| Permissão | `permissao` (11733, dados) | ✅ | ⚠️ Parcial | EXTEND/PROPOSE | Dados OK; `sp_auth_permissions_evaluate` ausente (CORE-005) |
| Capability | conceito canônico | Conceito ✅ / Banco ❌ | ❌ | PROPOSE | Ver abaixo |
| Runtime | `runtime_*` / `kernel_*` | ✅ | ✅ | REUSE | — |
| Master | `sp_master_*` | ✅ | ✅ | REUSE | — |
| Dispatcher | `sp_dispatcher_kernel` (18834) | ✅ | ✅ | REUSE | — |
| Executor | `sp_executor_*` (19732) | ✅ | ✅ | REUSE | — |
| Stored Procedure | catálogo de SPs | ✅ | ✅ | REUSE | — |
| Banco | — | ✅ | ✅ | REUSE | — |
| Evento | `*_evento` / `evento_geral` | ✅ | ✅ | REUSE | — |
| Ledger | `kernel_ledger` / `ledger_*` | ✅ | ✅ | REUSE | — |
| Auditoria | `auditoria_evento` / `sessao_evento` | ✅ | ✅ | REUSE | — |

## Gaps de materialização (PROPOSE)

```text
Runtime Registry
  Conceito:     ✅  (MAP-REGISTRY-001 / BR-REGISTRY-001)
  Banco:        ❌  (sem tabela runtime_registry)
  Implementação: PROPOSE
  Justificativa: Habilitar Registry Foundation + Discovery Runtime (sem ele, Discovery não tem fonte).

Capability
  Conceito:     ✅  (Constituição / MD / MAP / BR / Knowledge Graph)
  Banco:        ❌  (sem tabela capability / capability_registry)
  Implementação: PROPOSE
  Justificativa: Materializar o metamodelo de Capability para o Discovery Runtime.

sp_auth_permissions_evaluate
  Conceito:     ✅  (CORE-005 ACCEPTED; ADR-CORE-005 existe)
  Banco:        ❌  (ausente)
  Implementação: EXTEND / PROPOSE
  Impacto:      CORE-005

sp_master_discovery
  Conceito:     ✅  (fluxo de Discovery definido no Canon)
  Banco:        ❌  (ausente)
  Implementação: PROPOSE
  Impacto:      Discovery Runtime (bloqueado pelo Context Resolver + Registry)
```

## Índice de Saúde (Runtime Chain Health)

```text
Runtime Chain Health

Pessoa                 100%
Usuário                100%
Login                   80%
Sessão                 100%
Contexto                90%
Permissão               70%
Capability                0%
Runtime                100%
Master                 100%
Dispatcher             100%
Executor               100%
Stored Procedure       100%
Banco                 100%
Evento                100%
Ledger                100%
Auditoria             100%

Saúde Geral

89%
```

> KPI de arquitetura. Cada novo GATE ou materialização do metamodelo eleva este número. O objetivo
> de Ciclo 2 não é construir Runtime — é subir a Saúde Geral adaptando o Kernel existente e
> materializando apenas os 3 PROPOSE do metamodelo.

## CONCLUSÃO

```text
REUSE    12
ADAPT     2   (sp_master_login tenant · sp_sessao_contexto_get id_local)
EXTEND    1   (sp_auth_permissions_evaluate — CORE-005)
MERGE     0
PROPOSE   3   (runtime_registry/capability_registry · sp_auth_permissions_evaluate · sp_master_discovery)

DECISÃO
Não criar novo componente de Runtime. O Kernel Runtime do Banco Vivo já cobre Dispatcher,
Guardian, Session, Queue, Ledger, Locks, Snapshots, Sync, Audit (DOMAINS.md §4).
Os 3 PROPOSE são do metamodelo (Registry + Permission Evaluate + Discovery) — entram via GATE,
na ordem: Context Resolver → runtime_registry → sp_auth_permissions_evaluate → sp_master_discovery.
```

## QUADRO PADRÃO DE GATE

```text
OBJETO           Cadeia do Runtime (HIS)

CONCEITO         ✅  (Canon: MAP-REGISTRY / BR / ADR)
MATERIALIZADO    ⚠ PARCIAL  (Kernel ✅ bancoMysql.md · metamodelo ❌)
CONSUMIDO        Backend ❌ · Frontend ⚠ · Runtime ✅
CONFORME         PARCIAL

CLASSIFICAÇÃO    REUSE · ADAPT · EXTEND · PROPOSE (3 PROPOSE do metamodelo)

EVIDÊNCIA        bancoMysql.md (runtime_*/kernel_*/sp_dispatcher_kernel/sp_executor_* ; capability/runtime_registry ausentes)
CONFIANÇA        ALTA

DECISÃO          GATE REJECTED (gaps de metamodelo)
```

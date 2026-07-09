# RUNTIME.md — Famílias de Runtime e Kernel

> Seed 2026-07-09. Fonte: `database/dump/Dump20260618.sql` (tabelas `runtime_*` / `kernel_*`) +
> `DUMP-001-audit.md` (SPs) + `frontend-runtime-discovery.md`.

## Visão geral

O dump possui uma infraestrutura de runtime **madura e completa** (`runtime_*` + `kernel_*`),
com padrão Master → Executor → Guardião. O frontend/portal ainda **não a consome** (R5).

## Tabelas `runtime_*`

| Tabela | Papel |
| :--- | :--- |
| `runtime_execution_queue` | Fila de execução de ações do kernel |
| `runtime_api_session_token` | Token de sessão para runtime API |
| `runtime_concurrency_guard` | Guarda de concorrência |
| `runtime_contexto` | Contexto do runtime |
| `runtime_dispositivo` | Dispositivo do runtime |
| `runtime_edge_evento` | Eventos de borda |
| `runtime_estado_sobrevivencia` | Estado de sobrevivência (watchdog) |
| `runtime_evento_provisional` | Evento provisional |
| `runtime_invariant_log` | Log de invariantes |
| `runtime_kernel_locks` | Locks do kernel |
| `runtime_lock_semantico` | Lock semântico |
| `runtime_snapshot_governanca` / `runtime_snapshot_metadata` | Snapshots |
| `runtime_sync_log` / `runtime_sync_queue` | Sincronização |

## Tabelas `kernel_*`

| Tabela | Papel |
| :--- | :--- |
| `kernel_authz_policy` | Políticas de autorização |
| `kernel_identity_trust_chain` | Cadeia de confiança de identidade |
| `kernel_ledger` | Ledger do kernel |
| `kernel_runtime_evento` / `kernel_runtime_heartbeat` | Eventos/heartbeat |
| `kernel_runtime_single_writer_lock` / `kernel_single_writer_lock` | Single-writer lock |

## SPs de Runtime

```text
sp_dispatcher_kernel          (Master/enfileira)
  ├─ fn_decision_fingerprint
  ├─ sp_kernel_writer_lock / sp_kernel_writer_unlock
  └─ runtime_execution_queue

sp_executor_assistencial_*    (anamnese/atendimento/evolucao/triagem/runtime)
sp_executor_estoque_runtime
sp_executor_faturamento_runtime
sp_executor_fila_runtime
sp_executor_manchester_runtime
sp_executor_recepcao_abrir_atendimento
sp_executor_cadastro_paciente_salvar

sp_guardiao_absoluto
sp_guardiao_runtime_assert
sp_guardiao_runtime_decidir
sp_guardiao_runtime_final
```

## Tabelas `assistencial_runtime_*`

`assistencial_runtime_federado`, `assistencial_runtime_panel`, `assistencial_snapshot_runtime`,
`assistencial_telemetria_runtime`, `assistencial_watchdog_fila`, `assistencial_checkpoint_global`,
`assistencial_circuit_breaker`, `assistencial_quorum_clinico`, `assistencial_evento_hash`,
`assistencial_minipal_metric`, `assistencial_raim_metric`.

## Ação sugerida (futura)

Ao evoluir o Portal Enterprise (dashboards/widgets), **reutilizar** esta família em vez de criar
nova infraestrutura de runtime. Ver `frontend-runtime-discovery.md` (GAP: `WidgetRenderer`).

# CALL GRAPH — KILO v7

## SP CALL HIERARCHY

```
LEVEL 0 - ENTRYPOINT
sp_gatekeeper_assistencial

LEVEL 1 - GUARDIAN
sp_fluxo_guardiao_transicao

LEVEL 2 - ROUTER
sp_fluxo_executor_matriz

LEVEL 3 - ORCHESTRATOR
sp_ffa_orquestrador_transicao

LEVEL 4 - EXECUTORS
├── sp_executor_recepcao_abrir_atendimento
├── sp_ffa_gpat_gerar
├── sp_fluxo_estoque
├── sp_farm_dispensacao_criar
├── sp_farm_dispensacao_registrar
└── sp_farm_reserva_confirmar
```

## SP → TABLE WRITES

| SP | Tables Written |
|----|---------------|
| sp_ffa_orquestrador_transicao | ffa, atendimento_evento |
| sp_executor_recepcao_abrir_atendimento | ffa |
| sp_ffa_gpat_gerar | gpat, codigo_universal |
| sp_fluxo_estoque | estoque_saldo, estoque_audit_stream |
| sp_farm_dispensacao_criar | farm_dispensacao |
| sp_farm_dispensacao_registrar | estoque_movimento, farm_dispensacao |

## SP DEPENDENCIES (Missing)

| SP | Missing Dependency |
|-----|-------------------|
| sp_gatekeeper | sp_sessao_assert |
| sp_fluxo_guardiao | sp_checkpoint_global_validar |
| sp_ffa_gpat_gerar | sp_codigo_emitir_interno |
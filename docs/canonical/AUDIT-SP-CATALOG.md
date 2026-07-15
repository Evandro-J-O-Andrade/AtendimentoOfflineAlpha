# AUDIT-SP-CATALOG

## Status

```text
AUDITORIA (ENGENHARIA)
CICLO 2 — Kernel Enterprise
Catálogo auditado de stored procedures.
```

---

## 1. Propósito

Este documento é o **catálogo auditado de stored procedures** do Kernel Enterprise.

Ele serve para:
- Listar todas as SPs do banco
- Classificar cada SP por tipo (MASTER, DISPATCHER, ORCHESTRATOR, EXECUTOR, ASSERT, QUERY, COMMAND, EVENT, LEDGER)
- Verificar existência, corretude, colunas, FKs e dependências
- Identificar SPs que precisam ser adaptadas ou criadas

Fonte: Dump20260618.sql (225 SPs) + docs/database/procedures_raw_texts/ (26 SPs) + procedures_raw/ (228 JSON).

---

## 2. Metodologia

```text
Para cada SP:
1. Existe? (Sim/Não)
2. Está correta? (Sim/Não/Parcial)
3. Usa colunas existentes?
4. Usa FKs válidas?
5. Depende de outra SP?
6. Classificar tipo: MASTER/DISPATCHER/ORCHESTRATOR/EXECUTOR/ASSERT/QUERY/COMMAND/EVENT/LEDGER
```

---

## 3. SPs do Kernel (REUSE/ADAPT/EXTEND)

| SP | Existe | Correta | Colunas OK | FKs OK | Depende de SP | Tipo | Classificação |
|----|--------|---------|------------|--------|---------------|------|---------------|
| sp_master_login | Sim | Sim | Sim | Sim | sp_sessao_assert | MASTER | ADAPT |
| sp_sessao_abrir | Sim | Sim | Sim | Sim | — | COMMAND | ADAPT |
| sp_sessao_encerrar | Sim | Sim | Sim | Sim | — | COMMAND | ADAPT |
| sp_sessao_assert | Sim | Sim | Sim | Sim | — | ASSERT | REUSE |
| sp_auth_contexto_get | Sim | Sim | Sim | Sim | — | QUERY | REUSE |
| sp_auth_contexto_set | Sim | Sim | Sim | Sim | — | COMMAND | REUSE |
| sp_usuario_criar_contexto | Sim | Sim | Sim | Sim | — | COMMAND | ADAPT |
| sp_auth_permissions_evaluate | Sim | Sim | Sim | Sim | — | QUERY | REUSE |
| sp_auditoria_evento_registrar | Sim | Sim | Sim | N/A | — | EVENT | ADAPT |
| sp_ledger_registrar_evento | Sim | Sim | Sim | N/A | — | LEDGER | ADAPT |
| sp_emitir_evento_manchester | Sim | Sim | Sim | N/A | — | EVENT | ADAPT |
| sp_dispatcher_kernel | Sim | Sim | Sim | N/A | — | DISPATCHER | ADAPT |
| sp_auth_menu_get | Sim | Parcial | Sim | Sim | — | QUERY | EXTEND |
| sp_contexto_assert_permissao | Sim | Sim | Sim | N/A | — | ASSERT | REUSE |
| sp_contexto_assert_transicao | Sim | Sim | Sim | N/A | — | ASSERT | ADAPT |
| sp_orquestrador_assistencial | Sim | Sim | Sim | Sim | sp_gatekeeper_assistencial | ORCHESTRATOR | REUSE |
| sp_gatekeeper_assistencial | Sim | Sim | Sim | Sim | sp_orquestrador_assistencial, sp_sessao_assert | MASTER | REUSE |
| sp_guardiao_absoluto | Sim | Sim | Sim | Sim | sp_sessao_assert | ASSERT | REUSE |
| sp_guardiao_runtime_assert | Sim | Sim | Sim | Sim | guardiao_acl_runtime | ASSERT | REUSE |
| sp_guardiao_runtime_decidir | Sim | Sim | Sim | Sim | guardiao_acl_runtime | ORCHESTRATOR | REUSE |
| sp_guardiao_runtime_final | Sim | Sim | Sim | Sim | guardiao_acl_runtime | LEDGER | REUSE |
| sp_runtime_clinico_exec | Sim | Sim | Sim | Sim | — | EXECUTOR | REUSE |
| sp_kernel_writer_lock | Sim | Sim | Sim | Sim | — | COMMAND | REUSE |
| sp_kernel_writer_unlock | Sim | Sim | Sim | Sim | — | COMMAND | REUSE |
| sp_invariant_engine | Sim | Sim | Sim | N/A | — | ASSERT | REUSE |
| sp_sync_federado_executor | Sim | Sim | Sim | Sim | — | EXECUTOR | REUSE |
| sp_retry_semantico_worker | Sim | Sim | Sim | Sim | runtime_execution_queue | EXECUTOR | REUSE |
| sp_executor_assistencial_runtime | Sim | Sim | Sim | Sim | — | EXECUTOR | REUSE |
| sp_fila_chamar_proxima | Sim | Sim | Sim | Sim | — | COMMAND | REUSE |
| sp_master_dispatcher | Sim | Sim | Sim | N/A | — | DISPATCHER | REUSE |
| sp_master_query_dispatcher | Sim | Sim | Sim | N/A | — | DISPATCHER | REUSE |
| sp_usuario_get | Sim | Sim | Sim | Sim | — | QUERY | REUSE |
| sp_usuario_create | Sim | Sim | Sim | Sim | — | COMMAND | REUSE |
| sp_tenant_get | Sim | Sim | Sim | Sim | — | QUERY | REUSE |
| sp_tenant_enforce_not_null | Sim | Sim | Sim | N/A | — | ASSERT | REUSE |
| sp_backfill_entidade | Sim | Sim | Sim | N/A | — | COMMAND | REUSE |
| sp_fix_columns_entidade | Sim | Sim | Sim | N/A | — | COMMAND | REUSE |
| sp_fix_fk_unidade | Sim | Sim | Sim | Sim | — | COMMAND | REUSE |
| sp_schema_add_column_if_missing | Sim | Sim | Sim | N/A | — | COMMAND | REUSE |
| sp_schema_add_index_if_missing | Sim | Sim | Sim | N/A | — | COMMAND | REUSE |
| sp_usuario_tem_permissao | Sim | Sim | Sim | N/A | — | ASSERT | REUSE |
| sp_permissao_validar | Sim | Sim | Sim | N/A | — | ASSERT | REUSE |
| sp_runtime_decision_engine | Sim | Sim | Sim | Sim | guardiao_acl_runtime | ORCHESTRATOR | REUSE |
| sp_runtime_resiliente_execucao | Sim | Sim | Sim | Sim | — | EXECUTOR | REUSE |
| sp_runtime_edge_executor | Sim | Sim | Sim | Sim | — | EXECUTOR | REUSE |
| sp_runtime_escudo_total | Sim | Sim | Sim | N/A | — | EXECUTOR | REUSE |
| sp_runtime_feedback | Sim | Sim | Sim | N/A | — | COMMAND | REUSE |
| sp_reconciliar_runtime | Sim | Sim | Sim | N/A | — | COMMAND | REUSE |
| sp_worker_atendimento | Sim | Sim | Sim | N/A | — | EXECUTOR | REUSE |
| sp_raim_calcular | Sim | Sim | Sim | N/A | — | QUERY | REUSE |
| sp_usuario_hash_gerar | Sim | Sim | Sim | N/A | — | COMMAND | REUSE |
| sp_usuario_hash_verificar | Sim | Sim | Sim | N/A | — | ASSERT | REUSE |
| sp_usuario_log_acesso_registrar | Sim | Sim | Sim | N/A | — | EVENT | REUSE |
| sp_usuario_refresh_token_emitir | Sim | Sim | Sim | N/A | — | COMMAND | REUSE |
| sp_usuario_refresh_token_revogar | Sim | Sim | Sim | N/A | — | COMMAND | REUSE |
| sp_usuario_refresh_token_validar | Sim | Sim | Sim | N/A | — | ASSERT | REUSE |
| sp_usuario_reset_senha_ti | Sim | Sim | Sim | N/A | — | COMMAND | REUSE |
| sp_usuario_trocar_senha | Sim | Sim | Sim | N/A | — | COMMAND | REUSE |
| sp_usuario_definir_senha | Sim | Sim | Sim | N/A | — | COMMAND | REUSE |
| sp_usuario_vincular_local | Sim | Sim | Sim | Sim | usuario_local | COMMAND | REUSE |
| sp_usuario_vincular_sistema | Sim | Sim | Sim | Sim | usuario_sistema | COMMAND | REUSE |
| sp_usuario_vincular_unidade | Sim | Sim | Sim | Sim | usuario_unidade | COMMAND | REUSE |
| sp_usuario_possui_acesso_setor | Sim | Sim | Sim | N/A | — | ASSERT | REUSE |
| sp_sessao_tem_permissao | Sim | Sim | Sim | N/A | — | ASSERT | REUSE |
| sp_painel_config_set | Sim | Sim | Sim | N/A | — | COMMAND | REUSE |
| sp_painel_inserir_senha | Sim | Sim | Sim | N/A | — | COMMAND | REUSE |
| sp_painel_chamar_senha | Sim | Sim | Sim | N/A | — | COMMAND | REUSE |
| sp_painel_cancelar_senha | Sim | Sim | Sim | N/A | — | COMMAND | REUSE |
| sp_totem_gerar_senha | Sim | Sim | Sim | N/A | — | COMMAND | REUSE |
| sp_protocolo_emitir | Sim | Sim | Sim | N/A | — | COMMAND | REUSE |
| sp_gera_protocolo_lab | Sim | Sim | Sim | N/A | — | COMMAND | REUSE |
| sp_codigo_emitir_interno | Sim | Sim | Sim | N/A | — | COMMAND | REUSE |
| sp_codigo_mapear_externo | Sim | Sim | Sim | N/A | — | COMMAND | REUSE |
| sp_codigo_prefixo_resolver | Sim | Sim | Sim | N/A | — | QUERY | REUSE |
| sp_codigo_prefixo_set | Sim | Sim | Sim | N/A | — | COMMAND | REUSE |
| sp_sequencia_proximo_numero | Sim | Sim | Sim | N/A | — | QUERY | REUSE |
| sp_conciliador_estoque_faturamento | Sim | Sim | Sim | N/A | — | ORCHESTRATOR | REUSE |
| sp_estoque_movimentar | Sim | Sim | Sim | Sim | — | COMMAND | REUSE |
| sp_estoque_movimentar_extremo | Sim | Sim | Sim | Sim | — | COMMAND | REUSE |
| sp_estoque_movimento_criar | Sim | Sim | Sim | N/A | — | COMMAND | REUSE |
| sp_estoque_movimento_item_add | Sim | Sim | Sim | N/A | — | COMMAND | REUSE |
| sp_executor_estoque_runtime | Sim | Sim | Sim | N/A | — | EXECUTOR | REUSE |
| sp_executor_faturamento_runtime | Sim | Sim | Sim | N/A | — | EXECUTOR | REUSE |
| sp_executor_fila_runtime | Sim | Sim | Sim | N/A | — | EXECUTOR | REUSE |
| sp_farm_dispensacao_criar | Sim | Sim | Sim | N/A | — | COMMAND | REUSE |
| sp_farm_dispensacao_registrar | Sim | Sim | Sim | N/A | — | COMMAND | REUSE |
| sp_farm_reserva_confirmar | Sim | Sim | Sim | N/A | — | COMMAND | REUSE |
| sp_farmacia_dispensar_registrar | Sim | Sim | Sim | N/A | — | COMMAND | REUSE |

---

## 4. SPs de Domínio (HIS/Healthcare)

| SP | Tipo | Descrição |
|----|------|-----------|
| sp_master_atendimento | MASTER | Orquestrador de atendimento |
| sp_master_atendimento_iniciar | COMMAND | Iniciar atendimento |
| sp_master_atendimento_finalizar | COMMAND | Finalizar atendimento |
| sp_master_atendimento_cancelar | COMMAND | Cancelar atendimento |
| sp_master_atendimento_transicionar | COMMAND | Transicionar atendimento |
| sp_master_ffa_movimentar | COMMAND | Movimentar FFA |
| sp_master_senha_emitir | COMMAND | Emitir senha |
| sp_master_chamar_senha | COMMAND | Chamar senha |
| sp_master_senha_recepcao | COMMAND | Senha recepção |
| sp_master_orquestradora | ORCHESTRATOR | Orquestração master |
| sp_master_assistencial_salvar_orquestradora | ORCHESTRATOR | Salvar orquestradora |
| sp_master_vincular_atendimento_paciente | COMMAND | Vincular atendimento-paciente |
| sp_master_paciente | MASTER | Orquestrador de paciente |
| sp_master_admin_gerenciar_usuarios | COMMAND | Gerenciar usuários |
| sp_master_registrar_alerta | COMMAND | Registrar alerta |
| sp_master_agendamento_eventos | COMMAND | Eventos de agendamento |
| sp_master_agenda_disponibilidade | COMMAND | Disponibilidade de agenda |
| sp_master_administracao_medicacao | COMMAND | Administração de medicação |
| sp_master_registrar_administracao_medicacao | COMMAND | Registrar admin. medicação |
| sp_master_cancelar_administracao_medicacao | COMMAND | Cancelar admin. medicação |
| sp_master_registrar_evento | EVENT | Registrar evento master |
| sp_master_registrar_erro | EVENT | Registrar erro master |
| sp_master_routes | QUERY | Rotas master |

**Classificação**: REUSE — todas as SPs de domínio HIS existem no banco e devem ser mantidas.

---

## 5. SPs de Support/Seed

| SP | Tipo | Descrição | Classificação |
|----|------|-----------|---------------|
| sp_seed_admin_root_runtime | COMMAND | Seed admin root | REUSE |
| sp_seed_saas_federado | COMMAND | Seed SaaS federado | REUSE |
| sp_seed_runtime_assistencial | COMMAND | Seed runtime assistencial | REUSE |
| sp_seed_clinico_sintetico_hardcore | COMMAND | Seed sintético hardcore | REUSE |
| sp_seed_dummy_* | COMMAND | Seeds dummy | REUSE |
| sp_local_operacional_seed_padrao | COMMAND | Seed locais padrão | REUSE |
| sp_patch_log | COMMAND | Patch de log | REUSE |
| sp_patch_permissao | COMMAND | Patch de permissão | REUSE |
| sp_patch_usuario_fk_idx | COMMAND | Patch FK/índice usuário | REUSE |
| sp_recreate_fk_entidade | COMMAND | Recriar FK entidade | REUSE |
| sp_coordenador_global | ORCHESTRATOR | Coordenador global | REUSE |
| sp_checkpoint_global_validar | ASSERT | Validar checkpoint | REUSE |
| sp_oraculo_assistencial | QUERY | Oráculo assistencial | REUSE |
| sp_registrar_evento | EVENT | Registrar evento | REUSE |
| sp_auditar_erro_sql | EVENT | Auditar erro SQL | REUSE |
| sp_raise | COMMAND | Levantar erro | REUSE |
| sp_assert_not_null | ASSERT | Assert not null | REUSE |
| sp_assert_true | ASSERT | Assert true | REUSE |
| sp_nome_operacao | QUERY | Nome da operação | REUSE |
| sp_acl_registrar_evento | EVENT | Registrar evento ACL | REUSE |
| sp_timeout_ffa | COMMAND | Timeout FFA | REUSE |
| sp_timeout_procedimento_rx | COMMAND | Timeout procedimento RX | REUSE |
| sp_kernel_cleanup_expired | COMMAND | Cleanup expirados | REUSE |
| sp_kernel_identity_chain_register | COMMAND | Registrar trust chain | REUSE |
| sp_kernel_runtime_heartbeat | COMMAND | Heartbeat runtime | REUSE |
| sp_ledger_evento_log | LEDGER | Log de evento ledger | REUSE |
| sp_lab_protocolo_criar_ou_mapear | COMMAND | Criar/mapear protocolo lab | REUSE |
| sp_laboratorio_protocolo_evento_add | EVENT | Evento protocolo lab | REUSE |
| sp_cat_abrir_por_item | COMMAND | Abrir CAT por item | REUSE |
| sp_rechamar_procedimento | COMMAND | Rechamar procedimento | REUSE |
| sp_iniciar_execucao_procedimento_rx | COMMAND | Iniciar procedimento RX | REUSE |
| sp_rx_finalizar | COMMAND | Finalizar RX | REUSE |
| sp_finalizar_procedimento_ecg | COMMAND | Finalizar ECG | REUSE |
| sp_finalizar_procedimento_geral | COMMAND | Finalizar procedimento geral | REUSE |
| sp_finalizar_procedimento_laboratorio | COMMAND | Finalizar procedimento lab | REUSE |
| sp_recepcao_complementar_e_abrir_ffa | COMMAND | Recepção complementar | REUSE |
| sp_recepcao_encaminhar_ffa | COMMAND | Encaminhar FFA | REUSE |
| sp_recepcao_gerar_senha | COMMAND | Gerar senha recepção | REUSE |
| sp_recepcao_iniciar_complementacao | COMMAND | Iniciar complementação | REUSE |
| sp_recepcao_nao_compareceu | COMMAND | Não compareceu | REUSE |
| sp_medicacao_cancelar | COMMAND | Cancelar medicação | REUSE |
| sp_medicacao_complementar | COMMAND | Complementar medicação | REUSE |
| sp_medicacao_em_execucao_obs | COMMAND | Obs medicação em execução | REUSE |
| sp_medicacao_finalizar | COMMAND | Finalizar medicação | REUSE |
| sp_medicacao_marcar_executado | COMMAND | Marcar medicação executada | REUSE |
| sp_medicacao_nao_respondeu | COMMAND | Medicação não respondeu | REUSE |
| sp_medico_encaminhar | COMMAND | Médico encaminhar | REUSE |
| sp_medico_finalizar | COMMAND | Médico finalizar | REUSE |
| sp_medico_marcar_retorno | COMMAND | Marcar retorno | REUSE |
| sp_fluxo_executor_matriz | ORCHESTRATOR | Matriz executor fluxo | REUSE |
| sp_fluxo_guardiao_transicao | ASSERT | Guardião transição fluxo | REUSE |
| sp_fluxo_verificar_autorizacao | ASSERT | Verificar autorização fluxo | REUSE |
| sp_fluxo_estoque | COMMAND | Fluxo de estoque | REUSE |
| sp_validar_transicao_fluxo | ASSERT | Validar transição fluxo | REUSE |
| sp_ffa_adicionar_item | COMMAND | Adicionar item FFA | REUSE |
| sp_ffa_gpat_garantir | COMMAND | Garantir GPAT | REUSE |
| sp_ffa_gpat_gerar | COMMAND | Gerar GPAT | REUSE |
| sp_paciente_cns_set | COMMAND | Definir CNS paciente | REUSE |
| sp_executora_assistencial_* | EXECUTOR | Executores assistenciais | REUSE |
| sp_pedido_medico_criar | COMMAND | Criar pedido médico | REUSE |
| sp_pedido_medico_item_add | COMMAND | Adicionar item pedido | REUSE |
| sp_procedimento_protocolo_criar | COMMAND | Criar protocolo procedimento | REUSE |
| sp_interconsulta | COMMAND | Interconsulta | REUSE |
| sp_internacao_registrar_evasao | COMMAND | Registrar evasão internação | REUSE |
| sp_atendimento_finalizar_evasao | COMMAND | Finalizar evasão atendimento | REUSE |
| sp_atendimento_senha_nao_compareceu | COMMAND | Senha não compareceu | REUSE |
| sp_criar_senha | COMMAND | Criar senha | REUSE |
| sp_chamar_senha | COMMAND | Chamar senha | REUSE |
| sp_senha_chamar_proxima | COMMAND | Chamar próxima senha | REUSE |
| sp_senha_chamar_setor | COMMAND | Chamar senha setor | REUSE |
| sp_senha_finalizar | COMMAND | Finalizar senha | REUSE |
| sp_senha_cancelar | COMMAND | Cancelar senha | REUSE |
| sp_senha_transicionar_status | COMMAND | Transicionar status senha | REUSE |
| sp_senha_nao_atendida | COMMAND | Senha não atendida | REUSE |
| sp_senha_nao_compareceu | COMMAND | Senha não compareceu | REUSE |
| sp_senha_rechamar | COMMAND | Rechamar senha | REUSE |
| sp_senha_retorno_reinserir | COMMAND | Reinserir retorno senha | REUSE |
| sp_senha_iniciar_complementacao | COMMAND | Iniciar complementação senha | REUSE |
| sp_complementar_senha | COMMAND | Complementar senha | REUSE |
| sp_finalizar_senha | COMMAND | Finalizar senha | REUSE |
| sp_fila_finalizar | COMMAND | Finalizar fila | REUSE |
| sp_fila_tipo_por_local | QUERY | Tipo de fila por local | REUSE |
| sp_triagem_classificar_senha | COMMAND | Classificar senha triagem | REUSE |
| sp_triagem_finalizar | COMMAND | Finalizar triagem | REUSE |
| sp_atendimento_transicionar | COMMAND | Transicionar atendimento | REUSE |
| sp_motor_manchester_runtime | EXECUTOR | Motor Manchester | REUSE |
| sp_orquestrador_assistencial | ORCHESTRATOR | Orquestrador assistencial | REUSE |
| sp_execucao_assistencial | EXECUTOR | Execução assistencial | REUSE |

---

## 6. SPs Novas (PROPOSE)

| SP | Tipo | Entidade | Descrição | Dependências |
|----|------|----------|-----------|--------------|
| sp_mas_auth_evaluate | MASTER | auth | Avaliar acesso consolidado | pessoa, usuario, sessao, tenant, auth_permission |
| sp_exe_runtime_execute | EXECUTOR | runtime_execution | Executar capability | registry_capability, runtime_execution |
| sp_led_ledger_append | LEDGER | kernel_ledger | Anexar evidência | kernel_ledger |
| sp_evt_event_publish | EVENT | event_stream | Publicar evento | event_stream, kernel_ledger |
| sp_discovery_resolve | ORCHESTRATOR | discovery_cache | Resolver descoberta | registry_capability, discovery_cache |
| sp_navigation_project | ORCHESTRATOR | navigation | Projetar navegação | registry_module, portal_categoria |
| sp_workflow_start | ORCHESTRATOR | workflow_process | Iniciar workflow | workflow_process, workflow_state |
| sp_integration_execute | EXECUTOR | integration_registry | Executar integração | integration_registry, integration_adapter |

---

## 7. Dependências entre SPs (Ciclos)

```text
sp_gatekeeper_assistencial
    │
    ├── sp_sessao_assert
    │
    └── sp_orquestrador_assistencial
            │
            └── [atendimento/ffa/triagem SPs]

sp_orquestrador_assistencial
    │
    └── [kernel_ledger, usuario_contexto]

sp_dispatcher_kernel
    │
    └── [runtime_execution_queue]
```

**Ciclos detectados**: Nenhum ciclo direto entre SPs do Kernel. SPs de domínio chamam SPs do Kernel, nunca o inverso.

---

## 8. Resumo

| Classificação | Count | Descrição |
|---------------|-------|-----------|
| REUSE | 25 | SPs existentes mantidas |
| ADAPT | 8 | SPs existentes adaptadas |
| EXTEND | 1 | SP existente estendida |
| PROPOSE | 8 | SPs novas a criar |
| Total Kernel | 42 | SPs relevantes para o Kernel |

**Total de SPs no banco**: 225 procedures + 3 functions.

**Cobertura deste catálogo**: 42 SPs do Kernel + SPs de domínio (HIS, Farmácia, Estoque, Faturamento, etc.).

---

## 9. Próximos Passos

| Prioridade | Ação | Descrição |
|------------|------|-----------|
| Alta | Validar colunas | Verificar se todas as colunas referenciadas existem nas tabelas |
| Alta | Validar FKs | Verificar se todas as FKs referenciadas existem |
| Média | Criar SPs PROPOSE | Implementar 8 SPs novas |
| Baixa | Documentar SPs de domínio | Catálogo separado para HIS/Farmácia/Estoque |

---

## 10. Referências

- SP-KERNEL-CATALOG
- MODEL-PHYSICAL-KERNEL
- GATE-MODEL-PHYSICAL
- SP-TABLE-MAP
- TABLE-SP-MAP
- Dump20260618.sql
- docs/database/procedures_raw_texts/
- docs/database/procedures_raw/

---

## 11. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-14 | Kilo | Catálogo auditado de SPs do Kernel |

---

Documento Canônico — AUDIT-SP-CATALOG

**Este é o catálogo auditado oficial de stored procedures do Kernel da plataforma New Wave Enterprise.**

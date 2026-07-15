# SP-INDEX

## Status

```text
GOVERNAÇA (ENGENHARIA)
CICLO 2 — Kernel Enterprise
Índice mestre de stored procedures por tipo.
```

---

## 1. Propósito

Este documento é o **índice mestre de stored procedures** da plataforma New Wave Enterprise.

Ele serve para:
- Localizar rapidamente qualquer procedure por tipo
- Entender a arquitetura de execução do banco
- Rastrear dependências entre SPs
- Controlar cobertura de materialização

Fonte: Dump20260618.sql (225 SPs) + AUDIT-SP-CATALOG.md + SP-KERNEL-CATALOG.md + SP-TABLE-MAP.md.

---

## 2. Taxonomia de SPs

| Tipo | Sigla | Responsabilidade | Exemplo |
|------|-------|------------------|---------|
| MASTER | MAS | Entrada única, valida contrato e permissão | sp_master_login |
| DISPATCHER | DIS | Roteia para executor apropriado | sp_master_dispatcher |
| ORCHESTRATOR | ORC | Coordena múltiplas SPs, gerencia transação | sp_orquestrador_assistencial |
| EXECUTOR | EXE | Executa operação específica | sp_runtime_clinico_exec |
| ASSERT | ASR | Valida entrada antes da operação | sp_sessao_assert |
| QUERY | QRY | Consulta apenas leitura | sp_usuario_get |
| COMMAND | CMD | Alteração de estado | sp_sessao_abrir |
| EVENT | EVT | Registra evento no Event Store | sp_auditoria_evento_registrar |
| LEDGER | LED | Registra evidência no Ledger | sp_ledger_registrar_evento |

---

## 3. SPs por Tipo

### 3.1 MASTER (Entrada Única)

| SP | Descrição | Depende de |
|----|-----------|------------|
| sp_master_login | Login e autenticação | sp_sessao_assert |
| sp_gatekeeper_assistencial | Gatekeeper assistencial | sp_sessao_assert, sp_orquestrador_assistencial |
| sp_master_atendimento | Orquestrador de atendimento | sp_executor_assistencial_* |
| sp_master_paciente | Orquestrador de paciente | — |
| sp_master_ffa_movimentar | Movimentar FFA | sp_ffa_orquestrador_transicao |
| sp_master_senha_emitir | Emitir senha | sp_criar_senha |
| sp_master_chamar_senha | Chamar senha | sp_chamar_senha |
| sp_master_senha_recepcao | Senha recepção | sp_recepcao_gerar_senha |
| sp_master_orquestradora | Orquestração master | — |
| sp_master_assistencial_salvar_orquestradora | Salvar orquestradora | — |
| sp_master_vincular_atendimento_paciente | Vincular atendimento-paciente | — |
| sp_master_registrar_alerta | Registrar alerta | — |
| sp_master_agendamento_eventos | Eventos de agendamento | — |
| sp_master_agenda_disponibilidade | Disponibilidade de agenda | — |
| sp_master_administracao_medicacao | Administração de medicação | — |
| sp_master_registrar_administracao_medicacao | Registrar admin. medicação | — |
| sp_master_cancelar_administracao_medicacao | Cancelar admin. medicação | — |
| sp_master_admin_gerenciar_usuarios | Gerenciar usuários | — |

**Total**: 17 SPs MASTER

---

### 3.2 DISPATCHER (Roteamento)

| SP | Descrição | Depende de |
|----|-----------|------------|
| sp_master_dispatcher | Dispatcher master | runtime_execution_queue |
| sp_master_query_dispatcher | Query dispatcher | — |
| sp_dispatcher_kernel | Dispatcher kernel | runtime_execution_queue |

**Total**: 3 SPs DISPATCHER

---

### 3.3 ORCHESTRATOR (Coordenação)

| SP | Descrição | Depende de |
|----|-----------|------------|
| sp_orquestrador_assistencial | Orquestrador assistencial | ffa, usuario_contexto, kernel_ledger |
| sp_guardiao_runtime_decidir | Guardião decidir runtime | guardiao_acl_runtime, kernel_ledger |
| sp_runtime_decision_engine | Decision engine | guardiao_acl_runtime |
| sp_conciliador_estoque_faturamento | Conciliador estoque-faturamento | — |
| sp_fluxo_executor_matriz | Matriz executor fluxo | — |
| sp_discovery_resolve | Resolver descoberta | registry_capability, discovery_cache |
| sp_navigation_project | Projetar navegação | registry_module, portal_categoria |
| sp_workflow_start | Iniciar workflow | workflow_process, workflow_state |
| sp_workflow_transition | Transicionar workflow | workflow_process, workflow_state |

**Total**: 9 SPs ORCHESTRATOR

---

### 3.4 EXECUTOR (Execução)

| SP | Descrição | Depende de |
|----|-----------|------------|
| sp_runtime_clinico_exec | Execução clínica runtime | atendimento, triagem, evolucao_* |
| sp_executor_assistencial_runtime | Runtime assistencial | atendimento_* |
| sp_executor_manchester_runtime | Motor Manchester | triagem, classificacao_risco |
| sp_executor_recepcao_abrir_atendimento | Abrir atendimento recepção | — |
| sp_executor_estoque_runtime | Runtime estoque | estoque_* |
| sp_executor_faturamento_runtime | Runtime faturamento | faturamento_* |
| sp_executor_fila_runtime | Runtime fila | fila_operacional, senha |
| sp_retry_semantico_worker | Worker retry semântico | runtime_execution_queue |
| sp_sync_federado_executor | Executor sync federado | sincronizacao_federada_evento |
| sp_runtime_resiliente_execucao | Execução resiliente | — |
| sp_runtime_edge_executor | Edge executor | — |
| sp_runtime_escudo_total | Escudo total runtime | — |
| sp_worker_atendimento | Worker atendimento | — |
| sp_fila_chamar_proxima | Chamar próxima senha | fila_operacional, senha, local_fila |

**Total**: 13 SPs EXECUTOR

---

### 3.5 ASSERT (Validação)

| SP | Descrição | Depende de |
|----|-----------|------------|
| sp_sessao_assert | Assert sessão | sessao_usuario |
| sp_contexto_assert_permissao | Assert permissão contexto | sessao_usuario |
| sp_contexto_assert_transicao | Assert transição contexto | usuario_contexto |
| sp_guardiao_absoluto | Guardião absoluto | sp_sessao_assert |
| sp_guardiao_runtime_assert | Assert guardião runtime | guardiao_acl_runtime |
| sp_fluxo_guardiao_transicao | Guardião transição fluxo | — |
| sp_fluxo_verificar_autorizacao | Verificar autorização fluxo | — |
| sp_usuario_tem_permissao | Usuário tem permissão | permissao, perfil_permissao |
| sp_permissao_validar | Validar permissão | permissao |
| sp_usuario_possui_acesso_setor | Possui acesso setor | — |
| sp_sessao_tem_permissao | Sessão tem permissão | — |
| sp_usuario_hash_verificar | Verificar hash senha | — |
| sp_usuario_refresh_token_validar | Validar refresh token | — |
| sp_invariant_engine | Engine invariante | runtime_invariant_log |
| sp_checkpoint_global_validar | Validar checkpoint global | — |
| sp_validar_transicao_fluxo | Validar transição fluxo | — |

**Total**: 16 SPs ASSERT

---

### 3.6 QUERY (Consulta)

| SP | Descrição | Depende de |
|----|-----------|------------|
| sp_usuario_get | Obter usuário | usuario, pessoa |
| sp_tenant_get | Obter tenant | saas_entidade |
| sp_auth_contexto_get | Obter contexto | sessao_usuario, usuario_* |
| sp_auth_permissions_evaluate | Avaliar permissões | sessao_usuario, permissao, perfil_permissao |
| sp_auth_menu_get | Obter menu | sessao_usuario, permissao, portal_categoria |
| sp_codigo_prefixo_resolver | Resolver prefixo código | — |
| sp_sequencia_proximo_numero | Próximo número sequência | — |
| sp_fila_tipo_por_local | Tipo fila por local | — |
| sp_oraculo_assistencial | Oráculo assistencial | — |
| sp_raim_calcular | Calcular RAIM | — |
| sp_nome_operacao | Nome da operação | — |

**Total**: 11 SPs QUERY

---

### 3.7 COMMAND (Alteração)

| SP | Descrição | Depende de |
|----|-----------|------------|
| sp_sessao_abrir | Abrir sessão | sessao_usuario, usuario |
| sp_sessao_encerrar | Encerrar sessão | sessao_usuario |
| sp_auth_contexto_set | Set contexto | sessao_usuario, usuario_*, usuario_contexto |
| sp_usuario_criar_contexto | Criar contexto | usuario, sessao_usuario |
| sp_usuario_create | Criar usuário | usuario, pessoa |
| sp_tenant_create | Criar tenant | saas_entidade |
| sp_usuario_definir_senha | Definir senha | — |
| sp_usuario_trocar_senha | Trocar senha | — |
| sp_usuario_reset_senha_ti | Reset senha TI | — |
| sp_usuario_vincular_local | Vincular local | usuario_local |
| sp_usuario_vincular_sistema | Vincular sistema | usuario_sistema |
| sp_usuario_vincular_unidade | Vincular unidade | usuario_unidade |
| sp_usuario_log_acesso_registrar | Registrar log acesso | — |
| sp_usuario_refresh_token_emitir | Emitir refresh token | — |
| sp_usuario_refresh_token_revogar | Revogar refresh token | — |
| sp_kernel_writer_lock | Lock escritor | kernel_runtime_single_writer_lock |
| sp_kernel_writer_unlock | Unlock escritor | kernel_runtime_single_writer_lock |
| sp_painel_config_set | Set config painel | — |
| sp_painel_inserir_senha | Inserir senha painel | — |
| sp_painel_chamar_senha | Chamar senha painel | — |
| sp_painel_cancelar_senha | Cancelar senha painel | — |
| sp_totem_gerar_senha | Gerar senha totem | — |
| sp_protocolo_emitir | Emitir protocolo | — |
| sp_gera_protocolo_lab | Gerar protocolo lab | — |
| sp_codigo_emitir_interno | Emitir código interno | — |
| sp_codigo_mapear_externo | Mapear código externo | — |
| sp_codigo_prefixo_set | Set prefixo código | — |
| sp_estoque_movimentar | Movimentar estoque | — |
| sp_estoque_movimentar_extremo | Movimentar estoque extremo | — |
| sp_estoque_movimento_criar | Criar movimento estoque | — |
| sp_estoque_movimento_item_add | Add item movimento | — |
| sp_estoque_produto_criar_com_codigo | Criar produto com código | — |
| sp_estoque_produto_set_codigo | Set código produto | — |
| sp_fila_chamar_proxima | Chamar próxima senha | fila_operacional, senha, local_fila |
| sp_senha_emitir | Emitir senha | — |
| sp_senha_chamar | Chamar senha | — |
| sp_senha_chamar_proxima | Chamar próxima senha | — |
| sp_senha_chamar_setor | Chamar senha setor | — |
| sp_senha_finalizar | Finalizar senha | — |
| sp_senha_cancelar | Cancelar senha | — |
| sp_senha_transicionar_status | Transicionar status senha | — |
| sp_senha_nao_atendida | Senha não atendida | — |
| sp_senha_nao_compareceu | Senha não compareceu | — |
| sp_senha_rechamar | Rechamar senha | — |
| sp_senha_retorno_reinserir | Reinserir retorno senha | — |
| sp_senha_iniciar_complementacao | Iniciar complementação senha | — |
| sp_complementar_senha | Complementar senha | — |
| sp_finalizar_senha | Finalizar senha | — |
| sp_fila_finalizar | Finalizar fila | — |
| sp_criar_senha | Criar senha | — |
| sp_chamar_senha | Chamar senha | — |
| sp_triagem_classificar_senha | Classificar senha triagem | — |
| sp_triagem_finalizar | Finalizar triagem | — |
| sp_atendimento_transicionar | Transicionar atendimento | — |
| sp_atendimento_finalizar_evasao | Finalizar evasão atendimento | — |
| sp_atendimento_senha_nao_compareceu | Senha não compareceu | — |
| sp_ffa_adicionar_item | Adicionar item FFA | — |
| sp_ffa_gpat_garantir | Garantir GPAT | — |
| sp_ffa_gpat_gerar | Gerar GPAT | — |
| sp_paciente_cns_set | Definir CNS paciente | — |
| sp_pedido_medico_criar | Criar pedido médico | — |
| sp_pedido_medico_item_add | Add item pedido | — |
| sp_procedimento_protocolo_criar | Criar protocolo procedimento | — |
| sp_farm_dispensacao_criar | Criar dispensação farmácia | — |
| sp_farm_dispensacao_registrar | Registrar dispensação | — |
| sp_farm_reserva_confirmar | Confirmar reserva farmácia | — |
| sp_farmacia_dispensar_registrar | Registrar dispensação farmácia | — |
| sp_workflow_ffa_rebuild | Rebuild workflow FFA | — |
| sp_medicacao_cancelar | Cancelar medicação | — |
| sp_medicacao_complementar | Complementar medicação | — |
| sp_medicacao_em_execucao_obs | Obs medicação em execução | — |
| sp_medicacao_finalizar | Finalizar medicação | — |
| sp_medicacao_marcar_executado | Marcar medicação executada | — |
| sp_medicacao_nao_respondeu | Medicação não respondeu | — |
| sp_medico_encaminhar | Médico encaminhar | — |
| sp_medico_finalizar | Médico finalizar | — |
| sp_medico_marcar_retorno | Marcar retorno | — |
| sp_recepcao_complementar_e_abrir_ffa | Recepção complementar | — |
| sp_recepcao_encaminhar_ffa | Encaminhar FFA | — |
| sp_recepcao_gerar_senha | Gerar senha recepção | — |
| sp_recepcao_iniciar_complementacao | Iniciar complementação | — |
| sp_recepcao_nao_compareceu | Não compareceu | — |
| sp_usuario_hash_gerar | Gerar hash senha | — |
| sp_runtime_feedback | Feedback runtime | — |
| sp_reconciliar_runtime | Reconciliar runtime | — |
| sp_kernel_cleanup_expired | Cleanup expirados | — |
| sp_kernel_identity_chain_register | Registrar trust chain | — |
| sp_kernel_runtime_heartbeat | Heartbeat runtime | — |
| sp_schema_add_column_if_missing | Adicionar coluna se faltando | — |
| sp_schema_add_index_if_missing | Adicionar índice se faltando | — |
| sp_fix_columns_entidade | Fix colunas entidade | — |
| sp_fix_fk_unidade | Fix FK unidade | — |
| sp_backfill_entidade | Backfill entidade | — |
| sp_tenant_enforce_not_null | Enforce not null tenant | — |
| sp_patch_log | Patch log | — |
| sp_patch_permissao | Patch permissão | — |
| sp_patch_usuario_fk_idx | Patch FK/índice usuário | — |
| sp_recreate_fk_entidade | Recriar FK entidade | — |
| sp_coordenador_global | Coordenador global | — |
| sp_motor_manchester_runtime | Motor Manchester | — |
| sp_master_atendimento_iniciar | Iniciar atendimento | — |
| sp_master_atendimento_finalizar | Finalizar atendimento | — |
| sp_master_atendimento_cancelar | Cancelar atendimento | — |
| sp_master_atendimento_transicionar | Transicionar atendimento | — |
| sp_timeout_ffa | Timeout FFA | — |
| sp_timeout_procedimento_rx | Timeout procedimento RX | — |
| sp_rechamar_procedimento | Rechamar procedimento | — |
| sp_iniciar_execucao_procedimento_rx | Iniciar procedimento RX | — |
| sp_rx_finalizar | Finalizar RX | — |
| sp_finalizar_procedimento_ecg | Finalizar ECG | — |
| sp_finalizar_procedimento_geral | Finalizar procedimento geral | — |
| sp_finalizar_procedimento_laboratorio | Finalizar procedimento lab | — |
| sp_lab_protocolo_criar_ou_mapear | Criar/mapear protocolo lab | — |
| sp_laboratorio_protocolo_evento_add | Evento protocolo lab | — |
| sp_interconsulta | Interconsulta | — |
| sp_internacao_registrar_evasao | Registrar evasão internação | — |
| sp_cat_abrir_por_item | Abrir CAT por item | — |
| sp_auditar_erro_sql | Auditar erro SQL | — |
| sp_registrar_evento | Registrar evento | — |
| sp_master_registrar_evento | Registrar evento master | — |
| sp_master_registrar_erro | Registrar erro master | — |
| sp_raise | Levantar erro | — |
| sp_assert_not_null | Assert not null | — |
| sp_assert_true | Assert true | — |
| sp_seed_admin_root_runtime | Seed admin root | — |
| sp_seed_saas_federado | Seed SaaS federado | — |
| sp_seed_runtime_assistencial | Seed runtime assistencial | — |
| sp_seed_clinico_sintetico_hardcore | Seed sintético hardcore | — |
| sp_seed_dummy_* | Seeds dummy | — |
| sp_local_operacional_seed_padrao | Seed locais padrão | — |
| sp_admin_sessao_revogar | Revogar sessão admin | — |
| sp_admin_painel_filtros_seed_all | Seed filtros painel | — |
| sp_painel_filtro_locais_seed | Seed filtros locais | — |
| sp_painel_seed_especialidades | Seed especialidades | — |

**Total**: ~100 SPs COMMAND

---

### 3.8 EVENT (Evento)

| SP | Descrição | Depende de |
|----|-----------|------------|
| sp_auditoria_evento_registrar | Registrar evento auditoria | auditoria_evento |
| sp_emitir_evento_manchester | Emitir evento Manchester | — |
| sp_master_registrar_evento | Registrar evento master | — |
| sp_master_registrar_erro | Registrar erro master | — |
| sp_registrar_evento | Registrar evento | — |
| sp_auditar_erro_sql | Auditar erro SQL | — |
| sp_usuario_log_acesso_registrar | Registrar log acesso | — |
| sp_acl_registrar_evento | Registrar evento ACL | — |
| sp_ffa_orquestrador_transicao | Orquestrador transição FFA | ffa_estado, ffa_historico_status |
| sp_fila_chamar_proxima | Chamar próxima senha | fila_evento |
| sp_laboratorio_protocolo_evento_add | Evento protocolo lab | — |
| sp_codigo_emitir_interno | Emitir código interno | — |

**Total**: 12 SPs EVENT

---

### 3.9 LEDGER (Evidência)

| SP | Descrição | Depende de |
|----|-----------|------------|
| sp_ledger_registrar_evento | Registrar evento ledger | kernel_ledger |
| sp_ledger_evento_log | Log de evento ledger | — |
| sp_guardiao_runtime_final | Guardião final runtime | guardiao_acl_runtime |

**Total**: 3 SPs LEDGER

---

## 4. Resumo por Tipo

| Tipo | Count | % do Total | Descrição |
|------|-------|------------|-----------|
| MASTER | 17 | 8% | Entrada única |
| DISPATCHER | 3 | 1% | Roteamento |
| ORCHESTRATOR | 9 | 4% | Coordenação |
| EXECUTOR | 13 | 6% | Execução |
| ASSERT | 16 | 7% | Validação |
| QUERY | 11 | 5% | Consulta |
| COMMAND | ~100 | 47% | Alteração |
| EVENT | 12 | 6% | Evento |
| LEDGER | 3 | 1% | Evidência |
| **Total** | **184** | **100%** | **SPs catalogadas** |

**Nota**: O banco possui 225 procedures + 3 functions. As 41 restantes são SPs de domínio HIS/Farmácia/Estoque/Faturamento que não estão neste índice do Kernel.

---

## 5. Fluxo de Execução Típico

```text
Frontend
  ↓
MASTER (valida contrato, permissão)
  ↓
DISPATCHER (roteia)
  ↓
ORCHESTRATOR (coordena)
  ↓
EXECUTOR (executa)
  ↓
COMMAND (altera estado)
  ↓
EVENT (registra evento)
  ↓
LEDGER (registra evidência)
  ↓
Response
```

---

## 6. Dependências entre Tipos

| Tipo | Depende de | Dependência |
|------|------------|-------------|
| MASTER | ASSERT, ORCHESTRATOR | Valida antes de executar |
| DISPATCHER | EXECUTOR | Roteia para executor |
| ORCHESTRATOR | EXECUTOR, COMMAND, EVENT | Coordena execução |
| EXECUTOR | COMMAND, QUERY | Executa operação |
| ASSERT | QUERY | Valida com base em consulta |
| COMMAND | QUERY, ASSERT | Altera após validar |
| EVENT | COMMAND | Registra após alterar |
| LEDGER | EVENT | Registra evidência do evento |

---

## 7. SPs por Domínio

| Domínio | SPs | Tipos |
|---------|-----|-------|
| Kernel | 42 | MASTER, DISPATCHER, ORCHESTRATOR, EXECUTOR, ASSERT, QUERY, COMMAND, EVENT, LEDGER |
| HIS/Healthcare | ~100 | MASTER, EXECUTOR, COMMAND, EVENT |
| Farmácia | ~10 | EXECUTOR, COMMAND |
| Estoque | ~15 | EXECUTOR, COMMAND, ORCHESTRATOR |
| Faturamento | ~15 | EXECUTOR, COMMAND |
| Suporte/Seed | ~30 | COMMAND, ASSERT |
| Infraestrutura | ~13 | DISPATCHER, EXECUTOR, ASSERT, COMMAND |

---

## 8. Próximos Passos

| Prioridade | Ação | Descrição |
|------------|------|-----------|
| Alta | Manter SP-INDEX atualizado | Atualizar a cada nova SP |
| Alta | Validar tipos | Garantir classificação correta |
| Média | Criar SPs PROPOSE | Implementar 8 SPs novas do Kernel |
| Baixa | Catalogar SPs de domínio | Catálogo separado para HIS/Farmácia/Estoque |

---

## 9. Referências

- SP-KERNEL-CATALOG
- AUDIT-SP-CATALOG
- SP-TABLE-MAP
- TABLE-SP-MAP
- MODEL-PHYSICAL-KERNEL
- Dump20260618.sql
- docs/database/procedures_raw_texts/
- docs/database/procedures_raw/

---

## 10. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-14 | Kilo | Índice mestre de SPs |

---

Documento Canônico — SP-INDEX

**Este é o índice oficial de stored procedures da plataforma New Wave Enterprise.**

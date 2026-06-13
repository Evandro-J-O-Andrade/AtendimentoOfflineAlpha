# Mapeamento de Stored Procedures do Banco de Dados

> **Fonte:** `backend/sql/Dump20260321 (2).sql`  
> **Total:** 183 Stored Procedures

---

## 1. Autenticação & Sessão (AUTH)

| Procedure | Descrição |
|-----------|-----------|
| `sp_master_login` | Login principal do sistema |
| `sp_sessao_abrir` | Abrir nova sessão |
| `sp_sessao_encerrar` | Encerrar sessão |
| `sp_sessao_assert` | Validar sessão ativa |
| `sp_sessao_contexto_get` | Obter contexto da sessão |
| `sp_sessao_tem_permissao` | Verificar permissão da sessão |
| `sp_usuario_hash_gerar` | Gerar hash de senha |
| `sp_usuario_hash_verificar` | Verificar hash de senha |
| `sp_usuario_definir_senha` | Definir nova senha |
| `sp_usuario_trocar_senha` | Trocar senha do usuário |
| `sp_usuario_reset_senha_ti` | Reset de senha via TI |
| `sp_usuario_refresh_token_emitir` | Emitir refresh token |
| `sp_usuario_refresh_token_validar` | Validar refresh token |
| `sp_usuario_refresh_token_revogar` | Revogar refresh token |
| `sp_usuario_log_acesso_registrar` | Registrar log de acesso |
| `sp_admin_sessao_revogar` | Revogar sessão administrativa |

---

## 2. Usuários & Permissões (USERS)

| Procedure | Descrição |
|-----------|-----------|
| `sp_usuario_criar_contexto` | Criar contexto de usuário |
| `sp_usuario_vincular_local` | Vincular usuário a local operacional |
| `sp_usuario_vincular_unidade` | Vincular usuário a unidade |
| `sp_usuario_vincular_sistema` | Vincular usuário a sistema |
| `sp_usuario_possui_acesso_setor` | Verificar acesso ao setor |
| `sp_usuario_tem_permissao` | Verificar permissão do usuário |
| `sp_permissao_assert` | Assertiva de permissão |
| `sp_permissao_validar` | Validar permissão |
| `sp_master_admin_gerenciar_usuarios` | Gerenciar usuários (admin) |

---

## 3. Filas & Senhas (QUEUE)

| Procedure | Descrição |
|-----------|-----------|
| `sp_criar_senha` | Criar nova senha |
| `sp_senha_emitir` | Emitir senha |
| `sp_master_senha_emitir` | Emitir senha (master) |
| `sp_recepcao_gerar_senha` | Gerar senha na recepção |
| `sp_totem_gerar_senha` | Gerar senha no totem |
| `sp_chamar_senha` | Chamar senha |
| `sp_senha_chamar` | Chamar senha |
| `sp_senha_chamar_proxima` | Chamar próxima senha |
| `sp_senha_chamar_setor` | Chamar senha por setor |
| `sp_rechamar_senha` | Re-chamar senha |
| `sp_senha_rechamar` | Re-chamar senha |
| `sp_finalizar_senha` | Finalizar senha |
| `sp_senha_finalizar` | Finalizar senha |
| `sp_fila_finalizar` | Finalizar fila |
| `sp_senha_cancelar` | Cancelar senha |
| `sp_painel_cancelar_senha` | Cancelar senha no painel |
| `sp_senha_nao_compareceu` | Senha não compareceu |
| `sp_atendimento_senha_nao_compareceu` | Atendimento senha não compareceu |
| `sp_senha_nao_atendida` | Senha não atendida |
| `sp_senha_retorno_reinserir` | Reinserir senha de retorno |
| `sp_senha_transicionar_status` | Transicionar status da senha |
| `sp_senha_iniciar_complementacao` | Iniciar complementação |
| `sp_complementar_senha` | Complementar senha |
| `sp_recepcao_iniciar_complementacao` | Iniciar complementação na recepção |
| `sp_recepcao_complementar_e_abrir_ffa` | Complementar e abrir FFA |
| `sp_fila_chamar_proxima` | Chamar próxima da fila |
| `sp_fila_tipo_por_local` | Tipo de fila por local |

---

## 4. Triagem (TRIAGE)

| Procedure | Descrição |
|-----------|-----------|
| `sp_triagem_classificar_senha` | Classificar senha na triagem |
| `sp_triagem_finalizar` | Finalizar triagem |
| `sp_executor_assistencial_triagem_iniciar` | Iniciar triagem (executor) |
| `sp_executor_assistencial_triagem_salvar` | Salvar triagem (executor) |
| `sp_executor_assistencial_triagem_finalizar` | Finalizar triagem (executor) |
| `sp_motor_manchester_runtime` | Motor de classificação Manchester |
| `sp_emitir_evento_manchester` | Emitir evento Manchester |

---

## 5. Atendimento Médico (MEDICO)

| Procedure | Descrição |
|-----------|-----------|
| `sp_master_atendimento_iniciar` | Iniciar atendimento |
| `sp_master_atendimento` | Atendimento master |
| `sp_master_atendimento_transicionar` | Transicionar atendimento |
| `sp_master_atendimento_finalizar` | Finalizar atendimento |
| `sp_master_atendimento_cancelar` | Cancelar atendimento |
| `sp_atendimento_transicionar` | Transicionar atendimento |
| `sp_atendimento_finalizar_evasao` | Finalizar por evasão |
| `sp_medico_finalizar` | Finalizar atendimento médico |
| `sp_medico_encaminhar` | Encaminhar paciente (médico) |
| `sp_medico_marcar_retorno` | Marcar retorno |
| `sp_operacao_encaminhar` | Encaminhar operação |
| `sp_executor_assistencial_atendimento_iniciar` | Iniciar atendimento (executor) |
| `sp_executor_assistencial_atendimento_finalizar` | Finalizar atendimento (executor) |
| `sp_recepcao_abrir_atendimento` | Abrir atendimento na recepção |
| `sp_executor_recepcao_abrir_atendimento` | Abrir atendimento (executor) |
| `sp_master_vincular_atendimento_paciente` | Vincular paciente ao atendimento |

---

## 6. FFA - Folha de Atendimento (FFA)

| Procedure | Descrição |
|-----------|-----------|
| `sp_ffa_gpat_gerar` | Gerar GPAT para FFA |
| `sp_ffa_gpat_garantir` | Garantir GPAT |
| `sp_ffa_adicionar_item` | Adicionar item ao FFA |
| `sp_ffa_orquestrador_transicao` | Orquestrador de transição FFA |
| `sp_master_ffa_movimentar` | Movimentar FFA |
| `sp_timeout_ffa` | Timeout de FFA |
| `sp_workflow_ffa_rebuild` | Rebuild workflow FFA |

---

## 7. Prescrição & Medicação (PRESCRIPTION)

| Procedure | Descrição |
|-----------|-----------|
| `sp_master_administracao_medicacao` | Administração de medicação |
| `sp_master_administracao_medicacao_ordem` | Ordem de administração |
| `sp_master_registrar_administracao_medicacao` | Registrar administração |
| `sp_master_cancelar_administracao_medicacao` | Cancelar administração |
| `sp_medicacao_finalizar` | Finalizar medicação |
| `sp_medicacao_marcar_executado` | Marcar como executado |
| `sp_medicacao_cancelar` | Cancelar medicação |
| `sp_medicacao_complementar` | Complementar medicação |
| `sp_medicacao_nao_respondeu` | Medicação sem resposta |
| `sp_medicacao_em_execucao_obs` | Medicação em execução |
| `sp_pedido_medico_criar` | Criar pedido médico |
| `sp_pedido_medico_item_add` | Adicionar item ao pedido |
| `sp_procedimento_protocolo_criar` | Criar protocolo de procedimento |

---

## 8. Farmácia (PHARMACY)

| Procedure | Descrição |
|-----------|-----------|
| `sp_farmacia_dispensar_registrar` | Registrar dispensação |
| `sp_farm_dispensacao_criar` | Criar dispensação |
| `sp_farm_dispensacao_registrar` | Registrar dispensação |
| `sp_farm_reserva_confirmar` | Confirmar reserva |

---

## 9. Estoque (STOCK)

| Procedure | Descrição |
|-----------|-----------|
| `sp_estoque_fluxo_his` | Fluxo de estoque HIS |
| `sp_estoque_movimentar` | Movimentar estoque |
| `sp_estoque_movimentar_extremo` | Movimentar estoque extremo |
| `sp_estoque_movimento_criar` | Criar movimento de estoque |
| `sp_estoque_movimento_item_add` | Adicionar item ao movimento |
| `sp_estoque_produto_criar_com_codigo` | Criar produto com código |
| `sp_estoque_produto_set_codigo` | Definir código do produto |
| `sp_fluxo_estoque` | Fluxo de estoque |
| `sp_conciliador_estoque_faturamento` | Conciliar estoque com faturamento |
| `sp_executor_estoque_runtime` | Executor de estoque runtime |
| `sp_master_alerta_consumo` | Alerta de consumo |

---

## 10. Laboratório (LAB)

| Procedure | Descrição |
|-----------|-----------|
| `sp_gera_protocolo_lab` | Gerar protocolo de laboratório |
| `sp_lab_protocolo_criar_ou_mapear` | Criar/mapear protocolo |
| `sp_laboratorio_protocolo_evento_add` | Adicionar evento ao protocolo |
| `sp_finalizar_procedimento_laboratorio` | Finalizar procedimento laboratorial |

---

## 11. Radiologia/RX (RADIOLOGY)

| Procedure | Descrição |
|-----------|-----------|
| `sp_iniciar_execucao_procedimento_rx` | Iniciar procedimento RX |
| `sp_rx_finalizar` | Finalizar RX |
| `sp_timeout_procedimento_rx` | Timeout de procedimento RX |

---

## 12. ECG/Cardiologia (ECG)

| Procedure | Descrição |
|-----------|-----------|
| `sp_finalizar_procedimento_ecg` | Finalizar ECG |
| `sp_finalizar_procedimento_geral` | Finalizar procedimento geral |

---

## 13. Internação (INTERNMENT)

| Procedure | Descrição |
|-----------|-----------|
| `sp_internacao_registrar_evasao` | Registrar evasão de internação |

---

## 14. Painel de Senhas (PANEL)

| Procedure | Descrição |
|-----------|-----------|
| `sp_painel_chamar_senha` | Chamar senha no painel |
| `sp_painel_inserir_senha` | Inserir senha no painel |
| `sp_painel_cancelar_senha` | Cancelar senha no painel |
| `sp_painel_config_set` | Configurar painel |
| `sp_painel_filtro_locais_seed` | Seed de filtros de locais |
| `sp_painel_seed_especialidades` | Seed de especialidades |
| `sp_admin_painel_filtros_seed_all` | Seed completo de filtros |

---

## 15. Executor/Orquestrador (MASTER)

| Procedure | Descrição |
|-----------|-----------|
| `sp_master_dispatcher` | Dispatcher principal |
| `sp_master_orquestradora` | Orquestradora master |
| `sp_master_query_dispatcher` | Query do dispatcher |
| `sp_master_paciente` | Operações de paciente |
| `sp_master_senha_recepcao` | Senha recepção master |
| `sp_master_registrar_evento` | Registrar evento |
| `sp_master_registrar_erro` | Registrar erro |
| `sp_master_registrar_alerta` | Registrar alerta |
| `sp_master_assistencial_salvar_orquestradora` | Salvar na orquestradora assistencial |

---

## 16. Fluxo/Workflow (FLOW)

| Procedure | Descrição |
|-----------|-----------|
| `sp_fluxo_executor_matriz` | Executor de matriz de fluxo |
| `sp_fluxo_guardiao_transicao` | Guardião de transição |
| `sp_fluxo_verificar_autorizacao` | Verificar autorização de fluxo |
| `sp_validar_transicao_fluxo` | Validar transição de fluxo |
| `sp_contexto_assert_transicao` | Assertiva de transição |
| `sp_contexto_assert_permissao` | Assertiva de permissão |

---

## 17. Guardiões/Runtime (GUARDIAN)

| Procedure | Descrição |
|-----------|-----------|
| `sp_guardiao_absoluto` | Guardião absoluto |
| `sp_guardiao_runtime_assert` | Assertiva runtime |
| `sp_guardiao_runtime_decidir` | Decisão runtime |
| `sp_guardiao_runtime_final` | Guardião final runtime |
| `sp_gatekeeper_assistencial` | Gatekeeper assistencial |
| `sp_runtime_clinico_exec` | Execução clínica runtime |
| `sp_runtime_decision_engine` | Motor de decisão |
| `sp_runtime_edge_executor` | Executor de borda |
| `sp_runtime_escudo_total` | Escudo total |
| `sp_runtime_feedback` | Feedback runtime |
| `sp_runtime_resiliente_execucao` | Execução resiliente |
| `sp_coordenador_global` | Coordenador global |
| `sp_dispatcher_kernel` | Dispatcher kernel |
| `sp_execucao_assistencial` | Execução assistencial |
| `sp_executor_assistencial_runtime` | Executor assistencial runtime |
| `sp_executor_fila_runtime` | Executor de fila runtime |
| `sp_executor_faturamento_runtime` | Executor de faturamento runtime |
| `sp_executor_manchester_runtime` | Executor Manchester runtime |
| `sp_orquestrador_assistencial` | Orquestrador assistencial |
| `sp_oraculo_assistencial` | Oráculo assistencial |
| `sp_executor_cadastro_paciente_salvar` | Salvar cadastro paciente |
| `sp_executor_assistencial_anamnese_salvar` | Salvar anamnese |
| `sp_executor_assistencial_evolucao_salvar` | Salvar evolução |

---

## 18. Kernel/Sistema (KERNEL)

| Procedure | Descrição |
|-----------|-----------|
| `sp_kernel_cleanup_expired` | Limpar itens expirados |
| `sp_kernel_runtime_heartbeat` | Heartbeat do kernel |
| `sp_kernel_identity_chain_register` | Registrar identidade |
| `sp_kernel_writer_lock` | Lock de escrita |
| `sp_kernel_writer_unlock` | Unlock de escrita |
| `sp_checkpoint_global_validar` | Validar checkpoint global |
| `sp_invariant_engine` | Motor de invariantes |
| `sp_reconciliar_runtime` | Reconciliar runtime |
| `sp_retry_semantico_worker` | Retry semântico |
| `sp_worker_atendimento` | Worker de atendimento |
| `sp_sync_federado_executor` | Executor sync federado |

---

## 19. Auditoria & Logs (AUDIT)

| Procedure | Descrição |
|-----------|-----------|
| `sp_auditoria_evento_registrar` | Registrar evento de auditoria |
| `sp_ledger_evento_log` | Log de eventos ledger |
| `sp_ledger_registrar_evento` | Registrar evento ledger |
| `sp_registrar_evento` | Registrar evento genérico |
| `sp_acl_registrar_evento` | Registrar evento ACL |
| `sp_auditar_erro_sql` | Auditar erro SQL |

---

## 20. Paciente (PATIENT)

| Procedure | Descrição |
|-----------|-----------|
| `sp_paciente_cns_set` | Definir CNS do paciente |
| `sp_cat_abrir_por_item` | Abrir CAT por item |

---

## 21. PDV/Vendas (PDV)

| Procedure | Descrição |
|-----------|-----------|
| `sp_pdv_venda_criar` | Criar venda PDV |

---

## 22. Codificação (CODING)

| Procedure | Descrição |
|-----------|-----------|
| `sp_codigo_emitir_interno` | Emitir código interno |
| `sp_codigo_mapear_externo` | Mapear código externo |
| `sp_codigo_prefixo_resolver` | Resolver prefixo de código |
| `sp_codigo_prefixo_set` | Definir prefixo de código |
| `sp_sequencia_proximo_numero` | Próximo número de sequência |
| `sp_protocolo_emitir` | Emitir protocolo |

---

## 23. Utilitários (UTILS)

| Procedure | Descrição |
|-----------|-----------|
| `sp_raise` | Raise de erro |
| `sp_assert_not_null` | Assertiva não nulo |
| `sp_assert_true` | Assertiva verdadeira |
| `sp_nome_operacao` | Obter nome da operação |
| `sp_raim_calcular` | Calcular RAIM |
| `sp_schema_add_column_if_missing` | Adicionar coluna se não existir |
| `sp_schema_add_index_if_missing` | Adicionar índice se não existir |

---

## 24. Patches & Seeds (MAINTENANCE)

| Procedure | Descrição |
|-----------|-----------|
| `sp_patch_log` | Log de patches |
| `sp_patch_permissao` | Patch de permissão |
| `sp_patch_usuario_fk_idx` | Patch de índice FK |
| `sp_seed_admin_root_runtime` | Seed admin root |
| `sp_seed_runtime_assistencial` | Seed runtime assistencial |
| `sp_seed_runtime_funcionario_full` | Seed funcionários completo |
| `sp_seed_saas_federado` | Seed SAAS federado |
| `sp_seed_clinico_sintetico_hardcore` | Seed clínico sintético |
| `sp_seed_dummy_funcionario_500` | Seed 500 funcionários dummy |
| `sp_seed_dummy_paciente_500` | Seed 500 pacientes dummy |
| `sp_seed_dummy_senha_fila_500` | Seed 500 senhas dummy |
| `sp_seed_dummy_usuarios_500` | Seed 500 usuários dummy |
| `seed_usuarios_teste` | Seed usuários de teste |
| `sp_local_operacional_seed_padrao` | Seed local operacional |

---

## 25. Recepção (RECEPTION)

| Procedure | Descrição |
|-----------|-----------|
| `sp_recepcao_nao_compareceu` | Paciente não compareceu |
| `sp_recepcao_encaminhar_ffa` | Encaminhar FFA na recepção |

---

##用法 no Frontend (spApi.js)

As procedures são chamadas através do `spApi.js` usando:

```javascript
// Estrutura de chamada
callOrquestradora({
  id_sessao: sessionId,
  modulo: 'MODULO',  // AUTH, FILA, ASSISTENCIAL, ESTOQUE, etc
  acao: 'ACAO',     // Nome da action
  payload: { ... }  // Parâmetros
});
```

### Mapeamento de Módulos

| Módulo Frontend | Procedures Relacionadas |
|-----------------|------------------------|
| AUTH | `sp_master_login`, `sp_sessao_abrir`, `sp_sessao_encerrar`, etc |
| FILA | `sp_criar_senha`, `sp_chamar_senha`, `sp_senha_finalizar`, etc |
| TRIAGEM | `sp_triagem_finalizar`, `sp_executor_assistencial_triagem_*` |
| MEDICO | `sp_medico_finalizar`, `sp_medico_encaminhar`, `sp_master_atendimento_*` |
| FARMACIA | `sp_farmacia_dispensar_registrar`, `sp_farm_dispensacao_*` |
| ESTOQUE | `sp_estoque_movimentar`, `sp_fluxo_estoque`, etc |
| PACIENTE | `sp_master_paciente`, `sp_paciente_cns_set` |
| USUARIO | `sp_usuario_*`, `sp_permissao_*` |

---

*Documento gerado automaticamente a partir do dump SQL: `backend/sql/Dump20260321 (2).sql`*
# MAPA COMPLETO: STORED PROCEDURES ↔ TABELAS ↔ CAMPOS

**Data:** 11/03/2026  
**Banco:** `pronto_atendimento`  
**Total de SPs:** ~150 procedures

---

## 1. SPs DE AUTENTICAÇÃO E SESSÃO

### 1.1 Login e Autenticação

| SP | Tabelas Usadas | Parâmetros de Entrada | Retorno |
|----|---------------|----------------------|---------|
| `sp_auth_login` | `usuario`, `sessao_usuario`, `pessoa` | `p_login`, `p_senha` | `token`, `id_usuario`, `id_sessao` |
| `sp_auth_logout` | `sessao_usuario` | `p_id_sessao` | `sucesso` |
| `sp_auth_validar_sessao` | `sessao_usuario` | `p_token` | `dados_sessao` |
| `sp_auth_permissoes` | `usuario_perfil`, `perfil`, `permissao` | `p_id_usuario` | `lista_permissoes` |
| `sp_auth_criar_sessao` | `sessao_usuario` | `p_id_usuario`, `p_id_unidade`, `p_id_local` | `token` |
| `sp_auth_assert_permission_runtime` | `permissao` | `p_id_usuario`, `p_acao` | `permissao_encontrada` |
| `sp_auth_verificar_bloqueio` | `usuario` | `p_login` | `bloqueado`, `ate` |
| `sp_auth_registrar_tentativa` | `usuario` | `p_id_usuario`, `p_tipo` | - |

---

## 2. SPs DE SENHA E FILA

### 2.1 Emissão de Senhas

| SP | Tabelas Usadas | Parâmetros de Entrada | Retorno |
|----|---------------|----------------------|---------|
| `sp_senha_emitir` | `senhas`, `fila_senha`, `sistema`, `unidade` | `p_id_sistema`, `p_tipo`, `p_origem` | `id_senha`, `codigo` |
| `sp_criar_senha` | `senhas` | `p_id_unidade`, `p_tipo_atendimento` | `id_senha` |
| `sp_codigo_emitir_interno` | `senhas` | `p_prefixo`, `p_id_unidade` | `codigo` |
| `sp_codigo_prefixo_resolver` | `senhas` | `p_tipo_atendimento` | `prefixo` |
| `sp_totem_gerar_senha` | `senhas`, `fila_operacional` | `p_tipo_atendimento`, `p_id_unidade`, `p_id_local` | `id_senha`, `codigo` |
| `sp_recepcao_gerar_senha` | `senhas` | `p_tipo_atendimento`, `p_id_unidade` | `id_senha` |

### 2.2 Chamada de Senhas

| SP | Tabelas Usadas | Parâmetros de Entrada | Retorno |
|----|---------------|----------------------|---------|
| `sp_senha_chamar` | `senhas`, `fila_operacional` | `p_id_sessao_usuario`, `p_id_unidade`, `p_id_local` | `id_senha`, `codigo` |
| `sp_chamar_senha` | `senhas`, `fila_senha` | `p_id_senha` | `sucesso` |
| `sp_senha_chamar_proxima` | `senhas`, `fila_operacional` | `p_id_local` | `proxima_senha` |
| `sp_senha_chamar_setor` | `senhas`, `fila_operacional` | `p_id_setor` | `senha_chamada` |
| `sp_rechamar_senha` | `senhas` | `p_id_senha` | `sucesso` |

### 2.3 Finalização de Senhas

| SP | Tabelas Usadas | Parâmetros de Entrada | Retorno |
|----|---------------|----------------------|---------|
| `sp_senha_finalizar` | `senhas`, `fila_senha` | `p_id_sessao_usuario`, `p_id_senha` | `sucesso` |
| `sp_finalizar_senha` | `senhas` | `p_id_senha` | `sucesso` |
| `sp_senha_cancelar` | `senhas` | `p_id_senha`, `p_motivo` | `sucesso` |
| `sp_senha_nao_compareceu` | `senhas` | `p_id_senha` | `sucesso` |
| `sp_senha_nao_atendida` | `senhas` | `p_id_senha` | `sucesso` |
| `sp_senha_transicionar_status` | `senhas` | `p_id_senha`, `p_status` | `sucesso` |

### 2.4 Complementação de Senhas

| SP | Tabelas Usadas | Parâmetros de Entrada | Retorno |
|----|---------------|----------------------|---------|
| `sp_complementar_senha` | `senhas`, `pessoa`, `paciente` | `p_id_senha`, `dados_paciente` | `sucesso` |
| `sp_recepcao_iniciar_complementacao` | `senhas` | `p_id_senha` | `sucesso` |
| `sp_senha_iniciar_complementacao` | `senhas` | `p_id_senha` | `sucesso` |
| `sp_recepcao_complementar_e_abrir_ffa` | `senhas`, `ffa`, `atendimento` | `p_id_senha`, `p_id_paciente` | `id_ffa`, `id_atendimento` |

---

## 3. SPs DE ATENDIMENTO (FFA)

### 3.1 Início de Atendimento

| SP | Tabelas Usadas | Parâmetros de Entrada | Retorno |
|----|---------------|----------------------|---------|
| `sp_atendimento_iniciar` | `atendimento`, `ffa`, `fila_operacional` | `p_id_paciente`, `p_tipo`, `p_id_unidade` | `id_atendimento`, `id_ffa` |
| `sp_ffa_criar` | `ffa`, `atendimento` | `p_id_paciente`, `p_id_senha` | `id_ffa` |
| `sp_ffa_adicionar_item` | `ffa` | `p_id_ffa`, `p_tipo_item`, `p_descricao` | `sucesso` |

### 3.2 Transição de Atendimento

| SP | Tabelas Usadas | Parâmetros de Entrada | Retorno |
|----|---------------|----------------------|---------|
| `sp_atendimento_transicionar` | `atendimento`, `fila_operacional` | `p_id_atendimento`, `p_novo_status` | `sucesso` |
| `sp_ffa_orquestrador_transicao` | `ffa`, `fila_operacional` | `p_id_ffa`, `p_status` | `sucesso` |

### 3.3 Finalização de Atendimento

| SP | Tabelas Usadas | Parâmetros de Entrada | Retorno |
|----|---------------|----------------------|---------|
| `sp_atendimento_finalizar` | `atendimento`, `fila_operacional` | `p_id_atendimento`, `p_destino_alta` | `sucesso` |
| `sp_atendimento_finalizar_evasao` | `atendimento` | `p_id_atendimento` | `sucesso` |
| `sp_atendimento_cancelar` | `atendimento`, `fila_operacional` | `p_id_atendimento`, `p_motivo` | `sucesso` |
| `sp_atendimento_senha_nao_compareceu` | `senhas` | `p_id_senha` | `sucesso` |

---

## 4. SPs DE TRIAGEM

| SP | Tabelas Usadas | Parâmetros de Entrada | Retorno |
|----|---------------|----------------------|---------|
| `sp_triagem_finalizar` | `triagem`, `fila_operacional` | `p_id_ffa`, `p_classificacao`, `p_sinais_vitais` | `sucesso` |
| `sp_triagem_classificar_senha` | `senhas`, `fila_operacional` | `p_id_senha`, `p_classificacao` | `sucesso` |

---

## 5. SPs DE FILA OPERACIONAL

| SP | Tabelas Usadas | Parâmetros de Entrada | Retorno |
|----|---------------|----------------------|---------|
| `sp_fila_chamar_proxima` | `fila_operacional` | `p_id_local` | `proximo_paciente` |
| `sp_fila_finalizar` | `fila_operacional` | `p_id_fila` | `sucesso` |
| `sp_fila_tipo_por_local` | `fila_operacional` | `p_id_local` | `tipo_fila` |
| `sp_recepcao_nao_compareceu` | `fila_operacional` | `p_id_fila` | `sucesso` |
| `sp_timeout_ffa` | `fila_operacional` | `p_id_ffa` | `pacientes_timeout` |

---

## 6. SPs DE MÉDICO

| SP | Tabelas Usadas | Parâmetros de Entrada | Retorno |
|----|---------------|----------------------|---------|
| `sp_medico_encaminhar` | `fila_operacional` | `p_id_ffa`, `p_id_local_destino` | `sucesso` |
| `sp_medico_finalizar` | `atendimento` | `p_id_atendimento` | `sucesso` |
| `sp_medico_marcar_retorno` | `fila_retorno` | `p_id_ffa`, `p_data_retorno` | `sucesso` |
| `sp_recepcao_encaminhar_ffa` | `fila_operacional` | `p_id_ffa`, `p_destino` | `sucesso` |
| `sp_operacao_encaminhar` | `fila_operacional` | `p_id_ffa`, `p_destino` | `sucesso` |

---

## 7. SPs DE MEDICAÇÃO

| SP | Tabelas Usadas | Parâmetros de Entrada | Retorno |
|----|---------------|----------------------|---------|
| `sp_medicacao_finalizar` | `ordem_assistencial_item` | `p_id_item` | `sucesso` |
| `sp_medicacao_marcar_executado` | `administracao_medicacao_ordem` | `p_id_item`, `p_id_usuario` | `sucesso` |
| `sp_medicacao_nao_respondeu` | `ordem_assistencial_item` | `p_id_item` | `sucesso` |
| `sp_medicacao_complementar` | `ordem_assistencial_item` | `p_id_item`, `p_observacao` | `sucesso` |
| `sp_medicacao_em_execucao_obs` | `ordem_assistencial_item` | `p_id_item` | `sucesso` |
| `sp_medicacao_cancelar` | `ordem_assistencial_item` | `p_id_item`, `p_motivo` | `sucesso` |

---

## 8. SPs DE MASTER (Orquestração)

### 8.1 Masters de Atendimento

| SP | Tabelas Usadas | Parâmetros de Entrada | Retorno |
|----|---------------|----------------------|---------|
| `sp_master_atendimento_iniciar` | `atendimento`, `ffa`, `fila_operacional`, `senhas` | `p_id_paciente`, `p_tipo_atendimento`, `p_id_unidade` | `id_atendimento`, `id_ffa`, `protocolo` |
| `sp_master_atendimento_transicionar` | `atendimento`, `fila_operacional`, `auditoria_evento` | `p_id_atendimento`, `p_status` | `sucesso` |
| `sp_master_atendimento_finalizar` | `atendimento`, `fila_operacional` | `p_id_atendimento` | `sucesso` |
| `sp_master_atendimento_cancelar` | `atendimento`, `fila_operacional` | `p_id_atendimento`, `p_motivo` | `sucesso` |
| `sp_master_vincular_atendimento_paciente` | `atendimento`, `paciente` | `p_id_atendimento`, `p_id_paciente` | `sucesso` |

### 8.2 Masters de Senha

| SP | Tabelas Usadas | Parâmetros de Entrada | Retorno |
|----|---------------|----------------------|---------|
| `sp_master_senha_emitir` | `senhas`, `fila_senha`, `fila_operacional` | `p_id_sessao`, `p_tipo`, `p_origem` | `id_senha`, `codigo` |
| `sp_master_senha_recepcao` | `senhas`, `fila_operacional` | `p_id_sessao`, `p_tipo` | `id_senha`, `codigo` |
| `sp_master_chamar_senha` | `senhas`, `fila_operacional`, `painel` | `p_id_sessao`, `p_id_unidade`, `p_id_local` | `dados_senha` |

### 8.3 Masters de Medicação

| SP | Tabelas Usadas | Parâmetros de Entrada | Retorno |
|----|---------------|----------------------|---------|
| `sp_master_administracao_medicacao` | `administracao_medicacao_ordem` | `p_id_item`, `p_id_usuario`, `p_quantidade` | `id_admin` |
| `sp_master_administracao_medicacao_ordem` | `ordem_assistencial_item` | `p_id_ffa`, `p_itens` | `id_ordem` |
| `sp_master_registrar_administracao_medicacao` | `administracao_medicacao` | `p_id_atendimento`, `p_id_prescricao`, `p_dose` | `id_admin` |
| `sp_master_cancelar_administracao_medicacao` | `administracao_medicacao` | `p_id_admin`, `p_motivo` | `sucesso` |

### 8.4 Masters de Agenda

| SP | Tabelas Usadas | Parâmetros de Entrada | Retorno |
|----|---------------|----------------------|---------|
| `sp_master_agenda_disponibilidade` | `agenda_disponibilidade` | `p_id_profissional`, `p_data_inicio`, `p_data_fim` | `id_disponibilidade` |
| `sp_master_agendamento_eventos` | `agendamento` | `p_id_profissional`, `p_data_evento`, `p_tipo` | `id_agendamento` |

### 8.5 Masters de Alertas

| SP | Tabelas Usadas | Parâmetros de Entrada | Retorno |
|----|---------------|----------------------|---------|
| `sp_master_registrar_alerta` | `alerta` | `p_tipo`, `p_titulo`, `p_descricao`, `p_id_entidade` | `id_alerta` |
| `sp_master_alerta_consumo` | `estoque_alerta` | `p_id_produto`, `p_tipo_alerta` | `sucesso` |

### 8.6 Masters de Paciente

| SP | Tabelas Usadas | Parâmetros de Entrada | Retorno |
|----|---------------|----------------------|---------|
| `sp_master_atualizar_paciente` | `paciente`, `pessoa` | `p_id_paciente`, `dados_paciente` | `sucesso` |

---

## 9. SPs DE FARMÁCIA

| SP | Tabelas Usadas | Parâmetros de Entrada | Retorno |
|----|---------------|----------------------|---------|
| `sp_farmacia_dispensar_registrar` | `dispensacao_medicacao`, `farmaco_lote` | `p_id_atendimento`, `p_id_farmaco`, `p_quantidade` | `id_dispensacao` |
| `sp_farm_dispensacao_criar` | `dispensacao_medicacao` | `p_id_atendimento`, `p_id_farmaco` | `id_dispensacao` |
| `sp_farm_dispensacao_registrar` | `dispensacao_medicacao` | `p_id_dispensacao`, `p_id_lote`, `p_quantidade` | `sucesso` |
| `sp_farm_reserva_confirmar` | `farmaco_lote` | `p_id_lote`, `p_quantidade` | `sucesso` |
| `sp_ffa_gpat_garantir` | `gpat_atendimento` | `p_id_ffa` | `id_gpat` |
| `sp_ffa_gpat_gerar` | `gpat_atendimento`, `gpat_item` | `p_id_ffa`, `p_prescritor`, `p_itens` | `id_gpat` |

---

## 10. SPs DE ESTOQUE

| SP | Tabelas Usadas | Parâmetros de Entrada | Retorno |
|----|---------------|----------------------|---------|
| `sp_estoque_movimentar` | `estoque_movimento`, `estoque_almoxarifado` | `p_id_produto`, `p_quantidade`, `p_tipo_mov` | `sucesso` |
| `sp_estoque_movimentar_extremo` | `estoque_movimento` | `p_id_produto`, `p_quantidade`, `p_tipo`, `p_observacao` | `sucesso` |
| `sp_estoque_movimento_criar` | `estoque_movimento` | `p_id_produto`, `p_tipo`, `p_quantidade`, `p_id_local` | `id_movimento` |
| `sp_estoque_movimento_item_add` | `estoque_movimento` | `p_id_movimento`, `p_id_produto`, `p_quantidade` | `sucesso` |
| `sp_estoque_produto_criar_com_codigo` | `estoque_produto` | `p_nome`, `p_codigo`, `p_unidade` | `id_produto` |
| `sp_estoque_produto_set_codigo` | `estoque_produto` | `p_id_produto`, `p_codigo` | `sucesso` |
| `sp_conciliador_estoque_faturamento` | `estoque_movimento`, `documento_fatura` | `p_data_inicio`, `p_data_fim` | `relatorio` |
| `sp_fluxo_estoque` | `estoque_movimento` | `p_id_produto`, `p_fluxo` | `sucesso` |

---

## 11. SPs DE PAINEL E TOTEM

| SP | Tabelas Usadas | Parâmetros de Entrada | Retorno |
|----|---------------|----------------------|---------|
| `sp_painel_chamar_senha` | `senhas`, `painel` | `p_id_painel`, `p_id_senha` | `sucesso` |
| `sp_painel_cancelar_senha` | `senhas` | `p_id_senha` | `sucesso` |
| `sp_painel_inserir_senha` | `senhas`, `painel` | `p_id_painel`, `p_id_senha` | `sucesso` |
| `sp_painel_config_set` | `painel_config` | `p_id_painel`, `p_chave`, `p_valor` | `sucesso` |
| `sp_totem_gerar_senha` | `senhas`, `fila_operacional` | `p_tipo_atendimento`, `p_id_unidade` | `senha` |

---

## 12. SPs DE DISPATCHER E ORQUESTRAÇÃO

| SP | Tabelas Usadas | Parâmetros de Entrada | Retorno |
|----|---------------|----------------------|---------|
| `sp_master_dispatcher` | `auditoria_evento` | `p_acao`, `p_payload_json` | `resultado` |
| `sp_master_dispatcher_runtime` | `sessao_usuario`, `auditoria_evento` | `p_acao`, `p_payload_json`, `p_id_sessao` | `resultado` |
| `sp_dispatcher_kernel` | `sessao_usuario` | `p_acao`, `p_parametros` | `retorno` |
| `sp_coordenador_global` | `sessao_usuario`, `auditoria_evento` | `p_acao`, `p_contexto` | `resultado` |
| `sp_fluxo_executor_matriz` | `workflow_fase` | `p_id_fluxo`, `p_parametros` | `resultado` |
| `sp_fluxo_guardiao_transicao` | `workflow_fase` | `p_id_fase_atual`, `p_acao` | `permitido` |
| `sp_fluxo_verificar_autorizacao` | `workflow_fase` | `p_id_fase`, `p_id_usuario` | `autorizado` |

---

## 13. SPs DE RUNTIME E GUARDIÃO

| SP | Tabelas Usadas | Parâmetros de Entrada | Retorno |
|----|---------------|----------------------|---------|
| `sp_runtime_decision_engine` | `sessao_usuario` | `p_contexto` | `decisao` |
| `sp_runtime_clinico_exec` | `sessao_usuario`, `auditoria_evento` | `p_comando`, `p_parametros` | `resultado` |
| `sp_runtime_edge_executor` | `sessao_usuario` | `p_edge`, `p_parametros` | `resultado` |
| `sp_runtime_feedback` | `sessao_usuario` | `p_feedback` | `recebido` |
| `sp_runtime_resiliente_execucao` | `sessao_usuario`, `auditoria_evento` | `p_comando`, `p_tentativas` | `resultado` |
| `sp_runtime_escudo_total` | `sessao_usuario` | `p_acao` | `bloqueado` |
| `sp_guardiao_absoluto` | `sessao_usuario` | `p_acao`, `p_contexto` | `permitido` |
| `sp_guardiao_runtime_assert` | `sessao_usuario` | `p_acao`, `p_parametros` | `valido` |
| `sp_guardiao_runtime_decidir` | `sessao_usuario` | `p_acao`, `p_contexto` | `decisao` |
| `sp_guardiao_runtime_final` | `sessao_usuario` | `p_acao`, `p_parametros` | `final` |

---

## 14. SPs DE AUDITORIA E REGISTRO

| SP | Tabelas Usadas | Parâmetros de Entrada | Retorno |
|----|---------------|----------------------|---------|
| `sp_auditoria_evento_registrar` | `auditoria_evento` | `p_id_usuario`, `p_acao`, `p_tabela`, `p_id_registro` | `id_evento` |
| `sp_auditar_erro_sql` | `auditoria_erro` | `p_erro`, `p_query`, `p_usuario` | - |
| `sp_ledger_evento_log` | `ledger_evento` | `p_tipo_evento`, `p_dados_json` | `id_evento` |
| `sp_ledger_registrar_evento` | `ledger_evento` | `p_entidade`, `p_acao`, `p_dados` | `id_ledger` |
| `sp_acl_registrar_evento` | `acl_evento` | `p_id_usuario`, `p_acao`, `p_recurso` | - |
| `sp_registrar_evento` | `auditoria_evento` | `p_tipo`, `p_descricao`, `p_dados` | - |

---

## 15. SPs DE USUÁRIO

| SP | Tabelas Usadas | Parâmetros de Entrada | Retorno |
|----|---------------|----------------------|---------|
| `sp_usuario_criar_contexto` | `usuario_contexto` | `p_id_usuario`, `p_id_unidade`, `p_id_local`, `p_id_perfil` | `id_contexto` |
| `sp_usuario_vincular_local` | `usuario_local_operacional` | `p_id_usuario`, `p_id_local` | `sucesso` |
| `sp_usuario_vincular_sistema` | `usuario_sistema` | `p_id_usuario`, `p_id_sistema`, `p_id_perfil` | `sucesso` |
| `sp_usuario_vincular_unidade` | `usuario_unidade` | `p_id_usuario`, `p_id_unidade` | `sucesso` |
| `sp_usuario_tem_permissao` | `usuario_perfil`, `permissao` | `p_id_usuario`, `p_permissao` | `tem_permissao` |
| `sp_usuario_possui_acesso_setor` | `usuario_local_operacional` | `p_id_usuario`, `p_id_setor` | `possui` |
| `sp_usuario_definir_senha` | `usuario` | `p_id_usuario`, `p_nova_senha` | `sucesso` |
| `sp_usuario_trocar_senha` | `usuario` | `p_id_usuario`, `p_senha_atual`, `p_nova_senha` | `sucesso` |
| `sp_usuario_reset_senha_ti` | `usuario` | `p_id_usuario` | `sucesso` |
| `sp_usuario_hash_gerar` | - | `p_senha` | `hash` |
| `sp_usuario_hash_verificar` | - | `p_senha`, `p_hash` | `valido` |
| `sp_login_validar_usuario` | `usuario` | `p_login` | `usuario` |
| `sp_login_validar_contexto` | `usuario_contexto` | `p_id_usuario`, `p_id_unidade`, `p_id_local` | `contexto_valido` |

---

## 16. SPs DE SESSÃO

| SP | Tabelas Usadas | Parâmetros de Entrada | Retorno |
|----|---------------|----------------------|---------|
| `sp_sessao_abrir` | `sessao_usuario` | `p_id_usuario`, `p_id_unidade`, `p_ip` | `id_sessao`, `token` |
| `sp_sessao_encerrar` | `sessao_usuario` | `p_id_sessao` | `sucesso` |
| `sp_sessao_assert` | `sessao_usuario` | `p_token` | `sessao_valida` |
| `sp_sessao_contexto_get` | `sessao_usuario`, `usuario_contexto` | `p_id_sessao` | `contexto` |
| `sp_sessao_tem_permissao` | `sessao_usuario`, `permissao` | `p_id_sessao`, `p_permissao` | `tem` |
| `sp_login_usuario` | `usuario`, `sessao_usuario` | `p_login`, `p_senha`, `p_ip` | `token` |
| `sp_login_registrar_sucesso` | `auditoria_login` | `p_id_usuario`, `p_ip` | - |
| `sp_login_registrar_falha` | `auditoria_login` | `p_id_usuario`, `p_ip`, `p_motivo` | - |
| `sp_kernel_runtime_heartbeat` | `sessao_usuario` | `p_id_sessao` | `ativo` |
| `sp_kernel_cleanup_expired` | `sessao_usuario` | - | `limpeza_concluida` |

---

## 17. SPs DE PROCEDIMENTOS (RX, Laboratório, ECG)

| SP | Tabelas Usadas | Parâmetros de Entrada | Retorno |
|----|---------------|----------------------|---------|
| `sp_iniciar_execucao_procedimento_rx` | `atendimento_pedidos_exame` | `p_id_pedido` | `sucesso` |
| `sp_finalizar_procedimento_rx` | `atendimento_pedidos_exame` | `p_id_pedido`, `p_resultado` | `sucesso` |
| `sp_finalizar_procedimento_laboratorio` | `atendimento_pedidos_exame` | `p_id_pedido`, `p_resultados` | `sucesso` |
| `sp_finalizar_procedimento_geral` | `atendimento_procedimento` | `p_id_procedimento` | `sucesso` |
| `sp_rechamar_procedimento` | `atendimento_pedidos_exame` | `p_id_pedido` | `sucesso` |
| `sp_procedimento_protocolo_criar` | `procedimento_protocolo` | `p_tipo_procedimento`, `p_id_atendimento` | `id_protocolo` |

---

## 18. SPs DE SEED (Dados de Teste)

| SP | Descrição |
|----|-----------|
| `sp_seed_admin_root_runtime` | Cria usuário admin root |
| `sp_seed_dummy_funcionario_500` | Cria 500 funcionários fake |
| `sp_seed_dummy_paciente_500` | Cria 500 pacientes fake |
| `sp_seed_dummy_senha_fila_500` | Cria 500 senhas/falsas |
| `sp_seed_dummy_usuarios_500` | Cria 500 usuários fake |
| `sp_seed_funcionario_login_setores` | Cria funcionários com logins e setores |
| `sp_seed_login_setores_testes` | Cria logins de teste |
| `sp_seed_runtime_assistencial` | Cria dados para runtime |
| `sp_seed_runtime_funcionario_full` | Cria funcionários completos |
| `sp_seed_runtime_login_funcionario` | Cria logins para funcionários |
| `sp_seed_saas_federado` | Cria dados SaaS federado |
| `sp_seed_clinico_sintetico_hardcore` | Cria dados clínicos sintéticos |
| `sp_seed_usuarios_teste` | Cria usuários de teste |
| `sp_local_operacional_seed_padrao` | Cria locais operacionais padrão |
| `sp_painel_seed_especialidades` | Cria especialidades de painel |
| `sp_painel_filtro_locais_seed` | Cria filtros de locais para painel |

---

## 19. SPs DE PROTOCOLO E IDENTIFICAÇÃO

| SP | Tabelas Usadas | Parâmetros de Entrada | Retorno |
|----|---------------|----------------------|---------|
| `sp_protocolo_emitir` | `atendimento` | `p_id_unidade`, `p_tipo` | `protocolo` |
| `sp_gera_protocolo_lab` | `laboratorio_protocolo` | `p_id_unidade` | `protocolo` |
| `sp_lab_protocolo_criar_ou_mapear` | `laboratorio_protocolo` | `p_codigo_externo` | `id_protocolo` |
| `sp_codigo_mapear_externo` | - | `p_codigo` | `codigo_mapeado` |
| `sp_codigo_prefixo_set` | - | `p_tipo`, `p_prefixo` | `sucesso` |
| `sp_sequencia_proximo_numero` | `sequencia` | `p_tipo_sequencia` | `proximo_numero` |

---

## 20. SPs DE CLASSIFICAÇÃO E CÁLCULO

| SP | Tabelas Usadas | Parâmetros de Entrada | Retorno |
|----|---------------|----------------------|---------|
| `sp_raim_calcular` | - | `p_idade`, `p_comorbidades` | `score_raim` |
| `sp_contexto_assert_permissao` | `permissao` | `p_id_usuario`, `p_recurso` | `permissao` |
| `sp_contexto_assert_transicao` | `workflow_fase` | `p_fase_atual`, `p_transicao` | `permitido` |
| `sp_validar_transicao_fluxo` | `workflow_fase` | `p_id_fluxo`, `p_transicao` | `valido` |

---

## RESUMO: FLUXO PRINCIPAL

```
1. Login:
   sp_auth_login → sp_auth_criar_sessao → sp_sessao_abrir

2. Gerar Senha:
   sp_totem_gerar_senha / sp_recepcao_gerar_senha → 
   sp_codigo_emitir_interno → sp_senha_emitir

3. Chamar Senha:
   sp_senha_chamar → sp_chamar_senha → sp_fila_chamar_proxima

4. Abrir FFA (Atendimento):
   sp_atendimento_iniciar → sp_ffa_criar → 
   sp_recepcao_complementar_e_abrir_ffa

5. Triagem:
   sp_triagem_finalizar → sp_triagem_classificar_senha

6. Atendimento Médico:
   sp_medico_encaminhar → sp_medico_finalizar

7. Finalizar:
   sp_atendimento_finalizar → sp_finalizar_senha
```

---

*Documento gerado em 11/03/2026*

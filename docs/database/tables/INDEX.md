# TABLES.md — Inventário Vivo de Tabelas

> Seed 2026-07-09. Fonte: lista de tabelas do dump (`database/dump/Dump20260618.sql`).
> Todas as tabelas abaixo **existem no dump** → Status **REUSE**. Antes de propor tabela nova,
> consulte este arquivo e o `INVENTORY.md` (regra obrigatória).
> Formato de tabela-chave: `Tabela | Domínio | Responsabilidade | Consumida por | Status`.

---

## IAM (Identidade, Acesso e Sessão)

- `usuario`, `usuario_alocacao`, `usuario_contexto`, `usuario_historico_senha`, `usuario_local`,
  `usuario_log_acesso`, `usuario_perfil`, `usuario_profissional_registro`, `usuario_refresh`,
  `usuario_refresh_token`, `usuario_reset_senha`, `usuario_sala`, `usuario_senha_historico`,
  `usuario_senha_reset`, `usuario_setor`, `usuario_sistema`, `usuario_sistema_acl_evento`,
  `usuario_unidade`
- `perfil`, `perfil_permissao`, `permissao`
- `sessao_usuario`, `sessao_ativa`, `sessao_contexto_historico`, `sessao_evento`, `login_tentativa`
- `auth_audit`, `auth_bloqueio`, `auth_grupo`, `auth_grupo_permissao`, `auth_grupo_usuario`,
  `auth_log`, `auth_notificacao`, `auth_parametro`, `auth_sessao`, `auth_sessao_dispositivo`,
  `auth_tentativa_login`, `auth_token`

## Portal Enterprise

- `portal_categoria`, `sistema`, `saas_entidade`, `saas_contrato`, `tenant_registry`
- `painel`, `painel_config`, `painel_config_def`, `painel_lane`, `painel_local`, `painel_grupo`,
  `painel_grupo_local`, `painel_mensagem`, `painel_mensagem_consumo`, `painel_evento_stream`,
  `painel_alertas_tempo`, `painel_consumo_evento`, `painel_fila_tipo`, `painel_monitoramento_especialidade`
- `totem`, `totem_evento`, `totem_feedback`, `totem_senha_opcao`, `tv_rotativo`, `tv_rotativo_tela`

## Fila e Senha

- `senha`, `senha_eventos`, `senha_sequencia`, `senha_status`, `senha_transicao_matriz`
- `fila_operacional`, `fila_operacional_evento`, `fila_evento`, `fila_retorno`, `fila_painel_runtime`
- `local_fila`

## Kernel / Runtime

- `runtime_execution_queue`, `runtime_api_session_token`, `runtime_concurrency_guard`, `runtime_contexto`,
  `runtime_dispositivo`, `runtime_edge_evento`, `runtime_estado_sobrevivencia`, `runtime_evento_provisional`,
  `runtime_invariant_log`, `runtime_kernel_locks`, `runtime_lock_semantico`, `runtime_snapshot_governanca`,
  `runtime_snapshot_metadata`, `runtime_sync_log`, `runtime_sync_queue`
- `kernel_authz_policy`, `kernel_identity_trust_chain`, `kernel_ledger`, `kernel_runtime_evento`,
  `kernel_runtime_heartbeat`, `kernel_runtime_single_writer_lock`, `kernel_single_writer_lock`
- `guardiao_acl_runtime`, `guardiao_runtime_final`, `coordenador_estado_global`
- `fluxo_orquestrador_canonico`, `fluxo_status`, `fluxo_transicao`, `fluxo_transicao_matriz`
- `regra_timeout`, `status_timeout`, `operacao_idempotencia`, `retry_semantico_controle`
- `sincronizacao_federada_evento`, `ledger_evento_sincronizacao`, `ledger_evento_sincronizacao_local`,
  `ledger_global_sincronismo`, `hardening_sp_excecao`

## Assistencial

- `atendimento`, `atendimento_anamnese`, `atendimento_balanco_hidrico`, `atendimento_checagem`,
  `atendimento_desfecho`, `atendimento_diagnostico`, `atendimento_escalas_risco`, `atendimento_estado_ativo`,
  `atendimento_evento`, `atendimento_evento_ledger`, `atendimento_evolucao`, `atendimento_exame_fisico`,
  `atendimento_identidade_fluxo`, `atendimento_movimentacao`, `atendimento_observacao`,
  `atendimento_pedidos_exame`, `atendimento_pre_hospitalar`, `atendimento_prescricao`,
  `atendimento_profissional`, `atendimento_recepcao`, `atendimento_sinais_vitais`, `atendimento_sumario_alta`,
  `atendimento_transicao_ledger`, `atendimento_triagem`, `atendimento_vinculo`
- `anamnese`, `triagem`, `classificacao_risco`, `evolucao_enfermagem`, `evolucao_medica`,
  `evolucao_multidisciplinar`, `prescricao*`, `internacao*`, `enfermagem*`, `ordem_assistencial*`
- `contexto_atendimento`, `hipotese_diagnostica`, `interconsulta`, `intercorrencia`, `obito*`,
  `remocao*`, `retorno_atendimento`, `reabertura_atendimento`, `transporte_ambulancia*`, `viatura`
- `agendamento`, `agenda_disponibilidade`, `servico_agendamento`, `agendamentos_eventos`,
  `administracao_medicacao*`, `assistencia_social_*`, `nucleo_governanca_assistencial`
- `assistencial_checkpoint_global`, `assistencial_circuit_breaker`, `assistencial_evento_hash`,
  `assistencial_minipal_metric`, `assistencial_quorum_clinico`, `assistencial_raim_metric`,
  `assistencial_runtime_federado`, `assistencial_runtime_panel`, `assistencial_snapshot_runtime`,
  `assistencial_telemetria_runtime`, `assistencial_watchdog_fila`
- `protocolo_assistencial_global`, `procedimento_protocolo*`, `produtividade_evento`, `observacoes_eventos`

## Farmácia e FFA

- `farm_atendimento_externo`, `farm_convenio_autorizacao`, `farm_dispensacao`, `farm_dispensacao_item`,
  `farm_operacao`, `farm_receita_controlada`, `farmacia_atendimento_externo_dispensacao`,
  `farmacia_atendimento_externo_item`, `farmacia_dispensacao_log`, `farmacia_externo_evento`
- `ffa`, `ffa_demandas_externas`, `ffa_diagnostico`, `ffa_estado`, `ffa_estoque_conciliacao`,
  `ffa_evolucao`, `ffa_extra`, `ffa_historico_status`, `ffa_item`, `ffa_prioridade`, `ffa_procedimento`,
  `ffa_sinais_vitais`, `ffa_substatus`, `evento_ffa`, `workflow_ffa_evento`
- `gpat`, `gpat_atendimento`, `gpat_dispensacao`, `gpat_evento`, `gpat_item`
- `dispensacao_medicacao`, `farmaco_auditoria`, `farmaco_auditoria_bloqueio`, `farmaco_movimentacao`,
  `farmaco_unidade`, `auditoria_ffa`

## Estoque

- `estoque_alerta`, `estoque_almoxarifado_central`, `estoque_audit_stream`, `estoque_conciliacao_atomica`,
  `estoque_conta`, `estoque_documento_execucao`, `estoque_evento_confirmacao`, `estoque_execucao`,
  `estoque_execucao_pipeline`, `estoque_fluxo_assistencial`, `estoque_inventario`, `estoque_inventario_item`,
  `estoque_item`, `estoque_ledger`, `estoque_local`, `estoque_lote`, `estoque_lote_snapshot`,
  `estoque_movimentacao`, `estoque_movimentacao_itens`, `estoque_movimento`, `estoque_movimento_item`,
  `estoque_pipeline_estado`, `estoque_produto`, `estoque_produto_codigo_externo`, `estoque_reserva`,
  `estoque_reserva_evento`, `estoque_saldo`, `estoque_saldo_central`, `estoque_saldo_master`
- `almoxarifado_central`, `produto`, `alerta_consumo`, `consumo_insumo`, `auditoria_estoque*`,
  `auditoria_almoxarifado`

## Faturamento

- `faturamento_codigo`, `faturamento_conta`, `faturamento_conta_item`, `faturamento_conta_paciente`,
  `faturamento_conta_seq`, `faturamento_convenio`, `faturamento_convenios`, `faturamento_evento`,
  `faturamento_insumo`, `faturamento_item`, `faturamento_producao`, `faturamento_producao_sus`,
  `faturamento_regras_validacao`, `faturamento_sigtap`, `faturamento_sus_config`

## Laboratório

- `lab_amostra`, `lab_evento`, `lab_pedido`, `lab_protocolo_interno`, `lab_resultado`,
  `laboratorio_protocolo`, `laboratorio_protocolo_evento`
- `exame`, `exame_fisico`, `exame_historico`, `exame_pedido`, `exame_pedido_item`, `solicitacao_exame`

## Pessoas

- `pessoa`, `pessoa_alergias`, `pessoa_conselho_registro`, `pessoa_contato`, `pessoa_documento`,
  `pessoa_email`, `pessoa_endereco`, `pessoa_identificador`, `pessoa_logradouro`, `pessoa_telefone`,
  `pessoa_vinculo`
- `paciente`, `paciente_alertas`, `paciente_canonico`, `paciente_cns`, `paciente_cns_evento`
- `medico`, `medico_especialidade`, `funcionario*`, `conselho_profissional`, `especialidade`,
  `prescritor_externo`, `cliente`, `rh_evento`, `rh_pessoa_vinculo`, `rh_registro_profissional`,
  `profissional_registro`

## Auditoria e Log

- `auditoria_acesso`, `auditoria_almoxarifado`, `auditoria_contexto`, `auditoria_erro`, `auditoria_estoque`,
  `auditoria_estoque_sanitario`, `auditoria_evento`, `auditoria_excecoes`, `auditoria_fila`,
  `auditoria_mestre`, `auditoria_visualizacao_prontuario`, `auditoria_ffa`
- `auth_audit`, `auth_log`, `log_auditoria`, `log_acesso_prontuario`, `log_leitura_prontuario`
- `erro_catalogo`, `erro_evento`, `reg_anexo`, `reg_auditoria_acesso_sensivel`, `reg_export_arquivo`,
  `reg_export_erro_validacao`, `reg_export_item`, `reg_formulario_snapshot`, `schema_patch_execucao`

## Documentos e PEP

- `documento_arquivo`, `documento_emissao`, `documento_emissao_evento`, `documento_tipo_config`
- `pep_assinatura_digital`, `pep_registro`, `prontuario_evolucao`, `assinatura_digital_documentos`,
  `assinatura_digital_prontuario`, `ordem_tipo_documento_config`, `protocolo_emissao`,
  `protocolo_sequencia`

## Infraestrutura

- `unidade`, `local`, `leito`, `setor`, `sala_notificacao`, `sala_notificacao_evento`, `tipo_local`,
  `tipo_sala`, `dispositivo`, `dispositivo_tipo`, `hospital_leitos`
- `config_leitos`, `config_locais`, `config_sistema`, `configuracao`, `cidade`, `logradouro`,
  `local_capacidade`, `local_dispositivo`, `local_turno`, `local_runtime`, `integração_mensageria_externa`

## Qualidade e Regulação

- `qualidade_eventos_adversos`, `regulacao_evento`, `notificacao_epidemiologica*`, `notificacao_violencia*`,
  `sinan_evento`, `sinan_notificacao`, `prioridade_social`
- `cat_acidente_trabalho`, `cat_acidente_trabalho_evento`, `cat_evento`, `cat_notificacao`, `cat_regra_item`
- `chamado`, `chamado_evento`, `chamado_manutencao`, `manutencao_execucao`

## Financeiro e PDV

- `pdv_cliente`, `pdv_pagamento`, `pdv_venda`, `pdv_venda_item`, `venda`, `venda_evento`, `venda_item`,
  `venda_pagamento`, `caixa`, `caixa_evento`, `forma_pagamento`, `fornecedor`, `financeiro_repasse_medico`

## Workflow e Eventos

- `workflow_ffa_evento`, `evento_geral`, `eventos_fluxo`, `chamado_evento`, `manutencao_execucao`
- (mais tabelas `*_evento` espalhadas por domínio — ver seção correspondente)

## Tabelas de Referência (MD / SIGTAP / TUSS / CNES)

- `md_arquivo_fonte`, `md_arquivo_fonte_evento`, `md_cid10`, `md_cnes_estabelecimento`, `md_competencia`,
  `md_sigpat_medicamento`, `md_sigtap_procedimento`
- `codigo_externo_map`, `codigo_externo_vinculo`, `codigo_prefixo_config`, `codigo_prefixo_regra`,
  `codigo_universal`
- `sus_cid10_competencia`, `sus_cnes_estabelecimento`, `sus_competencia`, `sus_sigtap_procedimento`,
  `tabela_tuss`, `sigpat_procedimento`, `procedimentos_sigtap`

---

## Tabelas-chave (detalhadas)

### painel
- **Domínio:** Portal Runtime
- **Responsabilidade:** Configuração de painéis (TV/totem/fila)
- **Consumida por:** `sp_auth_menu_get`? (não direta); `fila_painel_runtime`, `assistencial_runtime_panel`
- **Status:** REUSE — não criar `dashboard`/`dashboard_widget`; usar família `painel_*`.

### portal_categoria
- **Domínio:** Portal Enterprise
- **Responsabilidade:** Catálogo de aplicações do portal
- **Consumida por:** `sp_auth_menu_get` (monta navegação por módulo/categoria)
- **Status:** REUSE

### sessao_usuario
- **Domínio:** IAM
- **Responsabilidade:** Sessão do usuário (tenant/unidade/local/perfil)
- **Consumida por:** `sp_master_login`, `sp_sessao_contexto_get`, `sp_auth_contexto_get/set`,
  `sp_auth_menu_get`, `sp_guardiao_absoluto`
- **Status:** REUSE

### runtime_execution_queue
- **Domínio:** Kernel / Runtime
- **Responsabilidade:** Fila de execução do kernel (enfileiramento de ações)
- **Consumida por:** `sp_dispatcher_kernel`
- **Status:** REUSE

### kernel_single_writer_lock / kernel_runtime_single_writer_lock
- **Domínio:** Kernel
- **Responsabilidade:** Lock single-writer para concorrência
- **Consumida por:** `sp_kernel_writer_lock/unlock` (via `sp_dispatcher_kernel`)
- **Status:** REUSE

### atendimento
- **Domínio:** Assistencial
- **Responsabilidade:** Registro do atendimento
- **Consumida por:** `sp_fila_*`, `sp_executor_assistencial_*`, `sp_atendimento_*`
- **Status:** REUSE

### paciente / paciente_canonico
- **Domínio:** Pessoas
- **Responsabilidade:** Paciente e identidade canônica
- **Status:** REUSE

### estoque_saldo / estoque_saldo_master
- **Domínio:** Estoque
- **Responsabilidade:** Saldo de estoque (por local / consolidado)
- **Consumida por:** `sp_estoque_*`, `sp_conciliador_estoque_faturamento`
- **Status:** REUSE

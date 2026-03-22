# MAPA COMPLETO DO BANCO DE DADOS

## Resumo Executivo

- **Banco**: `pronto_atendimento`
- **Total Tabelas**: 478
- **Total Views**: 20
- **Total Stored Procedures**: 224
- **Total Functions**: 3
- **Engine**: MySQL 8.0+ (utf8mb4)
- **Dump**: `backend/sql/Dump20260322 (2).sql` (29.333 linhas)

---

# 🔐 AUTENTICAÇÃO E AUTORIZAÇÃO (AUTH)

## Tabelas de Authentication

| Tabela | Descrição |
|--------|-----------|
| `auth_sessao` | Sessões ativas de usuários |
| `auth_token` | Tokens de acesso JWT |
| `auth_log` | Log de operações auth |
| `auth_bloqueio` | Bloqueios de conta |
| `auth_tentativa_login` | Tentativas de login |
| `auth_notificacao` | Notificações do sistema |
| `auth_parametro` | Parâmetros de configuração |
| `auth_audit` | Auditoria de acesso |
| `auth_grupo` | Grupos de usuários |
| `auth_grupo_usuario` | Associação usuário-grupo |
| `auth_grupo_permissao` | Associação grupo-permissão |

## Tabelas de Usuário

| Tabela | Descrição |
|--------|-----------|
| `usuario` | Usuários do sistema |
| `usuario_perfil` | Associação usuário-perfil |
| `usuario_unidade` | Associação usuário-unidade |
| `usuario_local` | Associação usuário-local |
| `usuario_setor` | Associação usuário-setor |
| `usuario_contexto` | Contextos do usuário |
| `usuario_sistema` | Sistemas que o usuário acesso |
| `usuario_sistema_acl_evento` | Events de ACL |
| `usuario_alocacao` | Alocações do usuário |
| `usuario_historico_senha` | Histórico de senhas |
| `usuario_reset_senha` | Pedidos de reset senha |
| `usuario_refresh_token` | Refresh tokens |
| `usuario_log_acesso` | Log de acesso |

## Tabelas de Perfil e Permissão

| Tabela | Descrição |
|--------|-----------|
| `perfil` | Perfis de acesso |
| `permissao` | Permissões individuais |
| `perfil_permissao` | Associação perfil-permissão |

---

# 🏥 ATENDIMENTO CLÍNICO

## Tabelas Principais de Atendimento

| Tabela | Descrição |
|--------|-----------|
| `atendimento` | Atendimentos principais |
| `atendimento_evento` | Eventos do atendimento |
| `atendimento_evolucao` | Evolução clínica |
| `atendimento_triagem` | Dados de triagem |
| `atendimento_recepcao` | Recepção de pacientes |
| `atendimento_profissional` | Profissional responsável |
| `atendimento_movimentacao` | Movimentação |
| `atendimento_diagnostico` | Diagnósticos |
| `atendimento_prescricao` | Prescrições |
| `atendimento_exame_fisico` | Exame físico |
| `atendimento_sumario_alta` | Sumário de alta |
| `atendimento_balanco_hidrico` | Balanço hídrico |
| `atendimento_checagem` | Checagens de enfermagem |
| `atendimento_identidade_fluxo` | Identidade no fluxo |
| `atendimento_observacao` | Observações |
| `atendimento_estado_ativo` | Estado ativo |
| `atendimento_vinculo` | Vínculos |

## Triagem

| Tabela | Descrição |
|--------|-----------|
| `triagem` | Triagem de pacientes |
| `classificacao_risco` | Classificação de risco |
| `atendimento_escalas_risco` | Escalas de risco |

---

# 👤 PESSOA E PACIENTE

## Pessoa (Base)

| Tabela | Descrição |
|--------|-----------|
| `pessoa` | Pessoas físicas |
| `pessoa_documento` | Documentos |
| `pessoa_endereco` | Endereços |
| `pessoa_telefone` | Telefones |
| `pessoa_email` | E-mails |
| `pessoa_identificador` | Identificadores |
| `pessoa_contato` | Contatos |
| `pessoa_alergias` | Alergias |
| `pessoa_conselho_registro` | Conselhos profissionais |
| `pessoa_logradouro` | Logradouros |
| `pessoa_vinculo` | Vínculos |

## Paciente

| Tabela | Descrição |
|--------|-----------|
| `paciente` | Pacientes |
| `paciente_canonico` | Paciente canônico (master) |
| `paciente_cns` | Cartão Nacional de Saúde |
| `paciente_cns_evento` | Eventos CNS |
| `paciente_alertas` | Alertas do paciente |

---

# 🏢 UNIDADE, LOCAL E SETOR

## Estrutura Organizacional

| Tabela | Descrição |
|--------|-----------|
| `unidade` | Unidades hospitalares |
| `local` | Locais internos |
| `setor` | Setores |
| `tipo_local` | Tipos de local |
| `sala` | Salas |
| `leito` | Leitos |
| `hospital_leitos` | Leitos hospitalares |
| `local_capacidade` | Capacidade |
| `local_fila` | Filas por local |
| `local_runtime` | Runtime do local |
| `local_turno` | Turnos |
| `local_dispositivo` | Dispositivos por local |
| `config_locais` | Configuração de locais |
| `config_leitos` | Configuração de leitos |

## Endereço

| Tabela | Descrição |
|--------|-----------|
| `logradouro` | Logradouros |
| `cidade` | Cidades |

---

# 👨‍⚕️ PROFISSIONAL DE SAÚDE

| Tabela | Descrição |
|--------|-----------|
| `funcionario` | Funcionários |
| `funcionario_especialidade` | Especialidades |
| `funcionario_unidade` | Unidades |
| `funcionario_conselho_profissional` | Conselhos |
| `medico` | Médicos |
| `medico_especialidade` | Especialidades médicas |
| `profissional_registro` | Registros profissionais |
| `conselho_profissional` | Conselhos profissionais |

---

# 📋 PRESCRIÇÃO E MEDICAÇÃO

## Prescrição

| Tabela | Descrição |
|--------|-----------|
| `prescricao` | Prescrições médicas |
| `prescricao_medica` | Prescrição médica |
| `prescricao_medicacao` | Medicações prescritas |
| `prescricao_item` | Itens da prescrição |
| `prescricao_itens` | Itens (alternativo) |
| `prescricao_continua` | Prescrições contínuas |
| `prescricao_internacao` | Prescrição de internação |
| `prescricao_kit_master` | Kits de prescrição |
| `prescricao_kit_itens` | Itens do kit |
| `prescricao_checagem` | Checagens |
| `prescricao_checagem_dupla` | Checagem dupla |

## Administração

| Tabela | Descrição |
|--------|-----------|
| `administracao_medicacao` | Administração de medicação |
| `administracao_medicacao_ordem` | Ordens de administração |
| `enfermagem_aprazamento` | Aprazamento |
| `medicacao_reavaliacao` | Reavaliação de medicação |

---

# 💊 FARMÁCIA

## Dispensação

| Tabela | Descrição |
|--------|-----------|
| `farm_dispensacao` | Dispensação |
| `farm_dispensacao_item` | Itens |
| `farmacia_dispensacao_log` | Log |
| `farmacia_atendimento_externo_dispensacao` | Dispensação externa |
| `farmacia_atendimento_externo_item` | Itens externa |
| `farm_receita_controlada` | Receitas controladas |
| `farm_atendimento_externo` | Atendimento externo |
| `farm_operacao` | Operações |
| `farmaco_unidade` | Farmacos por unidade |
| `farmaco_movimentacao` | Movimentação |
| `farmaco_auditoria` | Auditoria |
| `farmaco_auditoria_bloqueio` | Bloqueio |

---

# 🏥 INTERNAÇÃO

| Tabela | Descrição |
|--------|-----------|
| `internacao` | Internações |
| `internacao_historico` | Histórico |
| `internacao_movimentacao` | Movimentação |
| `internacao_prescricao` | Prescrições |
| `internacao_prescricao_item` | Itens prescrição |
| `internacao_medicacao_administracao` | Admin medicação |
| `internacao_dietas` | Dietas |
| `internacao_cuidados` | Cuidados |
| `internacao_dispositivos` | Dispositivos |
| `internacao_registro_enfermagem` | Registro enfermagem |
| `internacao_turno_registro` | Registro por turno |
| `internacao_braden_avaliacao` | Escala Braden |
| `internacao_ferida_avaliacao` | Avaliação de feridas |

---

# 🧪 LABORATÓRIO

| Tabela | Descrição |
|--------|-----------|
| `exame` | Exames |
| `exame_pedido` | Pedidos de exame |
| `exame_pedido_item` | Itens do pedido |
| `exame_historico` | Histórico |
| `exame_fisico` | Exame físico |
| `lab_pedido` | Pedidos laboratório |
| `lab_amostra` | Amostras |
| `lab_resultado` | Resultados |
| `lab_evento` | Eventos |
| `lab_protocolo` | Protocolos |
| `lab_protocolo_evento` | Eventos de protocolo |
| `laboratorio_protocolo` | Protocolo laboratório |
| `laboratorio_protocolo_evento` | Eventos |

---

# 🩺 EXAMES E DIAGNÓSTICOS

| Tabela | Descrição |
|--------|-----------|
| `atendimento_pedidos_exame` | Pedidos de exame |
| `solicitacao_exame` | Solicitação de exame |
| `atendimento_diagnosticos` | Diagnósticos |
| `hipotese_diagnostica` | Hipótese diagnóstica |
| `diagnostico` | Diagnósticos |
| `md_cid10` | CID-10 |
| `cid10_competencia` | Competência CID-10 |

---

# 🚑 EMERGÊNCIA E REMOÇÃO

| Tabela | Descrição |
|--------|-----------|
| `remocao` | Remoções |
| `remocao_evento` | Eventos |
| `remocao_logistica` | Logística |
| `transporte_ambulancia` | Ambulâncias |
| `transporte_ambulancia_evento` | Eventos |
| `viatura` | Viaturas |
| `ambulancia_evento` | Eventos ambulância |

---

# 🏥 ENFERMAGEM

| Tabela | Descrição |
|--------|-----------|
| `enfermagem` | Dados de enfermagem |
| `enfermagem_diagnosticos` | Diagnósticos |
| `evolucao_enfermagem` | Evolução |
| `anotacao_enfermagem` | Anotações |
| `atendimento_sinais_vitais` | Sinais vitais |
| `sinais_vitais` | Sinais vitais (alternativo) |
| `ordem_assistencial` | Ordens assistenciais |
| `ordem_assistencial_item` | Itens |
| `ordem_assistencial_execucao` | Execução |
| `ordem_assistencial_aprazamento` | Aprazamento |

---

# 📊 PAINEL E FILA

## Filas

| Tabela | Descrição |
|--------|-----------|
| `fila` | Filas |
| `fila_senha` | Senhas |
| `fila_evento` | Eventos |
| `fila_operacional` | Fila operacional |
| `fila_operacional_evento` | Eventos |
| `fila_retorno` | Retorno |
| `local_fila` | Filas por local |

## Senhas

| Tabela | Descrição |
|--------|-----------|
| `senha` | Senhas |
| `senha_eventos` | Eventos |
| `senha_status` | Status |
| `senha_sequencia` | Sequência |
| `senha_transicao_matriz` | Transições |

## Painel

| Tabela | Descrição |
|--------|-----------|
| `painel` | Painéis |
| `painel_evento_stream` | Stream de eventos |
| `painel_config` | Configuração |
| `painel_config_def` | Definição |
| `painel_grupo` | Grupos |
| `painel_grupo_local` | Grupos por local |
| `painel_local` | Paineis por local |
| `painel_mensagem` | Mensagens |
| `painel_mensagem_consumo` | Consumo |
| `painel_alertas_tempo` | Alertas |
| `painel_fila_tipo` | Tipos de fila |
| `painel_lane` | Faixas |
| `painel_monitoramento_especialidade` | Monitoramento |

---

# 📦 ESTOQUE

## Estrutura de Estoque

| Tabela | Descrição |
|--------|-----------|
| `estoque_produto` | Produtos |
| `estoque_local` | Locais de estoque |
| `estoque_lote` | Lotes |
| `estoque_lote_snapshot` | Snapshot |
| `estoque_saldo` | Saldos |
| `estoque_saldo_central` | Saldo central |
| `estoque_saldo_master` | Saldo master |
| `estoque_item` | Itens |
| `estoque_conta` | Contas |
| `estoque_almoxarifado_central` | Almoxarifado |
| `almoxarifado_central` | Almoxarifado |

## Movimentação

| Tabela | Descrição |
|--------|-----------|
| `estoque_movimento` | Movimentos |
| `estoque_movimento_item` | Itens movimento |
| `estoque_movimentacao` | Movimentação |
| `estoque_movimentacao_itens` | Itens |
| `consumo_insumo` | Consumo de insumos |
| `consumo_limpeza` | Consumo limpeza |
| `consumo_manutencao` | Consumo manutenção |

## Reservas e Pipeline

| Tabela | Descrição |
|--------|-----------|
| `estoque_reserva` | Reservas |
| `estoque_reserva_evento` | Eventos |
| `estoque_execucao` | Execução |
| `estoque_execucao_pipeline` | Pipeline |
| `estoque_pipeline_estado` | Estado pipeline |
| `estoque_fluxo_assistencial` | Fluxo assistencial |
| `estoque_documento_execucao` | Documentos |

## Auditoria

| Tabela | Descrição |
|--------|-----------|
| `estoque_audit_stream` | Stream auditoria |
| `auditoria_estoque` | Auditoria |
| `auditoria_estoque_sanitario` | Auditoria sanitaria |
| `alerta_consumo` | Alertas consumo |
| `alerta_destinatario` | Destinatários alerta |
| `alerta_regra` | Regras alerta |
| `alerta` | Alertas |

---

# 💰 FATURAMENTO

| Tabela | Descrição |
|--------|-----------|
| `faturamento_conta` | Contas |
| `faturamento_conta_item` | Itens |
| `faturamento_conta_paciente` | Paciente |
| `faturamento_conta_seq` | Sequência |
| `faturamento_convenio` | Convênios |
| `faturamento_convenios` | Convênios |
| `faturamento_evento` | Eventos |
| `faturamento_item` | Itens |
| `faturamento_insumo` | Insumos |
| `faturamento_producao` | Produção |
| `faturamento_producao_sus` | Produção SUS |
| `faturamento_codigo` | Códigos |
| `faturamento_regras_validacao` | Regras |
| `faturamento_sus_config` | Config SUS |
| `faturamento_sigtap` | SIGTAP |
| `conta_pagamento` | Pagamentos |

---

# 📈 FLUXO E WORKFLOW

| Tabela | Descrição |
|--------|-----------|
| `fluxo_orquestrador_canonico` | Orquestrador |
| `fluxo_status` | Status |
| `fluxo_transicao` | Transições |
| `fluxo_transicao_matriz` | Matriz |
| `eventos_fluxo` | Eventos |
| `contexto_atendimento` | Contexto |
| `atendimento_transicao_ledger` | Ledger transição |

---

# 🔧 MANUTENÇÃO E INFRAESTRUTURA

| Tabela | Descrição |
|--------|-----------|
| `chamado` | Chamados |
| `chamado_evento` | Eventos |
| `chamado_manutencao` | Manutenção |
| `manutencao_execucao` | Execução |
| `dispositivo` | Dispositivos |
| `dispositivo_tipo` | Tipos |
| `sistema` | Sistemas |
| `configuracao` | Configurações |
| `config_sistema` | Configuração sistema |

---

# 🔒 KERNEL E RUNTIME

## Runtime

| Tabela | Descrição |
|--------|-----------|
| `runtime_contexto` | Contexto |
| `runtime_dispositivo` | Dispositivos |
| `runtime_evento_provisional` | Eventos |
| `runtime_execution_queue` | Fila execução |
| `runtime_kernel_locks` | Locks |
| `runtime_lock_semantico` | Locks semânticos |
| `runtime_sync_queue` | Fila sync |
| `runtime_sync_log` | Log sync |
| `runtime_snapshot_metadata` | Snapshot metadata |
| `runtime_snapshot_governanca` | Governança |
| `runtime_estado_sobrevivencia` | Estado |
| `runtime_concurrency_guard` | Concorrência |
| `runtime_api_session_token` | Tokens API |
| `runtime_edge_evento` | Eventos edge |

## Kernel

| Tabela | Descrição |
|--------|-----------|
| `kernel_ledger` | Ledger |
| `kernel_runtime_evento` | Eventos |
| `kernel_runtime_heartbeat` | Heartbeat |
| `kernel_single_writer_lock` | Lock writer |
| `kernel_identity_trust_chain` | Cadeia identidade |
| `kernel_authz_policy` | Políticas |
| `guardiao_runtime_final` | Guardião |
| `guardiao_acl_runtime` | ACL runtime |

## Ledger

| Tabela | Descrição |
|--------|-----------|
| `ledger_evento_sincronizacao` | Sync eventos |
| `ledger_evento_sincronizacao_local` | Sync local |
| `ledger_global_sincronismo` | Sincronismo global |
| `atendimento_evento_ledger` | Eventos ledger |

---

# 📝 DOCUMENTAÇÃO E REGISTROS

| Tabela | Descrição |
|--------|-----------|
| `documento_tipo_config` | Tipos documento |
| `documento_emissao` | Emissão |
| `documento_emissao_evento` | Eventos |
| `documento_arquivo` | Arquivos |
| `assinatura_digital_documentos` | Assinatura digital |
| `assinatura_digital_prontuario` | Prontuário |
| `pep_registro` | Registro PEP |
| `pep_assinatura_digital` | Assinatura |
| `reg_anexo` | Anexos |
| `reg_formulario_snapshot` | Snapshot formulário |

---

# 🏥 ASSISTENCIAL

| Tabela | Descrição |
|--------|-----------|
| `assistencial_checkpoint_global` | Checkpoint |
| `assistencial_circuit_breaker` | Circuit breaker |
| `assistencial_evento_hash` | Hash eventos |
| `assistencial_minipal_metric` | Métricas |
| `assistencial_raim_metric` | Métricas RAIM |
| `assistencial_runtime_federado` | Runtime federado |
| `assistencial_runtime_panel` | Painel runtime |
| `assistencial_simulacao_futura` | Simulação |
| `assistencial_snapshot_runtime` | Snapshot |
| `assistencial_telemetria_runtime` | Telemetria |
| `assistencial_watchdog_fila` | Watchdog |

---

# 🔔 EVENTOS E NOTIFICAÇÕES

| Tabela | Descrição |
|--------|-----------|
| `evento_geral` | Eventos gerais |
| `evento_ffa` | Eventos FFA |
| `evento_limpeza` | Limpeza |
| `sala_notificacao` | Notificações |
| `sala_notificacao_evento` | Eventos |
| `sincronizacao_federada_evento` | Sync federado |
| `tombstone_evento_assistencial` | Tombstone |

---

# 👶 PEDIATRIA E ACOMPANHANTE

| Tabela | Descrição |
|--------|-----------|
| `acompanhante` | Acompanhantes |
| `paciente_vinculo` | Vínculos |

---

# 🏥 SERVIÇOS ESPECIALIZADOS

## Ambulância

| Tabela | Descrição |
|--------|-----------|
| `ambulancia` | Ambulâncias |
| `ambulancia_evento` | Eventos |

## Gasoterapia

| Tabela | Descrição |
|--------|-----------|
| `gaso_solicitacao` | Solicitações |
| `gaso_evento` | Eventos |
| `gasoterapia_consumo` | Consumo |
| `gasoterapia_consumo_evento` | Eventos |

## Ambulatório

| Tabela | Descrição |
|--------|-----------|
| `ambulatorio_atendimento` | Atendimento |
| `retorno_atendimento` | Retorno |

---

# 📋 AGENDAMENTO

| Tabela | Descrição |
|--------|-----------|
| `agendamento` | Agendamentos |
| `agenda_disponibilidade` | Disponibilidade |
| `agendamentos_eventos` | Eventos |
| `servico_agendamento` | Serviços |

---

# 🌐 INTEGRAÇÃO E EXTERNO

| Tabela | Descrição |
|--------|-----------|
| `codigo_externo_map` | Mapeamento códigos |
| `codigo_externo_vinculo` | Vínculos |
| `codigo_universal` | Códigos universais |
| `codigo_prefixo_config` | Prefixos |
| `codigo_prefixo_regra` | Regras prefixo |
| `identificador_global_assistencial` | Identificador global |
| `integracao_mensageria_externa` | Mensageria |
| `operacao_idempotencia` | Idempotência |

---

# 📊 PRODUVIDADES E RELATÓRIOS

| Tabela | Descrição |
|--------|-----------|
| `produtividade_evento` | Eventos produtividade |
| `plantao` | Plantões |
| `plantao_escala` | Escalas |
| `plantao_modelo` | Modelos |
| `escala_medica` | Escala médica |
| `escala_plantao` | Escala plantão |
| `escala_plantao_atual` | Atual |
| `escala_profissional` | Escala profissional |

---

# 📋 OUTRAS TABELAS IMPORTANTES

| Tabela | Descrição |
|--------|-----------|
| `gpat` | GPAT |
| `gpat_atendimento` | GPAT atendimento |
| `gpat_item` | Itens |
| `gpat_dispensacao` | Dispensação |
| `gpat_evento` | Eventos |
| `ffa` | FFA |
| `ffa_item` | Itens |
| `ffa_evento` | Eventos |
| `ffa_diagnostico` | Diagnóstico |
| `ffa_estado` | Estado |
| `ffa_evolucao` | Evolução |
| `ffa_extra` | Extra |
| `ffa_procedimento` | Procedimento |
| `ffa_substatus` | Substatus |
| `ffa_prioridade` | Prioridade |
| `cat` | CAT |
| `cat_acidente_trabalho` | Acidente trabalho |
| `cat_evento` | Eventos |
| `notificacao_epidemiologica` | Notificação |
| `notificacao_violencia` | Violência |
| `obito` | Óbito |
| `obito_evento` | Eventos |
| `interconsulta` | Interconsulta |
| `intercorrencia` | Intercorrência |
| `reabertura_atendimento` | Reabertura |
| `prioridade_social` | Prioridade social |
| `protocolo_assistencial_global` | Protocolo global |
| `protocolo_emissao` | Emissão |
| `protocolo_sequencia` | Sequência |
| `qualidade_eventos_adversos` | Eventos adversos |
| `caixa` | Caixa |
| `caixa_evento` | Eventos |
| `contrato` | Contratos |
| `fornecedor` | Fornecedores |
| `forma_pagamento` | Forma pagamento |
| `produto` | Produtos |
| `tenant_registry` | Multi-tenant |
| `rh_evento` | RH eventos |
| `rh_pessoa_vinculo` | RH vínculo |
| `rh_registro_profissional` | Registro |

---

# 👁️ VIEWS DO BANCO

| View | Descrição |
|------|-----------|
| `vw_conciliacao_faturamento` | Conciliação |
| `vw_estoque_assistencial` | Estoque assistencial |
| `vw_estoque_central` | Estoque central |
| `vw_estoque_farmacia` | Estoque pharmacy |
| `vw_fila_painel` | Fila para painel |
| `vw_gestao_fluxo_tempo_real` | Fluxo tempo real |
| `vw_laboratorio_protocolos_pendentes` | Protocolos pendentes |
| `vw_laboratorio_protocolos_por_gpat` | Por GPAT |
| `vw_painel_config_efetiva` | Config efetiva |
| `vw_painel_config_json` | Config JSON |
| `vw_painel_senhas_chamando_por_painel` | Senhas chiamndo |
| `vw_rastreio_cat_por_ffa` | Rastreio CAT |
| `vw_rastreio_ffa_gpat` | Rastreio FFA |
| `vw_senhas_ativas` | Senhas ativas |
| `vw_usuario_contextos` | Contextos usuário |
| `vw_usuario_permissoes` | Permissões usuário |
| `vw_workflow_ffa_completo` | Workflow completo |
| `vw_workflow_ffa_eventos_materializado` | Eventos materializados |

---

# 🗂️ STORED PROCEDURES (SP) DO SISTEMA

> **Total: 224 procedures + 3 functions** (extraídas do dump `Dump20260322 (2).sql`)

---

## 📌 FUNCTIONS (3)

| Function | Descrição |
|----------|-----------|
| `fn_decision_fingerprint` | Fingerprint de decisão |
| `fn_runtime_chain_fingerprint` | Fingerprint de cadeia runtime |
| `fn_sha256i_hash` | Hash SHA256 |

---

## 🔐 AUTH E SESSÃO

| Procedure | Descrição |
|-----------|-----------|
| `sp_auth_contexto_get` | Buscar contexto |
| `sp_auth_contexto_set` | Definir contexto |
| `sp_auth_menu_get` | Buscar menu do usuário |
| `sp_master_login` | Login master |
| `sp_sessao_abrir` | Abrir sessão |
| `sp_sessao_assert` | Validar sessão |
| `sp_sessao_contexto_get` | Buscar contexto da sessão |
| `sp_sessao_contexto_set` | Definir contexto da sessão |
| `sp_sessao_encerrar` | Encerrar sessão |
| `sp_sessao_tem_permissao` | Verificar permissão |
| `sp_admin_sessao_revogar` | Revogar sessão |
| `sp_usuario_refresh_token_emitir` | Emitir refresh token |
| `sp_usuario_refresh_token_revogar` | Revogar refresh token |
| `sp_usuario_refresh_token_validar` | Validar refresh token |

---

## 👤 USUÁRIO

| Procedure | Descrição |
|-----------|-----------|
| `sp_master_admin_gerenciar_usuarios` | Gerenciar usuários |
| `sp_usuario_criar_contexto` | Criar contexto |
| `sp_usuario_definir_senha` | Definir senha |
| `sp_usuario_hash_gerar` | Gerar hash |
| `sp_usuario_hash_verificar` | Verificar hash |
| `sp_usuario_log_acesso_registrar` | Registrar acesso |
| `sp_usuario_possui_acesso_setor` | Verificar acesso setor |
| `sp_usuario_reset_senha_ti` | Reset senha TI |
| `sp_usuario_tem_permissao` | Verificar permissão |
| `sp_usuario_trocar_senha` | Trocar senha |
| `sp_usuario_vincular_local` | Vincular local |
| `sp_usuario_vincular_sistema` | Vincular sistema |
| `sp_usuario_vincular_unidade` | Vincular unidade |

---

## 🚀 MASTER DISPATCHER

| Procedure | Descrição |
|-----------|-----------|
| `sp_master_dispatcher` | **Dispatcher principal** |
| `sp_master_routes` | Rotas do sistema |
| `sp_master_query_dispatcher` | Query dispatcher |
| `sp_master_orquestradora` | Orquestradora master |
| `sp_master_administracao_medicacao` | Admin medicação |
| `sp_master_administracao_medicacao_ordem` | Ordem medicação |
| `sp_master_agenda_disponibilidade` | Agenda disponibilidade |
| `sp_master_agendamento_eventos` | Agendamento |
| `sp_master_alerta_consumo` | Alerta consumo |
| `sp_master_assistencial_salvar_orquestradora` | Assistencial |
| `sp_master_atendimento` | Atendimento master |
| `sp_master_atendimento_cancelar` | Cancelar |
| `sp_master_atendimento_finalizar` | Finalizar |
| `sp_master_atendimento_iniciar` | Iniciar |
| `sp_master_atendimento_transicionar` | Transicionar |
| `sp_master_cancelar_administracao_medicacao` | Cancelar medicação |
| `sp_master_chamar_senha` | Chamar senha |
| `sp_master_ffa_movimentar` | Movimentar FFA |
| `sp_master_registrar_administracao_medicacao` | Registrar admin |
| `sp_master_registrar_alerta` | Registrar alerta |
| `sp_master_registrar_erro` | Registrar erro |
| `sp_master_registrar_evento` | Registrar evento |
| `sp_master_senha_emitir` | Emitir senha |
| `sp_master_senha_recepcao` | Senha recepção |
| `sp_master_vincular_atendimento_paciente` | Vincular paciente |

---

## 🏥 ATENDIMENTO

| Procedure | Descrição |
|-----------|-----------|
| `sp_atendimento_finalizar_evasao` | Finalizar evasão |
| `sp_atendimento_senha_nao_compareceu` | Não compareceu |
| `sp_atendimento_transicionar` | Transicionar |
| `sp_executor_assistencial_atendimento_finalizar` | Finalizar |
| `sp_executor_assistencial_atendimento_iniciar` | Iniciar |
| `sp_executor_recepcao_abrir_atendimento` | Abrir recepção |
| `sp_medico_encaminhar` | Encaminhar médico |
| `sp_medico_finalizar` | Finalizar médico |
| `sp_medico_marcar_retorno` | Marcar retorno |
| `sp_worker_atendimento` | Worker atendimento |

---

## 🎫 TRIAGEM

| Procedure | Descrição |
|-----------|-----------|
| `sp_executor_assistencial_triagem_finalizar` | Finalizar triagem |
| `sp_executor_assistencial_triagem_iniciar` | Iniciar triagem |
| `sp_executor_assistencial_triagem_salvar` | Salvar triagem |
| `sp_triagem_classificar_senha` | Classificar senha |
| `sp_triagem_finalizar` | Finalizar triagem |

---

## 📋 FILA E SENHA

| Procedure | Descrição |
|-----------|-----------|
| `sp_chamar_senha` | Chamar senha |
| `sp_complementar_senha` | Complementar senha |
| `sp_criar_senha` | Criar senha |
| `sp_fila_chamar_proxima` | Chamar próxima |
| `sp_fila_finalizar` | Finalizar fila |
| `sp_fila_tipo_por_local` | Tipo por local |
| `sp_finalizar_senha` | Finalizar senha |
| `sp_finalizar_procedimento_ecg` | Finalizar ECG |
| `sp_finalizar_procedimento_geral` | Procedimento geral |
| `sp_finalizar_procedimento_laboratorio` | Procedimento lab |
| `sp_recepcao_complementar_e_abrir_ffa` | Complementar e abrir |
| `sp_recepcao_encaminhar_ffa` | Encaminhar FFA |
| `sp_recepcao_gerar_senha` | Gerar senha |
| `sp_recepcao_iniciar_complementacao` | Iniciar complementação |
| `sp_recepcao_nao_compareceu` | Não compareceu |
| `sp_rechamar_procedimento` | Rechamar |
| `sp_senha_cancelar` | Cancelar senha |
| `sp_senha_chamar` | Chamar senha |
| `sp_senha_chamar_proxima` | Chamar próxima |
| `sp_senha_chamar_setor` | Chamar setor |
| `sp_senha_emitir` | Emitir senha |
| `sp_senha_finalizar` | Finalizar senha |
| `sp_senha_iniciar_complementacao` | Iniciar complementação |
| `sp_senha_nao_atendida` | Não atendida |
| `sp_senha_nao_compareceu` | Não compareceu |
| `sp_senha_rechamar` | Rechamar senha |
| `sp_senha_retorno_reinserir` | Retorno reinserir |
| `sp_senha_transicionar_status` | Transicionar status |
| `sp_totem_gerar_senha` | Gerar totem |
| `sp_painel_cancelar_senha` | Cancelar painel |
| `sp_painel_chamar_senha` | Chamar painel |
| `sp_painel_inserir_senha` | Inserir painel |

---

## 🏥 ASSISTENCIAL

| Procedure | Descrição |
|-----------|-----------|
| `sp_execucao_assistencial` | Execução |
| `sp_executor_assistencial_anamnese_salvar` | Salvar anamnese |
| `sp_executor_assistencial_evolucao_salvar` | Salvar evolução |
| `sp_executor_assistencial_runtime` | Runtime assistencial |
| `sp_executor_cadastro_paciente_salvar` | Salvar paciente |
| `sp_executor_estoque_runtime` | Runtime estoque |
| `sp_executor_faturamento_runtime` | Runtime faturamento |
| `sp_executor_fila_runtime` | Runtime fila |
| `sp_executor_manchester_runtime` | Runtime Manchester |
| `sp_gatekeeper_assistencial` | Gatekeeper |
| `sp_oraculo_assistencial` | Oracle |
| `sp_orquestrador_assistencial` | Orquestrador |

---

## 💊 FARMÁCIA

| Procedure | Descrição |
|-----------|-----------|
| `sp_farm_dispensacao_criar` | Criar dispensação |
| `sp_farm_dispensacao_registrar` | Registrar dispensação |
| `sp_farm_reserva_confirmar` | Confirmar reserva |
| `sp_farmacia_dispensar_registrar` | Registrar dispensar |
| `sp_medicacao_cancelar` | Cancelar medicação |
| `sp_medicacao_complementar` | Complementar medicação |
| `sp_medicacao_em_execucao_obs` | Em execução |
| `sp_medicacao_finalizar` | Finalizar medicação |
| `sp_medicacao_marcar_executado` | Marcar executado |
| `sp_medicacao_nao_respondeu` | Não respondeu |

---

## 🏥 INTERNAÇÃO

| Procedure | Descrição |
|-----------|-----------|
| `sp_internacao_registrar_evasao` | Registrar evasão |

---

## 🧪 LABORATÓRIO

| Procedure | Descrição |
|-----------|-----------|
| `sp_gera_protocolo_lab` | Gerar protocolo |
| `sp_lab_protocolo_criar_ou_mapear` | Criar/mapear protocolo |
| `sp_laboratorio_protocolo_evento_add` | Adicionar evento |
| `sp_procedimento_protocolo_criar` | Criar protocolo |
| `sp_protocolo_emitir` | Emitir protocolo |

---

## 📦 ESTOQUE

| Procedure | Descrição |
|-----------|-----------|
| `sp_estoque_fluxo_his` | Fluxo histórico |
| `sp_estoque_movimentar` | Movimentar |
| `sp_estoque_movimentar_extremo` | Movimentar extremo |
| `sp_estoque_movimento_criar` | Criar movimento |
| `sp_estoque_movimento_item_add` | Adicionar item |
| `sp_estoque_produto_criar_com_codigo` | Criar produto |
| `sp_estoque_produto_set_codigo` | Setar código |
| `sp_conciliador_estoque_faturamento` | Conciliar |
| `sp_fluxo_estoque` | Fluxo estoque |

---

## 🏥 FFA (Fluxo de Atendimento)

| Procedure | Descrição |
|-----------|-----------|
| `sp_ffa_adicionar_item` | Adicionar item |
| `sp_ffa_gpat_garantir` | Garantir GPAT |
| `sp_ffa_gpat_gerar` | Gerar GPAT |
| `sp_ffa_orquestrador_transicao` | Transição FFA |
| `sp_timeout_ffa` | Timeout FFA |
| `sp_workflow_ffa_rebuild` | Rebuild workflow |

---

## 💰 FATURAMENTO

| Procedure | Descrição |
|-----------|-----------|
| `sp_pdv_venda_criar` | Criar venda PDV |

---

## 🔄 KERNEL E RUNTIME

| Procedure | Descrição |
|-----------|-----------|
| `sp_dispatcher_kernel` | Dispatcher kernel |
| `sp_emitir_evento_manchester` | Emitir evento Manchester |
| `sp_motor_manchester_runtime` | Motor Manchester |
| `sp_coordenador_global` | Coordenador global |
| `sp_checkpoint_global_validar` | Validar checkpoint |
| `sp_contexto_assert_permissao` | Assert permissão |
| `sp_contexto_assert_transicao` | Assert transição |
| `sp_invariant_engine` | Engine invariante |
| `sp_kernel_cleanup_expired` | Cleanup expired |
| `sp_kernel_identity_chain_register` | Registrar identidade |
| `sp_kernel_runtime_heartbeat` | Heartbeat |
| `sp_kernel_writer_lock` | Lock writer |
| `sp_kernel_writer_unlock` | Unlock writer |
| `sp_runtime_clinico_exec` | Exec clínico |
| `sp_runtime_decision_engine` | Decision engine |
| `sp_runtime_edge_executor` | Edge executor |
| `sp_runtime_escudo_total` | Escudo total |
| `sp_runtime_feedback` | Feedback |
| `sp_runtime_resiliente_execucao` | Execução resiliente |
| `sp_reconciliar_runtime` | Reconciliar runtime |
| `sp_sync_federado_executor` | Sync federado |
| `sp_retry_semantico_worker` | Retry worker |

---

## 🛡️ GUARDIÃO (GUARD)

| Procedure | Descrição |
|-----------|-----------|
| `sp_guardiao_absoluto` | Guardião absoluto |
| `sp_guardiao_runtime_assert` | Runtime assert |
| `sp_guardiao_runtime_decidir` | Runtime decidir |
| `sp_guardiao_runtime_final` | Runtime final |
| `sp_fluxo_guardiao_transicao` | Transição guardião |
| `sp_fluxo_verificar_autorizacao` | Verificar autorização |

---

## 🔀 FLUXO E WORKFLOW

| Procedure | Descrição |
|-----------|-----------|
| `sp_fluxo_executor_matriz` | Executor matriz |
| `sp_validar_transicao_fluxo` | Validar transição |
| `sp_operacao_encaminhar` | Encaminhar operação |
| `sp_nome_operacao` | Nome operação |

---

## 🏥 PROCEDIMENTOS

| Procedure | Descrição |
|-----------|-----------|
| `sp_iniciar_execucao_procedimento_rx` | Iniciar RX |
| `sp_finalizar_procedimento_rx` | Finalizar RX |
| `sp_rechamar_procedimento` | Rechamar |
| `sp_timeout_procedimento_rx` | Timeout RX |
| `sp_raim_calcular` | Calcular RAIM |

---

## 📋 CÓDIGOS

| Procedure | Descrição |
|-----------|-----------|
| `sp_codigo_emitir_interno` | Emitir interno |
| `sp_codigo_mapear_externo` | Mapear externo |
| `sp_codigo_prefixo_resolver` | Resolver prefixo |
| `sp_codigo_prefixo_set` | Setar prefixo |
| `sp_cat_abrir_por_item` | Abrir CAT |

---

## 📊 LEDGER

| Procedure | Descrição |
|-----------|-----------|
| `sp_auditoria_evento_registrar` | Registrar auditoria |
| `sp_ledger_evento_log` | Log evento |
| `sp_ledger_registrar_evento` | Registrar evento |
| `sp_auditar_erro_sql` | Auditar erro SQL |

---

## 🔒 PERMISSÃO

| Procedure | Descrição |
|-----------|-----------|
| `sp_permissao_assert` | Assert permissão |
| `sp_permissao_validar` | Validar permissão |
| `sp_acl_registrar_evento` | Registrar ACL |

---

## 🔧 SEEDS E ADMIN

| Procedure | Descrição |
|-----------|-----------|
| `seed_usuarios_teste` | Seed usuários teste |
| `sp_local_operacional_seed_padrao` | Seed local operacional |
| `sp_painel_filtro_locais_seed` | Seed filtros painel |
| `sp_painel_seed_especialidades` | Seed especialidades |
| `sp_patch_log` | Log patch |
| `sp_patch_permissao` | Patch permissão |
| `sp_patch_usuario_fk_idx` | Patch índice |
| `sp_schema_add_column_if_missing` | Add coluna |
| `sp_schema_add_index_if_missing` | Add índice |
| `sp_seed_admin_root_runtime` | Seed admin root |
| `sp_seed_clinico_sintetico_hardcore` | Seed clínico |
| `sp_seed_dummy_funcionario_500` | Seed 500 funcionários |
| `sp_seed_dummy_paciente_500` | Seed 500 pacientes |
| `sp_seed_dummy_senha_fila_500` | Seed 500 senhas |
| `sp_seed_dummy_usuarios_500` | Seed 500 usuários |
| `sp_seed_runtime_assistencial` | Seed runtime assistencial |
| `sp_seed_runtime_funcionario_full` | Seed funcionário full |
| `sp_seed_saas_federado` | Seed SAAS federado |
| `sp_admin_painel_filtros_seed_all` | Seed todos filtros |

---

## 🔀 SEQUÊNCIA

| Procedure | Descrição |
|-----------|-----------|
| `sp_sequencia_proximo_numero` | Próximo número |

---

## 📋 REGISTRO DE EVENTOS

| Procedure | Descrição |
|-----------|-----------|
| `sp_registrar_evento` | Registrar evento |
| `sp_assert_not_null` | Assert not null |
| `sp_assert_true` | Assert true |

---

## 👁️ AUXILIARES

| Procedure | Descrição |
|-----------|-----------|
| `sp_paciente_cns_set` | Setar CNS |
| `sp_raise` | Raise erro |
| `sp_pedido_medico_criar` | Criar pedido médico |
| `sp_pedido_medico_item_add` | Add item pedido |

---

# 📋 ÍNDICES PRINCIPAIS

## Auth

- `auth_sessao.id_sessao` (PK)
- `auth_sessao.token` (UNIQUE)
- `auth_sessao.id_usuario`
- `usuario.login` (UNIQUE)
- `usuario.email`

## Atendimento

- `atendimento.id_atendimento` (PK)
- `atendimento.id_paciente`
- `atendimento.id_profissional`
- `atendimento.id_local`
- `atendimento.data_entrada`

## Paciente

- `paciente.id_paciente` (PK)
- `paciente.cpf` (UNIQUE)
- `paciente.cns` (UNIQUE)
- `paciente.nome`

## Local

- `local.id_local` (PK)
- `local.id_unidade`
- `local.codigo`

---

# 🔗 RELACIONAMENTOS PRINCIPAIS

```
usuario (1:N) usuario_perfil (N:1) perfil
usuario (1:N) usuario_unidade (N:1) unidade
usuario (1:N) usuario_local (N:1) local

perfil (1:N) perfil_permissao (N:1) permissao

atendimento (N:1) paciente
atendimento (N:1) unidade
atendimento (N:1) local
atendimento (N:1) profissional

atendimento_triagem (N:1) atendimento
atendimento_triagem (N:1) classificacao_risco

prescricao (N:1) atendimento
prescricao_item (N:1) prescricao
prescricao_item (N:1) produto

estoque_movimento (N:1) estoque_local
estoque_movimento_item (N:1) estoque_movimento
estoque_movimento_item (N:1) produto
```

---

# 📌 PROCEDURES DO DISPATCHER (sp_master_dispatcher)

Parâmetros de entrada:
- `p_id_sessao` - ID da sessão
- `p_uuid_transacao` - UUID da transação
- `p_dominio` - Domínio (auth, operacional, cadastros, etc)
- `p_acao` - Ação a executar
- `p_id_referencia` - ID de referência
- `p_payload` - Payload JSON

 Estrutura de resposta:
```json
{
  "sucesso": true,
  "mensagem": "...",
  "resultado": {},
  "metadata": {}
}
```

---

# 🎯 TABELAS CRÍTICAS PARA O SISTEMA

| Prioridade | Tabelas |
|------------|---------|
| 🔴 Crítica | `auth_sessao`, `usuario`, `perfil`, `permissao`, `perfil_permissao` |
| 🟠 Alta | `atendimento`, `paciente`, `local`, `unidade`, `senha`, `fila` |
| 🟡 Média | `prescricao`, `estoque_produto`, `estoque_movimento`, `faturamento_conta` |
| 🟢 Normal | Demais tabelas |

---

# 📝 RESUMO POR MÓDULO

| Módulo | Tabelas |
|--------|---------|
| Auth | 12 |
| Usuário | 14 |
| Perfil/Permissão | 3 |
| Pessoa/Paciente | 18 |
| Estrutura Organizacional | 16 |
| Profissional | 7 |
| Atendimento | 18 |
| Triagem | 3 |
| Prescrição | 11 |
| Farmácia | 11 |
| Internação | 13 |
| Laboratório | 12 |
| Estoque | 26 |
| Faturamento | 16 |
| Fluxo/Workflow | 6 |
| Manutenção | 6 |
| Kernel/Runtime | 22 |
| Painel/Fila | 21 |
| Documentação | 6 |
| Outros | 40+ |

---

*Documento gerado automaticamente a partir do dump `Dump20260322 (2).sql`*
*Total: 478 tabelas + 20 views*

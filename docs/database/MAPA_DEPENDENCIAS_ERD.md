# MAPA DE DEPENDÊNCIAS E ERD
**Banco:** pronto_atendimento (Dump20260606.sql)  
**Data:** 2026-06-30  
**Status:** Inventário consolidado

---

## ESTATÍSTICAS

| Métrica | Valor |
|---------|-------|
| Total tabelas | 478 |
| Tabelas raiz | 47 |
| Tabelas folha | 186 |
| Tabelas centrais | 245 |
| Ciclos detectados | 0 |
| Tabelas órfãs (sem FK) | 47 |

---

## TABELAS POR DOMÍNIO

### CORE / IDENTIDADE / MULTI-TENANT
- `saas_entidade` — entidade raiz do tenant
- `tenant_registry` — registro de tenants
- `saas_contrato` — contratos SaaS
- `pessoa` — entidade raiz de pessoas
- `pessoa_documento` — documentos de pessoa
- `pessoa_endereco` — endereços de pessoa
- `pessoa_telefone` — telefones de pessoa
- `pessoa_email` — e-mails de pessoa
- `pessoa_identificador` — identificadores (CPF, RG, CNS)
- `pessoa_vinculo` — vínculos entre pessoas
- `pessoa_alergias` — alergias de pessoa
- `pessoa_conselho_registro` — conselhos profissionais
- `pessoa_contato` — contatos de pessoa
- `pessoa_logradouro` — logradouros de pessoa

### IAM / AUTH
- `usuario` — usuários do sistema
- `usuario_perfil` — perfis de usuário
- `usuario_sistema` — sistemas de usuário
- `usuario_unidade` — unidades de usuário
- `usuario_setor` — setores de usuário
- `usuario_local` — locais de usuário
- `usuario_contexto` — contextos de usuário
- `usuario_sala` — salas de usuário
- `usuario_alocacao` — alocações de usuário
- `usuario_historico_senha` — histórico de senha
- `usuario_senha_historico` — histórico de senha
- `usuario_senha_reset` — reset de senha
- `usuario_reset_senha` — reset de senha
- `usuario_refresh` — refresh tokens
- `usuario_refresh_token` — refresh tokens
- `usuario_log_acesso` — log de acesso
- `usuario_profissional_registro` — registros profissionais
- `usuario_sistema_acl_evento` — eventos ACL
- `perfil` — perfais de acesso
- `perfil_permissao` — permissões de perfil
- `permissao` — permissões
- `auth_sessao` — sessões
- `auth_token` — tokens
- `auth_grupo` — grupos
- `auth_grupo_permissao` — permissões de grupo
- `auth_grupo_usuario` — usuários em grupos
- `auth_tentativa_login` — tentativas de login
- `auth_log` — logs de autenticação
- `auth_audit` — auditoria de auth
- `auth_bloqueio` — bloqueios
- `auth_notificacao` — notificações de auth
- `auth_parametro` — parâmetros de auth
- `auth_sessao_dispositivo` — dispositivos de sessão
- `sessao_usuario` — sessões de usuário
- `sessao_ativa` — sessões ativas
- `sessao_evento` — eventos de sessão
- `sessao_contexto_historico` — histórico de contexto
- `login_tentativa` — tentativas de login
- `runtime_contexto` — contexto de runtime
- `runtime_dispositivo` — dispositivos de runtime
- `runtime_api_session_token` — tokens de sessão API

### PORTAL / DISPLAY
- `portal_categoria` — categorias do portal (EXTRA — não no dump)
- `portal_noticia` — notícias do portal (EXTRA — não no dump)
- `painel` — painéis de chamada
- `painel_config` — configuração de painel
- `painel_config_def` — definição de painel
- `painel_evento_stream` — stream de eventos
- `painel_fila_tipo` — tipos de fila
- `painel_grupo` — grupos de painel
- `painel_grupo_local` — locais de grupo
- `painel_lane` — lanes de painel
- `painel_local` — locais de painel
- `painel_mensagem` — mensagens de painel
- `painel_mensagem_consumo` — consumo de mensagens
- `painel_alertas_tempo` — alertas de tempo
- `painel_consumo_evento` — eventos de consumo
- `painel_monitoramento_especialidade` — monitoramento
- `totem` — totens de autoatendimento
- `totem_evento` — eventos de totem
- `totem_feedback` — feedback de totem
- `totem_senha_opcao` — opções de senha
- `tv_rotativo` — TVs rotativas
- `tv_rotativo_tela` — telas de TV rotativa
- `local` — locais operacionais
- `local_operacional` — locais operacionais
- `local_fila` — filas de local
- `local_dispositivo` — dispositivos de local
- `local_capacidade` — capacidade de local
- `local_runtime` — runtime de local
- `local_turno` — turnos de local
- `sala_notificacao` — notificações de sala
- `sala_notificacao_evento` — eventos de notificação
- `setor` — setores
- `leito` — leitos
- `hospital_leitos` — leitos hospitalares
- `config_leitos` — configuração de leitos
- `tipo_local` — tipos de local
- `tipo_sala` — tipos de sala
- `ambiente` — ambientes
- `dispositivo` — dispositivos
- `dispositivo_tipo` — tipos de dispositivo

### RUNTIME / KERNEL
- `runtime_execution_queue` — fila de execução
- `runtime_sync_queue` — fila de sync
- `runtime_sync_log` — log de sync
- `runtime_concurrency_guard` — guarda de concorrência
- `runtime_lock_semantico` — lock semântico
- `runtime_kernel_locks` — locks de kernel
- `runtime_snapshot_governanca` — snapshot de governança
- `runtime_snapshot_metadata` — metadados de snapshot
- `runtime_estado_sobrevivencia` — estado de sobrevivência
- `runtime_evento_provisional` — eventos provisionais
- `runtime_invariant_log` — log invariante
- `runtime_edge_evento` — eventos edge
- `runtime_api_session_token` — tokens API
- `kernel_ledger` — ledger do kernel
- `kernel_runtime_evento` — eventos de runtime
- `kernel_runtime_heartbeat` — heartbeat
- `kernel_runtime_single_writer_lock` — lock single writer
- `kernel_single_writer_lock` — lock single writer
- `kernel_authz_policy` — políticas de authz
- `kernel_identity_trust_chain` — cadeia de confiança
- `assistencial_checkpoint_global` — checkpoint global
- `assistencial_circuit_breaker` — circuit breaker
- `assistencial_evento_hash` — hash de eventos
- `assistencial_minipal_metric` — métricas minipal
- `assistencial_quorum_clinico` — quorum clínico
- `assistencial_raim_metric` — métricas RAIM
- `assistencial_runtime_federado` — runtime federado
- `assistencial_runtime_panel` — painel runtime
- `assistencial_simulacao_futura` — simulação futura
- `assistencial_snapshot_runtime` — snapshot runtime
- `assistencial_telemetria_runtime` — telemetria
- `assistencial_watchdog_fila` — watchdog de fila
- `guardiao_acl_runtime` — guardião ACL
- `guardiao_runtime_final` — guardião final
- `hardening_sp_excecao` — exceções de hardening
- `schema_patch_execucao` — execução de patches
- `operacao_idempotencia` — idempotência

### HEALTHCARE / HIS
- `paciente` — pacientes
- `paciente_canonico` — paciente canônico
- `paciente_cns` — CNS de paciente
- `paciente_cns_evento` — eventos de CNS
- `paciente_alertas` — alertas de paciente
- `ffa` — Ficha de Atendimento (FFA)
- `ffa_demandas_externas` — demandas externas
- `ffa_diagnostico` — diagnósticos FFA
- `ffa_estado` — estado da FFA
- `ffa_estoque_conciliacao` — conciliação estoque
- `ffa_evolucao` — evolução da FFA
- `ffa_extra` — campos extras
- `ffa_historico_status` — histórico de status
- `ffa_item` — itens da FFA
- `ffa_prioridade` — prioridades da FFA
- `ffa_procedimento` — procedimentos da FFA
- `ffa_sinais_vitais` — sinais vitais
- `ffa_substatus` — substatus da FFA
- `senha` — senhas de atendimento
- `senha_eventos` — eventos de senha
- `senha_sequencia` — sequência de senha
- `senha_status` — status de senha
- `senha_transicao_matriz` — matriz de transição
- `fila_operacional` — filas operacionais
- `fila_operacional_evento` — eventos de fila
- `fila_painel_runtime` — painel runtime
- `fila_retorno` — fila de retorno
- `fila_senha` — fila de senhas
- `fila_evento` — eventos de fila
- `atendimento` — atendimentos
- `atendimento_anamnese` — anamnese
- `atendimento_balanco_hidrico` — balanço hídrico
- `atendimento_checagem` — checagens
- `atendimento_desfecho` — desfecho
- `atendimento_diagnostico` — diagnósticos
- `atendimento_escalas_risco` — escalas de risco
- `atendimento_estado_ativo` — estado ativo
- `atendimento_evento` — eventos
- `atendimento_evento_ledger` — ledger de eventos
- `atendimento_evolucao` — evolução
- `atendimento_exame_fisico` — exame físico
- `atendimento_identidade_fluxo` — identidade do fluxo
- `atendimento_movimentacao` — movimentações
- `atendimento_observacao` — observações
- `atendimento_pedidos_exame` — pedidos de exame
- `atendimento_pre_hospitalar` — pré-hospitalar
- `atendimento_prescricao` — prescrições
- `atendimento_profissional` — profissionais
- `atendimento_recepcao` — recepção
- `atendimento_sinais_vitais` — sinais vitais
- `atendimento_sumario_alta` — sumário de alta
- `atendimento_transicao_ledger` — ledger de transição
- `atendimento_triagem` — triagem
- `atendimento_vinculo` — vínculos
- `triagem` — triagens
- `anamnese` — anamneses
- `anotacao_enfermagem` — anotações de enfermagem
- `evolucao_enfermagem` — evolução de enfermagem
- `evolucao_medica` — evolução médica
- `evolucao_multidisciplinar` — evolução multidisciplinar
- `exame` — exames
- `exame_fisico` — exame físico
- `exame_historico` — histórico de exames
- `exame_pedido` — pedidos de exame
- `exame_pedido_item` — itens de pedido
- `solicitacao_exame` — solicitações
- `prescricao` — prescrições
- `prescricao_item` — itens de prescrição
- `prescricao_itens` — itens de prescrição
- `prescricao_medica` — prescrição médica
- `prescricao_medicacao` — medicação prescrita
- `prescricao_continua` — prescrição contínua
- `prescricao_internacao` — prescrição de internação
- `prescricao_checagem` — checagem de prescrição
- `prescricao_checagem_dupla` — checagem dupla
- `prescricao_kit_master` — kit master
- `prescricao_kit_itens` — itens de kit
- `internacao` — internações
- `internacao_prescricao` — prescrições de internação
- `internacao_prescricao_item` — itens de prescrição
- `internacao_registro_enfermagem` — registros de enfermagem
- `internacao_turno_registro` — registros de turno
- `internacao_historico` — histórico de internação
- `internacao_movimentacao` — movimentações
- `internacao_cuidados` — cuidados
- `internacao_dietas` — dietas
- `internacao_dispositivos` — dispositivos
- `internacao_medicacao_administracao` — administração
- `internacao_braden_avaliacao` — avaliação Braden
- `internacao_ferida_avaliacao` — avaliação de ferida
- `medicacao_reavaliacao` — reavaliação
- `administracao_medicacao` — administração
- `administracao_medicacao_ordem` — ordem de administração
- `obito` — óbitos
- `obito_evento` — eventos de óbito
- `notificacao_epidemiologica` — notificações epidemiológicas
- `notificacao_epidemiologica_evento` — eventos
- `notificacao_violencia` — notificações de violência
- `notificacao_violencia_evento` — eventos
- `sinan_notificacao` — notificações SINAN
- `sinan_evento` — eventos SINAN
- `transporte_ambulancia` — transporte ambulância
- `transporte_ambulancia_evento` — eventos transporte
- `hospital_leitos` — leitos hospitalares
- `config_leitos` — configuração leitos
- `classificacao_risco` — classificação de risco
- `escala_medica` — escalas médicas
- `escala_plantao` — plantões
- `escala_plantao_atual` — plantão atual
- `escala_profissional` — profissionais de escala
- `plantao` — plantões
- `plantao_escala` — escala de plantão
- `plantao_modelo` — modelo de plantão
- `medico` — médicos
- `medico_especialidade` — especialidades
- `enfermagem` — enfermagem
- `enfermagem_aprazamento` — aprazamentos
- `enfermagem_diagnosticos` — diagnósticos
- `funcionario` — funcionários
- `funcionario_conselho_profissional` — conselhos
- `funcionario_especialidade` — especialidades
- `funcionario_unidade` — unidades
- `profissional_registro` — registros profissionais
- `rh_registro_profissional` — registros RH
- `rh_pessoa_vinculo` — vínculos RH
- `rh_evento` — eventos RH
- `interconsulta` — interconsultas
- `intercorrencia` — intercorrências
- `reabertura_atendimento` — reabertura
- `retorno_atendimento` — retorno
- `prioridade_social` — prioridades sociais
- `assistencia_social_atendimento` — atendimento social
- `assistencia_social_evento` — eventos sociais
- `ordem_assistencial` — ordens assistenciais
- `ordem_assistencial_item` — itens
- `ordem_assistencial_execucao` — execução
- `ordem_assistencial_aprazamento` — aprazamento
- `ordem_tipo_documento_config` — config de tipo
- `protocolo_assistencial_global` — protocolo global
- `protocolo_emissao` — emissão
- `protocolo_sequencia` — sequência
- `procedimento_protocolo` — protocolo de procedimento
- `procedimento_protocolo_evento` — eventos
- `procedimento_protocolo_resultado` — resultados
- `procedimentos_sigtap` — procedimentos SIGTAP

### FARMÁCIA
- `farmaco_movimentacao` — movimentação de fármacos
- `farmaco_auditoria` — auditoria
- `farmaco_auditoria_bloqueio` — bloqueios
- `farmaco_unidade` — unidades de fármaco
- `farm_dispensacao` — dispensação
- `farm_dispensacao_item` — itens
- `farm_operacao` — operações
- `farm_convenio_autorizacao` — autorizações
- `farm_receita_controlada` — receitas controladas
- `farm_atendimento_externo` — atendimento externo
- `farmacia_atendimento_externo_dispensacao` — dispensação externa
- `farmacia_atendimento_externo_item` — itens externos
- `farmacia_dispensacao_log` — log de dispensação
- `farmacia_externo_evento` — eventos externos

### ESTOQUE
- `estoque_produto` — produtos
- `estoque_item` — itens
- `estoque_local` — locais
- `estoque_lote` — lotes
- `estoque_lote_snapshot` — snapshot de lotes
- `estoque_saldo` — saldos
- `estoque_saldo_central` — saldo central
- `estoque_saldo_master` — saldo master
- `estoque_movimentacao` — movimentações
- `estoque_movimentacao_itens` — itens de movimentação
- `estoque_movimento` — movimentos
- `estoque_movimento_item` — itens de movimento
- `estoque_inventario` — inventário
- `estoque_inventario_item` — itens de inventário
- `estoque_reserva` — reservas
- `estoque_reserva_evento` — eventos de reserva
- `estoque_conta` — contas
- `estoque_fluxo_assistencial` — fluxo assistencial
- `estoque_execucao` — execução
- `estoque_execucao_pipeline` — pipeline
- `estoque_pipeline_estado` — estado do pipeline
- `estoque_documento_execucao` — documentos de execução
- `estoque_evento_confirmacao` — eventos de confirmação
- `estoque_ledger` — ledger
- `estoque_audit_stream` — stream de auditoria
- `estoque_conciliacao_atomica` — conciliação atômica
- `estoque_produto_codigo_externo` — códigos externos
- `alerta_consumo` — alertas de consumo
- `alerta_destinatario` — destinatários
- `alerta_regra` — regras de alerta
- `alerta` — alertas
- `estoque_alerta` — alertas de estoque
- `consumo_insumo` — consumo de insumos
- `consumo_limpeza` — consumo de limpeza
- `consumo_manutencao` — consumo de manutenção
- `almoxarifado_central` — almoxarifado central
- `estoque_almoxarifado_central` — almoxarifado

### FATURAMENTO / FINANCEIRO
- `faturamento_conta` — contas
- `faturamento_conta_item` — itens de conta
- `faturamento_conta_paciente` — conta de paciente
- `faturamento_conta_seq` — sequência de conta
- `faturamento_convenio` — convênios
- `faturamento_convenios` — convênios
- `faturamento_codigo` — códigos
- `faturamento_evento` — eventos
- `faturamento_insumo` — insumos
- `faturamento_item` — itens
- `faturamento_producao` — produção
- `faturamento_producao_sus` — produção SUS
- `faturamento_regras_validacao` — regras de validação
- `faturamento_sigtap` — SIGTAP
- `faturamento_sus_config` — config SUS
- `caixa` — caixa PDV
- `caixa_evento` — eventos de caixa
- `forma_pagamento` — formas de pagamento
- `venda` — vendas
- `venda_item` — itens de venda
- `venda_pagamento` — pagamentos
- `venda_evento` — eventos de venda
- `pdv_cliente` — clientes PDV
- `pdv_pagamento` — pagamentos PDV
- `pdv_venda` — vendas PDV
- `pdv_venda_item` — itens PDV
- `financeiro_repasse_medico` — repasses médicos
- `contrato` — contratos

### LABORATÓRIO
- `lab_pedido` — pedidos
- `lab_amostra` — amostras
- `lab_resultado` — resultados
- `lab_evento` — eventos
- `lab_protocolo_interno` — protocolos internos
- `laboratorio_protocolo` — protocolos
- `laboratorio_protocolo_evento` — eventos

### AUDITORIA / SEGURANÇA
- `auditoria_acesso` — auditoria de acesso
- `auditoria_almoxarifado` — auditoria almoxarifado
- `auditoria_contexto` — auditoria de contexto
- `auditoria_erro` — auditoria de erros
- `auditoria_estoque` — auditoria de estoque
- `auditoria_estoque_sanitario` — auditoria sanitária
- `auditoria_evento` — auditoria de eventos
- `auditoria_excecoes` — auditoria de exceções
- `auditoria_ffa` — auditoria de FFA
- `auditoria_fila` — auditoria de fila
- `auditoria_mestre` — auditoria mestre
- `auditoria_visualizacao_prontuario` — auditoria de prontuário
- `log_auditoria` — log de auditoria
- `log_acesso_prontuario` — log de acesso
- `log_leitura_prontuario` — log de leitura
- `log_auditoria` — log de auditoria
- `log_acesso_prontuario` — log de acesso
- `log_leitura_prontuario` — log de leitura
- `reg_auditoria_acesso_sensivel` — auditoria acesso sensível
- `reg_formulario_snapshot` — snapshot de formulário
- `qualidade_eventos_adversos` — eventos adversos

### EVENT STORE / LEDGER
- `atendimento_evento` — eventos de atendimento
- `atendimento_evento_ledger` — ledger
- `atendimento_transicao_ledger` — ledger de transição
- `ffa_evento` — eventos de FFA
- `evento_geral` — eventos gerais
- `evento_limpeza` — eventos de limpeza
- `eventos_fluxo` — eventos de fluxo
- `obito_evento` — eventos de óbito
- `observacoes_eventos` — observações
- `sala_notificacao_evento` — eventos de notificação
- `workflow_ffa_evento` — eventos de workflow
- `sincronizacao_federada_evento` — eventos de sincronização
- `ledger_evento_sincronizacao` — eventos de sync
- `ledger_evento_sincronizacao_local` — eventos locais
- `ledger_global_sincronismo` — sincronismo global
- `retry_semantico_controle` — controle de retry
- `tombstone_evento_assistencial` — tombstone

### INTEGRAÇÃO
- `integracao_mensageria_externa` — mensageria externa
- `sinan_notificacao` — notificações SINAN
- `sinan_evento` — eventos SINAN
- `webhook_entrada` — webhooks de entrada
- `webhook_saida` — webhooks de saída
- `integracao` — integrações
- `integracao_credencial` — credenciais

### SAAS / MULTI-TENANT
- `tenant_registry` — registro de tenants
- `saas_contrato` — contratos SaaS
- `saas_entidade` — entidades

### RH / ADMINISTRATIVO
- `funcionario` — funcionários
- `funcionario_unidade` — unidades
- `funcionario_especialidade` — especialidades
- `funcionario_conselho_profissional` — conselhos
- `escala_medica` — escalas médicas
- `escala_plantao` — plantões
- `escala_plantao_atual` — plantão atual
- `escala_profissional` — profissionais de escala
- `plantao` — plantões
- `plantao_escala` — escala de plantão
- `plantao_modelo` — modelo de plantão
- `chamado` — chamados
- `chamado_evento` — eventos
- `chamado_manutencao` — manutenções
- `manutencao_execucao` — execuções

### CRM / SAC
- `cliente` — clientes
- `contrato` — contratos
- `cat_evento` — eventos de catálogo
- `cat_notificacao` — notificações
- `cat_regra_item` — itens de regra
- `cat_acidente_trabalho` — acidentes de trabalho
- `cat_acidente_trabalho_evento` — eventos

### DOCUMENTOS
- `documento_arquivo` — arquivos
- `documento_emissao` — emissões
- `documento_emissao_evento` — eventos de emissão
- `documento_tipo_config` — configuração de tipo
- `assinatura_digital_documentos` — assinaturas de documentos
- `assinatura_digital_prontuario` — assinaturas de prontuário
- `reg_anexo` — anexos
- `reg_export_arquivo` — arquivos de exportação
- `reg_export_item` — itens de exportação
- `reg_export_lote` — lotes de exportação
- `reg_export_erro_validacao` — erros de validação
- `pep_registro` — registros PEP
- `pep_assinatura_digital` — assinaturas PEP

### SOCIAL / WIKI / CHAT
- `social_perfil` — perfis sociais
- `social_post` — posts
- `social_grupo` — grupos
- `social_membro` — membros

### MD / DADOS MESTRE
- `md_competencia` — competências
- `md_cid10` — CID-10
- `md_cnes_estabelecimento` — CNES
- `md_sigpat_medicamento` — medicamentos SIGPAT
- `md_sigtap_procedimento` — procedimentos SIGTAP
- `md_arquivo_fonte` — arquivos fonte
- `md_arquivo_fonte_evento` — eventos
- `sus_competencia` — competências SUS
- `sus_cid10_competencia` — CID-10 SUS
- `sus_cnes_estabelecimento` — CNES SUS
- `sus_sigtap_procedimento` — procedimentos SUS
- `tabela_tuss` — TUSS
- `codigo_universal` — códigos universais
- `codigo_externo_map` — mapeamento externo
- `codigo_externo_vinculo` — vínculos externos
- `codigo_prefixo_config` — configuração de prefixo
- `codigo_prefixo_regra` — regras de prefixo
- `exame` — exames
- `especialidade` — especialidades
- `conselho_profissional` — conselhos
- `fornecedor` — fornecedores
- `produto` — produtos
- `servico_agendamento` — serviços de agendamento
- `agendamento` — agendamentos
- `agenda_disponibilidade` — disponibilidade
- `agendamentos_eventos` — eventos

### LOGÍSTICA / TRANSPORTE
- `viatura` — viaturas
- `remocao` — remoções
- `remocao_evento` — eventos de remoção
- `remocao_logistica` — logística de remoção
- `gaso_solicitacao` — solicitações de gasoterapia
- `gaso_evento` — eventos
- `gasoterapia_consumo` — consumo
- `gasoterapia_consumo_evento` — eventos

### CONFIGURAÇÃO
- `config_sistema` — configurações do sistema
- `configuracao` — configurações
- `config_locais` — configuração de locais
- `config_leitos` — configuração de leitos
- `configuracao` — configurações gerais

### IDENTIFICADORES GLOBAIS
- `identificador_global_assistencial` — identificador global

---

## TABELAS RAIZ (sem FK de saída)

| Tabela | Tipo | Descrição |
|--------|------|-----------|
| `saas_entidade` | PK | Entidade raiz do tenant |
| `tenant_registry` | PK | Tenant |
| `pessoa` | PK | Pessoa |
| `sistema` | PK | Sistema |
| `unidade` | PK/FK | Unidade (FK para saas_entidade) |
| `local` | PK/FK | Local (FK para unidade) |
| `setor` | PK/FK | Setor (FK para local) |
| `leito` | PK/FK | Leito (FK para setor) |
| `perfil` | PK | Perfil |
| `permissao` | PK | Permissão |
| `tipo_local` | PK | Tipo de local |
| `tipo_sala` | PK | Tipo de sala |
| `classificacao_risco` | PK | Classificação de risco |
| `forma_pagamento` | PK | Forma de pagamento |
| `produto` | PK | Produto |
| `fornecedor` | PK | Fornecedor |
| `cidade` | PK | Cidade |
| `logradouro` | PK | Logradouro |
| `md_competencia` | PK | Competência |
| `exame` | PK | Exame |
| `especialidade` | PK | Especialidade |

---

## TABELAS FOLHA (apenas FK de entrada)

| Tabela | FKs Entrando | Descrição |
|--------|--------------|-----------|
| `acompanhante` | 1 | Acompanhante de paciente |
| `medico_especialidade` | 2 | Especialidades de médico |
| `usuario_perfil` | 3 | Perfis de usuário |
| `usuario_unidade` | 3 | Unidades de usuário |
| `usuario_setor` | 2 | Setores de usuário |
| `usuario_local` | 3 | Locais de usuário |
| `usuario_sala` | 3 | Salas de usuário |
| `usuario_alocacao` | 3 | Alocações |
| `login_tentativa` | 1 | Tentativas de login |
| `log_acesso_prontuario` | 2 | Log de acesso |
| `log_leitura_prontuario` | 2 | Log de leitura |
| `lab_amostra` | 3 | Amostras |
| `lab_evento` | 1 | Eventos |
| `lab_resultado` | 2 | Resultados |
| `laboratorio_protocolo_evento` | 1 | Eventos |
| `fila_evento` | 1 | Eventos de fila |
| `totem_evento` | 1 | Eventos de totem |
| `tv_rotativo_tela` | 1 | Telas de TV |

---

## TABELAS CENTRAIS (muitas FKs entrada/saída)

| Tabela | FKs Entrando | FKs Saindo | Centralidade | Descrição |
|--------|--------------|------------|--------------|-----------|
| `atendimento` | 12 | 18 | 30 | Atendimento clínico |
| `ffa` | 15 | 12 | 27 | Ficha de Atendimento |
| `senha` | 8 | 6 | 14 | Senhas de atendimento |
| `usuario` | 25+ | 0 | 25+ | Usuário (hub) |
| `paciente` | 5 | 2 | 7 | Paciente |
| `internacao` | 10 | 8 | 18 | Internação |
| `prescricao` | 8 | 5 | 13 | Prescrição |
| `faturamento_conta` | 6 | 4 | 10 | Faturamento |
| `estoque_movimentacao` | 10 | 3 | 13 | Movimentação |
| `lab_pedido` | 5 | 3 | 8 | Pedido de exame |
| `triagem` | 5 | 1 | 6 | Triagem |

---

## CICLOS DE DEPENDÊNCIA

Nenhum ciclo detectado. O modelo é hierárquico e respeita a ordem de criação.

---

## ORDEM RECOMENDADA DE MIGRATIONS

### Fase 1 — Entidades base
1. `saas_entidade`
2. `tenant_registry`
3. `pessoa`
4. `sistema`
5. `unidade`
6. `cidade`
7. `logradouro`
8. `local`
9. `setor`
10. `leito`

### Fase 2 — IAM
11. `perfil`
12. `permissao`
13. `usuario`
14. `usuario_perfil`
15. `usuario_sistema`
16. `usuario_unidade`
17. `usuario_setor`
18. `usuario_local`
19. `auth_sessao`
20. `auth_token`

### Fase 3 — Healthcare base
21. `paciente`
22. `classificacao_risco`
23. `tipo_local`
24. `tipo_sala`
25. `dispositivo`
26. `dispositivo_tipo`

### Fase 4 — Operacional
27. `ffa`
28. `senha`
29. `fila_operacional`
30. `atendimento`
31. `triagem`

### Fase 5 — Internação
32. `internacao`
33. `internacao_prescricao`
34. `medicacao_reavaliacao`

### Fase 6 — Apoio
35. `exame`
36. `procedimento_protocolo`
37. `medico`
38. `especialidade`
39. `funcionario`

### Fase 7 — Estoque
40. `estoque_produto`
41. `estoque_local`
42. `estoque_lote`
43. `estoque_saldo`
44. `estoque_movimentacao`

### Fase 8 — Faturamento
45. `forma_pagamento`
46. `faturamento_conta`
47. `caixa`

### Fase 9 — Display
48. `painel`
49. `totem`
50. `tv_rotativo`

### Fase 10 — Runtime/Kernel
51. `runtime_execution_queue`
52. `kernel_ledger`
53. `kernel_authz_policy`

### Fase 11 — Auditoria/Eventos
54. `auditoria_mestre`
55. `log_auditoria`
56. `atendimento_evento`

### Fase 12 — Integração/Mestrado
57. `md_competencia`
58. `md_cid10`
59. `sus_sigtap_procedimento`

---

## GARGALOS ARQUITETURAIS

### Tabelas com muitas FKs (>10)
- `atendimento` — 30 dependências
- `ffa` — 27 dependências
- `usuario` — 25+ dependências
- `internacao` — 18 dependências
- `prescricao` — 13 dependências

### Possíveis normalizações
- `pessoa_documento`, `pessoa_endereco`, `pessoa_telefone`, `pessoa_email` — considerar JSONB se performance for crítica
- `prescricao_item` vs `prescricao_itens` — verificar se são duplicatas
- `faturamento_convenio` vs `faturamento_convenios` — verificar duplicação
- `kernel_runtime_single_writer_lock` vs `kernel_single_writer_lock` — verificar duplicação
- `usuario_refresh` vs `usuario_refresh_token` — verificar duplicação
- `usuario_senha_historico` vs `usuario_historico_senha` — verificar duplicação

### Tabelas órfãs (sem FK)
- 47 tabelas sem chaves estrangeiras
- Principais: `pessoa`, `usuario`, `perfil`, `permissao`, `sistema`, `classificacao_risco`, `forma_pagamento`

---

**Arquivo:** docs/database/MAPA_DEPENDENCIAS_ERD.md  
**Status:** Consolidado  
**Próximo:** Catálogo de Entidades do Core + Mapa de Consumo + Mapa de Escrita.

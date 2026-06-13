# Mapa Completo do Banco de Dados - Setores e Landing Pages

## Resumo Geral
- **Total de Tabelas**: ~465
- **Total de Stored Procedures**: ~193
- **Stored Procedures Master**: ~20 (sp_master_*)

---

## 1. RECEPÇÃO / ATENDIMENTO AMBULATORIAL

### Tabelas Principais
| Tabela | Descrição |
|--------|-----------|
| `atendimento` | Registro principal de atendimento |
| `atendimento_recepcao` | Dados de recepção do atendimento |
| `ffa` | Fluxo de Atendimento (principal) |
| `paciente` | Cadastro de pacientes |
| `paciente_canonico` | Paciente canônico (master) |
| `senha` | Senhas de atendimento |
| `fila_senha` | Fila de senhas |
| `fila_operacional` | Fila operacional por setor |
| `fila_retorno` | Retornos |
| `classificacao_risco` | Classificação de risco |
| `triagem` | Dados da triagem |
| `atendimento_diagnosticos` | Diagnósticos do atendimento |
| `atendimento_desfecho` | Desfecho do atendimento |
| `prioridade_social` | Prioridade social |

### Tabelas de Evento/Histórico
| Tabela | Descrição |
|--------|-----------|
| `atendimento_evento` | Eventos do atendimento |
| `atendimento_evento_ledger` | Ledger de eventos |
| `fila_evento` | Eventos da fila |
| `ffa_historico_status` | Histórico de status FFA |
| `atendimento_movimentacao` | Movimentações |

### Stored Procedures
- `sp_master_atendimento_iniciar` - Iniciar atendimento
- `sp_master_atendimento_transicionar` - Transicionar estado
- `sp_master_atendimento_finalizar` - Finalizar atendimento
- `sp_master_senha_emitir` - Emitir senha
- `sp_master_senha_recepcao` - Receptionar senha
- `sp_recepcao_gerar_senha` - Gerar senha recepção
- `sp_recepcao_encaminhar_ffa` - Encaminhar FFA
- `sp_triagem_classificar_senha` - Classificar senha

### JOINs Principais
```sql
-- Atendimento completo
SELECT a.*, p.nome, p.cpf, p.data_nascimento, cr.descricao AS classificacao
FROM atendimento a
JOIN paciente p ON a.id_paciente = p.id_paciente
LEFT JOIN classificacao_risco cr ON a.id_classificacao_risco = cr.id_classificacao_risco

-- FFA com paciente
SELECT f.*, p.nome, p.cpf, p.data_nascimento
FROM ffa f
JOIN paciente p ON f.id_paciente = p.id_paciente
```

---

## 2. TRIAGEM

### Tabelas Principais
| Tabela | Descrição |
|--------|-----------|
| `triagem` | Dados da triagem |
| `atendimento_sinais_vitais` | Sinais vitais |
| `sinais_vitais` | Registro de sinais vitais |
| `anamnese` | Anamnese |
| `atendimento_exame_fisico` | Exame físico |
| `exame_fisico` | Dados do exame físico |
| `classificacao_risco` | Classificação de risco |

### Tabelas de Evolução
| Tabela | Descrição |
|--------|-----------|
| `evolucao_enfermagem` | Evolução de enfermagem |
| `evolucao_medica` | Evolução médica |
| `evolucao_multidisciplinar` | Evolução multidisciplinar |

### Stored Procedures
- `sp_triagem_finalizar` - Finalizar triagem
- `sp_master_chamar_senha` - Chamar senha

---

## 3. MÉDICO / CONSULTÓRIO

### Tabelas Principais
| Tabela | Descrição |
|--------|-----------|
| `medico` | Cadastro de médicos |
| `medico_especialidade` | Especialidades médicas |
| `atendimento_evolucao` | Evolução do atendimento |
| `evolucao_medica` | Evolução médica |
| `prescricao` | Prescrições |
| `prescricao_medica` | Prescrição médica |
| `prescricao_item` | Itens da prescrição |
| `pedido_medico` | Pedidos médicos |
| `pedido_medico_item` | Itens do pedido |
| `hipotese_diagnostica` | Hipóteses diagnósticas |
| `atendimento_diagnosticos` | Diagnósticos |
| `interconsulta` | Interconsultas |

### Tabelas de Procedimentos
| Tabela | Descrição |
|--------|-----------|
| `procedimento_protocolo` | Protocolos de procedimentos |
| `procedimento_protocolo_evento` | Eventos de protocolo |
| `procedimento_protocolo_resultado` | Resultados |

### Stored Procedures
- `sp_medico_finalizar` - Finalizar atendimento médico
- `sp_medico_encaminhar` - Encaminhar paciente
- `sp_medico_marcar_retorno` - Marcar retorno
- `sp_pedido_medico_criar` - Criar pedido médico
- `sp_pedido_medico_item_add` - Adicionar item ao pedido

---

## 4. ENFERMAGEM

### Tabelas Principais
| Tabela | Descrição |
|--------|-----------|
| `enfermagem` | Dados de enfermagem |
| `enfermagem_aprazamento` | Aprazamentos |
| `enfermagem_diagnosticos` | Diagnósticos de enfermagem |
| `anotacao_enfermagem` | Anotações |
| `evolucao_enfermagem` | Evolução de enfermagem |
| `prescricao_internacao` | Prescrição de internação |
| `prescricao_item` | Itens da prescrição |
| `prescricao_medicacao` | Medicações prescritas |
| `prescricao_continua` | Prescrição contínua |
| `administracao_medicacao` | Administração de medicação |
| `administracao_medicacao_ordem` | Ordem de administração |
| `atendimento_checagem` | Checagens |
| `prescricao_checagem` | Checagem de prescrição |
| `prescricao_checagem_dupla` | Checagem dupla |

### Tabelas de Internação (Enfermaria)
| Tabela | Descrição |
|--------|-----------|
| `internacao` | Internações |
| `internacao_prescricao` | Prescrições de internação |
| `internacao_prescricao_item` | Itens das prescrições |
| `internacao_movimentacao` | Movimentações |
| `internacao_historico` | Histórico |
| `internacao_registro_enfermagem` | Registros de enfermagem |
| `internacao_turno_registro` | Registro por turno |
| `internacao_cuidados` | Cuidados |
| `internacao_dietas` | Dietas |
| `internacao_dispositivos` | Dispositivos |
| `internacao_braden_avaliacao` | Escala de Braden |
| `internacao_ferida_avaliacao` | Avaliação de feridas |
| `internacao_medicacao_administracao` | Administração de medicação |

### Tabelas de Balanço Hídrico
| Tabela | Descrição |
|--------|-----------|
| `atendimento_balanco_hidrico` | Balanço hídrico |

### Stored Procedures
- `sp_master_administracao_medicacao` - Administrar medicação
- `sp_master_administracao_medicacao_ordem` - Ordem de administração
- `sp_master_registrar_administracao_medicacao` - Registrar administração

---

## 5. FARMÁCIA

### Tabelas Principais
| Tabela | Descrição |
|--------|-----------|
| `farmacia_dispensacao_log` | Log de dispensação |
| `farm_dispensacao` | Dispensação |
| `farm_dispensacao_item` | Itens de dispensação |
| `farmacia_atendimento_externo_dispensacao` | Dispensação atendimento externo |
| `farmacia_atendimento_externo_item` | Itens atendimento externo |
| `dispensacao_medicacao` | Dispensação de medicação |
| `farmaco_movimentacao` | Movimentação de fármacos |
| `farmaco_auditoria` | Auditoria de fármacos |
| `farmaco_auditoria_bloqueio` | Bloqueio de auditoria |
| `farmaco_unidade` | Unidades de fármacos |
| `farmacia_externo_evento` | Eventos externo |
| `farm_convenio_autorizacao` | Autorização convênio |
| `farm_receita_controlada` | Receita controlada |
| `farm_operacao` | Operações |
| `farm_atendimento_externo` | Atendimento externo farmácia |
| `gpat` | GPAT (Gestão de Prescrição de Alto Custo) |
| `gpat_item` | Itens GPAT |
| `gpat_dispensacao` | Dispensação GPAT |
| `gpat_evento` | Eventos GPAT |

### Stored Procedures
- `sp_farmacia_dispensar_registrar` - Registrar dispensação
- `sp_farm_dispensacao_criar` - Criar dispensação
- `sp_farm_dispensacao_registrar` - Registrar dispensação
- `sp_farm_reserva_confirmar` - Confirmar reserva
- `sp_master_registrar_alerta` - Registrar alerta

---

## 6. LABORATÓRIO

### Tabelas Principais
| Tabela | Descrição |
|--------|-----------|
| `exame` | Exames |
| `exame_pedido` | Pedido de exames |
| `exame_pedido_item` | Itens do pedido |
| `exame_historico` | Histórico de exames |
| `exame_fisico` | Exame físico |
| `lab_pedido` | Pedido laboratório |
| `lab_amostra` | Amostras |
| `lab_protocolo_interno` | Protocolo interno |
| `laboratorio_protocolo` | Protocolo laboratório |
| `laboratorio_protocolo_evento` | Eventos de protocolo |
| `lab_resultado` | Resultados |

### Stored Procedures
- `sp_finalizar_procedimento_laboratorio` - Finalizar laboratório
- `sp_gera_protocolo_lab` - Gerar protocolo LAB
- `sp_lab_protocolo_criar_ou_mapear` - Criar/mapear protocolo
- `sp_laboratorio_protocolo_evento_add` - Adicionar evento

---

## 7. IMAGEM / RADIOLOGIA

### Tabelas Principais
| Tabela | Descrição |
|--------|-----------|
| `procedimento_protocolo` | Protocolos de procedimentos |
| `procedimento_protocolo_evento` | Eventos |
| `procedimento_protocolo_resultado` | Resultados |

### Stored Procedures
- `sp_iniciar_execucao_procedimento_rx` - Iniciar RX
- `sp_finalizar_procedimento_rx` - Finalizar RX
- `sp_finalizar_procedimento_ecg` - Finalizar ECG

---

## 8. ESTOQUE / ALMOXARIFADO

### Tabelas Principais
| Tabela | Descrição |
|--------|-----------|
| `estoque_produto` | Produtos |
| `estoque_produto_codigo_externo` | Códigos externos |
| `estoque_local` | Locais de estoque |
| `estoque_movimentacao` | Movimentações |
| `estoque_movimento` | Movimentos |
| `estoque_movimento_item` | Itens de movimento |
| `estoque_movimentacao_itens` | Itens de movimentação |
| `estoque_saldo` | Saldos |
| `estoque_saldo_central` | Saldo central |
| `estoque_saldo_master` | Saldo master |
| `estoque_lote` | Lotes |
| `estoque_lote_snapshot` | Snapshot de lotes |
| `estoque_item` | Itens |
| `estoque_conta` | Contas |
| `estoque_almoxarifado_central` | Almoxarifado central |
| `almoxarifado_central` | Almoxarifado |
| `estoque_reserva` | Reservas |
| `estoque_reserva_evento` | Eventos de reserva |
| `estoque_inventario` | Inventário |
| `estoque_inventario_item` | Itens de inventário |
| `estoque_alerta` | Alertas |
| `consumo_insumo` | Consumo de insumos |
| `consumo_limpeza` | Consumo de limpeza |
| `consumo_manutencao` | Consumo manutenção |

### Tabelas de Auditoria de Estoque
| Tabela | Descrição |
|--------|-----------|
| `auditoria_estoque` | Auditoria de estoque |
| `auditoria_almoxarifado` | Auditoria de almoxarifado |
| `auditoria_estoque_sanitario` | Auditoria sanitária |
| `estoque_audit_stream` | Stream de auditoria |
| `estoque_ledger` | Ledger de estoque |
| `estoque_evento_confirmacao` | Confirmação de eventos |

### Tabelas de Fluxo
| Tabela | Descrição |
|--------|-----------|
| `estoque_fluxo_assistencial` | Fluxo assistencial |
| `estoque_execucao` | Execução |
| `estoque_execucao_pipeline` | Pipeline de execução |
| `estoque_pipeline_estado` | Estado do pipeline |
| `estoque_documento_execucao` | Documentos de execução |

### Stored Procedures
- `sp_estoque_movimentar` - Movimentar estoque
- `sp_estoque_movimento_criar` - Criar movimento
- `sp_estoque_movimento_item_add` - Adicionar item
- `sp_estoque_produto_criar_com_codigo` - Criar produto
- `sp_estoque_produto_set_codigo` - Setar código
- `sp_conciliador_estoque_faturamento` - Conciliar estoque/faturamento
- `sp_fluxo_estoque` - Fluxo de estoque

---

## 9. FATURAMENTO

### Tabelas Principais
| Tabela | Descrição |
|--------|-----------|
| `faturamento_conta` | Conta hospitalar |
| `faturamento_conta_item` | Itens da conta |
| `faturamento_conta_paciente` | Conta paciente |
| `faturamento_conta_seq` | Sequência de contas |
| `faturamento_convenio` | Convênios |
| `faturamento_convenios` | Convênios (alternativo) |
| `faturamento_producao` | Produção |
| `faturamento_producao_sus` | Produção SUS |
| `faturamento_insumo` | Insumos |
| `faturamento_item` | Itens |
| `faturamento_evento` | Eventos |
| `faturamento_codigo` | Códigos |
| `faturamento_regras_validacao` | Regras de validação |
| `faturamento_sus_config` | Configuração SUS |
| `faturamento_sigtap` | Tabela SIGTAP |

### Tabelas SUS
| Tabela | Descrição |
|--------|-----------|
| `sus_sigtap_procedimento` | Procedimentos SIGTAP |
| `sus_cid10_competencia` | CID10 por competência |
| `sus_cnes_estabelecimento` | CNES |
| `sus_competencia` | Competências |
| `procedimentos_sigtap` | Procedimentos |

### Tabelas de Contrato
| Tabela | Descrição |
|--------|-----------|
| `contrato` | Contratos |
| `forma_pagamento` | Formas de pagamento |

---

## 10. RECURSOS HUMANOS / ESCALAS

### Tabelas Principais
| Tabela | Descrição |
|--------|-----------|
| `funcionario` | Funcionários |
| `funcionario_conselho_profissional` | Conselhos profissionais |
| `funcionario_especialidade` | Especialidades |
| `funcionario_unidade` | Unidades do funcionário |
| `escala_medica` | Escala médica |
| `escala_plantao` | Plantões |
| `escala_plantao_atual` | Plantão atual |
| `escala_profissional` | Escala profissional |
| `agenda_disponibilidade` | Disponibilidade |
| `agendamento` | Agendamentos |
| `agendamentos_eventos` | Eventos de agendamento |
| `plantao` | Plantões |
| `plantao_escala` | Escalas de plantão |
| `plantao_modelo` | Modelos de plantão |
| `profissional_registro` | Registro profissional |
| `rh_registro_profissional` | Registro RH |
| `rh_pessoa_vinculo` | Vínculos RH |
| `rh_evento` | Eventos RH |

### Stored Procedures
- `sp_master_agenda_disponibilidade` - Gerenciar disponibilidade
- `sp_master_agendamento_eventos` - Eventos de agendamento
- `sp_master_agenda_disponibilidade` - Disponibilidade

---

## 11. GESTÃO DE LEITOS

### Tabelas Principais
| Tabela | Descrição |
|--------|-----------|
| `leito` | Leitos |
| `hospital_leitos` | Leitos hospitalares |
| `sala` | Salas |
| `config_leitos` | Configuração de leitos |
| `local` | Locais operacionais |
| `local_capacidade` | Capacidade |

---

## 12. MANUTENÇÃO

### Tabelas Principais
| Tabela | Descrição |
|--------|-----------|
| `chamado_manutencao` | Chamados de manutenção |
| `manutencao_execucao` | Execução de manutenção |
| `consumo_manutencao` | Consumo de manutenção |
| `evento_limpeza` | Evento de limpeza |

---

## 13. ASSISTÊNCIA SOCIAL

### Tabelas Principais
| Tabela | Descrição |
|--------|-----------|
| `assistencia_social_atendimento` | Atendimentos |
| `assistencia_social_evento` | Eventos |

---

## 14. PAINEL / TOTEM

### Tabelas Principais
| Tabela | Descrição |
|--------|-----------|
| `painel` | Painéis |
| `painel_config` | Configuração |
| `painel_config_def` | Definições de configuração |
| `painel_local` | Local do painel |
| `painel_grupo` | Grupos |
| `painel_grupo_local` | Grupos por local |
| `painel_lane` | Filas do painel |
| `painel_fila_tipo` | Tipos de fila |
| `painel_mensagem` | Mensagens |
| `painel_mensagem_consumo` | Consumo de mensagens |
| `painel_alertas_tempo` | Alertas de tempo |
| `painel_monitoramento_especialidade` | Monitoramento por especialidade |
| `painel_consumo_evento` | Eventos de consumo |

### Tabelas de Totem
| Tabela | Descrição |
|--------|-----------|
| `totem` | Totens |
| `totem_evento` | Eventos |
| `totem_feedback` | Feedback |
| `totem_senha_opcao` | Opções de senha |

### Tabelas de Senhas
| Tabela | Descrição |
|--------|-----------|
| `senha` | Senhas |
| `senha_eventos` | Eventos de senha |
| `senha_status` | Status de senha |
| `senha_sequencia` | Sequência de senhas |
| `senha_transicao_matriz` | Matriz de transição |

### Stored Procedures
- `sp_master_chamar_senha` - Chamar senha
- `sp_painel_chamar_senha` - Chamar senha no painel
- `sp_painel_config_set` - Configurar painel
- `sp_totem_gerar_senha` - Gerar senha no totem

---

## 15. DOCUMENTOS

### Tabelas Principais
| Tabela | Descrição |
|--------|-----------|
| `documento_arquivo` | Arquivos de documentos |
| `documento_emissao` | Emissão de documentos |
| `documento_emissao_evento` | Eventos de emissão |
| `documento_tipo_config` | Tipos de configuração |
| `assinatura_digital_documentos` | Assinatura digital |
| `assinatura_digital_prontuario` | Assinatura de prontuário |
| `pep_assinatura_digital` | Assinatura PEP |
| `pep_registro` | Registro PEP |
| `reg_formulario_snapshot` | Snapshot de formulário |
| `md_arquivo_fonte` | Arquivo fonte |

---

## 16. PACIENTE

### Tabelas Principais
| Tabela | Descrição |
|--------|-----------|
| `paciente` | Pacientes |
| `paciente_canonico` | Paciente canônico |
| `paciente_cns` | CNS do paciente |
| `paciente_cns_evento` | Eventos CNS |
| `paciente_alertas` | Alertas do paciente |
| `pessoa` | Pessoas |
| `pessoa_endereco` | Endereços |
| `pessoa_telefone` | Telefones |
| `pessoa_email` | E-mails |
| `pessoa_documento` | Documentos |
| `pessoa_contato` | Contatos |
| `pessoa_identificador` | Identificadores |
| `pessoa_logradouro` | Logradouros |
| `pessoa_alergias` | Alergias |
| `pessoa_conselho_registro` | Registro em conselhos |
| `acompanhante` | Acompanhantes |

### Stored Procedures
- `sp_master_atualizar_paciente` - Atualizar paciente
- `sp_master_vincular_atendimento_paciente` - Vincular atendimento
- `sp_paciente_cns_set` - Setar CNS

---

## 17. PROFISSIONAIS / USUÁRIOS

### Tabelas Principais
| Tabela | Descrição |
|--------|-----------|
| `usuario` | Usuários |
| `usuario_perfil` | Perfis de usuário |
| `usuario_unidade` | Unidades do usuário |
| `usuario_local` | Locais do usuário |
| `usuario_setor` | Setores do usuário |
| `usuario_contexto` | Contextos |
| `usuario_sistema` | Sistemas do usuário |
| `usuario_senha_historico` | Histórico de senhas |
| `usuario_historico_senha` | Histórico (alternativo) |
| `usuario_reset_senha` | Reset de senha |
| `usuario_senha_reset` | Senhas resetadas |
| `usuario_alocacao` | Alocações |
| `usuario_profissional_registro` | Registro profissional |
| `usuario_log_acesso` | Log de acesso |
| `log_acesso_prontuario` | Acesso ao prontuário |
| `usuario_refresh` | Refresh tokens |
| `usuario_refresh_token` | Tokens de refresh |

### Tabelas de Autenticação
| Tabela | Descrição |
|--------|-----------|
| `auth_sessao` | Sessões auth |
| `auth_token` | Tokens |
| `auth_log` | Logs de auth |
| `auth_notificacao` | Notificações |
| `auth_grupo` | Grupos |
| `auth_grupo_usuario` | Usuários por grupo |
| `auth_grupo_permissao` | Permissões por grupo |
| `auth_bloqueio` | Bloqueios |
| `auth_parametro` | Parâmetros |
| `auth_tentativa_login` | Tentativas de login |
| `auth_audit` | Auditoria de auth |

### Tabelas de Permissão
| Tabela | Descrição |
|--------|-----------|
| `permissao` | Permissões |
| `perfil` | Perfis |
| `perfil_permissao` | Permissões por perfil |
| `usuario_perfil` | Perfis de usuário |

### Stored Procedures
- `sp_master_login` - Login
- `sp_usuario_definir_senha` - Definir senha
- `sp_usuario_trocar_senha` - Trocar senha
- `sp_usuario_reset_senha_ti` - Resetar senha TI
- `sp_usuario_hash_gerar` - Gerar hash
- `sp_usuario_hash_verificar` - Verificar hash
- `sp_sessao_abrir` - Abrir sessão
- `sp_sessao_encerrar` - Encerrar sessão
- `sp_sessao_assert` - Validar sessão
- `sp_usuario_vincular_sistema` - Vincular sistema
- `sp_usuario_vincular_unidade` - Vincular unidade
- `sp_usuario_vincular_local` - Vincular local

---

## 18. AUDITORIA

### Tabelas Principais
| Tabela | Descrição |
|--------|-----------|
| `auditoria_evento` | Eventos de auditoria |
| `auditoria_acesso` | Acesso |
| `auditoria_erro` | Erros |
| `auditoria_ffa` | Auditoria FFA |
| `auditoria_fila` | Auditoria de fila |
| `auditoria_mestre` | Auditoria master |
| `auditoria_visualizacao_prontuario` | Visualização de prontuário |
| `log_auditoria` | Log de auditoria |
| `log_leitura_prontuario` | Leitura de prontuário |
| `reg_auditoria_acesso_sensivel` | Acesso sensível |
| `qualidade_eventos_adversos` | Eventos adversos |

### Tabelas de Auditoria Específica
| Tabela | Descrição |
|--------|-----------|
| `audit_evento_sincronizacao` | Sincronização |
| `ledger_evento_sincronizacao` | Ledger de sincronização |
| `ledger_evento_sincronizacao_local` | Ledger local |

### Stored Procedures
- `sp_auditoria_evento_registrar` - Registrar evento
- `sp_ledger_registrar_evento` - Registrar no ledger

---

## 19. SINAN (Notificações Epidemiology)

### Tabelas Principais
| Tabela | Descrição |
|--------|-----------|
| `notificacao_epidemiologica` | Notificações |
| `notificacao_epidemiologica_evento` | Eventos |
| `notificacao_violencia` | Violência |
| `notificacao_violencia_evento` | Eventos de violência |

---

## 20. CAT (Comunicação de Acidente de Trabalho)

### Tabelas Principais
| Tabela | Descrição |
|--------|-----------|
| `cat_acidente_trabalho` | Acidentes de trabalho |
| `cat_acidente_trabalho_evento` | Eventos |
| `cat_evento` | Eventos CAT |
| `cat_notificacao` | Notificações |
| `cat_regra_item` | Regras |

---

## 21. ÓBITO

### Tabelas Principais
| Tabela | Descrição |
|--------|-----------|
| `obito` | Óbitos |
| `obito_evento` | Eventos |

---

## 22. PDV (Ponto de Venda)

### Tabelas Principais
| Tabela | Descrição |
|--------|-----------|
| `pdv_venda` | Vendas |
| `pdv_venda_item` | Itens de venda |
| `pdv_pagamento` | Pagamentos |
| `pdv_cliente` | Clientes |
| `venda` | Vendas (genérico) |
| `venda_item` | Itens |
| `venda_pagamento` | Pagamentos |
| `venda_evento` | Eventos |
| `caixa` | Caixa |
| `caixa_evento` | Eventos de caixa |
| `fornecedor` | Fornecedores |
| `produto` | Produtos |

### Stored Procedures
- `sp_pdv_venda_criar` - Criar venda

---

## 23. TRANSPORTE / AMBULÂNCIA

### Tabelas Principais
| Tabela | Descrição |
|--------|-----------|
| `transporte_ambulancia` | Ambulâncias |
| `transporte_ambulancia_evento` | Eventos |
| `remocao` | Remoções |
| `remocao_evento` | Eventos |
| `remocao_logistica` | Logística de remoção |
| `viatura` | Viaturas |

---

## 24. GASOTERAPIA

### Tabelas Principais
| Tabela | Descrição |
|--------|-----------|
| `gaso_solicitacao` | Solicitações |
| `gaso_evento` | Eventos |
| `gasoterapia_consumo` | Consumo |
| `gasoterapia_consumo_evento` | Eventos de consumo |

---

## 25. ALERTAS / MONITORAMENTO

### Tabelas Principais
| Tabela | Descrição |
|--------|-----------|
| `alerta` | Alertas |
| `alerta_consumo` | Consumo de alertas |
| `alerta_destinatario` | Destinatários |
| `alerta_regra` | Regras de alerta |
| `painel_alertas_tempo` | Alertas de tempo |
| `paciente_alertas` | Alertas de paciente |

---

## 26. CHAMADOS / SUPORTE

### Tabelas Principais
| Tabela | Descrição |
|--------|-----------|
| `chamado` | Chamados |
| `chamado_evento` | Eventos |
| `chamado_manutencao` | Chamados de manutenção |

---

## 27. ORDEM ASSISTENCIAL

### Tabelas Principais
| Tabela | Descrição |
|--------|-----------|
| `ordem_assistencial` | Ordens assistenciais |
| `ordem_assistencial_item` | Itens |
| `ordem_assistencial_aprazamento` | Aprazamentos |
| `ordem_assistencial_execucao` | Execução |
| `ordem_tipo_documento_config` | Configuração de documentos |

---

## 28. KERNEL / RUNTIME / INFRA

### Tabelas de Runtime
| Tabela | Descrição |
|--------|-----------|
| `runtime_contexto` | Contexto runtime |
| `runtime_dispositivo` | Dispositivos |
| `runtime_edge_evento` | Eventos edge |
| `runtime_evento_provisional` | Eventos provisionais |
| `runtime_execution_queue` | Fila de execução |
| `runtime_invariant_log` | Log de invariantes |
| `runtime_kernel_locks` | Locks do kernel |
| `runtime_lock_semantico` | Locks semânticos |
| `runtime_snapshot_governanca` | Snapshot de governança |
| `runtime_snapshot_metadata` | Metadados de snapshot |
| `runtime_sync_log` | Log de sincronização |
| `runtime_sync_queue` | Fila de sincronização |
| `runtime_api_session_token` | Tokens de API |
| `runtime_concurrency_guard` | Guard de concorrência |
| `runtime_estado_sobrevivencia` | Estado de sobrevivencia |

### Tabelas de Kernel
| Tabela | Descrição |
|--------|-----------|
| `kernel_ledger` | Ledger do kernel |
| `kernel_runtime_evento` | Eventos |
| `kernel_runtime_heartbeat` | Heartbeat |
| `kernel_runtime_single_writer_lock` | Lock de escrita única |
| `kernel_single_writer_lock` | Lock |
| `kernel_identity_trust_chain` | Cadeia de identidade |
| `kernel_authz_policy` | Política de autorização |

### Tabelas de Assistencial Runtime
| Tabela | Descrição |
|--------|-----------|
| `assistencial_checkpoint_global` | Checkpoint global |
| `assistencial_circuit_breaker` | Circuit breaker |
| `assistencial_evento_hash` | Hash de eventos |
| `assistencial_minipal_metric` | Métricas minipal |
| `assistencial_quorum_clinico` | Quórum clínico |
| `assistencial_raim_metric` | Métricas RAIM |
| `assistencial_runtime_federado` | Runtime federado |
| `assistencial_runtime_panel` | Painel de runtime |
| `assistencial_simulacao_futura` | Simulação futura |
| `assistencial_snapshot_runtime` | Snapshot |
| `assistencial_telemetria_runtime` | Telemetria |
| `assistencial_watchdog_fila` | Watchdog |

### Tabelas de Fluxo
| Tabela | Descrição |
|--------|-----------|
| `fluxo_orquestrador_canonico` | Orquestrador canônico |
| `fluxo_status` | Status de fluxo |
| `fluxo_transicao` | Transições |
| `fluxo_transicao_matriz` | Matriz de transição |
| `eventos_fluxo` | Eventos de fluxo |

### Tabelas de Guardião
| Tabela | Descrição |
|--------|-----------|
| `guardiao_acl_runtime` | ACL do guardião |
| `guardiao_runtime_final` | Guardião final |
| `coordenador_estado_global` | Estado global |

### Stored Procedures
- `sp_kernel_runtime_heartbeat` - Heartbeat
- `sp_kernel_writer_lock` - Lock de escrita
- `sp_kernel_writer_unlock` - Unlock
- `sp_kernel_cleanup_expired` - Limpeza
- `sp_kernel_identity_chain_register` - Registrar identidade
- `sp_dispatcher_kernel` - Dispatcher
- `sp_coordenador_global` - Coordenador global

---

## Landing Pages a Criar

Baseado na análise acima, as landing pages necessárias são:

### Já Criadas
1. ✅ Reception (Recepção)
2. ✅ Triagem
3. ✅ Médico
4. ✅ Laboratorio
5. ✅ Internação
6. ✅ Estoque

### Pendentes
7. 🔲 Farmácia
8. 🔲 Ambulatório/Consultório
9. 🔲 Imagem/Radiologia
10. 🔲 Faturamento
11. 🔲 RH/Escalas
12. 🔲 Almoxarifado
13. 🔲 Manutenção
14. 🔲 Assistência Social
15. 🔲 Painel/Totem
16. 🔲 Documentos
17. 🔲 Pacientes
18. 🔲 Profissionais/Usuários
19. 🔲 Auditoria
20. 🔲 SINAN/Notificações
21. 🔲 CAT
22. 🔲 Óbito
23. 🔲 PDV
24. 🔲 Transporte
25. 🔲 Gasoterapia
26. 🔲 Alertas
27. 🔲 Chamados
28. 🔲 Prescrição/Ordem Assistencial
29. 🔲 Admin/Sistema

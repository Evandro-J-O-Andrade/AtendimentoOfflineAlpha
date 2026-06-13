# MAPA COMPLETO DE SETORES E MÓDULOS DO SISTEMA

## Total: 329 tabelas identificadas no banco de dados

---

## 1. ATENDIMENTO CLÍNICO (PRINCIPAL)
### Tabelas:
- `atendimento` - Registro principal de atendimento
- `atendimento_balanco_hidrico` - Balanço hídrico
- `atendimento_checagem` - Checagens de atendimento
- `atendimento_desfecho` - Desfecho do atendimento
- `atendimento_diagnosticos` - Diagnósticos
- `atendimento_escalas_risco` - Escalas de risco
- `atendimento_estado_ativo` - Estado ativo
- `atendimento_evento` - Eventos do atendimento
- `atendimento_evento_ledger` - Ledger de eventos
- `atendimento_evolucao` - Evolução do atendimento
- `atendimento_exame_fisico` - Exame físico
- `atendimento_identidade_fluxo` - Identidade de fluxo
- `atendimento_movimentacao` - Movimentação
- `atendimento_observacao` - Observação
- `atendimento_pedidos_exame` - Pedidos de exame
- `atendimento_prescricao` - Prescrição
- `atendimento_recepcao` - Recepção
- `atendimento_sinais_vitais` - Sinais vitais
- `atendimento_sumario_alta` - Sumário de alta
- `atendimento_transicao_ledger` - Transição ledger

### SPs Relacionadas:
- `sp_master_atendimento_iniciar`
- `sp_master_atendimento_finalizar`
- `sp_master_atendimento_transicionar`
- `sp_atendimento_transicionar`
- `sp_atendimento_finalizar_evasao`

**PÁGINA: AtendimentoClinico.jsx** - Dashboard de atendimento com triagem, classificações de risco, evolução

---

## 2. TRIAGEM
### Tabelas:
- `triagem` - Registro de triagem
- `classificacao_risco` - Classificação de risco
- `sinais_vitais` - Sinais vitais

### SPs Relacionadas:
- `sp_triagem_classificar_senha`
- `sp_triagem_finalizar`

**PÁGINA: Triagem.jsx** ✅ EXISTE

---

## 3. RECEPÇÃO
### Tabelas:
- `senha` - Senhas de atendimento
- `senha_eventos` - Eventos de senha
- `senha_sequencia` - Sequência de senhas
- `senha_status` - Status de senha
- `senha_transicao_matriz` - Matriz de transição
- `fila_senha` - Fila de senhas
- `fila_operacional` - Fila operacional
- `fila_operacional_evento` - Eventos da fila
- `fila_evento` - Eventos de fila
- `fila_retorno` - Fila de retorno
- `local_fila` - Local da fila
- `codigo_prefixo_config` - Configuração de prefixo
- `codigo_prefixo_regra` - Regra de prefixo
- `codigo_externo_map` - Mapeamento código externo
- `codigo_externo_vinculo` - Vínculo código externo
- `codigo_universal` - Código universal

### SPs Relacionadas:
- `sp_recepcao_gerar_senha`
- `sp_recepcao_iniciar_complementacao`
- `sp_recepcao_complementar_e_abrir_ffa`
- `sp_recepcao_encaminhar_ffa`
- `sp_chamar_senha`
- `sp_senha_emitir`
- `sp_senha_chamar`

**PÁGINA: Recepcao.jsx** ✅ EXISTE

---

## 4. FARMÁCIA / DISPENSAÇÃO
### Tabelas:
- `farmacia_dispensacao_log` - Log de dispensação
- `farmacia_atendimento_externo_dispensacao` - Dispensação externa
- `farmacia_atendimento_externo_item` - Item externo
- `farmacia_externo_evento` - Evento externo
- `farm_dispensacao` - Dispensação
- `farm_dispensacao_item` - Item de dispensação
- `farm_operacao` - Operação
- `farm_receita_controlada` - Receita controlada
- `farm_atendimento_externo` - Atendimento externo
- `dispensacao_medicacao` - Dispensação medicação
- `gpat` - GPAT (Gestão de Prescrição)
- `gpat_atendimento` - GPAT atendimento
- `gpat_dispensacao` - GPAT dispensação
- `gpat_evento` - GPAT evento
- `gpat_item` - GPAT item

### SPs Relacionadas:
- `sp_farmacia_dispensar_registrar`
- `sp_farm_dispensacao_criar`
- `sp_farm_dispensacao_registrar`
- `sp_farm_reserva_confirmar`
- `sp_master_administracao_medicacao`
- `sp_master_administracao_medicacao_ordem`

**PÁGINA: Farmacia.jsx** ✅ EXISTE

---

## 5. LABORATÓRIO / EXAMES
### Tabelas:
- `laboratorio_protocolo` - Protocolo laboratório
- `laboratorio_protocolo_evento` - Evento protocolo
- `lab_amostra` - Amostra
- `lab_evento` - Evento
- `lab_pedido` - Pedido
- `lab_protocolo_interno` - Protocolo interno
- `lab_resultado` - Resultado
- `exame` - Exame
- `exame_fisico` - Exame físico
- `exame_historico` - Histórico exame
- `exame_pedido` - Pedido exame
- `exame_pedido_item` - Item pedido exame
- `solicitacao_exame` - Solicitação exame

### SPs Relacionadas:
- `sp_lab_protocolo_criar_ou_mapear`
- `sp_laboratorio_protocolo_evento_add`
- `sp_gera_protocolo_lab`
- `sp_finalizar_procedimento_laboratorio`

**PÁGINA: Laboratorio.jsx** ✅ EXISTE

---

## 6. ESTOKE / ALMOXARIFADO
### Tabelas:
- `estoque_produto` - Produto
- `estoque_local` - Local estoque
- `estoque_lote` - Lote
- `estoque_movimento` - Movimento
- `estoque_movimento_item` - Item movimento
- `estoque_movimentacao` - Movimentação
- `estoque_movimentacao_itens` - Itens movimentação
- `estoque_saldo` - Saldo
- `estoque_saldo_central` - Saldo central
- `estoque_saldo_master` - Saldo master
- `estoque_inventario` - Inventário
- `estoque_inventario_item` - Item inventário
- `estoque_reserva` - Reserva
- `estoque_reserva_evento` - Evento reserva
- `estoque_conta` - Conta estoque
- `estoque_documento_execucao` - Documento execução
- `estoque_execucao` - Execução
- `estoque_execucao_pipeline` - Pipeline execução
- `estoque_fluxo_assistencial` - Fluxo assistencial
- `estoque_alerta` - Alerta
- `almoxarifado_central` - Almoxarifado central
- `estoque_almoxarifado_central` - Almoxarifado
- `consumo_insumo` - Consumo insumo
- `produto` - Produto (cadastro)

### SPs Relacionadas:
- `sp_estoque_movimento_criar`
- `sp_estoque_movimento_item_add`
- `sp_estoque_movimentar`
- `sp_estoque_produto_criar_com_codigo`
- `sp_conciliador_estoque_faturamento`
- `sp_fluxo_estoque`

**PÁGINA: Estoque.jsx** ✅ EXISTE

---

## 7. INTERNAÇÃO
### Tabelas:
- `internacao` - Internação
- `internacao_braden_avaliacao` - Avaliação Braden
- `internacao_cuidados` - Cuidados
- `internacao_dietas` - Dietas
- `internacao_dispositivos` - Dispositivos
- `internacao_ferida_avaliacao` - Avaliação ferida
- `internacao_historico` - Histórico
- `internacao_medicacao_administracao` - Medicação admin
- `internacao_movimentacao` - Movimentação
- `internacao_prescricao` - Prescrição
- `internacao_prescricao_item` - Item prescrição
- `internacao_registro_enfermagem` - Registro enfermagem
- `internacao_turno_registro` - Registro turno

### SPs Relacionadas:
- `sp_internacao_registrar_evasao`
- `sp_master_atendimento_iniciar` (para internação)

**PÁGINA: Internacao.jsx** ✅ EXISTE

---

## 8. MÉDICO / CLÍNICO
### Tabelas:
- `medico` - Médicos
- `medico_especialidade` - Especialidade médico
- `evolucao_medica` - Evolução médica
- `prescricao_medica` - Prescrição médica
- `pedido_medico` - Pedido médico
- `pedido_medico_item` - Item pedido médico
- `hipotese_diagnostica` - Hipótese diagnóstica
- `interconsulta` - Interconsulta

### SPs Relacionadas:
- `sp_medico_encaminhar`
- `sp_medico_finalizar`
- `sp_medico_marcar_retorno`
- `sp_pedido_medico_criar`
- `sp_pedido_medico_item_add`
- `sp_raim_calcular`

**PÁGINA: Medico.jsx** ✅ EXISTE

---

## 9. ENFERMAGEM
### Tabelas:
- `enfermagem` - Enfermagem
- `enfermagem_aprazamento` - Aprazamento
- `enfermagem_diagnosticos` - Diagnósticos enfermagem
- `evolucao_enfermagem` - Evolução enfermagem
- `evolucao_multidisciplinar` - Evolução multidisciplinar
- `anotacao_enfermagem` - Anotação enfermagem
- `prescricao_enfermagem` - Prescrição enfermagem
- `ordem_assistencial` - Ordem assistencial
- `ordem_assistencial_aprazamento` - Aprazamento ordem
- `ordem_assistencial_execucao` - Execução ordem
- `ordem_assistencial_item` - Item ordem
- `prescricao` - Prescrição
- `prescricao_checagem` - Checagem prescrição
- `prescricao_checagem_dupla` - Checagem dupla
- `prescricao_continua` - Prescrição contínua
- `prescricao_internacao` - Prescrição internação
- `prescricao_item` - Item prescrição
- `prescricao_itens` - Itens prescrição
- `prescricao_kit_master` - Kit master
- `prescricao_kit_itens` - Itens kit

**PÁGINA: Enfermagem.jsx** - Necesário criar

---

## 10. GASOTERAPIA
### Tabelas:
- `gaso_evento` - Evento gasoterapia
- `gaso_solicitacao` - Solicitação gasoterapia
- `gasoterapia_consumo` - Consumo gasoterapia
- `gasoterapia_consumo_evento` - Evento consumo

**PÁGINA: Gasoterapia.jsx** - Necessário criar

---

## 11. FISIOTERAPIA
### Tabelas:
- Não foram encontradas tabelas específicas com "fisio"
- Pode ser integrada em atendimento ou evoluções

**PÁGINA: Fisioterapia.jsx** - Pode ser integrada com Atendimento

---

## 12. ASSISTÊNCIA SOCIAL
### Tabelas:
- `assistencia_social_atendimento` - Atendimento social
- `assistencia_social_evento` - Evento social

**PÁGINA: AssistenciaSocial.jsx** - Necesário criar

---

## 13. MANUTENÇÃO / INFRAESTRUTURA
### Tabelas:
- `manutencao_execucao` - Execução manutenção
- `consumo_manutencao` - Consumo manutenção

**PÁGINA: Manutencao.jsx** - Necesário criar

---

## 14. PAINEL / TV / DISPLAY
### Tabelas:
- `painel` - Painel
- `painel_alertas_tempo` - Alertas tempo
- `painel_config` - Configuração
- `painel_config_def` - Definição config
- `painel_consumo_evento` - Evento consumo
- `painel_fila_tipo` - Tipo fila
- `painel_grupo` - Grupo painel
- `painel_grupo_local` - Grupo local
- `painel_lane` - Lane painel
- `painel_local` - Local painel
- `painel_mensagem` - Mensagem painel
- `painel_mensagem_consumo` - Consumo mensagem
- `painel_monitoramento_especialidade` - Monitoramento
- `tv_rotativo` - TV rotativo
- `tv_rotativo_tela` - Tela TV

### SPs Relacionadas:
- `sp_painel_chamar_senha`
- `sp_painel_inserir_senha`
- `sp_painel_cancelar_senha`

**PÁGINA: Painel.jsx** - Já existe no sistema

---

## 15. TOTEM / AUTOATENDIMENTO
### Tabelas:
- `totem` - Totem
- `totem_evento` - Evento totem
- `totem_feedback` - Feedback totem
- `totem_senha_opcao` - Opção senha

### SPs Relacionadas:
- `sp_totem_gerar_senha`

**PÁGINA: Totem.jsx** - Necesário criar

---

## 16. DOCUMENTAÇÃO / PROTOCOLOS
### Tabelas:
- `documento_arquivo` - Arquivo documento
- `documento_emissao` - Emissão documento
- `documento_emissao_evento` - Evento emissão
- `documento_tipo_config` - Tipo config
- `protocolo_assistencial_global` - Protocolo assistencial
- `protocolo_emissao` - Emissão protocolo
- `protocolo_sequencia` - Sequência protocolo
- `protocolo_protocolo` - Protocolo
- `protocolo_protocolo_evento` - Evento protocolo
- `protocolo_protocolo_resultado` - Resultado
- `assinatura_digital_documentos` - Assinatura digital docs
- `assinatura_digital_prontuario` - Assinatura prontuário
- `pep_assinatura_digital` - PEP assinatura
- `pep_registro` - PEP registro

**PÁGINA: Documentos.jsx** - Necesário criar

---

## 17. PACIENTE / PESSOA
### Tabelas:
- `paciente` - Paciente
- `paciente_alertas` - Alertas paciente
- `paciente_canonico` - Paciente canônico
- `paciente_cns` - CNS paciente
- `paciente_cns_evento` - Evento CNS
- `pessoa` - Pessoa
- `pessoa_alergias` - Alergias
- `pessoa_conselho_registro` - Conselho registro
- `pessoa_contato` - Contato
- `pessoa_documento` - Documento
- `pessoa_email` - Email
- `pessoa_endereco` - Endereço
- `pessoa_identificador` - Identificador
- `pessoa_logradouro` - Logradouro
- `pessoa_telefone` - Telefone
- `pessoa_vinculo` - Vínculo
- `acompanhante` - Acompanhante

**PÁGINA: Paciente.jsx** - Necesário criar (busca/cadastro)

---

## 18. PROFISSIONAIS / FUNCIONÁRIOS
### Tabelas:
- `funcionario` - Funcionário
- `funcionario_conselho_profissional` - Conselho profissional
- `funcionario_especialidade` - Especialidade
- `funcionario_unidade` - Unidade funcionário
- `profissional_registro` - Registro profissional
- `rh_registro_profissional` - RH registro
- `rh_pessoa_vinculo` - RH vínculo
- `rh_evento` - Evento RH
- `conselho_profissional` - Conselho
- `especialidade` - Especialidade

### SPs Relacionadas:
- `sp_seed_dummy_funcionario_500`

**PÁGINA: Profissionais.jsx** - Necesário criar

---

## 19. ESCALAS / PLANTÕES
### Tabelas:
- `escala_medica` - Escala médica
- `escala_plantao` - Plantão
- `escala_plantao_atual` - Plantão atual
- `escala_profissional` - Escala profissional
- `agenda_disponibilidade` - Disponibilidade agenda
- `agendamento` - Agendamento
- `agendamentos_eventos` - Eventos agendamento
- `servico_agendamento` - Serviço agendamento

**PÁGINA: Escalas.jsx** - Necesário criar

---

## 20. LOCAL / UNIDADE / SETOR
### Tabelas:
- `local` - Local
- `local_capacidade` - Capacidade local
- `local_dispositivo` - Dispositivo local
- `local_runtime` - Runtime local
- `local_turno` - Turno local
- `unidade` - Unidade
- `setor` - Setor
- `sala` - Sala
- `sala_notificacao` - Notificação sala
- `sala_notificacao_evento` - Evento notificação
- `leito` - Leito
- `hospital_leitos` - Leitos hospital
- `config_locais` - Config locais
- `tipo_local` - Tipo local

**PÁGINA: Locais.jsx** - Necesário criar

---

## 21. FATURAMENTO / FINANCEIRO
### Tabelas:
- `faturamento_conta` - Conta faturamento
- `faturamento_conta_item` - Item conta
- `faturamento_conta_paciente` - Conta paciente
- `faturamento_conta_seq` - Sequência conta
- `faturamento_convenio` - Convênio
- `faturamento_convenios` - Convênios
- `faturamento_evento` - Evento
- `faturamento_insumo` - Insumo
- `faturamento_item` - Item
- `faturamento_producao` - Produção
- `faturamento_producao_sus` - Produção SUS
- `faturamento_regras_validacao` - Regras
- `faturamento_codigo` - Código
- `faturamento_sigtap` - SIGTAP
- `faturamento_sus_config` - Config SUS
- `caixa` - Caixa
- `caixa_evento` - Evento caixa
- `financeiro_repasse_medico` - Repasse médico

**PÁGINA: Faturamento.jsx** - Necesário criar

---

## 22. ADMINISTRAÇÃO / AUTENTICAÇÃO
### Tabelas:
- `usuario` - Usuário
- `usuario_contexto` - Contexto usuário
- `usuario_alocacao` - Alocação
- `usuario_historico_senha` - Histórico senha
- `usuario_local` - Local usuário
- `usuario_perfil` - Perfil usuário
- `usuario_profissional_registro` - Registro profissional
- `usuario_refresh` - Refresh token
- `usuario_refresh_token` - Refresh token
- `usuario_reset_senha` - Reset senha
- `usuario_senha_historico` - Histórico senha
- `usuario_senha_reset` - Reset senha
- `usuario_setor` - Setor usuário
- `usuario_sistema` - Sistema usuário
- `usuario_sistema_acl_evento` - ACL evento
- `usuario_unidade` - Unidade usuário
- `perfil` - Perfil
- `perfil_permissao` - Permissão perfil
- `permissao` - Permissão
- `sistema` - Sistema

### SPs Relacionadas:
- `sp_master_login`
- `sp_usuario_criar_contexto`
- `sp_usuario_vincular_local`
- `sp_usuario_vincular_sistema`
- `sp_usuario_vincular_unidade`

**PÁGINA: Administracao.jsx** ✅ EXISTE (Admin.jsx)

---

## 23. AUDITORIA / LOGS
### Tabelas:
- `auditoria_acesso` - Acesso
- `auditoria_almoxarifado` - Almoxarifado
- `auditoria_erro` - Erro
- `auditoria_estoque` - Estoque
- `auditoria_estoque_sanitario` - Estoque sanitary
- `auditoria_evento` - Evento
- `auditoria_excecoes` - Exceções
- `auditoria_ffa` - FFA
- `auditoria_fila` - Fila
- `auditoria_mestre` - Mestre
- `auditoria_visualizacao_prontuario` - Visualização prontuário
- `log_acesso_prontuario` - Acesso prontuário
- `log_auditoria` - Log
- `log_leitura_prontuario` - Leitura prontuário

**PÁGINA: Auditoria.jsx** - Necesário criar

---

## 24. TRANSPORTE / REMOÇÃO
### Tabelas:
- `transporte_ambulancia` - Ambulância
- `transporte_ambulancia_evento` - Evento ambulância
- `remocao` - Remoção
- `remocao_evento` - Evento remoção
- `remocao_logistica` - Logística remoção
- `viatura` - Viatura

**PÁGINA: Transporte.jsx** - Necesário criar

---

## 25. NOTIFICAÇÕES / EPIDEMIOLOGIA
### Tabelas:
- `notificacao_epidemiologica` - Notificação epidemiológica
- `notificacao_epidemiologica_evento` - Evento notificação
- `notificacao_violencia` - Violência
- `notificacao_violencia_evento` - Evento violência
- `sinan_evento` - Evento SINAN
- `sinan_notificacao` - Notificação SINAN

**PÁGINA: Notificacoes.jsx** - Necesário criar

---

## 26. CAT / ACIDENTE TRABALHO
### Tabelas:
- `cat_acidente_trabalho` - CAT acidente trabalho
- `cat_acidente_trabalho_evento` - Evento CAT
- `cat_evento` - Evento CAT
- `cat_notificacao` - Notificação CAT
- `cat_regra_item` - Regra CAT

**PÁGINA: CAT.jsx** - Necesário criar

---

## 27. ÓBITO
### Tabelas:
- `obito` - Óbito
- `obito_evento` - Evento óbito

**PÁGINA: Obito.jsx** - Necesário criar

---

## 28. PDV / VENDAS
### Tabelas:
- `pdv_cliente` - Cliente PDV
- `pdv_pagamento` - Pagamento PDV
- `pdv_venda` - Venda PDV
- `pdv_venda_item` - Item venda
- `venda` - Venda
- `venda_evento` - Evento venda
- `venda_item` - Item venda
- `venda_pagamento` - Pagamento venda
- `forma_pagamento` - Forma pagamento

**PÁGINA: PDV.jsx** - Necesário criar

---

## 29. ASSISTENCIAL / MONITORAMENTO
### Tabelas:
- `assistencial_checkpoint_global` - Checkpoint
- `assistencial_circuit_breaker` - Circuit breaker
- `assistencial_evento_hash` - Hash evento
- `assistencial_minipal_metric` - Métrica MINIPAL
- `assistencial_quorum_clinico` - Quórum clínico
- `assistencial_raim_metric` - Métrica RAIM
- `assistencial_runtime_federado` - Runtime federado
- `assistencial_runtime_panel` - Panel runtime
- `assistencial_simulacao_futura` - Simulação
- `assistencial_snapshot_runtime` - Snapshot
- `assistencial_telemetria_runtime` - Telemetria
- `assistencial_watchdog_fila` - Watchdog

**PÁGINA: Monitoramento.jsx** - Pode integrar com Painel

---

## 30. ALERTAS
### Tabelas:
- `alerta` - Alerta
- `alerta_consumo` - Consumo alerta
- `alerta_destinatario` - Destinatário
- `alerta_regra` - Regra alerta

**PÁGINA: Alertas.jsx** - Necesário criar

---

## 31. CHAMADOS / TICKETS
### Tabelas:
- `chamado` - Chamado
- `chamado_evento` - Evento chamado
- `chamado_manutencao` - Manutenção chamado

**PÁGINA: Chamados.jsx** - Necesário criar

---

## 32. PRESCRIÇÃO / MEDICAÇÃO
### Tabelas:
- `prescricao` - Prescrição (já listada em enfermagem)
- `prescricao_medica` - Prescrição médica
- `prescricao_medicacao` - Medicação
- `medicacao_reavaliacao` - Reavaliação medicação
- `prescritor_externo` - Prescritor externo

**PÁGINA: Prescricao.jsx** - Necesário criar

---

## 33. ANTENDIMENTO EXTERNO / AMBULATORIAL
### Tabelas:
- `farmacia_atendimento_externo_dispensacao`
- `farmacia_atendimento_externo_item`
- `farm_atendimento_externo`

**PÁGINA: AtendimentoExterno.jsx** - Necesário criar

---

## RESUMO DE PÁGINAS NECESSÁRIAS

### Já existem:
- ✅ Triagem.jsx
- ✅ Recepcao.jsx
- ✅ Laboratorio.jsx
- ✅ Estoque.jsx
- ✅ Internacao.jsx
- ✅ Medico.jsx
- ✅ Farmacia.jsx
- ✅ Admin.jsx

### Precisam ser criadas:
- 1. **Enfermagem.jsx** - Prescrições, aprazamentos, evoluções
- 2. **Gasoterapia.jsx** - Consumo de gases
- 3. **AssistenciaSocial.jsx** - Atendimento social
- 4. **Manutencao.jsx** - Chamados de manutenção
- 5. **Painel.jsx** - Painel de senhas (já existe)
- 6. **Totem.jsx** - Totem autoatendimento
- 7. **Documentos.jsx** - Gestão de documentos
- 8. **Paciente.jsx** - Cadastro/busca de pacientes
- 9. **Profissionais.jsx** - Gestão de profissionais
- 10. **Escalas.jsx** - Escalas e plantões
- 11. **Locais.jsx** - Gestão de locais/leitos/salas
- 12. **Faturamento.jsx** - Faturamento/financeiro
- 13. **Auditoria.jsx** - Logs e auditoria
- 14. **Transporte.jsx** - Ambulâncias/vitórias
- 15. **Notificacoes.jsx** - EPIDEMIOLOGIA/SINAN
- 16. **CAT.jsx** - Acidentes trabalho
- 17. **Obito.jsx** - Registro de óbitos
- 18. **PDV.jsx** - Ponto de venda
- 19. **Monitoramento.jsx** - Métricas assistenciais
- 20. **Alertas.jsx** - Sistema de alertas
- 21. **Chamados.jsx** - Tickets/chamados
- 22. **Prescricao.jsx** - Prescrições
- 23. **AtendimentoExterno.jsx** - Ambulatório

---

## ESTRUTURA DE PASTAS PROPOSTA

```
frontend/src/apps/operacional/pages/
├── LandingPages.jsx (menu principal)
├── recepcao/
│   └── Recepcao.jsx ✅
├── triagem/
│   └── Triagem.jsx ✅
├── medico/
│   └── Medico.jsx ✅
├── enfermagem/
│   └── Enfermagem.jsx (NOVA)
├── farmacia/
│   └── Farmacia.jsx ✅
├── laboratorio/
│   └── Laboratorio.jsx ✅
├── estoque/
│   └── Estoque.jsx ✅
├── internacao/
│   └── Internacao.jsx ✅
├── gasoterapia/
│   └── Gasoterapia.jsx (NOVA)
├── assistencia_social/
│   └── AssistenciaSocial.jsx (NOVA)
├── manutencao/
│   └── Manutencao.jsx (NOVA)
├── documento/
│   └── Documentos.jsx (NOVA)
├── paciente/
│   └── Paciente.jsx (NOVA)
├── profissional/
│   └── Profissionais.jsx (NOVA)
├── escalas/
│   └── Escalas.jsx (NOVA)
├── local/
│   └── Locais.jsx (NOVA)
├── faturamento/
│   └── Faturamento.jsx (NOVA)
├── auditoria/
│   └── Auditoria.jsx (NOVA)
├── transporte/
│   └── Transporte.jsx (NOVA)
├── notificacao/
│   └── Notificacoes.jsx (NOVA)
├── cat/
│   └── CAT.jsx (NOVA)
├── obito/
│   └── Obito.jsx (NOVA)
├── pdv/
│   └── PDV.jsx (NOVA)
├── monitoramento/
│   └── Monitoramento.jsx (NOVA)
├── alertas/
│   └── Alertas.jsx (NOVA)
├── chamado/
│   └── Chamados.jsx (NOVA)
├── prescricao/
│   └── Prescricao.jsx (NOVA)
├── atendimento_externo/
│   └── AtendimentoExterno.jsx (NOVA)
├── totem/
│   └── Totem.jsx (NOVA)
└── contexto/
    └── SelecionarContexto.jsx (EXISTE)
```

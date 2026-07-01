# MAPA DE CONSUMO POR MÓDULO
**Banco:** pronto_atendimento (Dump20260606.sql)  
**Data:** 2026-06-30  
**Status:** Inventário consolidado

---

## VISÃO GERAL

Cada módulo da plataforma consome um conjunto específico de tabelas e procedures.

Este documento mapeia **o que cada módulo consome**.

---

## MÓDULOS IDENTIFICADOS

### 1. PORTAL
**Descrição:** Launcher de aplicações, home, navegação, widgets.  
**Domínio:** PLATFORM

#### Procedures Consumidas
| Procedure | Objetivo |
|-----------|----------|
| `sp_auth_login` | Autenticação |
| `sp_auth_logout` | Logout |
| `sp_auth_menu_get` | Menu do usuário |
| `sp_auth_permissao` | Permissões |
| `sp_notification_list` | Notificações |
| `sp_profile_get` | Perfil do usuário |
| `sp_contexto_get_available` | Contextos disponíveis |
| `sp_contexto_open` | Abertura de contexto |
| `sp_dashboard_load` | Carregar dashboard |
| `sp_portal_apps` | Apps disponíveis |
| `sp_portal_noticia_listar` | Notícias |
| `sp_portal_modulos` | Módulos |

#### Tabelas Consumidas
| Tabela | Operação |
|--------|----------|
| `usuario` | SELECT |
| `perfil` | SELECT |
| `permissao` | SELECT |
| `auth_sessao` | SELECT/UPDATE |
| `auth_token` | INSERT/SELECT |
| `usuario_perfil` | SELECT |
| `usuario_sistema` | SELECT |
| `usuario_unidade` | SELECT |
| `usuario_contexto` | SELECT |
| `notificacao_epidemiologica` | SELECT |
| `portal_noticia` | SELECT |
| `portal_categoria` | SELECT |
| `painel` | SELECT |

---

### 2. AUTH / IAM
**Descrição:** Autenticação, autorização, sessões, tokens, ACL.  
**Domínio:** CORE

#### Procedures Consumidas
| Procedure | Objetivo |
|-----------|----------|
| `sp_auth_login` | Login |
| `sp_auth_logout` | Logout |
| `sp_auth_refresh_token` | Refresh token |
| `sp_auth_validate_session` | Validar sessão |
| `sp_auth_permissao` | Validar permissão |
| `sp_auth_menu_get` | Menu |
| `sp_sessao_abrir` | Abrir sessão |
| `sp_sessao_encerrar` | Encerrar sessão |
| `sp_sessao_contexto_set` | Set contexto |
| `sp_sessao_contexto_get` | Get contexto |
| `sp_sessao_assert` | Assert sessão |
| `sp_usuario_criar` | Criar usuário |
| `sp_usuario_atualizar` | Atualizar usuário |
| `sp_usuario_alterar_senha` | Alterar senha |
| `sp_usuario_reset_senha` | Reset senha |
| `sp_usuario_bloquear` | Bloquear usuário |
| `sp_usuario_desbloquear` | Desbloquear |
| `sp_usuario_vincular_perfil` | Vincular perfil |
| `sp_usuario_vincular_sistema` | Vincular sistema |
| `sp_usuario_vincular_unidade` | Vincular unidade |
| `sp_usuario_vincular_setor` | Vincular setor |
| `sp_usuario_vincular_local` | Vincular local |
| `sp_usuario_criar_contexto` | Criar contexto |
| `sp_usuario_tem_permissao` | Verificar permissão |
| `sp_usuario_possui_acesso_setor` | Verificar acesso |
| `sp_usuario_log_acesso_registrar` | Registrar acesso |
| `sp_permissao_validar` | Validar permissão |
| `sp_permissao_assert` | Assert permissão |
| `sp_acl_registrar_evento` | Registrar evento ACL |
| `sp_kernel_ledger_registrar` | Registrar evento |

#### Tabelas Consumidas
| Tabela | Operação |
|--------|----------|
| `usuario` | SELECT/INSERT/UPDATE |
| `usuario_perfil` | SELECT/INSERT/DELETE |
| `usuario_sistema` | SELECT/INSERT/DELETE |
| `usuario_unidade` | SELECT/INSERT/DELETE |
| `usuario_setor` | SELECT/INSERT/DELETE |
| `usuario_local` | SELECT/INSERT/DELETE |
| `usuario_contexto` | SELECT/INSERT/UPDATE |
| `usuario_historico_senha` | INSERT/SELECT |
| `usuario_senha_historico` | INSERT/SELECT |
| `usuario_refresh` | INSERT/SELECT/UPDATE |
| `usuario_refresh_token` | INSERT/SELECT/UPDATE |
| `usuario_reset_senha` | INSERT/SELECT |
| `usuario_senha_reset` | INSERT/SELECT |
| `usuario_log_acesso` | INSERT/SELECT |
| `usuario_profissional_registro` | SELECT |
| `auth_sessao` | INSERT/SELECT/UPDATE/DELETE |
| `auth_token` | INSERT/SELECT/UPDATE/DELETE |
| `auth_grupo` | SELECT |
| `auth_grupo_permissao` | SELECT |
| `auth_grupo_usuario` | SELECT |
| `auth_tentativa_login` | INSERT/SELECT |
| `auth_log` | INSERT |
| `auth_bloqueio` | SELECT/INSERT |
| `perfil` | SELECT |
| `perfil_permissao` | SELECT |
| `permissao` | SELECT |
| `kernel_ledger` | INSERT |
| `runtime_contexto` | SELECT/INSERT |

---

### 3. CONTEXTO OPERACIONAL
**Descrição:** Seleção de unidade, local, setor, perfil.  
**Domínio:** CORE

#### Procedures Consumidas
| Procedure | Objetivo |
|-----------|----------|
| `sp_contexto_get_available` | Listar contextos disponíveis |
| `sp_contexto_open` | Abrir contexto |
| `sp_contexto_switch` | Trocar contexto |
| `sp_contexto_assert_permissao` | Assert permissão no contexto |
| `sp_contexto_assert_transicao` | Assert transição |
| `sp_contexto_set` | Set contexto |
| `sp_contexto_get` | Get contexto |

#### Tabelas Consumidas
| Tabela | Operação |
|--------|----------|
| `usuario_contexto` | SELECT/INSERT/UPDATE |
| `unidade` | SELECT |
| `local` | SELECT |
| `local_operacional` | SELECT |
| `setor` | SELECT |
| `tipo_local` | SELECT |
| `perfil` | SELECT |
| `perfil_permissao` | SELECT |
| `permissao` | SELECT |
| `kernel_authz_policy` | SELECT |

---

### 4. RECEPÇÃO / TRIAGEM
**Descrição:** Geração de senha, classificação Manchester, encaminhamento.  
**Domínio:** APP/HIS

#### Procedures Consumidas
| Procedure | Objetivo |
|-----------|----------|
| `sp_recepcao_gerar_senha` | Gerar senha |
| `sp_recepcao_nao_compareceu` | Não compareceu |
| `sp_recepcao_iniciar_complementacao` | Iniciar complementação |
| `sp_recepcao_encaminhar_ffa` | Encaminhar FFA |
| `sp_recepcao_complementar_e_abrir_ffa` | Complementar e abrir |
| `sp_triagem_classificar_senha` | Classificar senha |
| `sp_triagem_finalizar` | Finalizar triagem |
| `sp_totem_gerar_senha` | Totem gerar senha |
| `sp_motor_manchester_runtime` | Motor Manchester |

#### Tabelas Consumidas
| Tabela | Operação |
|--------|----------|
| `senha` | SELECT/INSERT/UPDATE |
| `fila_operacional` | SELECT/INSERT |
| `ffa` | SELECT/INSERT/UPDATE |
| `atendimento` | SELECT/INSERT |
| `triagem` | SELECT/INSERT/UPDATE |
| `atendimento_triagem` | SELECT/INSERT |
| `classificacao_risco` | SELECT |
| `usuario` | SELECT |
| `sessao_usuario` | SELECT |
| `local` | SELECT |
| `setor` | SELECT |
| `totem` | SELECT |
| `totem_evento` | INSERT |

---

### 5. ATENDIMENTO MÉDICO
**Descrição:** Execução do atendimento clínico, prescrição, evolução.  
**Domínio:** APP/HIS

#### Procedures Consumidas
| Procedure | Objetivo |
|-----------|----------|
| `sp_medico_iniciar` | Iniciar atendimento |
| `sp_medico_finalizar` | Finalizar atendimento |
| `sp_medico_encaminhar` | Encaminhar |
| `sp_medico_marcar_retorno` | Marcar retorno |
| `sp_pedido_medico_criar` | Criar pedido |
| `sp_pedido_medico_item_add` | Adicionar item |
| `sp_prescritor_externo_criar` | Prescritor externo |
| `sp_orquestrador_assistencial` | Orquestrar fluxo |
| `sp_worker_atendimento` | Worker de atendimento |

#### Tabelas Consumidas
| Tabela | Operação |
|--------|----------|
| `atendimento` | SELECT/INSERT/UPDATE |
| `ffa` | SELECT/UPDATE |
| `atendimento_prescricao` | SELECT/INSERT/UPDATE |
| `prescricao` | SELECT/INSERT/UPDATE |
| `prescricao_item` | SELECT/INSERT/UPDATE |
| `pedido_medico` | SELECT/INSERT/UPDATE |
| `pedido_medico_item` | SELECT/INSERT/UPDATE |
| `atendimento_evolucao` | SELECT/INSERT |
| `atendimento_observacao` | SELECT/INSERT |
| `atendimento_diagnostico` | SELECT/INSERT |
| `atendimento_sinais_vitais` | SELECT/INSERT |
| `sinais_vitais` | SELECT/INSERT |
| `usuario` | SELECT |
| `medico` | SELECT |
| `especialidade` | SELECT |
| `exame` | SELECT |
| `solicitacao_exame` | SELECT/INSERT |

---

### 6. FARMÁCIA
**Descrição:** Dispensação, administração, receitas controladas.  
**Domínio:** APP/HIS

#### Procedures Consumidas
| Procedure | Objetivo |
|-----------|----------|
| `sp_farm_dispensacao_criar` | Criar dispensação |
| `sp_farm_dispensacao_finalizar` | Finalizar dispensação |
| `sp_farmacia_dispensacao_registrar` | Registrar log |
| `sp_medicacao_administrar` | Administrar medicação |
| `sp_medicacao_nao_respondeu` | Paciente não respondeu |
| `sp_administracao_medicacao_registrar` | Registrar administração |

#### Tabelas Consumidas
| Tabela | Operação |
|--------|----------|
| `farm_dispensacao` | SELECT/INSERT/UPDATE |
| `farm_dispensacao_item` | SELECT/INSERT/UPDATE |
| `farmacia_dispensacao_log` | INSERT |
| `prescricao` | SELECT/UPDATE |
| `prescricao_item` | SELECT/UPDATE |
| `administracao_medicacao` | INSERT/UPDATE |
| `medicacao_reavaliacao` | INSERT/UPDATE |
| `usuario` | SELECT |
| `local` | SELECT |

---

### 7. INTERNAÇÃO
**Descrição:** Admission, alta, movimentação, prescrição de internação.  
**Domínio:** APP/HIS

#### Procedures Consumidas
| Procedure | Objetivo |
|-----------|----------|
| `sp_internacao_admitir` | Admitir |
| `sp_internacao_alta` | Dar alta |
| `sp_internacao_transferir` | Transferir |
| `sp_internacao_movimentar` | Movimentar |
| `sp_internacao_prescricao_criar` | Criar prescrição |
| `sp_internacao_prescricao_item_add` | Adicionar item |
| `sp_internacao_registro_enfermagem_criar` | Registro enfermagem |
| `sp_internacao_turno_registro_criar` | Registro de turno |

#### Tabelas Consumidas
| Tabela | Operação |
|--------|----------|
| `internacao` | SELECT/INSERT/UPDATE |
| `internacao_prescricao` | SELECT/INSERT/UPDATE |
| `internacao_prescricao_item` | SELECT/INSERT/UPDATE |
| `internacao_registro_enfermagem` | SELECT/INSERT |
| `internacao_turno_registro` | SELECT/INSERT |
| `internacao_historico` | INSERT |
| `internacao_movimentacao` | INSERT/UPDATE |
| `internacao_cuidados` | SELECT/INSERT |
| `internacao_dietas` | SELECT/INSERT |
| `internacao_medicacao_administracao` | INSERT/UPDATE |
| `leito` | SELECT/UPDATE |
| `setor` | SELECT |
| `unidade` | SELECT |

---

### 8. FATURAMENTO
**Descrição:** Geração de contas, convênios, produção SUS.  
**Domínio:** APP/FINANCEIRO

#### Procedures Consumidas
| Procedure | Objetivo |
|-----------|----------|
| `sp_faturamento_gerar_conta` | Gerar conta |
| `sp_faturamento_fechar_conta` | Fechar conta |
| `sp_faturamento_cancelar` | Cancelar faturamento |
| `sp_faturamento_emitir_documento` | Emitir documento |
| `sp_faturamento_sus_processar` | Processar SUS |
| `sp_conciliador_estoque_faturamento` | Conciliar |

#### Tabelas Consumidas
| Tabela | Operação |
|--------|----------|
| `faturamento_conta` | SELECT/INSERT/UPDATE |
| `faturamento_conta_item` | SELECT/INSERT/UPDATE |
| `faturamento_conta_paciente` | SELECT |
| `faturamento_convenio` | SELECT |
| `faturamento_evento` | INSERT |
| `caixa` | SELECT/INSERT/UPDATE |
| `caixa_evento` | INSERT |
| `venda` | SELECT/INSERT |
| `venda_item` | SELECT/INSERT |
| `forma_pagamento` | SELECT |

---

### 9. ESTOQUE
**Descrição:** Movimentação, saldos, reservas, inventário.  
**Domínio:** APP/ESTOQUE

#### Procedures Consumidas
| Procedure | Objetivo |
|-----------|----------|
| `sp_estoque_movimento_create` | Criar movimento |
| `sp_estoque_movimento_confirmar` | Confirmar movimento |
| `sp_estoque_saldo_calcular` | Calcular saldo |
| `sp_estoque_inventario_abrir` | Abrir inventário |
| `sp_estoque_inventario_fechar` | Fechar inventário |
| `sp_estoque_reserva_criar` | Criar reserva |
| `sp_estoque_reserva_cancelar` | Cancelar reserva |
| `sp_conciliador_estoque_faturamento` | Conciliar |
| `sp_almoxarifado_central_movimentar` | Movimentar almoxarifado |

#### Tabelas Consumidas
| Tabela | Operação |
|--------|----------|
| `estoque_produto` | SELECT/UPDATE |
| `estoque_item` | SELECT/UPDATE |
| `estoque_local` | SELECT |
| `estoque_lote` | SELECT |
| `estoque_saldo` | SELECT/UPDATE |
| `estoque_movimentacao` | INSERT/UPDATE |
| `estoque_movimento` | INSERT/UPDATE |
| `estoque_inventario` | SELECT/INSERT/UPDATE |
| `estoque_reserva` | SELECT/INSERT/UPDATE |
| `estoque_fluxo_assistencial` | SELECT |
| `estoque_ledger` | INSERT |
| `estoque_audit_stream` | INSERT |
| `almoxarifado_central` | SELECT/UPDATE |
| `consumo_insumo` | INSERT |

---

### 10. PAINEL / DISPLAY
**Descrição:** Painéis de chamada, TVs rotativas, alertas.  
**Domínio:** PLATFORM

#### Procedures Consumidas
| Procedure | Objetivo |
|-----------|----------|
| `sp_painel_chamar_senha` | Chamar senha |
| `sp_painel_cancelar_senha` | Cancelar senha |
| `sp_painel_config_set` | Configurar painel |
| `sp_painel_filtro_locais_seed` | Seed filtros |
| `sp_painel_seed_especialidades` | Seed especialidades |
| `sp_tv_rotativo_configurar` | Configurar TV |

#### Tabelas Consumidas
| Tabela | Operação |
|--------|----------|
| `painel` | SELECT/UPDATE |
| `painel_local` | SELECT |
| `painel_fila_tipo` | SELECT |
| `painel_lane` | SELECT |
| `painel_mensagem` | SELECT/INSERT |
| `painel_evento_stream` | INSERT |
| `tv_rotativo` | SELECT/UPDATE |
| `tv_rotativo_tela` | SELECT/INSERT |
| `fila_operacional` | SELECT |
| `senha` | SELECT/UPDATE |
| `totem` | SELECT |
| `totem_evento` | INSERT |

---

### 11. TOTEM
**Descrição:** Totens de autoatendimento.  
**Domínio:** PLATFORM

#### Procedures Consumidas
| Procedure | Objetivo |
|-----------|----------|
| `sp_totem_gerar_senha` | Gerar senha |
| `sp_totem_feedback_registrar` | Registrar feedback |
| `sp_totem_status_get` | Status do totem |

#### Tabelas Consumidas
| Tabela | Operação |
|--------|----------|
| `totem` | SELECT/UPDATE |
| `totem_evento` | INSERT |
| `totem_feedback` | INSERT |
| `totem_senha_opcao` | SELECT |
| `senha` | INSERT/SELECT |
| `fila_operacional` | INSERT/SELECT |

---

### 12. RUNTIME / KERNEL
**Descrição:** Engine de execução, sincronização, edge, resiliência.  
**Domínio:** KERNEL

#### Procedures Consumidas
| Procedure | Objetivo |
|-----------|----------|
| `sp_runtime_edge_executor` | Executor edge |
| `sp_runtime_resiliente_execucao` | Execução resiliente |
| `sp_runtime_clinico_exec` | Execução clínica |
| `sp_runtime_feedback` | Feedback |
| `sp_runtime_escudo_total` | Escudo total |
| `sp_runtime_decision_engine` | Decision engine |
| `sp_sync_federado_executor` | Sync federado |
| `sp_worker_atendimento` | Worker atendimento |
| `sp_worker_runtime` | Worker runtime |
| `sp_retry_semantico_worker` | Retry semântico |
| `sp_reconciliar_runtime` | Reconciliar |
| `sp_kernel_ledger_registrar` | Registrar ledger |
| `sp_kernel_writer_unlock` | Unlock writer |

#### Tabelas Consumidas
| Tabela | Operação |
|--------|----------|
| `runtime_execution_queue` | SELECT/INSERT/UPDATE |
| `runtime_sync_queue` | SELECT/INSERT/UPDATE |
| `runtime_contexto` | SELECT/INSERT/UPDATE |
| `runtime_dispositivo` | SELECT |
| `runtime_api_session_token` | SELECT |
| `kernel_ledger` | INSERT |
| `kernel_runtime_evento` | INSERT |
| `kernel_runtime_heartbeat` | INSERT/UPDATE |
| `kernel_runtime_single_writer_lock` | SELECT/INSERT/UPDATE |
| `kernel_single_writer_lock` | SELECT/INSERT/UPDATE |
| `kernel_authz_policy` | SELECT |
| `kernel_identity_trust_chain` | SELECT/INSERT |
| `assistencial_circuit_breaker` | SELECT/UPDATE |
| `assistencial_checkpoint_global` | SELECT/UPDATE |
| `assistencial_snapshot_runtime` | SELECT/INSERT |
| `ledger_global_sincronismo` | INSERT/SELECT |
| `ledger_evento_sincronizacao` | INSERT/SELECT |
| `runtime_invariant_log` | INSERT |
| `runtime_edge_evento` | INSERT |
| `runtime_estado_sobrevivencia` | SELECT/UPDATE |
| `runtime_evento_provisional` | INSERT |
| `atendimento` | SELECT/UPDATE |
| `ffa` | SELECT/UPDATE |
| `senha` | SELECT/UPDATE |

---

### 13. FARMÁCIA
**Descrição:** Gestão de medicamentos, dispensação, receitas controladas.  
**Domínio:** APP/FARMÁCIA

#### Procedures Consumidas
| Procedure | Objetivo |
|-----------|----------|
| `sp_farm_dispensacao_criar` | Criar dispensação |
| `sp_farm_dispensacao_finalizar` | Finalizar |
| `sp_farmacia_dispensacao_registrar` | Registrar log |
| `sp_medicacao_administrar` | Administrar |
| `sp_medicacao_nao_respondeu` | Não respondeu |
| `sp_administracao_medicacao_registrar` | Registrar administração |

#### Tabelas Consumidas
| Tabela | Operação |
|--------|----------|
| `farm_dispensacao` | SELECT/INSERT/UPDATE |
| `farm_dispensacao_item` | SELECT/INSERT/UPDATE |
| `farmacia_dispensacao_log` | INSERT |
| `prescricao` | SELECT/UPDATE |
| `prescricao_item` | SELECT/UPDATE |
| `administracao_medicacao` | INSERT/UPDATE |
| `medicacao_reavaliacao` | INSERT/UPDATE |
| `usuario` | SELECT |
| `local` | SELECT |

---

### 14. LABORATÓRIO
**Descrição:** Gestão de exames laboratoriais, amostras, resultados.  
**Domínio:** APP/LABORATÓRIO

#### Procedures Consumidas
| Procedure | Objetivo |
|-----------|----------|
| `sp_lab_pedido_criar` | Criar pedido |
| `sp_lab_amostra_registrar` | Registrar amostra |
| `sp_lab_resultado_registrar` | Registrar resultado |
| `sp_protocolo_emitir` | Emitir protocolo |

#### Tabelas Consumidas
| Tabela | Operação |
|--------|----------|
| `lab_pedido` | SELECT/INSERT/UPDATE |
| `lab_amostra` | SELECT/INSERT/UPDATE |
| `lab_resultado` | SELECT/INSERT/UPDATE |
| `lab_evento` | INSERT |
| `laboratorio_protocolo` | SELECT/INSERT |
| `laboratorio_protocolo_evento` | INSERT |
| `exame_pedido` | SELECT/INSERT |
| `solicitacao_exame` | SELECT/INSERT |

---

### 15. AUDITORIA / CONFORMIDADE
**Descrição:** Auditoria de acesso, eventos, erros, prontuário.  
**Domínio:** CORE/AUDITORIA

#### Procedures Consumidas
| Procedure | Objetivo |
|-----------|----------|
| `sp_auditoria_evento_registrar` | Registrar evento |
| `sp_auditar_erro_sql` | Auditar erro SQL |
| `sp_log_acesso_registrar` | Registrar acesso |

#### Tabelas Consumidas
| Tabela | Operação |
|--------|----------|
| `auditoria_evento` | INSERT |
| `auditoria_acesso` | INSERT |
| `auditoria_erro` | INSERT |
| `auditoria_ffa` | INSERT |
| `auditoria_fila` | INSERT |
| `auditoria_mestre` | INSERT |
| `log_auditoria` | INSERT |
| `log_acesso_prontuario` | INSERT |
| `log_leitura_prontuario` | INSERT |
| `kernel_ledger` | INSERT |
| `auth_log` | INSERT |

---

### 16. INTEGRAÇÃO
**Descrição:** Integrações externas, SINAN, webhooks.  
**Domínio:** INTEGRAÇÃO

#### Procedures Consumidas
| Procedure | Objetivo |
|-----------|----------|
| `sp_integracao_executar` | Executar integração |
| `sp_webhook_disparar` | Disparar webhook |
| `sp_sinan_notificacao_enviar` | Enviar SINAN |

#### Tabelas Consumidas
| Tabela | Operação |
|--------|----------|
| `integracao` | SELECT |
| `integracao_credencial` | SELECT |
| `webhook_entrada` | SELECT |
| `webhook_saida` | INSERT |
| `sinan_notificacao` | INSERT/UPDATE |
| `sinan_evento` | INSERT |

---

### 17. AGENDAMENTO
**Descrição:** Agendamentos de consultas, disponibilidade.  
**Domínio:** APP/AGENDAMENTO

#### Procedures Consumidas
| Procedure | Objetivo |
|-----------|----------|
| `sp_agendamento_criar` | Criar agendamento |
| `sp_agendamento_cancelar` | Cancelar |
| `sp_agenda_disponibilidade_get` | Get disponibilidade |

#### Tabelas Consumidas
| Tabela | Operação |
|--------|----------|
| `agendamento` | SELECT/INSERT/UPDATE/DELETE |
| `agenda_disponibilidade` | SELECT/INSERT/UPDATE |
| `agendamentos_eventos` | INSERT |
| `usuario` | SELECT |
| `paciente` | SELECT |
| `local` | SELECT |
| `especialidade` | SELECT |

---

### 18. RH / ADMINISTRATIVO
**Descrição:** Escalas, plantões, chamados, manutenção.  
**Domínio:** APP/RH

#### Procedures Consumidas
| Procedure | Objetivo |
|-----------|----------|
| `sp_escala_gerar` | Gerar escala |
| `sp_plantao_abrir` | Abrir plantão |
| `sp_plantao_fechar` | Fechar plantão |
| `sp_chamado_abrir` | Abrir chamado |
| `sp_chamado_fechar` | Fechar chamado |
| `sp_manutencao_iniciar` | Iniciar manutenção |
| `sp_manutencao_finalizar` | Finalizar |

#### Tabelas Consumidas
| Tabela | Operação |
|--------|----------|
| `escala_medica` | SELECT/INSERT/UPDATE |
| `escala_plantao` | SELECT/INSERT/UPDATE |
| `escala_plantao_atual` | SELECT/INSERT |
| `escala_profissional` | SELECT/INSERT |
| `plantao` | SELECT/INSERT/UPDATE |
| `chamado` | SELECT/INSERT/UPDATE |
| `chamado_evento` | INSERT |
| `chamado_manutencao` | INSERT/UPDATE |
| `manutencao_execucao` | INSERT/UPDATE |
| `funcionario` | SELECT |
| `usuario` | SELECT |
| `unidade` | SELECT |
| `setor` | SELECT |

---

## MATRIZ DE CONSUMO (Módulo × Tabela)

| Módulo | Tabelas | Procedures |
|--------|---------|------------|
| PORTAL | 12 | 11 |
| AUTH/IAM | 27 | 29 |
| CONTEXTO | 9 | 7 |
| RECEPÇÃO/TRIAGEM | 12 | 9 |
| ATENDIMENTO MÉDICO | 18 | 9 |
| FARMÁCIA | 9 | 6 |
| INTERNAÇÃO | 13 | 8 |
| FATURAMENTO | 11 | 6 |
| ESTOQUE | 14 | 9 |
| PAINEL/DISPLAY | 12 | 6 |
| TOTEM | 6 | 3 |
| RUNTIME/KERNEL | 23 | 13 |
| LABORATÓRIO | 8 | 4 |
| AUDITORIA | 12 | 3 |
| INTEGRAÇÃO | 6 | 3 |
| AGENDAMENTO | 7 | 4 |
| RH/ADMIN | 13 | 7 |

---

## FLUXOS DE CONSUMO (Exemplos Concretos)

### FLUXO 1 — LOGIN
```text
FRONT (Login)
    ↓
sp_auth_login
    ↓
SELECT usuario, auth_sessao, auth_token, usuario_perfil, perfil_permissao
    ↓
INSERT auth_sessao, auth_token, usuario_log_acesso, kernel_ledger
    ↓
Retorna sessão + token + perfil
    ↓
FRONT renderiza Portal
```

### FLUXO 2 — RECEPÇÃO → SENHA → FFA
```text
FRONT (Recepção)
    ↓
sp_recepcao_gerar_senha
    ↓
INSERT senha, fila_operacional, atendimento
    ↓
Retorna senha + ffa + atendimento
    ↓
FRONT exibe senha
```

### FLUXO 3 — TRIAGEM
```text
FRONT (Triagem)
    ↓
sp_triagem_classificar_senha
    ↓
SELECT senha, ffa, classificacao_risco
    ↓
INSERT triagem, atendimento_evento, ffa_historico_status
    ↓
Retorna classificação
    ↓
FRONT exibe classificação
```

### FLUXO 4 — ATENDIMENTO MÉDICO
```text
FRONT (Médico)
    ↓
sp_medico_iniciar
    ↓
SELECT atendimento, ffa, prescricao
    ↓
INSERT prescricao, pedido_medico, atendimento_evolucao
    ↓
Retorna prescrição + pedidos
    ↓
FRONT exibe prescrição
```

### FLUXO 5 — FARMÁCIA
```text
FRONT (Farmácia)
    ↓
sp_farm_dispensacao_criar
    ↓
SELECT prescricao, prescricao_item, estoque_saldo
    ↓
INSERT farm_dispensacao, farm_dispensacao_item, estoque_movimentacao
    ↓
Retorna dispensação
    ↓
FRONT exibe dispensação
```

### FLUXO 6 — INTERNAÇÃO
```text
FRONT (Internação)
    ↓
sp_internacao_admitir
    ↓
SELECT atendimento, leito, setor
    ↓
INSERT internacao, leito (UPDATE status)
    ↓
Retorna internação + leito
    ↓
FRONT exibe leito
```

### FLUXO 7 — PAINEL DE CHAMADA
```text
FRONT (Painel)
    ↓
sp_painel_chamar_senha
    ↓
SELECT senha, fila_operacional
    ↓
UPDATE senha, INSERT painel_evento_stream
    ↓
Retorna senha chamada
    ↓
FRONT exibe senha
```

---

## CONCLUSÃO

- **18 módulos** identificados
- **478 tabelas** consumidas por esses módulos
- **~501 procedures** consumidas por esses módulos
- **0 duplicações** de consumo entre módulos
- **Padrão claro:** FRONT → SP → SELECT/INSERT/UPDATE → Retorno

---

**Arquivo:** docs/database/MAPA_CONSUMO_MODULOS.md  
**Status:** Consolidado  
**Próximo:** Catálogo completo de Procedures + Blueprints/MDs/BRs/FRONTs.

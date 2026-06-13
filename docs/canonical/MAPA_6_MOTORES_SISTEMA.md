# MAPA COMPLETO: 6 MOTORES DO SISTEMA HOSPITALAR

**Sistema:** Pronto Atendimento / UPA  
**Arquitetura:** Plataforma Assistencial Determinística

---

## VISÃO GERAL DA ARQUITETURA

```
┌─────────────────────────────────────────────────────────────────┐
│                         KERNEL                                  │
│                  sp_master_dispatcher                           │
└─────────────────────────────┬───────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     RUNTIME GUARDIAN                           │
│               sp_guardiao_runtime / sp_kernel                   │
└─────────────────────────────┬───────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                 ORQUESTRADOR GLOBAL                            │
│              sp_orquestrador_assistencial                       │
└─────────────────────────────┬───────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      EVENT LEDGER                               │
│                   atendimento_evento                           │
└─────────────────────────────┬───────────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        ▼                     ▼                     ▼
┌───────────────┐    ┌───────────────┐    ┌───────────────┐
│    FARMÁCIA   │    │  FFA/GPAT    │    │  ATENDIMENTO  │
│  dispensação  │    │   pedido SUS  │    │ fluxo clínico │
└───────────────┘    └───────────────┘    └───────────────┘
```

---

## 1º MOTOR: KERNEL

**Responsável por:** Orquestração central e dispatching de ações

### Tabelas do Kernel

| Tabela | Descrição | Campos Principais |
|--------|-----------|------------------|
| `sistema` | Sistemas cadastrados | `id_sistema`, `nome`, `descricao` |
| `unidade` | Unidades/UPAs | `id_unidade`, `nome`, `cnes` |
| `local_operacional` | Locais internos | `id_local_operacional`, `nome`, `tipo` |
| `perfil` | Perfis de acesso | `id_perfil`, `nome` |
| `permissao` | Permissões | `id_permissao`, `nome`, `recurso` |

### SPs do Kernel

| SP | Descrição |
|----|-----------|
| `sp_master_dispatcher` | Orquestrador central de ações |
| `sp_master_dispatcher_runtime` | Runtime de execução com sessão |
| `sp_dispatcher_kernel` | Kernel de dispatching |
| `sp_coordenador_global` | Coordenador global |
| `sp_kernel_runtime_heartbeat` | Heartbeat do sistema |
| `sp_kernel_cleanup_expired` | Limpeza de sessões expiradas |
| `sp_kernel_authenticate_runtime` | Autenticação runtime |
| `sp_kernel_writer_lock` | Lock de escrita |
| `sp_kernel_writer_unlock` | Unlock de escrita |

---

## 2º MOTOR: IDENTIDADE

**Responsável por:** Autenticação, sessão e contexto do usuário

### Tabelas de Identidade

| Tabela | Descrição | Campos Principais |
|--------|-----------|------------------|
| `usuario` | Usuários do sistema | `id_usuario`, `id_pessoa`, `login`, `senha_hash` |
| `pessoa` | Dados pessoais | `id_pessoa`, `nome_completo`, `cpf`, `cns`, `data_nascimento` |
| `sessao_usuario` | Sessões ativas | `id_sessao_usuario`, `token`, `expira_em`, `ativo` |
| `usuario_perfil` | Usuário ↔ Perfil | `id_usuario`, `id_perfil` |
| `usuario_contexto` | Contexto ativo | `id_usuario`, `id_unidade`, `id_local_operacional`, `id_perfil` |
| `usuario_local_operacional` | Locais do usuário | `id_usuario`, `id_local_operacional` |
| `usuario_unidade` | Unidades do usuário | `id_usuario`, `id_unidade` |
| `usuario_sistema` | Sistemas do usuário | `id_usuario`, `id_sistema`, `id_perfil` |

### SPs de Identidade

| SP | Descrição |
|----|-----------|
| `sp_auth_login` | Login de usuário |
| `sp_auth_logout` | Logout |
| `sp_auth_validar_sessao` | Valida sessão |
| `sp_auth_criar_sessao` | Cria sessão |
| `sp_auth_permissoes` | Lista permissões |
| `sp_auth_verificar_bloqueio` | Verifica bloqueio |
| `sp_auth_assert_permission_runtime` | Assert permissão runtime |
| `sp_usuario_criar_contexto` | Cria contexto |
| `sp_usuario_vincular_local` | Vincula local |
| `sp_usuario_vincular_unidade` | Vincula unidade |
| `sp_usuario_vincular_sistema` | Vincula sistema |
| `sp_usuario_tem_permissao` | Verifica permissão |
| `sp_login_validar_usuario` | Valida usuário |
| `sp_login_validar_contexto` | Valida contexto |
| `sp_sessao_abrir` | Abre sessão |
| `sp_sessao_encerrar` | Encerra sessão |
| `sp_sessao_assert` | Assert sessão |
| `sp_sessao_contexto_get` | Get contexto sessão |

---

## 3º MOTOR: FLUXO CLÍNICO

**Responsável por:** Gerenciamento de filas, senhas e transições de estado

### Tabelas de Fluxo Clínico

| Tabela | Descrição | Campos Principais |
|--------|-----------|------------------|
| `senhas` | Senhas/tickets | `id`, `codigo`, `status`, `tipo_atendimento`, `prioridade` |
| `fila_senha` | Status público | `id_senha`, `status` |
| `senha_eventos` | Auditoria | `id_senha`, `tipo_evento`, `status_de`, `status_para` |
| `fila_operacional` | Fila por setor | `id_fila`, `id_ffa`, `tipo`, `substatus`, `prioridade` |
| `fila_operacional_evento` | Auditoria fila | `id_fila`, `tipo_evento` |
| `fila_retorno` | Retornos | `id`, `id_ffa`, `data_retorno_agendada` |

### SPs de Fluxo Clínico

| SP | Descrição |
|----|-----------|
| `sp_senha_emitir` | Emite senha |
| `sp_senha_chamar` | Chama senha |
| `sp_senha_chamar_proxima` | Chama próxima |
| `sp_senha_chamar_setor` | Chama por setor |
| `sp_senha_finalizar` | Finaliza senha |
| `sp_senha_cancelar` | Cancela senha |
| `sp_senha_nao_compareceu` | Não compareceu |
| `sp_senha_transicionar_status` | Transiciona status |
| `sp_senha_iniciar_complementacao` | Inicia complementação |
| `sp_complementar_senha` | Complementa dados |
| `sp_recepcao_gerar_senha` | Gera senha recepção |
| `sp_recepcao_complementar_e_abrir_ffa` | Complementa e abre FFA |
| `sp_recepcao_iniciar_complementacao` | Inicia complementação |
| `sp_recepcao_encaminhar_ffa` | Encaminha FFA |
| `sp_fila_chamar_proxima` | Chama próxima fila |
| `sp_fila_finalizar` | Finaliza fila |
| `sp_fila_tipo_por_local` | Tipo por local |

---

## 4º MOTOR: FFA (FICHA DE FOLHAS DE ATENDIMENTO)

**Responsável por:** Registro central de atendimento clínico

### Tabelas do FFA

| Tabela | Descrição | Campos Principais |
|--------|-----------|------------------|
| `ffa` | Ficha de Atendimento | `id`, `id_paciente`, `id_senha`, `status`, `classificacao_cor` |
| `atendimento` | Registro de visita | `id`, `id_paciente`, `protocolo`, `status` |
| `atendimento_evolucao` | Notas clínicas | `id_atendimento`, `descricao`, `tipo_profissional` |
| `atendimento_sinais_vitais` | Sinais vitais | `id_atendimento`, `pressao_sistolica`, `fc`, `temperatura` |
| `atendimento_diagnosticos` | CID-10 | `id_atendimento`, `cid10`, `tipo` |
| `atendimento_prescricao` | Prescrições | `id_atendimento`, `id_medico`, `status` |
| `atendimento_pedidos_exame` | Pedidos exames | `id_atendimento`, `id_exame`, `status` |
| `triagem` | Avaliação de risco | `id_triagem`, `id_atendimento`, `classificacao_risco`, `sinais_vitais` |

### SPs do FFA

| SP | Descrição |
|----|-----------|
| `sp_ffa_criar` | Cria FFA |
| `sp_ffa_adicionar_item` | Adiciona item |
| `sp_ffa_gpat_garantir` | Garante GPAT |
| `sp_ffa_gpat_gerar` | Gera GPAT |
| `sp_ffa_orquestrador_transicao` | Orquestra transição |
| `sp_atendimento_iniciar` | Inicia atendimento |
| `sp_atendimento_transicionar` | Transiciona |
| `sp_atendimento_finalizar` | Finaliza |
| `sp_atendimento_finalizar_evasao` | Finaliza evasão |
| `sp_atendimento_cancelar` | Cancela |
| `sp_atendimento_senha_nao_compareceu` | Não compareceu |
| `sp_atendimento_vincular_paciente` | Vincula paciente |
| `sp_triagem_finalizar` | Finaliza triagem |
| `sp_triagem_classificar_senha` | Classifica senha |
| `sp_medico_encaminhar` | Encaminha médico |
| `sp_medico_finalizar` | Finaliza médico |
| `sp_medico_marcar_retorno` | Marca retorno |
| `sp_rechamar_procedimento` | Rechama procedimento |

---

## 5º MOTOR: FARMÁCIA

**Responsável por:** Dispensação de medicamentos e controle de estoque

### Tabelas de Farmácia

| Tabela | Descrição | Campos Principais |
|--------|-----------|------------------|
| `farmaco` | Catálogo meds | `id`, `codigo`, `nome`, `principio_ativo`, `concentracao` |
| `farmaco_lote` | Lotes meds | `id_farmaco`, `lote`, `validade`, `quantidade_saldo` |
| `dispensacao_medicacao` | Dispensação | `id_atendimento`, `id_farmaco`, `quantidade`, `status` |
| `gpat_atendimento` | Prescrição GPAT | `id_ffa`, `tipo_prescritor`, `status` |
| `gpat_item` | Itens GPAT | `id_gpat`, `id_farmaco`, `posologia`, `status` |
| `gpat_dispensacao` | Disp. GPAT | `id_gpat_item`, `quantidade_dispensada` |
| `administracao_medicacao` | Admin real | `id_atendimento`, `dose_administrada`, `via` |
| `administracao_medicacao_ordem` | Ordem admin | `id_item`, `quantidade`, `status` |

### SPs de Farmácia

| SP | Descrição |
|----|-----------|
| `sp_farmacia_dispensar_registrar` | Registra dispensação |
| `sp_farm_dispensacao_criar` | Cria dispensação |
| `sp_farm_dispensacao_registrar` | Registra detalhes |
| `sp_farm_reserva_confirmar` | Confirma reserva |
| `sp_medicacao_finalizar` | Finaliza medicação |
| `sp_medicacao_marcar_executado` | Marca executado |
| `sp_medicacao_nao_respondeu` | Não respondeu |
| `sp_medicacao_complementar` | Complementa |
| `sp_medicacao_em_execucao_obs` | Em execução |
| `sp_medicacao_cancelar` | Cancela |
| `sp_estoque_movimentar` | Movimenta estoque |
| `sp_estoque_movimento_criar` | Cria movimento |
| `sp_estoque_produto_criar_com_codigo` | Cria produto |
| `sp_conciliador_estoque_faturamento` | Concilia |

---

## 6º MOTOR: FATURAMENTO SUS

**Responsável por:** Faturamento, protocolos e integração SUS

### Tabelas de Faturamento

| Tabela | Descrição | Campos Principais |
|--------|-----------|------------------|
| `procedimento_protocolo` | Protocolos | `id_protocolo`, `tipo`, `status` |
| `laboratorio_protocolo` | Protocolos lab | `id_protocolo`, `codigo_externo` |
| `documento_tipo_config` | Tipos documentos | `tipo`, `descricao` |
| `documento_emissao` | Docs emitidos | `tipo_documento`, `numeroDocumento`, `status` |
| `forma_pagamento` | Formas pagamento | `descricao` |
| `sequencia` | Sequências | `tipo_sequencia`, `proximo_numero` |

### SPs de Faturamento

| SP | Descrição |
|----|-----------|
| `sp_protocolo_emitir` | Emite protocolo |
| `sp_gera_protocolo_lab` | Gera protocolo lab |
| `sp_lab_protocolo_criar_ou_mapear` | Cria/mapeia |
| `sp_procedimento_protocolo_criar` | Cria protocolo |
| `sp_iniciar_execucao_procedimento_rx` | Inicia RX |
| `sp_finalizar_procedimento_rx` | Finaliza RX |
| `sp_finalizar_procedimento_laboratorio` | Finaliza laboratório |
| `sp_finalizar_procedimento_geral` | Finaliza geral |
| `sp_conciliador_estoque_faturamento` | Concilia |
| `sp_fluxo_estoque` | Fluxo estoque |
| `sp_sequencia_proximo_numero` | Próximo número |

---

## MOTORES AUXILIARES

### Auditoria e Logging

| Tabela | Descrição |
|--------|-----------|
| `auditoria_evento` | Eventos de auditoria |
| `auditoria_erro` | Erros SQL |
| `ledger_evento` | Ledger de eventos |
| `acl_evento` | Eventos ACL |
| `auditoria_login` | Logins |

### SPs de Auditoria

| SP | Descrição |
|----|-----------|
| `sp_auditoria_evento_registrar` | Registra evento |
| `sp_auditar_erro_sql` | Registra erro SQL |
| `sp_ledger_evento_log` | Log ledger |
| `sp_ledger_registrar_evento` | Registra ledger |
| `sp_acl_registrar_evento` | Registra ACL |

### Workflow e Runtime

| Tabela | Descrição |
|--------|-----------|
| `workflow_fase` | Fases do workflow |

### SPs de Workflow

| SP | Descrição |
|----|-----------|
| `sp_fluxo_executor_matriz` | Executor matriz |
| `sp_fluxo_guardiao_transicao` | Guardião transição |
| `sp_fluxo_verificar_autorizacao` | Verifica autorização |
| `sp_validar_transicao_fluxo` | Valida transição |
| `sp_contexto_assert_permissao` | Assert permissão |
| `sp_contexto_assert_transicao` | Assert transição |
| `sp_orquestrador_assistencial` | Orquestrador |
| `sp_oraculo_assistencial` | Órculo |

### Runtime e Execução

| SP | Descrição |
|----|-----------|
| `sp_runtime_decision_engine` | Motor de decisão |
| `sp_runtime_clinico_exec` | Execução clínica |
| `sp_runtime_edge_executor` | Executor edge |
| `sp_runtime_feedback` | Feedback |
| `sp_runtime_resiliente_execucao` | Execução resiliente |
| `sp_runtime_escudo_total` | Escudo total |
| `sp_guardiao_absoluto` | Guardião absoluto |
| `sp_guardiao_runtime_assert` | Assert guardião |
| `sp_guardiao_runtime_decidir` | Decisão guardião |
| `sp_guardiao_runtime_final` | Guardião final |
| `sp_checkpoint_global_validar` | Valida checkpoint |
| `sp_reconciliar_runtime` | Reconcilia runtime |
| `sp_invariant_engine` | Motor invariante |
| `sp_raim_calcular` | Calcula RAIM |

---

## FLUXO COMPLETO DE UM ATENDIMENTO

```
1. KERNEL
   sp_master_dispatcher
           │
           ▼
2. IDENTIDADE
   sp_auth_validar_sessao
   sp_sessao_contexto_get
           │
           ▼
3. FLUXO CLÍNICO
   sp_senha_emitir → senhas
   sp_senha_chamar → fila_operacional
           │
           ▼
4. FFA
   sp_ffa_criar → ffa
   sp_atendimento_iniciar → atendimento
   sp_triagem_finalizar → triagem
           │
           ▼
5. FARMÁCIA
   sp_ffa_gpat_gerar → gpat_atendimento
   sp_farmacia_dispensar_registrar → dispensacao_medicacao
           │
           ▼
6. FATURAMENTO
   sp_protocolo_emitir → documento_emissao
   sp_estoque_movimentar → estoque_movimento
```

---

## RESUMO: 6 MOTORES

| # | Motor | Tabelas Principais | Função |
|---|-------|-------------------|--------|
| 1 | **KERNEL** | `sistema`, `unidade`, `local_operacional`, `perfil` | Orquestração central |
| 2 | **IDENTIDADE** | `usuario`, `pessoa`, `sessao_usuario`, `usuario_contexto` | Auth e contexto |
| 3 | **FLUXO CLÍNICO** | `senhas`, `fila_operacional`, `fila_senha` | Filas e senhas |
| 4 | **FFA** | `ffa`, `atendimento`, `triagem`, `atendimento_evolucao` | Atendimento clínico |
| 5 | **FARMÁCIA** | `farmaco`, `gpat_atendimento`, `dispensacao_medicacao` | Medicamentos |
| 6 | **FATURAMENTO** | `protocolo`, `documento_emissao`, `estoque_movimento` | SUS e financeiro |

---

*Documento gerado em 11/03/2026*

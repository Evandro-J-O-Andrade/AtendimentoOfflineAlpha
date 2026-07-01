# CATÁLOGO DE ENTIDADES DO CORE
**Banco:** pronto_atendimento (Dump20260606.sql)  
**Data:** 2026-06-30  
**Status:** Consolidado

---

## CLASSIFICAÇÃO POR DOMÍNIO

### CORE / IDENTIDADE / MULTI-TENANT
Entidades fundamentais da plataforma. Reutilizáveis por qualquer aplicação.

| Entidade | Tabelas | Descrição |
|----------|---------|-----------|
| **Pessoa (Raiz)** | `pessoa`, `pessoa_*` (9) | Entidade raiz da plataforma. Pacientes, funcionários, profissionais, acompanhantes, responsáveis, clientes, fornecedores. |
| **Tenant/SaaS** | `saas_entidade`, `tenant_registry`, `saas_contrato` | Multi-tenant. Entidade, tenant, contrato. |
| **Identidade** | `usuario`, `usuario_*` (18), `perfil`, `perfil_permissao`, `permissao` | Autenticação, autorização, perfis, permissões, contexto, unidades, setores, sistemas. |
| **Auth** | `auth_sessao`, `auth_token`, `auth_grupo`, `auth_grupo_permissao`, `auth_grupo_usuario`, `auth_tentativa_login`, `auth_log`, `auth_audit`, `auth_bloqueio`, `auth_notificacao`, `auth_parametro`, `auth_sessao_dispositivo` | Autenticação, sessões, tokens, grupos, tentativas, logs, bloqueios. |
| **Sessão** | `sessao_usuario`, `sessao_ativa`, `sessao_evento`, `sessao_contexto_historico` | Sessões ativas, eventos, histórico de contexto. |

**Total CORE:** ~47 tabelas

---

### KERNEL / RUNTIME
Infraestrutura técnica de execução, sincronização, resiliência.

| Entidade | Tabelas | Descrição |
|----------|---------|-----------|
| **Runtime Core** | `runtime_execution_queue`, `runtime_sync_queue`, `runtime_sync_log`, `runtime_concurrency_guard`, `runtime_lock_semantico`, `runtime_kernel_locks`, `runtime_snapshot_governanca`, `runtime_snapshot_metadata`, `runtime_estado_sobrevivencia`, `runtime_evento_provisional`, `runtime_invariant_log`, `runtime_edge_evento`, `runtime_api_session_token`, `runtime_contexto`, `runtime_dispositivo` | Filas, sync, edge, snapshots, locks, heartbeats, dispositivos. |
| **Kernel** | `kernel_ledger`, `kernel_runtime_evento`, `kernel_runtime_heartbeat`, `kernel_runtime_single_writer_lock`, `kernel_single_writer_lock`, `kernel_authz_policy`, `kernel_identity_trust_chain` | Ledger, eventos, heartbeat, single writer, authz policies, trust chain. |
| **Resiliência** | `assistencial_checkpoint_global`, `assistencial_circuit_breaker`, `assistencial_evento_hash`, `assistencial_minipal_metric`, `assistencial_quorum_clinico`, `assistencial_raim_metric`, `assistencial_runtime_federado`, `assistencial_runtime_panel`, `assistencial_simulacao_futura`, `assistencial_snapshot_runtime`, `assistencial_telemetria_runtime`, `assistencial_watchdog_fila` | Checkpoints, circuit breakers, métricas, quorum, telemetria, watchdog. |
| **Guardiões** | `guardiao_acl_runtime`, `guardiao_runtime_final` | Guardiões de ACL e runtime. |
| **Hardening** | `hardening_sp_excecao` | Exceções de hardening. |
| **Schema/Sync** | `schema_patch_execucao`, `operacao_idempotencia`, `sincronizacao_federada_evento`, `ledger_evento_sincronizacao`, `ledger_evento_sincronizacao_local`, `ledger_global_sincronismo` | Patches, idempotência, sincronização federada. |

**Total KERNEL:** ~53 tabelas

---

### PORTAL / DISPLAY / UX
Experiência do usuário, painéis, totens, TVs, contexto visual.

| Entidade | Tabelas | Descrição |
|----------|---------|-----------|
| **Portal** | `portal_categoria`, `portal_noticia` | Notícias e categorias do portal (EXTRA — não no dump). |
| **Painel** | `painel`, `painel_config`, `painel_config_def`, `painel_evento_stream`, `painel_fila_tipo`, `painel_grupo`, `painel_grupo_local`, `painel_lane`, `painel_local`, `painel_mensagem`, `painel_mensagem_consumo`, `painel_alertas_tempo`, `painel_consumo_evento`, `painel_monitoramento_especialidade` | Painéis de chamada, configuração, lanes, grupos, mensagens, alertas. |
| **Totem** | `totem`, `totem_evento`, `totem_feedback`, `totem_senha_opcao` | Totens de autoatendimento. |
| **TV Rotativo** | `tv_rotativo`, `tv_rotativo_tela` | TVs rotativas de informação. |
| **Local/Setor** | `local`, `local_operacional`, `local_fila`, `local_dispositivo`, `local_capacidade`, `local_runtime`, `local_turno`, `setor`, `leito`, `hospital_leitos`, `config_leitos`, `tipo_local`, `tipo_sala`, `sala_notificacao`, `sala_notificacao_evento` | Locais físicos, setores, leitos, capacidade, turnos. |
| **Dispositivo** | `dispositivo`, `dispositivo_tipo` | Dispositivos operacionais. |

**Total PORTAL/DISPLAY:** ~38 tabelas

---

### HEALTHCARE / HIS
Domínio assistencial completo. Senha → Fila → FFA → Atendimento → Triagem → Execução → Farmácia → Faturamento.

| Entidade | Tabelas | Descrição |
|----------|---------|-----------|
| **Paciente** | `paciente`, `paciente_canonico`, `paciente_cns`, `paciente_cns_evento`, `paciente_alertas` | Dados do paciente, CNS, alertas. |
| **Senha/Fila** | `senha`, `senha_eventos`, `senha_sequencia`, `senha_status`, `senha_transicao_matriz`, `fila_operacional`, `fila_operacional_evento`, `fila_painel_runtime`, `fila_retorno`, `fila_senha`, `fila_evento` | Senhas, filas, transições, status. |
| **FFA (Orquestrador)** | `ffa`, `ffa_estado`, `ffa_historico_status`, `ffa_demandas_externas`, `ffa_diagnostico`, `ffa_evolucao`, `ffa_extra`, `ffa_item`, `ffa_prioridade`, `ffa_procedimento`, `ffa_sinais_vitais`, `ffa_substatus`, `ffa_estoque_conciliacao` | Ficha de Atendimento. Documento central do fluxo. |
| **Atendimento** | `atendimento`, `atendimento_anamnese`, `atendimento_balanco_hidrico`, `atendimento_checagem`, `atendimento_desfecho`, `atendimento_diagnostico`, `atendimento_escalas_risco`, `atendimento_estado_ativo`, `atendimento_evento`, `atendimento_evento_ledger`, `atendimento_evolucao`, `atendimento_exame_fisico`, `atendimento_identidade_fluxo`, `atendimento_movimentacao`, `atendimento_observacao`, `atendimento_pedidos_exame`, `atendimento_pre_hospitalar`, `atendimento_prescricao`, `atendimento_profissional`, `atendimento_recepcao`, `atendimento_sinais_vitais`, `atendimento_sumario_alta`, `atendimento_transicao_ledger`, `atendimento_triagem`, `atendimento_vinculo` | Atendimento clínico completo. |
| **Triagem** | `triagem`, `atendimento_triagem` | Classificação Manchester, risco. |
| **Anamnese/Evolução** | `anamnese`, `anotacao_enfermagem`, `evolucao_enfermagem`, `evolucao_medica`, `evolucao_multidisciplinar`, `prontuario_evolucao` | Anamnese, evoluções, anotações. |
| **Exames** | `exame`, `exame_fisico`, `exame_historico`, `exame_pedido`, `exame_pedido_item`, `solicitacao_exame` | Exames físicos, pedidos, solicitações. |
| **Prescrição** | `prescricao`, `prescricao_item`, `prescricao_itens`, `prescricao_medica`, `prescricao_medicacao`, `prescricao_continua`, `prescricao_internacao`, `prescricao_checagem`, `prescricao_checagem_dupla`, `prescricao_kit_master`, `prescricao_kit_itens` | Prescrições, medicações, checagens. |
| **Internação** | `internacao`, `internacao_prescricao`, `internacao_prescricao_item`, `internacao_registro_enfermagem`, `internacao_turno_registro`, `internacao_historico`, `internacao_movimentacao`, `internacao_cuidados`, `internacao_dietas`, `internacao_dispositivos`, `internacao_medicacao_administracao`, `internacao_braden_avaliacao`, `internacao_ferida_avaliacao` | Internação, prescrições, registros, movimentações. |
| **Medicação** | `medicacao_reavaliacao`, `administracao_medicacao`, `administracao_medicacao_ordem`, `dispensacao_medicacao`, `prescricao_medicacao` | Reavaliação, administração, dispensação. |
| **Óbito** | `obito`, `obito_evento` | Registro de óbito. |
| **Notificações** | `notificacao_epidemiologica`, `notificacao_epidemiologica_evento`, `notificacao_violencia`, `notificacao_violencia_evento`, `sinan_notificacao`, `sinan_evento` | Notificações epidemiológicas e de violência. |
| **Transporte** | `transporte_ambulancia`, `transporte_ambulancia_evento` | Transporte de ambulância. |
| **Profissionais** | `medico`, `medico_especialidade`, `enfermagem`, `enfermagem_aprazamento`, `enfermagem_diagnosticos`, `funcionario`, `funcionario_conselho_profissional`, `funcionario_especialidade`, `funcionario_unidade`, `profissional_registro`, `rh_registro_profissional` | Médicos, enfermeiros, funcionários. |
| **Escala/Plantão** | `escala_medica`, `escala_plantao`, `escala_plantao_atual`, `escala_profissional`, `plantao`, `plantao_escala`, `plantao_modelo` | Escalas, plantões, modelos. |
| **Social** | `assistencia_social_atendimento`, `assistencia_social_evento`, `ordem_assistencial`, `ordem_assistencial_item`, `ordem_assistencial_execucao`, `ordem_assistencial_aprazamento`, `ordem_tipo_documento_config`, `prioridade_social` | Assistência social, ordens assistenciais. |
| **Protocolos** | `protocolo_assistencial_global`, `protocolo_emissao`, `protocolo_sequencia`, `procedimento_protocolo`, `procedimento_protocolo_evento`, `procedimento_protocolo_resultado`, `procedimentos_sigtap` | Protocolos, emissões, sequências. |

**Total HIS:** ~200 tabelas

---

### FARMÁCIA
Gestão de medicamentos, dispensação, receitas controladas.

| Entidade | Tabelas | Descrição |
|----------|---------|-----------|
| **Farmácia** | `farm_dispensacao`, `farm_dispensacao_item`, `farm_operacao`, `farm_convenio_autorizacao`, `farm_receita_controlada`, `farm_atendimento_externo` | Dispensação, operações, autorizações, receitas. |
| **Integração Farmacêutica** | `farmacia_atendimento_externo_dispensacao`, `farmacia_atendimento_externo_item`, `farmacia_dispensacao_log`, `farmacia_externo_evento` | Integração externa de farmácia. |

**Total FARMÁCIA:** ~9 tabelas

---

### ESTOQUE / LOGÍSTICA
Gestão de estoque, movimentação, saldos, inventário.

| Entidade | Tabelas | Descrição |
|----------|---------|-----------|
| **Produto/Item** | `estoque_produto`, `estoque_item`, `produto` | Produtos e itens de estoque. |
| **Local/Lote** | `estoque_local`, `estoque_lote`, `estoque_lote_snapshot` | Locais de estoque, lotes. |
| **Saldo** | `estoque_saldo`, `estoque_saldo_central`, `estoque_saldo_master` | Saldos de estoque. |
| **Movimentação** | `estoque_movimentacao`, `estoque_movimentacao_itens`, `estoque_movimento`, `estoque_movimento_item` | Movimentações de entrada/saída. |
| **Inventário** | `estoque_inventario`, `estoque_inventario_item` | Inventários. |
| **Reserva** | `estoque_reserva`, `estoque_reserva_evento` | Reservas. |
| **Execução** | `estoque_execucao`, `estoque_execucao_pipeline`, `estoque_pipeline_estado`, `estoque_documento_execucao`, `estoque_evento_confirmacao` | Pipeline de execução. |
| **Ledger/Auditoria** | `estoque_ledger`, `estoque_audit_stream`, `estoque_conciliacao_atomica` | Ledger, auditoria, conciliação. |
| **Fluxo/Conta** | `estoque_fluxo_assistencial`, `estoque_conta` | Fluxo assistencial, contas. |
| **Código Externo** | `estoque_produto_codigo_externo` | Códigos externos. |
| **Alerta/Consumo** | `estoque_alerta`, `alerta_consumo`, `alerta_destinatario`, `alerta_regra`, `alerta` | Alertas de estoque e consumo. |
| **Almoxarifado** | `almoxarifado_central`, `estoque_almoxarifado_central` | Almoxarifado. |
| **Insumos** | `consumo_insumo`, `consumo_limpeza`, `consumo_manutencao` | Consumo de insumos. |

**Total ESTOQUE:** ~38 tabelas

---

### FATURAMENTO / FINANCEIRO
Faturamento assistencial, PDV, caixa, convênios.

| Entidade | Tabelas | Descrição |
|----------|---------|-----------|
| **Faturamento** | `faturamento_conta`, `faturamento_conta_item`, `faturamento_conta_paciente`, `faturamento_conta_seq`, `faturamento_convenio`, `faturamento_convenios`, `faturamento_codigo`, `faturamento_evento`, `faturamento_insumo`, `faturamento_item`, `faturamento_producao`, `faturamento_producao_sus`, `faturamento_regras_validacao`, `faturamento_sigtap`, `faturamento_sus_config` | Contas, itens, convênios, produção SUS. |
| **PDV/Caixa** | `caixa`, `caixa_evento`, `forma_pagamento`, `venda`, `venda_item`, `venda_pagamento`, `venda_evento`, `pdv_cliente`, `pdv_pagamento`, `pdv_venda`, `pdv_venda_item` | Caixa, vendas, pagamentos. |
| **Repasse** | `financeiro_repasse_medico` | Repasses médicos. |

**Total FINANCEIRO:** ~22 tabelas

---

### LABORATÓRIO
Gestão de exames laboratoriais, amostras, resultados.

| Entidade | Tabelas | Descrição |
|----------|---------|-----------|
| **Laboratório** | `lab_pedido`, `lab_amostra`, `lab_resultado`, `lab_evento`, `lab_protocolo_interno` | Pedidos, amostras, resultados, protocolos. |
| **Protocolo** | `laboratorio_protocolo`, `laboratorio_protocolo_evento` | Protocolos de laboratório. |

**Total LABORATÓRIO:** ~7 tabelas

---

### AUDITORIA / EVENT STORE / LOGS
 Auditoria, logs, eventos, ledger.

| Entidade | Tabelas | Descrição |
|----------|---------|-----------|
| **Auditoria** | `auditoria_acesso`, `auditoria_almoxarifado`, `auditoria_contexto`, `auditoria_erro`, `auditoria_estoque`, `auditoria_estoque_sanitario`, `auditoria_evento`, `auditoria_excecoes`, `auditoria_ffa`, `auditoria_fila`, `auditoria_mestre`, `auditoria_visualizacao_prontuario`, `log_auditoria`, `log_acesso_prontuario`, `log_leitura_prontuario`, `reg_auditoria_acesso_sensivel` | Auditoria de acesso, estoque, eventos, prontuário. |
| **Event Store** | `atendimento_evento`, `atendimento_evento_ledger`, `atendimento_transicao_ledger`, `ffa_evento`, `evento_geral`, `evento_limpeza`, `eventos_fluxo`, `obito_evento`, `observacoes_eventos`, `sala_notificacao_evento`, `workflow_ffa_evento`, `sincronizacao_federada_evento`, `ledger_evento_sincronizacao`, `ledger_evento_sincronizacao_local`, `ledger_global_sincronismo`, `retry_semantico_controle`, `tombstone_evento_assistencial` | Eventos imutáveis, ledger, sincronização. |
| **Logs** | `auth_log`, `login_tentativa`, `usuario_log_acesso`, `auth_audit`, `erro_catalogo`, `erro_evento` | Logs de autenticação, acesso, erros. |

**Total AUDITORIA/EVENT:** ~38 tabelas

---

### INTEGRAÇÃO
Integrações externas, mensageria, webhooks, SINAN.

| Entidade | Tabelas | Descrição |
|----------|---------|-----------|
| **Integração** | `integracao`, `integracao_credencial`, `webhook_entrada`, `webhook_saida`, `integracao_mensageria_externa` | Integrações genéricas, credenciais, webhooks. |
| **SINAN** | `sinan_notificacao`, `sinan_evento` | Notificações SINAN. |

**Total INTEGRAÇÃO:** ~6 tabelas

---

### SOCIAL / WIKI / CHAT
Redes sociais, colaboração, documentação.

| Entidade | Tabelas | Descrição |
|----------|---------|-----------|
| **Social** | `social_perfil`, `social_post`, `social_grupo`, `social_membro` | Perfis, posts, grupos, membros. |

**Total SOCIAL:** ~4 tabelas

---

### RH / ADMINISTRATIVO
Recursos humanos, escalas, plantões, chamados.

| Entidade | Tabelas | Descrição |
|----------|---------|-----------|
| **RH** | `funcionario`, `funcionario_unidade`, `funcionario_especialidade`, `funcionario_conselho_profissional`, `escala_medica`, `escala_plantao`, `escala_plantao_atual`, `escala_profissional`, `plantao`, `plantao_escala`, `plantao_modelo`, `rh_evento`, `rh_pessoa_vinculo`, `rh_registro_profissional` | Funcionários, escalas, plantões, vínculos. |
| **Manutenção** | `chamado`, `chamado_evento`, `chamado_manutencao`, `manutencao_execucao`, `remocao`, `remocao_evento`, `remocao_logistica` | Chamados, manutenções, remoções. |

**Total RH/ADMIN:** ~18 tabelas

---

### CRM / SAC
Relacionamento com cliente, atendimentos externos.

| Entidade | Tabelas | Descrição |
|----------|---------|-----------|
| **CRM** | `cliente`, `contrato`, `cat_evento`, `cat_notificacao`, `cat_regra_item`, `cat_acidente_trabalho`, `cat_acidente_trabalho_evento` | Clientes, contratos, acidentes de trabalho. |

**Total CRM:** ~7 tabelas

---

### DADOS MESTRE / MD
Tabelas de mestrado, catálogos, códigos.

| Entidade | Tabelas | Descrição |
|----------|---------|-----------|
| **Mestrado** | `md_competencia`, `md_cid10`, `md_cnes_estabelecimento`, `md_sigpat_medicamento`, `md_sigtap_procedimento`, `md_arquivo_fonte`, `md_arquivo_fonte_evento` | Competências, CID-10, CNES, SIGPAT, SIGTAP. |
| **SUS** | `sus_competencia`, `sus_cid10_competencia`, `sus_cnes_estabelecimento`, `sus_sigtap_procedimento` | Dados SUS. |
| **Códigos** | `tabela_tuss`, `codigo_universal`, `codigo_externo_map`, `codigo_externo_vinculo`, `codigo_prefixo_config`, `codigo_prefixo_regra` | TUSS, códigos universais, prefixos. |
| **Catálogos** | `exame`, `especialidade`, `conselho_profissional`, `fornecedor`, `produto`, `servico_agendamento` | Exames, especialidades, conselhos. |

**Total MD:** ~22 tabelas

---

### CONFIGURAÇÃO
Configurações do sistema, locais, leitos.

| Entidade | Tabelas | Descrição |
|----------|---------|-----------|
| **Config** | `config_sistema`, `configuracao`, `config_locais`, `config_leitos` | Configurações gerais, sistema, locais, leitos. |

**Total CONFIG:** ~4 tabelas

---

### LOGÍSTICA / TRANSPORTE
Viaturas, remoções, gasoterapia.

| Entidade | Tabelas | Descrição |
|----------|---------|-----------|
| **Transporte** | `viatura`, `remocao`, `remocao_evento`, `remocao_logistica`, `gaso_solicitacao`, `gaso_evento`, `gasoterapia_consumo`, `gasoterapia_consumo_evento` | Viaturas, remoções, gasoterapia. |

**Total LOGÍSTICA:** ~8 tabelas

---

### DOCUMENTOS
Documentos, anexos, assinaturas digitais.

| Entidade | Tabelas | Descrição |
|----------|---------|-----------|
| **Documentos** | `documento_arquivo`, `documento_emissao`, `documento_emissao_evento`, `documento_tipo_config` | Arquivos, emissões, tipos. |
| **Assinaturas** | `assinatura_digital_documentos`, `assinatura_digital_prontuario` | Assinaturas digitais. |
| **Anexos/Export** | `reg_anexo`, `reg_export_arquivo`, `reg_export_item`, `reg_export_lote`, `reg_export_erro_validacao`, `reg_formulario_snapshot`, `pep_registro`, `pep_assinatura_digital` | Anexos, exportação, PEP. |

**Total DOCUMENTOS:** ~13 tabelas

---

### AGENDAMENTO
Agendamentos de consultas e procedimentos.

| Entidade | Tabelas | Descrição |
|----------|---------|-----------|
| **Agendamento** | `agendamento`, `agenda_disponibilidade`, `agendamentos_eventos`, `servico_agendamento` | Agendamentos, disponibilidade, serviços. |

**Total AGENDAMENTO:** ~4 tabelas

---

## RESUMO POR DOMÍNIO

| Domínio | Quantidade | % |
|---------|------------|---|
| CORE/IDENTIDADE/MULTI-TENANT | 47 | 9,8% |
| KERNEL/RUNTIME | 53 | 11,1% |
| PORTAL/DISPLAY | 38 | 7,9% |
| HIS/HEALTHCARE | 200 | 41,8% |
| FARMÁCIA | 9 | 1,9% |
| ESTOQUE | 38 | 7,9% |
| FATURAMENTO/FINANCEIRO | 22 | 4,6% |
| LABORATÓRIO | 7 | 1,5% |
| AUDITORIA/EVENT STORE | 38 | 7,9% |
| INTEGRAÇÃO | 6 | 1,3% |
| SOCIAL/WIKI/CHAT | 4 | 0,8% |
| RH/ADMINISTRATIVO | 18 | 3,8% |
| CRM/SAC | 7 | 1,5% |
| DADOS MESTRE/MD | 22 | 4,6% |
| CONFIGURAÇÃO | 4 | 0,8% |
| LOGÍSTICA/TRANSPORTE | 8 | 1,7% |
| DOCUMENTOS | 13 | 2,7% |
| AGENDAMENTO | 4 | 0,8% |
| **TOTAL** | **478** | **100%** |

---

## FLUXO PRINCIPAL (LEI CANÔNICA)

```text
Pessoa (raiz)
    ↓
Usuario + Auth (IAM)
    ↓
Tenant + Entidade (SaaS)
    ↓
Contexto (Unidade + Local)
    ↓
Senha → FFA → Atendimento
    ↓
Triagem → Prescrição → Internação
    ↓
Medicação → Farmácia → Estoque
    ↓
Exames → Laboratório
    ↓
Faturamento → Financeiro
    ↓
Eventos → Auditoria → Ledger
```

---

**Arquivo:** docs/database/CATALOGO_ENTIDADES_CORE.md  
**Status:** Consolidado  
**Próximo:** Mapa de Consumo por Módulo + Mapa de Escrita.

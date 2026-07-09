# DOMAINS.md — Decomposição de Domínios

> Seed 2026-07-09. Domínios derivados da lista de tabelas do dump. Toda tabela do `TABLES.md`
> pertence a exatamente um domínio. Usado por `CALL-GRAPH.md` e `PROCEDURES.md`.

## 1. IAM (Identidade, Acesso e Sessão)

Núcleo de autenticação, autorização, sessão e vínculos de usuário.

```text
usuario, usuario_alocacao, usuario_contexto, usuario_historico_senha, usuario_local,
usuario_log_acesso, usuario_perfil, usuario_profissional_registro, usuario_refresh,
usuario_refresh_token, usuario_reset_senha, usuario_sala, usuario_senha_historico,
usuario_senha_reset, usuario_setor, usuario_sistema, usuario_sistema_acl_evento,
usuario_unidade, perfil, perfil_permissao, permissao, sessao_usuario, sessao_ativa,
sessao_contexto_historico, sessao_evento, auth_*, login_tentativa
```

## 2. Portal Enterprise (Experiência SaaS)

Catálogo, painéis, totens, TV rotativa, tenant.

```text
portal_categoria, sistema, saas_entidade, saas_contrato, tenant_registry,
painel, painel_config, painel_config_def, painel_lane, painel_local, painel_grupo,
painel_grupo_local, painel_mensagem, painel_mensagem_consumo, painel_evento_stream,
painel_alertas_tempo, painel_consumo_evento, painel_fila_tipo, painel_monitoramento_especialidade,
totem, totem_evento, totem_feedback, totem_senha_opcao, tv_rotativo, tv_rotativo_tela
```

## 3. Fila e Senha (Queue)

Senhas, filas operacionais, painel de fila.

```text
senha, senha_eventos, senha_sequencia, senha_status, senha_transicao_matriz,
fila_operacional, fila_operacional_evento, fila_evento, fila_retorno, fila_painel_runtime,
local_fila, painel_fila_tipo, totem_senha_opcao
```

## 4. Kernel / Runtime (Núcleo de Execução)

Orquestração, guardião, ledger, locks, runtime federado.

```text
runtime_execution_queue, runtime_api_session_token, runtime_concurrency_guard, runtime_contexto,
runtime_dispositivo, runtime_edge_evento, runtime_estado_sobrevivencia, runtime_evento_provisional,
runtime_invariant_log, runtime_kernel_locks, runtime_lock_semantico, runtime_snapshot_governanca,
runtime_snapshot_metadata, runtime_sync_log, runtime_sync_queue,
kernel_authz_policy, kernel_identity_trust_chain, kernel_ledger, kernel_runtime_evento,
kernel_runtime_heartbeat, kernel_runtime_single_writer_lock, kernel_single_writer_lock,
guardiao_acl_runtime, guardiao_runtime_final, coordenador_estado_global,
fluxo_orquestrador_canonico, fluxo_status, fluxo_transicao, fluxo_transicao_matriz,
regra_timeout, status_timeout, operacao_idempotencia, retry_semantico_controle,
sincronizacao_federada_evento, ledger_evento_sincronizacao, ledger_evento_sincronizacao_local,
ledger_global_sincronismo, hardening_sp_excecao
```

## 5. Assistencial (Clínico)

Atendimento, triagem, evolução, prescrição, internação, enfermagem, etc.

```text
atendimento*, anamnese, triagem, classificacao_risco, evolucao_*, prescricao*, internacao*,
enfermagem*, ordem_assistencial*, contexto_atendimento, hipotese_diagnostica, interconsulta,
intercorrencia, obito, remocao*, retorno_atendimento, reabertura_atendimento, transporte_ambulancia*,
viatura, agendamento, agenda_disponibilidade, servico_agendamento, agendamentos_eventos,
administracao_medicacao*, assistencia_social_*, nucleo_governanca_assistencial,
assistencial_* (runtime/metrics/quorum/watchdog), protocolo_assistencial_global,
procedimento_protocolo*, produtividade_evento, observacoes_eventos, paciente_vinculo
```

## 6. Farmácia e FFA

Dispensação, GPAT, FFA, fármacos.

```text
farm_*, ffa*, gpat*, dispensacao_medicacao, farmaco_*, evento_ffa, workflow_ffa_evento,
auditoria_ffa, auditoria_farma*
```

## 7. Estoque

Almoxarifado, movimentação, saldos, lotes.

```text
estoque_*, almoxarifado_central, estoque_almoxarifado_central, produto, alerta_consumo,
consumo_insumo, auditoria_estoque*, auditoria_almoxarifado
```

## 8. Faturamento

Contas, convênios, produção, SIGTAP/SUS.

```text
faturamento_*, caixa, caixa_evento, financeiro_repasse_medico, forma_pagamento, fornecedor
```

## 9. Laboratório

Exames, amostras, resultados, protocolos.

```text
lab_*, exame, exame_fisico, exame_historico, exame_pedido, exame_pedido_item,
solicitacao_exame, laboratorio_protocolo*
```

## 10. Pessoas (Paciente / Profissional)

```text
pessoa*, paciente*, paciente_canonico, paciente_cns*, medico, medico_especialidade,
funcionario*, conselho_profissional, especialidade, prescritor_externo, cliente,
rh_*, profissional_registro
```

## 11. Auditoria e Log

```text
auditoria_*, auth_audit, auth_log, log_auditoria, log_acesso_prontuario, log_leitura_prontuario,
erro_catalogo, erro_evento, reg_*, schema_patch_execucao, kernel_ledger
```

## 12. Documentos e PEP

```text
documento_*, pep_*, assinatura_digital_*, ordem_tipo_documento_config, prontuario_evolucao,
protocolo_emissao, protocolo_sequencia, reg_formulario_snapshot
```

## 13. Infraestrutura

```text
unidade, local, leito, setor, sala_*, tipo_local, tipo_sala, dispositivo*, hospital_leitos,
config_leitos, config_locais, config_sistema, configuracao, cidade, logradouro,
pessoa_logradouro, local_capacidade, local_dispositivo, local_turno, local_runtime,
integração_mensageria_externa
```

## 14. Qualidade e Regulação

```text
qualidade_eventos_adversos, regulacao_evento, notificacao_epidemiologica*, notificacao_violencia*,
sinan_*, cat_*, prioridade_social, chamado* (manutenção)
```

## 15. Financeiro e PDV

```text
pdv_*, venda*, caixa, caixa_evento, forma_pagamento, fornecedor, financeiro_repasse_medico
```

## 16. Workflow e Eventos

```text
workflow_ffa_evento, evento_geral, eventos_fluxo, chamado*, chamado_evento, chamado_manutencao,
manutencao_execucao, *evento (tabelas de evento por domínio)
```

## 17. Tabelas de Referência (MD / SIGTAP / TUSS / CNES)

```text
md_*, codigo_*, sus_*, tabela_tuss, sigpat_procedimento, procedimentos_sigtap
```

# DATABASE BRAIN — FCA/MIDAS Enterprise

## Generated: 2026-07-05T02:04:56.064Z

## Estatísticas

| Tipo | Count |
|------|-------|
| Tabelas | 478 |
| Procedures | 25 |
| FKs | 563 |
| Tables com FK | 283 |
| Órfãos | 195 |

## Domains Distribution

{
  "Core": 54,
  "Runtime": 70,
  "Agendamento": 3,
  "Operational": 15,
  "Documents": 6,
  "Social": 2,
  "HIS": 85,
  "Runtime/Auditoria": 12,
  "IAM/Auth": 12,
  "Financeiro": 3,
  "Config": 9,
  "SAC": 4,
  "Core/Business": 3,
  "Workforce": 10,
  "Workforce/Operational": 10,
  "HIS/Farmacia": 9,
  "Unknown": 121,
  "HIS/Enfermagem": 3,
  "Diagnostics": 9,
  "Integration": 1,
  "Epidemiologia": 6,
  "Displays": 16,
  "IAM": 3,
  "Compliance": 7,
  "Regulacao": 1,
  "Regulacao/SUS": 4
}

## Procedures

- sp_executor_manchester_runtime
- sp_executor_recepcao_abrir_atendimento
- sp_farmacia_dispensar_registrar
- sp_farm_dispensacao_criar
- sp_farm_dispensacao_registrar
- sp_farm_reserva_confirmar
- sp_ffa_adicionar_item
- sp_ffa_gpat_garantir
- sp_ffa_gpat_gerar
- sp_ffa_orquestrador_transicao
- sp_fila_chamar_proxima
- sp_fila_finalizar
- sp_fila_tipo_por_local
- sp_finalizar_procedimento_ecg
- sp_finalizar_procedimento_geral
- sp_finalizar_procedimento_laboratorio
- sp_finalizar_senha
- sp_fix_columns_entidade
- sp_fix_fk_unidade
- sp_fluxo_estoque
- sp_fluxo_executor_matriz
- sp_fluxo_guardiao_transicao
- sp_fluxo_verificar_autorizacao
- sp_gatekeeper_assistencial
- sp_gera_protocolo_lab

## Foreign Keys (sample)

- acompanhante → pessoa
- administracao_medicacao → prescricao_internacao
- administracao_medicacao → usuario
- administracao_medicacao_ordem → ordem_assistencial_item
- administracao_medicacao_ordem → usuario
- agendamento → paciente
- agendamento → usuario
- agendamento → servico_agendamento
- agendamento → sistema
- agendamento → saas_entidade
- agendamento → ffa
- agendamento → senha
- agendamento → unidade
- agendamentos_eventos → agendamentos
- agendamentos_eventos → sessao_usuario
- agendamentos_eventos → usuario
- agenda_disponibilidade → local_operacional
- agenda_disponibilidade → usuario
- agenda_disponibilidade → sessao_usuario
- agenda_disponibilidade → sistema

## Órfãos

almoxarifado_central
assinatura_digital_documentos
assistencial_circuit_breaker
assistencial_evento_hash
assistencial_minipal_metric
assistencial_quorum_clinico
assistencial_raim_metric
auditoria_estoque
auditoria_estoque_sanitario
auditoria_evento
auditoria_excecoes
auditoria_ffa
auditoria_visualizacao_prontuario
auth_audit
auth_grupo
auth_log
auth_parametro
auth_tentativa_login
caixa_evento
cat_evento

# PROJECT BRAIN — FCA/MIDAS Enterprise
## Generated: 2026-07-05T02:02:56.412Z
# CANONICAL INDEX

## MDs
- MD-001 -> Pessoa/Identity
- MD-002 -> IAM/Auth
- MD-011 -> ???

## BRs
- BR-001 -> Entrada do Paciente
- BR-002 -> FFA Cycle
- BR-003 -> Farmácia

## FRONTs
- FRONT-001 -> Portal
- FRONT-002 -> Fila
- FRONT-003 -> Atendimento

## MAPs
- MAP-001 -> HIS
- MAP-002 -> IAM

---

*Índice canônico do sistema*

---

# TABLE → DOMAIN → MD MAPPING

## Fluxo Canônico
```
478 tabelas (dump)
   ↓
KILO descobre domínio
   ↓
KILO encontra MD correspondente
   ↓
KILO gera/atualiza documento
```

## Domínios Detectados no Dump

| Domínio | Tabelas | MD Number | Status |
|---------|---------|-----------|--------|
| ASSISTENCIAL | senha, ffa, atendimento, triagem, ... | MD-105 | 🟢 EXISTS |
| FARMACIA | farm_dispensacao, estoque_*, ... | MD-141 | 🟢 EXISTS |
| IAM | usuario, sessao_usuario, perfil | MD-34 | 🟢 EXISTS |
| DISPLAY | painel, tv_rotativo, totem | MD-125 | 🟢 EXISTS |
| FATURAMENTO | faturamento_*, gpat | MD-117 | 🟢 EXISTS |
| AGENDAMENTO | agenda_*, agenda_unidade | MD-XXX | 🟡 MISSING |
| INTERNACAO | internacao_*, leito, ... | MD-117 | 🟢 EXISTS |
| SAC | chamado_*, chamado_evento | MD-XXX | 🟡 MISSING |
| REGULACAO | regulacao_*, regulacao_evento | MD-XXX | 🟡 MISSING |

## Contagem
- Total tabelas: 478
- Domínios identificados: 17
- Tabelas mapeadas por domínio:
  - Core: 54
  - HIS: 85
  - Runtime: 70
  - IAM/Auth: 12
  - Agendamento: 3
  - SAC: 4
  - Regulacao: 1 + 4 (SUS)
  - Workforce: 10 + 10
  - Displays: 16
  - Diagnostics: 9
  - Unknown: 121
- FKs extraídas: 563
- Relationships mapeadas: 28

---

# CANONICAL MAPPING INDEX

## 📊 Matriz de Rastreabilidade

| Domínio | Tabelas | Procedures | MD | BR | FRONT | MAP | Contracts | Status |
|---------|---------|------------|-----|-----|-------|-----|-----------|--------|
| Core    | 36      |            |     |     |       |     |           |        |
| IAM     | 3       |            |     |     |       |     |           |        |
| HIS     | 67      |            |     |     |       |     |           |        |
| Displays|         |            |     |     |       |     |           |        |
| Workforce| 5      |            |     |     |       |     |           |        |
| BI      |         |            |     |     |       |     |           |        |
| Integration| 1    |            |     |     |       |     |           |        |
| Suporte |         |            |     |     |       |     |           |        |
| Agendamento| 3     |            |     |     |       |     |           |        |
| SAC     | 4       |            |     |     |       |     |           |        |
| Regulacao| 1      |            |     |     |       |     |           |        |
| Unknown | 358     |            |     |     |       |     |           |        |

---

## 🗂 DOMÍNIO → OBJETOS

### Core (36 tabelas)
- **Tabelas**: pessoa, usuario, tenant_registry, saas_entidade, etc.
- **Procedures**: sp_gera_protocolo_lab
- **MD**: MD-001 (pendente)

### IAM (3 tabelas)
- **Tabelas**: perfil, perfil_usuario, permissao, papel, grupo
- **MD**: MD-002 (pendente)

### HIS (67 tabelas)
- **Tabelas**: senha, fila, ffa, atendimento, triagem, totem
- **Procedures**: sp_finalizar_senha, sp_fila_*, sp_ffa_*, sp_executor_*
- **MD**: MD-021 (pendente)

### Agendamento (3 tabelas)
- **Tabelas**: agenda_disponibilidade, agendamento, agendamentos_eventos
- **MD**: (faltando)

### SAC (4 tabelas)
- **Tabelas**: ticket_sac, chamado, atendimento_sac
- **MD**: (faltando)

### Regulacao (1 tabela)
- **Tabelas**: regulacao, transferencia
- **MD**: (faltando)

---

# ORPHAN ANALYSIS

## 📊 Status

| Status | Count | % |
|--------|-------|-----|
| Com FK | 283 | 59% |
| Órfãos | 195 | 41% |
| Total | 478 | 100% |

## 🔗 Principais Relacionamentos

| De → Para | Count | Criticidade |
|-----------|-------|-------------|
| HIS → HIS | 68 | Crítica |
| Unknown → Unknown | 53 | Alta |
| Runtime → HIS | 12 | Alta |
| Runtime → Core | 16 | Alta |
| Unknown → Core | 38 | Média |

## 🚨 Órfãos por Domínio

| Domínio | Órfãos | Ação |
|---------|--------|------|
| Unknown | ~120 | Reclassificar |
| HIS/Farmacia | ~10 | Verificar FKs faltantes |
| SAC | ~2 | Verificar FKs faltantes |

## 📋 Próximo

1. Reclassificar Unknown
2. Validar FKs manualmente
3. Gerar workflow-graph

---

# MD-acompanhante — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: acompanhante
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-agendamento — Agendamento

## DOMAIN OVERVIEW
Domain: Agendamento

## CANONICAL ENTITIES

### TABLE: agendamento
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-agendamentos_eventos — Agendamento

## DOMAIN OVERVIEW
Domain: Agendamento

## CANONICAL ENTITIES

### TABLE: agendamentos_eventos
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-agenda_disponibilidade — Agendamento

## DOMAIN OVERVIEW
Domain: Agendamento

## CANONICAL ENTITIES

### TABLE: agenda_disponibilidade
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-atendimento — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: atendimento
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-atendimento_anamnese — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: atendimento_anamnese
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-atendimento_balanco_hidrico — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: atendimento_balanco_hidrico
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-atendimento_checagem — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: atendimento_checagem
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-atendimento_desfecho — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: atendimento_desfecho
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-atendimento_diagnostico — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: atendimento_diagnostico
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-atendimento_escalas_risco — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: atendimento_escalas_risco
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-atendimento_estado_ativo — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: atendimento_estado_ativo
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-atendimento_evento — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: atendimento_evento
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-atendimento_evento_ledger — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: atendimento_evento_ledger
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-atendimento_evolucao — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: atendimento_evolucao
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-atendimento_exame_fisico — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: atendimento_exame_fisico
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-atendimento_identidade_fluxo — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: atendimento_identidade_fluxo
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-atendimento_movimentacao — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: atendimento_movimentacao
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-atendimento_observacao — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: atendimento_observacao
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-atendimento_pedidos_exame — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: atendimento_pedidos_exame
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-atendimento_prescricao — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: atendimento_prescricao
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-atendimento_pre_hospitalar — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: atendimento_pre_hospitalar
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-atendimento_profissional — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: atendimento_profissional
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-atendimento_recepcao — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: atendimento_recepcao
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-atendimento_sinais_vitais — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: atendimento_sinais_vitais
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-atendimento_sumario_alta — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: atendimento_sumario_alta
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-atendimento_transicao_ledger — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: atendimento_transicao_ledger
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-atendimento_triagem — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: atendimento_triagem
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-atendimento_vinculo — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: atendimento_vinculo
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-auth_audit — IAM/Auth

## DOMAIN OVERVIEW
Domain: IAM/Auth

## CANONICAL ENTITIES

### TABLE: auth_audit
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-auth_bloqueio — IAM/Auth

## DOMAIN OVERVIEW
Domain: IAM/Auth

## CANONICAL ENTITIES

### TABLE: auth_bloqueio
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-auth_grupo — IAM/Auth

## DOMAIN OVERVIEW
Domain: IAM/Auth

## CANONICAL ENTITIES

### TABLE: auth_grupo
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-auth_grupo_permissao — IAM/Auth

## DOMAIN OVERVIEW
Domain: IAM/Auth

## CANONICAL ENTITIES

### TABLE: auth_grupo_permissao
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-auth_grupo_usuario — IAM/Auth

## DOMAIN OVERVIEW
Domain: IAM/Auth

## CANONICAL ENTITIES

### TABLE: auth_grupo_usuario
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-auth_log — IAM/Auth

## DOMAIN OVERVIEW
Domain: IAM/Auth

## CANONICAL ENTITIES

### TABLE: auth_log
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-auth_notificacao — IAM/Auth

## DOMAIN OVERVIEW
Domain: IAM/Auth

## CANONICAL ENTITIES

### TABLE: auth_notificacao
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-auth_parametro — IAM/Auth

## DOMAIN OVERVIEW
Domain: IAM/Auth

## CANONICAL ENTITIES

### TABLE: auth_parametro
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-auth_sessao — IAM/Auth

## DOMAIN OVERVIEW
Domain: IAM/Auth

## CANONICAL ENTITIES

### TABLE: auth_sessao
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-auth_sessao_dispositivo — IAM/Auth

## DOMAIN OVERVIEW
Domain: IAM/Auth

## CANONICAL ENTITIES

### TABLE: auth_sessao_dispositivo
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-auth_tentativa_login — IAM/Auth

## DOMAIN OVERVIEW
Domain: IAM/Auth

## CANONICAL ENTITIES

### TABLE: auth_tentativa_login
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-auth_token — IAM/Auth

## DOMAIN OVERVIEW
Domain: IAM/Auth

## CANONICAL ENTITIES

### TABLE: auth_token
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-chamado — SAC

## DOMAIN OVERVIEW
Domain: SAC

## CANONICAL ENTITIES

### TABLE: chamado
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-chamado_evento — SAC

## DOMAIN OVERVIEW
Domain: SAC

## CANONICAL ENTITIES

### TABLE: chamado_evento
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-chamado_manutencao — SAC

## DOMAIN OVERVIEW
Domain: SAC

## CANONICAL ENTITIES

### TABLE: chamado_manutencao
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-cidade — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: cidade
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-classificacao_risco — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: classificacao_risco
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-codigo_externo_map — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: codigo_externo_map
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-codigo_externo_vinculo — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: codigo_externo_vinculo
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-codigo_prefixo_config — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: codigo_prefixo_config
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-codigo_prefixo_regra — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: codigo_prefixo_regra
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-codigo_universal — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: codigo_universal
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-conselho_profissional — Workforce

## DOMAIN OVERVIEW
Domain: Workforce

## CANONICAL ENTITIES

### TABLE: conselho_profissional
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-contexto_atendimento — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: contexto_atendimento
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-especialidade — Workforce

## DOMAIN OVERVIEW
Domain: Workforce

## CANONICAL ENTITIES

### TABLE: especialidade
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-evolucao_enfermagem — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: evolucao_enfermagem
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-evolucao_medica — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: evolucao_medica
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-evolucao_multidisciplinar — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: evolucao_multidisciplinar
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-ffa — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: ffa
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-ffa_demandas_externas — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: ffa_demandas_externas
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-ffa_diagnostico — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: ffa_diagnostico
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-ffa_estado — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: ffa_estado
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-ffa_estoque_conciliacao — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: ffa_estoque_conciliacao
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-ffa_evolucao — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: ffa_evolucao
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-ffa_extra — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: ffa_extra
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-ffa_historico_status — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: ffa_historico_status
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-ffa_item — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: ffa_item
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-ffa_prioridade — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: ffa_prioridade
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-ffa_procedimento — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: ffa_procedimento
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-ffa_sinais_vitais — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: ffa_sinais_vitais
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-ffa_substatus — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: ffa_substatus
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-fila_evento — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: fila_evento
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-fila_operacional — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: fila_operacional
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-fila_operacional_evento — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: fila_operacional_evento
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-fila_painel_runtime — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: fila_painel_runtime
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-fila_retorno — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: fila_retorno
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-fila_senha — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: fila_senha
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-funcionario — Workforce

## DOMAIN OVERVIEW
Domain: Workforce

## CANONICAL ENTITIES

### TABLE: funcionario
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-funcionario_conselho_profissional — Workforce

## DOMAIN OVERVIEW
Domain: Workforce

## CANONICAL ENTITIES

### TABLE: funcionario_conselho_profissional
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-funcionario_especialidade — Workforce

## DOMAIN OVERVIEW
Domain: Workforce

## CANONICAL ENTITIES

### TABLE: funcionario_especialidade
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-funcionario_unidade — Workforce

## DOMAIN OVERVIEW
Domain: Workforce

## CANONICAL ENTITIES

### TABLE: funcionario_unidade
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-internacao — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: internacao
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-internacao_braden_avaliacao — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: internacao_braden_avaliacao
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-internacao_cuidados — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: internacao_cuidados
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-internacao_dietas — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: internacao_dietas
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-internacao_dispositivos — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: internacao_dispositivos
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-internacao_ferida_avaliacao — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: internacao_ferida_avaliacao
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-internacao_historico — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: internacao_historico
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-internacao_medicacao_administracao — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: internacao_medicacao_administracao
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-internacao_movimentacao — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: internacao_movimentacao
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-internacao_prescricao — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: internacao_prescricao
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-internacao_prescricao_item — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: internacao_prescricao_item
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-internacao_registro_enfermagem — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: internacao_registro_enfermagem
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-internacao_turno_registro — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: internacao_turno_registro
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-local — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: local
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-local_capacidade — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: local_capacidade
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-local_dispositivo — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: local_dispositivo
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-local_fila — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: local_fila
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-local_runtime — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: local_runtime
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-local_turno — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: local_turno
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-logradouro — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: logradouro
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-painel — Displays

## DOMAIN OVERVIEW
Domain: Displays

## CANONICAL ENTITIES

### TABLE: painel
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-painel_alertas_tempo — Displays

## DOMAIN OVERVIEW
Domain: Displays

## CANONICAL ENTITIES

### TABLE: painel_alertas_tempo
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-painel_config — Displays

## DOMAIN OVERVIEW
Domain: Displays

## CANONICAL ENTITIES

### TABLE: painel_config
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-painel_config_def — Displays

## DOMAIN OVERVIEW
Domain: Displays

## CANONICAL ENTITIES

### TABLE: painel_config_def
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-painel_consumo_evento — Displays

## DOMAIN OVERVIEW
Domain: Displays

## CANONICAL ENTITIES

### TABLE: painel_consumo_evento
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-painel_evento_stream — Displays

## DOMAIN OVERVIEW
Domain: Displays

## CANONICAL ENTITIES

### TABLE: painel_evento_stream
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-painel_fila_tipo — Displays

## DOMAIN OVERVIEW
Domain: Displays

## CANONICAL ENTITIES

### TABLE: painel_fila_tipo
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-painel_grupo — Displays

## DOMAIN OVERVIEW
Domain: Displays

## CANONICAL ENTITIES

### TABLE: painel_grupo
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-painel_grupo_local — Displays

## DOMAIN OVERVIEW
Domain: Displays

## CANONICAL ENTITIES

### TABLE: painel_grupo_local
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-painel_lane — Displays

## DOMAIN OVERVIEW
Domain: Displays

## CANONICAL ENTITIES

### TABLE: painel_lane
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-painel_local — Displays

## DOMAIN OVERVIEW
Domain: Displays

## CANONICAL ENTITIES

### TABLE: painel_local
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-painel_mensagem — Displays

## DOMAIN OVERVIEW
Domain: Displays

## CANONICAL ENTITIES

### TABLE: painel_mensagem
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-painel_mensagem_consumo — Displays

## DOMAIN OVERVIEW
Domain: Displays

## CANONICAL ENTITIES

### TABLE: painel_mensagem_consumo
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-painel_monitoramento_especialidade — Displays

## DOMAIN OVERVIEW
Domain: Displays

## CANONICAL ENTITIES

### TABLE: painel_monitoramento_especialidade
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-pessoa — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: pessoa
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-pessoa_alergias — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: pessoa_alergias
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-pessoa_conselho_registro — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: pessoa_conselho_registro
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-pessoa_contato — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: pessoa_contato
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-pessoa_documento — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: pessoa_documento
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-pessoa_email — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: pessoa_email
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-pessoa_endereco — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: pessoa_endereco
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-pessoa_identificador — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: pessoa_identificador
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-pessoa_logradouro — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: pessoa_logradouro
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-pessoa_telefone — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: pessoa_telefone
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-pessoa_vinculo — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: pessoa_vinculo
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-prescricao — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: prescricao
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-prescricao_checagem — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: prescricao_checagem
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-prescricao_checagem_dupla — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: prescricao_checagem_dupla
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-prescricao_continua — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: prescricao_continua
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-prescricao_internacao — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: prescricao_internacao
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-prescricao_item — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: prescricao_item
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-prescricao_itens — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: prescricao_itens
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-prescricao_kit_itens — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: prescricao_kit_itens
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-prescricao_kit_master — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: prescricao_kit_master
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-prescricao_medica — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: prescricao_medica
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-prescricao_medicacao — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: prescricao_medicacao
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-profissional_registro — Workforce

## DOMAIN OVERVIEW
Domain: Workforce

## CANONICAL ENTITIES

### TABLE: profissional_registro
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-prontuario_evolucao — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: prontuario_evolucao
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-reabertura_atendimento — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: reabertura_atendimento
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-regulacao_evento — Regulacao

## DOMAIN OVERVIEW
Domain: Regulacao

## CANONICAL ENTITIES

### TABLE: regulacao_evento
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-retorno_atendimento — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: retorno_atendimento
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-rh_evento — Workforce

## DOMAIN OVERVIEW
Domain: Workforce

## CANONICAL ENTITIES

### TABLE: rh_evento
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-rh_pessoa_vinculo — Workforce

## DOMAIN OVERVIEW
Domain: Workforce

## CANONICAL ENTITIES

### TABLE: rh_pessoa_vinculo
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-rh_registro_profissional — Workforce

## DOMAIN OVERVIEW
Domain: Workforce

## CANONICAL ENTITIES

### TABLE: rh_registro_profissional
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-senha — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: senha
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-senha_eventos — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: senha_eventos
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-senha_sequencia — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: senha_sequencia
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-senha_status — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: senha_status
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-senha_transicao_matriz — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: senha_transicao_matriz
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-sessao_ativa — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: sessao_ativa
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-sessao_contexto_historico — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: sessao_contexto_historico
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-sessao_evento — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: sessao_evento
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-sessao_usuario — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: sessao_usuario
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-setor — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: setor
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-solicitacao_exame — SAC

## DOMAIN OVERVIEW
Domain: SAC

## CANONICAL ENTITIES

### TABLE: solicitacao_exame
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-tenant_registry — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: tenant_registry
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-tipo_local — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: tipo_local
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-tipo_sala — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: tipo_sala
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-totem — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: totem
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-totem_evento — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: totem_evento
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-totem_feedback — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: totem_feedback
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-totem_senha_opcao — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: totem_senha_opcao
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-triagem — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: triagem
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-tv_rotativo — Displays

## DOMAIN OVERVIEW
Domain: Displays

## CANONICAL ENTITIES

### TABLE: tv_rotativo
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-tv_rotativo_tela — Displays

## DOMAIN OVERVIEW
Domain: Displays

## CANONICAL ENTITIES

### TABLE: tv_rotativo_tela
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-unidade — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: unidade
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-usuario — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: usuario
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-usuario_alocacao — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: usuario_alocacao
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-usuario_contexto — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: usuario_contexto
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-usuario_historico_senha — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: usuario_historico_senha
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-usuario_local — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: usuario_local
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-usuario_log_acesso — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: usuario_log_acesso
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-usuario_perfil — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: usuario_perfil
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-usuario_profissional_registro — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: usuario_profissional_registro
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-usuario_refresh — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: usuario_refresh
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-usuario_refresh_token — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: usuario_refresh_token
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-usuario_reset_senha — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: usuario_reset_senha
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-usuario_sala — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: usuario_sala
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-usuario_senha_historico — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: usuario_senha_historico
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-usuario_senha_reset — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: usuario_senha_reset
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-usuario_setor — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: usuario_setor
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-usuario_sistema — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: usuario_sistema
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-usuario_sistema_acl_evento — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: usuario_sistema_acl_evento
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-usuario_unidade — Core

## DOMAIN OVERVIEW
Domain: Core

## CANONICAL ENTITIES

### TABLE: usuario_unidade
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---

# MD-workflow_ffa_evento — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: workflow_ffa_evento
- Source: dump auto-generated
- Status: DISCOVERED

## RELATED
TBD


---


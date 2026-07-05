# MD-atendimento — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: atendimento
- Type: CORE
- Domain: HIS
- Source: dump auto-generated
- Status: COMPLETE

## BUSINESS FLOW
Derived from dump:
- FK relationships: anamnese, assistencial_checkpoint_global, assistencial_runtime_federado, assistencial_runtime_panel, assistencial_simulacao_futura

## SP MAP
Related procedures: sp_executor_recepcao_abrir_atendimento, sp_ffa_orquestrador_transicao

## EVENT MODEL
Event tables: Check manually

## RULES
TBD - Derived from procedures

## DEPENDENCIES
- References: 62 tabelas
- Procedures: 2 SPs

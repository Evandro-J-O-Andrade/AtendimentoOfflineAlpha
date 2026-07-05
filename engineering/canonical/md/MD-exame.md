# MD-exame — Diagnostics

## DOMAIN OVERVIEW
Domain: Diagnostics

## CANONICAL ENTITIES

### TABLE: exame
- Type: CORE
- Domain: Diagnostics
- Source: dump auto-generated
- Status: DISCOVERED

## BUSINESS FLOW
Derived from dump:
- FK relationships: solicitacao_exame

## SP MAP
Related procedures: sp_fila_tipo_por_local, sp_finalizar_procedimento_geral, sp_finalizar_procedimento_laboratorio, sp_gera_protocolo_lab

## EVENT MODEL
Event tables: Check manually

## RULES
TBD - Derived from procedures

## DEPENDENCIES
- References: 1 tabelas
- Procedures: 4 SPs

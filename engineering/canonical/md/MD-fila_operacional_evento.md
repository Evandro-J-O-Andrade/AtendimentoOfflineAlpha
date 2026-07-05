# MD-fila_operacional_evento — HIS

## DOMAIN OVERVIEW
Domain: HIS

## CANONICAL ENTITIES

### TABLE: fila_operacional_evento
- Type: CORE
- Domain: HIS
- Source: dump auto-generated
- Status: COMPLETE

## BUSINESS FLOW
Derived from dump:
- FK relationships: fila_operacional, sessao_usuario

## SP MAP
Related procedures: sp_fila_chamar_proxima, sp_fila_finalizar, sp_finalizar_procedimento_geral

## EVENT MODEL
Event tables: Yes

## RULES
TBD - Derived from procedures

## DEPENDENCIES
- References: 2 tabelas
- Procedures: 3 SPs

# MD-estoque_reserva — Runtime

## DOMAIN OVERVIEW
Domain: Runtime

## CANONICAL ENTITIES

### TABLE: estoque_reserva
- Type: CORE
- Domain: Runtime
- Source: dump auto-generated
- Status: DISCOVERED

## BUSINESS FLOW
Derived from dump:
- FK relationships: estoque_local, estoque_lote, estoque_produto, estoque_reserva_evento

## SP MAP
Related procedures: sp_farm_dispensacao_registrar, sp_farm_reserva_confirmar

## EVENT MODEL
Event tables: Check manually

## RULES
TBD - Derived from procedures

## DEPENDENCIES
- References: 4 tabelas
- Procedures: 2 SPs

# MD-estoque_lote — Runtime

## DOMAIN OVERVIEW
Domain: Runtime

## CANONICAL ENTITIES

### TABLE: estoque_lote
- Type: CORE
- Domain: Runtime
- Source: dump auto-generated
- Status: DISCOVERED

## BUSINESS FLOW
Derived from dump:
- FK relationships: estoque_item, estoque_lote_snapshot, estoque_movimento, estoque_reserva, estoque_saldo_central

## SP MAP
Related procedures: sp_farmacia_dispensar_registrar, sp_farm_dispensacao_registrar, sp_farm_reserva_confirmar

## EVENT MODEL
Event tables: Check manually

## RULES
TBD - Derived from procedures

## DEPENDENCIES
- References: 9 tabelas
- Procedures: 3 SPs

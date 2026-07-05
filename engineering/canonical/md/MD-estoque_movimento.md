# MD-estoque_movimento — Runtime

## DOMAIN OVERVIEW
Domain: Runtime

## CANONICAL ENTITIES

### TABLE: estoque_movimento
- Type: CORE
- Domain: Runtime
- Source: dump auto-generated
- Status: DISCOVERED

## BUSINESS FLOW
Derived from dump:
- FK relationships: unidade, estoque_item, estoque_lote, estoque_movimento_item

## SP MAP
Related procedures: sp_farmacia_dispensar_registrar, sp_farm_dispensacao_registrar, sp_fix_fk_unidade

## EVENT MODEL
Event tables: Check manually

## RULES
TBD - Derived from procedures

## DEPENDENCIES
- References: 4 tabelas
- Procedures: 3 SPs

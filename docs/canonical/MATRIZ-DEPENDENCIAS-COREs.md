# MATRIZ-DEPENDENCIAS-COREs

## Propósito

Documento único de dependências entre COREs.

## Matriz

| CORE | Depende de | Bloqueia |
|------|------------|----------|
| CORE-001 | — | CORE-002, CORE-003, CORE-004, CORE-005 |
| CORE-002 | CORE-001 | CORE-003, CORE-004, CORE-005 |
| CORE-003 | CORE-001, CORE-002 | CORE-005 |
| CORE-004 | CORE-001, CORE-002 | CORE-005 |
| CORE-005 | CORE-001, CORE-002, CORE-003, CORE-004 | CORE-006, CORE-007, CORE-008, CORE-009, CORE-010, CORE-011 |
| CORE-006 | CORE-005 | CORE-007, CORE-008, CORE-009 |
| CORE-007 | CORE-005, CORE-006 | — |
| CORE-008 | CORE-005, CORE-006, CORE-007 | — |
| CORE-009 | CORE-005, CORE-006 | — |
| CORE-010 | CORE-005, CORE-006, CORE-007, CORE-008 | — |
| CORE-011 | CORE-005, CORE-006, CORE-007 | — |

## Regra

Nenhum CORE pode ser implementado antes de seus dependentes estarem congelados.

Dependências reversas (quem depende de um CORE) devem ser revisadas antes de qualquer alteração.

## Atualização

Atualizada pelo arquiteto após aprovação de nova ADR ou dossiê.

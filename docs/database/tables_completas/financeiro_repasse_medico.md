# financeiro_repasse_medico

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | bigint | NOT NULL | - | (Documentar) |
| id_usuario_medico | bigint | NOT NULL | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| valor_procedimento | decimal(10 | YES | - | (Documentar) |
| percentual_repasse | decimal(5 | YES | - | (Documentar) |
| valor_final_medico | decimal(10 | YES | - | (Documentar) |
| status_pagamento | enum('PREVIA' | YES | - | (Documentar) |
| data_competencia | date | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (id)
- KEY (id_usuario_medico,data_competencia)
- KEY (data_competencia,status_pagamento)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


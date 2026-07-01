# assistencial_watchdog_fila

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_watchdog | bigint | NOT NULL | - | (Documentar) |
| unidade | varchar(100) | NOT NULL | - | (Documentar) |
| backlog_eventos | int | YES | - | (Documentar) |
| taxa_retry | decimal(10 | YES | - | (Documentar) |
| estado_runtime | enum('NORMAL' | YES | - | (Documentar) |
| atualizado_em | datetime(6) | YES | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (unidade)
- Estrangeira: id_atendimento -> atendimento.id_atendimento
- Estrangeira: id_entidade -> saas_entidade.id_entidade

## Indices

- PRIMARY KEY (id_watchdog)
- KEY (unidade)
- KEY (id_atendimento)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


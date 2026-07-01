# assistencial_simulacao_futura

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_simulacao | bigint | NOT NULL | - | (Documentar) |
| horizonte_minutos | int | NOT NULL | - | (Documentar) |
| carga_prevista | decimal(10 | YES | - | (Documentar) |
| risco_conflito_federado | decimal(10 | YES | - | (Documentar) |
| risco_backlog | decimal(10 | YES | - | (Documentar) |
| recomendacao_runtime | varchar(200) | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_atendimento -> atendimento.id_atendimento
- Estrangeira: id_entidade -> saas_entidade.id_entidade

## Indices

- PRIMARY KEY (id_simulacao)
- KEY (horizonte_minutos)
- KEY (id_atendimento)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


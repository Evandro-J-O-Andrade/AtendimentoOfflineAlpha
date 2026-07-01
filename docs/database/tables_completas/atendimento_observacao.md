# atendimento_observacao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_obs | bigint | NOT NULL | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| tipo | enum('OBSERVACAO' | NOT NULL | - | (Documentar) |
| id_leito | int | YES | - | (Documentar) |
| data_inicio | datetime | YES | - | (Documentar) |
| data_fim | datetime | YES | - | (Documentar) |
| status | enum('ATIVO' | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (id_atendimento)
- Estrangeira: id_leito -> leito.id_leito
- Estrangeira: id_atendimento -> atendimento.id_atendimento
- Estrangeira: id_entidade -> saas_entidade.id_entidade

## Indices

- PRIMARY KEY (id_obs)
- KEY (id_atendimento)
- KEY (id_leito)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


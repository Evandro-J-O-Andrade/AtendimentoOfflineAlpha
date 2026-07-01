# atendimento_sinais_vitais

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | bigint | NOT NULL | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| id_usuario_registro | bigint | NOT NULL | - | (Documentar) |
| pa_sistolica | int | YES | - | (Documentar) |
| pa_diastolica | int | YES | - | (Documentar) |
| frequencia_cardiaca | int | YES | - | (Documentar) |
| frequencia_respiratoria | int | YES | - | (Documentar) |
| temperatura | decimal(4 | YES | - | (Documentar) |
| saturacao_o2 | int | YES | - | (Documentar) |
| hgt | int | YES | - | (Documentar) |
| data_registro | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_atendimento -> atendimento.id_atendimento
- Estrangeira: id_entidade -> saas_entidade.id_entidade

## Indices

- PRIMARY KEY (id)
- KEY (id_atendimento)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


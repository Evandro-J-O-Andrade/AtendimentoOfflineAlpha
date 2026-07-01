# atendimento_movimentacao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_mov | bigint | NOT NULL | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| de_local | int | YES | - | (Documentar) |
| para_local | int | YES | - | (Documentar) |
| id_usuario | bigint | YES | - | (Documentar) |
| motivo | varchar(255) | YES | - | (Documentar) |
| data_hora | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_usuario -> usuario.id_usuario
- Estrangeira: id_atendimento -> atendimento.id_atendimento
- Estrangeira: id_entidade -> saas_entidade.id_entidade

## Indices

- PRIMARY KEY (id_mov)
- KEY (id_atendimento)
- KEY (id_usuario)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


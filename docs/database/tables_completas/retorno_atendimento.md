# retorno_atendimento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_retorno | bigint | NOT NULL | - | (Documentar) |
| id_atendimento_origem | bigint | NOT NULL | - | (Documentar) |
| id_atendimento_retorno | bigint | NOT NULL | - | (Documentar) |
| motivo | text | YES | - | (Documentar) |
| data_hora | datetime | YES | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_atendimento -> atendimento.id_atendimento
- Estrangeira: id_entidade -> saas_entidade.id_entidade

## Indices

- PRIMARY KEY (id_retorno)
- KEY (id_atendimento_origem)
- KEY (id_atendimento_retorno)
- KEY (id_atendimento)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


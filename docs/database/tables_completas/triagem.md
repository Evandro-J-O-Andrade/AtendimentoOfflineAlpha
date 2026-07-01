# triagem

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_triagem | bigint | NOT NULL | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| id_risco | int | NOT NULL | - | (Documentar) |
| queixa | text | YES | - | (Documentar) |
| sinais_vitais | json | YES | - | (Documentar) |
| observacao | text | YES | - | (Documentar) |
| id_enfermeiro | bigint | NOT NULL | - | (Documentar) |
| data_hora | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (id_atendimento)
- Estrangeira: id_atendimento -> atendimento.id_atendimento
- Estrangeira: id_entidade -> saas_entidade.id_entidade
- Estrangeira: id_risco -> classificacao_risco.id_risco
- Estrangeira: id_enfermeiro -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_triagem)
- KEY (id_atendimento)
- KEY (id_risco)
- KEY (id_enfermeiro)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


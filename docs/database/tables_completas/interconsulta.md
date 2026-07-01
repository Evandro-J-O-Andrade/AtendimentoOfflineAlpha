# interconsulta

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_interconsulta | bigint | NOT NULL | - | (Documentar) |
| id_internacao | bigint | YES | - | (Documentar) |
| id_especialidade | bigint | YES | - | (Documentar) |
| motivo | text | YES | - | (Documentar) |
| status | enum('SOLICITADA' | YES | - | (Documentar) |
| data_hora | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_especialidade -> especialidade.id_especialidade

## Indices

- PRIMARY KEY (id_interconsulta)
- KEY (id_especialidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


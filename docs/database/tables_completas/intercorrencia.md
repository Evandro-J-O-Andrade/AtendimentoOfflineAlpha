# intercorrencia

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_intercorrencia | bigint | NOT NULL | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| id_internacao | bigint | YES | - | (Documentar) |
| descricao | text | NOT NULL | - | (Documentar) |
| gravidade | enum('LEVE' | YES | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| data_hora | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_internacao -> internacao.id_internacao
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_intercorrencia)
- KEY (id_usuario)
- KEY (id_atendimento)
- KEY (id_internacao)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


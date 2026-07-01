# anotacao_enfermagem

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_anotacao | bigint | NOT NULL | - | (Documentar) |
| id_internacao | bigint | NOT NULL | - | (Documentar) |
| descricao | text | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| data_hora | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_internacao -> internacao.id_internacao
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_anotacao)
- KEY (id_internacao)
- KEY (id_usuario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


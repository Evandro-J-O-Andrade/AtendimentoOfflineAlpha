# fila_evento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | bigint | NOT NULL | - | (Documentar) |
| id_fila | bigint | NOT NULL | - | (Documentar) |
| evento | enum('GERADA' | NOT NULL | - | (Documentar) |
| id_usuario | bigint | YES | - | (Documentar) |
| id_local | bigint | YES | - | (Documentar) |
| detalhe | text | YES | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_fila -> fila_senha.id

## Indices

- PRIMARY KEY (id)
- KEY (id_fila)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


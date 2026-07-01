# exame_historico

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | bigint | NOT NULL | - | (Documentar) |
| id_pedido | bigint | NOT NULL | - | (Documentar) |
| evento | enum('SOLICITACAO' | NOT NULL | - | (Documentar) |
| descricao | text | YES | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_pedido -> exame_pedido.id_pedido

## Indices

- PRIMARY KEY (id)
- KEY (id_pedido)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


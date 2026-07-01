# venda_item

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_venda_item | bigint | NOT NULL | - | (Documentar) |
| id_venda | bigint | NOT NULL | - | (Documentar) |
| id_farmaco | bigint | YES | - | (Documentar) |
| id_lote | bigint | YES | - | (Documentar) |
| id_local_estoque | bigint | YES | - | (Documentar) |
| descricao | varchar(255) | NOT NULL | - | (Documentar) |
| quantidade | int | NOT NULL | - | (Documentar) |
| valor_unitario | decimal(10 | NOT NULL | - | (Documentar) |
| desconto | decimal(10 | NOT NULL | - | (Documentar) |
| total_linha | decimal(10 | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_farmaco -> farmaco.id_farmaco
- Estrangeira: id_lote -> farmaco_lote.id_lote
- Estrangeira: id_venda -> venda.id_venda

## Indices

- PRIMARY KEY (id_venda_item)
- KEY (id_venda)
- KEY (id_farmaco,id_lote)
- KEY (id_lote)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


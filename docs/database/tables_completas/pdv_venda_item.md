# pdv_venda_item

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_item | bigint | NOT NULL | - | (Documentar) |
| id_venda | bigint | NOT NULL | - | (Documentar) |
| id_produto | bigint | NOT NULL | - | (Documentar) |
| id_lote | bigint | YES | - | (Documentar) |
| quantidade | decimal(14 | NOT NULL | - | (Documentar) |
| valor_unitario | decimal(14 | NOT NULL | - | (Documentar) |
| valor_total | decimal(14 | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_lote -> estoque_lote.id_lote
- Estrangeira: id_produto -> estoque_produto.id_produto
- Estrangeira: id_venda -> pdv_venda.id_venda

## Indices

- PRIMARY KEY (id_item)
- KEY (id_venda)
- KEY (id_produto)
- KEY (id_lote)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


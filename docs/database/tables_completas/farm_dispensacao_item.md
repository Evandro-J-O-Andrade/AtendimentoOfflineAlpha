# farm_dispensacao_item

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_item | bigint | NOT NULL | - | (Documentar) |
| id_dispensacao | bigint | NOT NULL | - | (Documentar) |
| id_produto | bigint | NOT NULL | - | (Documentar) |
| lote | bigint | YES | - | (Documentar) |
| quantidade | decimal(12 | NOT NULL | - | (Documentar) |
| valor_unitario | decimal(12 | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: lote -> estoque_lote.id_lote
- Estrangeira: lote -> estoque_lote.id_lote
- Estrangeira: id_dispensacao -> farm_dispensacao.id_dispensacao

## Indices

- PRIMARY KEY (id_item)
- KEY (id_dispensacao)
- KEY (lote)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


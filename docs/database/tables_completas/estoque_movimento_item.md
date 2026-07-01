# estoque_movimento_item

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_movimento_item | bigint | NOT NULL | - | (Documentar) |
| id_movimento | bigint | NOT NULL | - | (Documentar) |
| id_produto | bigint | NOT NULL | - | (Documentar) |
| id_lote | bigint | NOT NULL | - | (Documentar) |
| quantidade | decimal(15 | NOT NULL | - | (Documentar) |
| valor_unitario | decimal(15 | NOT NULL | - | (Documentar) |
| id_ffa_item | bigint | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_movimento -> estoque_movimento.id_movimento

## Indices

- PRIMARY KEY (id_movimento_item)
- KEY (id_movimento)
- KEY (id_produto)
- KEY (id_lote)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


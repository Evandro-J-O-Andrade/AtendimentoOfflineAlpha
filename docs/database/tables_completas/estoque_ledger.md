# estoque_ledger

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_ledger | bigint | NOT NULL | - | (Documentar) |
| id_movimento_item | bigint | NOT NULL | - | (Documentar) |
| id_conta | bigint | NOT NULL | - | (Documentar) |
| id_lote | bigint | NOT NULL | - | (Documentar) |
| tipo_dc | enum('D' | NOT NULL | - | (Documentar) |
| quantidade | decimal(15 | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_conta -> estoque_conta.id_conta
- Estrangeira: id_movimento_item -> estoque_movimento_item.id_movimento_item

## Indices

- PRIMARY KEY (id_ledger)
- KEY (id_movimento_item)
- KEY (id_lote)
- KEY (id_conta)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


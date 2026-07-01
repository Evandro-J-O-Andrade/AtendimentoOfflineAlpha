# estoque_lote_snapshot

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_snapshot | bigint | NOT NULL | - | (Documentar) |
| id_lote | bigint | NOT NULL | - | (Documentar) |
| id_movimento_item | bigint | NOT NULL | - | (Documentar) |
| saldo_anterior | decimal(15 | NOT NULL | - | (Documentar) |
| variacao | decimal(15 | NOT NULL | - | (Documentar) |
| saldo_atual | decimal(15 | NOT NULL | - | (Documentar) |
| hash_anterior | char(64) | YES | - | (Documentar) |
| hash_atual | char(64) | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_lote -> estoque_lote.id_lote
- Estrangeira: id_movimento_item -> estoque_movimento_item.id_movimento_item

## Indices

- PRIMARY KEY (id_snapshot)
- KEY (id_lote)
- KEY (id_movimento_item)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


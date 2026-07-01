# estoque_lote_snapshot

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id_snapshot | bigint | NO |  | id snapshot |
| id_lote | bigint | NO |  | id lote |
| id_movimento_item | bigint | NO |  | id movimento item |
| saldo_anterior | decimal(15,4) | NO |  | saldo anterior |
| variacao | decimal(15,4) | NO |  | variacao |
| saldo_atual | decimal(15,4) | NO |  | saldo atual |
| hash_anterior | char(64) | YES | NULL | hash anterior |
| hash_atual | char(64) | NO |  | hash atual |
| criado_em | datetime | NO | CURRENT_TIMESTAMP | criado em |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id_snapshot.
- Estrangeiras:
  - id_lote referencia estoque_lote.id_lote
  - id_movimento_item referencia estoque_movimento_item.id_movimento_item

## Ãndices

- fk_snap_lote em (id_lote)
- fk_snap_mov_item em (id_movimento_item)

## Constraints

- FOREIGN KEY (id_lote) REFERENCES estoque_lote(id_lote)
- FOREIGN KEY (id_movimento_item) REFERENCES estoque_movimento_item(id_movimento_item)

## Relacionamentos e Cardinalidade

- estoque_lote_snapshot (id_lote) -> estoque_lote (id_lote): N:1
- estoque_lote_snapshot (id_movimento_item) -> estoque_movimento_item (id_movimento_item): N:1

## DependÃªncias

- Depende de: estoque_lote, estoque_movimento_item.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.


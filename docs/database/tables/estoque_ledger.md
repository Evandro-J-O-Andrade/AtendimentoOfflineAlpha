# estoque_ledger

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id_ledger | bigint | NO |  | id ledger |
| id_movimento_item | bigint | NO |  | id movimento item |
| id_conta | bigint | NO |  | id conta |
| id_lote | bigint | NO |  | id lote |
| tipo_dc | enum('D','C') | NO |  | tipo dc |
| quantidade | decimal(15,4) | NO |  | quantidade |
| criado_em | datetime | NO | CURRENT_TIMESTAMP | criado em |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id_ledger.
- Estrangeiras:
  - id_conta referencia estoque_conta.id_conta
  - id_movimento_item referencia estoque_movimento_item.id_movimento_item

## Ãndices

- fk_ledger_mov_item em (id_movimento_item)
- idx_ledger_lote em (id_lote)
- idx_ledger_conta em (id_conta)

## Constraints

- FOREIGN KEY (id_conta) REFERENCES estoque_conta(id_conta)
- FOREIGN KEY (id_movimento_item) REFERENCES estoque_movimento_item(id_movimento_item)

## Relacionamentos e Cardinalidade

- estoque_ledger (id_conta) -> estoque_conta (id_conta): N:1
- estoque_ledger (id_movimento_item) -> estoque_movimento_item (id_movimento_item): N:1

## DependÃªncias

- Depende de: estoque_conta, estoque_movimento_item.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.


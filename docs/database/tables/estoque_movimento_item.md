# estoque_movimento_item

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id_movimento_item | bigint | NO |  | id movimento item |
| id_movimento | bigint | NO |  | id movimento |
| id_produto | bigint | NO |  | id produto |
| id_lote | bigint | NO |  | id lote |
| quantidade | decimal(15,4) | NO |  | quantidade |
| valor_unitario | decimal(15,6) | NO | '0.000000' | valor unitario |
| id_ffa_item | bigint | YES | NULL | id ffa item |
| criado_em | datetime | NO | CURRENT_TIMESTAMP | criado em |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id_movimento_item.
- Estrangeiras:
  - id_movimento referencia estoque_movimento.id_movimento

## Ãndices

- fk_item_mov em (id_movimento)
- idx_item_produto em (id_produto)
- idx_item_lote em (id_lote)

## Constraints

- FOREIGN KEY (id_movimento) REFERENCES estoque_movimento(id_movimento)

## Relacionamentos e Cardinalidade

- estoque_movimento_item (id_movimento) -> estoque_movimento (id_movimento): N:1

## DependÃªncias

- Depende de: estoque_movimento.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.


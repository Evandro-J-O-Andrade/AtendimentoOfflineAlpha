# estoque_inventario_item

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id_item | bigint | NO |  | id item |
| id_inventario | bigint | NO |  | id inventario |
| id_produto | bigint | NO |  | id produto |
| id_lote | bigint | YES | NULL | id lote |
| qtd_sistema | decimal(14,3) | NO | '0.000' | qtd sistema |
| qtd_contada | decimal(14,3) | YES | NULL | qtd contada |
| divergencia | decimal(14,3) | YES | NULL | divergencia |
| criado_em | datetime | NO | CURRENT_TIMESTAMP | criado em |
| atualizado_em | datetime | YES | NULL | atualizado em |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id_item.

## Ãndices

- ix_inv_item_inv em (id_inventario)
- ix_inv_item_prod em (id_produto)

## Constraints

- Nenhuma constraint adicional.

## Relacionamentos e Cardinalidade

- Nenhum relacionamento externo declarado.

## DependÃªncias

- Nenhuma dependÃªncia externa declarada.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.


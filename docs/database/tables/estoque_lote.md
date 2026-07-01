# estoque_lote

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id_lote | bigint | NO |  | id lote |
| id_item | bigint | NO |  | id item |
| numero_lote | varchar(100) | NO |  | numero lote |
| data_validade | date | NO |  | data validade |
| id_sessao_usuario | bigint | NO |  | id sessao usuario |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id_lote.
- Estrangeiras:
  - id_item referencia estoque_item.id_item

## Ãndices

- fk_lote_item em (id_item)

## Constraints

- FOREIGN KEY (id_item) REFERENCES estoque_item(id_item)

## Relacionamentos e Cardinalidade

- estoque_lote (id_item) -> estoque_item (id_item): N:1

## DependÃªncias

- Depende de: estoque_item.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.


# dispensacao_medicacao

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id_dispensacao | bigint | NO |  | id dispensacao |
| id_ordem | bigint | NO |  | id ordem |
| id_item | bigint | YES | NULL | id item |
| id_farmaco | bigint | NO |  | id farmaco |
| id_lote | bigint | NO |  | id lote |
| quantidade | decimal(10,2) | NO |  | quantidade |
| id_usuario_dispensador | bigint | NO |  | id usuario dispensador |
| data_hora | datetime | YES | CURRENT_TIMESTAMP | data hora |
| status | enum('ENTREGUE','ESTORNADO') | YES | 'ENTREGUE' | status |
| observacao | text | YES |  | observacao |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id_dispensacao.
- Estrangeiras:
  - id_item referencia ordem_assistencial_item.id_item

## Ãndices

- fk_disp_ordem em (id_ordem)
- fk_disp_lote em (id_lote)
- idx_disp_item em (id_item)

## Constraints

- FOREIGN KEY (id_item) REFERENCES ordem_assistencial_item(id_item)

## Relacionamentos e Cardinalidade

- dispensacao_medicacao (id_item) -> ordem_assistencial_item (id_item): N:1

## DependÃªncias

- Depende de: ordem_assistencial_item.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.


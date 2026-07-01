# estoque_almoxarifado_central

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id | bigint | NO |  | id |
| id_produto | int | NO |  | id produto |
| lote | varchar(50) | NO |  | lote |
| validade | date | NO |  | validade |
| quantidade_atual | decimal(12,4) | NO |  | quantidade atual |
| valor_unitario_compra | decimal(12,4) | YES | NULL | valor unitario compra |
| id_fornecedor | int | YES | NULL | id fornecedor |
| nota_fiscal | varchar(50) | YES | NULL | nota fiscal |
| data_entrada | datetime | YES | CURRENT_TIMESTAMP | data entrada |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id.

## Ãndices

- Nenhum Ã­ndice adicional.

## Constraints

- Nenhuma constraint adicional.

## Relacionamentos e Cardinalidade

- Nenhum relacionamento externo declarado.

## DependÃªncias

- Nenhuma dependÃªncia externa declarada.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.


# estoque_produto_codigo_externo

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id_codigo_ext | bigint | NO |  | id codigo ext |
| id_produto | bigint | NO |  | id produto |
| sistema_externo | enum('SIGTAP','TUSS','SIMPRO','BRASINDICE','OUTRO') | NO |  | sistema externo |
| codigo_externo | varchar(80) | NO |  | codigo externo |
| preferencial | tinyint(1) | NO | '0' | preferencial |
| criado_em | datetime | NO | CURRENT_TIMESTAMP | criado em |
| id_sessao_usuario | bigint | NO |  | id sessao usuario |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id_codigo_ext.
- Estrangeiras:
  - id_produto referencia estoque_produto.id_produto

## Ãndices

- fk_cod_ext_sessao em (id_sessao_usuario)

## Constraints

- FOREIGN KEY (id_produto) REFERENCES estoque_produto(id_produto)

## Relacionamentos e Cardinalidade

- estoque_produto_codigo_externo (id_produto) -> estoque_produto (id_produto): N:1

## DependÃªncias

- Depende de: estoque_produto.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.


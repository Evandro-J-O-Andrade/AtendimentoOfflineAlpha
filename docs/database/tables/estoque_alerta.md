# estoque_alerta

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id_alerta | bigint | NO |  | id alerta |
| id_saldo | bigint | NO |  | id saldo |
| tipo_alerta | enum('BAIXO','CRITICO','VENCIMENTO_PROXIMO') | NO |  | tipo alerta |
| gerado_em | datetime | NO | CURRENT_TIMESTAMP | gerado em |
| resolvido | tinyint(1) | YES | '0' | resolvido |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id_alerta.
- Estrangeiras:
  - id_saldo referencia estoque_produto_saldo.id_saldo

## Ãndices

- fk_alerta_saldo em (id_saldo)

## Constraints

- FOREIGN KEY (id_saldo) REFERENCES estoque_produto_saldo(id_saldo)

## Relacionamentos e Cardinalidade

- estoque_alerta (id_saldo) -> estoque_produto_saldo (id_saldo): N:1

## DependÃªncias

- Depende de: estoque_produto_saldo.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.


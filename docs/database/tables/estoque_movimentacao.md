# estoque_movimentacao

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id_movimentacao | bigint | NO |  | id movimentacao |
| id_saldo | bigint | NO |  | id saldo |
| tipo_movimento | enum('ENTRADA','SAIDA','AJUSTE','TRANSFERENCIA','RESERVA','LIBERACAO_RESERVA') | NO |  | tipo movimento |
| origem_modulo | enum('FARMACIA','FATURAMENTO','TI','MANUTENCAO','GASO','FISIO','SUTURA','CUIDADOS','OUTRO') | NO |  | origem modulo |
| id_origem | bigint | YES | NULL | id origem |
| quantidade | decimal(14,3) | NO |  | quantidade |
| id_usuario | bigint | NO |  | id usuario |
| confirmado | tinyint(1) | NO | '0' | confirmado |
| confirmado_em | datetime | YES | NULL | confirmado em |
| criado_em | datetime | NO | CURRENT_TIMESTAMP | criado em |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id_movimentacao.
- Estrangeiras:
  - id_saldo referencia estoque_produto_saldo.id_saldo

## Ãndices

- fk_mov_saldo em (id_saldo)

## Constraints

- FOREIGN KEY (id_saldo) REFERENCES estoque_produto_saldo(id_saldo)

## Relacionamentos e Cardinalidade

- estoque_movimentacao (id_saldo) -> estoque_produto_saldo (id_saldo): N:1

## DependÃªncias

- Depende de: estoque_produto_saldo.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.


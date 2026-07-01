# estoque_reserva

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id_reserva | bigint | NO |  | id reserva |
| id_estoque_local | bigint | NO |  | id estoque local |
| id_produto | bigint | NO |  | id produto |
| id_lote | bigint | NO |  | id lote |
| quantidade | decimal(15,4) | NO |  | quantidade |
| origem_tipo | enum('FARM_DISP','PDV','AJUSTE','TRANSFERENCIA','OUTRO') | NO |  | origem tipo |
| id_documento_origem | bigint | YES | NULL | id documento origem |
| status | enum('ATIVA','FINALIZADA','CANCELADA') | NO | 'ATIVA' | status |
| hash_anterior | char(64) | YES | NULL | hash anterior |
| hash_atual | char(64) | NO |  | hash atual |
| id_sessao_usuario | bigint | NO |  | id sessao usuario |
| criado_em | datetime | NO | CURRENT_TIMESTAMP | criado em |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id_reserva.
- Estrangeiras:
  - id_estoque_local referencia estoque_local.id_estoque_local
  - id_lote referencia estoque_lote.id_lote
  - id_produto referencia estoque_produto.id_produto

## Ãndices

- fk_reserva_local em (id_estoque_local)
- fk_reserva_produto em (id_produto)
- fk_reserva_lote em (id_lote)
- fk_reserva_sessao em (id_sessao_usuario)

## Constraints

- FOREIGN KEY (id_estoque_local) REFERENCES estoque_local(id_estoque_local)
- FOREIGN KEY (id_lote) REFERENCES estoque_lote(id_lote)
- FOREIGN KEY (id_produto) REFERENCES estoque_produto(id_produto)

## Relacionamentos e Cardinalidade

- estoque_reserva (id_estoque_local) -> estoque_local (id_estoque_local): N:1
- estoque_reserva (id_lote) -> estoque_lote (id_lote): N:1
- estoque_reserva (id_produto) -> estoque_produto (id_produto): N:1

## DependÃªncias

- Depende de: estoque_local, estoque_lote, estoque_produto.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.


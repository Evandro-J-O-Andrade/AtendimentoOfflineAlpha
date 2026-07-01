# estoque_movimento

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id_movimento | bigint | NO |  | id movimento |
| id_item | bigint | NO |  | id item |
| id_unidade | bigint unsigned | NO |  | id unidade |
| id_local_origem | bigint | YES | NULL | id local origem |
| id_local_destino | bigint | YES | NULL | id local destino |
| id_lote | bigint | NO |  | id lote |
| tipo_movimento | enum('ENTRADA','SAIDA','TRANSFERENCIA','CONSUMO','VENDA','AJUSTE') | NO |  | tipo movimento |
| quantidade | decimal(15,4) | NO |  | quantidade |
| hash_duplicidade | char(64) | YES | NULL | hash duplicidade |
| id_sessao_usuario | bigint | NO |  | id sessao usuario |
| criado_em | timestamp | YES | CURRENT_TIMESTAMP | criado em |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id_movimento.
- Ãšnicas:
  - hash_duplicidade (hash_duplicidade)
- Estrangeiras:
  - id_unidade referencia unidade.id_unidade
  - id_item referencia estoque_item.id_item
  - id_lote referencia estoque_lote.id_lote

## Ãndices

- fk_estq_mov_item_ref em (id_item)
- fk_estq_mov_lote_ref em (id_lote)
- fk_estoque_movimento_unidade em (id_unidade)

## Constraints

- FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade)
- FOREIGN KEY (id_item) REFERENCES estoque_item(id_item)
- FOREIGN KEY (id_lote) REFERENCES estoque_lote(id_lote)

## Relacionamentos e Cardinalidade

- estoque_movimento (id_unidade) -> unidade (id_unidade): N:1
- estoque_movimento (id_item) -> estoque_item (id_item): N:1
- estoque_movimento (id_lote) -> estoque_lote (id_lote): N:1

## DependÃªncias

- Depende de: estoque_item, estoque_lote, unidade.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.


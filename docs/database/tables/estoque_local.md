# estoque_local

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id_estoque_local | bigint | NO |  | id estoque local |
| codigo | varchar(60) | NO |  | codigo |
| tipo | enum('FARMACIA_RUA','FARMACIA_PA','FARMACIA_UPA','FARMACIA_UBS','ALMOX','LAB','OUTRO') | NO |  | tipo |
| ala | enum('ADULTO','PEDI') | YES | NULL | ala |
| nome | varchar(200) | NO |  | nome |
| id_unidade | bigint unsigned | NO |  | id unidade |
| id_sistema | bigint | NO |  | id sistema |
| id_local_operacional | bigint | NO |  | id local operacional |
| ativo | tinyint(1) | NO | '1' | ativo |
| id_sessao_usuario | bigint | NO |  | id sessao usuario |
| criado_em | datetime | NO | CURRENT_TIMESTAMP | criado em |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id_estoque_local.
- Estrangeiras:
  - id_unidade referencia unidade.id_unidade

## Ãndices

- fk_local_sessao em (id_sessao_usuario)
- fk_estoque_local_unidade em (id_unidade)

## Constraints

- FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade)

## Relacionamentos e Cardinalidade

- estoque_local (id_unidade) -> unidade (id_unidade): N:1

## DependÃªncias

- Depende de: unidade.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.


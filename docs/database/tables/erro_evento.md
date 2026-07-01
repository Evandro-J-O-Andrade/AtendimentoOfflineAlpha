# erro_evento

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id_erro | bigint | NO |  | id erro |
| id_sessao_usuario | bigint | YES | NULL | id sessao usuario |
| id_erro_catalogo | bigint | YES | NULL | id erro catalogo |
| uuid_transacao | char(36) | YES | NULL | uuid transacao |
| dominio | varchar(50) | YES | NULL | dominio |
| acao | varchar(100) | YES | NULL | acao |
| mensagem_erro | text | NO |  | mensagem erro |
| stack_trace | json | YES | NULL | stack trace |
| payload_tentativa | json | YES | NULL | payload tentativa |
| criado_em | datetime(6) | NO | CURRENT_TIMESTAMP | criado em |
| id_entidade | bigint unsigned | YES | NULL | id entidade |

## Chaves

- PrimÃ¡ria: id_erro.
- Estrangeiras:
  - id_erro_catalogo referencia erro_catalogo.id_erro_catalogo

## Ãndices

- idx_erro_sessao em (id_sessao_usuario)
- idx_erro_data em (criado_em)
- fk_erro_catalogo em (id_erro_catalogo)

## Constraints

- FOREIGN KEY (id_erro_catalogo) REFERENCES erro_catalogo(id_erro_catalogo)

## Relacionamentos e Cardinalidade

- erro_evento (id_erro_catalogo) -> erro_catalogo (id_erro_catalogo): N:1

## DependÃªncias

- Depende de: erro_catalogo.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.


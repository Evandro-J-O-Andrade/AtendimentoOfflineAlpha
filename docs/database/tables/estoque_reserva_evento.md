# estoque_reserva_evento

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id_evento | bigint | NO |  | id evento |
| id_reserva | bigint | NO |  | id reserva |
| id_sessao_usuario | bigint | NO |  | id sessao usuario |
| tipo_evento | enum('CRIAR','FINALIZAR','CANCELAR','GERAR_MOVIMENTO','ERRO') | NO |  | tipo evento |
| detalhe | text | YES |  | detalhe |
| hash_anterior | char(64) | YES | NULL | hash anterior |
| hash_atual | char(64) | NO |  | hash atual |
| criado_em | datetime | NO | CURRENT_TIMESTAMP | criado em |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id_evento.
- Estrangeiras:
  - id_reserva referencia estoque_reserva.id_reserva

## Ãndices

- fk_evento_reserva em (id_reserva)
- fk_evento_sessao em (id_sessao_usuario)

## Constraints

- FOREIGN KEY (id_reserva) REFERENCES estoque_reserva(id_reserva)

## Relacionamentos e Cardinalidade

- estoque_reserva_evento (id_reserva) -> estoque_reserva (id_reserva): N:1

## DependÃªncias

- Depende de: estoque_reserva.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.


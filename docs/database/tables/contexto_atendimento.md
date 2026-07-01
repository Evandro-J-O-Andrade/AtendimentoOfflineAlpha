# contexto_atendimento

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id_contexto | bigint | NO |  | id contexto |
| id_sistema | bigint | NO |  | id sistema |
| nome | varchar(100) | YES | NULL | nome |
| tipo | enum('PORTA','EMERGENCIA','LEITO','EXECUCAO') | YES | NULL | tipo |
| usa_fila | tinyint(1) | YES | NULL | usa fila |
| usa_chamada | tinyint(1) | YES | NULL | usa chamada |
| ativo | tinyint(1) | YES | NULL | ativo |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id_contexto.
- Estrangeiras:
  - id_sistema referencia sistema.id_sistema

## Ãndices

- id_sistema em (id_sistema)

## Constraints

- FOREIGN KEY (id_sistema) REFERENCES sistema(id_sistema)

## Relacionamentos e Cardinalidade

- contexto_atendimento (id_sistema) -> sistema (id_sistema): N:1

## DependÃªncias

- Depende de: sistema.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.


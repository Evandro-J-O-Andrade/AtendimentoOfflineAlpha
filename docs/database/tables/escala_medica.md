# escala_medica

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id | bigint | NO |  | id |
| id_usuario_medico | bigint | NO |  | id usuario medico |
| id_unidade | bigint unsigned | NO |  | id unidade |
| data_plantao | date | NO |  | data plantao |
| turno | enum('MANHA','TARDE','NOITE','24H') | NO |  | turno |
| status_presenca | enum('PREVISTO','CONFIRMADO','FALTOU','SUBSTITUIDO') | YES | 'PREVISTO' | status presenca |
| id_substituto | bigint | YES | NULL | id substituto |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id.
- Estrangeiras:
  - id_unidade referencia unidade.id_unidade

## Ãndices

- fk_escala_medica_unidade em (id_unidade)

## Constraints

- FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade)

## Relacionamentos e Cardinalidade

- escala_medica (id_unidade) -> unidade (id_unidade): N:1

## DependÃªncias

- Depende de: unidade.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.


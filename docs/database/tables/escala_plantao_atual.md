# escala_plantao_atual

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id | bigint | NO |  | id |
| id_usuario | bigint | NO |  | id usuario |
| id_unidade | bigint unsigned | NO |  | id unidade |
| id_setor | int | YES | NULL | id setor |
| registro_profissional | varchar(50) | YES | NULL | registro profissional |
| data_inicio | datetime | YES | NULL | data inicio |
| data_fim | datetime | YES | NULL | data fim |
| status_plantao | enum('ATIVO','ENCERRADO') | YES | 'ATIVO' | status plantao |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id.
- Estrangeiras:
  - id_unidade referencia unidade.id_unidade

## Ãndices

- fk_escala_plantao_atual_unidade em (id_unidade)

## Constraints

- FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade)

## Relacionamentos e Cardinalidade

- escala_plantao_atual (id_unidade) -> unidade (id_unidade): N:1

## DependÃªncias

- Depende de: unidade.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.


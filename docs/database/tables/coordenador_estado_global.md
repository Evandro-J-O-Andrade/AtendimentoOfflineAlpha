# coordenador_estado_global

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id_coordenacao | bigint | NO |  | id coordenacao |
| uuid_runtime | char(36) | NO |  | uuid runtime |
| id_unidade | bigint unsigned | NO |  | id unidade |
| estado_atual | varchar(80) | NO |  | estado atual |
| hash_estado | char(64) | NO |  | hash estado |
| payload_snapshot | json | YES | NULL | payload snapshot |
| bloqueado | tinyint(1) | YES | '0' | bloqueado |
| criado_em | datetime(6) | YES | CURRENT_TIMESTAMP | criado em |
| atualizado_em | datetime(6) | YES | NULL | atualizado em |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id_coordenacao.
- Estrangeiras:
  - id_entidade referencia saas_entidade.id_entidade
  - id_unidade referencia unidade.id_unidade

## Ãndices

- idx_coord_uuid em (uuid_runtime)
- idx_coord_estado em (estado_atual)
- fk_coordenador_estado_global_unidade em (id_unidade)
- fk_coordenador_estado_global_entidade em (id_entidade)

## Constraints

- FOREIGN KEY (id_entidade) REFERENCES saas_entidade(id_entidade)
- FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade)

## Relacionamentos e Cardinalidade

- coordenador_estado_global (id_entidade) -> saas_entidade (id_entidade): N:1
- coordenador_estado_global (id_unidade) -> unidade (id_unidade): N:1

## DependÃªncias

- Depende de: saas_entidade, unidade.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.


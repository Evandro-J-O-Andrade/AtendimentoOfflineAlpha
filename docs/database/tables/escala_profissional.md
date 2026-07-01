# escala_profissional

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id_escala_profissional | bigint | NO |  | id escala profissional |
| id_funcionario | bigint | NO |  | id funcionario |
| id_unidade | bigint unsigned | NO |  | id unidade |
| id_local | bigint | YES | NULL | id local |
| data_inicio | datetime | NO |  | data inicio |
| data_fim | datetime | NO |  | data fim |
| tipo_escala | enum('PLANTAO','DIURNO','NOTURNO','SOBREAVISO') | YES | 'PLANTAO' | tipo escala |
| observacao | text | YES |  | observacao |
| criado_em | datetime(6) | YES | CURRENT_TIMESTAMP | criado em |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id_escala_profissional.
- Estrangeiras:
  - id_funcionario referencia funcionario.id_funcionario
  - id_local referencia local.id_local
  - id_unidade referencia unidade.id_unidade

## Ãndices

- idx_ep_funcionario em (id_funcionario)
- idx_ep_unidade em (id_unidade)
- idx_ep_local em (id_local)

## Constraints

- FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario)
- FOREIGN KEY (id_local) REFERENCES local(id_local)
- FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade)

## Relacionamentos e Cardinalidade

- escala_profissional (id_funcionario) -> funcionario (id_funcionario): N:1
- escala_profissional (id_local) -> local (id_local): N:1
- escala_profissional (id_unidade) -> unidade (id_unidade): N:1

## DependÃªncias

- Depende de: funcionario, local, unidade.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.


# estoque_audit_stream

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id_audit | bigint | NO |  | id audit |
| id_referencia_externa | bigint | YES | NULL | id referencia externa |
| entidade_tipo | enum('ESTOQUE','FATURAMENTO','ASSISTENCIAL') | NO |  | entidade tipo |
| evento_tipo | varchar(50) | YES | NULL | evento tipo |
| payload | json | YES | NULL | payload |
| hash_pipeline | char(64) | YES | NULL | hash pipeline |
| criado_em | timestamp | YES | CURRENT_TIMESTAMP | criado em |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id_audit.

## Ãndices

- idx_ref em (id_referencia_externa)
- idx_hash em (hash_pipeline)

## Constraints

- Nenhuma constraint adicional.

## Relacionamentos e Cardinalidade

- Nenhum relacionamento externo declarado.

## DependÃªncias

- Nenhuma dependÃªncia externa declarada.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.


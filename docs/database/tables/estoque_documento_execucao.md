# estoque_documento_execucao

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id | bigint | NO |  | id |
| hash_execucao | char(64) | NO |  | hash execucao |
| id_documento | bigint | NO |  | id documento |
| tipo_documento | varchar(50) | NO |  | tipo documento |
| id_movimento | bigint | YES | NULL | id movimento |
| id_sessao_usuario | bigint | NO |  | id sessao usuario |
| contexto_operacional | varchar(100) | YES | NULL | contexto operacional |
| estado_execucao | enum('PENDENTE','EXECUTANDO','CONCLUIDO','FALHA') | NO | 'PENDENTE' | estado execucao |
| tentativa_execucao | int | NO | '1' | tentativa execucao |
| hash_pipeline_anterior | char(64) | YES | NULL | hash pipeline anterior |
| hash_pipeline_atual | char(64) | YES | NULL | hash pipeline atual |
| criado_em | datetime | NO | CURRENT_TIMESTAMP | criado em |
| atualizado_em | datetime | YES | NULL | atualizado em |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id.
- Ãšnicas:
  - uk_hash_execucao (hash_execucao)

## Ãndices

- idx_documento em (id_documento)
- idx_movimento em (id_movimento)
- idx_sessao em (id_sessao_usuario)
- idx_estado em (estado_execucao)
- idx_pipeline em (hash_pipeline_atual)

## Constraints

- Nenhuma constraint adicional.

## Relacionamentos e Cardinalidade

- Nenhum relacionamento externo declarado.

## DependÃªncias

- Nenhuma dependÃªncia externa declarada.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.


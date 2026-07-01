# estoque_pipeline_estado

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| hash_execucao | char(64) | NO |  | hash execucao |
| etapa_atual | varchar(50) | YES | NULL | etapa atual |
| bloqueado | tinyint | YES | '1' | bloqueado |
| lease_expira_em | datetime | YES | NULL | lease expira em |
| atualizado_em | datetime | YES | CURRENT_TIMESTAMP | atualizado em |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: hash_execucao.

## Ãndices

- Nenhum Ã­ndice adicional.

## Constraints

- Nenhuma constraint adicional.

## Relacionamentos e Cardinalidade

- Nenhum relacionamento externo declarado.

## DependÃªncias

- Nenhuma dependÃªncia externa declarada.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.


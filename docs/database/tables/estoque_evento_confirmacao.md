# estoque_evento_confirmacao

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id_evento | bigint | NO |  | id evento |
| hash_execucao | char(64) | NO |  | hash execucao |
| id_movimento | bigint | NO |  | id movimento |
| id_usuario_executor | bigint | NO |  | id usuario executor |
| id_usuario_confirmador | bigint | YES | NULL | id usuario confirmador |
| tipo_evento | varchar(50) | NO |  | tipo evento |
| status_confirmacao | enum('PENDENTE','CONFIRMADO','REJEITADO') | NO | 'PENDENTE' | status confirmacao |
| criado_em | timestamp | YES | CURRENT_TIMESTAMP | criado em |
| atualizado_em | timestamp | YES | NULL | atualizado em |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id_evento.
- Ãšnicas:
  - uk_evento_execucao (hash_execucao)

## Ãndices

- idx_evento_movimento em (id_movimento)
- idx_evento_status em (status_confirmacao)

## Constraints

- Nenhuma constraint adicional.

## Relacionamentos e Cardinalidade

- Nenhum relacionamento externo declarado.

## DependÃªncias

- Nenhuma dependÃªncia externa declarada.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.


# estoque_conciliacao_atomica

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id | bigint | NO |  | id |
| id_movimento | bigint | NO |  | id movimento |
| id_movimento_item | bigint | NO |  | id movimento item |
| id_ledger | bigint | NO |  | id ledger |
| id_fluxo_assistencial | bigint | YES | NULL | id fluxo assistencial |
| hash_execucao | char(64) | NO |  | hash execucao |
| estado_conciliacao | enum('PENDENTE','OK','DIVERGENTE','REPROCESSAR') | NO | 'PENDENTE' | estado conciliacao |
| divergencia_quantidade | decimal(10,3) | YES | NULL | divergencia quantidade |
| divergencia_valor | decimal(10,2) | YES | NULL | divergencia valor |
| validado_em | datetime | YES | NULL | validado em |
| criado_em | datetime | NO | CURRENT_TIMESTAMP | criado em |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id.
- Ãšnicas:
  - uk_movimento_item (id_movimento_item)
  - uk_hash_execucao (hash_execucao)

## Ãndices

- idx_movimento em (id_movimento)
- idx_fluxo em (id_fluxo_assistencial)
- idx_estado em (estado_conciliacao)

## Constraints

- Nenhuma constraint adicional.

## Relacionamentos e Cardinalidade

- Nenhum relacionamento externo declarado.

## DependÃªncias

- Nenhuma dependÃªncia externa declarada.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.


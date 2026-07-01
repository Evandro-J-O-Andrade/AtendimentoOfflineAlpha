# estoque_fluxo_assistencial

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id | bigint | NO |  | id |
| id_paciente | bigint | NO |  | id paciente |
| id_ffaitem | bigint | NO |  | id ffaitem |
| id_movimento | bigint | NO |  | id movimento |
| id_movimento_item | bigint | NO |  | id movimento item |
| id_produto | bigint | NO |  | id produto |
| id_lote | bigint | NO |  | id lote |
| quantidade | decimal(10,3) | NO |  | quantidade |
| hash_execucao | char(64) | NO |  | hash execucao |
| criado_em | datetime | NO | CURRENT_TIMESTAMP | criado em |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id.
- Ãšnicas:
  - uk_hash_execucao (hash_execucao)

## Ãndices

- idx_paciente em (id_paciente)
- idx_lote em (id_lote)
- idx_produto em (id_produto)
- idx_movimento em (id_movimento)

## Constraints

- Nenhuma constraint adicional.

## Relacionamentos e Cardinalidade

- Nenhum relacionamento externo declarado.

## DependÃªncias

- Nenhuma dependÃªncia externa declarada.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.


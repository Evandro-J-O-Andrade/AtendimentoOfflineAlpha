# estoque_movimentacao_itens

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id | bigint | NO |  | id |
| id_atendimento | bigint unsigned | NO |  | id atendimento |
| id_produto | int | NO |  | id produto |
| quantidade_saida | decimal(12,4) | NO |  | quantidade saida |
| id_usuario_quem_deu_baixa | bigint | NO |  | id usuario quem deu baixa |
| data_movimento | datetime | YES | CURRENT_TIMESTAMP | data movimento |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id.

## Ãndices

- fk_mov_atendimento em (id_atendimento)

## Constraints

- Nenhuma constraint adicional.

## Relacionamentos e Cardinalidade

- Nenhum relacionamento externo declarado.

## DependÃªncias

- Nenhuma dependÃªncia externa declarada.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.


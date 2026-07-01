# consumo_limpeza

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: Consumo operacional de produtos de limpeza e higiene

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id_consumo | bigint | NO |  | id consumo |
| id_setor | int | NO |  | id setor |
| id_produto | bigint | NO |  | id produto |
| quantidade | decimal(10,2) | NO |  | quantidade |
| unidade | varchar(20) | YES | 'UN' | unidade |
| consumido_em | datetime | YES | CURRENT_TIMESTAMP | consumido em |
| registrado_por | bigint | NO |  | registrado por |
| motivo | enum('ROTINA','REPOSICAO','CONTAMINACAO','INTERCORRENCIA','OUTRO') | YES | 'ROTINA' | motivo |
| observacao | text | YES |  | observacao |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id_consumo.

## Ãndices

- idx_setor em (id_setor)
- idx_produto em (id_produto)

## Constraints

- Nenhuma constraint adicional.

## Relacionamentos e Cardinalidade

- Nenhum relacionamento externo declarado.

## DependÃªncias

- Nenhuma dependÃªncia externa declarada.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.


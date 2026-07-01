# consumo_manutencao

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: Consumo de materiais em manutenÃ§Ã£o

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id_consumo | bigint | NO |  | id consumo |
| id_chamado | bigint | NO |  | id chamado |
| id_produto | bigint | NO |  | id produto |
| quantidade | decimal(10,2) | NO |  | quantidade |
| unidade | varchar(20) | YES | NULL | unidade |
| consumido_em | datetime | YES | CURRENT_TIMESTAMP | consumido em |
| registrado_por | bigint | NO |  | registrado por |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id_consumo.

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


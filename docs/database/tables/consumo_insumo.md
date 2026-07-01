# consumo_insumo

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: Consumo real de insumos no paciente

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id_consumo | bigint | NO |  | id consumo |
| id_ffa | bigint | NO |  | id ffa |
| origem | enum('FARMACIA','ALMOXARIFADO','MANUTENCAO') | NO |  | origem |
| id_produto | bigint | NO |  | id produto |
| quantidade | decimal(10,2) | NO |  | quantidade |
| usado_em | datetime | YES | CURRENT_TIMESTAMP | usado em |
| registrado_por | bigint | NO |  | registrado por |
| observacao | text | YES |  | observacao |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id_consumo.

## Ãndices

- idx_ffa em (id_ffa)
- idx_origem em (origem)

## Constraints

- Nenhuma constraint adicional.

## Relacionamentos e Cardinalidade

- Nenhum relacionamento externo declarado.

## DependÃªncias

- Nenhuma dependÃªncia externa declarada.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.


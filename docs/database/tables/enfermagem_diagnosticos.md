# enfermagem_diagnosticos

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id | bigint | NO |  | id |
| id_ffa | bigint | NO |  | id ffa |
| diagnostico_selecionado | varchar(255) | YES | NULL | diagnostico selecionado |
| tipo | enum('HISTORICO','EXAME_FISICO','DIAGNOSTICO','PRESCRICAO') | YES | NULL | tipo |
| observacao | text | YES |  | observacao |
| id_usuario | bigint | NO |  | id usuario |
| data_hora | datetime | YES | CURRENT_TIMESTAMP | data hora |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id.

## Ãndices

- idx_ffa_diagnostico em (id_ffa)

## Constraints

- Nenhuma constraint adicional.

## Relacionamentos e Cardinalidade

- Nenhum relacionamento externo declarado.

## DependÃªncias

- Nenhuma dependÃªncia externa declarada.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.


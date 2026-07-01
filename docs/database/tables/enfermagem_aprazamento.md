# enfermagem_aprazamento

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id | bigint | NO |  | id |
| id_atendimento | bigint | NO |  | id atendimento |
| medicamento | varchar(255) | NO |  | medicamento |
| via_administracao | varchar(50) | YES | NULL | via administracao |
| frequencia | varchar(50) | YES | NULL | frequencia |
| horario_previsto | datetime | NO |  | horario previsto |
| horario_executado | datetime | YES | NULL | horario executado |
| id_usuario_execucao | bigint | YES | NULL | id usuario execucao |
| status | enum('AGUARDANDO','REALIZADO','ATRASADO','SUSPENSO') | YES | 'AGUARDANDO' | status |
| observacao | text | YES |  | observacao |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id.

## Ãndices

- idx_apraz_atend em (id_atendimento)
- idx_apraz_hora em (horario_previsto)

## Constraints

- Nenhuma constraint adicional.

## Relacionamentos e Cardinalidade

- Nenhum relacionamento externo declarado.

## DependÃªncias

- Nenhuma dependÃªncia externa declarada.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.


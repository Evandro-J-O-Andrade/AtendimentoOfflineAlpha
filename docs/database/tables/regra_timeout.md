# regra_timeout

Objetivo: Armazenar regras de timeout para eventos específicos no sistema, permitindo controle de tempo de espera para diferentes status.

Descrição: Tabela que define regras de timeout para eventos do sistema, indicando quantos minutos uma tarefa deve ficar em determinado status antes de disparar um evento de timeout.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| status | varchar(50) | YES | NULL | Status do evento ao qual a regra de timeout se aplica |
| minutos | int | YES | NULL | Quantidade de minutos para disparo do timeout |
| evento_timeout | varchar(50) | YES | NULL | Nome do evento a ser disparado após o timeout |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde a regra aplica |

## Chaves
- Primária: -
- Únicas: -
- Estrangeiras: -

## Índices
- -

## Constraints
- -

## Relacionamentos e Cardinalidade
- -

## Dependências
- Tabelas que dependem desta: -
| Esta tabela depende de: -

## Fluxo de utilização dentro do sistema
- Configurada para definir tempo máximo em cada status
- Monitoramento de processos críticos que não devem ficar estagnados
- Permite SLA (Service Level Agreement) para atendimentos
- Integrado ao sistema de notificações e alertas
# assistencial_watchdog_fila

Objetivo: Monitorar e controlar o estado das filas de processamento do sistema assistencial, identificando congestionamentos e gargalos.

Descrição: Esta tabela implementa um watchdog para monitoramento de filas de processamento, registrando backlog de eventos, taxa de retry, estado do runtime e fornecendo visibilidade sobre a saúde das filas de atendimento.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_watchdog | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do registro de watchdog |
| unidade | varchar(100) | NOT NULL | - | Nome da unidade ou identificador do componente de fila monitorado |
| backlog_eventos | int | YES | '0' | Quantidade de eventos pendentes na fila de processamento |
| taxa_retry | decimal(10,4) | YES | '0.0000' | Taxa de eventos que necessitam retry de processamento |
| estado_runtime | enum('NORMAL','ATENCAO','SATURADO') | YES | 'NORMAL' | Estado atual da fila: NORMAL, ATENCAO (atenção) ou SATURADO |
| atualizado_em | datetime(6) | YES | CURRENT_TIMESTAMP(6) | Timestamp automático de atualização do registro de watchdog |
| id_atendimento | bigint unsigned | NOT NULL | - | Chave estrangeira que referencia o atendimento ao qual o watchdog pertence |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o watchdog pertence |

## Chaves
- Primária: id_watchdog
- Únicas: uk_watchdog_unidade (unidade) - Garante um único watchdog por unidade/componente
- Estrangeiras: fk_assistencial_watchdog_fila_atendimento - id_atendimento → atendimento(id_atendimento) ON DELETE CASCADE - Vincula o watchdog ao atendimento; fk_assistencial_watchdog_fila_entidade - id_entidade → saas_entidade(id_entidade) - Vincula o watchdog à entidade

## Índices
- uk_watchdog_unidade (KEY) - Índice único para garantir unicidade por unidade
- fk_assistencial_watchdog_fila_atendimento (KEY) - Índice para busca por atendimento
- idx_awf_ent (KEY) - Índice para busca por entidade

## Constraints
- uk_watchdog_unidade - UNIQUE - Garante unicidade do nome da unidade
- fk_assistencial_watchdog_fila_atendimento - FOREIGN KEY - Restringe id_atendimento à tabela atendimento(id_atendimento) com CASCADE DELETE
- fk_assistencial_watchdog_fila_entidade - FOREIGN KEY - Restringe id_entidade à tabela saas_entidade(id_entidade)

## Relacionamentos e Cardinalidade
- N:1 com atendimento - Cada watchdog está associado a um atendimento (com CASCADE)
- N:1 com saas_entidade - Cada watchdog pertence a uma entidade SaaS

## Dependências
- Tabelas que dependem desta: Nenhuma (não há FK apontando para assistencial_watchdog_fila)
- Tabelas das quais esta depende: atendimento, saas_entidade

## Fluxo de utilização dentro do sistema
- Monitoramento contínuo de backlog de eventos nas filas de processamento
- Taxa de retry para identificação de processos falhando
- Estados de runtime para visibilidade rápida da saúde da fila
- Unicidade garantida por UK para evitar watchdogs duplicados por unidade
- Cascade delete remove watchdog quando atendimento é excluído
- Timestamp automático para controle de última atualização
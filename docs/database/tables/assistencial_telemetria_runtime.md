# assistencial_telemetria_runtime

Objetivo: Registrar telemetria de componentes do runtime assistencial, coletando métricas de performance, criticidade e valores para monitoramento contínuo.

Descrição: Esta tabela armazena dados de telemetria do runtime assistencial, permitindo o monitoramento granular de componentes específicos, métricas, valores coletados, criticidade do evento e auditoria completa com vinculação ao atendimento.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_telemetria | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do registro de telemetria |
| componente | varchar(60) | NOT NULL | - | Nome ou identificador do componente monitorado (ex: DATABASE, CACHE, NETWORK) |
| metrica | varchar(60) | NOT NULL | - | Nome da métrica coletada (ex: LATENCY, THROUGHPUT, ERROR_RATE) |
| valor | decimal(18,6) | NOT NULL | - | Valor numérico da métrica medido, com alta precisão decimal |
| unidade | varchar(30) | YES | NULL | Unidade de medida do valor (ex: ms, req/sec, %) |
| criticidade | enum('INFO','WARNING','CRITICAL') | YES | 'INFO' | Nível de criticidade do dado coletado: informativo, alerta ou crítico |
| criado_em | datetime(6) | YES | CURRENT_TIMESTAMP(6) | Timestamp automático da data/hora de coleta da telemetria |
| id_atendimento | bigint unsigned | NOT NULL | - | Chave estrangeira que referencia o atendimento ao qual a telemetria pertence |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual a telemetria pertence |

## Chaves
- Primária: id_telemetria
- Únicas: Nenhuma
- Estrangeiras: fk_assistencial_telemetria_runtime_atendimento - id_atendimento → atendimento(id_atendimento) ON DELETE CASCADE - Vincula a telemetria ao atendimento; fk_assistencial_telemetria_runtime_entidade - id_entidade → saas_entidade(id_entidade) - Vincula a telemetria à entidade

## Índices
- idx_telemetria_lookup (KEY) - Índice composto por componente, metrica e criado_em para busca eficiente
- fk_assistencial_telemetria_runtime_atendimento (KEY) - Índice para busca por atendimento
- idx_atr_ent (KEY) - Índice para busca por entidade

## Constraints
- fk_assistencial_telemetria_runtime_atendimento - FOREIGN KEY - Restringe id_atendimento à tabela atendimento(id_atendimento) com CASCADE DELETE
- fk_assistencial_telemetria_runtime_entidade - FOREIGN KEY - Restringe id_entidade à tabela saas_entidade(id_entidade)

## Relacionamentos e Cardinalidade
- N:1 com atendimento - Cada registro de telemetria está associado a um atendimento (com CASCADE)
- N:1 com saas_entidade - Cada telemetria pertence a uma entidade SaaS

## Dependências
- Tabelas que dependem desta: Nenhuma (não há FK apontando para assistencial_telemetria_runtime)
- Tabelas das quais esta depende: atendimento, saas_entidade

## Fluxo de utilização dentro do sistema
- Coleta contínua de métricas de componentes do runtime assistencial
- Métrica e componente para classificação granular dos dados
- Valor com alta precisão para análise estatística
- Unidade de medida para interpretação correta dos valores
- Criticidade para priorização de alertas de monitoramento
- Índice composto para busca eficiente por componente, métrica e data
- Cascade delete remove telemetria quando atendimento é excluído
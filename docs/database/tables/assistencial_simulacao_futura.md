# assistencial_simulacao_futura

Objetivo: Armazenar simulações de cenários futuros para atendimentos assistenciais, prevendo carga e riscos para planejamento.

Descrição: Esta tabela registra simulações de eventos futuros no sistema assistencial, prevendo carga, risco de conflito federado, risco de backlog e recomendações de runtime para suporte à tomada de decisão preventiva.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_simulacao | bigint | NOT NULL | AUTO_INCREMENT | Identificador único da simulação futura |
| horizonte_minutos | int | NOT NULL | - | Horizonte de previsão em minutos para a simulação (ex: 1440 = 24h) |
| carga_prevista | decimal(10,4) | YES | NULL | Carga prevista de eventos ou processos no horizonte |
| risco_conflito_federado | decimal(10,4) | YES | NULL | Probabilidade de conflito em sincronização federada |
| risco_backlog | decimal(10,4) | YES | NULL | Probabilidade de acúmulo de backlog no horizonte |
| recomendacao_runtime | varchar(200) | YES | NULL | Recomendações de runtime com base na simulação |
| criado_em | datetime(6) | YES | CURRENT_TIMESTAMP(6) | Timestamp automático da data/hora de criação da simulação |
| id_atendimento | bigint unsigned | NOT NULL | - | Chave estrangeira que referencia o atendimento ao qual a simulação pertence |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual a simulação pertence |

## Chaves
- Primária: id_simulacao
- Únicas: Nenhuma
- Estrangeiras: fk_assistencial_simulacao_futura_atendimento - id_atendimento → atendimento(id_atendimento) ON DELETE CASCADE - Vincula a simulação ao atendimento; fk_assistencial_simulacao_futura_entidade - id_entidade → saas_entidade(id_entidade) - Vincula a simulação à entidade

## Índices
- idx_simulacao_horizonte (KEY) - Índice para busca por horizonte de previsão
- fk_assistencial_simulacao_futura_atendimento (KEY) - Índice para busca por atendimento
- idx_asf_ent (KEY) - Índice para busca por entidade

## Constraints
- fk_assistencial_simulacao_futura_atendimento - FOREIGN KEY - Restringe id_atendimento à tabela atendimento(id_atendimento) com CASCADE DELETE
- fk_assistencial_simulacao_futura_entidade - FOREIGN KEY - Restringe id_entidade à tabela saas_entidade(id_entidade)

## Relacionamentos e Cardinalidade
- N:1 com atendimento - Cada simulação está associada a um atendimento (com CASCADE)
- N:1 com saas_entidade - Cada simulação pertence a uma entidade SaaS

## Dependências
- Tabelas que dependem desta: Nenhuma (não há FK apontando para assistencial_simulacao_futura)
- Tabelas das quais esta depende: atendimento, saas_entidade

## Fluxo de utilização dentro do sistema
- Simulação de cenários futuros para planejamento de capacidade
- Previsão de carga com base em padrões históricos
- Avaliação de risco de conflito federado para sincronizações
- Previsão de backlog para identificação de gargalos futuros
- Recomendações de runtime para ações preventivas
- Horizonte configurável em minutos para diferentes janelas de previsão
- Cascade delete remove simulações quando atendimento é excluído
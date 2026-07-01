# assistencial_minipal_metric

Objetivo: Armazenar métricas consolidadas do sistema assistencial (MINIPAL - Minimal Intelligence Platform for Adaptive Logistics), incluindo scores de risco e indicadores de estabilidade.

Descrição: Esta tabela registra métricas agregadas do sistema assistencial para monitoramento de saúde do sistema, incluindo scores de risco de fila, evasão, retry, e estabilidade do runtime, permitindo o acompanhamento do desempenho e tomada de decisão baseada em dados.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_metric | bigint | NOT NULL | AUTO_INCREMENT | Identificador único da métrica registrada |
| id_sistema | bigint | NOT NULL | - | Identificador do sistema ao qual as métricas pertencem |
| id_unidade | bigint unsigned | NOT NULL | - | Identificador da unidade ao qual as métricas estão associadas |
| score_global | decimal(10,4) | YES | '0.0000' | Score global de performance do sistema assistencial |
| risco_fila | decimal(10,4) | YES | '0.0000' | Score de risco de congestionamento de fila |
| risco_evasao | decimal(10,4) | YES | '0.0000' | Score de risco de evasão de atendimentos ou dados |
| risco_retry | decimal(10,4) | YES | '0.0000' | Score de risco de necessidade de retry em processos |
| estabilidade_runtime | decimal(10,4) | YES | '0.0000' | Medida de estabilidade do runtime do sistema |
| estado_rede | varchar(40) | YES | 'NORMAL' | Estado da rede/ambiente: NORMAL ou outros estados indicativos de problemas |
| criado_em | datetime(6) | YES | CURRENT_TIMESTAMP(6) | Timestamp automático da data/hora de criação da métrica |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual as métricas pertencem |

## Chaves
- Primária: id_metric
- Únicas: Nenhuma
- Estrangeiras: Nenhuma

## Índices
- idx_minipal_lookup (KEY) - Índice composto por id_sistema e criado_em para busca por sistema e data

## Constraints
- Nenhuma constraint adicional definida

## Relacionamentos e Cardinalidade
- Esta tabela não possui relacionamentos com outras tabelas via foreign key

## Dependências
- Tabelas que dependem desta: Nenhuma (não há FK apontando para assistencial_minipal_metric)
- Tabelas das quais esta depende: Nenhuma

## Fluxo de utilização dentro do sistema
- Coleta periódica de métricas de desempenho do sistema assistencial
- Score global para avaliação geral de saúde do sistema
- Métricas específicas de risco (fila, evasão, retry) para identificação de gargalos
- Indicador de estabilidade do runtime para detecção de instabilidades
- Estado da rede para detecção de problemas de conectividade
- Índice para busca eficiente por sistema e período
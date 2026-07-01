# assistencial_raim_metric

Objetivo: Armazenar métricas RAIM (Risk Assessment for Inpatient Management) para avaliação de risco em atendimentos assistenciais.

Descrição: Esta tabela registra métricas específicas para avaliação de risco em gestão de atendimentos, incluindo scores de pressão de fila, taxa de evasão, saturação de leitos, backlog do runtime e recomendações de alerta.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_metric | bigint | NOT NULL | AUTO_INCREMENT | Identificador único da métrica RAIM |
| id_sistema | bigint | NOT NULL | - | Identificador do sistema ao qual as métricas pertencem |
| id_unidade | bigint unsigned | NOT NULL | - | Identificador da unidade ao qual as métricas estão associadas |
| fila_pressao | decimal(10,4) | YES | '0.0000' | Score que mede a pressão de congestionamento na fila de atendimento |
| taxa_evasao | decimal(10,4) | YES | '0.0000' | Taxa de evasão de atendimentos ou cancelamentos |
| saturacao_leito | decimal(10,4) | YES | '0.0000' | Medida de saturação dos leitos de internação |
| backlog_runtime | decimal(10,4) | YES | '0.0000' | Medida do backlog de processamento do runtime |
| score_raim | decimal(10,4) | YES | '0.0000' | Score agregado RAIM para avaliação de risco geral |
| alerta_recomendacao | varchar(255) | YES | NULL | Texto de recomendação ou alerta gerado com base nas métricas |
| criado_em | datetime(6) | YES | CURRENT_TIMESTAMP(6) | Timestamp automático da data/hora de criação da métrica |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual as métricas pertencem |

## Chaves
- Primária: id_metric
- Únicas: Nenhuma
- Estrangeiras: Nenhuma

## Índices
- idx_raim_lookup (KEY) - Índice composto por id_sistema e criado_em para busca por sistema

## Constraints
- Nenhuma constraint adicional definida

## Relacionamentos e Cardinalidade
- Esta tabela não possui relacionamentos com outras tabelas via foreign key

## Dependências
- Tabelas que dependem desta: Nenhuma (não há FK apontando para assistencial_raim_metric)
- Tabelas das quais esta depende: Nenhuma

## Fluxo de utilização dentro do sistema
- Avaliação contínua de risco em gestão de atendimentos hospitalares
- Métricas de pressão de fila para identificação de congestionamentos
- Taxa de evasão para monitoramento de cancelamentos e não comparecimentos
- Saturação de leitos para gestão de capacidade de internação
- Backlog do runtime para detecção de processos pendentes
- Score agregado RAIM para visão geral de risco
- Recomendações automáticas baseadas nas métricas para ação preventiva
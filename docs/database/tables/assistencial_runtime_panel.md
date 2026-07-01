# assistencial_runtime_panel

Objetivo: Monitorar e exibir indicadores de saúde do runtime assistencial em um painel centralizado, permitindo acompanhamento em tempo real.

Descrição: Esta tabela armazena métricas de saúde do runtime assistencial para exibição em painéis de monitoramento, incluindo scores de health, backlog federado, taxas de retry, hit rates e recomendações preventivas.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_panel | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do painel de runtime |
| health_score_runtime | decimal(10,4) | YES | '0.0000' | Score de saúde geral do runtime assistencial |
| backlog_federado | int | YES | '0' | Quantidade de eventos em backlog aguardando sincronização federada |
| retry_rate | decimal(10,4) | YES | '0.0000' | Taxa de retry de processamento de eventos |
| hash_hit_rate | decimal(10,4) | YES | '0.0000' | Taxa de acertos de cache via hash |
| tombstone_hit_rate | decimal(10,4) | YES | '0.0000' | Taxa de acertos de tombstone (marcação de exclusão) |
| divergencia_edge_nucleo | decimal(10,4) | YES | '0.0000' | Medida de divergência entre nós edge e núcleo |
| estado_runtime | varchar(60) | YES | 'NORMAL' | Estado atual do runtime: NORMAL ou estados de alerta |
| alerta_preventivo | varchar(120) | YES | NULL | Mensagem de alerta preventivo para ação proativa |
| atualizado_em | datetime(6) | YES | CURRENT_TIMESTAMP(6) | Timestamp automático de atualização do painel |
| id_atendimento | bigint unsigned | NOT NULL | - | Chave estrangeira que referencia o atendimento ao qual o painel pertence |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o painel pertence |

## Chaves
- Primária: id_panel
- Únicas: uk_runtime_panel (id_panel) - Garante unicidade do id_panel
- Estrangeiras: fk_assistencial_runtime_panel_atendimento - id_atendimento → atendimento(id_atendimento) ON DELETE CASCADE - Vincula o painel ao atendimento; fk_assistencial_runtime_panel_entidade - id_entidade → saas_entidade(id_entidade) - Vincula o painel à entidade

## Índices
- uk_runtime_panel (KEY) - Índice único para id_panel
- fk_assistencial_runtime_panel_atendimento (KEY) - Índice para busca por atendimento
- idx_arp_ent (KEY) - Índice para busca por entidade

## Constraints
- uk_runtime_panel - UNIQUE - Garante unicidade do id_panel
- fk_assistencial_runtime_panel_atendimento - FOREIGN KEY - Restringe id_atendimento à tabela atendimento(id_atendimento) com CASCADE DELETE
- fk_assistencial_runtime_panel_entidade - FOREIGN KEY - Restringe id_entidade à tabela saas_entidade(id_entidade)

## Relacionamentos e Cardinalidade
- N:1 com atendimento - Cada painel está associado a um atendimento (com CASCADE)
- N:1 com saas_entidade - Cada painel pertence a uma entidade SaaS

## Dependências
- Tabelas que dependem desta: Nenhuma (não há FK apontando para assistencial_runtime_panel)
- Tabelas das quais esta depende: atendimento, saas_entidade

## Fluxo de utilização dentro do sistema
- Exibição de indicadores de saúde do runtime em painéis de monitoramento
- Tracking de backlog federado para identificar sincronizações pendentes
- Métricas de retry rate para detecção de falhas repetidas
- Hit rates de hash e tombstone para otimização de cache
- Medida de divergência edge-núcleo para garantir consistência
- Alertas preventivos para ação proativa antes de degradação
- Cascade delete remove painel quando atendimento é excluído
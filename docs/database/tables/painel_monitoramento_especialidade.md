# painel_monitoramento_especialidade

Objetivo: Configurar o monitoramento de especialidades por painel.
Descrição: Tabela que define quais especialidades devem ser monitoradas por cada painel, permitindo configuração de exibição de métricas por especialidade e local.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_cfg | bigint | NOT NULL | - | Identificador único da configuração (chave primária, auto incremento) |
| id_painel | bigint | NOT NULL | - | ID do painel que deve monitorar a especialidade |
| id_especialidade | bigint | NOT NULL | - | ID da especialidade a ser monitorada |
| id_local_operacional | bigint | YES | NULL | ID do local operacional específico (opcional) |
| ordem | int | NOT NULL | '1' | Ordem de exibição da especialidade no painel |
| ativo | tinyint(1) | NOT NULL | '1' | Flag indicando se a monitoração está ativa |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual a configuração pertence |

## Chaves
- Primária: id_cfg
- Únicas: (nenhuma)
- Estrangeiras: 
  - fk_cfg_painel: id_painel → painel (id_painel)

## Índices
- PRIMARY KEY (id_cfg)
- KEY idx_cfg_painel (id_painel)
- KEY idx_cfg_local_operacional (id_local_operacional)

## Constraints
- PRIMARY KEY: id_cfg
- FOREIGN KEY: fk_cfg_painel

## Relacionamentos e Cardinalidade
- N:1 com painel: Muitas configurações pertencem a um painel
- N:1 com especialidade: Muitas configurações pertencem a uma especialidade
- N:1 com local_operacional: Muitas configurações podem estar associadas a um local operacional

## Dependências
- Esta tabela depende de: painel, especialidade, local_operacional, saas_entidade
- Não há tabelas que dependem desta tabela

## Fluxo de utilização dentro do sistema
Utilizada para configurar quais métricas de especialidade cada painel deve exibir. Por exemplo, um painel de triagem pode monitorar a especialidade de Clínica Médica com ordem 1, Cardiologia com ordem 2, etc. Permite personalização do monitoramento por área de atendimento.
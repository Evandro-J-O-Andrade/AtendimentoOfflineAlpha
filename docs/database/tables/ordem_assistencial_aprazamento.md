# ordem_assistencial_aprazamento

Objetivo: Agendar a execução de itens de ordem assistencial em horários específicos (aprazamento).
Descrição: Tabela responsável por gerenciar o agendamento de execução dos itens das ordens assistenciais, definindo quando cada item deve ser realizado. Controla o status de cada agendamento e permite registrar a execução, estorno ou não realização.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_aprazamento | bigint | NOT NULL | - | Identificador único do agendamento (chave primária, auto incremento) |
| id_item | bigint | NOT NULL | - | ID do item da ordem assistencial a ser executado |
| previsto_em | datetime | NOT NULL | - | Data/hora prevista para execução do item |
| status | enum('PENDENTE','REALIZADO','NAO_REALIZADO','ESTORNADO','SUSPENSO','CANCELADO') | NOT NULL | 'PENDENTE' | Status atual do agendamento de execução |
| executado_em | datetime | YES | NULL | Data/hora em que a execução foi realizada |
| id_usuario_execucao | bigint | YES | NULL | ID do usuário que executou o item |
| id_sessao_usuario_execucao | bigint | YES | NULL | ID da sessão do usuário durante a execução |
| id_local_operacional_execucao | bigint | YES | NULL | ID do local operacional onde a execução ocorreu |
| observacao | text | YES | - | Observações adicionais sobre o agendamento ou execução |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data/hora de criação do registro |
| criado_por | bigint | YES | NULL | ID do usuário que criou o agendamento |
| id_sessao_usuario_criado | bigint | YES | NULL | ID da sessão do usuário durante a criação |
| id_atendimento | bigint unsigned | NOT NULL | - | ID do atendimento ao qual a ordem está vinculada |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual o agendamento pertence |

## Chaves
- Primária: id_aprazamento
- Únicas: uk_apraz_item_previsto (id_item, previsto_em)
- Estrangeiras: 
  - fk_apraz_exec_local: id_local_operacional_execucao → local_operacional (id_local_operacional)
  - fk_apraz_exec_user: id_usuario_execucao → usuario (id_usuario)
  - fk_apraz_item: id_item → ordem_assistencial_item (id_item)
  - fk_ordem_assistencial_aprazamento_atendimento: id_atendimento → atendimento (id_atendimento) com CASCADE
  - fk_ordem_assistencial_aprazamento_entidade: id_entidade → saas_entidade (id_entidade)

## Índices
- PRIMARY KEY (id_aprazamento)
- UNIQUE KEY uk_apraz_item_previsto (id_item, previsto_em)
- KEY idx_apraz_status_previsto (status, previsto_em)
- KEY fk_apraz_exec_user (id_usuario_execucao)
- KEY fk_apraz_exec_sessao (id_sessao_usuario_execucao)
- KEY fk_apraz_exec_local (id_local_operacional_execucao)
- KEY fk_ordem_assistencial_aprazamento_atendimento (id_atendimento)
- KEY idx_oassa_ent (id_entidade)

## Constraints
- PRIMARY KEY: id_aprazamento
- UNIQUE: uk_apraz_item_previsto
- FOREIGN KEY: fk_apraz_exec_local
- FOREIGN KEY: fk_apraz_exec_user
- FOREIGN KEY: fk_apraz_item
- FOREIGN KEY: fk_ordem_assistencial_aprazamento_atendimento
- FOREIGN KEY: fk_ordem_assistencial_aprazamento_entidade

## Relacionamentos e Cardinalidade
- N:1 com ordem_assistencial_item: Muitos agendamentos pertencem a um item de ordem
- N:1 com ordem_assistencial_execucao: Muitas execuções podem referenciar um aprazamento
- N:1 com usuario: Muitos agendamentos executados por um usuário
- N:1 com local_operacional: Muitos agendamentos ocorrem em um local operacional
- N:1 com atendimento: Muitos agendamentos pertencem a um atendimento

## Dependências
- Esta tabela depende de: ordem_assistencial_item, usuario, local_operacional, atendimento, saas_entidade
- Tabelas que dependem desta: ordem_assistencial_execucao

## Fluxo de utilização dentro do sistema
Quando uma ordem assistencial é criada com itens que precisam de agendamento (como medicações, exames), cada item é registrado nesta tabela com sua data/hora prevista. Em seguida, quando o item é executado, a tabela ordem_assistencial_execucao é usada para registrar a ação. Permite controle de quando cada item foi realmente executado versus quando deveria ser executado.
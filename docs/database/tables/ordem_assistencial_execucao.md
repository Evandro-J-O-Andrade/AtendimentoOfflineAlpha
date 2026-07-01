# ordem_assistencial_execucao

Objetivo: Registrar a execução efetiva dos itens de ordem assistencial.
Descrição: Tabela responsável por registrar quando um item de ordem assistencial foi realmente executado, não realizado ou estornado. Mantém o histórico de execuções com quantidade aplicada, local e observações.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_execucao | bigint | NOT NULL | - | Identificador único da execução (chave primária, auto incremento) |
| id_item | bigint | NOT NULL | - | ID do item da ordem assistencial executado |
| id_aprazamento | bigint | YES | NULL | ID do agendamento (aprazamento) ao qual esta execução está vinculada (opcional) |
| acao | enum('REALIZADO','NAO_REALIZADO','ESTORNADO') | NOT NULL | - | Tipo de ação executada: realizado, não realizado ou estornado |
| quantidade | decimal(10,2) | YES | NULL | Quantidade do item que foi executada |
| realizado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data/hora da execução |
| id_usuario | bigint | NOT NULL | - | ID do usuário que realizou a ação |
| id_sessao_usuario | bigint | NOT NULL | - | ID da sessão do usuário durante a execução |
| id_local_operacional | bigint | YES | NULL | ID do local operacional onde a execução ocorreu |
| observacao | text | YES | - | Observações sobre a execução |
| payload | json | YES | NULL | Dados adicionais da execução em formato JSON |
| id_atendimento | bigint unsigned | NOT NULL | - | ID do atendimento ao qual a execução está vinculada |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual a execução pertence |

## Chaves
- Primária: id_execucao
- Únicas: (nenhuma)
- Estrangeiras: 
  - fk_exec_apraz: id_aprazamento → ordem_assistencial_aprazamento (id_aprazamento)
  - fk_exec_item: id_item → ordem_assistencial_item (id_item)
  - fk_ordem_assistencial_execucao_atendimento: id_atendimento → atendimento (id_atendimento) com CASCADE
  - fk_ordem_assistencial_execucao_entidade: id_entidade → saas_entidade (id_entidade)

## Índices
- PRIMARY KEY (id_execucao)
- KEY idx_exec_item_data (id_item, realizado_em)
- KEY idx_exec_apraz (id_aprazamento)
- KEY fk_ordem_assistencial_execucao_atendimento (id_atendimento)
- KEY idx_oasse_ent (id_entidade)

## Constraints
- PRIMARY KEY: id_execucao
- FOREIGN KEY: fk_exec_apraz
- FOREIGN KEY: fk_exec_item
- FOREIGN KEY: fk_ordem_assistencial_execucao_atendimento
- FOREIGN KEY: fk_ordem_assistencial_execucao_entidade

## Relacionamentos e Cardinalidade
- N:1 com ordem_assistencial_item: Muitas execuções pertencem a um item
- N:1 com ordem_assistencial_aprazamento: Muitas execuções podem referenciar um agendamento
- N:1 com usuario: Muitas execuções realizadas por um usuário
- N:1 com local_operacional: Muitas execuções ocorrem em um local operacional
- N:1 com atendimento: Muitas execuções pertencem a um atendimento

## Dependências
- Esta tabela depende de: ordem_assistencial_item, ordem_assistencial_aprazamento, usuario, local_operacional, atendimento, saas_entidade
- Não há tabelas que dependem desta tabela

## Fluxo de utilização dentro do sistema
Utilizada após o agendamento de itens para registrar a execução efetiva. Quando um enfermeiro ou técnico administra um medicamento ou realiza um procedimento, um registro é criado aqui com o usuário responsável, data/hora, quantidade aplicada e observações. Permite auditoria completa de execuções versus agendamentos.
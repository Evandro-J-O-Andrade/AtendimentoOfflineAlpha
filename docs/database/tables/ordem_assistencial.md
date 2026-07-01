# ordem_assistencial

Objetivo: Gerenciar ordens assistenciais (prescrições, solicitações e pedidos) emitidas durante atendimentos médicos.
Descrição: Tabela central para controle de ordens clínicas emitidas no decorrer de um atendimento, como medicamentos, dietas, procedimentos, exames e cuidados. Cada ordem tem status de controle (ativa, suspensa, encerrada) e está associada a um atendimento específico.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id | bigint | NOT NULL | - | Identificador único da ordem assistencial (chave primária, auto incremento) |
| id_ffa | bigint | NOT NULL | - | ID do Fluxo de Atendimento Assistencial (FFA) associado à ordem |
| tipo_ordem | varchar(50) | NOT NULL | - | Tipo da ordem (ex: MEDICACAO, EXAME, PROCEDIMENTO, DIETA) |
| status | enum('ATIVA','SUSPENSA','ENCERRADA') | NOT NULL | 'ATIVA' | Status atual da ordem no fluxo clínico |
| origem | enum('MEDICO','ENFERMAGEM') | NOT NULL | - | Origem da ordem: criada por médico ou enfermagem |
| payload_clinico | json | NOT NULL | - | Dados clínicos adicionais da ordem em formato JSON |
| prioridade | int | YES | '0' | Nível de prioridade da ordem (0 = normal, valores maiores = prioridade alta) |
| iniciado_em | datetime | YES | CURRENT_TIMESTAMP | Data/hora em que a ordem foi iniciada |
| suspenso_em | datetime | YES | NULL | Data/hora em que a ordem foi suspensa (preenchido quando status=SUSPENSA) |
| encerrado_em | datetime | YES | NULL | Data/hora em que a ordem foi encerrada (preenchido quando status=ENCERRADA) |
| motivo_suspensao | varchar(255) | YES | NULL | Justificativa para suspensão da ordem |
| motivo_encerramento | varchar(255) | YES | NULL | Justificativa para encerramento da ordem |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data/hora de criação do registro |
| criado_por | bigint | NOT NULL | - | ID do usuário que criou a ordem |
| atualizado_em | datetime | YES | NULL | Data/hora da última atualização |
| atualizado_por | bigint | YES | NULL | ID do usuário que atualizou a ordem |
| id_atendimento | bigint unsigned | NOT NULL | - | ID do atendimento ao qual a ordem está vinculada |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual a ordem pertence |

## Chaves
- Primária: id
- Únicas: (nenhuma)
- Estrangeiras: 
  - fk_ordem_assistencial_atendimento: id_atendimento → atendimento (id_atendimento) com CASCADE
  - fk_ordem_assistencial_entidade: id_entidade → saas_entidade (id_entidade)

## Índices
- PRIMARY KEY (id)
- KEY idx_ordem_ffa (id_ffa)
- KEY idx_ordem_status (status)
- KEY idx_ordem_tipo (tipo_ordem)
- KEY fk_ordem_assistencial_atendimento (id_atendimento)
- KEY idx_oass_ent (id_entidade)

## Constraints
- PRIMARY KEY: id
- FOREIGN KEY: fk_ordem_assistencial_atendimento
- FOREIGN KEY: fk_ordem_assistencial_entidade

## Relacionamentos e Cardinalidade
- 1:N com atendimento: Uma ordem assistencial pertence a um atendimento; um atendimento pode ter múltiplas ordens
- 1:N com ordem_assistencial_item: Uma ordem assistencial possui múltiplos itens
- 1:N com ordem_assistencial_aprazamento: Uma ordem pode ter múltiplos agendamentos de execução
- 1:N com ordem_assistencial_execucao: Uma ordem pode ter múltiplas execuções registradas

## Dependências
- Esta tabela depende de: atendimento, saas_entidade
- Tabelas que dependem desta: ordem_assistencial_item, ordem_assistencial_aprazamento, ordem_assistencial_execucao

## Fluxo de utilização dentro do sistema
Utilizada quando profissionais de saúde criam ordens durante um atendimento. O médico ou enfermeiro cria uma ordem com itens específicos, que podem ser suspensos ou encerrados conforme evolução do caso. Os itens da ordem são agendados para execução (aprazamento) e cada execução é registrada. Controla todo o ciclo de vida de ordens clínicas.
# agendamentos_eventos

Objetivo: Registrar eventos relacionados a agendamentos, como criação, reagendamento, cancelamento, check-in, início, conclusão e não comparecimento.

Descrição: Esta tabela mantém um histórico de eventos ocorridos com agendamentos, permitindo o rastreamento de mudanças de status, check-ins e outras ações relevantes durante o ciclo de vida do agendamento, com auditoria completa de usuário e sessão.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_evento | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do evento de agendamento |
| id_agendamento | bigint | NOT NULL | - | Chave estrangeira que referencia o agendamento ao qual o evento pertence, vinculada à tabela agendamentos |
| tipo | enum('CRIADO','REAGENDADO','CANCELADO','CHECKIN','INICIADO','CONCLUIDO','NAO_COMPARECEU','OBSERVACAO') | NOT NULL | - | Tipo de evento: CRIADO, REAGENDADO, CANCELADO, CHECKIN, INICIADO, CONCLUIDO, NAO_COMPARECEU, OBSERVACAO |
| detalhe | text | YES | NULL | Campo de texto livre com detalhes adicionais sobre o evento |
| de_status | varchar(30) | YES | NULL | Status anterior do agendamento antes do evento ocorrer |
| para_status | varchar(30) | YES | NULL | Status posterior do agendamento após o evento ocorrer |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Timestamp automático da data/hora de criação do evento |
| id_usuario | bigint | NOT NULL | - | Chave estrangeira que referencia o usuário que registrou o evento |
| id_sessao_usuario | bigint | YES | NULL | Chave estrangeira que referencia a sessão do usuário no momento do evento |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o evento pertence |

## Chaves
- Primária: id_evento
- Únicas: Nenhuma
- Estrangeiras: fk_agev_agendamento - id_agendamento → agendamentos(id_agendamento) - Vincula o evento ao agendamento; fk_agev_sessao - id_sessao_usuario → sessao_usuario(id_sessao_usuario) - Vincula o evento à sessão do usuário; fk_agev_usuario - id_usuario → usuario(id_usuario) - Vincula o evento ao usuário responsável

## Índices
- ix_agev_agendamento (KEY) - Índice composto por id_agendamento e criado_em para busca por agendamento e data
- fk_agev_usuario (KEY) - Índice para busca por usuário
- fk_agev_sessao (KEY) - Índice para busca por sessão

## Constraints
- fk_agev_agendamento - FOREIGN KEY - Restringe id_agendamento à tabela agendamentos(id_agendamento)
- fk_agev_sessao - FOREIGN KEY - Restringe id_sessao_usuario à tabela sessao_usuario(id_sessao_usuario)
- fk_agev_usuario - FOREIGN KEY - Restringe id_usuario à tabela usuario(id_usuario)

## Relacionamentos e Cardinalidade
- N:1 com agendamentos - Cada evento está associado a um único agendamento
- N:1 com sessao_usuario - Cada evento pode ter uma sessão associada (opcional)
- N:1 com usuario - Cada evento é registrado por um único usuário

## Dependências
- Tabelas que dependem desta: Nenhuma (não há FK apontando para agendamentos_eventos)
- Tabelas das quais esta depende: agendamentos, sessao_usuario, usuario

## Fluxo de utilização dentro do sistema
- Registro automático de eventos de ciclo de vida do agendamento
- Rastreamento de mudanças de status (de_status → para_status)
- Check-in de pacientes no horário do agendamento
- Registro de não comparecimento para estatísticas
- Auditoria completa com usuário e sessão para cada evento
- Busca eficiente por agendamento e data via índice composto
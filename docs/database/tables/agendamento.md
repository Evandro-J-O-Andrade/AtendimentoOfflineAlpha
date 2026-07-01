# agendamento

Objetivo: Registrar agendamentos de atendimentos médicos, contendo informações de profissional, paciente, serviço, período e status do agendamento.

Descrição: Esta tabela centraliza os agendamentos no sistema, controlando a marcação de consultas, exames e atendimentos com informações completas de período, profissional responsável, paciente, serviço agendado, origem do agendamento, e mecanismos de sincronização e controle de estado.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_agendamento | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do agendamento |
| id_sistema | bigint | NOT NULL | - | Chave estrangeira que referencia o sistema ao qual o agendamento pertence |
| id_unidade | bigint unsigned | YES | NULL | Chave estrangeira que referencia a unidade onde ocorrerá o atendimento agendado |
| id_local_operacional | bigint | YES | NULL | Chave estrangeira que referencia o local operacional específico do agendamento |
| id_profissional | bigint | YES | NULL | Identificador do profissional responsável pelo atendimento agendado |
| id_paciente | bigint | YES | NULL | Chave estrangeira que referencia o paciente que tem o atendimento agendado |
| id_ffa | bigint unsigned | YES | NULL | Chave estrangeira que referencia a FFA (Ficha de Atendimento) associada ao agendamento |
| id_senha | bigint unsigned | YES | NULL | Identificador da senha de atendimento, quando aplicável |
| id_servico | bigint | NOT NULL | - | Chave estrangeira que referencia o serviço/procedimento agendado |
| inicio_em | datetime(6) | NOT NULL | - | Data e hora de início do atendimento agendado com precisão de microsegundos |
| fim_em | datetime(6) | NOT NULL | - | Data e hora de fim do atendimento agendado com precisão de microsegundos |
| duracao_minutos | int | YES | GENERATED | Campo calculado automaticamente (stored) com a duração em minutos entre início e fim |
| status | varchar(40) | NOT NULL | - | Status atual do agendamento (ex: AGENDADO, CONFIRMADO, CANCELADO, CONCLUIDO) |
| origem | varchar(40) | NOT NULL | - | Origem do agendamento (ex: SUS, PARTICULAR, CONVENIO, ONLINE) |
| observacao | text | YES | NULL | Campo de texto livre para observações sobre o agendamento |
| criado_em | datetime(6) | NOT NULL | CURRENT_TIMESTAMP(6) | Timestamp automático de criação do agendamento com precisão de microsegundos |
| atualizado_em | datetime(6) | YES | NULL | Timestamp automático de atualização do agendamento com precisão de microsegundos |
| criado_por | bigint | NOT NULL | - | Identificador do usuário que criou o agendamento |
| id_sessao_criacao | bigint | YES | NULL | Chave estrangeira que referencia a sessão do usuário no momento da criação |
| uuid_sync | char(36) | NOT NULL | - | UUID para sincronização entre sistemas, garantindo unicidade global |
| versao_sync | bigint | YES | '0' | Versão de sincronização para controle de conflitos de atualização |
| hash_estado | char(64) | YES | NULL | Hash do estado atual para detecção de alterações e consistência |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o agendamento pertence |

## Chaves
- Primária: id_agendamento
- Únicas: Nenhuma
- Estrangeiras: fk_ag_paciente - id_paciente → paciente(id) - Vincula o agendamento ao paciente; fk_ag_prof - id_profissional → usuario(id_usuario) - Vincula o agendamento ao profissional; fk_ag_servico - id_servico → servico(id_servico) - Vincula o agendamento ao serviço agendado

## Índices
- idx_ag_prof (KEY) - Índice composto por id_profissional e inicio_em para busca por profissional e data
- idx_ag_local (KEY) - Índice composto por id_local_operacional e inicio_em
- idx_ag_paciente (KEY) - Índice composto por id_paciente e inicio_em
- idx_ag_ffa (KEY) - Índice composto por id_ffa e inicio_em
- idx_ag_senha (KEY) - Índice para busca por senha
- idx_ag_ctx_inicio (KEY) - Índice composto por id_sistema, id_unidade e inicio_em
- fk_ag_servico (KEY) - Índice para busca por serviço
- fk_ag_sessao (KEY) - Índice para busca por sessão
- fk_ag_unidade (KEY) - Índice para busca por unidade
- fk_agendamento_entidade (KEY) - Índice para busca por entidade

## Constraints
- fk_ag_paciente - FOREIGN KEY - Restringe id_paciente à tabela paciente(id)
- fk_ag_prof - FOREIGN KEY - Restringe id_profissional à tabela usuario(id_usuario)
- fk_ag_servico - FOREIGN KEY - Restringe id_servico à tabela servico(id_servico)

## Relacionamentos e Cardinalidade
- N:1 com sistema - Cada agendamento pertence a um sistema
- N:1 com unidade - Cada agendamento pode estar associado a uma unidade (opcional)
- N:1 com local_operacional - Cada agendamento pode ter um local específico (opcional)
- N:1 com usuario (profissional) - Cada agendamento pode ter um profissional responsável (opcional)
- N:1 com paciente - Cada agendamento pode estar associado a um paciente (opcional)
- N:1 com ffa - Cada agendamento pode estar associado a uma FFA (opcional)
- N:1 com senha - Cada agendamento pode ter uma senha associada (opcional)
- N:1 com servico - Cada agendamento tem um serviço agendado

## Dependências
- Tabelas que dependem desta: agendamentos_eventos (via id_agendamento), atendimento (via uuid_sync), Nenhuma outra tabela possui FK apontando diretamente para agendamento
- Tabelas das quais esta depende: sistema, unidade, local_operacional, usuario, paciente, ffa, senha, servico

## Fluxo de utilização dentro do sistema
- Criação de agendamentos para atendimentos médicos, exames e consultas
- Cálculo automático de duração do agendamento
- Sincronização entre sistemas via uuid_sync e versao_sync
- Controle de estado via hash_estado para detecção de alterações
- Auditoria completa com sessão e usuário criador
- Busca eficiente por profissional, paciente, unidade ou período via índices compostos
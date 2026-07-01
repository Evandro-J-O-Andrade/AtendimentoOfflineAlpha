# agenda_disponibilidade

Objetivo: Gerenciar a disponibilidade de profissionais para atendimentos, registrando horários disponíveis, bloqueios de agenda, e informações de recorrência.

Descrição: Esta tabela controla a agenda e disponibilidade de profissionais no sistema, permitindo o registro de períodos disponíveis para atendimentos ou bloqueios (como férias, reuniões, etc.), com suporte a recorrência semanal e informações de auditoria de criação.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_disponibilidade | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do registro de disponibilidade |
| id_sistema | bigint | NOT NULL | - | Chave estrangeira que referencia o sistema ao qual esta disponibilidade está associada |
| id_unidade | bigint unsigned | YES | NULL | Chave estrangeira que referencia a unidade onde o profissional atua |
| id_profissional | bigint | NOT NULL | - | Chave estrangeira que referencia o usuário profissional cuja disponibilidade está sendo registrada |
| id_local_operacional | bigint | YES | NULL | Chave estrangeira que referencia o local operacional específico onde o profissional estará disponível |
| tipo | enum('ATENDIMENTO','BLOQUEIO') | NOT NULL | - | Tipo de disponibilidade: ATENDIMENTO (horário disponível) ou BLOQUEIO (horário indisponível) |
| inicio_em | datetime | NOT NULL | - | Data e hora de início do período de disponibilidade ou bloqueio |
| fim_em | datetime | NOT NULL | - | Data e hora de fim do período de disponibilidade ou bloqueio |
| recorrente | tinyint(1) | NOT NULL | '0' | Flag que indica se o horário é recorrente (1) ou único (0) |
| dia_semana | tinyint | YES | NULL | Dia da semana para recorrência: 0=Dom .. 6=Sab (quando recorrente=1) |
| ativo | tinyint(1) | YES | '1' | Flag que indica se o registro de disponibilidade está ativo |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Timestamp automático da data/hora de criação do registro |
| id_usuario_criador | bigint | NOT NULL | - | Chave estrangeira que referencia o usuário que criou este registro de disponibilidade |
| id_sessao_usuario | bigint | YES | NULL | Chave estrangeira que referencia a sessão do usuário no momento da criação |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o registro pertence |

## Chaves
- Primária: id_disponibilidade
- Únicas: Nenhuma
- Estrangeiras: fk_disp_local - id_local_operacional → local_operacional(id_local_operacional) - Vincula o registro ao local operacional; fk_disp_prof - id_profissional → usuario(id_usuario) - Vincula o registro ao profissional; fk_disp_sessao - id_sessao_usuario → sessao_usuario(id_sessao_usuario) - Vincula o registro à sessão do usuário; fk_disp_sistema - id_sistema → sistema(id_sistema) - Vincula o registro ao sistema; fk_disp_user - id_usuario_criador → usuario(id_usuario) - Vincula o registro ao usuário criador

## Índices
- ix_disp_prof (KEY) - Índice composto por id_profissional, inicio_em, fim_em para busca por profissional e período
- ix_disp_ctx (KEY) - Índice composto por id_sistema, id_unidade, inicio_em para contexto de busca
- ix_disp_local (KEY) - Índice composto por id_local_operacional, inicio_em
- fk_disp_unidade (KEY) - Índice para busca por unidade
- fk_disp_user (KEY) - Índice para busca por usuário criador
- fk_disp_sessao (KEY) - Índice para busca por sessão

## Constraints
- fk_disp_local - FOREIGN KEY - Restringe id_local_operacional à tabela local_operacional(id_local_operacional)
- fk_disp_prof - FOREIGN KEY - Restringe id_profissional à tabela usuario(id_usuario)
- fk_disp_sessao - FOREIGN KEY - Restringe id_sessao_usuario à tabela sessao_usuario(id_sessao_usuario)
- fk_disp_sistema - FOREIGN KEY - Restringe id_sistema à tabela sistema(id_sistema)
- fk_disp_user - FOREIGN KEY - Restringe id_usuario_criador à tabela usuario(id_usuario)

## Relacionamentos e Cardinalidade
- N:1 com sistema - Cada disponibilidade está associada a um sistema
- N:1 com unidade - Cada disponibilidade pode estar associada a uma unidade (opcional)
- N:1 com usuario (profissional) - Cada disponibilidade está vinculada a um profissional
- N:1 com local_operacional - Cada disponibilidade pode estar associada a um local específico (opcional)
- N:1 com sessao_usuario - Cada registro pode ter uma sessão associada (opcional)
- N:1 com usuario (criador) - Cada registro tem um usuário criador

## Dependências
- Tabelas que dependem desta: Nenhuma (não há FK apontando para agenda_disponibilidade)
- Tabelas das quais esta depende: sistema, unidade, usuario (2x), local_operacional, sessao_usuario

## Fluxo de utilização dentro do sistema
- Registro da agenda de profissionais para atendimentos
- Controle de bloqueios de agenda para férias, reuniões, eventos, etc.
- Suporte a recorrência semanal para agendas fixas
- Relacionamento com sessão para auditoria completa
- Busca eficiente por disponibilidade em períodos específicos via índices compostos
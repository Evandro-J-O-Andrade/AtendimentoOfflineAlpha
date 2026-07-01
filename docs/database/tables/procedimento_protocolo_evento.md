# procedimento_protocolo_evento

Objetivo: Registrar eventos de execução e alterações em protocolos de procedimentos médicos, com histórico completo de atividades.

Descrição: Tabela que armazena o histórico de eventos ocorridos durante a execução de um protocolo de procedimento, permitindo auditoria completa das ações realizadas no decorrer do processo.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_evento | bigint | NOT NULL | - | Chave primária da tabela, identificador único do evento |
| id_protocolo | bigint | NOT NULL | - | Referência ao id do protocolo de procedimento ao qual o evento pertence |
| tipo_evento | varchar(30) | NOT NULL | - | Tipo do evento ocorrido (ex: INICIADO, FINALIZADO, CANCELADO, etc.) |
| detalhe | text | YES | NULL | Detalhes complementares sobre o evento ocorrido |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data e hora de criação do registro do evento |
| id_sessao_usuario | bigint | YES | NULL | Referência ao id da sessão do usuário que realizou a ação |
| id_usuario | bigint | YES | NULL | Referência ao id do usuário que realizou a ação |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde o evento ocorreu |

## Chaves
- Primária: id_evento
- Únicas: -
- Estrangeiras: fk_pp_evt_proto (id_protocolo → procedimento_protocolo.id_protocolo) - vincula o evento ao protocolo; fk_pp_evt_user (id_usuario → usuario.id_usuario) - identifica o usuário que realizou a ação

## Índices
- PRIMARY KEY (id_evento)
- KEY idx_evt_proto (id_protocolo, criado_em)
- KEY idx_evt_tipo (tipo_evento, criado_em)
- KEY idx_evt_sessao (id_sessao_usuario, criado_em)
- KEY fk_pp_evt_user (id_usuario)

## Constraints
- CONSTRAINT fk_pp_evt_proto FOREIGN KEY (id_protocolo) REFERENCES procedimento_protocolo (id_protocolo)
- CONSTRAINT fk_pp_evt_user FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)

## Relacionamentos e Cardinalidade
- N:1 com procedimento_protocolo (um protocolo pode ter vários eventos)
- N:1 com usuario (um usuário pode registrar vários eventos)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: procedimento_protocolo, usuario

## Fluxo de utilização dentro do sistema
- Registrado automaticamente quando ocorre uma mudança de status no protocolo
- Permite auditoria completa do processo de execução do procedimento
- Vinculado ao usuário que realizou cada ação
- Utilizado para rastrear histórico e responsabilidades
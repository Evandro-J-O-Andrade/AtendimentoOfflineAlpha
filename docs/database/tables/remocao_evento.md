# remocao_evento

Objetivo: Registrar eventos ocorridos durante o processo de remoção de pacientes, com histórico de status e responsáveis.

Descrição: Tabela que armazena o histórico de eventos e mudanças de status no processo de remoção de pacientes, permitindo auditoria completa do fluxo de remoção.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_remocao_evento | bigint | NOT NULL | - | Chave primária da tabela, identificador único do evento de remoção |
| id_remocao | bigint | NOT NULL | - | Referência ao id da remoção à qual o evento pertence |
| evento | varchar(80) | NOT NULL | - | Tipo do evento ocorrido (ex: SOLICITADA, AUTORIZADA, EM_TRANSITO) |
| detalhe | text | YES | NULL | Detalhes complementares sobre o evento |
| id_usuario | bigint | YES | NULL | Referência ao id do usuário que realizou o evento |
| criado_em | datetime | - | CURRENT_TIMESTAMP | Data e hora de criação do registro do evento |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde o evento ocorreu |

## Chaves
- Primária: id_remocao_evento
- Únicas: -
- Estrangeiras: fk_re_remocao (id_remocao → remocao.id_remocao) - vincula o evento à remoção; fk_re_user (id_usuario → usuario.id_usuario) - identifica o usuário que realizou o evento

## Índices
- PRIMARY KEY (id_remocao_evento)
- KEY idx_re_remocao (id_remocao)
- KEY fk_re_user (id_usuario)

## Constraints
- CONSTRAINT fk_re_remocao FOREIGN KEY (id_remocao) REFERENCES remocao (id_remocao)
- CONSTRAINT fk_re_user FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)

## Relacionamentos e Cardinalidade
- N:1 com remocao (uma remoção pode ter vários eventos)
- N:1 com usuario (um usuário pode registrar vários eventos)

## Dependências
- Tabelas que dependem desta: -
| Esta tabela depende de: remocao, usuario

## Fluxo de utilização dentro do sistema
- Registrado automaticamente quando o status da remoção muda
- Permite histórico completo do processo de remoção
- Identifica o responsável por cada evento
- Usado para auditoria e acompanhamento de remoções
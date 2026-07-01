# reg_formulario_snapshot

Objetivo: Armazenar snapshots de formulários preenchidos no sistema, com controle de versão, sigilo e hash para integridade.

Descrição: Tabela que mantém snapshots completos de formulários preenchidos pelo usuário, permitindo versionamento, controle de sigilo (normal, sensível, muito sensível) e verificação de integridade via hash.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_snapshot | bigint | NOT NULL | - | Chave primária da tabela, identificador único do snapshot |
| entidade_ref | varchar(80) | NOT NULL | - | Nome da entidade referenciada pelo formulário (ex: atendimento, prontuario) |
| id_ref | bigint | NOT NULL | - | Id do registro da entidade referenciada pelo formulário |
| tipo_formulario | varchar(80) | NOT NULL | - | Tipo do formulário preenchido |
| versao_layout | varchar(40) | YES | NULL | Versão do layout do formulário utilizado |
| competencia | char(6) | YES | NULL | Competência do snapshot no formato AAAAMM |
| payload_json | json | NOT NULL | - | Payload JSON contendo os dados do formulário preenchido |
| payload_hash | char(64) | NOT NULL | - | Hash do payload para verificação de integridade |
| id_sessao_usuario | bigint | YES | NULL | Referência ao id da sessão do usuário que preencheu o formulário |
| id_usuario_criador | bigint | YES | NULL | Referência ao id do usuário que preencheu o formulário |
| sigilo_nivel | enum('NORMAL','SENSIVEL','MUITO_SENSIVEL') | NOT NULL | 'SENSIVEL' | Nível de sigilo: NORMAL, SENSIVEL ou MUITO_SENSIVEL |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data e hora de criação do snapshot |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde o formulário foi preenchido |

## Chaves
- Primária: id_snapshot
- Únicas: uk_reg_snapshot_ref (entidade_ref, id_ref, tipo_formulario, versao_layout)
- Estrangeiras: fk_reg_snapshot_competencia (competencia → md_competencia.competencia) - vincula a competência ao cadastro; fk_reg_snapshot_usuario (id_usuario_criador → usuario.id_usuario) - identifica o usuário que preencheu

## Índices
- PRIMARY KEY (id_snapshot)
- UNIQUE KEY uk_reg_snapshot_ref (entidade_ref, id_ref, tipo_formulario, versao_layout)
- KEY idx_reg_snapshot_hash (payload_hash)
- KEY idx_reg_snapshot_competencia (competencia)
- KEY idx_reg_snapshot_sessao (id_sessao_usuario)
- KEY idx_reg_snapshot_usuario (id_usuario_criador)

## Constraints
- CONSTRAINT fk_reg_snapshot_competencia FOREIGN KEY (competencia) REFERENCES md_competencia (competencia)
- CONSTRAINT fk_reg_snapshot_usuario FOREIGN KEY (id_usuario_criador) REFERENCES usuario (id_usuario)

## Relacionamentos e Cardinalidade
- N:1 com usuario (um usuário pode preencher vários formulários)
- N:1 com md_competencia (uma competência pode ter vários snapshots)

## Dependências
- Tabelas que dependem desta: -
| Esta tabela depende de: md_competencia, usuario

## Fluxo de utilização dentro do sistema
- Criado automaticamente quando um formulário é salvo
- Permite versionamento de formulários com layout diferente
- Hash garante integridade dos dados preenchidos
- Nível de sigilo controla acesso a informações sensíveis
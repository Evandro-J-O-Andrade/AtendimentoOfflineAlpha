# auditoria_contexto

Objetivo: Registrar o contexto de navegação e ações dos usuários no sistema para auditoria completa.
Descrição: Tabela de auditoria que registra o contexto de cada ação do usuário, incluindo sessão, atendimento, unidade, local, detalhes da ação e timestamp, permitindo rastrear o fluxo de navegação do usuário.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id | bigint unsigned | NOT NULL | - | Identificador único do registro de contexto, chave primária auto incrementada. |
| id_sessao_usuario | bigint | NOT NULL | - | Referência à sessão do usuário que realizou a ação. |
| id_usuario | bigint | NOT NULL | - | Referência ao usuário que realizou a ação. |
| id_atendimento | bigint unsigned | Nullable | - | Referência ao atendimento em contexto (pode ser nulo). |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) à qual o registro pertence. |
| id_unidade | bigint unsigned | NOT NULL | - | Referência à unidade onde a ação foi realizada. |
| id_local | bigint | NOT NULL | - | Referência ao local onde a ação foi realizada. |
| acao | varchar(60) | NOT NULL | - | Tipo de ação realizada pelo usuário no sistema. |
| detalhes | json | Nullable | - | Detalhes adicionais da ação em formato JSON. |
| criado_em | datetime(6) | NOT NULL | CURRENT_TIMESTAMP(6) | Timestamp de criação do registro com precisão de microsegundos. |

## Chaves
- Primária: id
- Únicas: nenhuma
- Estrangeiras:
  - fk_aud_ctx_atend: id_atendimento → atendimento (id_atendimento) - Relacionamento N:1, define SET NULL ao deletar
  - fk_aud_ctx_local: id_local → local (id_local) - Relacionamento N:1, define RESTRICT
  - fk_aud_ctx_sessao: id_sessao_usuario → sessao_usuario (id_sessao_usuario) - Relacionamento N:1, define CASCADE
  - fk_aud_ctx_unidade: id_unidade → unidade (id_unidade) - Relacionamento N:1, define RESTRICT
  - fk_aud_ctx_usuario: id_usuario → usuario (id_usuario) - Relacionamento N:1, define CASCADE
  - fk_auditoria_contexto_entidade: id_entidade → saas_entidade (id_entidade)

## Índices
- PRIMARY KEY (id)
- KEY idx_sessao (id_sessao_usuario)
- KEY idx_usuario_criado (id_usuario, criado_em)
- KEY idx_entidade_unidade (id_entidade, id_unidade)
- KEY idx_atendimento (id_atendimento)
- KEY idx_local (id_local)
- KEY fk_aud_ctx_unidade (id_unidade)

## Constraints
- PRIMARY KEY: id
- FOREIGN KEY: fk_aud_ctx_atend (id_atendimento) REFERENCES atendimento (id_atendimento) ON DELETE SET NULL
- FOREIGN KEY: fk_aud_ctx_local (id_local) REFERENCES local (id_local) ON DELETE RESTRICT
- FOREIGN KEY: fk_aud_ctx_sessao (id_sessao_usuario) REFERENCES sessao_usuario (id_sessao_usuario) ON DELETE CASCADE
- FOREIGN KEY: fk_aud_ctx_unidade (id_unidade) REFERENCES unidade (id_unidade) ON DELETE RESTRICT
- FOREIGN KEY: fk_aud_ctx_usuario (id_usuario) REFERENCES usuario (id_usuario) ON DELETE CASCADE
- FOREIGN KEY: fk_auditoria_contexto_entidade (id_entidade) REFERENCES saas_entidade (id_entidade)
- CHECK: auditoria_contexto_chk_1 - Valida que detalhes é JSON válido se não nulo

## Relacionamentos e Cardinalidade
- N:1 com atendimento (id_atendimento)
- N:1 com unidade (id_unidade)
- N:1 com local (id_local)
- N:1 com sessao_usuario (id_sessao_usuario)
- N:1 com usuario (id_usuario)
- N:1 com saas_entidade (id_entidade)

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: atendimento, unidade, local, sessao_usuario, usuario, saas_entidade

## Fluxo de utilização dentro do sistema
- Registrada automaticamente em cada ação significativa do usuário
- Usada para reconstruir o contexto de navegação e ações
- Permite auditoria detalhada de atividades por sessão e atendimento
- Campo detalhes armazena payload JSON com informações específicas da ação
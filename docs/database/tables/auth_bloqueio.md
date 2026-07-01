# auth_bloqueio

Objetivo: Gerenciar bloqueios de conta de usuário por motivos de segurança.
Descrição: Tabela que registra bloqueios de contas de usuário por motivos como senha expirada, tentativas excessivas, bloqueio administrativo, inatividade ou fraude.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_bloqueio | bigint | NOT NULL | - | Identificador único do bloqueio, chave primária auto incrementada. |
| id_usuario | bigint | NOT NULL | - | Referência ao usuário cuja conta está bloqueada. |
| tipo_bloqueio | enum('SENHA_EXPIRADA','TENTATIVAS_EXCEDIDAS','ADMINISTRATIVO','INATIVIDADE','FRAUDE') | NOT NULL | - | Tipo de bloqueio: senha expirada, tentativas excedidas, administrativo, inatividade ou fraude. |
| motivo | text | NOT NULL | - | Descrição detalhada do motivo do bloqueio. |
| bloqueado_por | bigint | Nullable | - | Referência ao usuário administrador que bloqueou a conta. |
| expira_em | datetime | Nullable | - | Data e hora de expiração do bloqueio (se temporário). |
| ativo | tinyint(1) | Nullable | '1' | Indicador se o bloqueio está ativo (1) ou desativado (0). |
| desbloqueado_por | bigint | Nullable | - | Referência ao usuário que desbloqueou a conta. |
| desbloqueado_em | datetime | Nullable | - | Data e hora do desbloqueio. |
| criado_em | datetime | Nullable | CURRENT_TIMESTAMP | Data e hora de criação do registro de bloqueio. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) à qual o registro pertence. |

## Chaves
- Primária: id_bloqueio
- Únicas: nenhuma
- Estrangeiras:
  - fk_bloqueio_usuario: id_usuario → usuario (id_usuario) - Relacionamento N:1, deleta em cascata

## Índices
- PRIMARY KEY (id_bloqueio)
- KEY idx_bloqueio_usuario (id_usuario)
- KEY idx_bloqueio_expira (expira_em)

## Constraints
- PRIMARY KEY: id_bloqueio
- FOREIGN KEY: fk_bloqueio_usuario (id_usuario) REFERENCES usuario (id_usuario) ON DELETE CASCADE

## Relacionamentos e Cardinalidade
- 1:1 com usuario (id_usuario) - cada bloqueio está associado a um usuário
- N:1 com usuario (bloqueado_por) - opcional, usuário administrador
- N:1 com usuario (desbloqueado_por) - opcional, usuário administrador
- N:1 com saas_entidade (id_entidade)

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: usuario, saas_entidade

## Fluxo de utilização dentro do sistema
- Criada automaticamente quando um usuário é bloqueado por segurança
- Usada para controle de acesso e prevenção a ataques
- Desbloqueio pode ser automático (expira_em) ou manual
- Integra-se com políticas de expiração de senha e tentativas de login
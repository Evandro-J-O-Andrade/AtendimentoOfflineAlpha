# auth_notificacao

Objetivo: Enviar notificações de segurança aos usuários relacionadas à autenticação.
Descrição: Tabela que armazena notificações de segurança para usuários, como login em novo dispositivo, login suspeito, senha expirando ou alertas de segurança.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_notificacao | bigint | NOT NULL | - | Identificador único da notificação, chave primária auto incrementada. |
| id_usuario | bigint | NOT NULL | - | Referência ao usuário destinatário da notificação. |
| tipo_notificacao | enum('LOGIN_NOVO_DISPOSITIVO','LOGIN_SUSPEITO','SENHA_EXPIRANDO','BLOQUUEIO_CONTA','SEGURANCA_ALERTA') | NOT NULL | - | Tipo: login novo dispositivo, login suspeito, senha expirando, bloqueio conta ou alerta de segurança. |
| titulo | varchar(200) | NOT NULL | - | Título da notificação. |
| mensagem | text | NOT NULL | - | Mensagem completa da notificação. |
| lido | tinyint(1) | Nullable | '0' | Indicador se a notificação foi lida (1) ou não (0). |
| lido_em | datetime | Nullable | - | Data e hora em que a notificação foi marcada como lida. |
| dados_extras | json | Nullable | - | Dados extras específicos da notificação em formato JSON. |
| criado_em | datetime | Nullable | CURRENT_TIMESTAMP | Timestamp de criação da notificação. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) à qual a notificação pertence. |

## Chaves
- Primária: id_notificacao
- Únicas: nenhuma
- Estrangeiras:
  - fk_notif_usuario: id_usuario → usuario (id_usuario) - Relacionamento N:1, deleta em cascata

## Índices
- PRIMARY KEY (id_notificacao)
- KEY idx_notif_usuario (id_usuario)
- KEY idx_notif_lido (lido)
- KEY idx_notif_data (criado_em)

## Constraints
- PRIMARY KEY: id_notificacao
- FOREIGN KEY: fk_notif_usuario (id_usuario) REFERENCES usuario (id_usuario) ON DELETE CASCADE

## Relacionamentos e Cardinalidade
- N:1 com usuario (id_usuario)
- N:1 com saas_entidade (id_entidade)

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: usuario, saas_entidade

## Fluxo de utilização dentro do sistema
- Criada automaticamente quando ocorre evento de segurança relevante
- Notificações permanecem não lidas até que usuário as visualize
- Usada para alertas de login suspeito e expiração de senha
- Integrada com sistema de notificação push/email do usuário
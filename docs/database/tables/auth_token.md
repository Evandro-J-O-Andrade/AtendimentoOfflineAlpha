# auth_token

Objetivo: Gerenciar tokens de acesso, refresh, recuperação e verificação de usuários.
Descrição: Tabela que armazena tokens de autenticação do sistema, incluindo access tokens, refresh tokens, tokens de recuperação de senha e verificação de email.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_token | bigint | NOT NULL | - | Identificador único do token, chave primária auto incrementada. |
| id_usuario | bigint | NOT NULL | - | Referência ao usuário dono do token. |
| tipo_token | enum('ACCESS','REFRESH','RECOVERY','VERIFICATION') | NOT NULL | - | Tipo: access token para API, refresh token, recovery para reset senha, verification para verificação. |
| token_hash | varchar(255) | NOT NULL | - | Hash do token (nunca o token em texto plano). |
| ip_origem | varchar(45) | Nullable | - | Endereço IP de origem da criação do token. |
| user_agent | text | Nullable | - | User agent do navegador/dispositivo na criação. |
| ativo | tinyint(1) | Nullable | '1' | Indicador se o token está ativo (1) ou revogado (0). |
| expira_em | datetime | NOT NULL | - | Data e hora de expiração do token. |
| criado_em | datetime | Nullable | CURRENT_TIMESTAMP | Timestamp de criação do token. |
| utilizado_em | datetime | Nullable | - | Timestamp de quando o token foi utilizado (para single-use como recovery). |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) à qual o token pertence. |

## Chaves
- Primária: id_token
- Únicas: nenhuma
- Estrangeiras:
  - fk_token_usuario: id_usuario → usuario (id_usuario) - Relacionamento N:1, deleta em cascata

## Índices
- PRIMARY KEY (id_token)
- KEY idx_token_usuario (id_usuario)
- KEY idx_token_hash (token_hash)
- KEY idx_token_expira (expira_em)

## Constraints
- PRIMARY KEY: id_token
- FOREIGN KEY: fk_token_usuario (id_usuario) REFERENCES usuario (id_usuario) ON DELETE CASCADE

## Relacionamentos e Cardinalidade
- N:1 com usuario (id_usuario) - muitos tokens podem pertencer a um usuário
- N:1 com saas_entidade (id_entidade)

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: usuario, saas_entidade

## Fluxo de utilização dentro do sistema
- Access token criado após login bem-sucedido, usado para autenticar requisições
- Refresh token usado para renovar access tokens expirados
- Recovery token enviado por email para reset de senha (single use)
- Verification token enviado para verificar email ou ações sensíveis
- Tokens inativados ao logout ou expiração
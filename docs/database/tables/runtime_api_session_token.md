# runtime_api_session_token

Objetivo: Gerenciar tokens de sessão para APIs runtime, com controle de expiração e dispositivos.

Descrição: Tabela que armazena tokens de sessão para APIs do sistema runtime, permitindo autenticação via UUID, controle de expiração, dispositivo e tenant.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_token | bigint | NOT NULL | - | Chave primária da tabela, identificador único do token |
| id_usuario | bigint | NOT NULL | - | Referência ao id do usuário ao qual o token pertence |
| uuid_runtime | varchar(36) | NOT NULL | - | UUID único que identifica a sessão runtime |
| token_hash | varchar(255) | NOT NULL | - | Hash do token para validação sem armazenar o valor original |
| expira_em | datetime | NOT NULL | - | Data e hora de expiração do token |
| device_id | varchar(100) | YES | NULL | Identificador do dispositivo que solicitou o token |
| tenant_id | bigint | - | '1' | Id do tenant (organização) para multi-tenancy |
| ativo | tinyint(1) | - | '1' | Flag indicando se o token está ativo (1) ou revogado (0) |
| criado_em | datetime | - | CURRENT_TIMESTAMP | Data e hora de criação do token |
| ultimo_acesso | datetime | - | NULL ON UPDATE CURRENT_TIMESTAMP | Data e hora do último uso do token |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde o token é válido |

## Chaves
- Primária: id_token
- Únicas: uk_uuid_runtime (uuid_runtime)
- Estrangeiras: -

## Índices
- PRIMARY KEY (id_token)
- UNIQUE KEY uk_uuid_runtime (uuid_runtime)
- KEY idx_token_hash (token_hash)
- KEY idx_id_usuario (id_usuario)
- KEY idx_expira (expira_em)

## Constraints
- -

## Relacionamentos e Cardinalidade
- N:1 com usuario (um usuário pode ter vários tokens ativos)

## Dependências
- Tabelas que dependem desta: -
| Esta tabela depende de: usuario

## Fluxo de utilização dentro do sistema
- Criado quando uma sessão runtime é iniciada via API
- UUID permite identificação única da sessão
- Hash do token permite validação sem expor o valor original
- Tenant_id suporta multi-tenancy no sistema
- Último acesso atualizado automaticamente em cada requisição
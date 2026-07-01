# usuario_refresh

Objetivo: Armazenar refresh tokens para autenticação contínua com rotação e revogação de tokens.
Descrição: Tabela que gerencia os refresh tokens emitidos para usuários autenticados, permitindo a obtenção de novos access tokens sem necessidade de novo login. Suporta rotação de tokens, revogação explícita e rastreamento de dispositivos por user-agent e IP. Essencial para autenticação stateless em APIs RESTful.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_refresh | bigint | NO | AUTO_INCREMENT | Chave primária única que identifica o refresh token |
| id_usuario | bigint | NO | NULL | Identificador do usuário dono do token |
| token_hash | char(64) | NO | NULL | Hash SHA-256 ou similar do refresh token para armazenamento seguro |
| expires_at | datetime | NO | NULL | Data e hora de expiração do token |
| created_at | datetime | NO | CURRENT_TIMESTAMP | Data e hora de criação do token |
| revoked | tinyint(1) | NO | '0' | Flag que indica se o token foi revogado (1) ou está ativo (0) |
| user_agent | varchar(255) | YES | NULL | User agent do dispositivo/dispositivo que solicitou o token |
| ip | varchar(45) | YES | NULL | Endereço IP de origem da solicitação do token |
| id_entidade | bigint unsigned | NO | NULL | Identificador da entidade SaaS à qual este token pertence |

## Chaves
- Primária: id_refresh
- Únicas: uk_token_hash (token_hash)
- Estrangeiras: fk_usuario_refresh_usuario (id_usuario -> usuario.id_usuario)

## Índices
- uk_token_hash (token_hash) - unique
- idx_usuario (id_usuario)

## Constraints
- fk_usuario_refresh_usuario: FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario) ON DELETE CASCADE

## Relacionamentos e Cardinalidade
- N:1 com usuario (muitos refresh tokens podem pertencer a um usuário, um por dispositivo/sessão)
- N:1 com saas_entidade (muitos tokens pertencem a uma entidade)

## Dependências
- Depende de: usuario, saas_entidade
- Dependências reversas: Nenhuma tabela principal depende diretamente desta

## Fluxo de utilização dentro do sistema
- Quando um usuário faz login, um refresh token é gerado e armazenado com hash
- O cliente usa o refresh token para obter novos access tokens periodicamente
- Tokens podem ser revogados individualmente (logout, troca de senha, suspeita de vazamento)
- Rotação de tokens: ao usar um refresh token, um novo é emitido e o antigo pode ser revogado
- Consultado em cada requisição que utiliza refresh token para validação
- Limpeza periódica remove tokens expirados e revogados antigos

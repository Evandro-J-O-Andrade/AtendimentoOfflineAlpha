# usuario_refresh_token

Objetivo: Armazenar refresh tokens de usuários para manutenção de sessão autenticada.
Descrição: Tabela que mantém os refresh tokens emitidos durante o processo de autenticação, permitindo que usuários renovem seus access tokens sem realizar novo login. Funciona como mecanismo de persistência de sessão em arquitetura stateless, com controle de expiração e revogação.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_token | bigint | NO | AUTO_INCREMENT | Chave primária única que identifica o registro do refresh token |
| id_usuario | bigint | NO | NULL | Identificador do usuário proprietário do token |
| token | varchar(255) | NO | NULL | Valor do refresh token (provavelmente armazenado em texto puro ou com ofuscação) |
| expira_em | datetime | NO | NULL | Data e hora de expiração do token |
| revogado | tinyint(1) | YES | '0' | Flag que indica se o token foi revogado (1) ou permanece válido (0) |
| criado_em | datetime | YES | CURRENT_TIMESTAMP | Data e hora de criação do token |
| id_entidade | bigint unsigned | NO | NULL | Identificador da entidade SaaS à qual este token pertence |

## Chaves
- Primária: id_token
- Únicas: uk_refresh_token (token)
- Estrangeiras: fk_rt_usuario (id_usuario -> usuario.id_usuario)

## Índices
- uk_refresh_token (token) - unique
- idx_rt_usuario (id_usuario)

## Constraints
- fk_rt_usuario: FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)

## Relacionamentos e Cardinalidade
- N:1 com usuario (muitos refresh tokens podem pertencer a um usuário)
- N:1 com saas_entidade (muitos tokens pertencem a uma entidade)

## Dependências
- Depende de: usuario, saas_entidade
- Dependências reversas: Nenhuma tabela principal depende diretamente desta

## Fluxo de utilização dentro do sistema
- Emitida durante o fluxo de autenticação (login) para permitir renovação de sessão
- O endpoint de refresh consulta esta tabela para validar e renovar o token
- Tokens podem ser revogados no logout ou por motivos de segurança
- Consultada em toda requisição que utiliza refresh token para renovação de access token
- Dados de IP e user-agent não são armazenados nesta tabela (diferente de usuario_refresh)

# usuario_senha_reset

Objetivo: Gerenciar tokens de redefinição de senha com rastreamento de sessão e solicitante.
Descrição: Tabela que armazena tokens de recuperação de senha com controle de sessão e usuário solicitante. Diferencia-se de usuario_reset_senha por incluir referências à sessão e ao usuário que solicitou o reset, permitindo auditoria mais detalhada do fluxo de recuperação de acesso. Controla expiração, uso e rastreabilidade completa do processo de reset.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_usuario_senha_reset | bigint | NO | AUTO_INCREMENT | Chave primária única que identifica a solicitação de reset de senha |
| id_usuario | bigint | NO | NULL | Identificador do usuário que terá a senha redefinida |
| token_hash | varchar(64) | NO | NULL | Hash criptográfico do token de redefinição de senha |
| expira_em | datetime | NO | NULL | Data e hora de expiração do token de redefinição |
| usado_em | datetime | YES | NULL | Data e hora em que o token foi utilizado para redefinir a senha |
| id_sessao_usuario_solicitante | bigint | YES | NULL | Identificador da sessão do usuário que solicitou o reset (se houver sessão) |
| id_usuario_solicitante | bigint | YES | NULL | Identificador do usuário que solicitou o reset (pode ser admin ou o próprio usuário) |
| criado_em | datetime | NO | CURRENT_TIMESTAMP | Data e hora de criação da solicitação de reset |
| id_entidade | bigint unsigned | NO | NULL | Identificador da entidade SaaS à qual esta solicitação pertence |

## Chaves
- Primária: id_usuario_senha_reset
- Únicas: ux_usr_reset_token_hash (token_hash)
- Estrangeiras: fk_usr_reset_solicitante (id_usuario_solicitante -> usuario.id_usuario), fk_usr_reset_usuario (id_usuario -> usuario.id_usuario)

## Índices
- ux_usr_reset_token_hash (token_hash) - unique
- idx_usr_reset_usuario (id_usuario)
- idx_usr_reset_expira (expira_em)
- fk_usr_reset_sessao (id_sessao_usuario_solicitante)
- fk_usr_reset_solicitante (id_usuario_solicitante)

## Constraints
- fk_usr_reset_solicitante: FOREIGN KEY (id_usuario_solicitante) REFERENCES usuario (id_usuario) ON DELETE SET NULL
- fk_usr_reset_usuario: FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario) ON DELETE CASCADE

## Relacionamentos e Cardinalidade
- N:1 com usuario como alvo (muitas solicitações podem pertencer a um usuário)
- N:1 com usuario como solicitante (muitas solicitações podem ser feitas por um usuário admin)
- N:1 com sessao_usuario (muitas solicitações podem estar associadas a uma sessão)

## Dependências
- Depende de: usuario, sessao_usuario, saas_entidade
- Dependências reversas: Nenhuma tabela principal depende diretamente desta

## Fluxo de utilização dentro do sistema
- Usuário autenticado solicita reset de senha própria ou de outro usuário (admin)
- Token é gerado e armazenado com hash, associado ao usuário alvo e à sessão/usuário solicitante
- Sistema envia token por e-mail ou notifica o usuário
- Quando o usuário utiliza o token, a senha é redefinida e o campo usado_em é preenchido
- Tokens expirados podem ser automaticamente invalidados por jobs de manutenção
- Permite rastrear se o reset foi solicitado pelo próprio usuário ou por um administrador

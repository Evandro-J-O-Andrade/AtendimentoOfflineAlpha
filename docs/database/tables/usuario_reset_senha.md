# usuario_reset_senha

Objetivo: Gerenciar tokens de redefinição de senha enviados para usuários que solicitam recuperação de acesso.
Descrição: Tabela que armazena tokens temporários para recuperação de senha, contendo informações de expiração, uso e proveniência da solicitação. Suporta rastreamento de IP e user-agent da solicitação para fins de segurança. Controla o ciclo de vida completo do token de reset desde a solicitação até o uso ou expiração.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_reset | bigint | NO | AUTO_INCREMENT | Chave primária única que identifica a solicitação de reset de senha |
| id_usuario | bigint | NO | NULL | Identificador do usuário que solicitou a redefinição de senha |
| token_hash | varchar(255) | NO | NULL | Hash do token de redefinição enviado ao usuário via e-mail ou SMS |
| criado_em | datetime | NO | CURRENT_TIMESTAMP | Data e hora de criação da solicitação de reset |
| expira_em | datetime | NO | NULL | Data e hora de expiração do token de redefinição |
| usado_em | datetime | YES | NULL | Data e hora em que o token foi utilizado para redefinir a senha |
| ip_solicitacao | varchar(45) | YES | NULL | Endereço IP de origem da solicitação de redefinição de senha |
| user_agent | varchar(255) | YES | NULL | User agent do dispositivo que originou a solicitação de reset |
| id_entidade | bigint unsigned | NO | NULL | Identificador da entidade SaaS à qual esta solicitação pertence |

## Chaves
- Primária: id_reset
- Únicas: Nenhuma
- Estrangeiras: fk_urs_usuario (id_usuario -> usuario.id_usuario)

## Índices
- ix_urs_usuario (id_usuario)
- ix_urs_expira (expira_em)
- ix_urs_token (token_hash)

## Constraints
- fk_urs_usuario: FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)

## Relacionamentos e Cardinalidade
- N:1 com usuario (muitas solicitações de reset podem pertencer a um usuário)

## Dependências
- Depende de: usuario, saas_entidade
- Dependências reversas: Nenhuma tabela principal depende diretamente desta

## Fluxo de utilização dentro do sistema
- Quando um usuário solicita recuperação de senha, um token é gerado e armazenado nesta tabela
- O sistema envia um e-mail ou SMS com link contendo o token para o usuário
- Quando o usuário acessa o link, o token é validado contra esta tabela (não expirado e não usado)
- Após a redefinição, o campo usado_em é preenchido com a data/hora atual
- Tokens expirados podem ser limpos periodicamente por job de manutenção
- Usado para detectar múltiplas solicitações de reset suspeitas para o mesmo usuário

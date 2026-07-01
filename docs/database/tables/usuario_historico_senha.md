# usuario_historico_senha

Objetivo: Manter histórico de senhas antigas dos usuários para evitar reutilização e suportar auditoria de segurança.
Descrição: Armazena hashes de senhas anteriormente utilizadas pelos usuários, permitindo aplicar políticas de não reutilização de senhas (não permitir que o usuário volte a usar senhas dos últimos N cadastramentos). Funciona como registro de auditoria e controle de conformidade de segurança.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_historico | bigint | NO | AUTO_INCREMENT | Chave primária única que identifica o registro de histórico de senha |
| id_usuario | bigint | NO | NULL | Identificador do usuário ao qual o hash de senha histórica pertence |
| senha_hash | varchar(255) | NO | NULL | Hash criptográfico da senha antiga do usuário (formato utf8mb4_unicode_ci) |
| criado_em | datetime | YES | CURRENT_TIMESTAMP | Data e hora em que a senha foi cadastrada no histórico |
| id_entidade | bigint unsigned | NO | NULL | Identificador da entidade SaaS à qual este histórico pertence |

## Chaves
- Primária: id_historico
- Únicas: Nenhuma
- Estrangeiras: fk_hist_senha_usuario (id_usuario -> usuario.id_usuario)

## Índices
- fk_hist_senha_usuario (id_usuario)

## Constraints
- fk_hist_senha_usuario: FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)

## Relacionamentos e Cardinalidade
- N:1 com usuario (muitos registros de histórico pertencem a um usuário)

## Dependências
- Depende de: usuario, saas_entidade
- Dependências reversas: Nenhuma

## Fluxo de utilização dentro do sistema
- Quando um usuário altera sua senha, o hash da senha anterior é inserido nesta tabela
- Antes de permitir uma alteração de senha, o sistema verifica se o novo hash não existe nesta tabela para o usuário
- Usado para cumprir políticas de segurança que exigem troca de senha periódica e proibem reutilização de senhas anteriores
- Pode ser consultado em auditorias de segurança e conformidade

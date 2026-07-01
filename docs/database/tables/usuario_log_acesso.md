# usuario_log_acesso

Objetivo: Registrar tentativas de acesso de usuários ao sistema para auditoria e segurança.
Descrição: Tabela de log que armazena cada tentativa de login ou acesso realizado por usuários, contendo informações de IP, user-agent, sucesso da tentativa e timestamp. Serve para detecção de invasões, auditoria de acesso e conformidade com políticas de segurança.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_log | bigint | NO | AUTO_INCREMENT | Chave primária única que identifica o registro de log de acesso |
| id_usuario | bigint | NO | NULL | Identificador do usuário que tentou acessar o sistema |
| id_entidade | bigint unsigned | NO | NULL | Identificador da entidade SaaS onde ocorreu a tentativa de acesso |
| ip | varchar(45) | NO | NULL | Endereço IP de origem da tentativa de acesso (suporta IPv4 e IPv6) |
| user_agent | varchar(255) | YES | NULL | String do user-agent do navegador/dispositivo utilizado na tentativa |
| sucesso | tinyint(1) | NO | NULL | Flag que indica se a tentativa de acesso foi bem-sucedida (1) ou falhou (0) |
| criado_em | datetime | YES | CURRENT_TIMESTAMP | Data e hora em que a tentativa de acesso foi realizada |

## Chaves
- Primária: id_log
- Únicas: Nenhuma
- Estrangeiras: fk_log_usuario (id_usuario -> usuario.id_usuario), fk_usuario_log_acesso_entidade (id_entidade -> saas_entidade.id_entidade)

## Índices
- idx_log_usuario (id_usuario)
- idx_log_entidade (id_entidade)

## Constraints
- fk_log_usuario: FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
- fk_usuario_log_acesso_entidade: FOREIGN KEY (id_entidade) REFERENCES saas_entidade (id_entidade)

## Relacionamentos e Cardinalidade
- N:1 com usuario (muitos logs de acesso pertencem a um usuário)
- N:1 com saas_entidade (muitos logs pertencem a uma entidade)

## Dependências
- Depende de: usuario, saas_entidade
- Dependências reversas: Nenhuma

## Fluxo de utilização dentro do sistema
- Toda vez que um usuário tenta fazer login, um registro é inserido com sucesso=true ou sucesso=false
- Usado para relatórios de auditoria de acesso e detecção de ataques de força bruta
- Consultado pelo módulo de segurança para bloquear usuários após múltiplas tentativas falhas
- Permite rastrear de onde e quando usuários acessam o sistema para investigações de segurança

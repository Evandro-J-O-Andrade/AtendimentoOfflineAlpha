# auth_log

Objetivo: Registrar eventos de autenticação do usuário como login, logout, alterações de senha, bloqueios.
Descrição: Tabela de log que registra eventos de sessão do usuário incluindo login sucesso/falha, logout, troca de senha, refresh de token e bloqueios de conta.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_log | bigint | NOT NULL | - | Identificador único do log, chave primária auto incrementada. |
| id_usuario | bigint | Nullable | - | Referência ao usuário (pode ser nulo para tentativas falhas). |
| tipo_evento | enum('LOGIN_SUCESSO','LOGIN_FALHA','LOGOUT','SENHA_TROCA','SENHA_RESET','TOKEN_REFRESH','BLOQUEIO','DESBLOQUEIO','SESSAO_EXPIRADA') | NOT NULL | - | Tipo do evento: login sucesso, falha, logout, troca/reset senha, refresh token, bloqueio, desbloqueio ou sessão expirada. |
| ip_origem | varchar(45) | Nullable | - | Endereço IP de origem do evento. |
| user_agent | text | Nullable | - | User agent do navegador/dispositivo utilizado. |
| dispositivo | varchar(100) | Nullable | - | Nome ou identificação do dispositivo utilizado. |
| localizacao | varchar(200) | Nullable | - | Localização geográfica ou descrição do local de acesso. |
| mensagem | text | Nullable | - | Mensagem complementar sobre o evento. |
| dados_extras | json | Nullable | - | Dados adicionais em formato JSON. |
| criado_em | datetime | Nullable | CURRENT_TIMESTAMP | Timestamp de criação do log. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) à qual o log pertence. |

## Chaves
- Primária: id_log
- Únicas: nenhuma
- Estrangeiras: nenhuma

## Índices
- PRIMARY KEY (id_log)
- KEY idx_log_usuario (id_usuario)
- KEY idx_log_tipo (tipo_evento)
- KEY idx_log_data (criado_em)

## Constraints
- PRIMARY KEY: id_log

## Relacionamentos e Cardinalidade
- N:1 com usuario (id_usuario) - opcional
- N:1 com saas_entidade (id_entidade)

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: usuario, saas_entidade

## Fluxo de utilização dentro do sistema
- Registrada automaticamente em cada evento de autenticação
- Usada para monitoramento de segurança e detecção de padrões suspeitos
- Permite análise de tentativas de login falhas para prevenir ataques
- Dados extras podem conter informações específicas por tipo de evento
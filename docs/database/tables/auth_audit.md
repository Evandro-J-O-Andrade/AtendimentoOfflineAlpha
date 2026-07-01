# auth_audit

Objetivo: Auditar todas as ações de segurança realizadas pelos usuários no sistema de autenticação.
Descrição: Tabela central de auditoria de segurança que registra ações de autenticação, recursos acessados, detalhes da operação e resultados (sucesso/falha).

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_audit | bigint | NOT NULL | - | Identificador único do registro de auditoria, chave primária auto incrementada. |
| id_usuario | bigint | Nullable | - | Referência ao usuário que realizou a ação (pode ser nulo). |
| id_sessao | bigint | Nullable | - | Referência à sessão do usuário (pode ser nulo). |
| acao | varchar(100) | NOT NULL | - | Tipo de ação realizada (ex: LOGIN, LOGOUT, ACESSO_RECURSO). |
| recurso | varchar(100) | Nullable | - | Recurso/system endpoint acessado na ação. |
| detalhes | json | Nullable | - | Detalhes adicionais da ação em formato JSON. |
| ip_origem | varchar(45) | Nullable | - | Endereço IP de origem da requisição. |
| user_agent | text | Nullable | - | User agent do navegador/dispositivo utilizado. |
| sucesso | tinyint(1) | Nullable | '1' | Indicador se a ação foi bem-sucedida (1) ou falhou (0). |
| criado_em | datetime | Nullable | CURRENT_TIMESTAMP | Timestamp de criação do registro. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) à qual o registro pertence. |

## Chaves
- Primária: id_audit
- Únicas: nenhuma
- Estrangeiras: nenhuma

## Índices
- PRIMARY KEY (id_audit)
- KEY idx_audit_usuario (id_usuario)
- KEY idx_audit_sessao (id_sessao)
- KEY idx_audit_acao (acao)
- KEY idx_audit_data (criado_em)

## Constraints
- PRIMARY KEY: id_audit

## Relacionamentos e Cardinalidade
- N:1 com usuario (id_usuario) - opcional
- N:1 com sessao (id_sessao) - opcional
- N:1 com saas_entidade (id_entidade)

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: usuario, sessao, saas_entidade

## Fluxo de utilização dentro do sistema
- Registrada automaticamente em todas as ações de autenticação
- Permite auditoria completa de login, logout, acessos a recursos
- Campo sucesso permite filtrar tentativas bem-sucedidas x falhas
- Base para detecção de ataques brute force ou acesso não autorizado
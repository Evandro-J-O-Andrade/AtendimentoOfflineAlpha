# auth_sessao

Objetivo: Gerenciar sessões de usuário autenticado no sistema.
Descrição: Tabela que mantém o controle de sessões ativas dos usuários, armazenando token de sessão, IP, user agent, unidade e local de operação.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_sessao | bigint | NOT NULL | - | Identificador único da sessão, chave primária auto incrementada. |
| id_usuario | bigint | NOT NULL | - | Referência ao usuário dono da sessão. |
| id_unidade | bigint unsigned | NOT NULL | - | Referência à unidade onde o usuário está operando. |
| id_local_operacional | bigint | Nullable | - | Referência ao local operacional onde a sessão está vinculada. |
| id_perfil | bigint | Nullable | - | Referência ao perfil do usuário na sessão. |
| token_sessao | varchar(255) | NOT NULL | - | Token único de identificação da sessão (usado para autenticação). |
| ip_origem | varchar(45) | Nullable | - | Endereço IP de origem da sessão. |
| user_agent | text | Nullable | - | User agent do navegador/dispositivo utilizado. |
| dispositivo | varchar(100) | Nullable | - | Nome do dispositivo utilizado na sessão. |
| geo_localizacao | varchar(200) | Nullable | - | Localização geográfica aproximada da sessão. |
| ativo | tinyint(1) | Nullable | '1' | Indicador se a sessão está ativa (1) ou encerrada (0). |
| expira_em | datetime | NOT NULL | - | Data e hora de expiração da sessão. |
| ultima_atividade | datetime | Nullable | CURRENT_TIMESTAMP | Timestamp da última atividade na sessão. |
| criado_em | datetime | Nullable | CURRENT_TIMESTAMP | Data e hora de criação da sessão. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) à qual pertence a sessão. |

## Chaves
- Primária: id_sessao
- Únicas: nenhuma
- Estrangeiras:
  - fk_sessao_usuario: id_usuario → usuario (id_usuario) - Relacionamento N:1, deleta em cascata

## Índices
- PRIMARY KEY (id_sessao)
- KEY idx_sessao_usuario (id_usuario)
- KEY idx_sessao_token (token_sessao)
- KEY idx_sessao_expira (expira_em)

## Constraints
- PRIMARY KEY: id_sessao
- FOREIGN KEY: fk_sessao_usuario (id_usuario) REFERENCES usuario (id_usuario) ON DELETE CASCADE

## Relacionamentos e Cardinalidade
- 1:1 com usuario (id_usuario) - cada sessão pertence a um usuário
- N:1 com unidade (id_unidade)
- N:1 com local_operacional (id_local_operacional) - opcional
- N:1 com perfil (id_perfil) - opcional
- N:1 com saas_entidade (id_entidade)

## Dependências
- Tabelas que dependem desta: auth_audit, auditoria_acesso, auditoria_contexto, auditoria_evento, auditoria_mestre
- Dependência desta tabela: usuario, unidade, local_operacional, perfil, saas_entidade

## Fluxo de utilização dentro do sistema
- Criada automaticamente após login bem-sucedido
- Token de sessão usado para autenticar requisições subsequentes
- Atualizada a cada atividade do usuário (ultima_atividade)
- Excluída automaticamente ao expirar ou logout
- Usada para prevenir múltiplas sessões simultâneas
# runtime_execution_queue

Objetivo: Gerenciar fila de execução de ações em runtime, permitindo processamento assíncrono com controle de status, prioridade e retry.

Descrição: Tabela que implementa uma fila de execução para ações assíncronas no sistema runtime, permitindo processamento em background com controle de status, tentativas e resultados.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id | varchar(36) | NOT NULL | - | Chave primária da tabela, UUID que identifica a ação na fila |
| id_sessao | bigint | NOT NULL | - | Referência ao id da sessão do usuário que solicitou a ação |
| id_usuario | bigint | NOT NULL | - | Referência ao id do usuário que solicitou a ação |
| id_perfil | bigint | NOT NULL | - | Referência ao id do perfil do usuário para autorização |
| acao | varchar(100) | NOT NULL | - | Nome da ação a ser executada na fila |
| contexto | varchar(60) | - | 'DEFAULT' | Contexto da ação para agrupamento e priorização |
| payload | json | YES | NULL | Payload JSON com parâmetros da ação |
| status | enum('PENDENTE','PROCESSANDO','CONCLUIDO','ERRO','CANCELADO') | - | 'PENDENTE' | Status da ação: PENDENTE, PROCESSANDO, CONCLUIDO, ERRO, CANCELADO |
| prioridade | int | - | '0' | Prioridade de execução (valores maiores têm prioridade) |
| retry_count | int | - | '0' | Quantidade de tentativas já realizadas |
| ultimo_erro | text | YES | NULL | Mensagem do último erro ocorrido |
| duracao_ms | int | YES | NULL | Duração da execução em milissegundos |
| resultado | text | YES | NULL | Resultado da execução da ação |
| criado_em | datetime | - | CURRENT_TIMESTAMP | Data e hora de criação da ação na fila |
| atualizado_em | datetime | - | NULL ON UPDATE CURRENT_TIMESTAMP | Data e hora da última atualização |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde a ação será executada |

## Chaves
- Primária: id
- Únicas: -
- Estrangeiras: -

## Índices
- PRIMARY KEY (id)
- KEY idx_status (status, criado_em)
- KEY idx_usuario (id_usuario)
- KEY idx_sessao (id_sessao)

## Constraints
- -

## Relacionamentos e Cardinalidade
- N:1 com usuario (um usuário pode ter várias ações na fila)

## Dependências
- Tabelas que dependem desta: -
| Esta tabela depende de: usuario

## Fluxo de utilização dentro do sistema
- Criado quando uma ação assíncrona precisa ser executada
- Workers consomem ações pendentes e atualizam status
- Retry automático em caso de falha
- Prioridade permite execução de ações críticas primeiro
# retry_semantico_controle

Objetivo: Controlar o mecanismo de retry semântico para eventos que falham, permitindo reprocessamento automático com número máximo de tentativas.

Descrição: Tabela que implementa o padrão de retry semântico para eventos que falham durante o processamento, permitindo controle de tentativas, bloqueio e agendamento de próximas tentativas.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_retry | bigint | NOT NULL | - | Chave primária da tabela, identificador único do controle de retry |
| id_ffa | bigint | NOT NULL | - | Referência ao id da ficha de atendimento assistido associada ao evento |
| evento | varchar(60) | NOT NULL | - | Nome do evento que precisa de retry |
| versao_logica | bigint | - | '1' | Versão lógica do evento para controle de concorrência |
| tentativas | int | - | '0' | Quantidade de tentativas já realizadas |
| max_tentativas | int | - | '5' | Número máximo de tentativas permitidas |
| bloqueado | tinyint(1) | - | '0' | Flag indicando se o evento está bloqueado para retry (1) ou não (0) |
| ultimo_erro | varchar(255) | YES | NULL | Mensagem do último erro ocorrido durante o retry |
| proxima_tentativa | datetime(6) | YES | NULL | Data e hora programada para a próxima tentativa |
| criado_em | datetime(6) | - | CURRENT_TIMESTAMP(6) | Data e hora de criação do registro de retry |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde o retry ocorre |

## Chaves
- Primária: id_retry
- Únicas: -
- Estrangeiras: -

## Índices
- PRIMARY KEY (id_retry)
- KEY idx_retry_fila (bloqueado, proxima_tentativa)

## Constraints
- -

## Relacionamentos e Cardinalidade
- N:1 com ffa (uma FFA pode ter vários eventos em retry)

## Dependências
- Tabelas que dependem desta: -
| Esta tabela depende de: ffa

## Fluxo de utilização dentro do sistema
- Criado automaticamente quando um evento falha durante processamento
- Permite reprocessamento automático até max_tentativas
- Bloqueado impede novas tentativas em caso de falha crítica
- Usado em sistemas distribuídos para tolerância a falhas
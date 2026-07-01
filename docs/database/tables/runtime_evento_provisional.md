# runtime_evento_provisional

Objetivo: Armazenar eventos provisionais emitidos por dispositivos offline, aguardando sincronização com o sistema central.

Descrição: Tabela que mantém eventos emitidos localmente em dispositivos que operam em modo offline, com controle de status de sincronização e criticidade do fluxo.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_provisional | bigint | NOT NULL | - | Chave primária da tabela, identificador único do evento provisional |
| uuid_evento | char(36) | NOT NULL | - | UUID único que identifica o evento globalmente |
| dominio_fluxo | varchar(50) | NOT NULL | - | Domínio de fluxo ao qual o evento pertence |
| payload_operacional | json | NOT NULL | - | Payload JSON com dados operacionais do evento |
| hash_snapshot | char(64) | NOT NULL | - | Hash do snapshot para verificação de integridade |
| token_execucao | char(36) | NOT NULL | - | Token de execução para controle de concorrência |
| versao_estado | bigint | NOT NULL | - | Versão do estado ao qual o evento se refere |
| status_provisional | enum('LOCAL_EXECUTADO','AGUARDANDO_SYNC','SINCRONIZADO','REJEITADO_CENTRAL') | - | 'LOCAL_EXECUTADO' | Status do evento: LOCAL_EXECUTADO, AGUARDANDO_SYNC, SINCRONIZADO, REJEITADO_CENTRAL |
| criticidade_fluxo | tinyint | - | '1' | Nível de criticidade do evento para priorização de sync |
| criado_em | datetime(6) | - | CURRENT_TIMESTAMP(6) | Data e hora de criação do evento provisional |
| sincronizado_em | datetime(6) | YES | NULL | Data e hora em que o evento foi sincronizado |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde o evento ocorre |

## Chaves
- Primária: id_provisional
- Únicas: uk_provisional_uuid (uuid_evento)
- Estrangeiras: -

## Índices
- PRIMARY KEY (id_provisional)
- UNIQUE KEY uk_provisional_uuid (uuid_evento)
- KEY idx_provisional_status (status_provisional)
- KEY idx_provisional_sync (sincronizado_em)

## Constraints
- -

## Relacionamentos e Cardinalidade
- -

## Dependências
- Tabelas que dependem desta: -
| Esta tabela depende de: -

## Fluxo de utilização dentro do sistema
- Criado automaticamente quando evento ocorre em modo offline
- Permanece como AGUARDANDO_SYNC até sincronizar com central
- Criticidade influencia priorização de sincronização
- Rejeitado central registra falhas de sincronização
# runtime_estado_sobrevivencia

Objetivo: Controlar o estado de sobrevivência de dispositivos runtime operando em modo offline com diferentes modos de operação.

Descrição: Tabela que monitora o estado de operação de dispositivos runtime quando desconectados do sistema central, permitindo operação autônoma com modos como NORMAL, DEGRADADO, OFFLINE_AUTONOMO e BLOQUEIO_SEGURANCA.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_estado | bigint | NOT NULL | - | Chave primária da tabela, identificador único do estado |
| runtime_device_id | varchar(100) | NOT NULL | - | Identificador do dispositivo runtime |
| modo_operacao | enum('NORMAL','DEGRADADO','OFFLINE_AUTONOMO','BLOQUEIO_SEGURANCA') | - | 'NORMAL' | Modo de operação: NORMAL, DEGRADADO, OFFLINE_AUTONOMO, BLOQUEIO_SEGURANCA |
| ultima_sincronizacao | datetime(6) | YES | NULL | Data e hora da última sincronização com o sistema central |
| hash_snapshot_runtime | char(64) | YES | NULL | Hash do snapshot de estado runtime para verificação |
| evento_seguranca | json | YES | NULL | Payload JSON com eventos de segurança detectados |
| criado_em | datetime(6) | - | CURRENT_TIMESTAMP(6) | Data e hora de criação do registro de estado |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde o estado é monitorado |

## Chaves
- Primária: id_estado
- Únicas: uk_runtime_device (runtime_device_id)
- Estrangeiras: -

## Índices
- PRIMARY KEY (id_estado)
- UNIQUE KEY uk_runtime_device (runtime_device_id)
- KEY idx_runtime_modo (modo_operacao)

## Constraints
- -

## Relacionamentos e Cardinalidade
- -

## Dependências
- Tabelas que dependem desta: -
| Esta tabela depende de: -

## Fluxo de utilização dentro do sistema
- Atualizado periodicamente pelo dispositivo runtime
- Permite operação offline automática em modo desconectado
- Modo de bloqueio segurança ativa quando detecta inconsistências
- Última sincronização usado para detectar dispositivos offline há muito tempo
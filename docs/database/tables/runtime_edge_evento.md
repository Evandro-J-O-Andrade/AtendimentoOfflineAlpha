# runtime_edge_evento

Objetivo: Registrar eventos de runtime ocorridos em dispositivos edge/offline, com controle de sincronização.

Descrição: Tabela que armazena eventos de runtime gerados em dispositivos que operam em modo offline ou edge, permitindo sincronização com o sistema central posteriormente.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_evento | bigint | NOT NULL | - | Chave primária da tabela, identificador único do evento |
| uuid_evento | char(36) | NOT NULL | - | UUID único que identifica o evento globalmente |
| id_sessao_usuario | bigint | NOT NULL | - | Referência ao id da sessão do usuário que gerou o evento |
| id_unidade | bigint unsigned | NOT NULL | - | Referência ao id da unidade onde o evento ocorreu |
| id_local | bigint | YES | NULL | Referência ao id do local operacional onde o evento ocorreu |
| dominio_fluxo | varchar(50) | NOT NULL | - | Domínio de fluxo ao qual o evento pertence |
| estado_origem | varchar(50) | NOT NULL | - | Estado de origem antes do evento |
| estado_destino | varchar(50) | NOT NULL | - | Estado de destino após o evento |
| payload_operacional | json | NOT NULL | - | Payload JSON com dados operacionais do evento |
| metadata_snapshot_hash | char(64) | NOT NULL | - | Hash do snapshot de metadados para integridade |
| modo_execucao | enum('ONLINE','OFFLINE') | NOT NULL | - | Modo de execução: ONLINE ou OFFLINE |
| status_sync | enum('PENDENTE','ENVIADO','CONFIRMADO','REJEITADO') | - | 'PENDENTE' | Status de sincronização: PENDENTE, ENVIADO, CONFIRMADO, REJEITADO |
| criado_em | datetime(6) | - | CURRENT_TIMESTAMP(6) | Data e hora de criação do evento |
| sincronizado_em | datetime(6) | YES | NULL | Data e hora em que o evento foi sincronizado |
| id_orquestrador | bigint | NOT NULL | - | Referência ao id do orquestrador que processou o evento |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde o evento ocorreu |

## Chaves
- Primária: id_evento
- Únicas: uk_runtime_evento_uuid (uuid_evento)
- Estrangeiras: fk_runtime_edge_evento_unidade (id_unidade → unidade.id_unidade) - vincula o evento à unidade |

## Índices
- PRIMARY KEY (id_evento)
- UNIQUE KEY uk_runtime_evento_uuid (uuid_evento)
- KEY idx_runtime_evento_sync (status_sync)
- KEY idx_runtime_evento_sessao (id_sessao_usuario)
- KEY idx_evento_orquestrador (id_orquestrador)
- KEY fk_runtime_edge_evento_unidade (id_unidade)

## Constraints
- CONSTRAINT fk_runtime_edge_evento_unidade FOREIGN KEY (id_unidade) REFERENCES unidade (id_unidade)

## Relacionamentos e Cardinalidade
- N:1 com unidade (uma unidade pode ter vários eventos runtime)
- N:1 com sessao_usuario (uma sessão pode ter vários eventos)

## Dependências
- Tabelas que dependem desta: -
| Esta tabela depende de: sessao_usuario, unidade

## Fluxo de utilização dentro do sistema
- Criado automaticamente quando evento ocorre em modo offline
- Status de sync controla fase de sincronização com central
- UUID permite identificação única global do evento
- Payload contém dados operacionais para processamento
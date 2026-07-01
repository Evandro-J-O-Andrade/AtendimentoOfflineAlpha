# runtime_dispositivo

Objetivo: Gerenciar dispositivos runtime com UUID, status e monitoramento de heartbeat para suporte a operação offline.

Descrição: Tabela que armazena informações de dispositivos runtime que executam a aplicação em modo offline ou edge, permitindo monitoramento de status, versão e último heartbeat.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_runtime_dispositivo | bigint | NOT NULL | - | Chave primária da tabela, identificador único do dispositivo runtime |
| id_dispositivo | bigint | NOT NULL | - | Referência ao id do dispositivo cadastrado |
| uuid_runtime | varchar(120) | NOT NULL | - | UUID único que identifica o dispositivo runtime |
| tipo_runtime | varchar(40) | NOT NULL | - | Tipo do runtime (ex: DESKTOP, MOBILE, TABLET) |
| versao_runtime | varchar(40) | YES | NULL | Versão do software runtime instalado |
| ip_runtime | varchar(45) | YES | NULL | Endereço IP do dispositivo runtime |
| status_runtime | varchar(30) | - | 'ONLINE' | Status do runtime: ONLINE, OFFLINE, DEGRADADO, etc. |
| ultimo_heartbeat | datetime(6) | YES | NULL | Data e hora do último heartbeat recebido |
| criado_em | datetime(6) | - | CURRENT_TIMESTAMP(6) | Data e hora de criação do registro do dispositivo |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde o dispositivo é registrado |

## Chaves
- Primária: id_runtime_dispositivo
- Únicas: uk_runtime_uuid (uuid_runtime)
- Estrangeiras: fk_runtime_dispositivo (id_dispositivo → dispositivo.id_dispositivo) - vincula o runtime ao dispositivo cadastrado |

## Índices
- PRIMARY KEY (id_runtime_dispositivo)
- UNIQUE KEY uk_runtime_uuid (uuid_runtime)
- KEY fk_runtime_dispositivo (id_dispositivo)

## Constraints
- CONSTRAINT fk_runtime_dispositivo FOREIGN KEY (id_dispositivo) REFERENCES dispositivo (id_dispositivo)

## Relacionamentos e Cardinalidade
- N:1 com dispositivo (um dispositivo pode ter um registro runtime)

## Dependências
- Tabelas que dependem desta: -
| Esta tabela depende de: dispositivo

## Fluxo de utilização dentro do sistema
- Criado quando um dispositivo runtime se conecta ao sistema
- Permite operação offline com sincronização posterior
- Heartbeat monitora se o dispositivo está ativo
- Status indica se o dispositivo está online ou em modo offline
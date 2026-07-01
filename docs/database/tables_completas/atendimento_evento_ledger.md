# atendimento_evento_ledger

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_evento | bigint | NOT NULL | - | (Documentar) |
| uuid_transacao | char(36) | NOT NULL | - | (Documentar) |
| uuid_transacao_pai | char(36) | YES | - | (Documentar) |
| sequencia_evento | int | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| id_sessao | bigint | NOT NULL | - | (Documentar) |
| id_perfil | bigint | NOT NULL | - | (Documentar) |
| nome_usuario | varchar(100) | YES | - | (Documentar) |
| acao | varchar(100) | NOT NULL | - | (Documentar) |
| modulo | varchar(50) | NOT NULL | - | (Documentar) |
| sub_modulo | varchar(50) | YES | - | (Documentar) |
| estado_origem | varchar(50) | YES | - | (Documentar) |
| estado_destino | varchar(50) | YES | - | (Documentar) |
| estado_anterior | json | YES | - | (Documentar) |
| estado_novo | json | YES | - | (Documentar) |
| payload_original | json | YES | - | (Documentar) |
| payload_processado | json | YES | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| status_evento | enum('SUCESSO' | NOT NULL | - | (Documentar) |
| codigo_erro | varchar(50) | YES | - | (Documentar) |
| mensagem | varchar(1000) | YES | - | (Documentar) |
| ip_origem | varchar(45) | YES | - | (Documentar) |
| user_agent | varchar(500) | YES | - | (Documentar) |
| hostname | varchar(100) | YES | - | (Documentar) |
| processing_time_ms | int | YES | - | (Documentar) |
| created_at | datetime(6) | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (uuid_transacao,sequencia_evento)
- Estrangeira: id_atendimento -> atendimento.id_atendimento
- Estrangeira: id_entidade -> saas_entidade.id_entidade

## Indices

- PRIMARY KEY (id_evento)
- KEY (uuid_transacao,sequencia_evento)
- KEY (uuid_transacao_pai)
- KEY (id_usuario)
- KEY (id_sessao)
- KEY (id_perfil)
- KEY (modulo)
- KEY (acao)
- KEY (created_at)
- KEY (id_atendimento)
- KEY (status_evento)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


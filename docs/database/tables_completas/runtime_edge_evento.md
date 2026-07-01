# runtime_edge_evento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_evento | bigint | NOT NULL | - | (Documentar) |
| uuid_evento | char(36) | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| id_local | bigint | YES | - | (Documentar) |
| dominio_fluxo | varchar(50) | NOT NULL | - | (Documentar) |
| estado_origem | varchar(50) | NOT NULL | - | (Documentar) |
| estado_destino | varchar(50) | NOT NULL | - | (Documentar) |
| payload_operacional | json | NOT NULL | - | (Documentar) |
| metadata_snapshot_hash | char(64) | NOT NULL | - | (Documentar) |
| modo_execucao | enum('ONLINE' | NOT NULL | - | (Documentar) |
| status_sync | enum('PENDENTE' | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| sincronizado_em | datetime(6) | YES | - | (Documentar) |
| id_orquestrador | bigint | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (uuid_evento)
- Estrangeira: id_unidade -> unidade.id_unidade

## Indices

- PRIMARY KEY (id_evento)
- KEY (uuid_evento)
- KEY (status_sync)
- KEY (id_sessao_usuario)
- KEY (id_orquestrador)
- KEY (id_unidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


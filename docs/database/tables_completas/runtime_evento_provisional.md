# runtime_evento_provisional

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_provisional | bigint | NOT NULL | - | (Documentar) |
| uuid_evento | char(36) | NOT NULL | - | (Documentar) |
| dominio_fluxo | varchar(50) | NOT NULL | - | (Documentar) |
| payload_operacional | json | NOT NULL | - | (Documentar) |
| hash_snapshot | char(64) | NOT NULL | - | (Documentar) |
| token_execucao | char(36) | NOT NULL | - | (Documentar) |
| versao_estado | bigint | NOT NULL | - | (Documentar) |
| status_provisional | enum('LOCAL_EXECUTADO' | YES | - | (Documentar) |
| criticidade_fluxo | tinyint | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| sincronizado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (uuid_evento)

## Indices

- PRIMARY KEY (id_provisional)
- KEY (uuid_evento)
- KEY (status_provisional)
- KEY (sincronizado_em)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


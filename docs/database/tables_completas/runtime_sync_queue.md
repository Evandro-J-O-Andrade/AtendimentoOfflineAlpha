# runtime_sync_queue

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_queue | bigint | NOT NULL | - | (Documentar) |
| uuid_evento | char(36) | NOT NULL | - | (Documentar) |
| tentativa_sync | int | YES | - | (Documentar) |
| ultimo_erro | text | YES | - | (Documentar) |
| proximo_retry_em | datetime(6) | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (uuid_evento)

## Indices

- PRIMARY KEY (id_queue)
- KEY (uuid_evento)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


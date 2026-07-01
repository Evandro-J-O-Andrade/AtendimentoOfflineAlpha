# assistencial_evento_hash

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_hash | bigint | NOT NULL | - | (Documentar) |
| hash_fingerprint | char(64) | NOT NULL | - | (Documentar) |
| id_ffa | bigint | NOT NULL | - | (Documentar) |
| evento | varchar(60) | NOT NULL | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (hash_fingerprint)

## Indices

- PRIMARY KEY (id_hash)
- KEY (hash_fingerprint)
- KEY (id_ffa,evento)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


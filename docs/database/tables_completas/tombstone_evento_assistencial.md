# tombstone_evento_assistencial

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_tombstone | bigint | NOT NULL | - | (Documentar) |
| id_ffa | bigint | NOT NULL | - | (Documentar) |
| evento | varchar(60) | NOT NULL | - | (Documentar) |
| estado_cancelado | varchar(60) | YES | - | (Documentar) |
| id_sessao_usuario | bigint | YES | - | (Documentar) |
| cancelado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (id_ffa,evento)

## Indices

- PRIMARY KEY (id_tombstone)
- KEY (id_ffa,evento)
- KEY (id_ffa,evento)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


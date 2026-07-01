# assistencial_quorum_clinico

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_quorum | bigint | NOT NULL | - | (Documentar) |
| id_ffa | bigint | NOT NULL | - | (Documentar) |
| evento | varchar(60) | NOT NULL | - | (Documentar) |
| total_unidades_participantes | int | YES | - | (Documentar) |
| unidades_confirmadas | int | YES | - | (Documentar) |
| quorum_valido | tinyint(1) | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (id_ffa,evento)

## Indices

- PRIMARY KEY (id_quorum)
- KEY (id_ffa,evento)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


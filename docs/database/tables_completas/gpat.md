# gpat

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_gpat | bigint | NOT NULL | - | (Documentar) |
| id_ffa | bigint | NOT NULL | - | (Documentar) |
| id_codigo_universal | bigint | NOT NULL | - | (Documentar) |
| codigo_gpat | varchar(50) | NOT NULL | - | (Documentar) |
| barcode_gpat | varchar(60) | NOT NULL | - | (Documentar) |
| origem | enum('AUTO' | NOT NULL | - | (Documentar) |
| observacao | varchar(255) | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (id_ffa)
- Unica: UNIQUE KEY (codigo_gpat)
- Unica: UNIQUE KEY (id_codigo_universal)

## Indices

- PRIMARY KEY (id_gpat)
- KEY (id_ffa)
- KEY (codigo_gpat)
- KEY (id_codigo_universal)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


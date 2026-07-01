# lab_protocolo_interno

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | bigint | NOT NULL | - | (Documentar) |
| id_ffa | bigint | NOT NULL | - | (Documentar) |
| codigo_amostra | varchar(50) | YES | - | (Documentar) |
| tipo_material | varchar(50) | YES | - | (Documentar) |
| status_laboratorial | enum('COLETADO' | YES | - | (Documentar) |
| impresso | tinyint(1) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (codigo_amostra)

## Indices

- PRIMARY KEY (id)
- KEY (codigo_amostra)
- KEY (id_ffa)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


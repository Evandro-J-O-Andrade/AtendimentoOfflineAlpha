# dispositivo

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_dispositivo | bigint | NOT NULL | - | (Documentar) |
| identificador | varchar(120) | NOT NULL | - | (Documentar) |
| descricao | varchar(120) | YES | - | (Documentar) |
| tipo | varchar(50) | YES | - | (Documentar) |
| ip_registro | varchar(45) | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (identificador)

## Indices

- PRIMARY KEY (id_dispositivo)
- KEY (identificador)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


# painel_evento_stream

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_evento | bigint | NOT NULL | - | (Documentar) |
| dominio | varchar(50) | NOT NULL | - | (Documentar) |
| tipo_evento | varchar(50) | NOT NULL | - | (Documentar) |
| id_referencia | bigint | NOT NULL | - | (Documentar) |
| id_painel | bigint | YES | - | (Documentar) |
| id_lane | bigint | YES | - | (Documentar) |
| id_local | bigint | YES | - | (Documentar) |
| payload | json | NOT NULL | - | (Documentar) |
| processado | tinyint(1) | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (id_evento)
- KEY (id_painel,processado)
- KEY (id_referencia)
- KEY (processado,criado_em)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


# assistencial_minipal_metric

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_metric | bigint | NOT NULL | - | (Documentar) |
| id_sistema | bigint | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| score_global | decimal(10 | YES | - | (Documentar) |
| risco_fila | decimal(10 | YES | - | (Documentar) |
| risco_evasao | decimal(10 | YES | - | (Documentar) |
| risco_retry | decimal(10 | YES | - | (Documentar) |
| estabilidade_runtime | decimal(10 | YES | - | (Documentar) |
| estado_rede | varchar(40) | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (id_metric)
- KEY (id_sistema,criado_em)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


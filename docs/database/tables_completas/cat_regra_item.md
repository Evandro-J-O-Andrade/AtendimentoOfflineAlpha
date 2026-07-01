# cat_regra_item

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_cat_regra | bigint | NOT NULL | - | (Documentar) |
| codigo_sigtap | varchar(30) | YES | - | (Documentar) |
| descricao | varchar(255) | YES | - | (Documentar) |
| ativo | tinyint(1) | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (codigo_sigtap)

## Indices

- PRIMARY KEY (id_cat_regra)
- KEY (codigo_sigtap)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


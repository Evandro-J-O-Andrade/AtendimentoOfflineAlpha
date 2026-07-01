# sus_cid10_competencia

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_cid10c | bigint | NOT NULL | - | (Documentar) |
| competencia | char(6) | NOT NULL | - | (Documentar) |
| cid10 | varchar(10) | NOT NULL | - | (Documentar) |
| descricao | varchar(255) | YES | - | (Documentar) |
| ativo | tinyint(1) | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (competencia,cid10)

## Indices

- PRIMARY KEY (id_cid10c)
- KEY (competencia,cid10)
- KEY (cid10)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


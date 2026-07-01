# md_cid10

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| competencia | char(6) | NOT NULL | - | (Documentar) |
| codigo | varchar(10) | NOT NULL | - | (Documentar) |
| descricao | varchar(255) | NOT NULL | - | (Documentar) |
| categoria | varchar(10) | YES | - | (Documentar) |
| subcategoria | varchar(10) | YES | - | (Documentar) |
| capitulo | varchar(20) | YES | - | (Documentar) |
| sexo_restricao | enum('A' | NOT NULL | - | (Documentar) |
| idade_min_meses | int | YES | - | (Documentar) |
| idade_max_meses | int | YES | - | (Documentar) |
| ativo | tinyint(1) | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- KEY (codigo)
- KEY (competencia)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


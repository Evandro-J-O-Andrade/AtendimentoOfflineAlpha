# sus_sigtap_procedimento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_sigtap | bigint | NOT NULL | - | (Documentar) |
| competencia | char(6) | NOT NULL | - | (Documentar) |
| codigo | varchar(30) | NOT NULL | - | (Documentar) |
| descricao | varchar(255) | NOT NULL | - | (Documentar) |
| descricao_completa | text | YES | - | (Documentar) |
| grupo | varchar(80) | YES | - | (Documentar) |
| subgrupo | varchar(80) | YES | - | (Documentar) |
| forma_organizacao | varchar(80) | YES | - | (Documentar) |
| complexidade | varchar(40) | YES | - | (Documentar) |
| sexo | enum('I' | NOT NULL | - | (Documentar) |
| idade_min | int | YES | - | (Documentar) |
| idade_max | int | YES | - | (Documentar) |
| exige_cat_default | tinyint(1) | NOT NULL | - | (Documentar) |
| exige_sinan_default | tinyint(1) | NOT NULL | - | (Documentar) |
| ativo | tinyint(1) | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (competencia,codigo)

## Indices

- PRIMARY KEY (id_sigtap)
- KEY (competencia,codigo)
- KEY (codigo)
- KEY (competencia)
- KEY (exige_cat_default)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


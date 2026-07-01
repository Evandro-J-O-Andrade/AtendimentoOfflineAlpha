# sus_cnes_estabelecimento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_cnes | bigint | NOT NULL | - | (Documentar) |
| competencia | char(6) | NOT NULL | - | (Documentar) |
| cnes | varchar(20) | NOT NULL | - | (Documentar) |
| nome | varchar(255) | YES | - | (Documentar) |
| municipio | varchar(120) | YES | - | (Documentar) |
| uf | char(2) | YES | - | (Documentar) |
| ativo | tinyint(1) | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | YES | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (competencia,cnes)

## Indices

- PRIMARY KEY (id_cnes)
- KEY (competencia,cnes)
- KEY (cnes)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


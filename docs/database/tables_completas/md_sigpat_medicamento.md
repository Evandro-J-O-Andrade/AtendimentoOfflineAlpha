# md_sigpat_medicamento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| competencia | char(6) | NOT NULL | - | (Documentar) |
| codigo | varchar(20) | NOT NULL | - | (Documentar) |
| descricao | varchar(255) | NOT NULL | - | (Documentar) |
| apresentacao | varchar(160) | YES | - | (Documentar) |
| forma_farmaceutica | varchar(80) | YES | - | (Documentar) |
| concentracao | varchar(60) | YES | - | (Documentar) |
| unidade_medida | varchar(30) | YES | - | (Documentar) |
| via_administracao | varchar(60) | YES | - | (Documentar) |
| ativo | tinyint(1) | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- KEY (codigo)
- KEY (competencia)
- KEY (descricao)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


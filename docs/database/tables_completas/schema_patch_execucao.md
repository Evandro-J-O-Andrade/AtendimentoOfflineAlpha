# schema_patch_execucao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_patch_execucao | bigint | NOT NULL | - | (Documentar) |
| patch_nome | varchar(120) | NOT NULL | - | (Documentar) |
| hash_patch | varchar(128) | YES | - | (Documentar) |
| status_execucao | enum('SUCESSO' | NOT NULL | - | (Documentar) |
| detalhes | json | YES | - | (Documentar) |
| executado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (id_patch_execucao)
- KEY (patch_nome,executado_em)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


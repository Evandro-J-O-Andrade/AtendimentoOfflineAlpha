# local

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_local | bigint | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| id_tipo_local | bigint | NOT NULL | - | (Documentar) |
| codigo | varchar(40) | YES | - | (Documentar) |
| nome | varchar(120) | NOT NULL | - | (Documentar) |
| descricao | text | YES | - | (Documentar) |
| andar | varchar(20) | YES | - | (Documentar) |
| bloco | varchar(20) | YES | - | (Documentar) |
| ativo | tinyint | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| atualizado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_entidade -> saas_entidade.id_entidade
- Estrangeira: id_tipo_local -> tipo_local.id_tipo_local
- Estrangeira: id_unidade -> unidade.id_unidade

## Indices

- PRIMARY KEY (id_local)
- KEY (id_unidade)
- KEY (id_tipo_local)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


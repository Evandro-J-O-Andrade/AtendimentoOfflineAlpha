# tipo_local

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_tipo_local | bigint | NOT NULL | - | (Documentar) |
| codigo | varchar(40) | NOT NULL | - | (Documentar) |
| nome | varchar(120) | NOT NULL | - | (Documentar) |
| categoria | varchar(40) | NOT NULL | - | (Documentar) |
| descricao | text | YES | - | (Documentar) |
| ativo | tinyint | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| categoria_operacional | varchar(40) | YES | - | (Documentar) |
| descricao_operacional | text | YES | - | (Documentar) |
| atualizado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | YES | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (codigo)

## Indices

- PRIMARY KEY (id_tipo_local)
- KEY (codigo)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


# cat_evento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_cat_evento | bigint | NOT NULL | - | (Documentar) |
| id_cat | bigint | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| evento | varchar(50) | NOT NULL | - | (Documentar) |
| payload_json | json | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (id_cat_evento)
- KEY (id_cat)
- KEY (evento)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


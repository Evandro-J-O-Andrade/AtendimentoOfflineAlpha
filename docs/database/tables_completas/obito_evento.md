# obito_evento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_obito_evento | bigint | NOT NULL | - | (Documentar) |
| id_obito | bigint | NOT NULL | - | (Documentar) |
| tipo_evento | enum('REGISTRADO' | NOT NULL | - | (Documentar) |
| descricao | text | YES | - | (Documentar) |
| id_usuario | bigint | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_obito -> obito.id_obito

## Indices

- PRIMARY KEY (id_obito_evento)
- KEY (id_obito)
- KEY (tipo_evento,criado_em)
- KEY (id_obito,criado_em)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


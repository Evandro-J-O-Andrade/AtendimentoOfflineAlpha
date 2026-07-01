# remocao_evento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_remocao_evento | bigint | NOT NULL | - | (Documentar) |
| id_remocao | bigint | NOT NULL | - | (Documentar) |
| evento | varchar(80) | NOT NULL | - | (Documentar) |
| detalhe | text | YES | - | (Documentar) |
| id_usuario | bigint | YES | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_remocao -> remocao.id_remocao
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_remocao_evento)
- KEY (id_remocao)
- KEY (id_usuario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


# cat_acidente_trabalho_evento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_evento | bigint | NOT NULL | - | (Documentar) |
| id_cat | bigint | NOT NULL | - | (Documentar) |
| tipo_evento | enum('CRIACAO' | NOT NULL | - | (Documentar) |
| status_anterior | varchar(30) | YES | - | (Documentar) |
| status_novo | varchar(30) | YES | - | (Documentar) |
| detalhes | text | YES | - | (Documentar) |
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_cat -> cat_acidente_trabalho.id

## Indices

- PRIMARY KEY (id_evento)
- KEY (id_cat)
- KEY (id_sessao_usuario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


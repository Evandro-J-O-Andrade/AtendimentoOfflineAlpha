# gaso_evento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_gaso_evento | bigint | NOT NULL | - | (Documentar) |
| id_gaso | bigint | NOT NULL | - | (Documentar) |
| evento | varchar(80) | NOT NULL | - | (Documentar) |
| detalhe | text | YES | - | (Documentar) |
| id_usuario | bigint | YES | - | (Documentar) |
| id_sessao_usuario | bigint | YES | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_gaso -> gaso_solicitacao.id_gaso
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_gaso_evento)
- KEY (id_gaso)
- KEY (id_usuario)
- KEY (id_sessao_usuario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


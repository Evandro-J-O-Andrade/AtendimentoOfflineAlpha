# gpat_evento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_gpat_evento | bigint | NOT NULL | - | (Documentar) |
| id_gpat | bigint | NOT NULL | - | (Documentar) |
| tipo_evento | varchar(50) | NOT NULL | - | (Documentar) |
| detalhes | text | YES | - | (Documentar) |
| id_usuario | bigint | YES | - | (Documentar) |
| id_sessao_usuario | bigint | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_gpat -> gpat_atendimento.id_gpat
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_gpat_evento)
- KEY (id_gpat)
- KEY (tipo_evento)
- KEY (id_usuario)
- KEY (id_sessao_usuario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


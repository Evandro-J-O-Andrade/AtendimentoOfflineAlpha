# produtividade_evento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_evento | bigint | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| tipo | enum('INICIO_ATENDIMENTO' | NOT NULL | - | (Documentar) |
| id_ffa | bigint | YES | - | (Documentar) |
| id_senha | bigint | YES | - | (Documentar) |
| ocorrido_em | datetime | NOT NULL | - | (Documentar) |
| detalhe | varchar(255) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_usuario -> usuario.id_usuario
- Estrangeira: id_unidade -> unidade.id_unidade

## Indices

- PRIMARY KEY (id_evento)
- KEY (id_usuario,ocorrido_em)
- KEY (tipo,ocorrido_em)
- KEY (id_unidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


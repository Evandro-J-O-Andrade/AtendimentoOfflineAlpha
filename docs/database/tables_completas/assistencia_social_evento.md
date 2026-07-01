# assistencia_social_evento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_evento | bigint | NOT NULL | - | (Documentar) |
| id_as | bigint | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| tipo | varchar(50) | NOT NULL | - | (Documentar) |
| detalhe | text | YES | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_as -> assistencia_social_atendimento.id_as
- Estrangeira: id_sessao_usuario -> sessao_usuario.id_sessao_usuario
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_evento)
- KEY (id_as,criado_em)
- KEY (id_sessao_usuario,criado_em)
- KEY (id_usuario,criado_em)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


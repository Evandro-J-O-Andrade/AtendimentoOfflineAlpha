# sala_notificacao_evento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_evento | bigint | NOT NULL | - | (Documentar) |
| id_notificacao | bigint | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| tipo | varchar(50) | NOT NULL | - | (Documentar) |
| detalhe | text | YES | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_notificacao -> sala_notificacao.id_notificacao
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_evento)
- KEY (id_notificacao,criado_em)
- KEY (id_sessao_usuario,criado_em)
- KEY (id_usuario,criado_em)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


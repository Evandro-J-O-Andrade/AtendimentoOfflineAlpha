# notificacao_violencia_evento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_evento | bigint | NOT NULL | - | (Documentar) |
| id_notificacao | bigint | NOT NULL | - | (Documentar) |
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
- Estrangeira: id_notificacao -> notificacao_violencia.id

## Indices

- PRIMARY KEY (id_evento)
- KEY (id_notificacao)
- KEY (id_sessao_usuario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


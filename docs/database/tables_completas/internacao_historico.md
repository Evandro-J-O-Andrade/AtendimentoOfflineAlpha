# internacao_historico

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | bigint | NOT NULL | - | (Documentar) |
| id_internacao | bigint | NOT NULL | - | (Documentar) |
| evento | enum('ENTRADA' | NOT NULL | - | (Documentar) |
| descricao | text | YES | - | (Documentar) |
| id_usuario | bigint | YES | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| id_sessao_usuario | bigint | YES | - | (Documentar) |
| id_local_operacional | bigint | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (id)
- KEY (id_internacao)
- KEY (id_internacao,criado_em)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


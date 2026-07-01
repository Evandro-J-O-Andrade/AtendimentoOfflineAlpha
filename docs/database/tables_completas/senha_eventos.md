# senha_eventos

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_evento | bigint | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | YES | - | (Documentar) |
| id_senha | bigint | NOT NULL | - | (Documentar) |
| tipo_evento | varchar(60) | NOT NULL | - | (Documentar) |
| detalhe | text | YES | - | (Documentar) |
| status_de | varchar(50) | YES | - | (Documentar) |
| status_para | varchar(50) | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | YES | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (id_evento)
- KEY (id_senha,criado_em)
- KEY (id_sessao_usuario,criado_em)
- KEY (tipo_evento,criado_em)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


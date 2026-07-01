# transporte_ambulancia_evento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_evento | bigint | NOT NULL | - | (Documentar) |
| id_transporte | bigint | NOT NULL | - | (Documentar) |
| evento | varchar(80) | NOT NULL | - | (Documentar) |
| detalhe | text | YES | - | (Documentar) |
| id_usuario | bigint | YES | - | (Documentar) |
| id_sessao_usuario | bigint | YES | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_transporte -> transporte_ambulancia.id

## Indices

- PRIMARY KEY (id_evento)
- KEY (id_transporte)
- KEY (id_sessao_usuario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


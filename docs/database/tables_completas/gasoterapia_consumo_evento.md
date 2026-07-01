# gasoterapia_consumo_evento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_evento | bigint | NOT NULL | - | (Documentar) |
| id_consumo | bigint | NOT NULL | - | (Documentar) |
| evento | varchar(50) | NOT NULL | - | (Documentar) |
| detalhe | text | YES | - | (Documentar) |
| id_usuario | bigint | YES | - | (Documentar) |
| id_sessao_usuario | bigint | YES | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_consumo -> gasoterapia_consumo.id

## Indices

- PRIMARY KEY (id_evento)
- KEY (id_consumo)
- KEY (id_sessao_usuario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


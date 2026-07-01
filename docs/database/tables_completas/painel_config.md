# painel_config

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_painel_config | bigint | NOT NULL | - | (Documentar) |
| id_painel | bigint | YES | - | (Documentar) |
| chave | varchar(80) | NOT NULL | - | (Documentar) |
| valor_bool | tinyint(1) | YES | - | (Documentar) |
| valor_int | int | YES | - | (Documentar) |
| valor_decimal | decimal(12 | YES | - | (Documentar) |
| valor_text | text | YES | - | (Documentar) |
| valor_json | json | YES | - | (Documentar) |
| valor_enum | varchar(80) | YES | - | (Documentar) |
| atualizado_em | datetime | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | YES | - | (Documentar) |
| id_usuario | bigint | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (id_painel,chave)
- Estrangeira: id_painel -> painel.id_painel

## Indices

- PRIMARY KEY (id_painel_config)
- KEY (id_painel,chave)
- KEY (chave)
- KEY (id_painel)
- KEY (atualizado_em)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


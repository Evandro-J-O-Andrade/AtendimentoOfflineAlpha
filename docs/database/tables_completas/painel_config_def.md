# painel_config_def

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_painel_config_def | bigint | NOT NULL | - | (Documentar) |
| chave | varchar(80) | NOT NULL | - | (Documentar) |
| aplica_em | enum('PAINEL' | NOT NULL | - | (Documentar) |
| tipo_valor | enum('BOOL' | NOT NULL | - | (Documentar) |
| default_bool | tinyint(1) | YES | - | (Documentar) |
| default_int | int | YES | - | (Documentar) |
| default_decimal | decimal(12 | YES | - | (Documentar) |
| default_text | text | YES | - | (Documentar) |
| default_json | json | YES | - | (Documentar) |
| default_enum | varchar(80) | YES | - | (Documentar) |
| categoria | varchar(50) | YES | - | (Documentar) |
| descricao | varchar(255) | YES | - | (Documentar) |
| enum_opcoes_json | json | YES | - | (Documentar) |
| ativo | tinyint(1) | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | YES | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (chave)
- Unica: UNIQUE KEY (aplica_em,chave)

## Indices

- PRIMARY KEY (id_painel_config_def)
- KEY (chave)
- KEY (aplica_em,chave)
- KEY (categoria)
- KEY (ativo)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


# evento_geral

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_evento | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| dominio | varchar(50) | NOT NULL | - | (Documentar) |
| tipo_evento | varchar(100) | NOT NULL | - | (Documentar) |
| id_referencia | bigint | YES | - | (Documentar) |
| payload | json | YES | - | (Documentar) |
| metadata | json | YES | - | (Documentar) |
| criado_em | datetime(6) | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_unidade -> unidade.id_unidade

## Indices

- PRIMARY KEY (id_evento)
- KEY (id_usuario)
- KEY (id_unidade)
- KEY (dominio,tipo_evento)
- KEY (id_referencia)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


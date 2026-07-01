# estoque_inventario

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_inventario | bigint | NOT NULL | - | (Documentar) |
| id_estoque_local | bigint | NOT NULL | - | (Documentar) |
| id_codigo_universal | bigint | YES | - | (Documentar) |
| codigo | varchar(60) | YES | - | (Documentar) |
| barcode | varchar(60) | YES | - | (Documentar) |
| status | enum('ABERTO' | NOT NULL | - | (Documentar) |
| id_sessao_usuario_abertura | bigint | NOT NULL | - | (Documentar) |
| aberto_em | datetime | NOT NULL | - | (Documentar) |
| fechado_em | datetime | YES | - | (Documentar) |
| observacao | varchar(255) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (id_inventario)
- KEY (id_estoque_local)
- KEY (status)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


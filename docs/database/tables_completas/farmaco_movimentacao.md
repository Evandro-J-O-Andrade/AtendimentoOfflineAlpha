# farmaco_movimentacao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_movimentacao | bigint | NOT NULL | - | (Documentar) |
| id_farmaco | bigint | NOT NULL | - | (Documentar) |
| id_lote | bigint | NOT NULL | - | (Documentar) |
| id_cidade | bigint | NOT NULL | - | (Documentar) |
| tipo | enum('ENTRADA' | NOT NULL | - | (Documentar) |
| quantidade | int | NOT NULL | - | (Documentar) |
| origem | enum('COMPRA' | NOT NULL | - | (Documentar) |
| id_ffa | bigint | YES | - | (Documentar) |
| observacao | varchar(255) | YES | - | (Documentar) |
| realizado_por | bigint | NOT NULL | - | (Documentar) |
| data_mov | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_farmaco -> farmaco.id_farmaco
- Estrangeira: id_lote -> farmaco_lote.id_lote

## Indices

- PRIMARY KEY (id_movimentacao)
- KEY (id_farmaco)
- KEY (id_lote)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


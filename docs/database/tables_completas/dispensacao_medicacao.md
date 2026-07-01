# dispensacao_medicacao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_dispensacao | bigint | NOT NULL | - | (Documentar) |
| id_ordem | bigint | NOT NULL | - | (Documentar) |
| id_item | bigint | YES | - | (Documentar) |
| id_farmaco | bigint | NOT NULL | - | (Documentar) |
| id_lote | bigint | NOT NULL | - | (Documentar) |
| quantidade | decimal(10 | NOT NULL | - | (Documentar) |
| id_usuario_dispensador | bigint | NOT NULL | - | (Documentar) |
| data_hora | datetime | YES | - | (Documentar) |
| status | enum('ENTREGUE' | YES | - | (Documentar) |
| observacao | text | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_item -> ordem_assistencial_item.id_item

## Indices

- PRIMARY KEY (id_dispensacao)
- KEY (id_ordem)
- KEY (id_lote)
- KEY (id_item)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


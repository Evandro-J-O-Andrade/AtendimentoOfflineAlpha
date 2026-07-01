# exame_pedido_item

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_item | bigint | NOT NULL | - | (Documentar) |
| id_pedido | bigint | NOT NULL | - | (Documentar) |
| codigo_procedimento | varchar(20) | YES | - | (Documentar) |
| nome_exame | varchar(150) | YES | - | (Documentar) |
| material | varchar(50) | YES | - | (Documentar) |
| valor_custo | decimal(10 | YES | - | (Documentar) |
| valor_venda | decimal(10 | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_pedido -> exame_pedido.id_pedido

## Indices

- PRIMARY KEY (id_item)
- KEY (id_pedido)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


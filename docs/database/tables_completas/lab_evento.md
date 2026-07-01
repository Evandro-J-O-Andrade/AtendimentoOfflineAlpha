# lab_evento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | bigint | NOT NULL | - | (Documentar) |
| id_pedido | bigint | NOT NULL | - | (Documentar) |
| status_novo | varchar(50) | YES | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| data_hora | datetime | YES | - | (Documentar) |
| payload_auditoria | text | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_pedido -> lab_pedido.id_pedido

## Indices

- PRIMARY KEY (id)
- KEY (id_pedido)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


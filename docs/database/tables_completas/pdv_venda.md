# pdv_venda

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_venda | bigint | NOT NULL | - | (Documentar) |
| id_estoque_local | bigint | NOT NULL | - | (Documentar) |
| id_cliente | bigint | YES | - | (Documentar) |
| id_codigo_universal | bigint | YES | - | (Documentar) |
| codigo | varchar(60) | YES | - | (Documentar) |
| barcode | varchar(60) | YES | - | (Documentar) |
| status | enum('ABERTA' | NOT NULL | - | (Documentar) |
| total_bruto | decimal(14 | NOT NULL | - | (Documentar) |
| desconto | decimal(14 | NOT NULL | - | (Documentar) |
| total_liquido | decimal(14 | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| pago_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_cliente -> cliente.id_cliente
- Estrangeira: id_codigo_universal -> codigo_universal.id_codigo
- Estrangeira: id_estoque_local -> estoque_local.id_estoque_local

## Indices

- PRIMARY KEY (id_venda)
- KEY (status)
- KEY (id_cliente)
- KEY (id_estoque_local)
- KEY (id_sessao_usuario)
- KEY (id_codigo_universal)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


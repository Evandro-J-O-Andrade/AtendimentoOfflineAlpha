# venda

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_venda | bigint | NOT NULL | - | (Documentar) |
| id_caixa | bigint | NOT NULL | - | (Documentar) |
| id_cliente | bigint | YES | - | (Documentar) |
| origem | enum('PDV_RUA' | NOT NULL | - | (Documentar) |
| status | enum('ABERTA' | NOT NULL | - | (Documentar) |
| total_itens | decimal(10 | NOT NULL | - | (Documentar) |
| total_desconto | decimal(10 | NOT NULL | - | (Documentar) |
| total_final | decimal(10 | NOT NULL | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| pago_em | datetime | YES | - | (Documentar) |
| cancelado_em | datetime | YES | - | (Documentar) |
| criado_por | bigint | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_caixa -> caixa.id_caixa
- Estrangeira: id_cliente -> cliente.id_cliente
- Estrangeira: criado_por -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_venda)
- KEY (status,criado_em)
- KEY (id_caixa)
- KEY (id_cliente)
- KEY (criado_por)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


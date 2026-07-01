# pdv_pagamento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_pagamento | bigint | NOT NULL | - | (Documentar) |
| id_venda | bigint | NOT NULL | - | (Documentar) |
| forma | enum('DINHEIRO' | NOT NULL | - | (Documentar) |
| valor | decimal(14 | NOT NULL | - | (Documentar) |
| nsu | varchar(80) | YES | - | (Documentar) |
| autorizacao | varchar(80) | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_venda -> pdv_venda.id_venda

## Indices

- PRIMARY KEY (id_pagamento)
- KEY (id_venda)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


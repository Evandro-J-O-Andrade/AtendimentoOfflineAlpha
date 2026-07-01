# venda_pagamento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_venda_pagamento | bigint | NOT NULL | - | (Documentar) |
| id_venda | bigint | NOT NULL | - | (Documentar) |
| id_forma_pagamento | int | NOT NULL | - | (Documentar) |
| valor | decimal(10 | NOT NULL | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_forma_pagamento -> forma_pagamento.id_forma_pagamento
- Estrangeira: id_venda -> venda.id_venda

## Indices

- PRIMARY KEY (id_venda_pagamento)
- KEY (id_venda)
- KEY (id_forma_pagamento)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)


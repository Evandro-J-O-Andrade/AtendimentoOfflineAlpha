# pdv_pagamento

Objetivo: Registrar os pagamentos das vendas realizadas no PDV.
Descrição: Tabela que armazena os registros de pagamento de cada venda no PDV, permitindo múltiplas formas de pagamento (dinheiro, débito, crédito, PIX, convênio) por venda.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_pagamento | bigint | NOT NULL | - | Identificador único do pagamento (chave primária, auto incremento) |
| id_venda | bigint | NOT NULL | - | ID da venda sendo paga |
| forma | enum('DINHEIRO','DEBITO','CREDITO','PIX','CONVENIO','OUTRO') | NOT NULL | - | Forma de pagamento utilizada |
| valor | decimal(14,2) | NOT NULL | - | Valor do pagamento nesta forma |
| nsu | varchar(80) | YES | NULL | Número do NSU (comprovante) do pagamento |
| autorizacao | varchar(80) | YES | NULL | Código de autorização do pagamento |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data/hora do registro do pagamento |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual o pagamento pertence |

## Chaves
- Primária: id_pagamento
- Únicas: (nenhuma)
- Estrangeiras: 
  - fk_pdv_pag_venda: id_venda → pdv_venda (id_venda) com CASCADE

## Índices
- PRIMARY KEY (id_pagamento)
- KEY ix_pag_venda (id_venda)

## Constraints
- PRIMARY KEY: id_pagamento
- FOREIGN KEY: fk_pdv_pag_venda

## Relacionamentos e Cardinalidade
- N:1 com pdv_venda: Muitos pagamentos pertencem a uma venda

## Dependências
- Esta tabela depende de: pdv_venda, saas_entidade
- Não há tabelas que dependem desta tabela

## Fluxo de utilização dentro do sistema
Utilizada para registrar cada forma de pagamento em uma venda. Uma venda pode ter múltiplos pagamentos (ex: metade em dinheiro, metade em cartão). O NSU e autorização são armazenados para conciliação bancária. O total dos pagamentos deve igualar o total_liquido da venda.
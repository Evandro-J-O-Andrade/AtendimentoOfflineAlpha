# venda_pagamento

Objetivo: Registrar os pagamentos realizados para cada venda, vinculando formas de pagamento e valores.
Descrição: Tabela de detalhes financeiros da venda que permite dividir o pagamento em múltiplas formas (dinheiro, cartão, Pix, convênio, etc.). Cada registro representa um meio de pagamento utilizado para quitar total ou parcialmente uma venda. Suporta vendas com pagamento misto e permite conciliação financeira detalhada.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_venda_pagamento | bigint | NO | AUTO_INCREMENT | Chave primária única que identifica o registro de pagamento |
| id_venda | bigint | NO | NULL | Identificador da venda à qual este pagamento pertence |
| id_forma_pagamento | int | NO | NULL | Identificador da forma de pagamento utilizada (dinheiro, cartão, Pix, etc.) |
| valor | decimal(10,2) | NO | NULL | Valor pago por esta forma de pagamento específica |
| criado_em | datetime | YES | CURRENT_TIMESTAMP | Data e hora do registro do pagamento |
| id_entidade | bigint unsigned | NO | NULL | Identificador da entidade SaaS à qual este pagamento pertence |

## Chaves
- Primária: id_venda_pagamento
- Únicas: Nenhuma
- Estrangeiras: fk_vp_forma (id_forma_pagamento -> forma_pagamento.id_forma_pagamento), fk_vp_venda (id_venda -> venda.id_venda)

## Índices
- idx_vp_venda (id_venda)
- fk_vp_forma (id_forma_pagamento)

## Constraints
- fk_vp_forma: FOREIGN KEY (id_forma_pagamento) REFERENCES forma_pagamento (id_forma_pagamento)
- fk_vp_venda: FOREIGN KEY (id_venda) REFERENCES venda (id_venda)

## Relacionamentos e Cardinalidade
- N:1 com venda (muitos pagamentos pertencem a uma venda)
- N:1 com forma_pagamento (muitos pagamentos podem usar a mesma forma de pagamento)

## Dependências
- Depende de: venda, forma_pagamento, saas_entidade
- Dependências reversas: Nenhuma tabela principal depende diretamente desta

## Fluxo de utilização dentro do sistema
- Quando um pagamento é registrado no PDV, um item é inserido aqui
- Permite vendas com pagamento misto (ex: 50% cartão + 50% Pix)
- A soma dos valores de venda_pagamento deve igualar o total_final da venda para que status mude para PAGA
- Usado para conciliação financeira diária e fechamento de caixa
- Consultado em relatórios de meios de pagamento mais utilizados

# pdv_venda_item

Objetivo: Armazenar os itens de cada venda realizada no PDV.
Descrição: Tabela que contém os itens individuais de cada venda no PDV, com referência ao produto, lote, quantidade, valor unitário e total.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_item | bigint | NOT NULL | - | Identificador único do item (chave primária, auto incremento) |
| id_venda | bigint | NOT NULL | - | ID da venda à qual o item pertence |
| id_produto | bigint | NOT NULL | - | ID do produto vendido |
| id_lote | bigint | YES | NULL | ID do lote do produto (para controle de validade) |
| quantidade | decimal(14,3) | NOT NULL | - | Quantidade do produto vendida |
| valor_unitario | decimal(14,4) | NOT NULL | - | Preço unitário do produto na venda |
| valor_total | decimal(14,2) | NOT NULL | - | Valor total do item (quantidade × valor_unitário) |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data/hora de criação do item na venda |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual o item pertence |

## Chaves
- Primária: id_item
- Únicas: (nenhuma)
- Estrangeiras: 
  - fk_pdv_item_lote: id_lote → estoque_lote (id_lote) com SET NULL
  - fk_pdv_item_prod: id_produto → estoque_produto (id_produto) com RESTRICT
  - fk_pdv_item_venda: id_venda → pdv_venda (id_venda) com CASCADE

## Índices
- PRIMARY KEY (id_item)
- KEY ix_venda_item_venda (id_venda)
- KEY ix_venda_item_prod (id_produto)
- KEY fk_pdv_item_lote (id_lote)

## Constraints
- PRIMARY KEY: id_item
- FOREIGN KEY: fk_pdv_item_lote
- FOREIGN KEY: fk_pdv_item_prod
- FOREIGN KEY: fk_pdv_item_venda

## Relacionamentos e Cardinalidade
- N:1 com pdv_venda: Muitos itens pertencem a uma venda
- N:1 com estoque_produto: Muitos itens usam um produto
- N:1 com estoque_lote: Muitos itens podem referenciar um lote

## Dependências
- Esta tabela depende de: pdv_venda, estoque_produto, estoque_lote, saas_entidade
- Não há tabelas que dependem desta tabela

## Fluxo de utilização dentro do sistema
Utilizada para registrar cada linha de produto vendida. Ao adicionar um item à venda, é criado um registro aqui com produto, quantidade, valor e lote. O lote é importante para rastrear produtos vencidos. O total da venda é calculado somando os valor_total de todos os itens.
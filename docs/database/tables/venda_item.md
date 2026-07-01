# venda_item

Objetivo: Armazenar os itens individuais de cada venda, com quantidades, valores e referências a produtos/lotes.
Descrição: Tabela de detalhes de venda que registra cada produto ou serviço incluído em uma transação comercial. Controla quantidade, valor unitário, descontos e total por linha de item, além de vincular a fármacos e lotes específicos quando aplicável. Funciona como base para cálculo de totais da venda e controle de estoque.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_venda_item | bigint | NO | AUTO_INCREMENT | Chave primária única que identifica o item da venda |
| id_venda | bigint | NO | NULL | Identificador da venda à qual este item pertence |
| id_farmaco | bigint | YES | NULL | Identificador do fármaco/produto farmacêutico vendido |
| id_lote | bigint | YES | NULL | Identificador do lote específico do produto vendido |
| id_local_estoque | bigint | YES | NULL | Identificador do local de estoque de onde o produto foi retirado |
| descricao | varchar(255) | NO | NULL | Descrição textual do item vendido (nome do produto/serviço) |
| quantidade | int | NO | NULL | Quantidade de unidades do item vendido |
| valor_unitario | decimal(10,2) | NO | NULL | Valor unitário do item no momento da venda |
| desconto | decimal(10,2) | NO | '0.00' | Valor de desconto aplicado a este item específico |
| total_linha | decimal(10,2) | NO | '0.00' | Valor total da linha do item (quantidade * valor_unitario - desconto) |
| id_entidade | bigint unsigned | NO | NULL | Identificador da entidade SaaS à qual este item pertence |

## Chaves
- Primária: id_venda_item
- Únicas: Nenhuma
- Estrangeiras: fk_vi_farmaco (id_farmaco -> farmaco.id_farmaco), fk_vi_lote (id_lote -> farmaco_lote.id_lote), fk_vi_venda (id_venda -> venda.id_venda)

## Índices
- idx_vi_venda (id_venda)
- idx_vi_farmaco (id_farmaco, id_lote)
- fk_vi_lote (id_lote)

## Constraints
- fk_vi_farmaco: FOREIGN KEY (id_farmaco) REFERENCES farmaco (id_farmaco)
- fk_vi_lote: FOREIGN KEY (id_lote) REFERENCES farmaco_lote (id_lote)
- fk_vi_venda: FOREIGN KEY (id_venda) REFERENCES venda (id_venda)

## Relacionamentos e Cardinalidade
- N:1 com venda (muitos itens pertencem a uma venda)
- N:1 com farmaco (muitos itens podem referir-se a um fármaco)
- N:1 com farmaco_lote (muitos itens podem referir-se a um lote)
- N:1 com local_estoque (muitos itens podem ser retirados de um local de estoque)

## Dependências
- Depende de: venda, farmaco, farmaco_lote, local_estoque (implícito), saas_entidade
- Dependências reversas: Nenhuma tabela principal depende diretamente desta, mas afeta totais da venda

## Fluxo de utilização dentro do sistema
- Quando um item é adicionado ao carrinho/PDV, um registro é inserido aqui
- O sistema calcula automaticamente total_linha = (quantidade * valor_unitario) - desconto
- A atualização de estoque é acionada com base nos itens vendidos (id_farmaco, id_lote, id_local_estoque)
- Usado para emissão de cupom fiscal/nota e relatórios de vendas por produto
- Consultado para análise de giro de estoque e produtos mais vendidos

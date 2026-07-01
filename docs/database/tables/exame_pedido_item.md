# exame_pedido_item

Objetivo: Gestão de exames médicos, pedidos e laudos

Descrição: Itens individuais de um pedido de exame, contendo código de procedimento, nome do exame, material, valores de custo e venda.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id_item | bigint AUTO_INCREMENT | NO | — | Identificador do item |
| id_pedido | bigint | NO | — | Identificador do pedido |
| codigo_procedimento | varchar(20) DEFAULT | YES | NULL | Campo do registro |
| nome_exame | varchar(150) DEFAULT | YES | NULL | Campo do registro |
| material | varchar(50) DEFAULT | YES | NULL | Material necessário para o exame |
| valor_custo | decimal(10,2) | YES | '0.00' | Valor de custo do item |
| valor_venda | decimal(10,2) | YES | '0.00' | Valor de venda do item |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id_item
- Estrangeira (fk_item_pedido): coluna id_pedido -> tabela exame_pedido(id_pedido): Referencia a tabela exame_pedido (coluna id_pedido) para garantir integridade referencial

## Indices

- fk_item_pedido (id_pedido)

## Constraints

- FOREIGN KEY fk_item_pedido: id_pedido references exame_pedido(id_pedido)
- PRIMARY KEY (id_item)

## Relacionamentos e Cardinalidade

- exame_pedido_item (1) -> exame_pedido (1): campo id_pedido

## Dependencias

- Depende de:
  - exame_pedido
- Dependencias diretas: Nenhuma tabela listada depende diretamente desta tabela com base nas FKs encontradas.

## Fluxo de utilizacao dentro do sistema

- Tabela componente do módulo de atendimento e faturamento hospitalar.
- Utilizada para persistência e consulta de dados específicos do domínio.
- Associada a operações de cadastro, evolução e faturamento.
- Integrada com fluxos de auditoria e sincronização.

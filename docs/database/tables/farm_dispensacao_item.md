# farm_dispensacao_item

Objetivo: Controle de dispensação de medicamentos

Descrição: Itens individuais dispensados em uma dispensação, com vínculo a lote de estoque, quantidade e valores unitário.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id_item | bigint AUTO_INCREMENT | NO | — | Identificador do item |
| id_dispensacao | bigint | NO | — | Identificador da dispensação |
| id_produto | bigint | NO | — | Identificador do produto/medicamento |
| lote | bigint DEFAULT | YES | NULL | Identificador do lote de medicamento |
| quantidade | decimal(12,3) | NO | — | Quantidade numérica do item |
| valor_unitario | decimal(12,2) DEFAULT | YES | NULL | Valor unitário do item |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id_item
- Estrangeira (fk_disp_item_lote): coluna lote -> tabela estoque_lote(id_lote): Referencia a tabela estoque_lote (coluna id_lote) para garantir integridade referencial
- Estrangeira (fk_farm_disp_item_estoque_lote): coluna lote -> tabela estoque_lote(id_lote): Referencia a tabela estoque_lote (coluna id_lote) para garantir integridade referencial
- Estrangeira (fk_item_dispensacao): coluna id_dispensacao -> tabela farm_dispensacao(id_dispensacao): Referencia a tabela farm_dispensacao (coluna id_dispensacao) para garantir integridade referencial

## Indices

- fk_item_dispensacao (id_dispensacao)
- fk_farm_disp_item_estoque_lote (lote)

## Constraints

- FOREIGN KEY fk_disp_item_lote: lote references estoque_lote(id_lote)
- FOREIGN KEY fk_farm_disp_item_estoque_lote: lote references estoque_lote(id_lote)
- FOREIGN KEY fk_item_dispensacao: id_dispensacao references farm_dispensacao(id_dispensacao)
- PRIMARY KEY (id_item)

## Relacionamentos e Cardinalidade

- farm_dispensacao_item (1) -> estoque_lote (1): campo lote
- farm_dispensacao_item (1) -> estoque_lote (1): campo lote
- farm_dispensacao_item (1) -> farm_dispensacao (1): campo id_dispensacao

## Dependencias

- Depende de:
  - estoque_lote
  - estoque_lote
  - farm_dispensacao
- Dependencias diretas: Nenhuma tabela listada depende diretamente desta tabela com base nas FKs encontradas.

## Fluxo de utilizacao dentro do sistema

- Tabela componente do módulo de atendimento e faturamento hospitalar.
- Utilizada para persistência e consulta de dados específicos do domínio.
- Associada a operações de cadastro, evolução e faturamento.
- Integrada com fluxos de auditoria e sincronização.

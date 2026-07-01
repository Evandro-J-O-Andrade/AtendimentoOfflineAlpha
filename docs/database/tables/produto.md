# produto

Objetivo: Manter o cadastro de produtos utilizados no sistema de saúde, incluindo medicamentos, insumos e materiais com diferentes características.

Descrição: Tabela mestre de produtos que suporta medicamentos, insumos e materiais utilizados na instituição, com controle de características como necessidade de lote, validade, serial, e exigência de prescrição.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_produto | bigint | NOT NULL | - | Chave primária da tabela, identificador único do produto |
| tipo_produto | varchar(40) | NOT NULL | - | Tipo do produto (ex: MEDICAMENTO, MATERIAL, INSUMO, etc.) |
| categoria | varchar(120) | YES | NULL | Categoria do produto para classificação |
| subcategoria | varchar(120) | YES | NULL | Subcategoria do produto para classificação mais detalhada |
| nome | varchar(255) | NOT NULL | - | Nome do produto |
| descricao_tecnica | text | YES | NULL | Descrição técnica detalhada do produto |
| unidade_medida | varchar(20) | YES | NULL | Unidade de medida do produto (ex: UNID, ML, MG, etc.) |
| controla_lote | tinyint | - | '0' | Flag indicando se o produto requer controle de lote (1) ou não (0) |
| controla_validade | tinyint | - | '0' | Flag indicando se o produto requer controle de validade (1) ou não (0) |
| controla_serial | tinyint | - | '0' | Flag indicando se o produto requer controle de número de série (1) ou não (0) |
| exige_prescricao | tinyint | - | '0' | Flag indicando se o produto exige prescrição médica (1) ou não (0) |
| codigo_barras | varchar(100) | YES | NULL | Código de barras do produto para identificação rápida |
| codigo_interno | varchar(100) | YES | NULL | Código interno de identificação do produto na instituição |
| codigo_sigtap | varchar(50) | YES | NULL | Código do procedimento no SIGTAP para produtos relacionados a procedimentos |
| codigo_gpat | varchar(50) | YES | NULL | Código GPAT para produtos do SUS |
| ativo | tinyint | - | '1' | Flag indicando se o produto está ativo no cadastro |
| criado_em | datetime | - | CURRENT_TIMESTAMP | Data e hora de cadastro do produto |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde o produto é utilizado |

## Chaves
- Primária: id_produto
- Únicas: -
- Estrangeiras: -

## Índices
- PRIMARY KEY (id_produto)

## Constraints
- -

## Relacionamentos e Cardinalidade
- 1:N com tabelas que referenciem produtos (ex: estoque, prescrições, pedidos)

## Dependências
- Tabelas que dependem desta: -
| Esta tabela depende de: -

## Fluxo de utilização dentro do sistema
- Cadastrado como produto disponível na instituição
- Controla características específicas para gestão de estoque
- Medicamentos exigem prescrição e controle rigoroso
- Códigos externos permitem integração com sistemas de faturamento
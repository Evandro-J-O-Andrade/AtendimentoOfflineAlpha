# almoxarifado_central

Objetivo: Controlar o estoque central de produtos/medicamentos, registrando lote, validade, quantidade atual e quantidade mínima de estoque.

Descrição: Esta tabela gerencia o almoxarifado central do sistema, permitindo o controle de entrada de produtos/medicamentos com informações de lote, validade e quantidades para gestão de estoque e alertas de reposição.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do registro de produto no almoxarifado |
| id_produto | int | NOT NULL | - | Identificador do produto/medicamento no almoxarifado |
| lote | varchar(50) | YES | NULL | Número do lote do produto para controle de qualidade e validade |
| validade | date | YES | NULL | Data de validade do lote para controle de vencimento |
| quantidade_atual | int | NOT NULL | - | Quantidade atual disponível em estoque do produto |
| quantidade_minima | int | YES | '100' | Quantidade mínima de estoque para disparo de alertas de reposição |
| nfe_chave_acesso | varchar(44) | YES | NULL | Chave de acesso da Nota Fiscal Eletrônica para rastreio de entrada |
| id_unidade | bigint unsigned | YES | NULL | Identificador da unidade que adicionou o produto ao almoxarifado |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o registro pertence |

## Chaves
- Primária: id
- Únicas: Nenhuma
- Estrangeiras: Nenhuma

## Índices
- idx_validade (KEY) - Índice para busca por data de validade, útil para identificar lotes próximos ao vencimento

## Constraints
- Nenhuma

## Relacionamentos e Cardinalidade
- Esta tabela não possui relacionamentos com outras tabelas via foreign key

## Dependências
- Tabelas que dependem desta: Nenhuma (não há FK apontando para almoxarifado_central)
- Tabelas das quais esta depende: Nenhuma

## Fluxo de utilização dentro do sistema
- Registro de entrada de produtos/medicamentos no almoxarifado central
- Controle de quantidade atual para gestão de estoque
- Monitoramento de validade via índice idx_validade para alertas de vencimento
- Controle de quantidade mínima para gatilho de reposição
- Rastreio da Nota Fiscal Eletrônica via chave de acesso
- Vinculação opcional à unidade que adicionou o produto
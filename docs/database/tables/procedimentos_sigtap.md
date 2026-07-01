# procedimentos_sigtap

Objetivo: Armazenar o cadastro de procedimentos do SIGTAP (Sistema de Gerenciamento da Tabela de Procedimentos) do SUS, com códigos e valores.

Descrição: Tabela que mantém o catálogo de procedimentos médicos padronizados pelo SIGTAP, permitindo integração com o sistema de saúde pública e informações sobre valores de procedimentos.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| codigo_procedimento | varchar(10) | NOT NULL | - | Chave primária da tabela, código identificador do procedimento no SIGTAP |
| nome_procedimento | varchar(255) | YES | NULL | Nome descritivo do procedimento |
| valor_sus | decimal(10,2) | YES | NULL | Valor do procedimento segundo a tabela SUS |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde o procedimento é utilizado |

## Chaves
- Primária: codigo_procedimento
- Únicas: -
- Estrangeiras: -

## Índices
- PRIMARY KEY (codigo_procedimento)

## Constraints
- -

## Relacionamentos e Cardinalidade
- 1:N com tabelas que referenciem procedimentos SIGTAP (ex: faturamento, realização de procedimentos)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: -

## Fluxo de utilização dentro do sistema
- Usada como referência para procedimentos médicos padronizados
- Integrada ao faturamento e controle de custos
- Permite validação de códigos de procedimentos no sistema
- Utilizada em relatórios e exportações ao SUS
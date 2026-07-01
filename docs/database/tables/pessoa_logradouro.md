# pessoa_logradouro

Objetivo: Associar pessoas a logradouros com histórico temporal.
Descrição: Tabela que mantém o histórico de associação entre pessoas e logradouros, permitindo armazenar múltiplas associações com datas de início e fim.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_pessoa | bigint | NOT NULL | - | ID da pessoa (parte da chave primária) |
| id_logradouro | bigint | NOT NULL | - | ID do logradouro (parte da chave primária) |
| principal | tinyint(1) | YES | '1' | Flag indicando se este é o logradouro principal da pessoa |
| data_inicio | date | NOT NULL | - | Data de início da associação pessoa-logradouro |
| data_fim | date | YES | NULL | Data de fim da associação (preenchida quando não mais válida) |
| ativo | tinyint(1) | YES | '1' | Flag indicando se a associação está ativa |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual a associação pertence |

## Chaves
- Primária: (id_pessoa, id_logradouro, data_inicio)
- Únicas: (nenhuma)
- Estrangeiras: 
  - pessoa_logradouro_ibfk_1: id_pessoa → pessoa (id_pessoa)
  - pessoa_logradouro_ibfk_2: id_logradouro → logradouro (id_logradouro)

## Índices
- PRIMARY KEY (id_pessoa, id_logradouro, data_inicio)
- KEY id_logradouro (id_logradouro)
- KEY idx_pessoa_logradouro_ativo (id_pessoa, ativo)
- KEY idx_pessoa_logradouro_principal (id_pessoa, principal)

## Constraints
- PRIMARY KEY: (id_pessoa, id_logradouro, data_inicio)
- FOREIGN KEY: pessoa_logradouro_ibfk_1
- FOREIGN KEY: pessoa_logradouro_ibfk_2

## Relacionamentos e Cardinalidade
- N:1 com pessoa: Muitas associações de logradouro pertencem a uma pessoa
- N:1 com logradouro: Muitas associações podem referenciar um logradouro

## Dependências
- Esta tabela depende de: pessoa, logradouro, saas_entidade
- Não há tabelas que dependem desta tabela

## Fluxo de utilização dentro do sistema
Utilizada para associar pessoas a logradouros de forma temporal. A data_inicio e data_fim permitem manter histórico. Quando uma pessoa muda de endereço, o registro antigo fica com data_fim preenchida e um novo registro é criado. Permite consultar o histórico de endereços de uma pessoa de forma eficiente.
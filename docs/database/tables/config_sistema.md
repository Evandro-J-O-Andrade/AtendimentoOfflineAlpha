# config_sistema

Objetivo: Armazenar configurações específicas de cada unidade no sistema.
Descrição: Tabela chave-valor que mantém parâmetros de configuração por unidade, permitindo personalização da operação sem alterações no código.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id | int | NOT NULL | - | Identificador único do parâmetro, chave primária auto incrementada. |
| id_unidade | bigint unsigned | NOT NULL | - | Referência à unidade à qual a configuração aplica. |
| parametro | varchar(100) | NOT NULL | - | Nome do parâmetro de configuração. |
| valor | varchar(255) | Nullable | - | Valor do parâmetro armazenado. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização). |

## Índices
- PRIMARY KEY (id)
- KEY idx_config_unid (id_unidade)

## Constraints
- PRIMARY KEY: id
- FOREIGN KEY: fk_config_sistema_unidade (id_unidade) REFERENCES unidade (id_unidade)

## Relacionamentos e Cardinalidade
- N:1 com unidade (id_unidade) - muitas configurações podem existir por unidade
- N:1 com saas_entidade (id_entidade)

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: unidade, saas_entidade

## Fluxo de utilização dentro do sistema
- Lida durante inicialização de processos para obter valores configuráveis
- Permite personalização por unidade sem alterações no código
- Parâmetros controlam funcionalidades específicas da unidade
- Usada para configuração de integrações e regras de negócio
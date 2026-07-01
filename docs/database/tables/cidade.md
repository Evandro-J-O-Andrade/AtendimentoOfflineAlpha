# cidade

Objetivo: Armazenar informações de cidades para referência geográfica e endereços.
Descrição: Tabela referencial que mantém dados de cidades incluindo nome, estado, código IBGE e vínculo com entidade.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_cidade | bigint | NOT NULL | - | Identificador único da cidade, chave primária auto incrementada. |
| nome | varchar(150) | NOT NULL | - | Nome da cidade. |
| estado | varchar(10) | NOT NULL | - | Sigla do estado (ex: SP, RJ, MG). |
| codigo_ibge | varchar(10) | Nullable | NULL | Código IBGE da cidade para integração governamental. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) à qual a cidade pertence. |
| ativo | tinyint | Nullable | '1' | Indicador se a cidade está ativa no sistema. |
| criado_em | datetime(6) | Nullable | CURRENT_TIMESTAMP(6) | Timestamp de criação do registro. |
| atualizado_em | datetime(6) | Nullable | NULL | Timestamp da última atualização. |

## Chaves
- Primária: id_cidade
- Únicas: nenhuma
- Estrangeiras:
  - fk_cidade_entidade: id_entidade → saas_entidade (id_entidade)

## Índices
- PRIMARY KEY (id_cidade)
- KEY idx_cidade_entidade (id_entidade)
- KEY idx_cidade_ibge (codigo_ibge)

## Constraints
- PRIMARY KEY: id_cidade
- FOREIGN KEY: fk_cidade_entidade (id_entidade) REFERENCES saas_entidade (id_entidade)

## Relacionamentos e Cardinalidade
- 1:N com saas_entidade (id_entidade) - muitas cidades podem pertencer a uma entidade
- 1:N com pessoa_endereco (id_cidade) - inferido
- 1:N com logradouro (id_cidade) - inferido

## Dependências
- Tabelas que dependem desta: pessoa_endereco, logradouro, pessoa_logradouro (inferido)
- Dependência desta tabela: saas_entidade

## Fluxo de utilização dentro do sistema
- Usada como referencial para endereços de pessoas e unidades
- Código IBGE integrado para relatórios e integrações governamentais
- Apenas cidades ativas são exibidas em buscas e seleções
- Mantém histórico de cidades cadastradas no sistema
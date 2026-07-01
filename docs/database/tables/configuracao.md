# configuracao

Objetivo: Armazenar parâmetros de configuração globais do sistema.
Descrição: Tabela chave-valor simples que mantém configurações gerais do sistema por entidade.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| chave | varchar(100) | NOT NULL | - | Chave única de configuração. |
| valor | text | Nullable | - | Valor da configuração. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização). |

## Chaves
- Primária: chave
- Únicas: nenhuma
- Estrangeiras: nenhuma

## Índices
- PRIMARY KEY (chave)

## Constraints
- PRIMARY KEY: chave

## Relacionamentos e Cardinalidade
- Própria chave é única por entidade (armazenada como PK)
- N:1 com saas_entidade (id_entidade) - inferido

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: saas_entidade (inferido)

## Fluxo de utilização dentro do sistema
- Usada como armazenamento de configurações chave-valor
- Permite ajuste de funcionalidades sem alteração no código
- Chaves são únicas para evitar sobreposição
- Lida pelo sistema em tempo de execução para obter valores
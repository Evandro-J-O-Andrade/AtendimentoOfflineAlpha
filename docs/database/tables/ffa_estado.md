# ffa_estado

Objetivo: Fluxo de Atendimento Ambulatorial (FFA)

Descrição: Catálogo de estados possíveis para o fluxo de atendimento ambulatorial (FFA), com nome e descrição do estado.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id_estado | bigint unsigned AUTO_INCREMENT | NO | — | Identificador do estado |
| nome | varchar(100) | NO | — | Campo do registro |
| descricao | varchar(255) DEFAULT | YES | NULL | Descrição textual do registro |
| ativo | tinyint(1) | NO | '1' | Flag indicando se o registro está ativo |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id_estado
- Unica (uk_ffa_estado_nome): nome

## Indices

Nenhum indice secundario adicional alem das chaves primaria, unicas e estrangeiras.

## Constraints

- UNIQUE KEY uk_ffa_estado_nome (nome)
- PRIMARY KEY (id_estado)

## Relacionamentos e Cardinalidade


## Dependencias

- Dependencias diretas: Nenhuma tabela listada depende diretamente desta tabela com base nas FKs encontradas.

## Fluxo de utilizacao dentro do sistema

- Tabela componente do módulo de atendimento e faturamento hospitalar.
- Utilizada para persistência e consulta de dados específicos do domínio.
- Associada a operações de cadastro, evolução e faturamento.
- Integrada com fluxos de auditoria e sincronização.

# faturamento_sus_config

Objetivo: Gestão de contas, itens e regras de faturamento

Descrição: Configuração de unidades para faturamento SUS, com CNES da unidade e tipo de gestão (municipal ou estadual).

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id | int AUTO_INCREMENT | NO | — | Campo do registro |
| id_unidade | bigint unsigned DEFAULT | YES | NULL | Identificador da unidade de saúde |
| cnes_unidade | varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT | YES | NULL | Código CNES da unidade |
| gestao_municipal_estadual | enum('M','E') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT | YES | NULL | Endereço IP de origem da requisição |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id

## Indices

Nenhum indice secundario adicional alem das chaves primaria, unicas e estrangeiras.

## Constraints

- PRIMARY KEY (id)

## Relacionamentos e Cardinalidade


## Dependencias

- Dependencias diretas: Nenhuma tabela listada depende diretamente desta tabela com base nas FKs encontradas.

## Fluxo de utilizacao dentro do sistema

- Tabela componente do módulo de atendimento e faturamento hospitalar.
- Utilizada para persistência e consulta de dados específicos do domínio.
- Associada a operações de cadastro, evolução e faturamento.
- Integrada com fluxos de auditoria e sincronização.

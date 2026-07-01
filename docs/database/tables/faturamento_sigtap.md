# faturamento_sigtap

Objetivo: Gestão de contas, itens e regras de faturamento

Descrição: Catálogo de procedimentos do sistema SIGTAP com valores de serviço hospitalar (SH), serviço ambulatorial (SA) e complexidade.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id | int AUTO_INCREMENT | NO | — | Campo do registro |
| codigo_procedimento | varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | NO | — | Campo do registro |
| nome_procedimento | varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT | YES | NULL | Campo do registro |
| valor_sh | decimal(10,2) DEFAULT | YES | NULL | Valor do serviço hospitalar |
| valor_sa | decimal(10,2) DEFAULT | YES | NULL | Valor do serviço ambulatorial |
| complexidade | enum('BASICA','MEDIA','ALTA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT | YES | NULL | Nível de complexidade do procedimento |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id
- Unica (uk_sigtap_cod): codigo_procedimento

## Indices

Nenhum indice secundario adicional alem das chaves primaria, unicas e estrangeiras.

## Constraints

- UNIQUE KEY uk_sigtap_cod (codigo_procedimento)
- PRIMARY KEY (id)

## Relacionamentos e Cardinalidade


## Dependencias

- Dependencias diretas: Nenhuma tabela listada depende diretamente desta tabela com base nas FKs encontradas.

## Fluxo de utilizacao dentro do sistema

- Tabela componente do módulo de atendimento e faturamento hospitalar.
- Utilizada para persistência e consulta de dados específicos do domínio.
- Associada a operações de cadastro, evolução e faturamento.
- Integrada com fluxos de auditoria e sincronização.

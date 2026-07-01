# faturamento_codigo

Objetivo: Gestão de contas, itens e regras de faturamento

Descrição: Catálogo de códigos de faturamento (SIGTAP, TUSS, CBHPM, INTERNO) com tipo de item, unidade de medida e status ativo.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id_codigo | bigint AUTO_INCREMENT | NO | — | Identificador do código de faturamento |
| sistema | enum('SIGTAP','TUSS','CBHPM','INTERNO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | NO | 'INTERNO' | Campo do registro |
| codigo | varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | NO | — | Código de identificação do registro |
| tipo | enum('PROCEDIMENTO','MATERIAL','MEDICAMENTO','TAXA','DIARIA','OUTRO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | NO | 'OUTRO' | Endereço IP de origem da requisição |
| descricao | varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT | YES | NULL | Descrição textual do registro |
| unidade_medida | varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT | YES | NULL | Unidade de medida do item |
| ativo | tinyint | NO | '1' | Flag indicando se o registro está ativo |
| criado_em | datetime | NO | CURRENT_TIMESTAMP | Data e hora do registro |
| atualizado_em | datetime | YES | CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP | Data e hora do registro |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id_codigo
- Unica (uq_faturamento_codigo): sistema, codigo

## Indices

Nenhum indice secundario adicional alem das chaves primaria, unicas e estrangeiras.

## Constraints

- UNIQUE KEY uq_faturamento_codigo (sistema, codigo)
- PRIMARY KEY (id_codigo)

## Relacionamentos e Cardinalidade


## Dependencias

- Dependencias diretas: Nenhuma tabela listada depende diretamente desta tabela com base nas FKs encontradas.

## Fluxo de utilizacao dentro do sistema

- Tabela componente do módulo de atendimento e faturamento hospitalar.
- Utilizada para persistência e consulta de dados específicos do domínio.
- Associada a operações de cadastro, evolução e faturamento.
- Integrada com fluxos de auditoria e sincronização.

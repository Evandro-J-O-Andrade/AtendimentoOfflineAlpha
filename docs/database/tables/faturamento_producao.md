# faturamento_producao

Objetivo: Gestão de contas, itens e regras de faturamento

Descrição: Registro de produção assistencial para faturamento, com código de procedimento, CBO do profissional e status de processamento.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id | bigint AUTO_INCREMENT | NO | — | Campo do registro |
| id_atendimento | bigint | NO | — | Identificador do atendimento |
| codigo_procedimento | varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT | YES | NULL | Campo do registro |
| cbo_profissional | varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT | YES | NULL | CBO do profissional responsável pela produção |
| status_faturamento | enum('PENDENTE','PROCESSADO','GLOSADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | YES | 'PENDENTE' | Status atual conforme enumeração definida |
| criado_em | datetime | YES | CURRENT_TIMESTAMP | Data e hora do registro |
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

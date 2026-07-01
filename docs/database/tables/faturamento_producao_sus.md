# faturamento_producao_sus

Objetivo: Gestão de contas, itens e regras de faturamento

Descrição: Produção SUS para faturamento, vinculada a atendimento e SIGTAP, com CNS do paciente, data de produção e status de remessa.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id | bigint AUTO_INCREMENT | NO | — | Campo do registro |
| id_atendimento | bigint unsigned | NO | — | Identificador do atendimento |
| id_sigtap | int | NO | — | Identificador único de sigtap |
| cbo_profissional | varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT | YES | NULL | CBO do profissional responsável pela produção |
| cns_paciente | varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT | YES | NULL | Cartão Nacional de Saúde do paciente |
| data_producao | date DEFAULT | YES | NULL | Data de produção do serviço |
| status_remessa | enum('PENDENTE','ENVIADO','REJEITADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | YES | 'PENDENTE' | Status atual conforme enumeração definida |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id

## Indices

- fk_sus_atend (id_atendimento)

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

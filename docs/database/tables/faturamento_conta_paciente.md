# faturamento_conta_paciente

Objetivo: Gestão de contas, itens e regras de faturamento

Descrição: Conta de faturamento do paciente vinculada a atendimento e convênio, com status de conta, valor total, guia principal e data de fechamento.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id | bigint AUTO_INCREMENT | NO | — | Campo do registro |
| id_atendimento | bigint unsigned | NO | — | Identificador do atendimento |
| id_convenio | int | NO | — | Identificador único de convenio |
| status_conta | enum('ABERTA','FECHADA','FATURADA','PAGA','GLOSADA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | YES | 'ABERTA' | Status atual conforme enumeração definida |
| valor_total | decimal(12,2) | YES | '0.00' | Valor total calculado |
| numero_guia_principal | varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT | YES | NULL | Número sequencial do documento |
| data_fechamento | datetime DEFAULT | YES | NULL | Data de fechamento da conta |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id

## Indices

- fk_conta_atend (id_atendimento)

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

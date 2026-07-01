# ffa_demandas_externas

Objetivo: Fluxo de Atendimento Ambulatorial (FFA)

Descrição: Demandas externas associadas a atendimentos (RX externo, medicação externa, exame externo), com status e profissional externo responsável.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id | bigint AUTO_INCREMENT | NO | — | Campo do registro |
| id_atendimento | bigint unsigned | NO | — | Identificador do atendimento |
| tipo_demanda | enum('RX_EXTERNO','MEDICACAO_EXTERNA','EXAME_EXTERNO','OUTROS') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT | YES | NULL | Endereço IP de origem da requisição |
| descricao | text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | YES | — | Descrição textual do registro |
| profissional_externo | varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT | YES | NULL | Campo do registro |
| status | enum('PENDENTE','REALIZADO','CANCELADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | YES | 'PENDENTE' | Status atual conforme enumeração definida |
| criado_em | datetime | YES | CURRENT_TIMESTAMP | Data e hora do registro |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id

## Indices

- fk_demanda_atendimento (id_atendimento)

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

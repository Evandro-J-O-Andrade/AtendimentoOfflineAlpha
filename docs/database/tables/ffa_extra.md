# ffa_extra

Objetivo: Fluxo de Atendimento Ambulatorial (FFA)

Descrição: Registros extras complementares ao atendimento (medicação externa, RX externo, exame externo, procedimento avulso).

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id | bigint AUTO_INCREMENT | NO | — | Campo do registro |
| id_atendimento | bigint DEFAULT | YES | NULL | Identificador do atendimento |
| tipo_extra | enum('MEDICACAO_EXTERNA','RX_EXTERNO','EXAME_EXTERNO','PROCEDIMENTO_AVULSO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT | YES | NULL | Endereço IP de origem da requisição |
| descricao | text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | YES | — | Descrição textual do registro |
| status | varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | YES | 'PENDENTE' | Status atual conforme enumeração definida |
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

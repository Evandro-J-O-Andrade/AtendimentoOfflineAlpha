# farmaco_auditoria_bloqueio

Objetivo: Gestão de medicamentos, movimentações e auditoria

Descrição: Registra bloqueios de medicamentos por lote e cidade, com motivo, responsável e vínculo a FFA quando aplicável.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id | bigint AUTO_INCREMENT | NO | — | Campo do registro |
| id_farmaco | bigint | NO | — | Identificador do medicamento |
| id_lote | bigint | NO | — | Identificador do lote de medicamento |
| id_cidade | bigint | NO | — | Identificador da cidade/localidade |
| quantidade | int | NO | — | Quantidade numérica do item |
| id_ffa | bigint DEFAULT | YES | NULL | Identificador do fluxo de atendimento ambulatorial |
| usuario | bigint | NO | — | Usuário responsável pela ação |
| motivo | varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | NO | — | Motivo do bloqueio ou ação |
| criado_em | datetime | NO | CURRENT_TIMESTAMP | Data e hora do registro |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id

## Indices

- idx_bloq_farmaco (id_farmaco)
- idx_bloq_lote (id_lote)
- idx_bloq_cidade (id_cidade)
- idx_bloq_usuario (usuario)

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

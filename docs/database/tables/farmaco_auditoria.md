# farmaco_auditoria

Objetivo: Gestão de medicamentos, movimentações e auditoria

Descrição: Auditoria geral de tabelas de farmácia, registrando inserts, updates e deletes com dados antes e depois da alteração.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id_auditoria | bigint AUTO_INCREMENT | NO | — | Identificador único de auditoria |
| tabela | varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT | YES | NULL | Campo do registro |
| id_registro | bigint DEFAULT | YES | NULL | Identificador único de registro |
| acao | enum('INSERT','UPDATE','DELETE') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT | YES | NULL | Campo do registro |
| dados_antes | json DEFAULT | YES | NULL | Snapshot dos dados antes da alteração em formato JSON |
| dados_depois | json DEFAULT | YES | NULL | Snapshot dos dados após a alteração em formato JSON |
| id_usuario | bigint DEFAULT | YES | NULL | Identificador único de usuario |
| data_evento | datetime | YES | CURRENT_TIMESTAMP | Campo do registro |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id_auditoria

## Indices

Nenhum indice secundario adicional alem das chaves primaria, unicas e estrangeiras.

## Constraints

- PRIMARY KEY (id_auditoria)

## Relacionamentos e Cardinalidade


## Dependencias

- Dependencias diretas: Nenhuma tabela listada depende diretamente desta tabela com base nas FKs encontradas.

## Fluxo de utilizacao dentro do sistema

- Tabela componente do módulo de atendimento e faturamento hospitalar.
- Utilizada para persistência e consulta de dados específicos do domínio.
- Associada a operações de cadastro, evolução e faturamento.
- Integrada com fluxos de auditoria e sincronização.

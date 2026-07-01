# eventos_fluxo

Objetivo: Registro de eventos e fluxos do sistema

Descrição: Registra eventos genéricos de fluxo de atendimento, associados a entidades e usuários, permitindo rastreamento de ações no sistema.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id | bigint AUTO_INCREMENT | NO | — | Campo do registro |
| entidade | varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT | YES | NULL | Campo do registro |
| entidade_id | bigint DEFAULT | YES | NULL | Campo do registro |
| tipo_evento | varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT | YES | NULL | Endereço IP de origem da requisição |
| descricao | text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | YES | — | Descrição textual do registro |
| id_usuario | bigint DEFAULT | YES | NULL | Identificador único de usuario |
| perfil_usuario | varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT | YES | NULL | Perfil do usuário que executou o evento |
| local | varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT | YES | NULL | Local físico onde o evento ocorreu |
| data_hora | datetime | YES | CURRENT_TIMESTAMP | Data e hora do evento |
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

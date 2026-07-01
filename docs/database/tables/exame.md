# exame

Objetivo: Gestão de exames médicos, pedidos e laudos

Descrição: Catálogo mestra de exames com código, descrição e tipo (LAB, RX, OUTROS), servindo como referência para pedidos de exame.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id_exame | int AUTO_INCREMENT | NO | — | Identificador do exame |
| codigo | varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT | YES | NULL | Código de identificação do registro |
| descricao | varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT | YES | NULL | Descrição textual do registro |
| tipo | enum('LAB','RX','OUTROS') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT | YES | NULL | Endereço IP de origem da requisição |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id_exame
- Unica (codigo): codigo

## Indices

Nenhum indice secundario adicional alem das chaves primaria, unicas e estrangeiras.

## Constraints

- UNIQUE KEY codigo (codigo)
- PRIMARY KEY (id_exame)

## Relacionamentos e Cardinalidade


## Dependencias

- Dependencias diretas: Nenhuma tabela listada depende diretamente desta tabela com base nas FKs encontradas.

## Fluxo de utilizacao dentro do sistema

- Tabela componente do módulo de atendimento e faturamento hospitalar.
- Utilizada para persistência e consulta de dados específicos do domínio.
- Associada a operações de cadastro, evolução e faturamento.
- Integrada com fluxos de auditoria e sincronização.

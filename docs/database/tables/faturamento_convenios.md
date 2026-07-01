# faturamento_convenios

Objetivo: Gestão de contas, itens e regras de faturamento

Descrição: Cadastro de convênios credenciados com nome fantasia, registro ANS e tabela de preços associada.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id | int AUTO_INCREMENT | NO | — | Campo do registro |
| nome_fantasia | varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | NO | — | Nome fantasia do convênio |
| registro_ans | varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT | YES | NULL | Registro ANS do convênio |
| id_tabela_precos | int DEFAULT | YES | NULL | Identificador único de tabela precos |
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

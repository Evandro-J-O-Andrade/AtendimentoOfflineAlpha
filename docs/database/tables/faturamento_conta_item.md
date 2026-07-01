# faturamento_conta_item

Objetivo: Gestão de contas, itens e regras de faturamento

Descrição: Tabela de relacionamento entre itens faturáveis (procedimentos, exames, medicamentos, materiais, taxas) e contas de faturamento.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id | bigint AUTO_INCREMENT | NO | — | Campo do registro |
| id_conta | bigint | NO | — | Identificador único de conta |
| id_item | bigint | NO | — | Identificador do item |
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

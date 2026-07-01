# ffa_estoque_conciliacao

Objetivo: Gerenciamento de saldo e quantidades de estoque

Descrição: Conciliação entre itens de estoque e movimentos de faturamento, comparando valores faturados versus custos para reconciliação contábil.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id_conciliacao | bigint AUTO_INCREMENT | NO | — | Identificador da conciliação |
| id_ffa_item | bigint | NO | — | Identificador do fluxo de atendimento ambulatorial |
| id_movimento_item | bigint | NO | — | Identificador do movimento de item |
| valor_faturado | decimal(15,6) DEFAULT | YES | NULL | Campo do registro |
| valor_custo | decimal(15,6) DEFAULT | YES | NULL | Valor de custo do item |
| criado_em | datetime | YES | CURRENT_TIMESTAMP | Data e hora do registro |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id_conciliacao

## Indices

Nenhum indice secundario adicional alem das chaves primaria, unicas e estrangeiras.

## Constraints

- PRIMARY KEY (id_conciliacao)

## Relacionamentos e Cardinalidade


## Dependencias

- Dependencias diretas: Nenhuma tabela listada depende diretamente desta tabela com base nas FKs encontradas.

## Fluxo de utilizacao dentro do sistema

- Tabela componente do módulo de atendimento e faturamento hospitalar.
- Utilizada para persistência e consulta de dados específicos do domínio.
- Associada a operações de cadastro, evolução e faturamento.
- Integrada com fluxos de auditoria e sincronização.

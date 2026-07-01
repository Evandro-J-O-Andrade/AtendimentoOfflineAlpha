# farmaco_unidade

Objetivo: Gestão de medicamentos, movimentações e auditoria

Descrição: Define cotas mínimas e máximas de medicamentos por cidade/localidade, permitindo controle de estoque por unidade geográfica.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id_farmaco | bigint | NO | — | Identificador do medicamento |
| id_cidade | bigint | NO | — | Identificador da cidade/localidade |
| cota_minima | int | NO | '0' | Campo do registro |
| cota_maxima | int DEFAULT | YES | NULL | Campo do registro |
| atualizado_por | bigint | NO | — | Usuário responsável pela última atualização |
| atualizado_em | datetime | NO | CURRENT_TIMESTAMP | Data e hora do registro |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id_farmaco, id_cidade
- Estrangeira (fk_fu_farmaco): coluna id_farmaco -> tabela farmaco(id_farmaco): Referencia a tabela farmaco (coluna id_farmaco) para garantir integridade referencial

## Indices

Nenhum indice secundario adicional alem das chaves primaria, unicas e estrangeiras.

## Constraints

- FOREIGN KEY fk_fu_farmaco: id_farmaco references farmaco(id_farmaco)
- PRIMARY KEY (id_farmaco, id_cidade)

## Relacionamentos e Cardinalidade

- farmaco_unidade (1) -> farmaco (1): campo id_farmaco

## Dependencias

- Depende de:
  - farmaco
- Dependencias diretas: Nenhuma tabela listada depende diretamente desta tabela com base nas FKs encontradas.

## Fluxo de utilizacao dentro do sistema

- Tabela componente do módulo de atendimento e faturamento hospitalar.
- Utilizada para persistência e consulta de dados específicos do domínio.
- Associada a operações de cadastro, evolução e faturamento.
- Integrada com fluxos de auditoria e sincronização.

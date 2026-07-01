# farmaco_movimentacao

Objetivo: Gestão de medicamentos, movimentações e auditoria

Descrição: Registra movimentações de entrada e saída de medicamentos (compras, transferências, atendimento a paciente, ajustes, PDV).

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id_movimentacao | bigint AUTO_INCREMENT | NO | — | Identificador da movimentação |
| id_farmaco | bigint | NO | — | Identificador do medicamento |
| id_lote | bigint | NO | — | Identificador do lote de medicamento |
| id_cidade | bigint | NO | — | Identificador da cidade/localidade |
| tipo | enum('ENTRADA','SAIDA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | NO | — | Endereço IP de origem da requisição |
| quantidade | int | NO | — | Quantidade numérica do item |
| origem | enum('COMPRA','TRANSFERENCIA','PACIENTE','AJUSTE','PDV') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | NO | — | Origem do registro (sistema ou operação que gerou o evento) |
| id_ffa | bigint DEFAULT | YES | NULL | Identificador do fluxo de atendimento ambulatorial |
| observacao | varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT | YES | NULL | Observação ou detalhe textual |
| realizado_por | bigint | NO | — | Campo do registro |
| data_mov | datetime | NO | CURRENT_TIMESTAMP | Data da movimentação |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id_movimentacao
- Estrangeira (fk_mov_farmaco): coluna id_farmaco -> tabela farmaco(id_farmaco): Referencia a tabela farmaco (coluna id_farmaco) para garantir integridade referencial
- Estrangeira (fk_mov_lote): coluna id_lote -> tabela farmaco_lote(id_lote): Referencia a tabela farmaco_lote (coluna id_lote) para garantir integridade referencial

## Indices

- fk_mov_farmaco (id_farmaco)
- fk_mov_lote (id_lote)

## Constraints

- FOREIGN KEY fk_mov_farmaco: id_farmaco references farmaco(id_farmaco)
- FOREIGN KEY fk_mov_lote: id_lote references farmaco_lote(id_lote)
- PRIMARY KEY (id_movimentacao)

## Relacionamentos e Cardinalidade

- farmaco_movimentacao (1) -> farmaco (1): campo id_farmaco
- farmaco_movimentacao (1) -> farmaco_lote (1): campo id_lote

## Dependencias

- Depende de:
  - farmaco
  - farmaco_lote
- Dependencias diretas: Nenhuma tabela listada depende diretamente desta tabela com base nas FKs encontradas.

## Fluxo de utilizacao dentro do sistema

- Registra todas as entradas e saídas de estoque de medicamentos.
- Origem: compras, transferências entre unidades, atendimento a pacientes, ajustes e PDV.
- Alimenta os saldos centrais e master de estoque.
- Consumida por relatórios de movimentação e conciliação contábil.

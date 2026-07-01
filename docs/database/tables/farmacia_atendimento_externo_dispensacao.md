# farmacia_atendimento_externo_dispensacao

Objetivo: Controle de dispensação de medicamentos

Descrição: Dispensação efetiva de medicamentos para atendimento externo, ligando itens de farmácia a atendimentos, com confirmação de entrega e cancelamento.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id_dispensacao | bigint AUTO_INCREMENT | NO | — | Identificador da dispensação |
| id_item | bigint | NO | — | Identificador do item |
| id_lote | bigint | NO | — | Identificador do lote de medicamento |
| id_local_estoque | bigint | NO | — | Identificador do local de estoque |
| quantidade | decimal(10,2) | NO | — | Quantidade numérica do item |
| status | enum('ENTREGUE','CANCELADA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | NO | 'ENTREGUE' | Status atual conforme enumeração definida |
| dispensado_em | datetime | NO | CURRENT_TIMESTAMP | Data e hora do registro |
| dispensado_por | bigint | NO | — | Campo do registro |
| observacao | text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | YES | — | Observação ou detalhe textual |
| id_atendimento | bigint unsigned | NO | — | Identificador do atendimento |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id_dispensacao
- Estrangeira (fk_faed_item): coluna id_item -> tabela farmacia_atendimento_externo_item(id_item): Referencia a tabela farmacia_atendimento_externo_item (coluna id_item) para garantir integridade referencial
- Estrangeira (fk_faed_local): coluna id_local_estoque -> tabela local_atendimento(id_local): Referencia a tabela local_atendimento (coluna id_local) para garantir integridade referencial
- Estrangeira (fk_faed_lote): coluna id_lote -> tabela farmaco_lote(id_lote): Referencia a tabela farmaco_lote (coluna id_lote) para garantir integridade referencial
- Estrangeira (fk_farmacia_atendimento_externo_dispensacao_atendimento): coluna id_atendimento -> tabela atendimento(id_atendimento): Referencia a tabela atendimento (coluna id_atendimento) para garantir integridade referencial
- Estrangeira (fk_farmacia_atendimento_externo_dispensacao_entidade): coluna id_entidade -> tabela saas_entidade(id_entidade): Referencia a tabela saas_entidade (coluna id_entidade) para garantir integridade referencial

## Indices

- idx_faed (id_item, status)
- fk_faed_lote (id_lote)
- fk_faed_local (id_local_estoque)
- fk_farmacia_atendimento_externo_dispensacao_atendimento (id_atendimento)
- idx_far_disp_ent (id_entidade)

## Constraints

- FOREIGN KEY fk_faed_item: id_item references farmacia_atendimento_externo_item(id_item)
- FOREIGN KEY fk_faed_local: id_local_estoque references local_atendimento(id_local)
- FOREIGN KEY fk_faed_lote: id_lote references farmaco_lote(id_lote)
- FOREIGN KEY fk_farmacia_atendimento_externo_dispensacao_atendimento: id_atendimento references atendimento(id_atendimento)
- FOREIGN KEY fk_farmacia_atendimento_externo_dispensacao_entidade: id_entidade references saas_entidade(id_entidade)
- PRIMARY KEY (id_dispensacao)

## Relacionamentos e Cardinalidade

- farmacia_atendimento_externo_dispensacao (1) -> farmacia_atendimento_externo_item (1): campo id_item
- farmacia_atendimento_externo_dispensacao (1) -> local_atendimento (1): campo id_local_estoque
- farmacia_atendimento_externo_dispensacao (1) -> farmaco_lote (1): campo id_lote
- farmacia_atendimento_externo_dispensacao (1) -> atendimento (1): campo id_atendimento
- farmacia_atendimento_externo_dispensacao (1) -> saas_entidade (1): campo id_entidade

## Dependencias

- Depende de:
  - farmacia_atendimento_externo_item
  - local_atendimento
  - farmaco_lote
  - atendimento
  - saas_entidade
- Dependencias diretas: Nenhuma tabela listada depende diretamente desta tabela com base nas FKs encontradas.

## Fluxo de utilizacao dentro do sistema

- Executa a baixa final do medicamento no estoque.
- Acionada após confirmação de segunda baixa na receita controlada.
- Gera log de dispensação e atualiza saldos de estoque.
- Vinculada diretamente a atendimentos externos e itens de farmácia.

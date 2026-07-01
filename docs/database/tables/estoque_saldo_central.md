# estoque_saldo_central

Objetivo: Gerenciamento de saldo e quantidades de estoque

Descrição: Armazena o saldo físico, reservado e projetado de itens de estoque por unidade, local e lote no ambiente central. Utilizada para controle de disponibilidade e conciliação de estoque.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id_saldo | bigint AUTO_INCREMENT | NO | — | Valor do serviço ambulatorial |
| id_unidade | bigint unsigned | NO | — | Identificador da unidade de saúde |
| id_local | bigint | NO | — | Identificador do local |
| id_item | bigint | NO | — | Identificador do item |
| id_lote | bigint | NO | — | Identificador do lote de medicamento |
| qtd_fisica | decimal(15,4) | NO | '0.0000' | Quantidade física registrada em estoque |
| qtd_reservada | decimal(15,4) | NO | '0.0000' | Quantidade reservada para atendimento |
| qtd_projetada | decimal(15,4) GENERATED ALWAYS AS ((`qtd_fisica` - `qtd_reservada`)) STORED | YES | GENERATED | Quantidade projetada (física - reservada) |
| id_sessao_usuario | bigint | NO | — | Identificador da sessão do usuário |
| ultima_atualizacao | timestamp | YES | CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP | Data e hora da última atualização do saldo |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id_saldo
- Unica (uk_central_his): id_unidade, id_local, id_item, id_lote
- Estrangeira (fk_central_item): coluna id_item -> tabela estoque_item(id_item): Referencia a tabela estoque_item (coluna id_item) para garantir integridade referencial
- Estrangeira (fk_central_lote): coluna id_lote -> tabela estoque_lote(id_lote): Referencia a tabela estoque_lote (coluna id_lote) para garantir integridade referencial
- Estrangeira (fk_estoque_saldo_central_unidade): coluna id_unidade -> tabela unidade(id_unidade): Referencia a tabela unidade (coluna id_unidade) para garantir integridade referencial

## Indices

- idx_central_lock (id_item, id_local, id_lote)
- fk_central_lote (id_lote)

## Constraints

- FOREIGN KEY fk_central_item: id_item references estoque_item(id_item)
- FOREIGN KEY fk_central_lote: id_lote references estoque_lote(id_lote)
- FOREIGN KEY fk_estoque_saldo_central_unidade: id_unidade references unidade(id_unidade)
- UNIQUE KEY uk_central_his (id_unidade, id_local, id_item, id_lote)
- PRIMARY KEY (id_saldo)

## Relacionamentos e Cardinalidade

- estoque_saldo_central (1) -> estoque_item (1): campo id_item
- estoque_saldo_central (1) -> estoque_lote (1): campo id_lote
- estoque_saldo_central (1) -> unidade (1): campo id_unidade

## Dependencias

- Depende de:
  - estoque_item
  - estoque_lote
  - unidade
- Dependencias diretas: Nenhuma tabela listada depende diretamente desta tabela com base nas FKs encontradas.

## Fluxo de utilizacao dentro do sistema

- Controle centralizado de saldo de medicamentos e insumos.
- Consultado em operações de dispensação, faturamento e conciliação.
- Atualizado por movimentações de entrada (compras, transferências) e saída (atendimento a pacientes).
- Publicado para ambientes master quando aplicável para sincronização.

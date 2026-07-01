# faturamento_insumo

Objetivo: Gestão de contas, itens e regras de faturamento

Descrição: Detalhe de insumos faturáveis (farmácia, almoxarifado, manutenção) vinculados a itens de faturamento, com lote e validade.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id_fat_insumo | bigint AUTO_INCREMENT | NO | — | Identificador único de fat insumo |
| id_item | bigint | NO | — | Identificador do item |
| origem | enum('FARMACIA','ALMOXARIFADO','MANUTENCAO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | NO | — | Origem do registro (sistema ou operação que gerou o evento) |
| id_produto | bigint | NO | — | Identificador do produto/medicamento |
| lote | varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT | YES | NULL | Identificador do lote de medicamento |
| validade | date DEFAULT | YES | NULL | Data de validade do lote |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id_fat_insumo

## Indices

- idx_item (id_item)

## Constraints

- PRIMARY KEY (id_fat_insumo)

## Relacionamentos e Cardinalidade


## Dependencias

- Dependencias diretas: Nenhuma tabela listada depende diretamente desta tabela com base nas FKs encontradas.

## Fluxo de utilizacao dentro do sistema

- Tabela componente do módulo de atendimento e faturamento hospitalar.
- Utilizada para persistência e consulta de dados específicos do domínio.
- Associada a operações de cadastro, evolução e faturamento.
- Integrada com fluxos de auditoria e sincronização.

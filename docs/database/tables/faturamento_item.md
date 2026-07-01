# faturamento_item

Objetivo: Gestão de contas, itens e regras de faturamento

Descrição: Itens faturáveis gerados a partir de eventos assistenciais (procedimentos, exames, medicações, materiais, taxas), com valores e descontos.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id_item | bigint AUTO_INCREMENT | NO | — | Identificador do item |
| origem | enum('PROCEDIMENTO','EXAME','MEDICACAO','MATERIAL','TAXA','OUTRO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | NO | — | Origem do registro (sistema ou operação que gerou o evento) |
| id_origem | bigint | NO | — | Identificador único de origem |
| descricao | varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | NO | — | Descrição textual do registro |
| quantidade | decimal(10,2) | YES | '1.00' | Quantidade numérica do item |
| valor_unitario | decimal(10,2) | NO | — | Valor unitário do item |
| valor_total | decimal(10,2) | NO | — | Valor total calculado |
| id_ffa | bigint DEFAULT | YES | NULL | Identificador do fluxo de atendimento ambulatorial |
| id_internacao | bigint DEFAULT | YES | NULL | Identificador da internação |
| criado_em | datetime | YES | CURRENT_TIMESTAMP | Data e hora do registro |
| criado_por | bigint | NO | — | Usuário responsável pela criação |
| status | enum('ABERTO','CONSOLIDADO','CANCELADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | YES | 'ABERTO' | Status atual conforme enumeração definida |
| id_conta | bigint DEFAULT | YES | NULL | Identificador único de conta |
| id_codigo | bigint DEFAULT | YES | NULL | Identificador do código de faturamento |
| sistema_codigo | enum('SUS','TUSS','PROPRIO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | NO | 'PROPRIO' | Código de identificação |
| codigo | varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT | YES | NULL | Código de identificação do registro |
| tipo | enum('PROCEDIMENTO','EXAME','MEDICACAO','DIARIA','HONORARIO','OUTRO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | NO | 'OUTRO' | Endereço IP de origem da requisição |
| desconto | decimal(10,2) | NO | '0.00' | Valor de desconto aplicado à linha |
| total_linha | decimal(10,2) | NO | '0.00' | Valor total da linha do item |
| atualizado_em | datetime | NO | CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP | Data e hora do registro |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id_item
- Estrangeira (fk_fat_item_codigo): coluna id_codigo -> tabela faturamento_codigo(id_codigo): Referencia a tabela faturamento_codigo (coluna id_codigo) para garantir integridade referencial
- Estrangeira (fk_fat_item_conta): coluna id_conta -> tabela faturamento_conta(id_conta): Referencia a tabela faturamento_conta (coluna id_conta) para garantir integridade referencial

## Indices

- idx_fat_item_conta (id_conta)
- idx_fat_item_codigo (id_codigo)
- idx_fat_item_codigo_txt (codigo)

## Constraints

- FOREIGN KEY fk_fat_item_codigo: id_codigo references faturamento_codigo(id_codigo)
- FOREIGN KEY fk_fat_item_conta: id_conta references faturamento_conta(id_conta)
- PRIMARY KEY (id_item)

## Relacionamentos e Cardinalidade

- faturamento_item (1) -> faturamento_codigo (1): campo id_codigo
- faturamento_item (1) -> faturamento_conta (1): campo id_conta

## Dependencias

- Depende de:
  - faturamento_codigo
  - faturamento_conta
- Dependencias diretas: Nenhuma tabela listada depende diretamente desta tabela com base nas FKs encontradas.

## Fluxo de utilizacao dentro do sistema

- Itens faturáveis gerados a partir de procedimentos, exames, medicações e materiais consumidos.
- Consolidados em contas de faturamento vinculadas a FFA ou internação.
- Permitem descontos, alteração de status e correção contábil.
- Alimentam exportações SUS/TISS e relatórios de produção.

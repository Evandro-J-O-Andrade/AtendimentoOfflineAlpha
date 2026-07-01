# reg_export_item

Objetivo: Representar itens individuais dentro de lotes de exportação, com controle de status e vínculo com registros do sistema.

Descrição: Tabela que representa cada item que será exportado dentro de um lote de exportação, permitindo rastrear o status de cada item (pendente, gerado, enviado, erro, confirmado, cancelado) e os metadados da exportação.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_export_item | bigint | NOT NULL | - | Chave primária da tabela, identificador único do item de exportação |
| id_export_lote | bigint | NOT NULL | - | Referência ao id do lote de exportação ao qual o item pertence |
| entidade_ref | varchar(80) | NOT NULL | - | Nome da entidade referenciada no item (ex: atendimento, prontuario) |
| id_ref | bigint | NOT NULL | - | Id do registro da entidade referenciada |
| status | enum('PENDENTE','GERADO','ENVIADO','ERRO','CONFIRMADO','CANCELADO') | NOT NULL | 'PENDENTE' | Status do item: PENDENTE, GERADO, ENVIADO, ERRO, CONFIRMADO ou CANCELADO |
| payload_hash | char(64) | YES | NULL | Hash do payload para verificação de integridade |
| protocolo_externo | varchar(80) | YES | NULL | Número do protocolo externo se houver integração |
| tentativas | int | NOT NULL | '0' | Quantidade de tentativas de processamento do item |
| ultima_tentativa_em | datetime | YES | NULL | Data e hora da última tentativa de processamento |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data e hora de criação do registro do item |
| atualizado_em | datetime | - | CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP | Data e hora da última atualização do item |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde o item está sendo exportado |

## Chaves
- Primária: id_export_item
- Únicas: uk_reg_item_lote_ref (id_export_lote, entidade_ref, id_ref)
- Estrangeiras: fk_reg_item_lote (id_export_lote → reg_export_lote.id_export_lote) - vincula o item ao lote

## Índices
- PRIMARY KEY (id_export_item)
- UNIQUE KEY uk_reg_item_lote_ref (id_export_lote, entidade_ref, id_ref)
- KEY idx_reg_item_status (status)
- KEY idx_reg_item_ref (entidade_ref, id_ref)

## Constraints
- CONSTRAINT fk_reg_item_lote FOREIGN KEY (id_export_lote) REFERENCES reg_export_lote (id_export_lote)

## Relacionamentos e Cardinalidade
- N:1 com reg_export_lote (um lote pode ter vários itens)

## Dependências
- Tabelas que dependem desta: reg_export_erro_validacao
| Esta tabela depende de: reg_export_lote

## Fluxo de utilização dentro do sistema
- Criado automaticamente quando itens são incluídos em um lote de exportação
- Permite rastrear cada etapa do processamento do item
- Controle de tentativas para reprocessamento em caso de falha
- Vinculado a qualquer entidade através de entidade_ref/id_ref
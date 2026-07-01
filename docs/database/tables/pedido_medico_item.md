# pedido_medico_item

Objetivo: Detalhar os itens individuais de cada pedido médico.
Descrição: Tabela que contém os itens de cada pedido médico, especificando o tipo de item, código SIGTAP, CID10, informações de executante e status individual de cada item.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_pedido_item | bigint | NOT NULL | - | Identificador único do item (chave primária, auto incremento) |
| id_pedido_medico | bigint | NOT NULL | - | ID do pedido médico ao qual o item pertence |
| tipo_item | enum('PROCEDIMENTO','EXAME','MEDICACAO','ENCAMINHAMENTO','OUTRO') | NOT NULL | - | Tipo do item: procedimento, exame, medicação, encaminhamento ou outro |
| status | enum('PENDENTE','EM_EXECUCAO','CONCLUIDO','CANCELADO','SUSPENSO') | NOT NULL | 'PENDENTE' | Status individual do item: pendente, em execução, concluído, cancelado ou suspenso |
| codigo_sigtap | varchar(30) | YES | NULL | Código SIGTAP do procedimento ou exame |
| competencia_sigtap | char(6) | YES | NULL | Competência do código SIGTAP (ex: "202401") |
| cid10_principal | varchar(10) | YES | NULL | CID-10 principal relacionado ao item |
| cnes_executante | varchar(20) | YES | NULL | Código CNES do estabelecimento executante |
| id_codigo_universal | bigint | YES | NULL | ID do código universal do produto (quando aplicável) |
| sistema_externo | varchar(50) | YES | NULL | Nome do sistema externo que gerou o item |
| codigo_externo | varchar(80) | YES | NULL | Código no sistema externo |
| descricao | varchar(500) | YES | NULL | Descrição do item quando não usa código padronizado |
| prioridade | tinyint | YES | NULL | Nível de prioridade do item (ex: 1=urgente) |
| observacao | text | YES | NULL | Observações sobre o item |
| exige_cat | tinyint(1) | NOT NULL | '0' | Flag indicando se o item exige notificação CAT (acidente de trabalho) |
| exige_sinan | tinyint(1) | NOT NULL | '0' | Flag indicando se o item exige notificação SINAN |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data/hora de criação do item |
| atualizado_em | datetime | YES | NULL | Data/hora da última atualização |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual o item pertence |

## Chaves
- Primária: id_pedido_item
- Únicas: uk_pedido_item_externo (sistema_externo, codigo_externo)
- Estrangeiras: (nenhuma foreign key explícita)

## Índices
- PRIMARY KEY (id_pedido_item)
- UNIQUE KEY uk_pedido_item_externo (sistema_externo, codigo_externo)
- KEY ix_pedido_item_pedido (id_pedido_medico)
- KEY ix_pedido_item_tipo (tipo_item)
- KEY ix_pedido_item_status (status)

## Constraints
- PRIMARY KEY: id_pedido_item
- UNIQUE: uk_pedido_item_externo

## Relacionamentos e Cardinalidade
- N:1 com pedido_medico: Muitos itens pertencem a um pedido
- N:1 com codigo_universal: Muitos itens podem referenciar um código universal

## Dependências
- Esta tabela depende de: pedido_medico, codigo_universal, saas_entidade
- Não há tabelas que dependem desta tabela

## Fluxo de utilização dentro do sistema
Utilizada para detalhar cada item de um pedido médico. O item pode ser um procedimento com código SIGTAP, um exame, uma medicação ou encaminhamento. Flags exige_cat e exige_sinan acionam notificações obrigatórias. O status individual permite acompanhar item por item, independentemente do status geral do pedido.
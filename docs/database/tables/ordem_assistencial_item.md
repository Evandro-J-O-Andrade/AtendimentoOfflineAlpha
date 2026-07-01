# ordem_assistencial_item

Objetivo: Armazenar os itens individuais que compõem uma ordem assistencial (medicamentos, dietas, procedimentos, cuidados).
Descrição: Tabela que detalha cada item dentro de uma ordem assistencial, especificando o tipo de item (medicação, dieta, oxigênio, procedimento, etc.), dosagem, via de administração, posologia e horários. Cada item pertence a uma ordem e pode ter múltiplos agendamentos e execuções.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_item | bigint | NOT NULL | - | Identificador único do item da ordem (chave primária, auto incremento) |
| id_ordem | bigint | NOT NULL | - | ID da ordem assistencial à qual o item pertence |
| tipo_item | enum('FARMACO','CUIDADO','DIETA','OXIGENIO','PROCEDIMENTO','OUTRO') | NOT NULL | 'FARMACO' | Tipo do item: medicamento, cuidado, dieta, oxigênio, procedimento ou outro |
| id_farmaco | bigint | YES | NULL | ID do medicamento (quando tipo_item=FARMACO) |
| descricao_item | varchar(255) | YES | NULL | Descrição textual do item quando não é medicamento controlado |
| dose | varchar(100) | YES | NULL | Dosagem do item (ex: "500mg", "10ml") |
| via | varchar(50) | YES | NULL | Via de administração (ex: "oral", "IV", "topica") |
| posologia | varchar(100) | YES | NULL | Posologia do item (ex: "a cada 8 horas") |
| dias | int | YES | NULL | Número de dias para aplicação do item |
| quantidade | decimal(10,2) | YES | NULL | Quantidade total do item |
| unidade | varchar(20) | YES | NULL | Unidade de medida (ex: "comprimido", "ampola") |
| frequencia_min | int | YES | NULL | Frequência mínima em minutos entre aplicações |
| frequencia_txt | varchar(50) | YES | NULL | Frequência em texto (ex: "8h", "12h") |
| horarios_json | json | YES | NULL | Horários específicos para aplicação em formato JSON |
| inicio_em | datetime | YES | NULL | Data/hora de início da aplicação do item |
| fim_em | datetime | YES | NULL | Data/hora de término da aplicação do item |
| quantidade_total | decimal(10,2) | NOT NULL | '0.00' | Quantidade total acumulada do item |
| status | enum('ATIVO','SUSPENSO','ENCERRADO') | NOT NULL | 'ATIVO' | Status do item na ordem: ativo, suspenso ou encerrado |
| observacao | text | YES | - | Observações sobre o item |
| criado_por | bigint | NOT NULL | - | ID do usuário que criou o item |
| id_sessao_usuario_criado | bigint | YES | NULL | ID da sessão do usuário durante criação |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data/hora de criação do item |
| atualizado_por | bigint | YES | NULL | ID do usuário que atualizou o item |
| id_sessao_usuario_atualizado | bigint | YES | NULL | ID da sessão do usuário durante atualização |
| atualizado_em | datetime | YES | NULL | Data/hora da última atualização |
| id_atendimento | bigint unsigned | NOT NULL | - | ID do atendimento ao qual o item pertence |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual o item pertence |

## Chaves
- Primária: id_item
- Únicas: (nenhuma)
- Estrangeiras: 
  - fk_ordem_assistencial_item_ordem: id_ordem → ordem_assistencial (id)
  - fk_ordem_assistencial_item_atendimento: id_atendimento → atendimento (id_atendimento) com CASCADE

## Índices
- PRIMARY KEY (id_item)
- KEY idx_item_ordem (id_ordem)
- KEY idx_item_farmaco (id_farmaco)
- KEY idx_item_tipo_status (tipo_item, status)
- KEY idx_item_ordem_status (id_ordem, status)

## Constraints
- PRIMARY KEY: id_item
- FOREIGN KEY: fk_ordem_assistencial_item_ordem
- FOREIGN KEY: fk_ordem_assistencial_item_atendimento

## Relacionamentos e Cardinalidade
- N:1 com ordem_assistencial: Muitos itens pertencem a uma ordem
- N:1 com ordem_assistencial_aprazamento: Um item pode ter muitos agendamentos
- N:1 com ordem_assistencial_execucao: Um item pode ter muitas execuções
- N:1 com administracao_medicacao_ordem: Um item pode ter muitas administrações
- N:1 com atendimento: Muitos itens pertencem a um atendimento

## Dependências
- Esta tabela depende de: ordem_assistencial, atendimento, saas_entidade
- Tabelas que dependem desta: ordem_assistencial_aprazamento, ordem_assistencial_execucao, administracao_medicacao_ordem

## Fluxo de utilização dentro do sistema
Utilizada ao criar ordens assistenciais para detalhar cada item. O item é criado com os parâmetros clínicos necessários e depois agendado via ordem_assistencial_aprazamento. Quando o item é executado, o registro vai para ordem_assistencial_execucao. Permite rastrear todo o ciclo de vida de cada item da ordem.
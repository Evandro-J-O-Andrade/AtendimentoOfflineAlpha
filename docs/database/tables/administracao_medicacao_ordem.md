# administracao_medicacao_ordem

Objetivo: Registrar a administração de medicamentos a partir de ordens assistenciais, controlando quantidade, status e responsáveis pela administração.

Descrição: Esta tabela registra a administração de medicamentos derivada de ordens assistenciais, permitindo o controle de quantidade utilizada, status da administração (administrado, não administrado, estornado), e auditoria completa com usuários e sessões envolvidas.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_administracao | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do registro de administração de ordem assistencial |
| id_item | bigint | NOT NULL | - | Chave estrangeira que referencia o item da ordem assistencial que foi administrado |
| quantidade | decimal(10,2) | NOT NULL | - | Quantidade do medicamento administrado, com precisão decimal de 2 casas |
| realizado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Timestamp automático da data/hora em que a administração foi realizada |
| id_usuario | bigint | NOT NULL | - | Chave estrangeira que referencia o usuário responsável pela administração |
| id_sessao_usuario | bigint | YES | NULL | Chave estrangeira que referencia a sessão do usuário no momento da administração |
| id_local_operacional | bigint | YES | NULL | Identificador do local operacional onde a administração foi realizada |
| id_aprazamento | bigint | YES | NULL | Identificador do aprazamento (agendamento) da medicação, quando aplicável |
| observacao | text | YES | NULL | Campo de texto livre para observações sobre a administração |
| status | enum('ADMINISTRADO','NAO_ADMINISTRADO','ESTORNADO') | NOT NULL | 'ADMINISTRADO' | Status da administração: se foi administrado com sucesso, não foi administrado, ou foi estornado/cancelado |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o registro pertence |

## Chaves
- Primária: id_administracao
- Únicas: Nenhuma
- Estrangeiras: fk_admin_item - id_item → ordem_assistencial_item(id_item) - Vincula o registro ao item da ordem assistencial; fk_admin_user - id_usuario → usuario(id_usuario) - Vincula o registro ao usuário que realizou a administração

## Índices
- idx_admin_item (KEY) - Índice para busca por item da ordem
- idx_admin_user (KEY) - Índice para busca por usuário

## Constraints
- fk_admin_item - FOREIGN KEY - Restringe id_item à tabela ordem_assistencial_item(id_item)
- fk_admin_user - FOREIGN KEY - Restringe id_usuario à tabela usuario(id_usuario)

## Relacionamentos e Cardinalidade
- N:1 com ordem_assistencial_item - Cada administração está vinculada a um item específico da ordem assistencial
- N:1 com usuario - Cada registro é vinculado a um único usuário responsável

## Dependências
- Tabelas que dependem desta: Nenhuma (não há FK apontando para esta tabela)
- Tabelas das quais esta depende: ordem_assistencial_item, usuario

## Fluxo de utilização dentro do sistema
- Registro da administração de medicamentos a partir de ordens assistenciais
- Controle de quantidade administrada para gestão de estoque
- Status diferenciado para rastrear medicamentos não administrados ou estornados
- Auditoria completa com sessão e local operacional para rastreabilidade
- Observações para registro de eventos clínicos relevantes durante administração
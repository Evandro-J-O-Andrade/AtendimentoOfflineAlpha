# atendimento_pedidos_exame

Objetivo: Registrar pedidos de exames durante atendimentos, controlando status, prioridade e informações de solicitação e resultado.

Descrição: Esta tabela armazena os pedidos de exames realizados durante atendimentos médicos, vinculando ao médico solicitante, código TUSS do exame, status da solicitação e prioridade, com controle de data e URL do laudo PACS.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do pedido de exame |
| id_atendimento | bigint unsigned | NOT NULL | - | Chave estrangeira que referencia o atendimento ao qual o pedido pertence |
| id_medico_solicitante | bigint | NOT NULL | - | Identificador do médico que solicitou o exame |
| id_exame_tuss | varchar(20) | NOT NULL | - | Chave estrangeira que referencia o código TUSS do exame solicitado |
| status_exame | enum('SOLICITADO','COLETADO','EM_ANALISE','LAUDADO','ENTREGUE') | YES | 'SOLICITADO' | Status do exame: solicitado, coletado, em análise, laudado, entregue |
| prioridade | enum('ELETIVO','URGENTE','EMERGENCIA') | YES | 'ELETIVO' | Prioridade do exame: eletivo, urgente ou emergência |
| data_solicitacao | datetime | YES | CURRENT_TIMESTAMP | Timestamp automático da data/hora da solicitação |
| url_laudo_pacs | varchar(255) | YES | NULL | URL do laudo no sistema PACS (imagem DICOM) |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o registro pertence |

## Chunas
- Primária: id
- Únicas: Nenhuma
- Estrangeiras: fk_pedido_tuss - id_exame_tuss → tabela_tuss(codigo_tuss) - Vincula o pedido ao código TUSS do exame; fk_atendimento_pedidos_exame_atendimento - id_atendimento → atendimento(id_atendimento) - Vincula o pedido ao atendimento; fk_atendimento_pedidos_exame_entidade - id_entidade → saas_entidade(id_entidade) - Vincula o pedido à entidade |

## Índices
- fk_pedido_tuss (KEY) - Índice para busca por código TUSS
- fk_atendimento_pedidos_exame_atendimento (KEY) - Índice para busca por atendimento
- idx_apex_ent (KEY) - Índice para busca por entidade

## Constraints
- fk_pedido_tuss - FOREIGN KEY - Restringe id_exame_tuss à tabela tabela_tuss(codigo_tuss)
- fk_atendimento_pedidos_exame_atendimento - FOREIGN KEY - Restringe id_atendimento à tabela atendimento(id_atendimento) com CASCADE
- fk_atendimento_pedidos_exame_entidade - FOREIGN KEY - Restringe id_entidade à tabela saas_entidade(id_entidade)

## Relacionamentos e Cardinalidade
- N:1 com tabela_tuss - Cada pedido está associado a um código TUSS de exame
- N:1 com atendimento - Cada pedido está associado a um atendimento (com CASCADE)
- N:1 com saas_entidade - Cada pedido pertence a uma entidade SaaS

## Dependências
- Tabelas que dependem desta: Nenhuma (não há FK apontando diretamente para atendimento_pedidos_exame)
- Tabelas das quais esta depende: tabela_tuss, atendimento, saas_entidade

## Fluxo de utilização dentro do sistema
- Registro de pedidos de exames durante atendimento médico
- Vinculação ao médico solicitante para responsabilidade
- Código TUSS para padronização de procedimentos
- Status de acompanhamento: solicitado, coletado, em análise, laudado, entregue
- Prioridade para escalar atendimento (eletivo, urgente, emergência)
- URL do laudo PACS para integração com sistema de imagem
- Timestamp automático de solicitação
- Cascade delete remove pedidos quando atendimento é excluído
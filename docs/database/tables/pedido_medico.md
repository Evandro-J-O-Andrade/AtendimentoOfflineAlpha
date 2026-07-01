# pedido_medico

Objetivo: Gerenciar pedidos médicos com status e controle de execução.
Descrição: Tabela que representa pedidos médicos dentro de um atendimento, podendo conter solicitações de exames, medicamentos, procedimentos ou encaminhamentos. Cada pedido tem status de acompanhamento.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_pedido_medico | bigint | NOT NULL | - | Identificador único do pedido (chave primária, auto incremento) |
| id_ffa | bigint | NOT NULL | - | ID do Fluxo de Atendimento Assistencial (FFA) associado |
| id_gpat | bigint | NOT NULL | - | ID do GPAT (atendimento presencial) associado |
| id_usuario_solicitante | bigint | NOT NULL | - | ID do usuário que criou o pedido |
| id_local_operacional | bigint | YES | NULL | ID do local operacional onde o pedido foi solicitado |
| status | enum('ABERTO','EM_EXECUCAO','CONCLUIDO','CANCELADO') | NOT NULL | 'ABERTO' | Status atual do pedido: aberto, em execução, concluído ou cancelado |
| justificativa | varchar(500) | YES | NULL | Justificativa para o cancelamento ou outras observações |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data/hora de criação do pedido |
| atualizado_em | datetime | YES | NULL | Data/hora da última atualização |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual o pedido pertence |

## Chaves
- Primária: id_pedido_medico
- Únicas: (nenhuma)
- Estrangeiras: (nenhuma foreign key explícita)

## Índices
- PRIMARY KEY (id_pedido_medico)
- KEY ix_pedido_medico_ffa (id_ffa)
- KEY ix_pedido_medico_status (status)
- KEY ix_pedido_medico_gpat (id_gpat)

## Constraints
- PRIMARY KEY: id_pedido_medico

## Relacionamentos e Cardinalidade
- 1:N com pedido_medico_item: Um pedido pode ter muitos itens
- N:1 com ffa: Muitos pedidos pertencem a um FFA
- N:1 com gpat: Muitos pedidos pertencem a um GPAT
- N:1 com usuario: Muitos pedidos são criados por um usuário
- N:1 com local_operacional: Muitos pedidos podem ter um local associado

## Dependências
- Esta tabela depende de: saas_entidade
- Tabelas que dependem desta: pedido_medico_item

## Fluxo de utilização dentro do sistema
Utilizada para gerenciar solicitações médicos dentro de um atendimento. O médico cria um pedido com status ABERTO, que pode incluir itens de exames, medicamentos ou procedimentos. À medida que os itens são executados, o status evolui. Permite acompanhamento em tempo real do andamento do pedido.
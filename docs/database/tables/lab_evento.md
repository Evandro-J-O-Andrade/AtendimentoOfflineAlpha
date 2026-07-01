# lab_evento

Objetivo: Registrar eventos e mudanças de status nos pedidos de exames laboratoriais.
Descrição: Tabela de auditoria que registra todas as mudanças de estado e eventos ocorridos em pedidos de laboratório, permitindo rastrear a história completa de cada pedido desde a solicitação até o resultado final.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id` | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do evento |
| `id_pedido` | bigint | NOT NULL | - | Referência ao pedido de laboratório |
| `status_novo` | varchar(50) | NULL | NULL | Novo status atribuído ao pedido |
| `id_usuario` | bigint | NOT NULL | - | Usuário que realizou a ação que gerou o evento |
| `data_hora` | datetime | NULL | CURRENT_TIMESTAMP | Timestamp do evento |
| `payload_auditoria` | text | NULL | NULL | Payload com detalhes da auditoria |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária |

## Chaves
- Primária: `id`
- Únicas: -
- Estrangeiras: 
  - `fk_evento_lab_pedido` (`id_pedido`) → `lab_pedido` (`id_pedido`) - Relaciona evento ao pedido

## Índices
- `fk_evento_lab_pedido` (KEY) - Índice em `id_pedido`

## Constraints
- `fk_evento_lab_pedido` FOREIGN KEY - Relaciona `id_pedido` com `lab_pedido`.`id_pedido`

## Relacionamentos e Cardinalidade
- N:1 com `lab_pedido` - Muitos eventos pertencem a um pedido de laboratório
- N:1 com `usuario` - Muitos eventos podem ter sido criados pelo mesmo usuário

## Dependências
- Esta tabela é referenciada por: (não possui FK apontando para ela)
- Esta tabela depende de: `lab_pedido`, `usuario`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Cada mudança de status no pedido gera um evento nesta tabela
2. O status_novo reflete o novo estado do pedido (SOLICITADO, COLETADO, ENVIADO, RECEBIDO_LAB, FINALIZADO, CANCELADO)
3. O payload_auditoria contém detalhes da mudança para rastreabilidade
4. Usado para auditoria completa de pedidos de laboratório
5. Permite replay de eventos em caso de inconsistências
6. Base para relatórios de SLA e tempo de processamento
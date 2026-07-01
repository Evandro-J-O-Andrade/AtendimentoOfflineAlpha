# auditoria_estoque

Objetivo: Auditar movimentações de estoque no contexto do sistema de estoques.
Descrição: Tabela de auditoria que registra cada movimentação de itens no estoque, incluindo tipo de ação, quantidade e responsável pela operação.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_log | bigint | NOT NULL | - | Identificador único do registro de auditoria, chave primária auto incrementada. |
| id_produto | bigint | NOT NULL | - | Referência ao produto que teve movimentação no estoque. |
| id_local | int | NOT NULL | - | Referência ao local onde ocorreu a movimentação. |
| acao | varchar(50) | NOT NULL | - | Tipo de ação realizada: entrada, saída ou ajuste. |
| quantidade | int | NOT NULL | - | Quantidade de itens movimentada. |
| id_usuario | bigint | Nullable | - | Referência ao usuário responsável pela movimentação. |
| data_hora | datetime | Nullable | CURRENT_TIMESTAMP | Data e hora da movimentação. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) à qual o registro pertence. |

## Chaves
- Primária: id_log
- Únicas: nenhuma
- Estrangeiras: nenhuma

## Índices
- PRIMARY KEY (id_log)

## Constraints
- PRIMARY KEY: id_log

## Relacionamentos e Cardinalidade
- N:1 com produto (id_produto) - inferido
- N:1 com local (id_local) - inferido
- N:1 com usuario (id_usuario) - opcional

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: produto, local, usuario (inferido)

## Fluxo de utilização dentro do sistema
- Registrada a cada movimentação de estoque
- Usada para auditoria de operações de entrada e saída de produtos
- Permite rastrear responsável e data/hora de cada movimentação
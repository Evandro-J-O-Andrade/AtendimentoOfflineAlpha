# auditoria_almoxarifado

Objetivo: Auditar todas as movimentações de entrada, saída e ajuste de produtos no almoxarifado.
Descrição: Tabela de auditoria que registra cada movimentação de produtos no almoxarifado, incluindo quantidade, ação realizada (ENTRADA, SAIDA, AJUSTE), produto e local envolvidos.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_log | bigint | NOT NULL | - | Identificador único do registro de auditoria, chave primária auto incrementada. |
| id_produto | bigint | NOT NULL | - | Referência ao produto que teve movimentação no almoxarifado. |
| id_local | bigint | Nullable | - | Referência ao local onde ocorreu a movimentação no almoxarifado. |
| acao | enum('ENTRADA','SAIDA','AJUSTE') | Nullable | - | Tipo de movimentação: entrada, saída ou ajuste de estoque. |
| quantidade | int | NOT NULL | - | Quantidade de produtos movimentada. |
| id_usuario | bigint | Nullable | - | Referência ao usuário que realizou a movimentação. |
| data_hora | datetime | Nullable | CURRENT_TIMESTAMP | Data e hora da movimentação. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) à qual o registro pertence. |

## Chaves
- Primária: id_log
- Únicas: nenhuma
- Estrangeiras:
  - auditoria_almoxarifado_ibfk_1: id_produto → produtos_almoxarifado (id_produto)
  - auditoria_almoxarifado_ibfk_2: id_local → local_atendimento (id_local)
  - auditoria_almoxarifado_ibfk_3: id_usuario → usuario (id_usuario)

## Índices
- PRIMARY KEY (id_log)
- KEY id_produto (id_produto)
- KEY id_local (id_local)
- KEY id_usuario (id_usuario)

## Constraints
- PRIMARY KEY: id_log
- FOREIGN KEY: auditoria_almoxarifado_ibfk_1 (id_produto) REFERENCES produtos_almoxarifado (id_produto)
- FOREIGN KEY: auditoria_almoxarifado_ibfk_2 (id_local) REFERENCES local_atendimento (id_local)
- FOREIGN KEY: auditoria_almoxarifado_ibfk_3 (id_usuario) REFERENCES usuario (id_usuario)

## Relacionamentos e Cardinalidade
- N:1 com produtos_almoxarifado (id_produto)
- N:1 com local_atendimento (id_local)
- N:1 com usuario (id_usuario)

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: produtos_almoxarifado, local_atendimento, usuario

## Fluxo de utilização dentro do sistema
- Registrada automaticamente a cada movimentação de produtos no almoxarifado
- Usada para auditoria de estoque e rastreamento de produtos
- Permite rastrear responsável por cada movimentação
- Base para relatórios de controle de estoques
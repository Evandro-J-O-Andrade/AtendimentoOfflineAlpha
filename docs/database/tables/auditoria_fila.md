# auditoria_fila

Objetivo: Registrar auditoria de operações realizadas nas filas do sistema.
Descrição: Tabela que audita ações relacionadas a filas de atendimento, como chamadas, remoções, priorizações e outras operações de gestão de filas.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id | bigint | NOT NULL | - | Identificador único do registro de auditoria, chave primária auto incrementada. |
| id_fila | bigint | NOT NULL | - | Referência à fila onde a ação foi realizada. |
| id_usuario | bigint | Nullable | - | Referência ao usuário que realizou a ação na fila. |
| acao | varchar(100) | NOT NULL | - | Descrição da ação realizada (ex: CHAMAR, REMOVER, PRIORIZAR). |
| timestamp | datetime | Nullable | CURRENT_TIMESTAMP | Data e hora da ação registrada. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) à qual o registro pertence. |

## Chaves
- Primária: id
- Únicas: nenhuma
- Estrangeiras:
  - auditoria_fila_ibfk_1: id_fila → fila_senha (id)

## Índices
- PRIMARY KEY (id)
- KEY id_fila (id_fila)

## Constraints
- PRIMARY KEY: id
- FOREIGN KEY: auditoria_fila_ibfk_1 (id_fila) REFERENCES fila_senha (id)

## Relacionamentos e Cardinalidade
- N:1 com fila_senha (id_fila)
- N:1 com usuario (id_usuario) - opcional
- N:1 com saas_entidade (id_entidade)

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: fila_senha, usuario, saas_entidade

## Fluxo de utilização dentro do sistema
- Registrada a cada operação nas filas de atendimento
- Permite auditoria de chamadas, remoções e priorizações
- Usada para análise de desempenho e gestão de filas
- Base para relatórios de eficiência do fluxo assistencial
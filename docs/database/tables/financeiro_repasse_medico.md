# financeiro_repasse_medico

Objetivo: Gerenciar o cálculo e controle de repasses financeiros para médicos.

Descrição: Tabela que armazena os valores de repasses médicos referentes a procedimentos realizados, calculando o valor final a ser pago ao médico com base no valor do procedimento e percentual de repasse. Utilizada no fluxo financeiro para pagamento de profissionais.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id | bigint | NOT NULL | - | Identificador único do repasse, chave primária auto incrementada |
| id_usuario_medico | bigint | NOT NULL | - | Referência ao usuário médico que receberá o repasse |
| id_atendimento | bigint | NOT NULL | - | Referência ao atendimento onde o procedimento foi realizado |
| valor_procedimento | decimal(10,2) | DEFAULT NULL | - | Valor bruto do procedimento realizado |
| percentual_repasse | decimal(5,2) | DEFAULT | '100.00' | Percentual do valor a ser repassado ao médico (padrão 100%) |
| valor_final_medico | decimal(10,2) | DEFAULT NULL | - | Valor líquido calculado a ser pago ao médico |
| status_pagamento | enum('PREVIA','APROVADO','PAGO','GLOSADO') | DEFAULT | 'PREVIA' | Status do pagamento: prévia, aprovado, pago ou glosado |
| data_competencia | date | DEFAULT NULL | - | Data de competência do pagamento (mês/refência) |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id
- Únicas: -
- Estrangeiras: -

## Índices
- idx_repasse_medico (id_usuario_medico, data_competencia)
- idx_financeiro_competencia (data_competencia, status_pagamento)

## Constraints
- -

## Relacionamentos e Cardinalidade
- financeiro_repasse_medico.id_usuario_medico → usuario (id_usuario): N:1 (vários repasses podem referenciar o mesmo médico)
- financeiro_repasse_medico.id_atendimento → atendimento (id_atendimento): N:1 (vários repasses podem referenciar o mesmo atendimento)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: usuario, atendimento

## Fluxo de utilização dentro do sistema
1. Atendimento é realizado pelo médico
2. Registro financeiro é criado com valor do procedimento
3. Percentual de repasse é calculado (padrão 100%)
4. Valor final ao médico é calculado e armazenado
5. Status inicia como 'PREVIA' até aprovação
6. Após aprovação: status muda para 'APROVADO'
7. Quando pago: status muda para 'PAGO'
8. Se houver glosa: status muda para 'GLOSADO'
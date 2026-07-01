# prescricao

Objetivo: Armazenar prescrições médicas emitidas durante atendimentos.
Descrição: Tabela que registra prescrições médicas realizadas durante atendimentos, incluindo tipo (interna, controlada, de uso na casa) e descrição.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_prescricao | bigint | NOT NULL | - | Identificador único da prescrição (chave primária, auto incremento) |
| id_atendimento | bigint unsigned | NOT NULL | - | ID do atendimento ao qual a prescrição pertence |
| tipo | enum('INTERNA','CONTROLADA','CASA') | YES | NULL | Tipo de prescrição: interna (para uso no hospital), controlada (medicamento controlado) ou uso em casa |
| descricao | text | NOT NULL | - | Descrição textual da prescrição (medicamentos, posologias) |
| id_medico | bigint | YES | NULL | ID do médico que emitiu a prescrição |
| data_hora | datetime | YES | CURRENT_TIMESTAMP | Data/hora da prescrição |
| bloqueada | tinyint(1) | YES | '0' | Flag indicando se a prescrição está bloqueada (não pode ser editada) |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual a prescrição pertence |

## Chaves
- Primária: id_prescricao
- Únicas: (nenhuma)
- Estrangeiras: 
  - prescricao_ibfk_2: id_medico → medico (id_usuario)

## Índices
- PRIMARY KEY (id_prescricao)
- KEY id_atendimento (id_atendimento)
- KEY id_medico (id_medico)

## Constraints
- PRIMARY KEY: id_prescricao
- FOREIGN KEY: prescricao_ibfk_2

## Relacionamentos e Cardinalidade
- 1:N com prescricao_item: Uma prescrição pode ter muitos itens
- N:1 com atendimento: Muitas prescrições pertencem a um atendimento
- N:1 com medico: Muitas prescrições são emitidas por um médico

## Dependências
- Esta tabela depende de: atendimento, medico, saas_entidade
- Tabelas que dependem desta: prescricao_item, prescricao_checagem

## Fluxo de utilização dentro do sistema
Utilizada para registrar prescrições médicas durante o atendimento. O médico cria a prescrição com descrição dos medicamentos. Items individuais são armazenados em prescricao_item. O tipo CONTROLADA indica medicamentos controlados que requerem protocolos especiais. A flag bloqueada impede alterações após conclusão.
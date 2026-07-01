# atendimento_checagem

Objetivo: Registrar a checagem (verificação) de medicamentos prescritos, controlando horário planejado, horário executado, status e motivo de recusa.

Descrição: Esta tabela controla a verificação da administração de medicamentos prescritos durante atendimentos, permitindo o registro de quando o medicamento deveria ser administrado, quando foi realizado, por qual enfermeiro, e o status atual da checagem.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do registro de checagem |
| id_prescricao | bigint | NOT NULL | - | Chave estrangeira que referencia a prescrição sendo checada, vinculada à tabela atendimento_prescricao |
| horario_planejado | datetime | NOT NULL | - | Horário planejado para administração do medicamento |
| horario_executado | datetime | YES | NULL | Horário real em que o medicamento foi administrado (quando realizado) |
| id_enfermeiro | bigint | YES | NULL | Identificador do enfermeiro responsável pela administração |
| status | enum('PENDENTE','REALIZADO','RECUSADO','ATRASADO') | YES | 'PENDENTE' | Status da checagem: pendente, realizado, recusado ou atrasado |
| motivo_recusa | varchar(255) | YES | NULL | Motivo da recusa da administração (quando status = RECUSADO) |
| id_atendimento | bigint unsigned | NOT NULL | - | Chave estrangeira que referencia o atendimento ao qual a checagem pertence |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o registro pertence |

## Chaves
- Primária: id
- Únicas: Nenhuma
- Estrangeiras: fk_chec_presc - id_prescricao → atendimento_prescricao(id) - Vincula a checagem à prescrição; fk_atendimento_checagem_atendimento - id_atendimento → atendimento(id_atendimento) - Vincula a checagem ao atendimento; fk_atendimento_checagem_entidade - id_entidade → saas_entidade(id_entidade) - Vincula a checagem à entidade

## Índices
- fk_chec_presc (KEY) - Índice para busca por prescrição
- idx_checagem_horarios (KEY) - Índice composto por horario_planejado e status
- fk_atendimento_checagem_atendimento (KEY) - Índice para busca por atendimento
- idx_achec_ent (KEY) - Índice para busca por entidade

## Constraints
- fk_atendimento_checagem_atendimento - FOREIGN KEY - Restringe id_atendimento à tabela atendimento(id_atendimento) com CASCADE
- fk_atendimento_checagem_entidade - FOREIGN KEY - Restringe id_entidade à tabela saas_entidade(id_entidade)
- fk_chec_presc - FOREIGN KEY - Restringe id_prescricao à tabela atendimento_prescricao(id)

## Relacionamentos e Cardinalidade
- N:1 com atendimento_prescricao - Cada checagem está associada a uma prescrição específica
- N:1 com atendimento - Cada checagem está associada a um atendimento
- N:1 com saas_entidade - Cada checagem pertence a uma entidade SaaS

## Dependências
- Tabelas que dependem desta: Nenhuma (não há FK apontando para atendimento_checagem)
- Tabelas das quais esta depende: atendimento_prescricao, atendimento, saas_entidade

## Fluxo de utilização dentro do sistema
- Registro de horários planejados para administração de medicamentos
- Controle de horário real de execução para comparação com o planejado
- Status diferenciado para acompanhamento da administração (pendente, realizado, recusado, atrasado)
- Motivo de recusa para justificativa da não administração
- Índice composto por horário e status para busca eficiente de medicamentos pendentes
- Vinculação à prescrição para contexto clínico completo
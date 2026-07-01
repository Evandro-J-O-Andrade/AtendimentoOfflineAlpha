# atendimento_sumario_alta

Objetivo: Armazenar o sumário de alta do atendimento médico, contendo informações clínicas e orientações do paciente ao final do atendimento.
Descrição: Tabela que registra o resumo clínico, motivos de internação, procedimentos realizados, orientações pós-alta e medicamentos receitados no momento da alta médica. Utilizada para documentação formal do final do atendimento assistencial.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id | bigint | NOT NULL | - | Identificador único do sumário de alta, chave primária auto incrementada. |
| id_atendimento | bigint unsigned | NOT NULL | - | Referência ao atendimento ao qual este sumário está vinculado. Relacionamento 1:1 com atendimento. |
| id_medico_alta | bigint | NOT NULL | - | Identificador do profissional médico responsável pela alta. |
| motivo_internacao | text | Nullable | - | Descrição do motivo da internação ou admissão do paciente. |
| resumo_clinico | text | Nullable | - | Resumo clínico completo do atendimento, incluindo evolução e diagnóstico. |
| procedimentos_realizados | text | Nullable | - | Lista dos procedimentos médicos e terapêuticos realizados durante o atendimento. |
| orientacoes_pos_alta | text | Nullable | - | Orientações de cuidados e acompanhamento ao paciente após alta. |
| medicamentos_receitados | text | Nullable | - | Lista dos medicamentos prescritos ao paciente na alta. |
| data_alta | datetime | Nullable | CURRENT_TIMESTAMP | Data e hora da realização da alta médica. |
| assinatura_hash | varchar(255) | Nullable | NULL | Hash da assinatura digital do médico para validação de autenticidade. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) à qual o registro pertence. |

## Chaves
- Primária: id
- Únicas: uk_sumario_atend (id_atendimento)
- Estrangeiras: 
  - fk_atendimento_sumario_alta_atendimento: id_atendimento → atendimento (id_atendimento) - Relacionamento 1:1 com o atendimento, deleta em cascata
  - fk_atendimento_sumario_alta_entidade: id_entidade → saas_entidade (id_entidade)

## Índices
- PRIMARY KEY (id)
- UNIQUE KEY uk_sumario_atend (id_atendimento)
- KEY idx_asumal_ent (id_entidade)

## Constraints
- PRIMARY KEY: id
- UNIQUE: uk_sumario_atend (id_atendimento)
- FOREIGN KEY: fk_atendimento_sumario_alta_atendimento (id_atendimento) REFERENCES atendimento (id_atendimento) ON DELETE CASCADE ON UPDATE CASCADE
- FOREIGN KEY: fk_atendimento_sumario_alta_entidade (id_entidade) REFERENCES saas_entidade (id_entidade)

## Relacionamentos e Cardinalidade
- 1:1 com atendimento (id_atendimento)
- N:1 com saas_entidade (id_entidade)

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: atendimento, saas_entidade

## Fluxo de utilização dentro do sistema
- Utilizada no final do atendimento assistencial médico
- Criada quando o médico finaliza o atendimento e emite o sumário de alta
- Integra-se com assinatura digital para validação de autenticidade médica
- Referenciada por atendimento para obter dados da alta
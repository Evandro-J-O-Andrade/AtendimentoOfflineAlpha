# internacao

Objetivo: Gerenciar internações hospitalares de pacientes.

Descrição: Tabela central que controla o ciclo de vida da internação hospitalar, vinculando-se ao FFA, leito, atendimento e médico responsável. Controla entrada, saída, status e precauções de isolamento.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_internacao | bigint | NOT NULL | - | Identificador único da internação, chave primária auto incrementada |
| id_ffa | bigint | NOT NULL | - | Referência ao episódio FFA que originou a internação |
| id_leito | int | DEFAULT NULL | - | Referência ao leito onde o paciente está internado |
| tipo | enum('OBSERVACAO','INTERNACAO') | NOT NULL | - | Tipo: observação ou internação |
| motivo | text | DEFAULT NULL | - | Motivo da internação |
| status | enum('ATIVA','ENCERRADA','TRANSFERIDA','OBITO') | NOT NULL | 'ATIVA' | Status: ativa, encerrada, transferida ou óbito |
| data_entrada | datetime | NOT NULL | - | Data e hora de entrada na internação |
| id_usuario_entrada | bigint | DEFAULT NULL | - | Referência ao usuário que registrou a entrada |
| data_saida | datetime | DEFAULT NULL | - | Data e hora de saída da internação |
| id_usuario_saida | bigint | DEFAULT NULL | - | Referência ao usuário que registrou a saída |
| motivo_alta | varchar(255) | DEFAULT NULL | - | Motivo da alta hospitalar |
| criado_em | datetime | NOT NULL DEFAULT | CURRENT_TIMESTAMP | Data e hora de criação do registro |
| encerrado_em | datetime | DEFAULT NULL | - | Data e hora do encerramento da internação |
| precaucao | enum('PADRAO','CONTATO','GOTICULAS','AEROSSOIS') | NOT NULL | 'PADRAO' | Precaução de isolamento: padrão, contato, gotículas ou aerossóis |
| previsao_alta | datetime | DEFAULT NULL | - | Previsão de alta hospitalar |
| id_medico_responsavel | bigint | DEFAULT NULL | - | Referência ao médico responsável pela internação |
| id_sessao_usuario_entrada | bigint | DEFAULT NULL | - | Referência à sessão do usuário na entrada |
| id_sessao_usuario_saida | bigint | DEFAULT NULL | - | Referência à sessão do usuário na saída |
| id_local_operacional_entrada | bigint | DEFAULT NULL | - | Referência ao local operacional de entrada |
| id_local_operacional_saida | bigint | DEFAULT NULL | - | Referência ao local operacional de saída |
| id_unidade_entrada | bigint | DEFAULT NULL | - | Referência à unidade de entrada |
| id_unidade_saida | bigint | DEFAULT NULL | - | Referência à unidade de saída |
| id_atendimento | bigint unsigned | NOT NULL | - | Referência ao atendimento principal |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id_internacao
- Únicas: -
- Estrangeiras: fk_internacao_atendimento (id_atendimento → atendimento.id_atendimento)

## Índices
- idx_ffa (id_ffa)
- idx_status (status)
- idx_leito (id_leito)
- idx_internacao_ffa_status (id_ffa, status)
- idx_internacao_leito_status (id_leito, status)
- idx_internacao_datas (data_entrada, data_saida)
- idx_internacao_status_data (status, data_entrada, data_saida)
- fk_internacao_atendimento (id_atendimento)
- idx_int_ent (id_entidade)

## Constraints
- CONSTRAINT fk_internacao_atendimento FOREIGN KEY (id_atendimento) REFERENCES atendimento (id_atendimento)

## Relacionamentos e Cardinalidade
- internacao.id_ffa → ffa (id_ffa): N:1 (várias internações podem referenciar o mesmo FFA)
- internacao.id_leito → hospital_leitos (id_leito): N:1 (várias internações podem usar o mesmo leito)
- internacao.id_atendimento → atendimento (id_atendimento): N:1 (várias internações podem referenciar o mesmo atendimento)

## Dependências
- Tabelas que dependem desta: interconsulta, intercorrencia, internacao_historico, internacao_movimentacao, internacao_medicacao_administracao
- Esta tabela depende de: ffa, atendimento, hospital_leitos

## Fluxo de utilização dentro do sistema
1. Paciente é internado via FFA (id_ffa)
2. Leito é atribuído (id_leito) e tipo definido (OBSERVACAO/INTERNACAO)
3. Médico responsável é vinculado
4. Status inicia como 'ATIVA'
5. Precaução define isolamento necessário (PADRAO, CONTATO, GOTICULAS, AEROSSOIS)
6. Na alta: status muda para 'ENCERRADA', motivo_alta preenchido
7. Se transferido: status muda para 'TRANSFERIDA'
8. Em óbito: status muda para 'OBITO'
9. Tabelas vinculadas registram: histórico, movimentações, medicamentos, intercorrências
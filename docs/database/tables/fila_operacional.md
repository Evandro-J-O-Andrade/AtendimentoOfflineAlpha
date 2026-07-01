# fila_operacional

Objetivo: Gerenciar as filas de atendimento operacional do sistema.

Descrição: Tabela central que controla as filas de atendimento operacional como triagem, consulta médica, medicação, exames, procedimentos e observação. Cada registro representa uma senha/paciente em uma determinada fila com status de fluxo, prioridade de Manchester e controle de tempos.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_fila | bigint | NOT NULL | - | Identificador único da fila operacional, chave primária auto incrementada |
| id_ffa | bigint | NOT NULL | - | Referência ao episódio assistencial FFA ao qual a fila está associada |
| tipo | enum('TRIAGEM','MEDICO','MEDICACAO','EXAME','RX','ECG','PROCEDIMENTO','OBSERVACAO') | NOT NULL | - | Tipo de fila: triagem, médico, medicação, exame, RX, ECG, procedimento ou observação |
| substatus | enum('AGUARDANDO','EM_EXECUCAO','REAVALIAR','FINALIZADO','CANCELADO','NAO_COMPARECEU','ENCAMINHADO','RETORNO','EM_OBSERVACAO','CRITICO') | NOT NULL | 'AGUARDANDO' | Substatus atual da fila no fluxo de atendimento |
| prioridade | enum('VERMELHO','LARANJA','AMARELO','VERDE','AZUL') | DEFAULT | 'AZUL' | Prioridade de Manchester: vermelho (máxima), laranja, amarelo, verde, azul (mínima) |
| data_entrada | datetime | NOT NULL | CURRENT_TIMESTAMP | Data e hora de entrada na fila (chegada) |
| entrada_original_em | datetime | DEFAULT NULL | - | Data e hora original de entrada (para histórico de reentradas) |
| nao_compareceu_em | datetime | DEFAULT NULL | - | Data e hora quando o paciente foi marcado como não compareceu |
| retorno_permitido_ate | datetime | DEFAULT NULL | - | Data e hora limite para retorno do paciente |
| retorno_utilizado | tinyint(1) | NOT NULL | '0' | Indicador se o direito de retorno já foi utilizado (0=não, 1=sim) |
| retorno_em | datetime | DEFAULT NULL | - | Data e hora quando o paciente retornou |
| data_inicio | datetime | DEFAULT NULL | - | Data e hora de início do atendimento/exame |
| reavaliar_em | datetime | DEFAULT NULL | - | Data e hora programada para reavaliação |
| data_fim | datetime | DEFAULT NULL | - | Data e hora de término do atendimento/exame |
| id_responsavel | bigint | DEFAULT NULL | - | Referência ao usuário que está atendendo/executando |
| observacao | text | DEFAULT NULL | - | Notas ou observações específicas sobre a fila |
| id_local | bigint | DEFAULT NULL | - | Referência ao local de atendimento |
| id_local_operacional | bigint | DEFAULT NULL | - | Referência ao local operacional específico |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id_fila
- Únicas: -
- Estrangeiras: -

## Índices
- id_responsavel (id_responsavel)
- id_local (id_local)
- idx_ffa_tipo_substatus (id_ffa, tipo, substatus)
- idx_tipo_prioridade (tipo, prioridade, substatus)
- idx_filaop_ordem (tipo, substatus, prioridade, data_entrada, id_local_operacional)
- idx_reavaliar_em (tipo, substatus, reavaluar_em)

## Constraints
- -

## Relacionamentos e Cardinalidade
- fila_operacional.id_ffa → ffa (id_ffa): N:1 (várias filas podem referenciar o mesmo FFA)
- fila_operacional.id_responsavel → usuario (id_usuario): N:1 (várias filas podem ter o mesmo responsável)
- fila_operacional.id_local → local (id_local): N:1 (várias filas podem ocorrer no mesmo local)
- fila_operacional.id_local_operacional → local_operacional (id_local_operacional): N:1 (várias filas podem referenciar o mesmo local operacional)

## Dependências
- Tabelas que dependem desta: fila_operacional_evento, ffa_sinais_vitais
- Esta tabela depende de: ffa, usuario, local, local_operacional

## Fluxo de utilização dentro do sistema
1. Paciente com FFA entra em uma fila (TRIAGEM, MEDICO, etc)
2. Registro criado com data_entrada automática e prioridade de Manchester
3. Status inicial é "AGUARDANDO" até início do atendimento
4. Quando atendimento começa: data_inicio preenchida, substatus muda para "EM_EXECUCAO"
5. Após finalização: data_fim preenchida, substatus muda para "FINALIZADO"
6. Caso não apareça: nao_compareceu_em marcado, substatus "NAO_COMPARECEU"
7. Para reavaliações: reavaliar_em programado
8. Para retornos: retorno_permitido_ate definido e retorno_em preenchido quando ocorre
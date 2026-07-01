# ffa_procedimento

Objetivo: Gerenciar procedimentos paralelos solicitados durante um episódio assistencial FFA.

Descrição: Tabela que registra procedimentos solicitados (exames, medicações, observações) para pacientes em atendimento FFA. Controla o ciclo de vida do procedimento desde a solicitação até a conclusão ou status crítico, integrando o workflow entre os diferentes tipos de atendimentos.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_procedimento | bigint | NOT NULL | - | Identificador único do procedimento, chave primária auto incrementada |
| id_ffa | bigint | NOT NULL | - | Referência ao episódio assistencial FFA ao qual o procedimento pertence |
| tipo | enum('RX','ECG','LABORATORIO','MEDICACAO','OBSERVACAO') | NOT NULL | - | Tipo de procedimento: RX (raio-x), ECG, laboratório, medicação ou observação |
| status | enum('SOLICITADO','EM_FILA','EM_EXECUCAO','CONCLUIDO','CRITICO') | NOT NULL | 'SOLICITADO' | Estado atual do procedimento no fluxo |
| prioridade | enum('NORMAL','EMERGENCIA') | DEFAULT | 'NORMAL' | Nível de prioridade do procedimento (normal ou emergência) |
| id_usuario_solicitante | bigint | DEFAULT NULL | - | Referência ao usuário que solicitou o procedimento |
| id_usuario_execucao | bigint | DEFAULT NULL | - | Referência ao usuário que executou o procedimento |
| criado_em | datetime | DEFAULT | CURRENT_TIMESTAMP | Data e hora de criação da solicitação |
| iniciado_em | datetime | DEFAULT NULL | - | Data e hora quando o procedimento foi iniciado |
| finalizado_em | datetime | DEFAULT NULL | - | Data e hora quando o procedimento foi finalizado |
| observacao | text | DEFAULT NULL | - | Observações ou notas sobre o procedimento |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id_procedimento
- Únicas: -
- Estrangeiras: -

## Índices
- idx_ffa (id_ffa)
- idx_status (status)

## Constraints
- -

## Relacionamentos e Cardinalidade
- ffa_procedimento.id_ffa → ffa (id_ffa): N:1 (vários procedimentos podem pertencer ao mesmo FFA)
- ffa_procedimento.id_usuario_solicitante → usuario (id_usuario): N:1 (vários procedimentos podem ser solicitados pelo mesmo usuário)
- ffa_procedimento.id_usuario_execucao → usuario (id_usuario): N:1 (vários procedimentos podem ser executados pelo mesmo usuário)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: ffa, usuario

## Fluxo de utilização dentro do sistema
1. Durante o atendimento FFA, procedimento é solicitado (tipo: RX, ECG, LABORATORIO, MEDICACAO, OBSERVACAO)
2. Registro criado com status 'SOLICITADO' e prioridade normal por padrão
3. Usuário que solicitou armazenado em id_usuario_solicitante
4. Quando entra na fila: status muda para 'EM_FILA'
5. Quando início da execução: id_usuario_execucao preenchido, iniciado_em timestampado
6. Finalização: status muda para 'CONCLUIDO', finalizado_em timestampado
7. Se crítico: status alterado para 'CRITICO'
# ffa_sinais_vitais

Objetivo: Registrar sinais vitais dos pacientes durante atendimentos FFA.

Descrição: Tabela que armazena os sinais vitais coletados do paciente em um episódio assistencial FFA, incluindo pressão arterial, frequência cardíaca, temperatura, saturação, glicemia e escala de dor. Utilizada para monitoramento e avaliação da condição clínica do paciente.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_sinais | bigint | NOT NULL | - | Identificador único da coleta de sinais vitais, chave primária auto incrementada |
| id_ffa | bigint | NOT NULL | - | Referência ao episódio assistencial FFA ao qual os sinais vitais estão associados |
| id_fila | bigint | DEFAULT NULL | - | Referência opcional à fila operacional de triagem |
| id_sessao_usuario | bigint | NOT NULL | - | Referência à sessão do usuário que realizou a coleta |
| id_local_operacional | bigint | DEFAULT NULL | - | Referência ao local operacional onde os sinais foram coletados |
| id_usuario | bigint | NOT NULL | - | Referência ao usuário profissional que coletou os sinais vitais |
| data_coleta | datetime | NOT NULL | CURRENT_TIMESTAMP | Data e hora em que os sinais vitais foram coletados |
| pressao_sistolica | int | DEFAULT NULL | - | Pressão arterial sistólica em mmHg |
| pressao_diastolica | int | DEFAULT NULL | - | Pressão arterial diastólica em mmHg |
| freq_cardiaca | int | DEFAULT NULL | - | Frequência cardíaca em batimentos por minuto (bpm) |
| freq_respiratoria | int | DEFAULT NULL | - | Frequência respiratória em respirações por minuto |
| temperatura | decimal(4,1) | DEFAULT NULL | - | Temperatura corporal em graus Celsius |
| saturacao | int | DEFAULT NULL | - | Saturação de oxigênio no sangue em percentual |
| glicemia | int | DEFAULT NULL | - | Nível de glicemia em mg/dL |
| escala_dor | tinyint | DEFAULT NULL | - | Escala de avaliação da dor (geralmente 0-10) |
| observacao | text | DEFAULT NULL | - | Observações complementares sobre a coleta dos sinais vitais |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data e hora de criação do registro |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id_sinais
- Únicas: -
- Estrangeiras: fk_ffa_sinais_local (id_local_operacional → local_operacional.id_local_operacional); fk_ffa_sinais_usuario (id_usuario → usuario.id_usuario)

## Índices
- idx_ffa_sinais_ffa (id_ffa, data_coleta)
- idx_ffa_sinais_sessao (id_sessao_usuario)
- idx_ffa_sinais_usuario (id_usuario, data_coleta)
- fk_ffa_sinais_local (id_local_operacional)

## Constraints
- CONSTRAINT fk_ffa_sinais_local FOREIGN KEY (id_local_operacional) REFERENCES local_operacional (id_local_operacional)
- CONSTRAINT fk_ffa_sinais_usuario FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)

## Relacionamentos e Cardinalidade
- ffa_sinais_vitais.id_ffa → ffa (id_ffa): N:1 (vários registros de sinais podem referenciar o mesmo FFA)
- ffa_sinais_vitais.id_fila → fila_operacional (id_fila): N:1 (vários registros de sinais podem referenciar a mesma fila)
- ffa_sinais_vitais.id_usuario → usuario (id_usuario): N:1 (vários registros de sinais podem ser feitos pelo mesmo usuário)
- ffa_sinais_vitais.id_local_operacional → local_operacional (id_local_operacional): N:1 (vários registros de sinais podem referenciar o mesmo local)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: ffa, fila_operacional, usuario, local_operacional

## Fluxo de utilização dentro do sistema
1. Paciente em atendimento FFA tem sinais vitais coletados
2. Profissional (enfermeiro/técnico) registra os valores: pressão, frequência cardíaca, temperatura, saturação, glicemia, escala de dor
3. Registro é associado ao FFA e ao usuário que coletou
4. Campo id_fila opcional vincula a uma fila de triagem específica
5. Histórico é mantido para rastreamento da evolução do paciente
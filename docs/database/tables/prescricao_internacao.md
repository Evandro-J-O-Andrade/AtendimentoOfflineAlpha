# prescricao_internacao

Objetivo: Gerenciar prescrições médicas específicas para internações hospitalares, incluindo medicamentos, cuidados, dietas e outros tipos de prescrições.

Descrição: Tabela dedicada ao gerenciamento de prescrições realizadas durante internações hospitalares. Suporta diferentes tipos de prescrições (medicamento, cuidado, dieta, outros) e permite descrição detalhada, controle de status e vínculo com o médico responsável pela prescrição.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_prescricao | bigint | NOT NULL | - | Chave primária da tabela, identificador único da prescrição de internação |
| id_internacao | bigint | NOT NULL | - | Referência ao id da internação hospitalar à qual a prescrição está vinculada |
| tipo | enum('MEDICAMENTO','CUIDADO','DIETA','OUTROS') | NOT NULL | - | Tipo de prescrição: MEDICAMENTO para medicamentos, CUIDADO para cuidados de enfermagem, DIETA para dietas, OUTROS para prescrições diversas |
| descricao | text | NOT NULL | - | Descrição detalhada do item prescrito |
| id_medico | bigint | NOT NULL | - | Referência ao id do médico que criou a prescrição |
| ativa | tinyint(1) | - | '1' | Flag indicando se a prescrição está ativa (1) ou inativa (0) |
| data_hora | datetime | - | CURRENT_TIMESTAMP | Data e hora de criação da prescrição |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde a prescrição foi criada |

## Chaves
- Primária: id_prescricao
- Únicas: -
- Estrangeiras: prescricao_internacao_ibfk_1 (id_internacao → internacao.id_internacao) - vincula a prescrição à internação do paciente; prescricao_internacao_ibfk_2 (id_medico → medico.id_usuario) - identifica o médico responsável pela prescrição

## Índices
- PRIMARY KEY (id_prescricao)
- KEY id_internacao (id_internacao)
- KEY id_medico (id_medico)

## Constraints
- CONSTRAINT prescricao_internacao_ibfk_1 FOREIGN KEY (id_internacao) REFERENCES internacao (id_internacao)
- CONSTRAINT prescricao_internacao_ibfk_2 FOREIGN KEY (id_medico) REFERENCES medico (id_usuario)

## Relacionamentos e Cardinalidade
- N:1 com internacao (uma internação pode ter várias prescrições)
- N:1 com medico (um médico pode criar várias prescrições)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: internacao, medico

## Fluxo de utilização dentro do sistema
- Criada durante a internação do paciente
- Tipos diferentes de prescrições são registrados conforme necessidade clínica
- Permite controle de status para gestão do tratamento
- Usada principalmente em contextos de hospitalização
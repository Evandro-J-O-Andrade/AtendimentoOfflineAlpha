# prescricao_continua

Objetivo: Gerenciar prescrições médicas contínuas vinculadas a atendimentos, permitindo diferentes tipos de prescrições como medicamentos e cuidados gerais.

Descrição: Tabela central para gerenciamento de prescrições médicas de caráter contínuo, ou seja, prescrições que se estendem por um período maior e são gerenciadas ao longo do atendimento. Suporta diferentes tipos de prescrições (medicamentos ou cuidados gerais) e permite rastrear o médico responsável, data/hora da prescrição, e status de ativação.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_prescricao | bigint | NOT NULL | - | Chave primária da tabela, identificador único da prescrição contínua |
| id_atendimento | bigint unsigned | NOT NULL | - | Referência ao id do atendimento ao qual a prescrição está vinculada |
| tipo | enum('MEDICAMENTOS','CUIDADOS_GERAIS') | NOT NULL | - | Tipo de prescrição: MEDICAMENTOS para prescrições de medicamentos ou CUIDADOS_GERAIS para outros cuidados |
| id_medico | bigint | NOT NULL | - | Referência ao id do médico que criou a prescrição |
| data_hora | datetime | - | CURRENT_TIMESTAMP | Data e hora de criação da prescrição |
| ativa | tinyint(1) | - | '1' | Flag indicando se a prescrição está ativa (1) ou inativa (0) |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde a prescrição foi criada |

## Chaves
- Primária: id_prescricao
- Únicas: -
- Estrangeiras: prescricao_continua_ibfk_2 (id_medico → medico.id_usuario) - vincula a prescrição ao médico responsável

## Índices
- PRIMARY KEY (id_prescricao)
- KEY id_atendimento (id_atendimento)
- KEY id_medico (id_medico)

## Constraints
- CONSTRAINT prescricao_continua_ibfk_2 FOREIGN KEY (id_medico) REFERENCES medico (id_usuario)

## Relacionamentos e Cardinalidade
- N:1 com atendimento (um atendimento pode ter várias prescrições contínuas)
- N:1 com medico (um médico pode criar várias prescrições contínuas)

## Dependências
- Tabelas que dependem desta: prescricao_item
- Esta tabela depende de: atendimento, medico

## Fluxo de utilização dentro do sistema
- Criada quando um médico registra uma prescrição contínua durante um atendimento
- Vinculada ao atendimento do paciente
- Pode ser inativada conforme evolução do tratamento
- Itens individuais são gerenciados na tabela prescricao_item
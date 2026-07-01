# administracao_medicacao

Objetivo: Registrar a administração de medicamentos durante a internação de um paciente, controlando dose, via, horário e observações da administração.

Descrição: Esta tabela controla a administração de medicamentos prescritos durante a internação, vinculando cada administração a uma prescrição específica e ao enfermeiro responsável pela administração, permitindo o registro completo do processo de medicação do paciente.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_admin | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do registro de administração de medicamento |
| id_prescricao | bigint | NOT NULL | - | Chave estrangeira que referencia a prescrição de internação à qual este registro de administração está vinculado |
| id_enfermeiro | bigint | NOT NULL | - | Chave estrangeira que referencia o usuário (enfermeiro) responsável pela administração do medicamento |
| dose | varchar(50) | YES | NULL | Quantidade e unidade da dose administrada (ex: "500mg", "1 comprimido") |
| via | varchar(50) | YES | NULL | Via de administração do medicamento (oral, intravenosa, subcutânea, etc.) |
| data_hora | datetime | YES | CURRENT_TIMESTAMP | Timestamp automático da data/hora em que a medicação foi administrada |
| observacao | text | YES | NULL | Campo de texto livre para observações sobre a administração, efeitos colaterais ou situações específicas |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o registro pertence |

## Chaves
- Primária: id_admin
- Únicas: Nenhuma
- Estrangeiras: administracao_medicacao_ibfk_1 - id_prescricao → prescricao_internacao(id_prescricao) - Vincula a administração a uma prescrição de internação; administracao_medicacao_ibfk_2 - id_enfermeiro → usuario(id_usuario) - Vincula o registro ao enfermeiro que realizou a administração

## Índices
- id_prescricao (KEY)
- id_enfermeiro (KEY)

## Constraints
- administracao_medicacao_ibfk_1 - FOREIGN KEY - Restringe id_prescricao à tabela prescricao_internacao(id_prescricao)
- administracao_medicacao_ibfk_2 - FOREIGN KEY - Restringe id_enfermeiro à tabela usuario(id_usuario)

## Relacionamentos e Cardinalidade
- N:1 com prescricao_internacao - Cada administração está vinculada a uma prescrição específica
- N:1 com usuario - Cada registro é criado por um único enfermeiro (usuário)

## Dependências
- Tabelas que dependem desta: administracao_medicacao_ordem (via id_item - indireto), Nenhuma outra tabela possui FK apontando para administracao_medicacao
- Tabelas das quais esta depende: prescricao_internacao, usuario

## Fluxo de utilização dentro do sistema
- Registro de administração de medicamentos prescritos durante internação
- Controle de dose e via de administração para garantia de segurança do paciente
- Vinculação ao profissional que realizou a administração para responsabilidade
- Timestamp automático para auditoria de quando a medicação foi ministrada
- Registro de observações para alertas clínicos ou observações relevantes
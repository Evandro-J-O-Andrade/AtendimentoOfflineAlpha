# prescricao_checagem

Objetivo: Registrar a checagem/administração de medicamentos prescritos.
Descrição: Tabela que registra cada checagem de administração de medicamentos prescritos, identificando o enfermeiro responsável, status da administração e observações.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_checagem | bigint | NOT NULL | - | Identificador único da checagem (chave primária, auto incremento) |
| id_prescricao_item | bigint | NOT NULL | - | ID do item da prescrição que foi checado/administrado |
| id_usuario_enfermeiro | bigint | NOT NULL | - | ID do usuário/enfermeiro que realizou a checagem |
| data_hora_checagem | datetime | YES | CURRENT_TIMESTAMP | Data/hora em que a checagem foi realizada |
| status | enum('ADMINISTRADO','RECUSADO','PACIENTE_AUSENTE','JEJUM') | YES | 'ADMINISTRADO' | Status da checagem: administrado, recusado, paciente ausente ou em jejum |
| observacao | text | YES | NULL | Observações sobre a checagem ou oporcionalidades |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual a checagem pertence |

## Chaves
- Primária: id_checagem
- Únicas: (nenhuma)
- Estrangeiras: 
  - fk_checagem_item: id_prescricao_item → prescricao_item (id_item)
  - fk_checagem_usuario: id_usuario_enfermeiro → usuario (id_usuario)

## Índices
- PRIMARY KEY (id_checagem)
- KEY fk_checagem_item (id_prescricao_item)
- KEY fk_checagem_usuario (id_usuario_enfermeiro)

## Constraints
- PRIMARY KEY: id_checagem
- FOREIGN KEY: fk_checagem_item
- FOREIGN KEY: fk_checagem_usuario

## Relacionamentos e Cardinalidade
- N:1 com prescricao_item: Muitas checagens pertencem a um item de prescrição
- N:1 com usuario: Muitas checagens são realizadas por um enfermeiro/usuário

## Dependências
- Esta tabela depende de: prescricao_item, usuario, saas_entidade
- Não há tabelas que dependem desta tabela

## Fluxo de utilização dentro do sistema
Utilizada para registrar a administração de medicamentos prescritos. Quando o enfermeiro administra um medicamento, cria-se um registro aqui com status ADMINISTRADO. Se o paciente recusar, o status é RECUSADO. Permite auditoria completa de medicamentos administrados vs. prescritos. Integra-se com o módulo de ordem assistencial para controle de estoque.
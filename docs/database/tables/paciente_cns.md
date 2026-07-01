# paciente_cns

Objetivo: Armazenar os números do Cartão Nacional de Saúde (CNS) dos pacientes.
Descrição: Tabela que mantém registros do CNS (Cartão Nacional de Saúde) dos pacientes, com status de validação e origem da informação. Permite associar múltiplos CNS a um paciente e controlar sua validade.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_paciente_cns | bigint | NOT NULL | - | Identificador único do registro CNS (chave primária, auto incremento) |
| id_paciente | bigint | NOT NULL | - | ID do paciente ao qual o CNS está vinculado |
| cns | varchar(20) | NOT NULL | - | Número do Cartão Nacional de Saúde |
| status | enum('ATIVO','INATIVO') | NOT NULL | 'ATIVO' | Status do CNS: ativo ou inativo |
| validado | tinyint(1) | NOT NULL | '0' | Flag indicando se o CNS foi validado |
| origem | enum('MANUAL','IMPORTADO','SUS','INTEGRACAO') | NOT NULL | 'MANUAL' | Origem do registro CNS: manual, importado, SUS ou integração |
| data_validacao | datetime | YES | NULL | Data/hora da validação do CNS |
| observacao | varchar(255) | YES | NULL | Observações sobre o registro CNS |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data/hora de criação do registro |
| atualizado_em | datetime | YES | NULL | Data/hora da última atualização |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual o registro pertence |

## Chaves
- Primária: id_paciente_cns
- Únicas: uk_paciente_cns_ativo (id_paciente, cns, status)
- Estrangeiras: (nenhuma foreign key explícita)

## Índices
- PRIMARY KEY (id_paciente_cns)
- UNIQUE KEY uk_paciente_cns_ativo (id_paciente, cns, status)
- KEY ix_paciente_cns_paciente (id_paciente)
- KEY ix_paciente_cns_cns (cns)

## Constraints
- PRIMARY KEY: id_paciente_cns
- UNIQUE: uk_paciente_cns_ativo

## Relacionamentos e Cardinalidade
- N:1 com paciente: Muitos registros de CNS pertencem a um paciente
- 1:N com paciente_cns_evento: Um registro de CNS pode ter muitos eventos

## Dependências
- Esta tabela depende de: saas_entidade
- Tabelas que dependem desta: paciente_cns_evento

## Fluxo de utilização dentro do sistema
Utilizada para armazenar e gerenciar os números do CNS dos pacientes. Ao cadastrar um paciente, pode-se associar um ou mais CNS. O campo status permite manter histórico de CNS antigos (INATIVO) e o campo validado indica se o número foi confirmado. Eventos são registrados em paciente_cns_evento para auditoria de mudanças.
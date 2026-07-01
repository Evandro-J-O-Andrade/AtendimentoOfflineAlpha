# paciente_canonico

Objetivo: Manter um registro canônico (mestre) de pacientes para reconciliação e integração.
Descrição: Tabela que armazena versão canônica do cadastro do paciente, utilizada como referência master para integrações e reconciliação de identidades. Contém estado do paciente para controle de duplicatas e status de conciliação.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_paciente | bigint | NOT NULL | - | Identificador único do paciente canônico (chave primária, auto incremento) |
| uuid_paciente | char(36) | NOT NULL | - | UUID único do paciente |
| hash_identidade | char(64) | NOT NULL | - | Hash da identidade para detecção de duplicatas |
| nome | varchar(200) | NOT NULL | - | Nome completo do paciente |
| data_nascimento | date | YES | NULL | Data de nascimento do paciente |
| sexo | char(1) | YES | NULL | Sexo do paciente (M/F) |
| documento_principal | varchar(50) | YES | NULL | Documento principal do paciente |
| metadata_identidade | json | YES | NULL | Metadados da identidade em formato JSON |
| estado_paciente | enum('ATIVO','INATIVO','BLOQUEADO','DUPLICADO_PENDENTE_RECONCILIACAO') | YES | 'ATIVO' | Estado atual: ativo, inativo, bloqueado ou duplicado aguardando reconciliação |
| criado_em | datetime(6) | YES | CURRENT_TIMESTAMP(6) | Data/hora de criação do registro canônico |
| atualizado_em | datetime(6) | YES | NULL ON UPDATE CURRENT_TIMESTAMP(6) | Data/hora da última atualização |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual o paciente pertence |

## Chaves
- Primária: id_paciente
- Únicas: uk_paciente_uuid (uuid_paciente), uk_paciente_hash (hash_identidade)
- Estrangeiras: (nenhuma foreign key)

## Índices
- PRIMARY KEY (id_paciente)
- UNIQUE KEY uk_paciente_uuid (uuid_paciente)
- UNIQUE KEY uk_paciente_hash (hash_identidade)
- KEY idx_paciente_nome (nome)

## Constraints
- PRIMARY KEY: id_paciente
- UNIQUE: uk_paciente_uuid
- UNIQUE: uk_paciente_hash

## Relacionamentos e Cardinalidade
- N:1 com saas_entidade: Muitos pacientes canônicos pertencem a uma entidade

## Dependências
- Esta tabela depende de: saas_entidade
- Não há tabelas que dependem desta tabela

## Fluxo de utilização dentro do sistema
Utilizada como fonte de verdade para identificação de pacientes em integrações entre sistemas. Quando um paciente é importado de outro sistema, verifica-se o hash_identidade para detectar duplicatas. Pacientes marcados como DUPLICADO_PENDENTE_RECONCILIACAO requerem intervenção manual para consolidar registros. Permite manter um registro mestre único de cada paciente.
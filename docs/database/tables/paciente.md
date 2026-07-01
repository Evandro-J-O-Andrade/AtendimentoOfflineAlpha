# paciente

Objetivo: Armazenar os dados principais dos pacientes do sistema.
Descrição: Tabela central de gestão de pacientes, armazenando informações identificadas como UUID, hash de identidade, dados pessoais e vínculo com a tabela de pessoas. É o cadastro principal de pacientes no sistema de atendimento.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id | bigint | NOT NULL | - | Identificador numérico único do paciente (chave primária, auto incremento) |
| uuid_paciente | char(36) | NOT NULL | - | UUID único do paciente no formato padrão, utilizado para identificação global |
| hash_identidade | char(64) | NOT NULL | - | Hash SHA256 da identidade do paciente para detecção de duplicatas |
| id_pessoa | bigint | NOT NULL | - | ID da pessoa física vinculada ao paciente (FK para tabela pessoa) |
| prontuario | varchar(50) | YES | NULL | Número do prontuário do paciente no sistema |
| data_cadastro | datetime | YES | CURRENT_TIMESTAMP | Data/hora de cadastro do paciente no sistema |
| sexo | char(1) | YES | NULL | Sexo do paciente: M (masculino), F (feminino), ou outro |
| data_nascimento | date | YES | NULL | Data de nascimento do paciente |
| nome | varchar(200) | YES | NULL | Nome completo do paciente |
| documento_principal | varchar(50) | YES | NULL | Documento principal do paciente (ex: CPF) |
| metadata_identidade | json | YES | NULL | Metadados adicionais de identidade em formato JSON |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual o paciente pertence |

## Chaves
- Primária: id
- Únicas: uk_paciente_uuid (uuid_paciente), uk_paciente_hash (hash_identidade), prontuario (prontuario)
- Estrangeiras: 
  - fk_paciente_entidade: id_entidade → saas_entidade (id_entidade)
  - paciente_ibfk_1: id_pessoa → pessoa (id_pessoa)

## Índices
- PRIMARY KEY (id)
- UNIQUE KEY uk_paciente_uuid (uuid_paciente)
- UNIQUE KEY uk_paciente_hash (hash_identidade)
- UNIQUE KEY prontuario (prontuario)
- KEY id_pessoa (id_pessoa)
- KEY idx_paciente_nome (nome)
- KEY idx_paciente_entidade (id_entidade)
- KEY idx_paciente_prontuario (id_entidade, prontuario)

## Constraints
- PRIMARY KEY: id
- UNIQUE: uk_paciente_uuid
- UNIQUE: uk_paciente_hash
- UNIQUE: prontuario
- FOREIGN KEY: fk_paciente_entidade
- FOREIGN KEY: paciente_ibfk_1

## Relacionamentos e Cardinalidade
- 1:1 com pessoa: Uma pessoa pode ser paciente; um paciente está vinculado a uma pessoa
- 1:N com atendimento: Um paciente pode ter muitos atendimentos
- 1:N com paciente_alertas: Um paciente pode ter muitos alertas cadastrados
- 1:N com paciente_cns: Um paciente pode ter muitos registros de CNS
- 1:N com paciente_cns_evento: Um paciente pode ter muitos eventos de CNS
- 1:N com saas_entidade: Muitos pacientes pertencem a uma entidade

## Dependências
- Esta tabela depende de: pessoa, saas_entidade
- Tabelas que dependem desta: atendimento, paciente_alertas, paciente_cns, paciente_cns_evento, agendamento

## Fluxo de utilização dentro do sistema
Utilizada como cadastro central de pacientes. Ao chegar um novo paciente, é verificado se já existe pelo hash_identidade ou uuid_paciente. O prontuário é atribuído automaticamente. A partir do paciente, são criados atendimentos (FFA), ordens assistenciais, prescrições e outros registros clínicos. Permite identificar o paciente em toda a jornada do atendimento.
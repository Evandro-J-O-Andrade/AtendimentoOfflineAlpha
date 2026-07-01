# funcionario_conselho_profissional

Objetivo: Gerenciar registros de conselhos profissionais dos funcionários.

Descrição: Tabela que armazena os registros dos conselhos profissionais (CRM, COREN, etc) dos funcionários, incluindo número de registro, UF e situação (ativo, suspenso, cancelado). Utilizada para validação de qualificação profissional.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_funcionario_conselho | bigint | NOT NULL | - | Identificador único do registro do conselho, chave primária auto incrementada |
| id_funcionario | bigint | NOT NULL | - | Referência ao funcionário ao qual o conselho está vinculado |
| conselho | varchar(50) | NOT NULL | - | Nome do conselho profissional (ex: CRM, COREN, CRF) |
| numero_registro | varchar(50) | NOT NULL | - | Número do registro no conselho profissional |
| uf | char(2) | NOT NULL | - | Unidade federativa do conselho (ex: SP, RJ, MG) |
| situacao | enum('ATIVO','SUSPENSO','CANCELADO') | DEFAULT | 'ATIVO' | Situação do registro no conselho: ativo, suspenso ou cancelado |
| criado_em | datetime(6) | DEFAULT | CURRENT_TIMESTAMP(6) | Data e hora de criação do registro |
| id_entidade | bigint unsigned | DEFAULT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id_funcionario_conselho
- Únicas: -
| Estrangeiras: fk_fcp_funcionario (id_funcionario → funcionario.id_funcionario)

## Índices
- idx_fcp_funcionario (id_funcionario)

## Constraints
- CONSTRAINT fk_fcp_funcionario FOREIGN KEY (id_funcionario) REFERENCES funcionario (id_funcionario)

## Relacionamentos e Cardinalidade
- funcionario_conselho_profissional.id_funcionario → funcionario (id_funcionario): N:1 (vários registros de conselho podem referenciar o mesmo funcionário)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: funcionario

## Fluxo de utilização dentro do sistema
1. Funcionário com registro profissional tem o conselho cadastrado
2. conselho armazena o nome (CRM para médicos, COREN para enfermeiros)
3. numero_registro guarda o número do documento profissional
4. uf indica a unidade federativa do registro
5. situacao indica se o registro está ativo, suspenso ou cancelado
6. Permite validação de qualificação antes de permitir atuações
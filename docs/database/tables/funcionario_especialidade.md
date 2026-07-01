# funcionario_especialidade

Objetivo: Vincular especialidades aos funcionários.

Descrição: Tabela que associa especialidades médicas aos funcionários, indicando qual área cada profissional atua. Permite marcar uma especialidade como principal para cada funcionário.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_funcionario_especialidade | bigint | NOT NULL | - | Identificador único da associação, chave primária auto incrementada |
| id_funcionario | bigint | NOT NULL | - | Referência ao funcionário ao qual a especialidade está vinculada |
| especialidade | varchar(150) | NOT NULL | - | Nome da especialidade médica (ex: Clínica Geral, Pediatria, Cardiologia) |
| principal | tinyint(1) | DEFAULT | '0' | Indicador se é a especialidade principal do funcionário (0=não, 1=sim) |
| criado_em | datetime(6) | DEFAULT | CURRENT_TIMESTAMP(6) | Data e hora de criação do registro |
| id_entidade | bigint unsigned | DEFAULT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id_funcionario_especialidade
- Únicas: -
- Estrangeiras: fk_fe_funcionario (id_funcionario → funcionario.id_funcionario)

## Índices
- idx_fe_funcionario (id_funcionario)

## Constraints
- CONSTRAINT fk_fe_funcionario FOREIGN KEY (id_funcionario) REFERENCES funcionario (id_funcionario)

## Relacionamentos e Cardinalidade
- funcionario_especialidade.id_funcionario → funcionario (id_funcionario): N:1 (várias especialidades podem pertencer ao mesmo funcionário)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: funcionario

## Fluxo de utilização dentro do sistema
1. Médico/funcionário possui uma ou mais especialidades
2. cada especialidade é registrada como um registro separado
3. principal indica se é a especialidade principal do profissional
4. Permite busca por especialidades disponíveis
5. Usado em agendamento e atribuição de consultas
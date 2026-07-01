# atendimento_profissional

Objetivo: Registrar a alocação de profissionais a atendimentos, controlando papel, status e timestamp de criação.

Descrição: Esta tabela controla a relação entre profissionais e atendimentos, permitindo o registro de quais usuários estão envolvidos no atendimento, seu papel (médico, enfermeiro, técnico, outros) e se a alocação ainda está ativa.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do registro de profissional no atendimento |
| id_atendimento | bigint unsigned | NOT NULL | - | Chave estrangeira que referencia o atendimento ao qual o profissional está alocado |
| id_usuario | bigint | NOT NULL | - | Identificador do usuário (profissional) alocado ao atendimento |
| papel | enum('MEDICO','ENFERMEIRO','TECNICO','OUTROS') | YES | NULL | Papel do profissional no atendimento: médico, enfermeiro, técnico ou outros |
| ativo | tinyint | YES | '1' | Flag que indica se a alocação do profissional está ativa (1) ou inativa (0) |
| criado_em | datetime(6) | NOT NULL | - | Timestamp da data/hora de criação do registro (NOT NULL, sem default automático) |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o registro pertence |

## Chaves
- Primária: id
- Únicas: Nenhuma
- Estrangeiras: fk_atendimento_profissional_atendimento - id_atendimento → atendimento(id_atendimento) - Vincula o registro ao atendimento; fk_atendimento_profissional_entidade - id_entidade → saas_entidade(id_entidade) - Vincula o registro à entidade |

## Índices
- fk_atendimento_profissional_atendimento (KEY) - Índice para busca por atendimento
- idx_aprof_ent (KEY) - Índice para busca por entidade

## Constraints
- fk_atendimento_profissional_atendimento - FOREIGN KEY - Restringe id_atendimento à tabela atendimento(id_atendimento) com CASCADE
- fk_atendimento_profissional_entidade - FOREIGN KEY - Restringe id_entidade à tabela saas_entidade(id_entidade)

## Relacionamentos e Cardinalidade
- N:1 com atendimento - Cada registro está associado a um atendimento (com CASCADE)
- N:1 com saas_entidade - Cada registro pertence a uma entidade SaaS
- N:1 com usuario - Cada registro está associado a um usuário profissional

## Dependências
- Tabelas que dependem desta: Nenhuma (não há FK apontando para atendimento_profissional)
- Tabelas das quais esta depende: atendimento, saas_entidade, usuario

## Fluxo de utilização dentro do sistema
- Alocação de profissionais a atendimentos médicos
- Controle de papel/função do profissional no atendimento
- Status ativo para controle de profissionais que ainda estão envolvidos
- Timestamp de criação para auditoria de quando o profissional foi alocado
- Cascade delete remove registros quando atendimento é excluído
- Múltiplos profissionais podem estar associados ao mesmo atendimento
# atendimento_observacao

Objetivo: Registrar o estado de observação do paciente durante atendimentos, controlando período, tipo de observação, status e leito associado.

Descrição: Esta tabela controla o registro de observação do paciente durante atendimentos, permitindo o gerenciamento de períodos de observação (clínica ou internação), status ativo/alta/transferido, e vinculação ao leito onde o paciente está.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_obs | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do registro de observação |
| id_atendimento | bigint unsigned | NOT NULL | - | Chave estrangeira que referencia o atendimento ao qual a observação pertence |
| tipo | enum('OBSERVACAO','INTERNACAO') | NOT NULL | - | Tipo de observação: observação clínica ou internação hospitalar |
| id_leito | int | YES | NULL | Identificador do leito onde o paciente está internado |
| data_inicio | datetime | YES | CURRENT_TIMESTAMP | Timestamp da data/hora de início da observação |
| data_fim | datetime | YES | NULL | Timestamp da data/hora de fim da observação (alta) |
| status | enum('ATIVO','ALTA','TRANSFERIDO') | YES | 'ATIVO' | Status da observação: ativo, alta ou transferido |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o registro pertence |

## Chaves
- Primária: id_obs
- Únicas: uk_atendimento_obs (id_atendimento) - Garante que cada atendimento tenha apenas um registro de observação
- Estrangeiras: atendimento_observacao_ibfk_2 - id_leito → leito(id_leito) - Vincula a observação ao leito; fk_atendimento_observacao_atendimento - id_atendimento → atendimento(id_atendimento) - Vincula a observação ao atendimento; fk_atendimento_observacao_entidade - id_entidade → saas_entidade(id_entidade) - Vincula a observação à entidade |

## Índices
- uk_atendimento_obs (KEY) - Índice único para garantir unicidade por atendimento
- id_leito (KEY) - Índice para busca por leito
- idx_aobs_ent (KEY) - Índice para busca por entidade

## Constraints
- uk_atendimento_obs - UNIQUE - Garante unicidade do id_atendimento
- atendimento_observacao_ibfk_2 - FOREIGN KEY - Restringe id_leito à tabela leito(id_leito)
- fk_atendimento_observacao_atendimento - FOREIGN KEY - Restringe id_atendimento à tabela atendimento(id_atendimento) com CASCADE
- fk_atendimento_observacao_entidade - FOREIGN KEY - Restringe id_entidade à tabela saas_entidade(id_entidade)

## Relacionamentos e Cardinalidade
- 1:1 com atendimento - Cada atendimento tem um registro de observação único
- N:1 com leito - Cada observação pode ter um leito associado (opcional)
- N:1 com saas_entidade - Cada observação pertence a uma entidade SaaS

## Dependências
- Tabelas que dependem desta: Nenhuma (não há FK apontando para atendimento_observacao)
- Tabelas das quais esta depende: atendimento, leito, saas_entidade

## Fluxo de utilização dentro do sistema
- Registro de início de observação clínica ou internação
- Vinculação ao leito para gestão de leitos hospitalares
- Status para acompanhamento: ativo, alta, transferido
- Períodos de início e fim para controle de tempo de observação
- Unicidade garantida por UK para evitar duplicação de observação por atendimento
- Cascade delete remove observação quando atendimento é excluído
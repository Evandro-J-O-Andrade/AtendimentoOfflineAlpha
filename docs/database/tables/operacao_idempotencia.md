# operacao_idempotencia

Objetivo: Garantir a execução única de operações (idempotência) para evitar duplicação de processos no sistema.
Descrição: Tabela responsável por armazenar tokens de idempotência para operações realizadas no sistema, garantindo que a mesma operação não seja executada mais de uma vez mesmo em caso de retries ou chamadas duplicadas. Utilizada para controle de consistência em processos críticos como pagamentos, cadastros e atualizações.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| token | varchar(128) | NOT NULL | - | Token único que identifica a operação idempotente; utilizado como chave primária para garantir unicidade |
| procedimento | varchar(120) | NOT NULL | - | Nome do procedimento ou operação sendo executada de forma idempotente |
| referencia_id | bigint | YES | NULL | ID de referência relacionado à operação (ex: ID do registro afetado) |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data/hora de criação do registro de idempotência |
| resultado | json | YES | NULL | Resultado da operação armazenado em formato JSON para referência futura |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual a operação pertence |

## Chaves
- Primária: token
- Únicas: (nenhuma constraint UNIQUE além da chave primária)
- Estrangeiras: (nenhuma foreign key)

## Índices
- PRIMARY KEY (token)

## Constraints
- PRIMARY KEY: token

## Relacionamentos e Cardinalidade
- Não possui relacionamentos com outras tabelas (é uma tabela independente de controle)

## Dependências
- Esta tabela não depende de outras tabelas
- Não há tabelas que dependem desta tabela

## Fluxo de utilização dentro do sistema
Utilizada ao iniciar operações críticas para verificar se a operação já foi realizada anteriormente. O token é gerado antes da operação e verificado antes de executar qualquer ação que não deve ser duplicada. Comum em integrações, processamentos financeiros e operações que modificam estado do sistema.
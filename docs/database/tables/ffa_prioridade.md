# ffa_prioridade

Objetivo: Registrar e controlar as prioridades de atendimento dos episódios assistenciais FFA.

Descrição: Tabela que armazena as classificações de prioridade atribuídas a episódios FFA, permitindo o controle do nível de urgência e priorização do atendimento. Utilizada no sistema de triagem e classificação de risco.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id | bigint | NOT NULL | - | Identificador único da prioridade, chave primária auto incrementada |
| id_ffa | bigint | NOT NULL | - | Referência ao episódio assistencial FFA ao qual a prioridade está associada |
| codigo_prioridade | varchar(30) | NOT NULL | - | Código que representa o nível de prioridade do atendimento |
| criado_em | datetime | DEFAULT | CURRENT_TIMESTAMP | Data e hora de criação do registro de prioridade |
| ativo | tinyint(1) | DEFAULT | '1' | Indicador se o registro de prioridade está ativo (1=ativo, 0=inativo) |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id
- Únicas: -
- Estrangeiras: -

## Índices
- -

## Constraints
- -

## Relacionamentos e Cardinalidade
- ffa_prioridade.id_ffa → ffa (id_ffa): N:1 (vários registros de prioridade podem referenciar o mesmo FFA)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: ffa

## Fluxo de utilização dentro do sistema
1. Paciente entra no FFA e é avaliado
2. Sistema classifica o paciente com um código de prioridade
3. Registro é criado em ffa_prioridade vinculado ao FFA
4. O campo ativo controla se a prioridade ainda é válida
5. A prioridade é usada para ordenação nas filas de atendimento
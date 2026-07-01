# identificador_global_assistencial

Objetivo: Fornecer identificação global única para entidades assistenciais.

Descrição: Tabela que gera UUIDs únicos para identificar recursos assistenciais (atendimentos, pacientes, processos) de forma global e imutável. Utilizada para integração e rastreamento único no sistema.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_global | bigint | NOT NULL | - | Identificador único auto incrementado, chave primária |
| uuid_assistencial | char(36) | NOT NULL | - | UUID único que identifica a entidade assistencial |
| tipo_entidade | varchar(60) | NOT NULL | - | Tipo da entidade (ex: FFA, ATENDIMENTO, INTERNACAO) |
| hash_imutavel | char(64) | NOT NULL | - | Hash que garante integridade imutável dos dados |
| origem_runtime | varchar(120) | NOT NULL | - | Origem/runtime onde foi criado |
| bloqueado | tinyint(1) | DEFAULT | '0' | Indicador se o identificador está bloqueado (0=não, 1=sim) |
| criado_em | datetime(6) | DEFAULT | CURRENT_TIMESTAMP(6) | Data e hora de criação |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id_global
- Únicas: uk_global_uuid (uuid_assistencial) - garante UUID único |
- Estrangeiras: -

## Índices
- idx_global_tipo (tipo_entidade)

## Constraints
- UNIQUE KEY uk_global_uuid (uuid_assistencial)

## Relacionamentos e Cardinalidade
- identificador_global_assistencial é uma tabela de identificação única, não possui relacionamentos diretos

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: -

## Fluxo de utilização dentro do sistema
1. Cada entidade assistencial recebe UUID único via esta tabela
2. tipo_entidade identifica o tipo (FFA, ATENDIMENTO)
3. hash_imutavel garante que os dados originais não foram alterados
4. origem_runtime indica de onde veio a criação
5. bloqueado impede alterações em casos específicos
6. Permite rastreamento global único de entidades
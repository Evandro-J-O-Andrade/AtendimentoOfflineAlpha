# runtime_kernel_locks

**Objetivo:** Gerencia locks e sincronização de runtime

**Descrição:** A tabela `runtime_kernel_locks` armazena dados relacionados a gerencia locks e sincronização de runtime. Contém 6 colunas, com chave primária em `id`.

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id | BIGINT | Não | NULL | Identificador único da linha na tabela runtime_kernel_locks |
| uuid_runtime | CHAR(36) | Não | NULL | Identificador único universal (UUID) para rastreamento distribuído |
| locked_by | INT | Não | NULL | Token ou identificador do lock semântico |
| acquired_at | DATETIME(6) | Não | NULL | Campo de data e/ou hora |
| expires_at | DATETIME(6) | Não | NULL | Data/hora de expiração do registro ou lock |
| id_entidade | BIGINT | Não | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id`

## Índices

- idx_runtime: `uuid_runtime`, `expires_at`

## Constraints

- PRIMARY KEY em (`id`)

## Relacionamentos e Cardinalidade

- Nenhum relacionamento de chave estrangeira direto identificado no DDL.

## Dependências

- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `runtime_kernel_locks` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Utilizado pelo motor de runtime para controle de execução concorrente, locks, snapshots de governança e sincronização entre instâncias federadas. Governa o ciclo de vida de processos assistenciais e operacionais garantindo integridade concorrente.

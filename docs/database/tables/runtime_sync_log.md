# runtime_sync_log

**Objetivo:** Gerencia logs e filas de sincronização federada

**Descrição:** A tabela `runtime_sync_log` armazena dados relacionados a gerencia logs e filas de sincronização federada. Contém 9 colunas, com chave primária em `id_sync` e relaciona-se com outras tabelas via chaves estrangeiras (id_entidade -> saas_entidade(id_entidade); id_unidade -> unidade(id_unidade)).

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_sync | BIGINT | Não | NULL | Campo numérico inteiro |
| id_unidade | BIGINT | Não | NULL | Identificador da unidade de saúde |
| uuid_evento | CHAR(36) | Não | NULL | Identificador único universal (UUID) para rastreamento distribuído |
| tipo_evento | VARCHAR(60) | Não | NULL | Classificação ou tipo do registro |
| estado_payload | JSON | Sim | NULL | Dados estruturados em formato JSON |
| hash_payload | CHAR(64) | Sim | NULL | Hash criptográfico para validação de integridade |
| sincronizado | TINYINT(1) | Sim | '0' | Campo numérico inteiro |
| criado_em | DATETIME(6) | Sim | CURRENT_TIMESTAMP(6) | Data e hora de criação do registro |
| id_entidade | BIGINT | Não | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_sync`
- **Estrangeiras:**
  - fk_runtime_sync_log_entidade: `id_entidade` -> `saas_entidade` (`id_entidade`)
  - fk_runtime_sync_log_unidade: `id_unidade` -> `unidade` (`id_unidade`)

## Índices

- idx_sync_unidade: `id_unidade`
- idx_sync_uuid: `uuid_evento`
- idx_sync_status: `sincronizado`
- fk_runtime_sync_log_entidade: `id_entidade`

## Constraints

- FOREIGN KEY `fk_runtime_sync_log_entidade` em (`id_entidade`) referencia `saas_entidade` (`id_entidade`)
- FOREIGN KEY `fk_runtime_sync_log_unidade` em (`id_unidade`) referencia `unidade` (`id_unidade`)
- PRIMARY KEY em (`id_sync`)

## Relacionamentos e Cardinalidade

- **runtime_sync_log -> saas_entidade:** Relacionamento 1:N via `id_entidade` referenciando `saas_entidade`(`id_entidade`)
- **runtime_sync_log -> unidade:** Relacionamento 1:N via `id_unidade` referenciando `unidade`(`id_unidade`)

## Dependências

- **Depende de:** `saas_entidade`, `unidade`
- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `runtime_sync_log` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Utilizado pelo motor de runtime para controle de execução concorrente, locks, snapshots de governança e sincronização entre instâncias federadas. Governa o ciclo de vida de processos assistenciais e operacionais garantindo integridade concorrente.

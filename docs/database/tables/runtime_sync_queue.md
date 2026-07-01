# runtime_sync_queue

**Objetivo:** Gerencia logs e filas de sincronização federada

**Descrição:** A tabela `runtime_sync_queue` armazena dados relacionados a gerencia logs e filas de sincronização federada. Contém 7 colunas, com chave primária em `id_queue`. Possui restrições de unicidade em: uuid_evento.

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_queue | BIGINT | Não | NULL | Campo numérico inteiro |
| uuid_evento | CHAR(36) | Não | NULL | Identificador único universal (UUID) para rastreamento distribuído |
| tentativa_sync | INT | Sim | '0' | Contador de tentativas de operação/sincronização |
| ultimo_erro | TEXT | Sim | NULL | Descrição do último erro ocorrido |
| proximo_retry_em | DATETIME(6) | Sim | NULL | Campo de data e/ou hora |
| criado_em | DATETIME(6) | Sim | CURRENT_TIMESTAMP(6) | Data e hora de criação do registro |
| id_entidade | BIGINT | Não | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_queue`
- **Únicas:**
  - uk_sync_queue_evento: `uuid_evento`

## Índices

- Nenhum índice secundário além da chave primária.

## Constraints

- UNIQUE KEY `uk_sync_queue_evento` em (`uuid_evento`)
- PRIMARY KEY em (`id_queue`)

## Relacionamentos e Cardinalidade

- Nenhum relacionamento de chave estrangeira direto identificado no DDL.

## Dependências

- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `runtime_sync_queue` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Utilizado pelo motor de runtime para controle de execução concorrente, locks, snapshots de governança e sincronização entre instâncias federadas. Governa o ciclo de vida de processos assistenciais e operacionais garantindo integridade concorrente.

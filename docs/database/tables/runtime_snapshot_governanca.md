# runtime_snapshot_governanca

**Objetivo:** Armazena snapshots de governança e metadados

**Descrição:** A tabela `runtime_snapshot_governanca` armazena dados relacionados a armazena snapshots de governança e metadados. Contém 9 colunas, com chave primária em `id_governanca`. Possui restrições de unicidade em: dominio_fluxo.

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_governanca | BIGINT | Não | NULL | Campo numérico inteiro |
| dominio_fluxo | VARCHAR(50) | Não | NULL | Domínio do fluxo assistencial ou operacional |
| ttl_snapshot_horas | INT | Não | '24' | Campo numérico inteiro |
| tolerancia_execucao_horas | INT | Não | '2' | Campo numérico inteiro |
| exigir_revalidacao_expirada | TINYINT(1) | Sim | '1' | Campo numérico inteiro |
| ativo | TINYINT(1) | Sim | '1' | Indica se o registro está ativo (1) ou inativo (0) |
| criado_em | DATETIME(6) | Sim | CURRENT_TIMESTAMP(6) | Data e hora de criação do registro |
| atualizado_em | DATETIME(6) | Sim | NULL ON UPDATE CURRENT_TIMESTAMP(6) | Data e hora da última atualização do registro |
| id_entidade | BIGINT | Não | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_governanca`
- **Únicas:**
  - uk_snapshot_governanca_fluxo: `dominio_fluxo`

## Índices

- Nenhum índice secundário além da chave primária.

## Constraints

- UNIQUE KEY `uk_snapshot_governanca_fluxo` em (`dominio_fluxo`)
- PRIMARY KEY em (`id_governanca`)

## Relacionamentos e Cardinalidade

- Nenhum relacionamento de chave estrangeira direto identificado no DDL.

## Dependências

- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `runtime_snapshot_governanca` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Utilizado pelo motor de runtime para controle de execução concorrente, locks, snapshots de governança e sincronização entre instâncias federadas. Governa o ciclo de vida de processos assistenciais e operacionais garantindo integridade concorrente.

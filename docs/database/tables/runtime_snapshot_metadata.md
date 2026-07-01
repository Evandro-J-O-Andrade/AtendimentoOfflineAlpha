# runtime_snapshot_metadata

**Objetivo:** Armazena snapshots de governança e metadados

**Descrição:** A tabela `runtime_snapshot_metadata` armazena dados relacionados a armazena snapshots de governança e metadados. Contém 10 colunas, com chave primária em `id_snapshot`. Possui restrições de unicidade em: hash_snapshot.

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_snapshot | BIGINT | Não | NULL | Campo numérico inteiro |
| dominio_fluxo | VARCHAR(50) | Não | NULL | Domínio do fluxo assistencial ou operacional |
| versao_fluxo | BIGINT | Não | NULL | Versão do fluxo associado ao snapshot |
| hash_snapshot | CHAR(64) | Não | NULL | Hash criptográfico para validação de integridade |
| payload_metadata | JSON | Não | NULL | Dados estruturados em formato JSON |
| ativo | TINYINT(1) | Sim | '1' | Indica se o registro está ativo (1) ou inativo (0) |
| criado_em | DATETIME(6) | Sim | CURRENT_TIMESTAMP(6) | Data e hora de criação do registro |
| expiracao_snapshot | DATETIME(6) | Não | NULL | Data/hora de expiração do registro ou lock |
| ultima_validacao_runtime | DATETIME(6) | Sim | NULL | Timestamp da última validação realizada em runtime |
| id_entidade | BIGINT | Não | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_snapshot`
- **Únicas:**
  - uk_snapshot_fluxo_hash: `hash_snapshot`

## Índices

- idx_snapshot_fluxo: `dominio_fluxo`, `versao_fluxo`
- idx_snapshot_expiracao: `expiracao_snapshot`

## Constraints

- UNIQUE KEY `uk_snapshot_fluxo_hash` em (`hash_snapshot`)
- PRIMARY KEY em (`id_snapshot`)

## Relacionamentos e Cardinalidade

- Nenhum relacionamento de chave estrangeira direto identificado no DDL.

## Dependências

- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `runtime_snapshot_metadata` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Utilizado pelo motor de runtime para controle de execução concorrente, locks, snapshots de governança e sincronização entre instâncias federadas. Governa o ciclo de vida de processos assistenciais e operacionais garantindo integridade concorrente.

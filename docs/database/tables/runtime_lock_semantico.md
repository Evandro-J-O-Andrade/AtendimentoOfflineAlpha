# runtime_lock_semantico

**Objetivo:** Gerencia locks e sincronização de runtime

**Descrição:** A tabela `runtime_lock_semantico` armazena dados relacionados a gerencia locks e sincronização de runtime. Contém 8 colunas, com chave primária em `id_lock`. Possui restrições de unicidade em: dominio_fluxo, id_recurso.

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_lock | BIGINT | Não | NULL | Token ou identificador do lock semântico |
| dominio_fluxo | VARCHAR(50) | Não | NULL | Domínio do fluxo assistencial ou operacional |
| id_recurso | VARCHAR(100) | Não | NULL | Identificador do recurso protegido pelo lock |
| id_sessao_usuario | BIGINT | Não | NULL | Identificador da sessão de usuário ativa |
| token_lock | CHAR(36) | Não | NULL | Token ou identificador do lock semântico |
| expiracao_lock | DATETIME(6) | Não | NULL | Data/hora de expiração do registro ou lock |
| criado_em | DATETIME(6) | Sim | CURRENT_TIMESTAMP(6) | Data e hora de criação do registro |
| id_entidade | BIGINT | Não | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_lock`
- **Únicas:**
  - uk_lock_recurso: `dominio_fluxo`, `id_recurso`

## Índices

- idx_lock_expiracao: `expiracao_lock`

## Constraints

- UNIQUE KEY `uk_lock_recurso` em (`dominio_fluxo, id_recurso`)
- PRIMARY KEY em (`id_lock`)

## Relacionamentos e Cardinalidade

- Nenhum relacionamento de chave estrangeira direto identificado no DDL.

## Dependências

- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `runtime_lock_semantico` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Utilizado pelo motor de runtime para controle de execução concorrente, locks, snapshots de governança e sincronização entre instâncias federadas. Governa o ciclo de vida de processos assistenciais e operacionais garantindo integridade concorrente.

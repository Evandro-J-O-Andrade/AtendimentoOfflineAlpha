# tombstone_evento_assistencial

**Objetivo:** Registro de exclusão lógica (tombstone) para eventos assistenciais

**Descrição:** A tabela `tombstone_evento_assistencial` armazena dados relacionados a registro de exclusão lógica (tombstone) para eventos assistenciais. Contém 7 colunas, com chave primária em `id_tombstone`. Possui restrições de unicidade em: id_ffa, evento.

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_tombstone | BIGINT | Não | NULL | Campo numérico inteiro |
| id_ffa | BIGINT | Não | NULL | Campo numérico inteiro |
| evento | VARCHAR(60) | Não | NULL | Registro de evento ou ocorrência |
| estado_cancelado | VARCHAR(60) | Sim | NULL | Campo de texto de comprimento variável |
| id_sessao_usuario | BIGINT | Sim | NULL | Identificador da sessão de usuário ativa |
| cancelado_em | DATETIME(6) | Sim | CURRENT_TIMESTAMP(6) | Campo de data e/ou hora |
| id_entidade | BIGINT | Não | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_tombstone`
- **Únicas:**
  - uk_tombstone_evento: `id_ffa`, `evento`

## Índices

- idx_tombstone_lookup: `id_ffa`, `evento`

## Constraints

- UNIQUE KEY `uk_tombstone_evento` em (`id_ffa, evento`)
- PRIMARY KEY em (`id_tombstone`)

## Relacionamentos e Cardinalidade

- Nenhum relacionamento de chave estrangeira direto identificado no DDL.

## Dependências

- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `tombstone_evento_assistencial` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Implementa exclusão lógica (soft delete) para eventos assistenciais, permitindo recuperação de dados e auditoria de remoções.

# sus_competencia

**Objetivo:** Competências mensais para faturamento SUS

**Descrição:** A tabela `sus_competencia` armazena dados relacionados a competências mensais para faturamento sus. Contém 6 colunas, com chave primária em `id_competencia`. Possui restrições de unicidade em: competencia.

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_competencia | BIGINT | Não | NULL | Competência (período) |
| competencia | CHAR(6) | Não | NULL | Competência (período) |
| descricao | VARCHAR(120) | Sim | NULL | Descrição textual do item |
| ativo | TINYINT(1) | Não | '1' | Indica se o registro está ativo (1) ou inativo (0) |
| criado_em | DATETIME | Não | CURRENT_TIMESTAMP | Data e hora de criação do registro |
| id_entidade | BIGINT | Não | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_competencia`
- **Únicas:**
  - uk_sus_competencia: `competencia`

## Índices

- Nenhum índice secundário além da chave primária.

## Constraints

- UNIQUE KEY `uk_sus_competencia` em (`competencia`)
- PRIMARY KEY em (`id_competencia`)

## Relacionamentos e Cardinalidade

- Nenhum relacionamento de chave estrangeira direto identificado no DDL.

## Dependências

- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `sus_competencia` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Armazena dados auxiliares para integração com sistemas públicos de saúde (SIGTAP, TUSS, CNES, CID-10) e regras de faturamento/conveniência.

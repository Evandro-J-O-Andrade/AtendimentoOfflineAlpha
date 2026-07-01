# sus_cid10_competencia

**Objetivo:** Competência CID-10 para faturamento SUS

**Descrição:** A tabela `sus_cid10_competencia` armazena dados relacionados a competência cid-10 para faturamento sus. Contém 7 colunas, com chave primária em `id_cid10c`. Possui restrições de unicidade em: competencia, cid10.

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_cid10c | BIGINT | Não | NULL | Código CID-10 |
| competencia | CHAR(6) | Não | NULL | Competência (período) |
| cid10 | VARCHAR(10) | Não | NULL | Código CID-10 |
| descricao | VARCHAR(255) | Sim | NULL | Descrição textual do item |
| ativo | TINYINT(1) | Não | '1' | Indica se o registro está ativo (1) ou inativo (0) |
| criado_em | DATETIME | Não | CURRENT_TIMESTAMP | Data e hora de criação do registro |
| id_entidade | BIGINT | Não | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_cid10c`
- **Únicas:**
  - uk_cid10c_comp: `competencia`, `cid10`

## Índices

- ix_cid10c_cid: `cid10`

## Constraints

- UNIQUE KEY `uk_cid10c_comp` em (`competencia, cid10`)
- PRIMARY KEY em (`id_cid10c`)

## Relacionamentos e Cardinalidade

- Nenhum relacionamento de chave estrangeira direto identificado no DDL.

## Dependências

- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `sus_cid10_competencia` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Armazena dados auxiliares para integração com sistemas públicos de saúde (SIGTAP, TUSS, CNES, CID-10) e regras de faturamento/conveniência.

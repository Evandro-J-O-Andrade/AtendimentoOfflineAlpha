# sus_cnes_estabelecimento

**Objetivo:** Estabelecimentos CNES para integração SUS

**Descrição:** A tabela `sus_cnes_estabelecimento` armazena dados relacionados a estabelecimentos cnes para integração sus. Contém 10 colunas, com chave primária em `id_cnes`. Possui restrições de unicidade em: competencia, cnes.

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_cnes | BIGINT | Não | NULL | Código CNES |
| competencia | CHAR(6) | Não | NULL | Competência (período) |
| cnes | VARCHAR(20) | Não | NULL | Código CNES |
| nome | VARCHAR(255) | Sim | NULL | Nome ou descrição do item |
| municipio | VARCHAR(120) | Sim | NULL | Campo de texto de comprimento variável |
| uf | CHAR(2) | Sim | NULL | Campo de texto de comprimento fixo |
| ativo | TINYINT(1) | Não | '1' | Indica se o registro está ativo (1) ou inativo (0) |
| criado_em | DATETIME | Não | CURRENT_TIMESTAMP | Data e hora de criação do registro |
| atualizado_em | DATETIME | Sim | NULL | Data e hora da última atualização do registro |
| id_entidade | BIGINT | Sim | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_cnes`
- **Únicas:**
  - uk_cnes_comp_cnes: `competencia`, `cnes`

## Índices

- ix_cnes_cnes: `cnes`

## Constraints

- UNIQUE KEY `uk_cnes_comp_cnes` em (`competencia, cnes`)
- PRIMARY KEY em (`id_cnes`)

## Relacionamentos e Cardinalidade

- Nenhum relacionamento de chave estrangeira direto identificado no DDL.

## Dependências

- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `sus_cnes_estabelecimento` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Armazena dados auxiliares para integração com sistemas públicos de saúde (SIGTAP, TUSS, CNES, CID-10) e regras de faturamento/conveniência.

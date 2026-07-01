# sus_sigtap_procedimento

**Objetivo:** Procedimentos SIGTAP para faturamento SUS

**Descrição:** A tabela `sus_sigtap_procedimento` armazena dados relacionados a procedimentos sigtap para faturamento sus. Contém 18 colunas, com chave primária em `id_sigtap`. Possui restrições de unicidade em: competencia, codigo.

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_sigtap | BIGINT | Não | NULL | Procedimento SIGTAP |
| competencia | CHAR(6) | Não | NULL | Competência (período) |
| codigo | VARCHAR(30) | Não | NULL | Código de identificação do item |
| descricao | VARCHAR(255) | Não | NULL | Descrição textual do item |
| descricao_completa | TEXT | Sim | NULL | Descrição textual do item |
| grupo | VARCHAR(80) | Sim | NULL | Campo de texto de comprimento variável |
| subgrupo | VARCHAR(80) | Sim | NULL | Campo de texto de comprimento variável |
| forma_organizacao | VARCHAR(80) | Sim | NULL | Campo de texto de comprimento variável |
| complexidade | VARCHAR(40) | Sim | NULL | Campo de texto de comprimento variável |
| sexo | ENUM('I','M','F') | Não | 'I' | Campo de enumeração com valores predefinidos |
| idade_min | INT | Sim | NULL | Campo numérico inteiro |
| idade_max | INT | Sim | NULL | Campo numérico inteiro |
| exige_cat_default | TINYINT(1) | Não | '0' | Campo numérico inteiro |
| exige_sinan_default | TINYINT(1) | Não | '0' | Campo numérico inteiro |
| ativo | TINYINT(1) | Não | '1' | Indica se o registro está ativo (1) ou inativo (0) |
| criado_em | DATETIME | Não | CURRENT_TIMESTAMP | Data e hora de criação do registro |
| atualizado_em | DATETIME | Sim | NULL | Data e hora da última atualização do registro |
| id_entidade | BIGINT | Não | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_sigtap`
- **Únicas:**
  - uk_sigtap_comp_cod: `competencia`, `codigo`

## Índices

- ix_sigtap_codigo: `codigo`
- ix_sigtap_comp: `competencia`
- ix_sigtap_exige_cat: `exige_cat_default`

## Constraints

- UNIQUE KEY `uk_sigtap_comp_cod` em (`competencia, codigo`)
- PRIMARY KEY em (`id_sigtap`)

## Relacionamentos e Cardinalidade

- Nenhum relacionamento de chave estrangeira direto identificado no DDL.

## Dependências

- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `sus_sigtap_procedimento` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Armazena dados auxiliares para integração com sistemas públicos de saúde (SIGTAP, TUSS, CNES, CID-10) e regras de faturamento/conveniência.

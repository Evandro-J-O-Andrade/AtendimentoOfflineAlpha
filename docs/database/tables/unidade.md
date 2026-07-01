# unidade

**Objetivo:** Cadastro de unidades de saúde

**Descrição:** A tabela `unidade` armazena dados relacionados a cadastro de unidades de saúde. Contém 7 colunas, com chave primária em `id_unidade` e relaciona-se com outras tabelas via chaves estrangeiras (id_cidade -> cidade(id_cidade); id_entidade -> saas_entidade(id_entidade)).

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_unidade | BIGINT | Não | NULL | Identificador da unidade de saúde |
| id_entidade | BIGINT | Não | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |
| id_cidade | BIGINT | Sim | NULL | Campo numérico inteiro |
| nome | VARCHAR(200) | Sim | NULL | Nome ou descrição do item |
| tipo | VARCHAR(100) | Sim | NULL | Classificação ou tipo do registro |
| ativo | TINYINT | Sim | '1' | Indica se o registro está ativo (1) ou inativo (0) |
| criado_em | DATETIME(6) | Sim | CURRENT_TIMESTAMP(6) | Data e hora de criação do registro |

## Chaves

- **Primária:** `id_unidade`
- **Estrangeiras:**
  - fk_unidade_cidade: `id_cidade` -> `cidade` (`id_cidade`)
  - fk_unidade_entidade: `id_entidade` -> `saas_entidade` (`id_entidade`)

## Índices

- idx_unidade_entidade: `id_entidade`
- idx_unidade_cidade: `id_cidade`

## Constraints

- FOREIGN KEY `fk_unidade_cidade` em (`id_cidade`) referencia `cidade` (`id_cidade`)
- FOREIGN KEY `fk_unidade_entidade` em (`id_entidade`) referencia `saas_entidade` (`id_entidade`)
- PRIMARY KEY em (`id_unidade`)

## Relacionamentos e Cardinalidade

- **unidade -> cidade:** Relacionamento 1:N via `id_cidade` referenciando `cidade`(`id_cidade`)
- **unidade -> saas_entidade:** Relacionamento 1:N via `id_entidade` referenciando `saas_entidade`(`id_entidade`)

## Dependências

- **Depende de:** `cidade`, `saas_entidade`
- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `unidade` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Cadastro de unidades de saúde (hospitais, UBS, UPAs), servindo como entidade central para alocação e gestão assistencial.

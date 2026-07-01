# tenant_registry

**Objetivo:** Registry de tenants multi-tenant

**Descrição:** A tabela `tenant_registry` armazena dados relacionados a registry de tenants multi-tenant. Contém 13 colunas, com chave primária em `id_tenant`. Possui restrições de unicidade em: uuid_tenant; cnes.

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_tenant | BIGINT | Não | NULL | Identificador do tenant (multi-tenant) |
| uuid_tenant | CHAR(36) | Não | (uuid()) | Identificador único universal (UUID) para rastreamento distribuído |
| nome_fantasia | VARCHAR(200) | Não | NULL | Nome ou descrição do item |
| razao_social | VARCHAR(300) | Não | NULL | Razão social da entidade |
| cnpj | VARCHAR(20) | Sim | NULL | CNPJ da entidade |
| cnes | VARCHAR(20) | Sim | NULL | Código CNES |
| instancia_primary | TINYINT(1) | Sim | '1' | Campo numérico inteiro |
| regiao | VARCHAR(50) | Sim | NULL | Campo de texto de comprimento variável |
| pais | VARCHAR(50) | Sim | 'BR' | Campo de texto de comprimento variável |
| status | ENUM('ATIVO','SUSPENSO','MIGRANDO','INATIVO') | Sim | 'ATIVO' | Status atual do registro no fluxo |
| created_at | DATETIME(6) | Sim | CURRENT_TIMESTAMP(6) | Campo de data e/ou hora |
| updated_at | DATETIME(6) | Sim | NULL | Campo de data e/ou hora |
| id_entidade | BIGINT | Não | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_tenant`
- **Únicas:**
  - uk_uuid: `uuid_tenant`
  - uk_cnes: `cnes`

## Índices

- idx_status: `status`
- idx_regiao: `regiao`

## Constraints

- UNIQUE KEY `uk_uuid` em (`uuid_tenant`)
- UNIQUE KEY `uk_cnes` em (`cnes`)
- PRIMARY KEY em (`id_tenant`)

## Relacionamentos e Cardinalidade

- Nenhum relacionamento de chave estrangeira direto identificado no DDL.

## Dependências

- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `tenant_registry` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Registry central de tenants para arquitetura multi-tenant, gerenciando isolamento e metadados por instância.

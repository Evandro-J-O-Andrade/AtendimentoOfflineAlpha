# saas_entidade

**Objetivo:** Cadastro central de entidades (tenants) do sistema SaaS

**Descrição:** A tabela `saas_entidade` armazena dados relacionados a cadastro central de entidades (tenants) do sistema saas. Contém 8 colunas, com chave primária em `id_entidade`.

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_entidade | BIGINT | Não | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |
| nome_fantasia | VARCHAR(200) | Não | NULL | Nome ou descrição do item |
| razao_social | VARCHAR(200) | Sim | NULL | Razão social da entidade |
| cnpj | VARCHAR(20) | Sim | NULL | CNPJ da entidade |
| tipo_entidade | ENUM('PREFEITURA','HOSPITAL','UPA','UBS','CLINICA','FARMACIA','OPERADORA') | Sim | NULL | Classificação ou tipo do registro |
| ativo | TINYINT | Sim | '1' | Indica se o registro está ativo (1) ou inativo (0) |
| criado_em | DATETIME(6) | Sim | CURRENT_TIMESTAMP(6) | Data e hora de criação do registro |
| atualizado_em | DATETIME(6) | Sim | NULL | Data e hora da última atualização do registro |

## Chaves

- **Primária:** `id_entidade`

## Índices

- Nenhum índice secundário além da chave primária.

## Constraints

- PRIMARY KEY em (`id_entidade`)

## Relacionamentos e Cardinalidade

- Nenhum relacionamento de chave estrangeira direto identificado no DDL.

## Dependências

- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `saas_entidade` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Gerencia a estrutura multi-tenant do sistema, controlando entidades, contratos e permissões por instância. Fundamental para isolar dados e configurações entre diferentes clientes (tenants).

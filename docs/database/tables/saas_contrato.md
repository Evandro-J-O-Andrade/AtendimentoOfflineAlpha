# saas_contrato

**Objetivo:** Gerencia contratos e períodos de vigência das entidades SaaS

**Descrição:** A tabela `saas_contrato` armazena dados relacionados a gerencia contratos e períodos de vigência das entidades saas. Contém 6 colunas, com chave primária em `id_contrato` e relaciona-se com outras tabelas via chaves estrangeiras (id_entidade -> saas_entidade(id_entidade)).

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_contrato | BIGINT | Não | NULL | Campo numérico inteiro |
| id_entidade | BIGINT | Não | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |
| data_inicio | DATE | Não | NULL | Dados operacionais do registro |
| data_fim | DATE | Sim | NULL | Dados operacionais do registro |
| status | ENUM('ATIVO','SUSPENSO','CANCELADO') | Não | 'ATIVO' | Status atual do registro no fluxo |
| atualizado_em | DATETIME | Sim | CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP | Data e hora da última atualização do registro |

## Chaves

- **Primária:** `id_contrato`
- **Estrangeiras:**
  - fk_saas_contrato_entidade: `id_entidade` -> `saas_entidade` (`id_entidade`)

## Índices

- idx_contrato_entidade_status: `id_entidade`, `status`

## Constraints

- FOREIGN KEY `fk_saas_contrato_entidade` em (`id_entidade`) referencia `saas_entidade` (`id_entidade`)
- PRIMARY KEY em (`id_contrato`)

## Relacionamentos e Cardinalidade

- **saas_contrato -> saas_entidade:** Relacionamento 1:N via `id_entidade` referenciando `saas_entidade`(`id_entidade`)

## Dependências

- **Depende de:** `saas_entidade`
- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `saas_contrato` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Gerencia a estrutura multi-tenant do sistema, controlando entidades, contratos e permissões por instância. Fundamental para isolar dados e configurações entre diferentes clientes (tenants).

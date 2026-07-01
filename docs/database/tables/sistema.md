# sistema

**Objetivo:** Configurações e parâmetros do sistema

**Descrição:** A tabela `sistema` armazena dados relacionados a configurações e parâmetros do sistema. Contém 6 colunas, com chave primária em `id_sistema`.

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_sistema | BIGINT | Não | NULL | Campo numérico inteiro |
| nome | VARCHAR(120) | Não | NULL | Nome ou descrição do item |
| codigo | VARCHAR(50) | Sim | NULL | Código de identificação do item |
| ativo | TINYINT | Sim | '1' | Indica se o registro está ativo (1) ou inativo (0) |
| criado_em | DATETIME(6) | Sim | CURRENT_TIMESTAMP(6) | Data e hora de criação do registro |
| id_entidade | BIGINT | Sim | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_sistema`

## Índices

- Nenhum índice secundário além da chave primária.

## Constraints

- PRIMARY KEY em (`id_sistema`)

## Relacionamentos e Cardinalidade

- Nenhum relacionamento de chave estrangeira direto identificado no DDL.

## Dependências

- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `sistema` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Armazena parâmetros globais e configurações do sistema, influenciando comportamento de módulos, timeouts e regras de negócio.

# tipo_local

**Objetivo:** Tipos de locais físicos

**Descrição:** A tabela `tipo_local` armazena dados relacionados a tipos de locais físicos. Contém 11 colunas, com chave primária em `id_tipo_local`. Possui restrições de unicidade em: codigo.

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_tipo_local | BIGINT | Não | NULL | Classificação ou tipo do registro |
| codigo | VARCHAR(40) | Não | NULL | Código de identificação do item |
| nome | VARCHAR(120) | Não | NULL | Nome ou descrição do item |
| categoria | VARCHAR(40) | Não | NULL | Campo de texto de comprimento variável |
| descricao | TEXT | Sim | NULL | Descrição textual do item |
| ativo | TINYINT | Sim | '1' | Indica se o registro está ativo (1) ou inativo (0) |
| criado_em | DATETIME(6) | Sim | CURRENT_TIMESTAMP(6) | Data e hora de criação do registro |
| categoria_operacional | VARCHAR(40) | Sim | NULL | Campo de texto de comprimento variável |
| descricao_operacional | TEXT | Sim | NULL | Descrição textual do item |
| atualizado_em | DATETIME(6) | Sim | NULL | Data e hora da última atualização do registro |
| id_entidade | BIGINT | Sim | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_tipo_local`
- **Únicas:**
  - uk_tipo_local_codigo: `codigo`

## Índices

- Nenhum índice secundário além da chave primária.

## Constraints

- UNIQUE KEY `uk_tipo_local_codigo` em (`codigo`)
- PRIMARY KEY em (`id_tipo_local`)

## Relacionamentos e Cardinalidade

- Nenhum relacionamento de chave estrangeira direto identificado no DDL.

## Dependências

- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `tipo_local` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Tabela de domínio que classifica entidades do sistema (locais, salas) permitindo parametrização de regras de negócio.

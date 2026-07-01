# tipo_sala

**Objetivo:** Tipos de salas assistenciais

**Descrição:** A tabela `tipo_sala` armazena dados relacionados a tipos de salas assistenciais. Contém 7 colunas, com chave primária em `id_tipo_sala`.

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_tipo_sala | BIGINT | Não | NULL | Classificação ou tipo do registro |
| codigo | VARCHAR(50) | Sim | NULL | Código de identificação do item |
| nome | VARCHAR(100) | Sim | NULL | Nome ou descrição do item |
| gera_chamada_painel | TINYINT(1) | Sim | NULL | Campo numérico inteiro |
| usa_tts | TINYINT(1) | Sim | NULL | Campo numérico inteiro |
| tipo_fila | VARCHAR(50) | Sim | NULL | Classificação ou tipo do registro |
| id_entidade | BIGINT | Sim | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_tipo_sala`

## Índices

- Nenhum índice secundário além da chave primária.

## Constraints

- PRIMARY KEY em (`id_tipo_sala`)

## Relacionamentos e Cardinalidade

- Nenhum relacionamento de chave estrangeira direto identificado no DDL.

## Dependências

- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `tipo_sala` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Tabela de domínio que classifica entidades do sistema (locais, salas) permitindo parametrização de regras de negócio.

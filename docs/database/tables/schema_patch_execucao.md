# schema_patch_execucao

**Objetivo:** Controle de execução de patches de schema de banco de dados

**Descrição:** A tabela `schema_patch_execucao` armazena dados relacionados a controle de execução de patches de schema de banco de dados. Contém 7 colunas, com chave primária em `id_patch_execucao`.

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_patch_execucao | BIGINT | Não | NULL | Campo numérico inteiro |
| patch_nome | VARCHAR(120) | Não | NULL | Nome ou descrição do item |
| hash_patch | VARCHAR(128) | Sim | NULL | Hash criptográfico para validação de integridade |
| status_execucao | ENUM('SUCESSO','ERRO') | Não | NULL | Status atual do registro no fluxo |
| detalhes | JSON | Sim | NULL | Detalhes complementares do registro |
| executado_em | DATETIME | Não | CURRENT_TIMESTAMP | Campo de data e/ou hora |
| id_entidade | BIGINT | Não | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_patch_execucao`

## Índices

- idx_patch_nome_data: `patch_nome`, `executado_em`

## Constraints

- PRIMARY KEY em (`id_patch_execucao`)

## Relacionamentos e Cardinalidade

- Nenhum relacionamento de chave estrangeira direto identificado no DDL.

## Dependências

- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `schema_patch_execucao` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Registra a execução de patches de schema no banco de dados, garantindo rastreabilidade de alterações estruturais e permitindo auditoria de evolução do banco.

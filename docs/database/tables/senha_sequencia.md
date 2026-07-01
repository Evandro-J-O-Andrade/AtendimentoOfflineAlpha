# senha_sequencia

**Objetivo:** Gestão de senhas, eventos, sequências e transições de status

**Descrição:** A tabela `senha_sequencia` armazena dados relacionados a gestão de senhas, eventos, sequências e transições de status. Contém 6 colunas, com chave primária em `id_sistema, id_unidade, data_ref, prefixo` e relaciona-se com outras tabelas via chaves estrangeiras (id_unidade -> unidade(id_unidade)).

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_sistema | BIGINT | Não | NULL | Campo numérico inteiro |
| id_unidade | BIGINT | Não | NULL | Identificador da unidade de saúde |
| data_ref | DATE | Não | NULL | Dados operacionais do registro |
| prefixo | VARCHAR(5) | Não | NULL | Campo de texto de comprimento variável |
| ultimo_numero | INT | Não | '0' | Campo numérico inteiro |
| id_entidade | BIGINT | Sim | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_sistema`, `id_unidade`, `data_ref`, `prefixo`
- **Estrangeiras:**
  - fk_senha_sequencia_unidade: `id_unidade` -> `unidade` (`id_unidade`)

## Índices

- fk_senha_sequencia_unidade: `id_unidade`

## Constraints

- FOREIGN KEY `fk_senha_sequencia_unidade` em (`id_unidade`) referencia `unidade` (`id_unidade`)
- PRIMARY KEY em (`id_sistema, id_unidade, data_ref, prefixo`)

## Relacionamentos e Cardinalidade

- **senha_sequencia -> unidade:** Relacionamento 1:N via `id_unidade` referenciando `unidade`(`id_unidade`)

## Dependências

- **Depende de:** `unidade`
- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `senha_sequencia` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Gerencia o ciclo de vida de senhas de usuários e senhas de fluxo operacional, incluindo sequências, transições de status e eventos de auditoria.

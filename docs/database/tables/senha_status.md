# senha_status

**Objetivo:** Gestão de senhas, eventos, sequências e transições de status

**Descrição:** A tabela `senha_status` armazena dados relacionados a gestão de senhas, eventos, sequências e transições de status. Contém 6 colunas, com chave primária em `id_senha_status`. Possui restrições de unicidade em: codigo.

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_senha_status | BIGINT | Não | NULL | Status atual do registro no fluxo |
| codigo | VARCHAR(30) | Não | NULL | Código de identificação do item |
| descricao | VARCHAR(150) | Não | NULL | Descrição textual do item |
| ativo | TINYINT(1) | Sim | '1' | Indica se o registro está ativo (1) ou inativo (0) |
| ordem_fluxo | INT | Não | NULL | Campo numérico inteiro |
| id_entidade | BIGINT | Sim | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_senha_status`
- **Únicas:**
  - uk_senha_status_codigo: `codigo`

## Índices

- Nenhum índice secundário além da chave primária.

## Constraints

- UNIQUE KEY `uk_senha_status_codigo` em (`codigo`)
- PRIMARY KEY em (`id_senha_status`)

## Relacionamentos e Cardinalidade

- Nenhum relacionamento de chave estrangeira direto identificado no DDL.

## Dependências

- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `senha_status` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Gerencia o ciclo de vida de senhas de usuários e senhas de fluxo operacional, incluindo sequências, transições de status e eventos de auditoria.

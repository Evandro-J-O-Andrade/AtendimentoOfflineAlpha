# senha_eventos

**Objetivo:** Gestão de senhas, eventos, sequências e transições de status

**Descrição:** A tabela `senha_eventos` armazena dados relacionados a gestão de senhas, eventos, sequências e transições de status. Contém 9 colunas, com chave primária em `id_evento`.

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_evento | BIGINT | Não | NULL | Registro de evento ou ocorrência |
| id_sessao_usuario | BIGINT | Sim | NULL | Identificador da sessão de usuário ativa |
| id_senha | BIGINT | Não | NULL | Senha ou hash de senha |
| tipo_evento | VARCHAR(60) | Não | NULL | Classificação ou tipo do registro |
| detalhe | TEXT | Sim | NULL | Detalhes complementares do registro |
| status_de | VARCHAR(50) | Sim | NULL | Status atual do registro no fluxo |
| status_para | VARCHAR(50) | Sim | NULL | Status atual do registro no fluxo |
| criado_em | DATETIME | Não | CURRENT_TIMESTAMP | Data e hora de criação do registro |
| id_entidade | BIGINT | Sim | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_evento`

## Índices

- idx_se_senha_criado: `id_senha`, `criado_em`
- idx_se_sessao_criado: `id_sessao_usuario`, `criado_em`
- idx_se_tipo_criado: `tipo_evento`, `criado_em`

## Constraints

- PRIMARY KEY em (`id_evento`)

## Relacionamentos e Cardinalidade

- Nenhum relacionamento de chave estrangeira direto identificado no DDL.

## Dependências

- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `senha_eventos` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Gerencia o ciclo de vida de senhas de usuários e senhas de fluxo operacional, incluindo sequências, transições de status e eventos de auditoria.

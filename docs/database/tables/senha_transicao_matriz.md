# senha_transicao_matriz

**Objetivo:** Gestão de senhas, eventos, sequências e transições de status

**Descrição:** A tabela `senha_transicao_matriz` armazena dados relacionados a gestão de senhas, eventos, sequências e transições de status. Contém 6 colunas, com chave primária em `id_senha_transicao` e relaciona-se com outras tabelas via chaves estrangeiras (id_status_origem -> senha_status(id_senha_status); id_status_destino -> senha_status(id_senha_status)). Possui restrições de unicidade em: id_status_origem, id_status_destino.

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_senha_transicao | BIGINT | Não | NULL | Dados de transição de estado/status |
| id_status_origem | BIGINT | Não | NULL | Status atual do registro no fluxo |
| id_status_destino | BIGINT | Não | NULL | Status atual do registro no fluxo |
| permite_retorno | TINYINT(1) | Sim | '0' | Campo numérico inteiro |
| ativo | TINYINT(1) | Sim | '1' | Indica se o registro está ativo (1) ou inativo (0) |
| id_entidade | BIGINT | Sim | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_senha_transicao`
- **Únicas:**
  - uk_transicao: `id_status_origem`, `id_status_destino`
- **Estrangeiras:**
  - senha_transicao_matriz_ibfk_1: `id_status_origem` -> `senha_status` (`id_senha_status`)
  - senha_transicao_matriz_ibfk_2: `id_status_destino` -> `senha_status` (`id_senha_status`)

## Índices

- id_status_destino: `id_status_destino`

## Constraints

- FOREIGN KEY `senha_transicao_matriz_ibfk_1` em (`id_status_origem`) referencia `senha_status` (`id_senha_status`)
- FOREIGN KEY `senha_transicao_matriz_ibfk_2` em (`id_status_destino`) referencia `senha_status` (`id_senha_status`)
- UNIQUE KEY `uk_transicao` em (`id_status_origem, id_status_destino`)
- PRIMARY KEY em (`id_senha_transicao`)

## Relacionamentos e Cardinalidade

- **senha_transicao_matriz -> senha_status:** Relacionamento 1:N via `id_status_origem` referenciando `senha_status`(`id_senha_status`)
- **senha_transicao_matriz -> senha_status:** Relacionamento 1:N via `id_status_destino` referenciando `senha_status`(`id_senha_status`)

## Dependências

- **Depende de:** `senha_status`
- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `senha_transicao_matriz` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Gerencia o ciclo de vida de senhas de usuários e senhas de fluxo operacional, incluindo sequências, transições de status e eventos de auditoria.

# sessao_contexto_historico

**Objetivo:** Gestão de sessões de usuário e contexto

**Descrição:** A tabela `sessao_contexto_historico` armazena dados relacionados a gestão de sessões de usuário e contexto. Contém 10 colunas, com chave primária em `id` e relaciona-se com outras tabelas via chaves estrangeiras (id_atendimento -> atendimento(id_atendimento); id_local -> local(id_local); id_sessao_usuario -> sessao_usuario(id_sessao_usuario); id_unidade -> unidade(id_unidade); id_usuario -> usuario(id_usuario); id_entidade -> saas_entidade(id_entidade)).

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id | BIGINT | Não | NULL | Identificador único da linha na tabela sessao_contexto_historico |
| id_sessao_usuario | BIGINT | Não | NULL | Identificador da sessão de usuário ativa |
| id_usuario | BIGINT | Não | NULL | Identificador do usuário do sistema |
| id_atendimento | BIGINT | Sim | NULL | Identificador do atendimento |
| id_entidade | BIGINT | Não | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |
| id_unidade | BIGINT | Não | NULL | Identificador da unidade de saúde |
| id_local | BIGINT | Não | NULL | Identificador do local físico |
| contexto_anterior | JSON | Sim | NULL | Contexto operacional |
| contexto_novo | JSON | Sim | NULL | Contexto operacional |
| criado_em | DATETIME(6) | Não | CURRENT_TIMESTAMP(6) | Data e hora de criação do registro |

## Chaves

- **Primária:** `id`
- **Estrangeiras:**
  - fk_hist_ctx_atend: `id_atendimento` -> `atendimento` (`id_atendimento`)
  - fk_hist_ctx_local: `id_local` -> `local` (`id_local`)
  - fk_hist_ctx_sessao: `id_sessao_usuario` -> `sessao_usuario` (`id_sessao_usuario`)
  - fk_hist_ctx_unidade: `id_unidade` -> `unidade` (`id_unidade`)
  - fk_hist_ctx_usuario: `id_usuario` -> `usuario` (`id_usuario`)
  - fk_sessao_contexto_historico_entidade: `id_entidade` -> `saas_entidade` (`id_entidade`)

## Índices

- idx_hist_sessao: `id_sessao_usuario`, `criado_em`
- idx_hist_usuario: `id_usuario`, `criado_em`
- idx_hist_ent_unid: `id_entidade`, `id_unidade`, `criado_em`
- idx_hist_atendimento: `id_atendimento`
- idx_hist_local: `id_local`
- fk_hist_ctx_unidade: `id_unidade`

## Constraints

- FOREIGN KEY `fk_hist_ctx_atend` em (`id_atendimento`) referencia `atendimento` (`id_atendimento`)
- FOREIGN KEY `fk_hist_ctx_local` em (`id_local`) referencia `local` (`id_local`)
- FOREIGN KEY `fk_hist_ctx_sessao` em (`id_sessao_usuario`) referencia `sessao_usuario` (`id_sessao_usuario`)
- FOREIGN KEY `fk_hist_ctx_unidade` em (`id_unidade`) referencia `unidade` (`id_unidade`)
- FOREIGN KEY `fk_hist_ctx_usuario` em (`id_usuario`) referencia `usuario` (`id_usuario`)
- FOREIGN KEY `fk_sessao_contexto_historico_entidade` em (`id_entidade`) referencia `saas_entidade` (`id_entidade`)
- PRIMARY KEY em (`id`)

## Relacionamentos e Cardinalidade

- **sessao_contexto_historico -> atendimento:** Relacionamento 1:N via `id_atendimento` referenciando `atendimento`(`id_atendimento`)
- **sessao_contexto_historico -> local:** Relacionamento 1:N via `id_local` referenciando `local`(`id_local`)
- **sessao_contexto_historico -> sessao_usuario:** Relacionamento 1:N via `id_sessao_usuario` referenciando `sessao_usuario`(`id_sessao_usuario`)
- **sessao_contexto_historico -> unidade:** Relacionamento 1:N via `id_unidade` referenciando `unidade`(`id_unidade`)
- **sessao_contexto_historico -> usuario:** Relacionamento 1:N via `id_usuario` referenciando `usuario`(`id_usuario`)
- **sessao_contexto_historico -> saas_entidade:** Relacionamento 1:N via `id_entidade` referenciando `saas_entidade`(`id_entidade`)

## Dependências

- **Depende de:** `atendimento`, `local`, `sessao_usuario`, `unidade`, `usuario`, `saas_entidade`
- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `sessao_contexto_historico` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Gerencia sessões ativas, histórico de contexto e eventos de sessão, permitindo rastreamento de uso do sistema por usuários e dispositivos.

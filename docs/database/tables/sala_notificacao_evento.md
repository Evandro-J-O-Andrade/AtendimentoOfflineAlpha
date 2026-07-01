# sala_notificacao_evento

**Objetivo:** Notificações de sala para eventos assistenciais

**Descrição:** A tabela `sala_notificacao_evento` armazena dados relacionados a notificações de sala para eventos assistenciais. Contém 8 colunas, com chave primária em `id_evento` e relaciona-se com outras tabelas via chaves estrangeiras (id_notificacao -> sala_notificacao(id_notificacao); id_usuario -> usuario(id_usuario)).

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_evento | BIGINT | Não | NULL | Registro de evento ou ocorrência |
| id_notificacao | BIGINT | Não | NULL | Notificação do sistema |
| id_sessao_usuario | BIGINT | Não | NULL | Identificador da sessão de usuário ativa |
| tipo | VARCHAR(50) | Não | NULL | Classificação ou tipo do registro |
| detalhe | TEXT | Sim | NULL | Detalhes complementares do registro |
| id_usuario | BIGINT | Não | NULL | Identificador do usuário do sistema |
| criado_em | DATETIME | Não | CURRENT_TIMESTAMP | Data e hora de criação do registro |
| id_entidade | BIGINT | Não | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_evento`
- **Estrangeiras:**
  - fk_sn_evento_notif: `id_notificacao` -> `sala_notificacao` (`id_notificacao`)
  - fk_sn_evento_usuario: `id_usuario` -> `usuario` (`id_usuario`)

## Índices

- idx_sn_evento_notif: `id_notificacao`, `criado_em`
- idx_sn_evento_sessao: `id_sessao_usuario`, `criado_em`
- idx_sn_evento_usuario: `id_usuario`, `criado_em`

## Constraints

- FOREIGN KEY `fk_sn_evento_notif` em (`id_notificacao`) referencia `sala_notificacao` (`id_notificacao`)
- FOREIGN KEY `fk_sn_evento_usuario` em (`id_usuario`) referencia `usuario` (`id_usuario`)
- PRIMARY KEY em (`id_evento`)

## Relacionamentos e Cardinalidade

- **sala_notificacao_evento -> sala_notificacao:** Relacionamento 1:N via `id_notificacao` referenciando `sala_notificacao`(`id_notificacao`)
- **sala_notificacao_evento -> usuario:** Relacionamento 1:N via `id_usuario` referenciando `usuario`(`id_usuario`)

## Dependências

- **Depende de:** `sala_notificacao`, `usuario`
- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `sala_notificacao_evento` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Controla notificações abertas em salas/unidades para agravos, violência e outros eventos, funcionando como painel de alerta operacional e acompanhamento de atendimentos.

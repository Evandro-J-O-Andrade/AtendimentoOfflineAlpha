# sala_notificacao

**Objetivo:** Notificações de sala para eventos assistenciais

**Descrição:** A tabela `sala_notificacao` armazena dados relacionados a notificações de sala para eventos assistenciais. Contém 11 colunas, com chave primária em `id_notificacao` e relaciona-se com outras tabelas via chaves estrangeiras (id_unidade -> unidade(id_unidade); id_usuario_abertura -> usuario(id_usuario)).

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_notificacao | BIGINT | Não | NULL | Notificação do sistema |
| id_unidade | BIGINT | Não | NULL | Identificador da unidade de saúde |
| id_senha | BIGINT | Sim | NULL | Senha ou hash de senha |
| id_ffa | BIGINT | Sim | NULL | Campo numérico inteiro |
| tipo | ENUM('VIOLENCIA','AGRAVO','OUTRO') | Não | 'OUTRO' | Classificação ou tipo do registro |
| status | ENUM('ABERTO','EM_ATENDIMENTO','FINALIZADO','CANCELADO') | Não | 'ABERTO' | Status atual do registro no fluxo |
| detalhes | TEXT | Sim | NULL | Detalhes complementares do registro |
| id_usuario_abertura | BIGINT | Não | NULL | Identificador do usuário do sistema |
| criado_em | DATETIME | Sim | CURRENT_TIMESTAMP | Data e hora de criação do registro |
| atualizado_em | DATETIME | Sim | CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP | Data e hora da última atualização do registro |
| id_entidade | BIGINT | Não | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_notificacao`
- **Estrangeiras:**
  - fk_sala_notificacao_unidade: `id_unidade` -> `unidade` (`id_unidade`)
  - fk_sn_user: `id_usuario_abertura` -> `usuario` (`id_usuario`)

## Índices

- fk_sn_unidade: `id_unidade`
- fk_sn_user: `id_usuario_abertura`

## Constraints

- FOREIGN KEY `fk_sala_notificacao_unidade` em (`id_unidade`) referencia `unidade` (`id_unidade`)
- FOREIGN KEY `fk_sn_user` em (`id_usuario_abertura`) referencia `usuario` (`id_usuario`)
- PRIMARY KEY em (`id_notificacao`)

## Relacionamentos e Cardinalidade

- **sala_notificacao -> unidade:** Relacionamento 1:N via `id_unidade` referenciando `unidade`(`id_unidade`)
- **sala_notificacao -> usuario:** Relacionamento 1:N via `id_usuario_abertura` referenciando `usuario`(`id_usuario`)

## Dependências

- **Depende de:** `unidade`, `usuario`
- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `sala_notificacao` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Controla notificações abertas em salas/unidades para agravos, violência e outros eventos, funcionando como painel de alerta operacional e acompanhamento de atendimentos.

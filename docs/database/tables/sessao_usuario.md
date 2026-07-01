# sessao_usuario

**Objetivo:** Gestão de sessões de usuário e contexto

**Descrição:** A tabela `sessao_usuario` armazena dados relacionados a gestão de sessões de usuário e contexto. Contém 28 colunas, com chave primária em `id_sessao_usuario` e relaciona-se com outras tabelas via chaves estrangeiras (id_entidade -> saas_entidade(id_entidade); id_local -> local(id_local); id_perfil -> perfil(id_perfil); id_sistema -> sistema(id_sistema); id_unidade -> unidade(id_unidade); id_usuario -> usuario(id_usuario)). Possui restrições de unicidade em: uuid_sessao.

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_sessao_usuario | BIGINT | Não | NULL | Identificador da sessão de usuário ativa |
| uuid_sessao | CHAR(36) | Não | NULL | Identificador da sessão de usuário ativa |
| id_usuario | BIGINT | Não | NULL | Identificador do usuário do sistema |
| id_perfil | BIGINT | Sim | NULL | Campo numérico inteiro |
| id_sistema | BIGINT | Não | NULL | Campo numérico inteiro |
| id_unidade | BIGINT | Não | NULL | Identificador da unidade de saúde |
| id_local | BIGINT | Sim | NULL | Identificador do local físico |
| id_sala | BIGINT | Sim | NULL | Identificador da sala |
| id_dispositivo | BIGINT | Sim | NULL | Campo numérico inteiro |
| token_jwt | VARCHAR(512) | Não | NULL | Token de autenticação ou autorização |
| refresh_token | VARCHAR(512) | Sim | NULL | Token de autenticação ou autorização |
| ip_origem | VARCHAR(45) | Sim | NULL | Campo de texto de comprimento variável |
| user_agent | VARCHAR(255) | Sim | NULL | Campo de texto de comprimento variável |
| iniciado_em | DATETIME(6) | Não | NULL | Campo de data e/ou hora |
| expira_em | DATETIME(6) | Não | NULL | Campo de data e/ou hora |
| contexto_definido_em | DATETIME(6) | Sim | NULL | Contexto operacional |
| finalizado_em | DATETIME(6) | Sim | NULL | Campo de data e/ou hora |
| motivo_finalizacao | VARCHAR(120) | Sim | NULL | Campo de texto de comprimento variável |
| ativo | TINYINT(1) | Sim | '1' | Indica se o registro está ativo (1) ou inativo (0) |
| revogado | TINYINT(1) | Sim | '0' | Campo numérico inteiro |
| criado_em | DATETIME(6) | Sim | CURRENT_TIMESTAMP(6) | Data e hora de criação do registro |
| atualizado_em | DATETIME(6) | Sim | NULL ON UPDATE CURRENT_TIMESTAMP(6) | Data e hora da última atualização do registro |
| ip_country | VARCHAR(80) | Sim | NULL | Campo de texto de comprimento variável |
| ip_city | VARCHAR(120) | Sim | NULL | Campo de texto de comprimento variável |
| token_hash | VARCHAR(128) | Sim | NULL | Hash criptográfico para validação de integridade |
| refresh_hash | VARCHAR(128) | Sim | NULL | Hash criptográfico para validação de integridade |
| device_fingerprint | VARCHAR(255) | Sim | NULL | Campo de texto de comprimento variável |
| id_entidade | BIGINT | Não | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_sessao_usuario`
- **Únicas:**
  - uk_sessao_uuid: `uuid_sessao`
- **Estrangeiras:**
  - fk_sessao_usuario_entidade: `id_entidade` -> `saas_entidade` (`id_entidade`)
  - fk_sessao_usuario_local: `id_local` -> `local` (`id_local`)
  - fk_sessao_usuario_perfil: `id_perfil` -> `perfil` (`id_perfil`)
  - fk_sessao_usuario_sistema: `id_sistema` -> `sistema` (`id_sistema`)
  - fk_sessao_usuario_unidade: `id_unidade` -> `unidade` (`id_unidade`)
  - fk_sessao_usuario_usuario: `id_usuario` -> `usuario` (`id_usuario`)

## Índices

- idx_sessao_usuario: `id_usuario`
- idx_sessao_perfil: `id_perfil`
- idx_sessao_sistema: `id_sistema`
- idx_sessao_unidade: `id_unidade`
- idx_sessao_token: `token_jwt(255`
- idx_sessao_refresh: `refresh_token(255`
- idx_sessao_expira: `expira_em`
- idx_sessao_ativo: `ativo`
- idx_sessao_local: `id_local`
- idx_sessao_sala: `id_sala`
- idx_sessao_user_ent: `id_usuario`, `id_entidade`
- fk_sessao_usuario_entidade: `id_entidade`

## Constraints

- FOREIGN KEY `fk_sessao_usuario_entidade` em (`id_entidade`) referencia `saas_entidade` (`id_entidade`)
- FOREIGN KEY `fk_sessao_usuario_local` em (`id_local`) referencia `local` (`id_local`)
- FOREIGN KEY `fk_sessao_usuario_perfil` em (`id_perfil`) referencia `perfil` (`id_perfil`)
- FOREIGN KEY `fk_sessao_usuario_sistema` em (`id_sistema`) referencia `sistema` (`id_sistema`)
- FOREIGN KEY `fk_sessao_usuario_unidade` em (`id_unidade`) referencia `unidade` (`id_unidade`)
- FOREIGN KEY `fk_sessao_usuario_usuario` em (`id_usuario`) referencia `usuario` (`id_usuario`)
- UNIQUE KEY `uk_sessao_uuid` em (`uuid_sessao`)
- PRIMARY KEY em (`id_sessao_usuario`)

## Relacionamentos e Cardinalidade

- **sessao_usuario -> saas_entidade:** Relacionamento 1:N via `id_entidade` referenciando `saas_entidade`(`id_entidade`)
- **sessao_usuario -> local:** Relacionamento 1:N via `id_local` referenciando `local`(`id_local`)
- **sessao_usuario -> perfil:** Relacionamento 1:N via `id_perfil` referenciando `perfil`(`id_perfil`)
- **sessao_usuario -> sistema:** Relacionamento 1:N via `id_sistema` referenciando `sistema`(`id_sistema`)
- **sessao_usuario -> unidade:** Relacionamento 1:N via `id_unidade` referenciando `unidade`(`id_unidade`)
- **sessao_usuario -> usuario:** Relacionamento 1:N via `id_usuario` referenciando `usuario`(`id_usuario`)

## Dependências

- **Depende de:** `saas_entidade`, `local`, `perfil`, `sistema`, `unidade`, `usuario`
- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `sessao_usuario` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Gerencia sessões ativas, histórico de contexto e eventos de sessão, permitindo rastreamento de uso do sistema por usuários e dispositivos.

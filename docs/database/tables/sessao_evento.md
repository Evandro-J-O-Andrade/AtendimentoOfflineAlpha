# sessao_evento

**Objetivo:** Gestão de sessões de usuário e contexto

**Descrição:** A tabela `sessao_evento` armazena dados relacionados a gestão de sessões de usuário e contexto. Contém 9 colunas, com chave primária em `id_evento` e relaciona-se com outras tabelas via chaves estrangeiras (id_sessao_usuario -> sessao_usuario(id_sessao_usuario); id_usuario -> usuario(id_usuario)).

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_evento | BIGINT | Não | NULL | Registro de evento ou ocorrência |
| id_sessao_usuario | BIGINT | Não | NULL | Identificador da sessão de usuário ativa |
| id_usuario | BIGINT | Não | NULL | Identificador do usuário do sistema |
| tipo_evento | VARCHAR(60) | Não | NULL | Classificação ou tipo do registro |
| recurso | VARCHAR(120) | Sim | NULL | Campo de texto de comprimento variável |
| payload | JSON | Sim | NULL | Dados estruturados em formato JSON |
| ip_origem | VARCHAR(45) | Sim | NULL | Campo de texto de comprimento variável |
| criado_em | DATETIME(6) | Sim | CURRENT_TIMESTAMP(6) | Data e hora de criação do registro |
| id_entidade | BIGINT | Não | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_evento`
- **Estrangeiras:**
  - fk_evento_sessao: `id_sessao_usuario` -> `sessao_usuario` (`id_sessao_usuario`)
  - fk_evento_usuario: `id_usuario` -> `usuario` (`id_usuario`)

## Índices

- idx_evento_sessao: `id_sessao_usuario`
- idx_evento_usuario: `id_usuario`
- idx_evento_tipo: `tipo_evento`
- idx_evento_sessao_data: `id_sessao_usuario`, `criado_em`

## Constraints

- FOREIGN KEY `fk_evento_sessao` em (`id_sessao_usuario`) referencia `sessao_usuario` (`id_sessao_usuario`)
- FOREIGN KEY `fk_evento_usuario` em (`id_usuario`) referencia `usuario` (`id_usuario`)
- PRIMARY KEY em (`id_evento`)

## Relacionamentos e Cardinalidade

- **sessao_evento -> sessao_usuario:** Relacionamento 1:N via `id_sessao_usuario` referenciando `sessao_usuario`(`id_sessao_usuario`)
- **sessao_evento -> usuario:** Relacionamento 1:N via `id_usuario` referenciando `usuario`(`id_usuario`)

## Dependências

- **Depende de:** `sessao_usuario`, `usuario`
- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `sessao_evento` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Gerencia sessões ativas, histórico de contexto e eventos de sessão, permitindo rastreamento de uso do sistema por usuários e dispositivos.

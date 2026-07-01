# usuario

**Objetivo:** Gestão de usuários do sistema

**Descrição:** A tabela `usuario` armazena dados relacionados a gestão de usuários do sistema. Contém 12 colunas, com chave primária em `id_usuario` e relaciona-se com outras tabelas via chaves estrangeiras (id_entidade -> saas_entidade(id_entidade)). Possui restrições de unicidade em: login; id_usuario, id_entidade; id_usuario, id_entidade.

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_usuario | BIGINT | Não | NULL | Identificador do usuário do sistema |
| id_pessoa | BIGINT | Sim | NULL | Campo numérico inteiro |
| id_entidade | BIGINT | Não | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |
| login | VARCHAR(80) | Não | NULL | Registro de auditoria ou log de sistema |
| senha_hash | VARCHAR(255) | Não | NULL | Hash criptográfico para validação de integridade |
| ativo | TINYINT | Sim | '1' | Indica se o registro está ativo (1) ou inativo (0) |
| tentativas_login | INT | Sim | '0' | Contador de tentativas de operação/sincronização |
| bloqueado_ate | DATETIME(6) | Sim | NULL | Campo de data e/ou hora |
| ultimo_login | DATETIME(6) | Sim | NULL | Registro de auditoria ou log de sistema |
| ultimo_ip | VARCHAR(45) | Sim | NULL | Campo de texto de comprimento variável |
| criado_em | DATETIME(6) | Sim | CURRENT_TIMESTAMP(6) | Data e hora de criação do registro |
| atualizado_em | DATETIME(6) | Sim | NULL | Data e hora da última atualização do registro |

## Chaves

- **Primária:** `id_usuario`
- **Únicas:**
  - login: `login`
  - id_usuario: `id_usuario`, `id_entidade`
  - id_usuario_2: `id_usuario`, `id_entidade`
- **Estrangeiras:**
  - fk_usuario_entidade: `id_entidade` -> `saas_entidade` (`id_entidade`)

## Índices

- idx_usuario_login: `login`
- fk_usuario_entidade: `id_entidade`

## Constraints

- FOREIGN KEY `fk_usuario_entidade` em (`id_entidade`) referencia `saas_entidade` (`id_entidade`)
- UNIQUE KEY `login` em (`login`)
- UNIQUE KEY `id_usuario` em (`id_usuario, id_entidade`)
- UNIQUE KEY `id_usuario_2` em (`id_usuario, id_entidade`)
- PRIMARY KEY em (`id_usuario`)

## Relacionamentos e Cardinalidade

- **usuario -> saas_entidade:** Relacionamento 1:N via `id_entidade` referenciando `saas_entidade`(`id_entidade`)

## Dependências

- **Depende de:** `saas_entidade`
- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `usuario` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Gerencia usuários do sistema, incluindo alocações, perfis, histórico de senhas e tokens de acesso, compondo a base de controle de acesso.

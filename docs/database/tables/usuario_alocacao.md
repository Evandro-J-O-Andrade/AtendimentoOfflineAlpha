# usuario_alocacao

**Objetivo:** Gestão de usuários do sistema

**Descrição:** A tabela `usuario_alocacao` armazena dados relacionados a gestão de usuários do sistema. Contém 7 colunas, com chave primária em `id_alocacao` e relaciona-se com outras tabelas via chaves estrangeiras (id_especialidade -> especialidade(id_especialidade); id_usuario -> usuario(id_usuario)).

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_alocacao | BIGINT | Não | NULL | Campo numérico inteiro |
| id_usuario | BIGINT | Não | NULL | Identificador do usuário do sistema |
| id_sala | INT | Não | NULL | Identificador da sala |
| id_especialidade | BIGINT | Sim | NULL | Especialidade médica |
| inicio | DATETIME | Não | NULL | Datas de vigência ou período |
| fim | DATETIME | Sim | NULL | Datas de vigência ou período |
| id_entidade | BIGINT | Não | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_alocacao`
- **Estrangeiras:**
  - fk_usuario_alocacao_especialidade: `id_especialidade` -> `especialidade` (`id_especialidade`)
  - fk_usuario_alocacao_usuario: `id_usuario` -> `usuario` (`id_usuario`)

## Índices

- fk_usuario_alocacao_usuario: `id_usuario`
- fk_usuario_alocacao_especialidade: `id_especialidade`

## Constraints

- FOREIGN KEY `fk_usuario_alocacao_especialidade` em (`id_especialidade`) referencia `especialidade` (`id_especialidade`)
- FOREIGN KEY `fk_usuario_alocacao_usuario` em (`id_usuario`) referencia `usuario` (`id_usuario`)
- PRIMARY KEY em (`id_alocacao`)

## Relacionamentos e Cardinalidade

- **usuario_alocacao -> especialidade:** Relacionamento 1:N via `id_especialidade` referenciando `especialidade`(`id_especialidade`)
- **usuario_alocacao -> usuario:** Relacionamento 1:N via `id_usuario` referenciando `usuario`(`id_usuario`)

## Dependências

- **Depende de:** `especialidade`, `usuario`
- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `usuario_alocacao` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Gerencia usuários do sistema, incluindo alocações, perfis, histórico de senhas e tokens de acesso, compondo a base de controle de acesso.

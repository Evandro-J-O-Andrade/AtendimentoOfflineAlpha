# sessao_ativa

**Objetivo:** Gestão de sessões de usuário e contexto

**Descrição:** A tabela `sessao_ativa` armazena dados relacionados a gestão de sessões de usuário e contexto. Contém 5 colunas, com chave primária em `id_usuario`. Possui restrições de unicidade em: token_sessao.

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_usuario | BIGINT | Não | NULL | Identificador do usuário do sistema |
| token_sessao | VARCHAR(255) | Não | NULL | Token de autenticação ou autorização |
| ip_origem | VARCHAR(45) | Sim | NULL | Campo de texto de comprimento variável |
| ultimo_clique | DATETIME | Sim | CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP | Campo de data e/ou hora |
| id_entidade | BIGINT | Não | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_usuario`
- **Únicas:**
  - uk_token: `token_sessao`

## Índices

- Nenhum índice secundário além da chave primária.

## Constraints

- UNIQUE KEY `uk_token` em (`token_sessao`)
- PRIMARY KEY em (`id_usuario`)

## Relacionamentos e Cardinalidade

- Nenhum relacionamento de chave estrangeira direto identificado no DDL.

## Dependências

- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `sessao_ativa` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Gerencia sessões ativas, histórico de contexto e eventos de sessão, permitindo rastreamento de uso do sistema por usuários e dispositivos.

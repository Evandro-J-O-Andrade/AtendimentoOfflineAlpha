# auth_grupo

Objetivo: Gerenciar grupos de usuários para controle de acesso e permissões.
Descrição: Tabela que define grupos de usuários (setor, equipe, projeto, regional) para atribuição coletiva de permissões e controle de acesso ao sistema.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_grupo | bigint | NOT NULL | - | Identificador único do grupo, chave primária auto incrementada. |
| nome | varchar(100) | NOT NULL | - | Nome do grupo. |
| descricao | text | Nullable | - | Descrição detalhada do propósito e membros do grupo. |
| tipo_grupo | enum('SETOR','EQUIPE','PROJETO','REGIONAL') | Nullable | 'SETOR' | Tipo de grupo: setor, equipe, projeto ou regional. |
| id_unidade | bigint unsigned | NOT NULL | - | Referência à unidade onde o grupo está vinculado. |
| ativo | tinyint(1) | Nullable | '1' | Indicador se o grupo está ativo no sistema. |
| criado_por | bigint | Nullable | - | Referência ao usuário que criou o grupo. |
| criado_em | datetime | Nullable | CURRENT_TIMESTAMP | Data e hora de criação do grupo. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) à qual o grupo pertence. |

## Chaves
- Primária: id_grupo
- Únicas: nenhuma
- Estrangeiras: nenhuma

## Índices
- PRIMARY KEY (id_grupo)
- KEY idx_grupo_unidade (id_unidade)

## Constraints
- PRIMARY KEY: id_grupo

## Relacionamentos e Cardinalidade
- N:1 com unidade (id_unidade)
- N:1 com usuario (criado_por) - opcional
- N:1 com saas_entidade (id_entidade)
- 1:N com auth_grupo_usuario (id_grupo) - um grupo pode ter muitos usuários
- 1:N com auth_grupo_permissao (id_grupo) - um grupo pode ter muitas permissões

## Dependências
- Tabelas que dependem desta: auth_grupo_usuario, auth_grupo_permissao
- Dependência desta tabela: unidade, usuario, saas_entidade

## Fluxo de utilização dentro do sistema
- Criado para agrupar usuários com permissões semelhantes
- Permite atribuição coletiva de permissões via auth_grupo_permissao
- Usado para controle de acesso baseado em papéis (RBAC)
- Integra-se com sistema de notificações por grupo
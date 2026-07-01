# usuario_perfil

Objetivo: Gerenciar a atribuição de múltiplos perfis de acesso a usuários em um modelo many-to-many.
Descrição: Tabela de relacionamento entre usuários e perfis, permitindo que um usuário possua mais de um perfil de acesso no sistema. Controla quais perfis de permissão são atribuídos a cada usuário dentro de uma entidade SaaS específica. Suporta exclusão em cascata para manter integridade referencial.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_usuario | bigint | NO | NULL | Identificador do usuário que recebe o perfil |
| id_entidade | bigint unsigned | NO | NULL | Identificador da entidade SaaS na qual o perfil é atribuído |
| id_perfil | bigint | NO | NULL | Identificador do perfil de acesso atribuído ao usuário |
| criado_em | datetime(6) | YES | CURRENT_TIMESTAMP(6) | Data e hora de criação da atribuição de perfil |

## Chaves
- Primária: (id_usuario, id_perfil)
- Únicas: Nenhuma
- Estrangeiras: fk_up_perfil (id_perfil -> perfil.id_perfil), fk_up_usuario (id_usuario -> usuario.id_usuario), fk_usuario_perfil_entidade (id_entidade -> saas_entidade.id_entidade)

## Índices
- idx_up_perfil (id_perfil)
- idx_usuario_perfil_usuario (id_usuario)
- idx_usuario_perfil_perfil (id_perfil)
- idx_usuario_perfil_entidade (id_entidade)

## Constraints
- fk_up_perfil: FOREIGN KEY (id_perfil) REFERENCES perfil (id_perfil) ON DELETE CASCADE
- fk_up_usuario: FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario) ON DELETE CASCADE
- fk_usuario_perfil_entidade: FOREIGN KEY (id_entidade) REFERENCES saas_entidade (id_entidade)

## Relacionamentos e Cardinalidade
- N:1 com usuario (muitos perfis podem ser atribuídos a um usuário)
- N:1 com perfil (muitos usuários podem ter o mesmo perfil)
- N:1 com saas_entidade (muitas atribuições pertencem a uma entidade)

## Dependências
- Depende de: usuario, perfil, saas_entidade
- Dependências reversas: Nenhuma tabela principal depende diretamente desta, é usada para verificação de permissões

## Fluxo de utilização dentro do sistema
- Durante a autenticação ou verificação de permissões, o sistema consulta esta tabela para determinar quais perfis o usuário possui
- Permite que um usuário tenha múltiplos perfis simultaneamente, com a união das permissões de cada perfil
- A exclusão de um usuário remove automaticamente seus perfis (ON DELETE CASCADE)
- Usado no controle de acesso baseado em papéis (RBAC) para determinar funcionalidades disponíveis

# perfil

Objetivo: Definir perfis/profissões dos usuários do sistema.
Descrição: Tabela que armazena os perfis disponíveis no sistema (como Recepcionista, Enfermeiro, Médico, Farmacêutico, etc.) com seus respectivos códigos, permissões e contextos de atuação.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_perfil | bigint | NOT NULL | - | Identificador único do perfil (chave primária, auto incremento) |
| codigo | varchar(60) | NOT NULL | - | Código único do perfil para identificação (ex: "MEDICO", "ENFERMAGEM") |
| nome | varchar(120) | NOT NULL | - | Nome descritivo do perfil |
| descricao | text | YES | NULL | Descrição detalhada das funções do perfil |
| contexto | varchar(40) | YES | NULL | Contexto de atuação do perfil (ex: "ATENDIMENTO", "FARMACIA", "LABORATORIO") |
| ativo | tinyint | YES | '1' | Flag indicando se o perfil está ativo |
| criado_em | datetime(6) | YES | CURRENT_TIMESTAMP(6) | Data/hora de criação do perfil |
| id_entidade | bigint unsigned | YES | NULL | ID da entidade/tenant (NULL para perfis globais) |

## Chaves
- Primária: id_perfil
- Únicas: uk_perfil_codigo (codigo)
- Estrangeiras: (nenhuma foreign key)

## Índices
- PRIMARY KEY (id_perfil)
- UNIQUE KEY uk_perfil_codigo (codigo)
- KEY idx_perfil_ativo (ativo)

## Constraints
- PRIMARY KEY: id_perfil
- UNIQUE: uk_perfil_codigo

## Relacionamentos e Cardinalidade
- 1:N com perfil_permissao: Um perfil pode ter muitas permissões
- N:1 com saas_entidade: Muitos perfis pertencem a uma entidade (ou são globais)

## Dependências
- Esta tabela depende de: saas_entidade
- Tabelas que dependem desta: perfil_permissao, usuario_perfil

## Fluxo de utilização dentro do sistema
Utilizada como base para definição de permissões no sistema. Cada usuário possui um ou mais perfis, e os perfis determinam quais permissões (painéis, funcionalidades) o usuário tem. Perfis são criados com contexto específico (ATENDIMENTO, FARMACIA, etc.) permitindo segmentação de acesso. Permite gestão simplificada de permissões por papel.
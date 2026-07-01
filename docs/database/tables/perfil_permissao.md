# perfil_permissao

Objetivo: Associar permissões a perfis de usuários.
Descrição: Tabela de associação que define quais permissões cada perfil possui, estabelecendo o mapeamento entre perfis e funcionalidades do sistema.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_perfil | bigint | NOT NULL | - | ID do perfil (parte da chave primária) |
| id_permissao | bigint | NOT NULL | - | ID da permissão (parte da chave primária) |
| criado_em | datetime(6) | YES | CURRENT_TIMESTAMP(6) | Data/hora da associação |
| id_entidade | bigint unsigned | YES | NULL | ID da entidade/tenant (NULL para associação global) |

## Chaves
- Primária: (id_perfil, id_permissao)
- Únicas: (nenhuma)
- Estrangeiras: 
  - fk_pp_perfil: id_perfil → perfil (id_perfil) com CASCADE
  - fk_pp_permissao: id_permissao → permissao (id_permissao) com CASCADE

## Índices
- PRIMARY KEY (id_perfil, id_permissao)
- KEY idx_pp_perfil (id_perfil)
- KEY idx_pp_permissao (id_permissao)
- KEY idx_perfil_permissao_perfil (id_perfil)
- KEY idx_perfil_permissao_permissao (id_permissao)

## Constraints
- PRIMARY KEY: (id_perfil, id_permissao)
- FOREIGN KEY: fk_pp_perfil
- FOREIGN KEY: fk_pp_permissao

## Relacionamentos e Cardinalidade
- N:1 com perfil: Muitas associações pertencem a um perfil
- N:1 com permissao: Muitas associações pertencem a uma permissão

## Dependências
- Esta tabela depende de: perfil, permissao
- Não há tabelas que dependem desta tabela

## Fluxo de utilização dentro do sistema
Utilizada para definir o acesso de cada perfil ao sistema. Quando um perfil é criado ou alterado, as permissões são associadas aqui. Por exemplo, o perfil "MEDICO" tem permissão para acessar o painel médico, enquanto "FARMACIA" tem permissão para dispensar medicamentos. Permite gestão centralizada de permissões por função.
# guardiao_acl_runtime

Objetivo: Controlar permissões de acesso em tempo real (runtime) via ACL.

Descrição: Tabela que armazena as permissões de acesso concedidas em tempo real para usuários em contextos específicos, definindo quais recursos são permitidos. Utilizada pelo sistema de guardião para autorização dinâmica.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_guardiao_acl | bigint | NOT NULL | - | Identificador único do ACL runtime, chave primária auto incrementada |
| id_usuario | bigint | NOT NULL | - | Referência ao usuário ao qual a permissão se aplica |
| id_sistema | bigint | NOT NULL | - | Referência ao sistema/sistema externo |
| contexto | varchar(60) | NOT NULL | - | Contexto da permissão (ex: fila, atendimento) |
| recurso | varchar(120) | NOT NULL | - | Recurso ao qual a permissão se refere (ex: botão, tela) |
| permitido | tinyint | DEFAULT | '0' | Indicador se a permissão está concedida (0=não, 1=sim) |
| criado_em | datetime(6) | DEFAULT | CURRENT_TIMESTAMP(6) | Data e hora de criação do registro |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id_guardiao_acl
- Únicas: -
- Estrangeiras: -

## Índices
- idx_acl_usuario (id_usuario)
- idx_acl_contexto (contexto)
- idx_acl_recurso (recurso)

## Constraints
- -

## Relacionamentos e Cardinalidade
- guardiao_acl_runtime.id_usuario → usuario (id_usuario): N:1 (várias permissões podem referenciar o mesmo usuário)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: usuario

## Fluxo de utilização dentro do sistema
1. Sistema guardião avalia permissões do usuário
2. Registro é criado com contexto e recurso específicos
3. permitido indica se o usuário tem acesso ao recurso
4. Permite cache de permissões para performance
5. Contexto define o escopo (fila, atendimento, etc)
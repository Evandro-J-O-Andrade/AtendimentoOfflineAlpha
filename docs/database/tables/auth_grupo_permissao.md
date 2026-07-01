# auth_grupo_permissao

Objetivo: Definir permissões específicas para cada grupo de usuários.
Descrição: Tabela que mapeia permissões (recursos e ações) para grupos, permitindo controle de acesso granulado baseado em grupos.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_grupo_permissao | bigint | NOT NULL | - | Identificador único da permissão de grupo, chave primária auto incrementada. |
| id_grupo | bigint | NOT NULL | - | Referência ao grupo que receberá a permissão. |
| recurso | varchar(100) | NOT NULL | - | Nome do recurso/protegido (ex: PACIENTE, ATENDIMENTO, FICHA). |
| acao | varchar(50) | NOT NULL | - | Ação permitida no recurso (ex: READ, WRITE, DELETE). |
| ativo | tinyint(1) | Nullable | '1' | Indicador se a permissão está ativa. |
| criado_em | datetime | Nullable | CURRENT_TIMESTAMP | Data e hora de criação da permissão. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) à qual a permissão pertence. |

## Chaves
- Primária: id_grupo_permissao
- Únicas: uk_grupo_recurso (id_grupo, recurso, acao)
- Estrangeiras:
  - fk_gp_grupo: id_grupo → auth_grupo (id_grupo) - Relacionamento N:1, deleta em cascata

## Índices
- PRIMARY KEY (id_grupo_permissao)
- UNIQUE KEY uk_grupo_recurso (id_grupo, recurso, acao)

## Constraints
- PRIMARY KEY: id_grupo_permissao
- UNIQUE: uk_grupo_recurso (id_grupo, recurso, acao)
- FOREIGN KEY: fk_gp_grupo (id_grupo) REFERENCES auth_grupo (id_grupo) ON DELETE CASCADE

## Relacionamentos e Cardinalidade
- N:1 com auth_grupo (id_grupo)
- N:1 com saas_entidade (id_entidade)

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: auth_grupo, saas_entidade

## Fluxo de utilização dentro do sistema
- Criada quando se atribui permissão a um grupo
- Usada pelo sistema de autorização para validar acesso a recursos
- Constraint única impede permissões duplicadas para mesmo grupo/recurso/ação
- Integra-se com middleware de verificação de permissões
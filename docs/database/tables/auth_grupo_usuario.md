# auth_grupo_usuario

Objetivo: Vincular usuários a grupos com papéis específicos.
Descrição: Tabela de relacionamento que associa usuários a grupos e define o papel do usuário no grupo (membro, coordenador, subcoordenador).

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_grupo_usuario | bigint | NOT NULL | - | Identificador único do vínculo, chave primária auto incrementada. |
| id_grupo | bigint | NOT NULL | - | Referência ao grupo ao qual o usuário pertence. |
| id_usuario | bigint | NOT NULL | - | Referência ao usuário vinculado ao grupo. |
| papel | enum('MEMBRO','COORDENADOR','SUBCOORDENADOR') | Nullable | 'MEMBRO' | Papel do usuário no grupo: membro comum, coordenador ou subcoordenador. |
| ativo | tinyint(1) | Nullable | '1' | Indicador se o vínculo está ativo. |
| criado_em | datetime | Nullable | CURRENT_TIMESTAMP | Data e hora de criação do vínculo. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) à qual o vínculo pertence. |

## Chaves
- Primária: id_grupo_usuario
- Únicas: uk_grupo_usuario (id_grupo, id_usuario)
- Estrangeiras:
  - fk_gu_grupo: id_grupo → auth_grupo (id_grupo) - Relacionamento N:1, deleta em cascata
  - fk_gu_usuario: id_usuario → usuario (id_usuario) - Relacionamento N:1, deleta em cascata

## Índices
- PRIMARY KEY (id_grupo_usuario)
- UNIQUE KEY uk_grupo_usuario (id_grupo, id_usuario)
- KEY idx_grupo_usuario_usuario (id_usuario)

## Constraints
- PRIMARY KEY: id_grupo_usuario
- UNIQUE: uk_grupo_usuario (id_grupo, id_usuario)
- FOREIGN KEY: fk_gu_grupo (id_grupo) REFERENCES auth_grupo (id_grupo) ON DELETE CASCADE
- FOREIGN KEY: fk_gu_usuario (id_usuario) REFERENCES usuario (id_usuario) ON DELETE CASCADE

## Relacionamentos e Cardinalidade
- N:1 com auth_grupo (id_grupo)
- N:1 com usuario (id_usuario)
- N:1 com saas_entidade (id_entidade)

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: auth_grupo, usuario, saas_entidade

## Fluxo de utilização dentro do sistema
- Criada quando um usuário é adicionado a um grupo
- Define hierarquia dentro do grupo (membro, coordenador, subcoordenador)
- Permite herdar permissões do grupo para o usuário
- Constraint única impede usuário duplicado no mesmo grupo
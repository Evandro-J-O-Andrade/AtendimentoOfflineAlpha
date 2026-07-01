# usuario_contexto

Objetivo: Armazenar o contexto operacional atual de cada usuário no sistema, vinculando-o a um sistema, unidade, local operacional e perfil específico para controle de acesso e sessão.
Descrição: Representa o estado ativo de contexto do usuário no momento da utilização do sistema, definindo em qual sistema ele está autenticado, em qual unidade e local operacional está trabalhando, e qual perfil de acesso está sendo utilizado no momento. Funciona como uma tabela de estado de sessão persistida para recuperação de contexto entre requisições.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_usuario_contexto | bigint | NO | AUTO_INCREMENT | Chave primária única que identifica o registro de contexto do usuário |
| id_usuario | bigint | NO | NULL | Identificador do usuário ao qual este contexto pertence |
| id_sistema | bigint | NO | NULL | Identificador do sistema ao qual o usuário está conectado no momento |
| id_unidade | bigint unsigned | NO | NULL | Identificador da unidade operacional na qual o usuário está atuando |
| id_local_operacional | bigint | YES | NULL | Identificador do local operacional específico dentro da unidade onde o usuário está trabalhando |
| id_perfil | bigint | NO | NULL | Identificador do perfil de acesso atualmente atribuído ao usuário neste contexto |
| ativo | tinyint(1) | YES | '1' | Flag que indica se o contexto está ativo (1) ou inativo (0) |
| criado_em | datetime(6) | YES | CURRENT_TIMESTAMP(6) | Data e hora de criação do registro de contexto |
| id_entidade | bigint unsigned | NO | NULL | Identificador da entidade SaaS à qual este contexto pertence |

## Chaves
- Primária: id_usuario_contexto
- Únicas: Nenhuma
- Estrangeiras: fk_uc_perfil (id_perfil -> perfil.id_perfil), fk_uc_usuario (id_usuario -> usuario.id_usuario), fk_usuario_contexto_entidade (id_entidade -> saas_entidade.id_entidade), fk_usuario_contexto_unidade (id_unidade -> unidade.id_unidade)

## Índices
- idx_usuario_contexto_usuario (id_usuario)
- fk_uc_perfil (id_perfil)
- fk_usuario_contexto_unidade (id_unidade)
- fk_usuario_contexto_entidade (id_entidade)

## Constraints
- fk_uc_perfil: FOREIGN KEY (id_perfil) REFERENCES perfil (id_perfil)
- fk_uc_usuario: FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
- fk_usuario_contexto_entidade: FOREIGN KEY (id_entidade) REFERENCES saas_entidade (id_entidade)
- fk_usuario_contexto_unidade: FOREIGN KEY (id_unidade) REFERENCES unidade (id_unidade)

## Relacionamentos e Cardinalidade
- N:1 com usuario (muitos contextos podem pertencer a um usuário, mas na prática é 1:1 por usuário ativo)
- N:1 com perfil (muitos contextos podem Referem-se a um perfil)
- N:1 com sistema (muitos contextos podem Referem-se a um sistema)
- N:1 com unidade (muitos contextos podem Referem-se a uma unidade)
- N:1 com local (muitos contextos podem Referem-se a um local operacional)
- N:1 com saas_entidade (muitos contextos podem pertencer a uma entidade)

## Dependências
- Depende de: usuario, perfil, sistema, unidade, local, saas_entidade
- Dependências reversas: Nenhuma tabela principal depende diretamente desta, é usada para consulta de contexto

## Fluxo de utilização dentro do sistema
- Usuário faz login no sistema e um contexto é criado/atualizado com o sistema, unidade, local e perfil selecionados
- A cada requisição autenticada, o sistema consulta esta tabela para determinar as permissões e escopo operacional do usuário
- Quando o usuário troca de unidade ou perfil, o registro é atualizado
- Usado para filtro de dados por entidade e unidade em todo o sistema multi-tenant

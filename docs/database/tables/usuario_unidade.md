# usuario_unidade

Objetivo: Mapear a associação entre usuários e unidades, definindo em quais unidades cada usuário pode atuar.
Descrição: Tabela de relacionamento many-to-many entre usuários e unidades organizacionais, controlando quais unidades cada usuário está autorizado a acessar ou operar. Serve para filtrar dados e funcionalidades por unidade no sistema multi-unidade multi-tenant. Garante que usuários só vejam dados das unidades às quais estão vinculados.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_usuario_unidade | bigint | NO | AUTO_INCREMENT | Chave primária única que identifica a associação usuário-unidade |
| id_usuario | bigint | NO | NULL | Identificador do usuário associado à unidade |
| id_unidade | bigint unsigned | NO | NULL | Identificador da unidade organizacional associada ao usuário |
| ativo | tinyint(1) | YES | '1' | Flag que indica se a associação está ativa (1) ou inativa (0) |
| criado_em | datetime | YES | CURRENT_TIMESTAMP | Data e hora de criação da associação |
| id_entidade | bigint unsigned | NO | NULL | Identificador da entidade SaaS à qual esta associação pertence |

## Chaves
- Primária: id_usuario_unidade
- Únicas: uk_usuario_unidade (id_usuario, id_unidade)
- Estrangeiras: fk_usuario_unidade_entidade (id_entidade -> saas_entidade.id_entidade), fk_usuario_unidade_unidade (id_unidade -> unidade.id_unidade), fk_uu_usuario (id_usuario -> usuario.id_usuario)

## Índices
- uk_usuario_unidade (id_usuario, id_unidade) - unique
- fk_uu_usuario (id_usuario)
- fk_uu_unidade (id_unidade)
- idx_usuario_entidade (id_usuario, id_entidade)
- fk_usuario_unidade_entidade (id_entidade)

## Constraints
- fk_usuario_unidade_entidade: FOREIGN KEY (id_entidade) REFERENCES saas_entidade (id_entidade)
- fk_usuario_unidade_unidade: FOREIGN KEY (id_unidade) REFERENCES unidade (id_unidade)
- fk_uu_usuario: FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario) ON DELETE CASCADE

## Relacionamentos e Cardinalidade
- N:1 com usuario (muitas associações pertencem a um usuário)
- N:1 com unidade (muitas associações pertencem a uma unidade)
- N:1 com saas_entidade (muitas associações pertencem a uma entidade)

## Dependências
- Depende de: usuario, unidade, saas_entidade
- Dependências reversas: Nenhuma tabela principal depende diretamente desta, é usada para consulta de permissão por unidade

## Fluxo de utilização dentro do sistema
- Usada para filtrar dados de acordo com as unidades às quais o usuário tem acesso
- No login ou seleção de contexto, o sistema carrega as unidades disponíveis para o usuário através desta tabela
- Quando um usuário é contratado ou alocado para uma unidade, uma associação é criada aqui
- Funciona como base para controle de acesso organizacional no sistema multi-unidade multi-tenant
- A exclusão de um usuário remove automaticamente suas associações de unidade (ON DELETE CASCADE)

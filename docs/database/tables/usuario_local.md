# usuario_local

Objetivo: Mapear a associação entre usuários e locais operacionais, definindo em quais locais cada usuário pode atuar.
Descrição: Tabela de relacionamento many-to-many entre usuários e locais, controlando quais locais operacionais cada usuário está autorizado a acessar ou operar. Serve para filtrar dados e funcionalidades por localidade no sistema multi-unidade.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_usuario_local | bigint | NO | AUTO_INCREMENT | Chave primária única que identifica a associação usuário-local |
| id_usuario | bigint | NO | NULL | Identificador do usuário associado ao local |
| id_local | bigint | NO | NULL | Identificador do local operacional associado ao usuário |
| ativo | tinyint | YES | '1' | Flag que indica se a associação está ativa (1) ou inativa (0) |
| criado_em | datetime | YES | CURRENT_TIMESTAMP | Data e hora de criação da associação |
| id_entidade | bigint unsigned | NO | NULL | Identificador da entidade SaaS à qual esta associação pertence |

## Chaves
- Primária: id_usuario_local
- Únicas: uk_usuario_local (id_usuario, id_local)
- Estrangeiras: fk_ul_local (id_local -> local.id_local), fk_ul_usuario (id_usuario -> usuario.id_usuario), fk_usuario_local_entidade (id_entidade -> saas_entidade.id_entidade)

## Índices
- uk_usuario_local (id_usuario, id_local) - unique
- idx_ul_usuario (id_usuario)
- idx_ul_local (id_local)
- fk_usuario_local_entidade (id_entidade)

## Constraints
- fk_ul_local: FOREIGN KEY (id_local) REFERENCES local (id_local)
- fk_ul_usuario: FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
- fk_usuario_local_entidade: FOREIGN KEY (id_entidade) REFERENCES saas_entidade (id_entidade)

## Relacionamentos e Cardinalidade
- N:1 com usuario (muitas associações pertencem a um usuário)
- N:1 com local (muitas associações pertencem a um local)
- N:1 com saas_entidade (muitas associações pertencem a uma entidade)

## Dependências
- Depende de: usuario, local, saas_entidade
- Dependências reversas: Nenhuma tabela principal depende diretamente desta, é usada para consulta de permissão por local

## Fluxo de utilização dentro do sistema
- Usada para filtrar dados de acordo com os locais aos quais o usuário tem acesso
- No login ou seleção de contexto, o sistema carrega os locais disponíveis para o usuário através desta tabela
- Quando um usuário é cadastrado ou transferido, suas associações com locais são atualizadas aqui
- Funciona como base para controle de acesso geográfico/físico no sistema multi-unidade

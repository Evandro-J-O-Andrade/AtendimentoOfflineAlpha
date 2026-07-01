# usuario_setor

Objetivo: Mapear a associação entre usuários e setores, definindo em quais setores cada usuário pode operar.
Descrição: Tabela de relacionamento many-to-many entre usuários e setores organizacionais, controlando quais setores cada usuário está autorizado a acessar ou operar. Serve para filtrar dados e funcionalidades por setor no sistema multi-unidade, garantindo que profissionais só vejam ou operem nos setores aos quais estão vinculados.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_usuario_setor | bigint | NO | AUTO_INCREMENT | Chave primária única que identifica a associação usuário-setor |
| id_usuario | bigint | NO | NULL | Identificador do usuário associado ao setor |
| id_setor | int | NO | NULL | Identificador do setor organizacional associado ao usuário |
| pode_operar | tinyint(1) | YES | '1' | Flag que indica se o usuário pode operar efetivamente no setor (1) ou apenas visualizar (0) |
| criado_em | datetime(6) | YES | CURRENT_TIMESTAMP(6) | Data e hora de criação da associação |
| id_entidade | bigint unsigned | NO | NULL | Identificador da entidade SaaS à qual esta associação pertence |

## Chaves
- Primária: id_usuario_setor
- Únicas: uk_usuario_setor (id_usuario, id_setor)
- Estrangeiras: Nenhuma constraint FK declarada explicitamente na criação da tabela

## Índices
- uk_usuario_setor (id_usuario, id_setor) - unique
- idx_us_setor_usuario (id_usuario)
- idx_us_setor_setor (id_setor)

## Constraints
- Nenhuma constraint explícita declarada (as FKs para setor e usuario podem estar em nível de aplicação ou em script separado)

## Relacionamentos e Cardinalidade
- N:1 com usuario (muitas associações pertencem a um usuário)
- N:1 com setor (muitas associações pertencem a um setor)

## Dependências
- Depende de: usuario, setor, saas_entidade
- Dependências reversas: Nenhuma tabela principal depende diretamente desta, é usada para consulta de permissão por setor

## Fluxo de utilização dentro do sistema
- Usada para filtrar dados de acordo com os setores aos quais o usuário tem acesso
- No login ou seleção de contexto, o sistema carrega os setores disponíveis para o usuário através desta tabela
- O campo pode_operar permite diferenciar visualização de operação efetiva no setor
- Quando um usuário é alocado para um setor, uma associação é criada aqui
- Funciona como base para controle de acesso organizacional hierárquico no sistema multi-unidade

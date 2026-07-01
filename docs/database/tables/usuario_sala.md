# usuario_sala

Objetivo: Mapear a associação entre usuários e salas operacionais, definindo em quais salas cada usuário pode atuar.
Descrição: Tabela de relacionamento many-to-many entre usuários e salas, controlando quais salas operacionais cada usuário está autorizado a acessar ou operar. Serve para filtrar o atendimento por sala no sistema multi-unidade, garantindo que profissionais só vejam ou operem nas salas às quais estão vinculados.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_usuario_sala | bigint | NO | AUTO_INCREMENT | Chave primária única que identifica a associação usuário-sala |
| id_usuario | bigint | NO | NULL | Identificador do usuário associado à sala |
| id_sala | bigint unsigned | NO | NULL | Identificador da sala operacional associada ao usuário |
| ativo | tinyint(1) | YES | '1' | Flag que indica se a associação está ativa (1) ou inativa (0) |
| criado_em | datetime | YES | CURRENT_TIMESTAMP | Data e hora de criação da associação |
| id_entidade | bigint unsigned | NO | NULL | Identificador da entidade SaaS à qual esta associação pertence |

## Chaves
- Primária: id_usuario_sala
- Únicas: uk_usuario_sala (id_usuario, id_sala)
- Estrangeiras: fk_usuario_sala_entidade (id_entidade -> saas_entidade.id_entidade), fk_usuario_sala_sala (id_sala -> sala.id_sala), fk_usuario_sala_usuario (id_usuario -> usuario.id_usuario)

## Índices
- uk_usuario_sala (id_usuario, id_sala) - unique
- idx_usuario (id_usuario)
- idx_sala (id_sala)
- fk_usuario_sala_entidade (id_entidade)

## Constraints
- fk_usuario_sala_entidade: FOREIGN KEY (id_entidade) REFERENCES saas_entidade (id_entidade)
- fk_usuario_sala_sala: FOREIGN KEY (id_sala) REFERENCES sala (id_sala)
- fk_usuario_sala_usuario: FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)

## Relacionamentos e Cardinalidade
- N:1 com usuario (muitas associações pertencem a um usuário)
- N:1 com sala (muitas associações pertencem a uma sala)
- N:1 com saas_entidade (muitas associações pertencem a uma entidade)

## Dependências
- Depende de: usuario, sala, saas_entidade
- Dependências reversas: Nenhuma tabela principal depende diretamente desta, é usada para consulta de permissão por sala

## Fluxo de utilização dentro do sistema
- Usada para filtrar dados de atendimento de acordo com as salas às quais o usuário tem acesso
- No login ou seleção de contexto, o sistema carrega as salas disponíveis para o usuário através desta tabela
- Quando um profissional é alocado para uma sala, uma associação é criada aqui
- Funciona como base para controle de acesso físico/operacional no sistema multi-unidade de saúde

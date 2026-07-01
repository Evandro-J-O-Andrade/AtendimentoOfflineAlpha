# usuario_sistema

Objetivo: Gerenciar a atribuição de usuários a sistemas com perfis específicos, definindo acesso e permissões por sistema.
Descrição: Tabela de relacionamento entre usuários, sistemas e perfis, controlando quais usuários podem acessar cada sistema do ecossistema e com qual perfil de acesso. Funciona como uma matriz de controle de acesso multi-sistema, permitindo que um mesmo usuário tenha diferentes perfis em sistemas diferentes. Garante unicidade da combinação usuário-sistema.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_usuario_sistema | bigint | NO | AUTO_INCREMENT | Chave primária única que identifica a associação usuário-sistema |
| id_usuario | bigint | NO | NULL | Identificador do usuário a ser associado ao sistema |
| id_sistema | bigint | NO | NULL | Identificador do sistema ao qual o usuário está sendo associado |
| id_perfil | bigint | NO | NULL | Identificador do perfil de acesso do usuário dentro deste sistema específico |
| ativo | tinyint(1) | YES | '1' | Flag que indica se a associação está ativa (1) ou inativa (0) |
| criado_em | datetime(6) | YES | CURRENT_TIMESTAMP(6) | Data e hora de criação da associação usuário-sistema |
| id_entidade | bigint unsigned | NO | NULL | Identificador da entidade SaaS à qual esta associação pertence |

## Chaves
- Primária: id_usuario_sistema
- Únicas: uk_usuario_sistema (id_usuario, id_sistema)
- Estrangeiras: fk_us_perfil (id_perfil -> perfil.id_perfil), fk_us_sistema (id_sistema -> sistema.id_sistema), fk_us_usuario (id_usuario -> usuario.id_usuario)

## Índices
- uk_usuario_sistema (id_usuario, id_sistema) - unique
- idx_us_usuario (id_usuario)
- idx_us_sistema (id_sistema)
- fk_us_perfil (id_perfil)

## Constraints
- fk_us_perfil: FOREIGN KEY (id_perfil) REFERENCES perfil (id_perfil)
- fk_us_sistema: FOREIGN KEY (id_sistema) REFERENCES sistema (id_sistema)
- fk_us_usuario: FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)

## Relacionamentos e Cardinalidade
- N:1 com usuario (muitas associações podem pertencer a um usuário, cada uma para um sistema diferente)
- N:1 com sistema (muitos usuários podem ser associados a um sistema)
- N:1 com perfil (muitas associações podem usar o mesmo perfil)

## Dependências
- Depende de: usuario, sistema, perfil, saas_entidade
- Dependências reversas: Nenhuma tabela principal depende diretamente desta, é usada para controle de acesso multi-sistema

## Fluxo de utilização dentro do sistema
- Quando um usuário é criado ou cadastrado, associações com sistemas são criadas aqui
- No login, o sistema consulta esta tabela para determinar quais sistemas o usuário pode acessar
- O perfil específico por sistema determina as permissões dentro daquele sistema
- Usado no menu de sistemas disponíveis para o usuário após autenticação
- Permite que um usuário seja admin em um sistema e operador em outro simultaneamente

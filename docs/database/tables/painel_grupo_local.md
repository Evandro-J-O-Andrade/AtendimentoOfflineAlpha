# painel_grupo_local

Objetivo: Associar grupos de painéis a locais operacionais específicos.
Descrição: Tabela de associação que vincula grupos de painéis a locais operacionais, permitindo que um grupo seja aplicado automaticamente a todos os painéis de um determinado local.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_grupo | bigint | NOT NULL | - | ID do grupo de painéis (parte da chave primária) |
| id_local_operacional | bigint | NOT NULL | - | ID do local operacional associado ao grupo |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual a associação pertence |

## Chaves
- Primária: (id_grupo, id_local_operacional)
- Únicas: (nenhuma)
- Estrangeiras: 
  - fk_pgl_grupo: id_grupo → painel_grupo (id_grupo)

## Índices
- PRIMARY KEY (id_grupo, id_local_operacional)
- KEY idx_pgl_local (id_local_operacional)

## Constraints
- PRIMARY KEY: (id_grupo, id_local_operacional)
- FOREIGN KEY: fk_pgl_grupo

## Relacionamentos e Cardinalidade
- N:1 com painel_grupo: Muitas associações de local pertencem a um grupo
- N:1 com local_operacional: Muitas associações pertencem a um local operacional

## Dependências
- Esta tabela depende de: painel_grupo, local_operacional, saas_entidade
- Não há tabelas que dependem desta tabela

## Fluxo de utilização dentro do sistema
Utilizada para aplicar automaticamente configurações de grupo a todos os painéis de um local específico. Quando um painel é criado ou configurado, o sistema verifica se pertence a algum grupo via esta associação. Permite gestão simplificada de configurações em locais com múltiplos painéis.
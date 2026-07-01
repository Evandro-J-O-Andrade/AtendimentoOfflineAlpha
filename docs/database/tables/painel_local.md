# painel_local

Objetivo: Associar painéis a locais operacionais específicos.
Descrição: Tabela de associação que vincula painéis a locais operacionais, permitindo que um painel seja configurado para exibir eventos de um local específico.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_painel | bigint | NOT NULL | - | ID do painel (parte da chave primária) |
| id_local_operacional | bigint | NOT NULL | - | ID do local operacional associado ao painel |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual a associação pertence |

## Chaves
- Primária: (id_painel, id_local_operacional)
- Únicas: (nenhuma)
- Estrangeiras: 
  - fk_painel_local_local: id_local_operacional → local_operacional (id_local_operacional)
  - fk_painel_local_painel: id_painel → painel (id_painel)

## Índices
- PRIMARY KEY (id_painel, id_local_operacional)
- KEY idx_painel_local_local (id_local_operacional)

## Constraints
- PRIMARY KEY: (id_painel, id_local_operacional)
- FOREIGN KEY: fk_painel_local_local
- FOREIGN KEY: fk_painel_local_painel

## Relacionamentos e Cardinalidade
- N:1 com painel: Muitos locais podem ser associados a um painel
- N:1 com local_operacional: Muitos painéis podem estar associados a um local operacional

## Dependências
- Esta tabela depende de: painel, local_operacional, saas_entidade
- Não há tabelas que dependem desta tabela

## Fluxo de utilização dentro do sistema
Utilizada para associar painéis específicos a locais operacionais. Quando um painel é configurado para um local, apenas eventos referentes a esse local são exibidos. Permite que painéis em diferentes setores mostrem informações relevantes apenas para aquele setor.
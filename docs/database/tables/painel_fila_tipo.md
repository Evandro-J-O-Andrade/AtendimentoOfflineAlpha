# painel_fila_tipo

Objetivo: Associar painéis a tipos de filas que devem monitorar.
Descrição: Tabela de associação que define quais tipos de filas cada painel deve exibir. Permite configurar que um painel especifique monitore apenas determinadas filas (ex: uma TV mostra apenas médicos, outro mostra triagem).

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_painel | bigint | NOT NULL | - | ID do painel (parte da chave primária) |
| tipo_fila | varchar(30) | NOT NULL | - | Tipo de fila a ser monitorada (ex: "RECEPCAO", "TRIAGEM", "MEDICO", "MEDICACAO") |
| id_entidade | bigint unsigned | YES | NULL | ID da entidade/tenant (NULL para configuração global) |

## Chaves
- Primária: (id_painel, tipo_fila)
- Únicas: (nenhuma)
- Estrangeiras: 
  - fk_painel_fila_tipo_painel: id_painel → painel (id_painel)

## Índices
- PRIMARY KEY (id_painel, tipo_fila)

## Constraints
- PRIMARY KEY: (id_painel, tipo_fila)
- FOREIGN KEY: fk_painel_fila_tipo_painel

## Relacionamentos e Cardinalidade
- N:1 com painel: Muitas associações de tipo de fila pertencem a um painel

## Dependências
- Esta tabela depende de: painel
- Não há tabelas que dependem desta tabela

## Fluxo de utilização dentro do sistema
Utilizada para configurar quais filas cada painel deve exibir. Um painel de triagem mostra apenas a fila de triagem, enquanto um painel geral mostra todas as filas. Permite personalização da exibição por tipo de painel. Utilizado em conjunto com painel_local e painel_lane para filtragem avançada.
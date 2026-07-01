# painel_lane

Objetivo: Definir lanes (filas específicas) para cada painel.
Descrição: Tabela que associa painéis a lanes específicas, que representam filas de atendimento diferenciadas (ex: adulto vs pediátrico). Cada lane tem um código identificador.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_painel | bigint | NOT NULL | - | ID do painel (parte da chave primária) |
| lane | varchar(20) | NOT NULL | - | Código da lane: identificador da fila específica (ex: "ADULTO", "PEDIATRICO") |
| id_entidade | bigint unsigned | YES | NULL | ID da entidade/tenant (NULL para configuração global) |

## Chaves
- Primária: (id_painel, lane)
- Únicas: (nenhuma)
- Estrangeiras: 
  - fk_painel_lane_painel: id_painel → painel (id_painel)

## Índices
- PRIMARY KEY (id_painel, lane)

## Constraints
- PRIMARY KEY: (id_painel, lane)
- FOREIGN KEY: fk_painel_lane_painel

## Relacionamentos e Cardinalidade
- N:1 com painel: Muitas lanes pertencem a um painel

## Dependências
- Esta tabela depende de: painel
- Não há tabelas que dependem desta tabela

## Fluxo de utilização dentro do sistema
Utilizada para definir quais lanes (filas) cada painel deve exibir. Por exemplo, um painel de medicina clínica pode ter lanes separadas para adultos e pediátricos. Permite que o mesmo painel exiba múltiplas filas distintas com base na especialidade ou tipo de atendimento.
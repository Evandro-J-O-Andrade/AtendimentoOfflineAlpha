# painel_evento_stream

Objetivo: Armazenar eventos de stream para processamento pelos painéis.
Descrição: Tabela que mantém uma fila de eventos para processamento pelos painéis, permitindo distribuição de eventos por domínio, painel, lane e local. Eventos são marcados como processados após consumo.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_evento | bigint | NOT NULL | - | Identificador único do evento (chave primária, auto incremento) |
| dominio | varchar(50) | NOT NULL | - | Domínio do evento (ex: "senha", "fila", "atendimento") |
| tipo_evento | varchar(50) | NOT NULL | - | Tipo específico do evento dentro do domínio |
| id_referencia | bigint | NOT NULL | - | ID da referência do evento (ex: ID da senha, ID da fila) |
| id_painel | bigint | YES | NULL | ID do painel específico para o qual o evento é destinado |
| id_lane | bigint | YES | NULL | ID da lane (fila específica) à qual o evento pertence |
| id_local | bigint | YES | NULL | ID do local operacional à qual o evento pertence |
| payload | json | NOT NULL | - | Dados do evento em formato JSON |
| processado | tinyint(1) | YES | '0' | Flag indicando se o evento foi processado pelo painel |
| criado_em | datetime(6) | YES | CURRENT_TIMESTAMP(6) | Data/hora de criação do evento no stream |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual o evento pertence |

## Chaves
- Primária: id_evento
- Únicas: (nenhuma)
- Estrangeiras: (nenhuma foreign key)

## Índices
- PRIMARY KEY (id_evento)
- KEY idx_painel (id_painel, processado)
- KEY idx_ref (id_referencia)
- KEY idx_stream (processado, criado_em)

## Constraints
- PRIMARY KEY: id_evento

## Relacionamentos e Cardinalidade
- N:1 com painel: Muitos eventos pertencem a um painel
- N:1 com painel_lane: Muitos eventos pertencem a uma lane
- N:1 com local_operacional: Muitos eventos pertencem a um local operacional
- N:1 com saas_entidade: Muitos eventos pertencem a uma entidade

## Dependências
- Esta tabela depende de: saas_entidade
- Não há tabelas que dependem desta tabela

## Fluxo de utilização dentro do sistema
Utilizada como buffer de eventos para painéis. Quando eventos ocorrem (chamadas de senha, movimentação de filas), são inseridos aqui com o payload e flag processado=0. Os painéis consomem os eventos marcando como processado=1. Permite distribuição eficiente de eventos para múltiplos painéis simultaneamente.
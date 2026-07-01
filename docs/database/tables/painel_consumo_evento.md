# painel_consumo_evento

Objetivo: Registrar o consumo de eventos por painéis (auditoria de eventos lidas).
Descrição: Tabela que controla qual painel já leu cada evento de senhas ou filas, evitando que o mesmo evento seja processado múltiplas vezes pelo mesmo painel. Utilizada para sincronização de eventos entre múltiplos painéis.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_consumo | bigint | NOT NULL | - | Identificador único do consumo (chave primária, auto incremento) |
| origem | enum('SENHA_EVENTOS','FILA_OPERACIONAL_EVENTO') | NOT NULL | - | Origem do evento: senhas ou eventos de fila operacional |
| id_evento | bigint | NOT NULL | - | ID do evento consumido |
| painel_tipo | varchar(50) | NOT NULL | - | Tipo do painel que consumiu o evento (ex: "RECEPCAO", "TRIAGEM") |
| id_local_operacional | bigint | YES | NULL | ID do local operacional associado ao evento |
| consumido_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data/hora em que o evento foi consumido pelo painel |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual o consumo pertence |

## Chaves
- Primária: id_consumo
- Únicas: uk_painel_consumo (origem, id_evento, painel_tipo)
- Estrangeiras: (nenhuma foreign key)

## Índices
- PRIMARY KEY (id_consumo)
- UNIQUE KEY uk_painel_consumo (origem, id_evento, painel_tipo)
- KEY idx_painel_local (id_local_operacional, consumido_em)

## Constraints
- PRIMARY KEY: id_consumo
- UNIQUE: uk_painel_consumo

## Relacionamentos e Cardinalidade
- N:1 com local_operacional: Muitos consumos podem estar associados a um local operacional
- N:1 com saas_entidade: Muitos consumos pertencem a uma entidade

## Dependências
- Esta tabela depende de: saas_entidade
- Não há tabelas que dependem desta tabela

## Fluxo de utilização dentro do sistema
Utilizada para sincronização entre múltiplos painéis e o sistema de eventos. Quando um painel consome um evento (ex: chamada de senha), o registro é criado aqui. Antes de processar um evento, o sistema verifica se já foi consumido pelo painel atual. Permite que diferentes painéis consumam eventos independentemente, sem duplicação.
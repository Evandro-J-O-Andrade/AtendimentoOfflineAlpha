# painel_mensagem_consumo

Objetivo: Registrar o consumo de mensagens por painéis (auditoria).
Descrição: Tabela de auditoria que registra quando cada painel consome/exibe uma mensagem, garantindo que mensagens não sejam exibidas repetidamente no mesmo painel.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_consumo | bigint | NOT NULL | - | Identificador único do consumo (chave primária, auto incremento) |
| id_mensagem | bigint | NOT NULL | - | ID da mensagem consumida |
| id_painel | bigint | NOT NULL | - | ID do painel que consumiu a mensagem |
| consumido_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data/hora em que a mensagem foi consumida |
| consumido_por | varchar(80) | YES | NULL | Nome do usuário ou sistema que consumiu a mensagem |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual o consumo pertence |

## Chaves
- Primária: id_consumo
- Únicas: uk_msg_consumo (id_mensagem, id_painel)
- Estrangeiras: 
  - fk_consumo_msg: id_mensagem → painel_mensagem (id_mensagem)
  - fk_consumo_painel: id_painel → painel (id_painel)

## Índices
- PRIMARY KEY (id_consumo)
- UNIQUE KEY uk_msg_consumo (id_mensagem, id_painel)
- KEY idx_consumo_painel (id_painel, consumido_em)

## Constraints
- PRIMARY KEY: id_consumo
- UNIQUE: uk_msg_consumo
- FOREIGN KEY: fk_consumo_msg
- FOREIGN KEY: fk_consumo_painel

## Relacionamentos e Cardinalidade
- N:1 com painel_mensagem: Muitos consumos pertencem a uma mensagem
- N:1 com painel: Muitos consumos pertencem a um painel

## Dependências
- Esta tabela depende de: painel_mensagem, painel, saas_entidade
- Não há tabelas que dependem desta tabela

## Fluxo de utilização dentro do sistema
Utilizada para controlar a exibição de mensagens nos painéis. Quando um painel exibe uma mensagem, um registro é criado aqui. Antes de exibir, o sistema verifica se o painel já consumiu a mensagem (via uk_msg_consumo). Permite que diferentes painéis consumam mensagens independentemente, sem duplicação.
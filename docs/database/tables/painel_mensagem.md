# painel_mensagem

Objetivo: Armazenar mensagens para exibição em painéis (alertas, avisos, chamadas).
Descrição: Tabela que gerencia mensagens que podem ser exibidas nos painéis, incluindo alertas, avisos gerais, chamadas para médicos e mensagens urgentes. Cada mensagem pode ter prioridade e data de expiração.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_mensagem | bigint | NOT NULL | - | Identificador único da mensagem (chave primária, auto incremento) |
| id_painel | bigint | NOT NULL | - | ID do painel ao qual a mensagem está vinculada |
| tipo | enum('ALERTA','CHAMAR_MEDICO','INFO','URGENTE') | NOT NULL | 'ALERTA' | Tipo da mensagem: alerta, chamada de médico, informação ou urgente |
| titulo | varchar(120) | YES | NULL | Título da mensagem para identificação rápida |
| texto | text | NOT NULL | - | Texto completo da mensagem |
| prioridade | int | NOT NULL | '0' | Nível de prioridade (valores maiores têm prioridade) |
| expira_em | datetime | YES | NULL | Data/hora de expiração da mensagem |
| ativo | tinyint(1) | NOT NULL | '1' | Flag indicando se a mensagem está ativa |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data/hora de criação da mensagem |
| criado_por | bigint | YES | NULL | ID do usuário que criou a mensagem |
| id_sessao_usuario | bigint | YES | NULL | ID da sessão do usuário durante a criação |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual a mensagem pertence |

## Chaves
- Primária: id_mensagem
- Únicas: (nenhuma)
- Estrangeiras: 
  - fk_msg_painel: id_painel → painel (id_painel)

## Índices
- PRIMARY KEY (id_mensagem)
- KEY idx_msg_painel (id_painel, ativo, criado_em)
- KEY idx_msg_expira (expira_em)

## Constraints
- PRIMARY KEY: id_mensagem
- FOREIGN KEY: fk_msg_painel

## Relacionamentos e Cardinalidade
- N:1 com painel: Muitas mensagens pertencem a um painel
- N:1 com usuario: Muitas mensagens podem ser criadas por um usuário
- N:1 com sessao_usuario: Muitas mensagens podem ter uma sessão associada

## Dependências
- Esta tabela depende de: painel, usuario, sessao_usuario, saas_entidade
- Tabelas que dependem desta: painel_mensagem_consumo

## Fluxo de utilização dentro do sistema
Utilizada para enviar mensagens para painéis, como chamadas de médicos, alertas sobre emergências, ou informações gerais. As mensagens com prioridade mais alta são exibidas primeiro. Mensagens podem ter data de expiração para desaparecerem automaticamente. O consumo é registrado em painel_mensagem_consumo para cada painel.
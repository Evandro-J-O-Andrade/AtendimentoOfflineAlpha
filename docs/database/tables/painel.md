# painel

Objetivo: Gerenciar os painéis de senhas e filas de atendimento (painel, totum, TV).
Descrição: Tabela que define os painéis de exibição de filas e senhas do sistema, podendo ser painéis de chamada, totens ou telas de TV. Cada painel está associado a uma unidade e pode ter configurações específicas.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_painel | bigint | NOT NULL | - | Identificador único do painel (chave primária, auto incremento) |
| codigo | varchar(50) | NOT NULL | - | Código único do painel para identificação |
| tipo | enum('PAINEL','TOTEM','TV') | NOT NULL | 'PAINEL' | Tipo de equipamento: painel de chamada, totum ou tela de TV |
| nome | varchar(120) | NOT NULL | - | Nome descritivo do painel |
| descricao | varchar(255) | YES | NULL | Descrição das funcionalidades do painel |
| id_unidade | bigint unsigned | NOT NULL | - | ID da unidade à qual o painel pertence |
| id_local_operacional | bigint | YES | NULL | ID do local operacional específico (opcional) |
| tts_habilitado | tinyint(1) | NOT NULL | '0' | Flag indicando se text-to-speech está habilitado |
| piscada_seg | int | NOT NULL | '20' | Tempo em segundos entre atualizações da exibição |
| ativo | tinyint(1) | NOT NULL | '1' | Flag de status: se o painel está ativo |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data/hora de criação do painel |
| atualizado_em | datetime | YES | NULL | Data/hora da última atualização |
| intervalo_segundos | int | NOT NULL | '120' | Intervalo em segundos entre atualizações |
| id_sistema | bigint | YES | NULL | ID do sistema associado ao painel |
| id_entidade | bigint unsigned | YES | NULL | ID da entidade/tenant à qual o painel pertence |

## Chaves
- Primária: id_painel
- Únicas: uk_painel_codigo (codigo)
- Estrangeiras: 
  - fk_painel_unidade: id_unidade → unidade (id_unidade)

## Índices
- PRIMARY KEY (id_painel)
- UNIQUE KEY uk_painel_codigo (codigo)
- KEY idx_painel_unidade (id_unidade)
- KEY idx_painel_local (id_local_operacional)

## Constraints
- PRIMARY KEY: id_painel
- UNIQUE: uk_painel_codigo
- FOREIGN KEY: fk_painel_unidade

## Relacionamentos e Cardinalidade
- N:1 com unidade: Muitos painéis pertencem a uma unidade
- 1:N com painel_config: Um painel pode ter muitas configurações
- 1:N com painel_fila_tipo: Um painel pode monitorar muitos tipos de fila
- 1:N com painel_local: Um painel pode estar associado a muitos locais operacionais
- 1:N com painel_lane: Um painel pode ter muitas lanes (filas)
- 1:N com painel_mensagem: Um painel pode exibir muitas mensagens

## Dependências
- Esta tabela depende de: unidade
- Tabelas que dependem desta: painel_config, painel_fila_tipo, painel_local, painel_lane, painel_mensagem

## Fluxo de utilização dentro do sistema
Utilizada para cadastrar e configurar os dispositivos de exibição de senhas e filas. Cada painel é definido com seu tipo, unidade e local. As configurações são armazenadas em painel_config e as filas monitoradas em painel_fila_tipo. Permite personalizar a experiência de exibição para cada tipo de equipamento.
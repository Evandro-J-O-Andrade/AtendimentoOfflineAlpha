# atendimento_evento_ledger

Objetivo: Registrar o ledger (livro razão) de eventos de atendimento, mantendo histórico completo de transações, estados e auditoria para fins de consistência e recuperação.

Descrição: Esta tabela implementa um ledger completo para eventos de atendimento, registrando todas as transações com UUID, sequência, usuário, sessão, perfil, ação, módulo, estados antes e depois, payloads originais e processados, para garantir rastreabilidade total e consistência eventual em sistemas distribuídos.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_evento | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do evento no ledger |
| uuid_transacao | char(36) | NOT NULL | - | UUID único da transação para rastreamento global |
| uuid_transacao_pai | char(36) | YES | NULL | UUID da transação pai (para rastrear encadeamento) |
| sequencia_evento | int | NOT NULL | - | Número de sequência do evento para ordenação cronológica |
| id_usuario | bigint | NOT NULL | - | Identificador do usuário que realizou a ação |
| id_sessao | bigint | NOT NULL | - | Identificador da sessão do usuário no momento da transação |
| id_perfil | bigint | NOT NULL | - | Identificador do perfil do usuário que realizou a ação |
| nome_usuario | varchar(100) | YES | NULL | Nome do usuário para auditoria humana |
| acao | varchar(100) | NOT NULL | - | Ação realizada (ex: CRIAR, ATUALIZAR, DELETAR, FINALIZAR) |
| modulo | varchar(50) | NOT NULL | - | Módulo do sistema onde a ação ocorreu |
| sub_modulo | varchar(50) | YES | NULL | Submódulo específico dentro do módulo |
| estado_origem | varchar(50) | YES | NULL | Estado anterior dos dados antes da ação |
| estado_destino | varchar(50) | YES | NULL | Estado posterior dos dados após a ação |
| estado_anterior | json | YES | NULL | Payload JSON do estado anterior para recuperação |
| estado_novo | json | YES | NULL | Payload JSON do estado novo para recuperação |
| payload_original | json | YES | NULL | Payload original enviado na requisição |
| payload_processado | json | YES | NULL | Payload após processamento pela regra/regra de negócio |
| id_atendimento | bigint unsigned | NOT NULL | - | Chave estrangeira que referencia o atendimento ao qual o evento pertence |
| status_evento | enum('SUCESSO','ERRO','AVISO','CANCELADO','ROLLBACK') | NOT NULL | 'SUCESSO' | Status do evento: sucesso, erro, aviso, cancelado ou rollback |
| codigo_erro | varchar(50) | YES | NULL | Código do erro ocorrido (quando status = ERRO) |
| mensagem | varchar(1000) | YES | NULL | Mensagem detalhada sobre o evento ou erro |
| ip_origem | varchar(45) | YES | NULL | Endereço IP de origem da requisição |
| user_agent | varchar(500) | YES | NULL | User agent do navegador/dispositivo utilizado |
| hostname | varchar(100) | YES | NULL | Nome do host/servidor que processou o evento |
| processing_time_ms | int | YES | NULL | Tempo de processamento em milissegundos |
| created_at | datetime(6) | NOT NULL | CURRENT_TIMESTAMP(6) | Timestamp automático da data/hora de criação do registro |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o evento pertence |

## Chaves
- Primária: id_evento
- Únicas: Nenhuma definida explícita (uuid_transacao também deve ser único)
- Estrangeiras: Nenhuma definida explícita (aparentemente sem FK)

## Índices
- Nenhum índice adicional definido

## Constraints
- Nenhuma constraint adicional definida

## Relacionamentos e Cardinalidade
- N:1 com atendimento - Cada evento no ledger está associado a um atendimento
- N:1 com saas_entidade - Cada evento pertence a uma entidade SaaS

## Dependências
- Tabelas que dependem desta: Nenhuma (não há FK apontando para atendimento_evento_ledger)
- Tabelas das quais esta depende: atendimento, saas_entidade (implicito via id_atendimento)

## Fluxo de utilização dentro do sistema
- Ledger completo de todas as transações durante atendimento
- UUIDs para rastreamento global de transações e encadeamento
- Sequencialização para ordenação cronológica dos eventos
- Auditoria completa com IP, user agent, hostname e tempo de processamento
- Estados antes/depois e payloads para recuperação e replay
- Status do evento para identificação de problemas (ERRO, AVISO, ROLLBACK)
- Código e mensagem de erro para diagnóstico de falhas
- Módulos e submódulos para categorização da ação
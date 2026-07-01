# runtime_concurrency_guard

Objetivo: Controlar a concorrência de execução de eventos em domínios de fluxo, prevenindo condições de corrida e conflitos.

Descrição: Tabela que implementa mecanismo de guarda de concorrência para eventos em runtime, permitindo controle de execução concorrente com tokens, versões de estado e status de confirmação.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_guard | bigint | NOT NULL | - | Chave primária da tabela, identificador único da guarda de concorrência |
| dominio_fluxo | varchar(50) | NOT NULL | - | Domínio de fluxo ao qual a guarda se aplica |
| id_recurso | varchar(100) | NOT NULL | - | Identificador do recurso ao qual a guarda se aplica |
| versao_estado | bigint | NOT NULL | - | Versão do estado do recurso para detecção de mudanças |
| token_execucao | char(36) | NOT NULL | - | Token único que identifica a execução concorrente |
| hash_contexto | char(64) | NOT NULL | - | Hash do contexto de execução para verificação |
| status_guard | enum('PROVISIONAL','CONFIRMADO','REJEITADO','CONFLITO') | - | 'PROVISIONAL' | Status da guarda: PROVISIONAL, CONFIRMADO, REJEITADO ou CONFLITO |
| criado_em | datetime(6) | - | CURRENT_TIMESTAMP(6) | Data e hora de criação da guarda |
| confirmado_em | datetime(6) | YES | NULL | Data e hora de confirmação da execução |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde a guarda ocorre |

## Chaves
- Primária: id_guard
- Únicas: uk_guard_concurrency (dominio_fluxo, id_recurso, versao_estado, token_execucao)
- Estrangeiras: -

## Índices
- PRIMARY KEY (id_guard)
- UNIQUE KEY uk_guard_concurrency (dominio_fluxo, id_recurso, versao_estado, token_execucao)
- KEY idx_guard_status (status_guard)

## Constraints
- -

## Relacionamentos e Cardinalidade
- -

## Dependências
- Tabelas que dependem desta: -
| Esta tabela depende de: -

## Fluxo de utilização dentro do sistema
- Criado como lock de concorrência quando evento é executado
- Previne execuções simultâneas no mesmo recurso
- Status confirmação permite commit ou rollback da execução
- Hash do contexto detecta alterações concorrentes
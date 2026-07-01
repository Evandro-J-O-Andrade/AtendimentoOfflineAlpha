# remocao_logistica

Objetivo: Gerenciar a logística de remoções de pacientes com foco em recursos humanos e informações de transporte.

Descrição: Tabela que armazena informações logísticas específicas para remoções de pacientes, incluindo nomes dos profissionais (motorista e técnico) e status da remoção.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_remocao | bigint | NOT NULL | - | Chave primária da tabela, identificador único da remoção logística |
| id_ffa | bigint | NOT NULL | - | Referência ao id da ficha de atendimento assistido sendo removido |
| id_atendimento | bigint unsigned | NOT NULL | - | Referência ao id do atendimento associado à remoção |
| motorista_nome | varchar(100) | YES | NULL | Nome do motorista responsável pela remoção |
| tecnico_nome | varchar(100) | YES | NULL | Nome do técnico ou auxiliar que acompanha a remoção |
| destino | varchar(255) | NOT NULL | - | Local de destino da remoção |
| status | enum('PENDENTE','EM_REMOCAO','CONCLUIDO') | - | 'PENDENTE' | Status da remoção: PENDENTE, EM_REMOCAO ou CONCLUIDO |
| data_saida | datetime | YES | NULL | Data e hora de saída do paciente na remoção |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde a remoção foi solicitada |

## Chaves
- Primária: id_remocao
- Únicas: -
- Estrangeiras: -

## Índices
- PRIMARY KEY (id_remocao)
- KEY fk_rem_ffa_heranca (id_ffa)
- KEY fk_rem_atend_heranca (id_atendimento)

## Constraints
- -

## Relacionamentos e Cardinalidade
- N:1 com ffa (uma FFA pode ter informações de logística de remoção)
- N:1 com atendimento (um atendimento pode ter informações de remoção)

## Dependências
- Tabelas que dependem desta: -
| Esta tabela depende de: ffa, atendimento

## Fluxo de utilização dentro do sistema
- Complementa a tabela remocao com informações de logística
- Permite registrar nomes dos profissionais diretamente
- Controla status da remoção para acompanhamento
- Integrado ao módulo de transporte e remoção
# atendimento_estado_ativo

Objetivo: Registrar o estado ativo atual de uma FFA no atendimento, controlando local atual, leito e tipo de estado do fluxo assistencial.

Descrição: Esta tabela mantém o estado ativo atual de FFAs (Fichas de Atendimento) no sistema assistencial, permitindo o rastreamento em tempo real da posição do paciente no fluxo (fila de espera, triagem, atendimento médico, observação, internação, exame, alta, evasão) com vinculação a sessão do último movimento.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_ffa | bigint | NOT NULL | - | Identificador único da FFA (Ficha de Atendimento) - também é a chave primária |
| id_local_atual | bigint | NOT NULL | - | Chave estrangeira que referencia o local operacional atual onde a FFA se encontra |
| id_leito | bigint | YES | NULL | Identificador do leito onde o paciente está internado (quando aplicável) |
| tipo_estado | enum('FILA_ESPERA','TRIAGEM','ATENDIMENTO_MEDICO','OBSERVACAO','INTERNACAO','EXAME','ALTA','EVASAO') | NOT NULL | - | Tipo de estado atual no fluxo: fila de espera, triagem, atendimento médico, observação, internação, exame, alta ou evasão |
| id_sessao_ultimo_movimento | bigint | NOT NULL | - | Identificador da sessão do usuário no último movimento da FFA |
| atualizado_em | timestamp | YES | NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP | Timestamp automático de atualização do estado (com atualização automática) |
| id_atendimento | bigint unsigned | NOT NULL | - | Chave estrangeira que referencia o atendimento ao qual o estado pertence |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o estado pertence |

## Chaves
- Primária: id_ffa
- Únicas: Nenhuma
- Estrangeiras: fk_estado_local - id_local_atual → local_operacional(id_local_operacional) - Vincula o estado ao local operacional; fk_atendimento_estado_ativo_atendimento - id_atendimento → atendimento(id_atendimento) - Vincula o estado ao atendimento; fk_atendimento_estado_ativo_entidade - id_entidade → saas_entidade(id_entidade) - Vincula o estado à entidade |

## Índices
- fk_estado_local (KEY) - Índice para busca por local operacional
- fk_estado_sessao (KEY) - Índice para busca por sessão
- fk_atendimento_estado_ativo_atendimento (KEY) - Índice para busca por atendimento
- idx_aest_ent (KEY) - Índice para busca por entidade

## Constraints
- fk_atendimento_estado_ativo_atendimento - FOREIGN KEY - Restringe id_atendimento à tabela atendimento(id_atendimento) com CASCADE
- fk_atendimento_estado_ativo_entidade - FOREIGN KEY - Restringe id_entidade à tabela saas_entidade(id_entidade)
- fk_estado_local - FOREIGN KEY - Restringe id_local_atual à tabela local_operacional(id_local_operacional)

## Relacionamentos e Cardinalidade
- 1:1 com atendimento - Cada atendimento tem um estado ativo único
- N:1 com local_operacional - Cada estado refere-se a um local operacional específico
- N:1 com saas_entidade - Cada estado pertence a uma entidade SaaS
- N:1 com leito - Cada estado pode ter um leito associado (opcional)

## Dependências
- Tabelas que dependem desta: assistantencial_checkpoint_global (via id_ffa), assistencial_snapshot_runtime (via id_ffa), assistencial_quorum_clinico (via id_ffa), assistencial_raim_metric (via id_ffa)
- Tabelas das quais esta depende: atendimento, local_operacional, saas_entidade

## Fluxo de utilização dentro do sistema
- Rastreamento em tempo real da posição do paciente no fluxo assistencial
- Estados pré-definidos do fluxo: fila, triagem, atendimento, observação, internação, exame, alta, evasão
- Vinculação ao local operacional atual para identificação precisa
- Última sessão registrada para auditoria do último movimento
- Cascade delete remove estado quando atendimento é excluído
- Atualização automática do timestamp para controle de mudanças
# atendimento_evento

Objetivo: Registrar eventos ocorridos durante atendimentos, permitindo o histórico completo de mudanças de estado, ações e contextos no ciclo de vida do atendimento.

Descrição: Esta tabela mantém um log completo de eventos durante atendimentos médicos, registrando mudanças de estado, domínio, tipo de evento, contexto do fluxo, payload JSON com dados completos e auditoria com sessão e usuário responsável.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_evento | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do evento de atendimento |
| id_unidade | bigint unsigned | NOT NULL | - | Identificador da unidade onde o evento ocorreu |
| id_ffa | bigint | YES | NULL | Identificador da FFA (Ficha de Atendimento) ao qual o evento pertence |
| id_atendimento | bigint unsigned | NOT NULL | - | Chave estrangeira que referencia o atendimento ao qual o evento pertence |
| id_paciente | bigint | YES | NULL | Identificador do paciente envolvido no evento |
| dominio | varchar(40) | NOT NULL | - | Domínio/classificação do evento (ex: CLINICO, ADMINISTRATIVO, OPERACIONAL) |
| tipo_evento | varchar(60) | NOT NULL | - | Tipo específico do evento ocorrido |
| estado_origem | varchar(40) | YES | NULL | Estado anterior do atendimento antes do evento |
| estado_destino | varchar(40) | YES | NULL | Estado posterior do atendimento após o evento |
| contexto_fluxo | varchar(60) | YES | NULL | Contexto do fluxo em que o evento ocorreu |
| payload | json | YES | NULL | Payload JSON com dados completos do evento para persistência |
| id_sessao_usuario | bigint | YES | NULL | Identificador da sessão do usuário no momento do evento |
| id_usuario | bigint | YES | NULL | Identificador do usuário que executou o evento |
| hash_evento | char(64) | YES | NULL | Hash do evento para verificação de integridade e detecção de duplicação |
| criado_em | datetime(6) | YES | CURRENT_TIMESTAMP(6) | Timestamp automático da data/hora de criação do evento |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o evento pertence |

## Chaves
- Primária: id_evento
- Únicas: Nenhuma
- Estrangeiras: fk_aevt_unid - id_unidade → unidade(id_unidade) - Vincula o evento à unidade; fk_atendimento_evento_atendimento - id_atendimento → atendimento(id_atendimento) - Vincula o evento ao atendimento; fk_atendimento_evento_entidade - id_entidade → saas_entidade(id_entidade) - Vincula o evento à entidade |

## Índices
- idx_evento_ffa (KEY) - Índice para busca por FFA
- idx_evento_atendimento (KEY) - Índice para busca por atendimento
- idx_evento_paciente (KEY) - Índice para busca por paciente
- idx_evento_dominio (KEY) - Índice para busca por domínio
- idx_evento_tipo (KEY) - Índice para busca por tipo de evento
- idx_evento_tempo (KEY) - Índice para busca por data de criação
- idx_evento_sessao (KEY) - Índice para busca por sessão
- idx_evento_hash (KEY) - Índice para busca por hash do evento
- fk_aevt_unid (KEY) - Índice para busca por unidade
- fk_atendimento_evento_entidade (KEY) - Índice para busca por entidade

## Constraints
- fk_aevt_unid - FOREIGN KEY - Restringe id_unidade à tabela unidade(id_unidade)
- fk_atendimento_evento_atendimento - FOREIGN KEY - Restringe id_atendimento à tabela atendimento(id_atendimento) com CASCADE
- fk_atendimento_evento_entidade - FOREIGN KEY - Restringe id_entidade à tabela saas_entidade(id_entidade)

## Relacionamentos e Cardinalidade
- N:1 com unidade - Cada evento ocorre em uma unidade
- N:1 com atendimento - Cada evento pertence a um atendimento (com CASCADE)
- N:1 com saas_entidade - Cada evento pertence a uma entidade SaaS
- N:1 com paciente - Cada evento pode ter um paciente associado (opcional)
- N:1 com usuario - Cada evento pode ter um usuário (opcional)
- N:1 com sessao_usuario - Cada evento pode ter uma sessão (opcional)

## Dependências
- Tabelas que dependem desta: atendimento_evento_ledger (registra eventos em ledger), Nenhuma outra tabela possui FK direta
- Tabelas das quais esta depende: unidade, atendimento, saas_entidade

## Fluxo de utilização dentro do sistema
- Registro automático de todos os eventos durante o atendimento
- Mudanças de estado (estado_origem → estado_destino) para rastreamento
- Domínios e tipos diferenciados para classificação de eventos
- Payload JSON completo para persistência de dados do evento
- Hash para verificação de integridade e prevenção de duplicação
- Índices múltiplos para busca eficiente por diferentes dimensões
- Cascade delete remove eventos quando atendimento é excluído
# atendimento

Objetivo: Registrar e centralizar todas as informações de atendimentos médicos, controlando o ciclo de vida completo do atendimento desde sua criação até sua finalização.

Descrição: Esta tabela é o núcleo central do sistema assistencial, armazenando todas as informações essenciais sobre atendimentos médicos incluindo tipo, modo de entrada, status de execução, profissional responsável, informações de sincronização e controle de exclusão lógica.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_atendimento | bigint unsigned | NOT NULL | AUTO_INCREMENT | Identificador único do atendimento no sistema |
| id_saas_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade SaaS à qual o atendimento pertence |
| id_unidade | bigint unsigned | NOT NULL | - | Identificador da unidade onde o atendimento está sendo realizado |
| id_ffa | bigint unsigned | NOT NULL | - | Chave estrangeira que referencia a FFA (Ficha de Atendimento) associada |
| id_profissional_responsavel | bigint unsigned | YES | NULL | Identificador do profissional (usuário) responsável pelo atendimento |
| tipo_atendimento | enum('AMBULATORIAL','URGENCIA','ELETIVO','UBS','FARMACIA','TELEMEDICINA','SAMU','REMOCAO') | NOT NULL | - | Tipo de atendimento: ambulatorial, urgência, eletivo, UBS, farmácia, telemedicina, SAMU ou remoção |
| modo_entrada | enum('LOCAL','SAMU','REGULADO','TRANSFERENCIA','CONVENIO') | NOT NULL | 'LOCAL' | Modo de entrada do paciente: local, SAMU, regulado, transferência ou convênio |
| status_execucao | enum('INICIADO','EM_CURSO','PAUSADO','CONCLUIDO','CANCELADO') | NOT NULL | 'INICIADO' | Status de execução do atendimento: iniciado, em curso, pausado, concluído ou cancelado |
| id_faturamento_guia | varchar(50) | YES | NULL | Identificador da guia de faturamento (convênio/operadora) |
| id_sessao_usuario_criacao | bigint unsigned | YES | NULL | Identificador da sessão do usuário no momento da criação do atendimento |
| id_sessao_usuario_alteracao | bigint unsigned | YES | NULL | Identificador da sessão do usuário no momento da última alteração |
| uuid_sync | char(36) | NOT NULL | - | UUID para sincronização entre sistemas distribuídos |
| versao_sync | bigint unsigned | YES | '0' | Versão do registro para controle de conflitos em sincronização |
| hash_estado | char(64) | YES | NULL | Hash do estado atual do atendimento para verificação de integridade |
| criado_em | datetime(6) | NOT NULL | CURRENT_TIMESTAMP(6) | Timestamp automático da data/hora de criação do atendimento |
| atualizado_em | datetime(6) | YES | NULL ON UPDATE CURRENT_TIMESTAMP(6) | Timestamp automático de atualização do atendimento |
| finalizado_em | datetime(6) | YES | NULL | Timestamp da data/hora de finalização do atendimento |
| removido_em | datetime(6) | YES | NULL | Timestamp da data/hora de remoção/exclusão lógica do atendimento |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o atendimento pertence |

## Chaves
- Primária: id_atendimento
- Únicas: Nenhuma definida explícita
- Estrangeiras: fk_atendimento_entidade - id_entidade → saas_entidade(id_entidade) - Vincula o atendimento à entidade; fk_atendimento_ffa - id_ffa → ffa(id_ffa) - Vincula o atendimento à FFA; fk_atendimento_unidade - id_unidade → unidade(id_unidade) - Vincula o atendimento à unidade

## Índices
- idx_atendimento_ffa (KEY) - Índice para busca por FFA
- idx_atendimento_saas_unidade (KEY) - Índice composto por id_saas_entidade e id_unidade
- idx_atendimento_status_execucao (KEY) - Índice para busca por status de execução
- fk_atendimento_unidade (KEY) - Índice para busca por unidade
- idx_atendimento_entidade (KEY) - Índice para busca por entidade

## Constraints
- fk_atendimento_entidade - FOREIGN KEY - Restringe id_entidade à tabela saas_entidade(id_entidade)
- fk_atendimento_ffa - FOREIGN KEY - Restringe id_ffa à tabela ffa(id_ffa)
- fk_atendimento_unidade - FOREIGN KEY - Restringe id_unidade à tabela unidade(id_unidade)

## Relacionamentos e Cardinalidade
- N:1 com saas_entidade - Cada atendimento pertence a uma entidade SaaS
- N:1 com unidade - Cada atendimento ocorre em uma unidade
- N:1 com ffa - Cada atendimento está associado a uma FFA (Ficha de Atendimento)
- N:1 com usuario (profissional) - Cada atendimento pode ter um profissional responsável (opcional)
- 1:N com atendimento_anamnese - Um atendimento pode ter uma ou mais anamneses
- 1:N com atendimento_evolucao - Um atendimento pode ter múltiplas evoluções
- 1:N com atendimento_prescricao - Um atendimento pode ter múltiplas prescrições
- 1:N com atendimento_evento - Um atendimento pode ter múltiplos eventos
- 1:1 com atendimento_recepcao - Cada atendimento pode ter um registro de recepção
- 1:1 com atendimento_estado_ativo - Cada atendimento tem um estado ativo

## Dependências
- Tabelas que dependem desta: atendimento_anamnese, atendimento_balanco_hidrico, atendimento_checagem, atendimento_desfecho, atendimento_diagnostico, atendimento_escalas_risco, atendimento_estado_ativo, atendimento_evento, atendimento_evento_ledger, atendimento_evolucao, atendimento_exame_fisico, atendimento_identidade_fluxo, atendimento_movimentacao, atendimento_observacao, atendimento_pedidos_exame, atendimento_pre_hospitalar, atendimento_prescricao, atendimento_profissional, atendimento_recepcao, atendimento_sinais_vitais, assistencial_checkpoint_global, assistencial_runtime_federado, assistencial_runtime_panel, assistencial_simulacao_futura, assistencial_snapshot_runtime, assistencial_telemetria_runtime, assistencial_watchdog_fila
- Tabelas das quais esta depende: saas_entidade, unidade, ffa, usuario

## Fluxo de utilização dentro do sistema
- Criação de atendimento ao início do ciclo de atendimento médico
- Controle de status de execução desde início até conclusão/cancelamento
- Tipos de atendimento diferenciados para rotas de trabalho específicas
- Modos de entrada para identificação do fluxo de admissão
- UUID e versão para sincronização entre sistemas federados
- Hash de estado para detecção de mudanças e integridade
- Exclusão lógica via removido_em ao invés de DELETE físico
- Índices para busca eficiente por FFA, status e unidade
# internacao_medicacao_administracao

Objetivo: Registrar administração de medicamentos durante internação.

Descrição: Tabela que controla a administração de medicamentos prescritos em internação, registrando dose aplicada, via, status e responsável. Utilizada para rastrear o cumprimento da prescrição.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_internacao_medicacao_administracao | bigint | NOT NULL | - | Identificador único da administração, chave primária auto incrementada |
| id_internacao | bigint | NOT NULL | - | Referência à internação onde a medicação foi administrada |
| id_internacao_prescricao_item | bigint | NOT NULL | - | Referência ao item de prescrição internação |
| data_hora | datetime | NOT NULL DEFAULT | CURRENT_TIMESTAMP | Data e hora da administração |
| status | enum('ADMINISTRADO','RECUSADO','SUSPENSO','NAO_DISPONIVEL') | NOT NULL | 'ADMINISTRADO' | Status da administração: administrado, recusado, suspenso ou não disponível |
| dose_aplicada | varchar(60) | DEFAULT NULL | - | Dose aplicada do medicamento (pode diferir da prescrita) |
| via_administracao | varchar(60) | DEFAULT NULL | - | Via de administração (oral, intravenosa, tópica, etc) |
| observacoes | text | DEFAULT NULL | - | Observações sobre a administração |
| id_usuario_responsavel | bigint | NOT NULL | - | Referência ao usuário que administrou a medicação |
| id_sessao_usuario | bigint | DEFAULT NULL | - | Referência à sessão do usuário que administrou |
| criado_em | datetime | NOT NULL DEFAULT | CURRENT_TIMESTAMP | Data e hora de criação do registro |
| id_atendimento | bigint unsigned | NOT NULL | - | Referência ao atendimento principal |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id_internacao_medicacao_administracao
- Únicas: -
- Estrangeiras: fk_ima_internacao (id_internacao → internacao.id_internacao); fk_ima_item (id_internacao_prescricao_item → internacao_prescricao_item.id_internacao_prescricao_item); fk_ima_usuario (id_usuario_responsavel → usuario.id_usuario); fk_internacao_medicacao_administracao_atendimento (id_atendimento → atendimento.id_atendimento ON DELETE CASCADE ON UPDATE CASCADE)

## Índices
- idx_ima_internacao (id_internacao)
- idx_ima_item (id_internacao_prescricao_item)
- idx_ima_data_hora (data_hora)
- idx_ima_usuario (id_usuario_responsavel)
- idx_ima_sessao (id_sessao_usuario)
- fk_internacao_medicacao_administracao_atendimento (id_atendimento)
- idx_int_med_ent (id_entidade)

## Constraints
- CONSTRAINT fk_ima_internacao FOREIGN KEY (id_internacao) REFERENCES internacao (id_internacao)
- CONSTRAINT fk_ima_item FOREIGN KEY (id_internacao_prescricao_item) REFERENCES internacao_prescricao_item (id_internacao_prescricao_item)
- CONSTRAINT fk_ima_usuario FOREIGN KEY (id_usuario_responsavel) REFERENCES usuario (id_usuario)
- CONSTRAINT fk_internacao_medicacao_administracao_atendimento FOREIGN KEY (id_atendimento) REFERENCES atendimento (id_atendimento) ON DELETE CASCADE ON UPDATE CASCADE
- CONSTRAINT fk_internacao_medicacao_administracao_entidade FOREIGN KEY (id_entidade) REFERENCES saas_entidade (id_entidade)

## Relacionamentos e Cardinalidade
- internacao_medicacao_administracao.id_internacao → internacao (id_internacao): N:1
- internacao_medicacao_administracao.id_internacao_prescricao_item → internacao_prescricao_item (id_internacao_prescricao_item): N:1
- internacao_medicacao_administracao.id_atendimento → atendimento (id_atendimento): N:1

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: internacao, internacao_prescricao_item, usuario, atendimento, saas_entidade

## Fluxo de utilização dentro do sistema
1. Médico prescreve medicamento em internacao_prescricao
2. Item de prescrição é criado em internacao_prescricao_item
3. Enfermeiro administra medicação e registra em administracao
4. dose_aplicada e via_administracao são preenchidos
5. Status muda conforme: ADMINISTRADO, RECUSADO (paciente recusou), SUSPENSO (suspenso) ou NAO_DISPONIVEL
6. ON DELETE CASCADE mantém consistência com atendimento
7. Permite auditoria completa de medicação hospitalar
# reabertura_atendimento

Objetivo: Registrar a reabertura de episódios ou atendimentos encerrados, permitindo nova continuidade do tratamento.

Descrição: Tabela que controla a reabertura de atendimentos que já foram encerrados, permitindo que o episódio clínico seja retomado com nova data, motivo e vínculo com atendimento original.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_reabertura | bigint | NOT NULL | - | Chave primária da tabela, identificador único da reabertura |
| id_ffa | bigint | NOT NULL | - | Referência ao id da ficha de atendimento assistido relacionada à reabertura |
| motivo | varchar(255) | NOT NULL | - | Motivo da reabertura do atendimento |
| id_usuario | bigint | NOT NULL | - | Referência ao id do usuário que solicitou a reabertura |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data e hora de criação do registro de reabertura |
| id_atendimento | bigint unsigned | NOT NULL | - | Referência ao id do atendimento onde a reabertura ocorreu |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde a reabertura foi registrada |

## Chaves
- Primária: id_reabertura
- Únicas: -
- Estrangeiras: fk_reabertura_atendimento_atendimento (id_atendimento → atendimento.id_atendimento) - vincula a reabertura ao atendimento; fk_reabertura_atendimento_entidade (id_entidade → saas_entidade.id_entidade) - vincula a reabertura à entidade

## Índices
- PRIMARY KEY (id_reabertura)
- KEY idx_ffa (id_ffa)
- KEY fk_reabertura_atendimento_atendimento (id_atendimento)
- KEY idx_reab_ent (id_entidade)

## Constraints
- CONSTRAINT fk_reabertura_atendimento_atendimento FOREIGN KEY (id_atendimento) REFERENCES atendimento (id_atendimento) ON DELETE CASCADE ON UPDATE CASCADE
- CONSTRAINT fk_reabertura_atendimento_entidade FOREIGN KEY (id_entidade) REFERENCES saas_entidade (id_entidade)

## Relacionamentos e Cardinalidade
- N:1 com atendimento (um atendimento pode ter várias reaberturas)
- N:1 com saas_entidade (uma entidade pode ter várias reaberturas)

## Dependências
- Tabelas que dependem desta: -
| Esta tabela depende de: atendimento, saas_entidade

## Fluxo de utilização dentro do sistema
- Registrado quando um atendimento precisa ser reaberto após encerramento
- Vinculado ao atendimento existente para retomada do tratamento
- Permite identificar o responsável pela reabertura
- Controla motivos para análise de reaberturas repetidas
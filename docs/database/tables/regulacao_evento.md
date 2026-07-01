# regulacao_evento

Objetivo: Gerenciar eventos de regulação de atendimentos, como solicitações de autorização, transferências e análise de regulacao.

Descrição: Tabela que controla o processo de regulação assistencial, permitindo acompanhar solicitações de autorização, análise de documentos e transferências de pacientes entre unidades.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_regulacao | bigint unsigned | NOT NULL | - | Chave primária da tabela, identificador único do evento de regulação |
| id_unidade | bigint unsigned | NOT NULL | - | Referência ao id da unidade solicitante da regulação |
| id_ffa | bigint unsigned | NOT NULL | - | Referência ao id da ficha de atendimento assistido sendo regulada |
| status | enum('SOLICITADO','EM_ANALISE','AUTORIZADO','NEGADO','TRANSFERIDO') | NOT NULL | - | Status da regulação: SOLICITADO, EM_ANALISE, AUTORIZADO, NEGADO ou TRANSFERIDO |
| destino_unidade | bigint unsigned | YES | NULL | Referência ao id da unidade de destino se houver transferência |
| tipo_regulacao | varchar(50) | YES | NULL | Tipo da regulação (ex: internacao, exame, consulta) |
| observacao | text | YES | NULL | Observações sobre a regulação ou justificativa |
| criado_em | datetime(6) | - | CURRENT_TIMESTAMP(6) | Data e hora de criação do evento de regulação |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde a regulação ocorreu |

## Chaves
- Primária: id_regulacao
- Únicas: -
- Estrangeiras: fk_reg_ffa (id_ffa → ffa.id_ffa) - vincula a regulação à FFA; fk_regulacao_evento_entidade (id_entidade → saas_entidade.id_entidade) - vincula a regulação à entidade

## Índices
- PRIMARY KEY (id_regulacao)
- KEY idx_reg_ffa (id_ffa)
- KEY fk_regulacao_evento_entidade (id_entidade)

## Constraints
- CONSTRAINT fk_reg_ffa FOREIGN KEY (id_ffa) REFERENCES ffa (id_ffa)
- CONSTRAINT fk_regulacao_evento_entidade FOREIGN KEY (id_entidade) REFERENCES saas_entidade (id_entidade)

## Relacionamentos e Cardinalidade
- N:1 com ffa (uma FFA pode ter vários eventos de regulação)
- N:1 com saas_entidade (uma entidade pode ter vários eventos de regulação)

## Dependências
- Tabelas que dependem desta: -
| Esta tabela depende de: ffa, saas_entidade

## Fluxo de utilização dentro do sistema
- Criado quando uma solicitação de regulação é iniciada
- Permite acompanhar o status da análise e autorização
- Destino unidade usado para transferências
- Integrado ao processo de autorização de procedimentos
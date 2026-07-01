# reg_export_lote

Objetivo: Gerenciar lotes de exportação de dados para sistemas externos como SINAN, CAT, produção SUS e faturamento.

Descrição: Tabela que controla lotes de exportação de dados do sistema, permitindo agrupar registros para envio a órgãos externos com controle de status, protocolo e observações.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_export_lote | bigint | NOT NULL | - | Chave primária da tabela, identificador único do lote de exportação |
| tipo | enum('SINAN_EPIDEMIOLOGICA','SINAN_VIOLENCIA','CAT','PRODUCAO_SUS','FATURAMENTO','OUTRO') | NOT NULL | - | Tipo do lote: SINAN_EPIDEMIOLOGICA, SINAN_VIOLENCIA, CAT, PRODUCAO_SUS, FATURAMENTO ou OUTRO |
| competencia | char(6) | YES | NULL | Competência do lote no formato AAAAMM (ano e mês) |
| id_sessao_usuario | bigint | YES | NULL | Referência ao id da sessão do usuário que criou o lote |
| id_usuario_criador | bigint | YES | NULL | Referência ao id do usuário que criou o lote |
| id_unidade | bigint unsigned | NOT NULL | - | Referência ao id da unidade onde os dados foram gerados |
| id_local_operacional | bigint | YES | NULL | Referência ao id do local operacional onde os dados foram gerados |
| status | enum('ABERTO','GERADO','ENVIADO','ERRO','CONFIRMADO','CANCELADO') | NOT NULL | 'ABERTO' | Status do lote: ABERTO, GERADO, ENVIADO, ERRO, CONFIRMADO ou CANCELADO |
| protocolo_externo | varchar(80) | YES | NULL | Número do protocolo externo se houver integração |
| observacao | text | YES | NULL | Observações sobre o lote de exportação |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data e hora de criação do lote |
| atualizado_em | datetime | - | CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP | Data e hora da última atualização do lote |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde o lote foi criado |

## Chaves
- Primária: id_export_lote
- Únicas: -
- Estrangeiras: fk_reg_export_lote_unidade (id_unidade → unidade.id_unidade) - vincula o lote à unidade; fk_reg_lote_competencia (competencia → md_competencia.competencia) - vincula a competência ao cadastro; fk_reg_lote_local (id_local_operacional → local_atendimento.id_local) - vincula o local operacional; fk_reg_lote_usuario (id_usuario_criador → usuario.id_usuario) - identifica o usuário criador

## Índices
- PRIMARY KEY (id_export_lote)
- KEY idx_reg_lote_tipo_status (tipo, status)
- KEY idx_reg_lote_competencia (competencia)
- KEY idx_reg_lote_data (criado_em)
- KEY idx_reg_lote_sessao (id_sessao_usuario)
- KEY idx_reg_lote_usuario (id_usuario_criador)
- KEY idx_reg_lote_unidade_local (id_unidade, id_local_operacional)
- KEY fk_reg_lote_local (id_local_operacional)

## Constraints
- CONSTRAINT fk_reg_export_lote_unidade FOREIGN KEY (id_unidade) REFERENCES unidade (id_unidade)
- CONSTRAINT fk_reg_lote_competencia FOREIGN KEY (competencia) REFERENCES md_competencia (competencia)
- CONSTRAINT fk_reg_lote_local FOREIGN KEY (id_local_operacional) REFERENCES local_atendimento (id_local)
- CONSTRAINT fk_reg_lote_usuario FOREIGN KEY (id_usuario_criador) REFERENCES usuario (id_usuario)

## Relacionamentos e Cardinalidade
- N:1 com unidade (uma unidade pode ter vários lotes)
- N:1 com local_atendimento (um local pode ter vários lotes)
- N:1 com usuario (um usuário pode criar vários lotes)
- N:1 com md_competencia (uma competência pode ter vários lotes)

## Dependências
- Tabelas que dependem desta: reg_export_arquivo, reg_export_item
| Esta tabela depende de: unidade, local_atendimento, md_competencia, usuario

## Fluxo de utilização dentro do sistema
- Criado quando um novo lote de exportação é iniciado
- Agrupa itens para envio a órgãos externos
- Permite acompanhamento do status de processamento
- Competência permite agrupamento por período
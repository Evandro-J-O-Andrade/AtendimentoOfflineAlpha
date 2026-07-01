# produtividade_evento

Objetivo: Registrar eventos de produtividade dos profissionais em atendimentos, permitindo análise de produtividade por tipo de ação e unidade.

Descrição: Tabela que registra eventos de produtividade realizados por profissionais durante atendimentos, permitindo análise de produtividade por tipo de evento (início/fim de atendimento, evolução, prescrição, encaminhamento) e geração de relatórios de produtividade.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_evento | bigint | NOT NULL | - | Chave primária da tabela, identificador único do evento de produtividade |
| id_unidade | bigint unsigned | NOT NULL | - | Referência ao id da unidade onde o evento ocorreu |
| id_usuario | bigint | NOT NULL | - | Referência ao id do usuário profissional que realizou o evento |
| tipo | enum('INICIO_ATENDIMENTO','FIM_ATENDIMENTO','EVOLUCAO','PRESCRICAO','ENCAMINHAMENTO','OUTRO') | NOT NULL | - | Tipo do evento de produtividade |
| id_ffa | bigint | YES | NULL | Referência ao id da ficha de atendimento assistido se o evento está vinculado a uma FFA |
| id_senha | bigint | YES | NULL | Referência ao id da senha de atendimento se o evento está vinculado a uma senha |
| ocorrido_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data e hora em que o evento ocorreu |
| detalhe | varchar(255) | YES | NULL | Detalhes complementares sobre o evento |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde o evento ocorreu |

## Chaves
- Primária: id_evento
- Únicas: -
- Estrangeiras: fk_pe_user (id_usuario → usuario.id_usuario) - vincula o evento ao usuário; fk_produtividade_evento_unidade (id_unidade → unidade.id_unidade) - vincula o evento à unidade

## Índices
- PRIMARY KEY (id_evento)
- KEY idx_pe_user_time (id_usuario, ocorrido_em)
- KEY idx_pe_tipo_time (tipo, ocorrido_em)
- KEY fk_pe_unidade (id_unidade)

## Constraints
- CONSTRAINT fk_pe_user FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
- CONSTRAINT fk_produtividade_evento_unidade FOREIGN KEY (id_unidade) REFERENCES unidade (id_unidade)

## Relacionamentos e Cardinalidade
- N:1 com usuario (um usuário pode ter vários eventos de produtividade)
- N:1 com unidade (uma unidade pode ter vários eventos de produtividade)
- N:1 com ffa (uma FFA pode ter vários eventos de produtividade)
- N:1 com senha (uma senha pode ter vários eventos de produtividade)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: usuario, unidade

## Fluxo de utilização dentro do sistema
- Registrado automaticamente quando um profissional realiza ações produtivas
- Usado para relatórios de produtividade por período e unidade
- Permite análise de tempo de atendimento e distribuição de atividades
- Integrado ao sistema de gestão de desempenho
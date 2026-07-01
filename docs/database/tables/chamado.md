# chamado

Objetivo: Gerenciar chamados de suporte interno para diferentes áreas do sistema.
Descrição: Tabela que registra chamados de suporte para TI, manutenção, engenharia clínica e outras áreas, com prioridade, status e integração GLPI.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_chamado | bigint | NOT NULL | - | Identificador único do chamado, chave primária auto incrementada. |
| id_unidade | bigint unsigned | NOT NULL | - | Referência à unidade onde o chamado foi aberto. |
| id_sistema | bigint | NOT NULL | - | Referência ao sistema/módulo relacionado ao chamado. |
| area_responsavel | enum('TI','MANUTENCAO','ENG_CLINICA','GASOTERAPIA','OUTRA') | NOT NULL | - | Área responsável: TI, manutenção, engenharia clínica, gasoterapia ou outra. |
| prioridade | enum('BAIXA','MEDIA','ALTA','CRITICA') | NOT NULL | 'MEDIA' | Nível de prioridade: baixa, média, alta ou crítica. |
| status | enum('ABERTO','ENVIADO_GLPI','EM_ATENDIMENTO','AGUARDANDO','RESOLVIDO','CANCELADO') | NOT NULL | 'ABERTO' | Status atual: aberto, enviado GLPI, em atendimento, aguardando, resolvido ou cancelado. |
| titulo | varchar(150) | NOT NULL | - | Título resumido do chamado. |
| descricao | text | Nullable | - | Descrição detalhada do problema ou solicitação. |
| id_usuario_abertura | bigint | NOT NULL | - | Referência ao usuário que abriu o chamado. |
| id_usuario_atribuido | bigint | Nullable | - | Referência ao usuário atribuído para atender o chamado. |
| glpi_ticket_id | bigint | Nullable | - | ID do ticket no sistema GLPI externo. |
| criado_em | datetime | Nullable | CURRENT_TIMESTAMP | Timestamp de criação do chamado. |
| atualizado_em | datetime | Nullable | CURRENT_TIMESTAMP | Timestamp da última atualização. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) à qual o chamado pertence. |

## Chaves
- Primária: id_chamado
- Únicas: nenhuma
- Estrangeiras:
  - fk_ch_sistema: id_sistema → sistema (id_sistema)
  - fk_ch_user_abertura: id_usuario_abertura → usuario (id_usuario)
  - fk_ch_user_atr: id_usuario_atribuido → usuario (id_usuario)

## Índices
- PRIMARY KEY (id_chamado)
- KEY idx_ch_area_status (area_responsavel, status)
- KEY idx_ch_glpi (glpi_ticket_id)
- KEY fk_ch_unidade (id_unidade)
- KEY fk_ch_sistema (id_sistema)
- KEY fk_ch_user_abertura (id_usuario_abertura)
- KEY fk_ch_user_atr (id_usuario_atribuido)

## Constraints
- PRIMARY KEY: id_chamado
- FOREIGN KEY: fk_ch_sistema (id_sistema) REFERENCES sistema (id_sistema)
- FOREIGN KEY: fk_ch_user_abertura (id_usuario_abertura) REFERENCES usuario (id_usuario)
- FOREIGN KEY: fk_ch_user_atr (id_usuario_atribuido) REFERENCES usuario (id_usuario)

## Relacionamentos e Cardinalidade
- N:1 com unidade (id_unidade)
- N:1 com sistema (id_sistema)
- N:1 com usuario (id_usuario_abertura) - abridor
- N:1 com usuario (id_usuario_atribuido) - responsável (opcional)
- N:1 com saas_entidade (id_entidade)
- 1:N com chamado_evento (id_chamado) - um chamado pode ter muitos eventos

## Dependências
- Tabelas que dependem desta: chamado_evento
- Dependência desta tabela: unidade, sistema, usuario, saas_entidade

## Fluxo de utilização dentro do sistema
- Aberto por usuários para solicitações de suporte ou correção
- Integrado com GLPI via glpi_ticket_id para chamados de TI
- Atribuído a responsável para atendimento
- Atualizado conforme andamento do atendimento
- Cancelado ou resolvido ao final do processo
# auditoria_ffa

Objetivo: Registrar auditoria de eventos relacionados às FFAs (Fichas de Atendimento).
Descrição: Tabela que mantém log de todas as ações realizadas em FFAs, incluindo criação, alterações de status, chamadas médicas, solicitações de exames e internações.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id | bigint | NOT NULL | - | Identificador único do registro de auditoria, chave primária auto incrementada. |
| id_ffa | bigint | NOT NULL | - | Referência à FFA (Ficha de Atendimento) auditada. |
| id_usuario | bigint | NOT NULL | - | Referência ao usuário que realizou a ação. |
| tipo_evento | enum('CRIACAO','STATUS','LAYOUT','CHAMADA_MEDICA','SOLICITACAO_RX','SOLICITACAO_MEDICACAO','ALTA_MEDICA','TRANSFERENCIA','INTERNACAO') | NOT NULL | - | Tipo do evento: criação, mudança de status, layout, chamada médica, solicitação de RX, solicitação de medicação, alta médica, transferência ou internação. |
| acao | varchar(255) | NOT NULL | - | Descrição detalhada da ação realizada. |
| timestamp | datetime | NOT NULL | CURRENT_TIMESTAMP | Data e hora do evento registrado. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) à qual o registro pertence. |

## Chaves
- Primária: id
- Únicas: nenhuma
- Estrangeiras: nenhuma

## Índices
- PRIMARY KEY (id)
- KEY fk_auditoria_ffa_ffa (id_ffa)

## Constraints
- PRIMARY KEY: id

## Relacionamentos e Cardinalidade
- N:1 com FFA (id_ffa) - inferido
- N:1 com usuario (id_usuario) - inferido
- N:1 com saas_entidade (id_entidade)

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: FFA, usuario, saas_entidade (inferido)

## Fluxo de utilização dentro do sistema
- Registrada automaticamente em cada evento nas FFAs
- Permite rastrear histórico completo de uma FFA
- Usada para auditoria e análise de fluxo de atendimento
- Suporta tipos específicos de eventos do ciclo de vida da FFA
# rh_evento

Objetivo: Registrar eventos de recursos humanos como mudanças de vínculo, registros profissionais e outras ocorrências RH.

Descrição: Tabela que armazena eventos ocorridos no módulo de recursos humanos, permitindo auditoria de mudanças em vínculos, registros e outras ações de RH.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_evento | bigint | NOT NULL | - | Chave primária da tabela, identificador único do evento RH |
| id_rh_vinculo | bigint | YES | NULL | Referência ao id do vínculo de pessoa no RH |
| id_registro | bigint | YES | NULL | Referência ao id do registro profissional no evento |
| id_sessao_usuario | bigint | NOT NULL | - | Referência ao id da sessão do usuário que realizou o evento |
| evento | varchar(50) | NOT NULL | - | Tipo do evento RH realizado (ex: ADMISSAO, DEMISSAO, ALTERACAO) |
| detalhe | varchar(255) | YES | NULL | Detalhes complementares sobre o evento |
| payload_json | json | YES | NULL | Payload JSON com dados adicionais do evento |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data e hora de criação do evento |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde o evento ocorreu |

## Chaves
- Primária: id_evento
- Únicas: -
- Estrangeiras: -

## Índices
- PRIMARY KEY (id_evento)
- KEY ix_rh_evt_vinc (id_rh_vinculo)
- KEY ix_rh_evt_reg (id_registro)
- KEY ix_rh_evt_evt (evento)

## Constraints
- -

## Relacionamentos e Cardinalidade
- N:1 com rh_pessoa_vinculo (um vínculo pode ter vários eventos)
- N:1 com rh_registro_profissional (um registro pode ter vários eventos)

## Dependências
- Tabelas que dependem desta: -
| Esta tabela depende de: rh_pessoa_vinculo, rh_registro_profissional

## Fluxo de utilização dentro do sistema
- Registrado automaticamente quando ocorre evento no módulo RH
- Permite auditoria completa de mudanças em vínculos
- Payload JSON permite armazenar dados estruturados do evento
- Integrado ao sistema de gestão de pessoas
# cat_evento

Objetivo: Registrar eventos genéricos de mudança de estado em processos auxiliares.
Descrição: Tabela que registra eventos diversos no sistema, permitindo rastrear mudanças em processos com suporte a payload JSON.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_cat_evento | bigint | NOT NULL | - | Identificador único do evento, chave primária auto incrementada. |
| id_cat | bigint | NOT NULL | - | Referência ao registro auxiliar associado ao evento. |
| id_sessao_usuario | bigint | NOT NULL | - | Referência à sessão do usuário que realizou a ação. |
| evento | varchar(50) | NOT NULL | - | Tipo do evento registrado (ex: STATUS_MUDANCA, APPROVAÇÃO). |
| payload_json | json | Nullable | - | Payload com dados do evento em formato JSON. |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Timestamp do evento. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) à qual o evento pertence. |

## Chaves
- Primária: id_cat_evento
- Únicas: nenhuma
- Estrangeiras: nenhuma

## Índices
- PRIMARY KEY (id_cat_evento)
- KEY ix_cat_evento_cat (id_cat)
- KEY ix_cat_evento_evt (evento)

## Constraints
- PRIMARY KEY: id_cat_evento

## Relacionamentos e Cardinalidade
- N:1 com registro auxiliar (id_cat) - genérico
- N:1 com sessao_usuario (id_sessao_usuario)
- N:1 com saas_entidade (id_entidade)

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: sessao_usuario, saas_entidade

## Fluxo de utilização dentro do sistema
- Registrada para eventos genéricos de processos auxiliares
- Payload JSON permite armazenar dados estruturados do evento
- Usada para auditoria de processos que não têm tabela específica
- Evento pode ser filtrado por tipo para análise específica
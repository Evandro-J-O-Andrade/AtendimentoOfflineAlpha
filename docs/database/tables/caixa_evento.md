# caixa_evento

Objetivo: Registrar eventos ocorridos durante o ciclo de vida de um caixa.
Descrição: Tabela que armazena eventos relacionados a um caixa, como abertura, fechamento, movimentações e outras operações.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_evento | bigint | NOT NULL | - | Identificador único do evento, chave primária auto incrementada. |
| id_caixa | bigint | NOT NULL | - | Referência ao caixa onde o evento ocorreu. |
| tipo | varchar(40) | NOT NULL | - | Tipo do evento (ex: ABERTURA, FECHAMENTO, MOVIMENTACAO, SANGRIA). |
| descricao | text | Nullable | - | Descrição detalhada do evento. |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Timestamp do evento. |
| id_usuario | bigint | Nullable | - | Referência ao usuário que realizou o evento. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) à qual o evento pertence. |

## Chaves
- Primária: id_evento
- Únicas: nenhuma
- Estrangeiras: nenhuma

## Índices
- PRIMARY KEY (id_evento)
- KEY idx_ce_caixa (id_caixa, criado_em)

## Constraints
- PRIMARY KEY: id_evento

## Relacionamentos e Cardinalidade
- N:1 com caixa (id_caixa) - muitos eventos podem ocorrer a um caixa
- N:1 com usuario (id_usuario) - opcional
- N:1 com saas_entidade (id_entidade)

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: caixa, usuario, saas_entidade

## Fluxo de utilização dentro do sistema
- Registrado automaticamente em cada operação no caixa
- Usado para manter histórico completo de um caixa
- Permite auditoria de fechamentos e movimentações
- Tipo e descrição permitem classificação e busca de eventos específicos
# internacao_historico

Objetivo: Manter histórico imutável de eventos da internação.

Descrição: Tabela de auditoria que registra eventos históricos da internação de forma imutável, como entrada, troca de leito, alta, transferência e óbito. Utilizada para rastrear todas as mudanças no histórico da internação.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id | bigint | NOT NULL | - | Identificador único do histórico, chave primária auto incrementada |
| id_internacao | bigint | NOT NULL | - | Referência à internação ao qual o evento pertence |
| evento | enum('ENTRADA','TROCA_LEITO','ALTA','TRANSFERENCIA','OBITO') | NOT NULL | - | Tipo de evento: entrada, troca de leito, alta, transferência ou óbito |
| descricao | text | DEFAULT NULL | - | Descrição detalhada do evento |
| id_usuario | bigint | DEFAULT NULL | - | Referência ao usuário que realizou o evento |
| criado_em | datetime | DEFAULT CURRENT_TIMESTAMP | - | Data e hora do evento |
| id_sessao_usuario | bigint | DEFAULT NULL | - | Referência à sessão do usuário |
| id_local_operacional | bigint | DEFAULT NULL | - | Referência ao local operacional do evento |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id
- Únicas: -
- Estrangeiras: -

## Índices
- idx_internacao (id_internacao)
- idx_intern_hist_internacao_data (id_internacao, criado_em)

## Constraints
- -

## Relacionamentos e Cardinalidade
- internacao_historico.id_internacao → internacao (id_internacao): N:1 (vários eventos podem referenciar a mesma internação)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: internacao

## Fluxo de utilização dentro do sistema
1. A cada mudança significativa na internação, um evento é registrado
2. evento define o tipo de mudança (ENTRADA, ALTA, etc)
3. descricao fornece detalhes sobre o evento
4. Histórico é mantido de forma imutável
5. Índice permite busca por internação e data
6. Não possui FK para permitir auditoria mesmo após exclusões
# fila_operacional_evento

Objetivo: Registrar eventos históricos das filas operacionais.

Descrição: Tabela de auditoria que armazena eventos ocorridos nas filas operacionais, como mudanças de status, início, término e outras transições, mantendo histórico imutável das ações realizadas por usuários no fluxo das filas.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_evento | bigint | NOT NULL | - | Identificador único do evento, chave primária auto incrementada |
| id_fila | bigint | NOT NULL | - | Referência à fila operacional à qual o evento pertence |
| id_sessao_usuario | bigint | NOT NULL | - | Referência à sessão do usuário que realizou a ação |
| tipo_evento | varchar(64) | NOT NULL | - | Tipo de evento ocorrido na fila (ex: status change, início, término) |
| detalhe | text | DEFAULT NULL | - | Detalhes complementares sobre o evento |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data e hora de criação do registro do evento |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id_evento
- Únicas: -
- Estrangeiras: fk_filaop_evt_fila (id_fila → fila_operacional.id_fila); fk_filaop_evt_sessao (id_sessao_usuario → sessao_usuario.id_sessao_usuario)

## Índices
- idx_filaop_evt_fila (id_fila)
- idx_filaop_evt_sessao (id_sessao_usuario)

## Constraints
- CONSTRAINT fk_filaop_evt_fila FOREIGN KEY (id_fila) REFERENCES fila_operacional (id_fila)
- CONSTRAINT fk_filaop_evt_sessao FOREIGN KEY (id_sessao_usuario) REFERENCES sessao_usuario (id_sessao_usuario)

## Relacionamentos e Cardinalidade
- fila_operacional_evento.id_fila → fila_operacional (id_fila): N:1 (vários eventos podem referenciar a mesma fila)
- fila_operacional_evento.id_sessao_usuario → sessao_usuario (id_sessao_usuario): N:1 (vários eventos podem referenciar a mesma sessão)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: fila_operacional, sessao_usuario

## Fluxo de utilização dentro do sistema
1. A cada mudança na fila operacional, um evento é registrado
2. Usuário logado em sessão realiza ação (iniciar, finalizar, mudar status)
3. Tipo de evento e detalhes são armazenados para auditoria
4. Histórico é mantido para rastrear todas as transições da fila
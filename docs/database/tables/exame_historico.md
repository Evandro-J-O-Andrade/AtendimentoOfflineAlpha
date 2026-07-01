# exame_historico

Objetivo: Gestão de exames médicos, pedidos e laudos

Descrição: Registra o histórico de eventos de pedidos de exame (solicitação, coleta, recebimento, laudo, cancelamento) com usuário e timestamp.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id | bigint AUTO_INCREMENT | NO | — | Campo do registro |
| id_pedido | bigint | NO | — | Identificador do pedido |
| evento | enum('SOLICITACAO','COLETA','RECEBIMENTO','LAUDO','CANCELAMENTO') | NO | — | Campo do registro |
| descricao | text | YES | — | Descrição textual do registro |
| id_usuario | bigint | NO | — | Identificador único de usuario |
| criado_em | datetime | YES | CURRENT_TIMESTAMP | Data e hora do registro |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id
- Estrangeira (fk_hist_exame_pedido): coluna id_pedido -> tabela exame_pedido(id_pedido): Referencia a tabela exame_pedido (coluna id_pedido) para garantir integridade referencial

## Indices

- idx_pedido_hist (id_pedido)

## Constraints

- FOREIGN KEY fk_hist_exame_pedido: id_pedido references exame_pedido(id_pedido)
- PRIMARY KEY (id)

## Relacionamentos e Cardinalidade

- exame_historico (1) -> exame_pedido (1): campo id_pedido

## Dependencias

- Depende de:
  - exame_pedido
- Dependencias diretas: Nenhuma tabela listada depende diretamente desta tabela com base nas FKs encontradas.

## Fluxo de utilizacao dentro do sistema

- Tabela componente do módulo de atendimento e faturamento hospitalar.
- Utilizada para persistência e consulta de dados específicos do domínio.
- Associada a operações de cadastro, evolução e faturamento.
- Integrada com fluxos de auditoria e sincronização.

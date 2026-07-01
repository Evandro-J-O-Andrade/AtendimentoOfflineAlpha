# exame_pedido

Objetivo: Gestão de exames médicos, pedidos e laudos

Descrição: Pedido de exame com herança completa de atendimento e FFA, permitindo rastreamento de status, solicitante e vínculos assistenciais.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id_pedido | bigint AUTO_INCREMENT | NO | — | Identificador do pedido |
| codigo_interno | varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | NO | — | Código interno sequencial do pedido |
| id_senha | bigint | NO | — | Identificador da senha de atendimento |
| id_ffa | bigint | NO | — | Identificador do fluxo de atendimento ambulatorial |
| id_atendimento | bigint unsigned | NO | — | Identificador do atendimento |
| status | enum('SOLICITADO','COLETADO','EM_LABORATORIO','FINALIZADO','CANCELADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | YES | 'SOLICITADO' | Status atual conforme enumeração definida |
| id_usuario_solicitante | bigint | NO | — | Identificador único de usuario solicitante |
| criado_em | datetime | YES | CURRENT_TIMESTAMP | Data e hora do registro |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id_pedido
- Unica (codigo_interno): codigo_interno

## Indices

- fk_exame_senha (id_senha)
- fk_exame_ffa (id_ffa)
- fk_exame_atendimento (id_atendimento)

## Constraints

- UNIQUE KEY codigo_interno (codigo_interno)
- PRIMARY KEY (id_pedido)

## Relacionamentos e Cardinalidade


## Dependencias

- Dependencias diretas: Nenhuma tabela listada depende diretamente desta tabela com base nas FKs encontradas.

## Fluxo de utilizacao dentro do sistema

- Tabela componente do módulo de atendimento e faturamento hospitalar.
- Utilizada para persistência e consulta de dados específicos do domínio.
- Associada a operações de cadastro, evolução e faturamento.
- Integrada com fluxos de auditoria e sincronização.

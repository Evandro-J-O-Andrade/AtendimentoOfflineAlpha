# farmacia_externo_evento

Objetivo: Registro de eventos e fluxos do sistema

Descrição: Registra eventos operacionais de farmácia para atendimentos externos, permitindo rastreamento de ações e ocorrências.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id_evento | bigint AUTO_INCREMENT | NO | — | Identificador único de evento |
| id_atendimento | bigint | NO | — | Identificador do atendimento |
| tipo | varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | NO | — | Endereço IP de origem da requisição |
| descricao | text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | YES | — | Descrição textual do registro |
| criado_em | datetime | NO | CURRENT_TIMESTAMP | Data e hora do registro |
| id_usuario | bigint DEFAULT | YES | NULL | Identificador único de usuario |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id_evento

## Indices

- idx_fee (id_atendimento, criado_em)

## Constraints

- PRIMARY KEY (id_evento)

## Relacionamentos e Cardinalidade


## Dependencias

- Dependencias diretas: Nenhuma tabela listada depende diretamente desta tabela com base nas FKs encontradas.

## Fluxo de utilizacao dentro do sistema

- Tabela componente do módulo de atendimento e faturamento hospitalar.
- Utilizada para persistência e consulta de dados específicos do domínio.
- Associada a operações de cadastro, evolução e faturamento.
- Integrada com fluxos de auditoria e sincronização.

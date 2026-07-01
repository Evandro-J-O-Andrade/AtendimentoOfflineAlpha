# ffa_historico_status

Objetivo: Fluxo de Atendimento Ambulatorial (FFA)

Descrição: Histórico de mudanças de status do FFA, registrando status anterior, novo status, data da mudança e usuário responsável pela ação.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id | bigint AUTO_INCREMENT | NO | — | Campo do registro |
| id_ffa | bigint | NO | — | Identificador do fluxo de atendimento ambulatorial |
| status_anterior | varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT | YES | NULL | Status atual conforme enumeração definida |
| status_novo | varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT | YES | NULL | Status atual conforme enumeração definida |
| data_mudanca | datetime | YES | CURRENT_TIMESTAMP | Data da mudança de status |
| id_usuario_acao | bigint DEFAULT | YES | NULL | Identificador único de usuario acao |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id

## Indices

- fk_hist_ffa (id_ffa)

## Constraints

- PRIMARY KEY (id)

## Relacionamentos e Cardinalidade


## Dependencias

- Dependencias diretas: Nenhuma tabela listada depende diretamente desta tabela com base nas FKs encontradas.

## Fluxo de utilizacao dentro do sistema

- Tabela componente do módulo de atendimento e faturamento hospitalar.
- Utilizada para persistência e consulta de dados específicos do domínio.
- Associada a operações de cadastro, evolução e faturamento.
- Integrada com fluxos de auditoria e sincronização.

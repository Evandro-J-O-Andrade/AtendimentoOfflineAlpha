# faturamento_evento

Objetivo: Registro de eventos e fluxos do sistema

Descrição: Auditoria humana do faturamento, registrando eventos de abertura, fechamento, reabertura e cancelamento de contas com observações.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id_evento | bigint AUTO_INCREMENT | NO | — | Identificador único de evento |
| id_conta | bigint | NO | — | Identificador único de conta |
| evento | enum('ABERTURA','FECHAMENTO','REABERTURA','CANCELAMENTO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | NO | — | Campo do registro |
| id_usuario | bigint | NO | — | Identificador único de usuario |
| observacao | text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | YES | — | Observação ou detalhe textual |
| criado_em | datetime | YES | CURRENT_TIMESTAMP | Data e hora do registro |
| id_sessao_usuario | bigint DEFAULT | YES | NULL | Identificador da sessão do usuário |
| tipo | enum('ABRIR','ADICIONAR_ITEM','CANCELAR_ITEM','FECHAR','REABRIR','CANCELAR_CONTA','OBS') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT | YES | NULL | Endereço IP de origem da requisição |
| detalhe | text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | YES | — | Campo do registro |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id_evento

## Indices

- idx_conta (id_conta)
- idx_fat_evt_sessao (id_sessao_usuario)
- idx_fat_evt_tipo (tipo)

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

# evento_limpeza

Objetivo: Registro de eventos e fluxos do sistema

Descrição: Registra eventos operacionais da equipe de limpeza, como rotinas de limpeza, reposição de higiene e intercorrências por setor.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id_evento | bigint AUTO_INCREMENT | NO | — | Identificador único de evento |
| id_setor | int | NO | — | Identificador único de setor |
| tipo_evento | enum('LIMPEZA_ROTINA','LIMPEZA_TERMINAL','REPOSICAO_HIGIENE','INTERCORRENCIA','CONTAMINACAO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | NO | — | Endereço IP de origem da requisição |
| registrado_por | bigint | NO | — | Usuário que registrou o evento |
| observacao | text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | YES | — | Observação ou detalhe textual |
| criado_em | datetime | YES | CURRENT_TIMESTAMP | Data e hora do registro |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id_evento

## Indices

- idx_setor (id_setor)

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

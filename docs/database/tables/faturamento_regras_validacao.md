# faturamento_regras_validacao

Objetivo: Gestão de contas, itens e regras de faturamento

Descrição: Validação de regras de faturamento por atendimento, verificando presença de CID, CBO e prescrição para determinar aptidão para faturar.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id | int AUTO_INCREMENT | NO | — | Campo do registro |
| id_atendimento | bigint | NO | — | Identificador do atendimento |
| possui_cid | tinyint(1) | YES | '0' | Campo do registro |
| possui_cbo | tinyint(1) | YES | '0' | Campo do registro |
| possui_prescricao | tinyint(1) | YES | '0' | Campo do registro |
| apto_para_faturar | tinyint(1) GENERATED ALWAYS AS (((0 <> `possui_cid`) and (0 <> `possui_cbo`))) STORED | YES | GENERATED | Campo do registro |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id
- Unica (uk_fatura_atend): id_atendimento

## Indices

Nenhum indice secundario adicional alem das chaves primaria, unicas e estrangeiras.

## Constraints

- UNIQUE KEY uk_fatura_atend (id_atendimento)
- PRIMARY KEY (id)

## Relacionamentos e Cardinalidade


## Dependencias

- Dependencias diretas: Nenhuma tabela listada depende diretamente desta tabela com base nas FKs encontradas.

## Fluxo de utilizacao dentro do sistema

- Tabela componente do módulo de atendimento e faturamento hospitalar.
- Utilizada para persistência e consulta de dados específicos do domínio.
- Associada a operações de cadastro, evolução e faturamento.
- Integrada com fluxos de auditoria e sincronização.

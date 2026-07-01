# faturamento_convenio

Objetivo: Gestão de contas, itens e regras de faturamento

Descrição: Registro de guias de convênio associadas a atendimentos, com número, valor, status, XML gerado e data de emissão.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id | bigint AUTO_INCREMENT | NO | — | Campo do registro |
| id_atendimento | bigint | NO | — | Identificador do atendimento |
| id_convenio | int | NO | — | Identificador único de convenio |
| numero_guia | varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT | YES | NULL | Número sequencial do documento |
| valor_total | decimal(12,2) DEFAULT | YES | NULL | Valor total calculado |
| status_guia | enum('ABERTA','ENVIADA','PAGA','GLOSADA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | YES | 'ABERTA' | Status atual conforme enumeração definida |
| xml_gerado | longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | YES | — | Conteúdo XML da guia de convênio gerada |
| data_emissao | datetime | YES | CURRENT_TIMESTAMP | Data e hora do registro |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id

## Indices

Nenhum indice secundario adicional alem das chaves primaria, unicas e estrangeiras.

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

# faturamento_conta

Objetivo: Gestão de contas, itens e regras de faturamento

Descrição: Conta de faturamento principal, associada a FFA ou internação, com status, valores monetários, competência e trilha de auditoria.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id_conta | bigint AUTO_INCREMENT | NO | — | Identificador único de conta |
| tipo_conta | enum('FFA','INTERNACAO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | NO | — | Endereço IP de origem da requisição |
| id_ffa | bigint DEFAULT | YES | NULL | Identificador do fluxo de atendimento ambulatorial |
| id_internacao | bigint DEFAULT | YES | NULL | Identificador da internação |
| status | enum('ABERTA','EM_REVISAO','EM_AUDITORIA','FECHADA','CANCELADA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | NO | 'ABERTA' | Status atual conforme enumeração definida |
| valor_total | decimal(12,2) | YES | '0.00' | Valor total calculado |
| aberta_em | datetime | YES | CURRENT_TIMESTAMP | Data e hora do registro |
| fechada_em | datetime DEFAULT | YES | NULL | Data e hora do registro |
| fechado_por | bigint DEFAULT | YES | NULL | Usuário responsável pelo fechamento do registro |
| numero_conta | varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT | YES | NULL | Número sequencial do documento |
| competencia | char(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT | YES | NULL | Competência (mês/ano) do faturamento |
| id_senha | bigint DEFAULT | YES | NULL | Identificador da senha de atendimento |
| id_unidade | bigint unsigned | NO | — | Identificador da unidade de saúde |
| id_local_operacional | bigint DEFAULT | YES | NULL | Identificador do local |
| total_bruto | decimal(10,2) | NO | '0.00' | Valor total bruto da conta |
| total_desconto | decimal(10,2) | NO | '0.00' | Valor total de descontos |
| total_liquido | decimal(10,2) | NO | '0.00' | Valor total líquido da conta |
| observacao | text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | YES | — | Observação ou detalhe textual |
| id_sessao_usuario_criacao | bigint DEFAULT | YES | NULL | Identificador da sessão do usuário |
| criado_por | bigint DEFAULT | YES | NULL | Usuário responsável pela criação |
| atualizado_em | datetime | NO | CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP | Data e hora do registro |
| cancelado_em | datetime DEFAULT | YES | NULL | Data e hora do registro |
| cancelado_por | bigint DEFAULT | YES | NULL | Usuário responsável pelo cancelamento do registro |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id_conta
- Estrangeira (fk_faturamento_conta_unidade): coluna id_unidade -> tabela unidade(id_unidade): Referencia a tabela unidade (coluna id_unidade) para garantir integridade referencial

## Indices

- fk_fat_conta_ffa (id_ffa)
- idx_fat_conta_numero (numero_conta)
- idx_fat_conta_comp (competencia)
- idx_fat_conta_senha (id_senha)
- idx_fat_conta_unidade (id_unidade)
- idx_fat_conta_local (id_local_operacional)
- idx_fat_conta_sessao_criacao (id_sessao_usuario_criacao)
- idx_fat_conta_criado_por (criado_por)
- idx_fat_conta_cancelado_por (cancelado_por)

## Constraints

- FOREIGN KEY fk_faturamento_conta_unidade: id_unidade references unidade(id_unidade)
- PRIMARY KEY (id_conta)

## Relacionamentos e Cardinalidade

- faturamento_conta (1) -> unidade (1): campo id_unidade

## Dependencias

- Depende de:
  - unidade
- Dependencias diretas: Nenhuma tabela listada depende diretamente desta tabela com base nas FKs encontradas.

## Fluxo de utilizacao dentro do sistema

- Conta de faturamento principal associada a FFA ou internação.
- Gerada automaticamente a partir de eventos assistenciais fechados.
- Permite revisão, auditoria, fechamento e cancelamento.
- Agrega itens faturáveis consolidados e alimenta relatórios e exportações SUS/TISS.

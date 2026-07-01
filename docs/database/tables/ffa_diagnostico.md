# ffa_diagnostico

Objetivo: Fluxo de Atendimento Ambulatorial (FFA)

Descrição: Diagnósticos CID-10 associados a FFA, com tipo (principal, secundário, suspeita), confirmação, observação clínica e auditoria por usuário/sessão.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id_diagnostico | bigint AUTO_INCREMENT | NO | — | Identificador do diagnóstico |
| id_ffa | bigint | NO | — | Identificador do fluxo de atendimento ambulatorial |
| id_sessao_usuario | bigint | NO | — | Identificador da sessão do usuário |
| id_usuario | bigint | NO | — | Identificador único de usuario |
| cid10 | varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT | YES | NULL | Campo do registro |
| descricao | varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT | YES | NULL | Descrição textual do registro |
| tipo | enum('PRINCIPAL','SECUNDARIO','SUSPEITA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | NO | 'PRINCIPAL' | Endereço IP de origem da requisição |
| confirmado | tinyint | NO | '0' | Flag indicando se o diagnóstico foi confirmado |
| observacao | text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | YES | — | Observação ou detalhe textual |
| criado_em | datetime | NO | CURRENT_TIMESTAMP | Data e hora do registro |
| atualizado_em | datetime | YES | CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP | Data e hora do registro |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id_diagnostico
- Unica (ux_diag_ffa_cid_tipo): id_ffa, cid10, tipo
- Estrangeira (fk_diag_usuario): coluna id_usuario -> tabela usuario(id_usuario): Referencia a tabela usuario (coluna id_usuario) para garantir integridade referencial

## Indices

- idx_diag_ffa (id_ffa)
- idx_diag_sessao (id_sessao_usuario)
- fk_diag_usuario (id_usuario)

## Constraints

- FOREIGN KEY fk_diag_usuario: id_usuario references usuario(id_usuario)
- UNIQUE KEY ux_diag_ffa_cid_tipo (id_ffa, cid10, tipo)
- PRIMARY KEY (id_diagnostico)

## Relacionamentos e Cardinalidade

- ffa_diagnostico (1) -> usuario (1): campo id_usuario

## Dependencias

- Depende de:
  - usuario
- Dependencias diretas: Nenhuma tabela listada depende diretamente desta tabela com base nas FKs encontradas.

## Fluxo de utilizacao dentro do sistema

- Tabela componente do módulo de atendimento e faturamento hospitalar.
- Utilizada para persistência e consulta de dados específicos do domínio.
- Associada a operações de cadastro, evolução e faturamento.
- Integrada com fluxos de auditoria e sincronização.

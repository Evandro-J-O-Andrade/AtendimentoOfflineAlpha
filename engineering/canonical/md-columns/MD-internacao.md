# MD-internacao-colunas — Colunas

## Tabela: `internacao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_internacao` | bigint | NOT NULL AUTO_INCREMENT |
| `id_ffa` | bigint | NOT NULL |
| `id_leito` | int | DEFAULT NULL |
| `tipo` | enum('OBSERVACAO','INTERNACAO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `motivo` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `status` | enum('ATIVA','ENCERRADA','TRANSFERIDA','OBITO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'ATIVA' |
| `data_entrada` | datetime | NOT NULL |
| `id_usuario_entrada` | bigint | DEFAULT NULL |
| `data_saida` | datetime | DEFAULT NULL |
| `id_usuario_saida` | bigint | DEFAULT NULL |
| `motivo_alta` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `encerrado_em` | datetime | DEFAULT NULL |
| `precaucao` | enum('PADRAO','CONTATO','GOTICULAS','AEROSSOIS') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'PADRAO' |
| `previsao_alta` | datetime | DEFAULT NULL |
| `id_medico_responsavel` | bigint | DEFAULT NULL |
| `id_sessao_usuario_entrada` | bigint | DEFAULT NULL |
| `id_sessao_usuario_saida` | bigint | DEFAULT NULL |
| `id_local_operacional_entrada` | bigint | DEFAULT NULL |
| `id_local_operacional_saida` | bigint | DEFAULT NULL |
| `id_unidade_entrada` | bigint | DEFAULT NULL |
| `id_unidade_saida` | bigint | DEFAULT NULL |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_internacao`),
KEY `idx_ffa` (`id_ffa`),
KEY `idx_status` (`status`),
KEY `idx_leito` (`id_leito`),
KEY `idx_internacao_ffa_status` (`id_ffa`,`status`),
KEY `idx_internacao_leito_status` (`id_leito`,`status`),
KEY `idx_internacao_datas` (`data_entrada`,`data_saida`),
KEY `idx_internacao_status_data` (`status`,`data_entrada`,`data_saida`),
KEY `fk_internacao_atendimento` (`id_atendimento`),
KEY `idx_int_ent` (`id_entidade`),
CONSTRAINT `fk_internacao_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_internacao_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`),
CONSTRAINT `fk_internacao_leito` FOREIGN KEY (`id_leito`) REFERENCES `leito` (`id_leito`)
/*!40000 ALTER TABLE `internacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `internacao` ENABLE KEYS */;

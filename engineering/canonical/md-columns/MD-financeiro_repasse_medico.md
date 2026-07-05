# MD-financeiro_repasse_medico-colunas — Colunas

## Tabela: `financeiro_repasse_medico`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_usuario_medico` | bigint | NOT NULL |
| `id_atendimento` | bigint | NOT NULL |
| `valor_procedimento` | decimal(10,2) | DEFAULT NULL |
| `percentual_repasse` | decimal(5,2) | DEFAULT '100.00' |
| `valor_final_medico` | decimal(10,2) | DEFAULT NULL |
| `status_pagamento` | enum('PREVIA','APROVADO','PAGO','GLOSADO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'PREVIA' |
| `data_competencia` | date | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `idx_repasse_medico` (`id_usuario_medico`,`data_competencia`),
KEY `idx_financeiro_competencia` (`data_competencia`,`status_pagamento`)
/*!40000 ALTER TABLE `financeiro_repasse_medico` DISABLE KEYS */;
/*!40000 ALTER TABLE `financeiro_repasse_medico` ENABLE KEYS */;

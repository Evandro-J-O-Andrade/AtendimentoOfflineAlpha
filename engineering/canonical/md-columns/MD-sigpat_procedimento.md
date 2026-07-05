# MD-sigpat_procedimento-colunas — Colunas

## Tabela: `sigpat_procedimento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_sigpat` | bigint | NOT NULL AUTO_INCREMENT |
| `codigo` | varchar(20) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `descricao` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `tipo` | enum('EXAME','PROCEDIMENTO','CONSULTA','OUTRO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `grupo` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `subgrupo` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `setor_execucao` | enum('RX','LABORATORIO','ECG','MEDICACAO','AMBULATORIO','OUTRO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'OUTRO' |
| `gera_faturamento` | tinyint(1) | DEFAULT '1' |
| `exige_coleta` | tinyint(1) | DEFAULT '0' |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_sigpat`),
UNIQUE KEY `uk_sigpat_codigo` (`codigo`)
/*!40000 ALTER TABLE `sigpat_procedimento` DISABLE KEYS */;
/*!40000 ALTER TABLE `sigpat_procedimento` ENABLE KEYS */;

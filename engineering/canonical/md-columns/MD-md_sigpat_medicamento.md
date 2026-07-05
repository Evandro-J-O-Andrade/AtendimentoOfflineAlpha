# MD-md_sigpat_medicamento-colunas — Colunas

## Tabela: `md_sigpat_medicamento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `competencia` | char(6) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `codigo` | varchar(20) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `descricao` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `apresentacao` | varchar(160) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `forma_farmaceutica` | varchar(80) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `concentracao` | varchar(60) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `unidade_medida` | varchar(30) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `via_administracao` | varchar(60) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `ativo` | tinyint(1) | NOT NULL DEFAULT '1' |
| `atualizado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`competencia`,`codigo`),
KEY `idx_sigpat_codigo` (`codigo`),
KEY `idx_sigpat_comp` (`competencia`),
KEY `idx_sigpat_desc` (`descricao`)
/*!40000 ALTER TABLE `md_sigpat_medicamento` DISABLE KEYS */;
/*!40000 ALTER TABLE `md_sigpat_medicamento` ENABLE KEYS */;

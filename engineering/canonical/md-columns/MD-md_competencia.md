# MD-md_competencia-colunas — Colunas

## Tabela: `md_competencia`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `competencia` | char(6) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `descricao` | varchar(80) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `dt_inicio` | date | DEFAULT NULL |
| `dt_fim` | date | DEFAULT NULL |
| `ativa` | tinyint(1) | NOT NULL DEFAULT '1' |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`competencia`)
/*!40000 ALTER TABLE `md_competencia` DISABLE KEYS */;
/*!40000 ALTER TABLE `md_competencia` ENABLE KEYS */;

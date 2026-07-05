# MD-faturamento_sus_config-colunas — Colunas

## Tabela: `faturamento_sus_config`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | int | NOT NULL AUTO_INCREMENT |
| `id_unidade` | bigint | unsigned DEFAULT NULL |
| `cnes_unidade` | varchar(20) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `gestao_municipal_estadual` | enum('M','E') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`)
/*!40000 ALTER TABLE `faturamento_sus_config` DISABLE KEYS */;
/*!40000 ALTER TABLE `faturamento_sus_config` ENABLE KEYS */;

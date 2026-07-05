# MD-regra_timeout-colunas — Colunas

## Tabela: `regra_timeout`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `status` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `minutos` | int | DEFAULT NULL |
| `evento_timeout` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

/*!40000 ALTER TABLE `regra_timeout` DISABLE KEYS */;
/*!40000 ALTER TABLE `regra_timeout` ENABLE KEYS */;

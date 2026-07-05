# MD-operacao_idempotencia-colunas — Colunas

## Tabela: `operacao_idempotencia`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `token` | varchar(128) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `procedimento` | varchar(120) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `referencia_id` | bigint | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `resultado` | json | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`token`)
/*!40000 ALTER TABLE `operacao_idempotencia` DISABLE KEYS */;
/*!40000 ALTER TABLE `operacao_idempotencia` ENABLE KEYS */;

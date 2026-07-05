# MD-faturamento_insumo-colunas — Colunas

## Tabela: `faturamento_insumo`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_fat_insumo` | bigint | NOT NULL AUTO_INCREMENT |
| `id_item` | bigint | NOT NULL |
| `origem` | enum('FARMACIA','ALMOXARIFADO','MANUTENCAO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `id_produto` | bigint | NOT NULL |
| `lote` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `validade` | date | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_fat_insumo`),
KEY `idx_item` (`id_item`)
/*!40000 ALTER TABLE `faturamento_insumo` DISABLE KEYS */;
/*!40000 ALTER TABLE `faturamento_insumo` ENABLE KEYS */;

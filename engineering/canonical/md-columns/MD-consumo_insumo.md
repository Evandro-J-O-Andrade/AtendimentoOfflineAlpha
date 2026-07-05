# MD-consumo_insumo-colunas — Colunas

## Tabela: `consumo_insumo`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_consumo` | bigint | NOT NULL AUTO_INCREMENT |
| `id_ffa` | bigint | NOT NULL |
| `origem` | enum('FARMACIA','ALMOXARIFADO','MANUTENCAO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `id_produto` | bigint | NOT NULL |
| `quantidade` | decimal(10,2) | NOT NULL |
| `usado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `registrado_por` | bigint | NOT NULL |
| `observacao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_consumo`),
KEY `idx_ffa` (`id_ffa`),
KEY `idx_origem` (`origem`)
/*!40000 ALTER TABLE `consumo_insumo` DISABLE KEYS */;
/*!40000 ALTER TABLE `consumo_insumo` ENABLE KEYS */;

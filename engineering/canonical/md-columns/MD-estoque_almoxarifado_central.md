# MD-estoque_almoxarifado_central-colunas — Colunas

## Tabela: `estoque_almoxarifado_central`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_produto` | int | NOT NULL |
| `lote` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `validade` | date | NOT NULL |
| `quantidade_atual` | decimal(12,4) | NOT NULL |
| `valor_unitario_compra` | decimal(12,4) | DEFAULT NULL |
| `id_fornecedor` | int | DEFAULT NULL |
| `nota_fiscal` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `data_entrada` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`)
/*!40000 ALTER TABLE `estoque_almoxarifado_central` DISABLE KEYS */;
/*!40000 ALTER TABLE `estoque_almoxarifado_central` ENABLE KEYS */;

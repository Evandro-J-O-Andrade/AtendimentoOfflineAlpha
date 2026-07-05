# MD-farm_dispensacao_item-colunas — Colunas

## Tabela: `farm_dispensacao_item`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_item` | bigint | NOT NULL AUTO_INCREMENT |
| `id_dispensacao` | bigint | NOT NULL |
| `id_produto` | bigint | NOT NULL |
| `lote` | bigint | DEFAULT NULL |
| `quantidade` | decimal(12,3) | NOT NULL |
| `valor_unitario` | decimal(12,2) | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_item`),
KEY `fk_item_dispensacao` (`id_dispensacao`),
KEY `fk_farm_disp_item_estoque_lote` (`lote`),
CONSTRAINT `fk_disp_item_lote` FOREIGN KEY (`lote`) REFERENCES `estoque_lote` (`id_lote`),
CONSTRAINT `fk_farm_disp_item_estoque_lote` FOREIGN KEY (`lote`) REFERENCES `estoque_lote` (`id_lote`),
CONSTRAINT `fk_item_dispensacao` FOREIGN KEY (`id_dispensacao`) REFERENCES `farm_dispensacao` (`id_dispensacao`)
/*!40000 ALTER TABLE `farm_dispensacao_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `farm_dispensacao_item` ENABLE KEYS */;

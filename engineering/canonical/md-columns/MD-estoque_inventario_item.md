# MD-estoque_inventario_item-colunas — Colunas

## Tabela: `estoque_inventario_item`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_item` | bigint | NOT NULL AUTO_INCREMENT |
| `id_inventario` | bigint | NOT NULL |
| `id_produto` | bigint | NOT NULL |
| `id_lote` | bigint | DEFAULT NULL |
| `qtd_sistema` | decimal(14,3) | NOT NULL DEFAULT '0.000' |
| `qtd_contada` | decimal(14,3) | DEFAULT NULL |
| `divergencia` | decimal(14,3) | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_item`),
KEY `ix_inv_item_inv` (`id_inventario`),
KEY `ix_inv_item_prod` (`id_produto`)
/*!40000 ALTER TABLE `estoque_inventario_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `estoque_inventario_item` ENABLE KEYS */;

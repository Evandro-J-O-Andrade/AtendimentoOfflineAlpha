# MD-pdv_venda_item-colunas — Colunas

## Tabela: `pdv_venda_item`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_item` | bigint | NOT NULL AUTO_INCREMENT |
| `id_venda` | bigint | NOT NULL |
| `id_produto` | bigint | NOT NULL |
| `id_lote` | bigint | DEFAULT NULL |
| `quantidade` | decimal(14,3) | NOT NULL |
| `valor_unitario` | decimal(14,4) | NOT NULL |
| `valor_total` | decimal(14,2) | NOT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_item`),
KEY `ix_venda_item_venda` (`id_venda`),
KEY `ix_venda_item_prod` (`id_produto`),
KEY `fk_pdv_item_lote` (`id_lote`),
CONSTRAINT `fk_pdv_item_lote` FOREIGN KEY (`id_lote`) REFERENCES `estoque_lote` (`id_lote`) ON DELETE SET NULL ON UPDATE CASCADE,
CONSTRAINT `fk_pdv_item_prod` FOREIGN KEY (`id_produto`) REFERENCES `estoque_produto` (`id_produto`) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT `fk_pdv_item_venda` FOREIGN KEY (`id_venda`) REFERENCES `pdv_venda` (`id_venda`) ON DELETE CASCADE ON UPDATE CASCADE
/*!40000 ALTER TABLE `pdv_venda_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `pdv_venda_item` ENABLE KEYS */;

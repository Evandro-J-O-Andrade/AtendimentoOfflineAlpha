# MD-estoque_movimento_item-colunas — Colunas

## Tabela: `estoque_movimento_item`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_movimento_item` | bigint | NOT NULL AUTO_INCREMENT |
| `id_movimento` | bigint | NOT NULL |
| `id_produto` | bigint | NOT NULL |
| `id_lote` | bigint | NOT NULL |
| `quantidade` | decimal(15,4) | NOT NULL |
| `valor_unitario` | decimal(15,6) | NOT NULL DEFAULT '0.000000' |
| `id_ffa_item` | bigint | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_movimento_item`),
KEY `fk_item_mov` (`id_movimento`),
KEY `idx_item_produto` (`id_produto`),
KEY `idx_item_lote` (`id_lote`),
CONSTRAINT `fk_item_mov` FOREIGN KEY (`id_movimento`) REFERENCES `estoque_movimento` (`id_movimento`)
/*!40000 ALTER TABLE `estoque_movimento_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `estoque_movimento_item` ENABLE KEYS */;

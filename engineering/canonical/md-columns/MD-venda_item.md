# MD-venda_item-colunas — Colunas

## Tabela: `venda_item`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_venda_item` | bigint | NOT NULL AUTO_INCREMENT |
| `id_venda` | bigint | NOT NULL |
| `id_farmaco` | bigint | DEFAULT NULL |
| `id_lote` | bigint | DEFAULT NULL |
| `id_local_estoque` | bigint | DEFAULT NULL |
| `descricao` | varchar(255) | NOT NULL |
| `quantidade` | int | NOT NULL |
| `valor_unitario` | decimal(10,2) | NOT NULL |
| `desconto` | decimal(10,2) | NOT NULL DEFAULT '0.00' |
| `total_linha` | decimal(10,2) | NOT NULL DEFAULT '0.00' |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_venda_item`),
KEY `idx_vi_venda` (`id_venda`),
KEY `idx_vi_farmaco` (`id_farmaco`,`id_lote`),
KEY `fk_vi_lote` (`id_lote`),
CONSTRAINT `fk_vi_farmaco` FOREIGN KEY (`id_farmaco`) REFERENCES `farmaco` (`id_farmaco`),
CONSTRAINT `fk_vi_lote` FOREIGN KEY (`id_lote`) REFERENCES `farmaco_lote` (`id_lote`),
CONSTRAINT `fk_vi_venda` FOREIGN KEY (`id_venda`) REFERENCES `venda` (`id_venda`)
/*!40000 ALTER TABLE `venda_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `venda_item` ENABLE KEYS */;

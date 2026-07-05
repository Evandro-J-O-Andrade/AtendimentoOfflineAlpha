# MD-estoque_lote_snapshot-colunas — Colunas

## Tabela: `estoque_lote_snapshot`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_snapshot` | bigint | NOT NULL AUTO_INCREMENT |
| `id_lote` | bigint | NOT NULL |
| `id_movimento_item` | bigint | NOT NULL |
| `saldo_anterior` | decimal(15,4) | NOT NULL |
| `variacao` | decimal(15,4) | NOT NULL |
| `saldo_atual` | decimal(15,4) | NOT NULL |
| `hash_anterior` | char(64) | DEFAULT NULL |
| `hash_atual` | char(64) | NOT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_snapshot`),
KEY `fk_snap_lote` (`id_lote`),
KEY `fk_snap_mov_item` (`id_movimento_item`),
CONSTRAINT `fk_snap_lote` FOREIGN KEY (`id_lote`) REFERENCES `estoque_lote` (`id_lote`),
CONSTRAINT `fk_snap_mov_item` FOREIGN KEY (`id_movimento_item`) REFERENCES `estoque_movimento_item` (`id_movimento_item`)
/*!40000 ALTER TABLE `estoque_lote_snapshot` DISABLE KEYS */;
/*!40000 ALTER TABLE `estoque_lote_snapshot` ENABLE KEYS */;

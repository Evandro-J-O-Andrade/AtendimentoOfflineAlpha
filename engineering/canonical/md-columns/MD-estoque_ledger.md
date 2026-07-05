# MD-estoque_ledger-colunas — Colunas

## Tabela: `estoque_ledger`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_ledger` | bigint | NOT NULL AUTO_INCREMENT |
| `id_movimento_item` | bigint | NOT NULL |
| `id_conta` | bigint | NOT NULL |
| `id_lote` | bigint | NOT NULL |
| `tipo_dc` | enum('D','C') | NOT NULL |
| `quantidade` | decimal(15,4) | NOT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_ledger`),
KEY `fk_ledger_mov_item` (`id_movimento_item`),
KEY `idx_ledger_lote` (`id_lote`),
KEY `idx_ledger_conta` (`id_conta`),
CONSTRAINT `fk_ledger_conta` FOREIGN KEY (`id_conta`) REFERENCES `estoque_conta` (`id_conta`),
CONSTRAINT `fk_ledger_mov_item` FOREIGN KEY (`id_movimento_item`) REFERENCES `estoque_movimento_item` (`id_movimento_item`)
/*!40000 ALTER TABLE `estoque_ledger` DISABLE KEYS */;
/*!40000 ALTER TABLE `estoque_ledger` ENABLE KEYS */;

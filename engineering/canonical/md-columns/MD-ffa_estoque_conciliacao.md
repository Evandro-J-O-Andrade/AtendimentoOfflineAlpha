# MD-ffa_estoque_conciliacao-colunas — Colunas

## Tabela: `ffa_estoque_conciliacao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_conciliacao` | bigint | NOT NULL AUTO_INCREMENT |
| `id_ffa_item` | bigint | NOT NULL |
| `id_movimento_item` | bigint | NOT NULL |
| `valor_faturado` | decimal(15,6) | DEFAULT NULL |
| `valor_custo` | decimal(15,6) | DEFAULT NULL |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_conciliacao`)
/*!40000 ALTER TABLE `ffa_estoque_conciliacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `ffa_estoque_conciliacao` ENABLE KEYS */;

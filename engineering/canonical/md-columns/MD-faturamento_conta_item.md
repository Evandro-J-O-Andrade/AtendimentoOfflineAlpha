# MD-faturamento_conta_item-colunas — Colunas

## Tabela: `faturamento_conta_item`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_conta` | bigint | NOT NULL |
| `id_item` | bigint | NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`)
/*!40000 ALTER TABLE `faturamento_conta_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `faturamento_conta_item` ENABLE KEYS */;

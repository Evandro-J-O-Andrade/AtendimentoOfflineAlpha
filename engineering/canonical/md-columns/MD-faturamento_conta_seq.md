# MD-faturamento_conta_seq-colunas — Colunas

## Tabela: `faturamento_conta_seq`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_usuario` | bigint | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`)
/*!40000 ALTER TABLE `faturamento_conta_seq` DISABLE KEYS */;
/*!40000 ALTER TABLE `faturamento_conta_seq` ENABLE KEYS */;

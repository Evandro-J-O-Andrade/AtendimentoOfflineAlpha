# MD-faturamento_convenios-colunas — Colunas

## Tabela: `faturamento_convenios`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | int | NOT NULL AUTO_INCREMENT |
| `nome_fantasia` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `registro_ans` | varchar(20) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `id_tabela_precos` | int | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`)
/*!40000 ALTER TABLE `faturamento_convenios` DISABLE KEYS */;
/*!40000 ALTER TABLE `faturamento_convenios` ENABLE KEYS */;

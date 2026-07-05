# MD-procedimentos_sigtap-colunas — Colunas

## Tabela: `procedimentos_sigtap`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `codigo_procedimento` | varchar(10) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `nome_procedimento` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `valor_sus` | decimal(10,2) | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`codigo_procedimento`)
/*!40000 ALTER TABLE `procedimentos_sigtap` DISABLE KEYS */;
/*!40000 ALTER TABLE `procedimentos_sigtap` ENABLE KEYS */;

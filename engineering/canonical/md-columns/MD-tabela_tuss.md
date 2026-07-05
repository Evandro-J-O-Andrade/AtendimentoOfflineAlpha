# MD-tabela_tuss-colunas — Colunas

## Tabela: `tabela_tuss`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `codigo_tuss` | varchar(20) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `descricao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `valor_honorario` | decimal(10,2) | DEFAULT NULL |
| `valor_custo_operacional` | decimal(10,2) | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`codigo_tuss`)
/*!40000 ALTER TABLE `tabela_tuss` DISABLE KEYS */;
/*!40000 ALTER TABLE `tabela_tuss` ENABLE KEYS */;

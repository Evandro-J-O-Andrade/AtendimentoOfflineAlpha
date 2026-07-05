# MD-faturamento_sigtap-colunas — Colunas

## Tabela: `faturamento_sigtap`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | int | NOT NULL AUTO_INCREMENT |
| `codigo_procedimento` | varchar(10) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `nome_procedimento` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `valor_sh` | decimal(10,2) | DEFAULT NULL |
| `valor_sa` | decimal(10,2) | DEFAULT NULL |
| `complexidade` | enum('BASICA','MEDIA','ALTA') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
UNIQUE KEY `uk_sigtap_cod` (`codigo_procedimento`)
/*!40000 ALTER TABLE `faturamento_sigtap` DISABLE KEYS */;
/*!40000 ALTER TABLE `faturamento_sigtap` ENABLE KEYS */;

# MD-logradouro-colunas — Colunas

## Tabela: `logradouro`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_logradouro` | bigint | NOT NULL AUTO_INCREMENT |
| `cep` | varchar(9) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `logradouro` | varchar(200) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `numero` | varchar(20) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `complemento` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `bairro` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `cidade` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `uf` | char(2) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_logradouro`)
/*!40000 ALTER TABLE `logradouro` DISABLE KEYS */;
/*!40000 ALTER TABLE `logradouro` ENABLE KEYS */;

# MD-md_cid10-colunas — Colunas

## Tabela: `md_cid10`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `competencia` | char(6) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `codigo` | varchar(10) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `descricao` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `categoria` | varchar(10) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `subcategoria` | varchar(10) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `capitulo` | varchar(20) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `sexo_restricao` | enum('A','M','F') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'A' |
| `idade_min_meses` | int | DEFAULT NULL |
| `idade_max_meses` | int | DEFAULT NULL |
| `ativo` | tinyint(1) | NOT NULL DEFAULT '1' |
| `atualizado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`competencia`,`codigo`),
KEY `idx_cid10_codigo` (`codigo`),
KEY `idx_cid10_comp` (`competencia`)
/*!40000 ALTER TABLE `md_cid10` DISABLE KEYS */;
/*!40000 ALTER TABLE `md_cid10` ENABLE KEYS */;

# MD-config_sistema-colunas — Colunas

## Tabela: `config_sistema`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | int | NOT NULL AUTO_INCREMENT |
| `id_unidade` | bigint | unsigned NOT NULL |
| `parametro` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `valor` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `idx_config_unid` (`id_unidade`),
CONSTRAINT `fk_config_sistema_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
/*!40000 ALTER TABLE `config_sistema` DISABLE KEYS */;
/*!40000 ALTER TABLE `config_sistema` ENABLE KEYS */;

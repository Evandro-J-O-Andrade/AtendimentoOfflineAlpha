# MD-pessoa_alergias-colunas — Colunas

## Tabela: `pessoa_alergias`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_pessoa` | bigint | NOT NULL |
| `substancia` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `gravidade` | enum('LEVE','MODERADA','GRAVE/CHOQUE') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `registrado_por` | bigint | DEFAULT NULL |
| `data_registro` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `fk_alergia_pessoa` (`id_pessoa`),
CONSTRAINT `fk_alergia_pessoa` FOREIGN KEY (`id_pessoa`) REFERENCES `pessoa` (`id_pessoa`)
/*!40000 ALTER TABLE `pessoa_alergias` DISABLE KEYS */;
/*!40000 ALTER TABLE `pessoa_alergias` ENABLE KEYS */;

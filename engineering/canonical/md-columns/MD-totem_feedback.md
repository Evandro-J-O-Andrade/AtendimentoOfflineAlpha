# MD-totem_feedback-colunas — Colunas

## Tabela: `totem_feedback`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_feedback` | bigint | NOT NULL AUTO_INCREMENT |
| `id_senha` | bigint | DEFAULT NULL |
| `origem` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `nota` | int | DEFAULT NULL |
| `comentario` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `data_hora` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_feedback`),
KEY `fk_totem_feedback_senhas` (`id_senha`)
/*!40000 ALTER TABLE `totem_feedback` DISABLE KEYS */;
/*!40000 ALTER TABLE `totem_feedback` ENABLE KEYS */;

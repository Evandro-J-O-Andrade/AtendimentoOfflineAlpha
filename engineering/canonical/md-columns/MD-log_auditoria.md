# MD-log_auditoria-colunas — Colunas

## Tabela: `log_auditoria`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_log` | bigint | NOT NULL AUTO_INCREMENT |
| `id_usuario` | bigint | DEFAULT NULL |
| `acao` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `tabela_afetada` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `id_registro` | bigint | DEFAULT NULL |
| `antes` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `depois` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `justificativa` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `data_hora` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_log`)
/*!40000 ALTER TABLE `log_auditoria` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_auditoria` ENABLE KEYS */;

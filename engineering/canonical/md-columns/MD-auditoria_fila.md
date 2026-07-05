# MD-auditoria_fila-colunas — Colunas

## Tabela: `auditoria_fila`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_fila` | bigint | NOT NULL |
| `id_usuario` | bigint | DEFAULT NULL |
| `acao` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `timestamp` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `id_fila` (`id_fila`),
CONSTRAINT `auditoria_fila_ibfk_1` FOREIGN KEY (`id_fila`) REFERENCES `fila_senha` (`id`)
/*!40000 ALTER TABLE `auditoria_fila` DISABLE KEYS */;
/*!40000 ALTER TABLE `auditoria_fila` ENABLE KEYS */;

# MD-fila_senha-colunas — Colunas

## Tabela: `fila_senha`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_senha` | bigint | NOT NULL |
| `status` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'AGUARDANDO' |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id`),
UNIQUE KEY `uk_fila_senha_id_senha` (`id_senha`),
KEY `idx_fs_senha` (`id_senha`)
/*!40000 ALTER TABLE `fila_senha` DISABLE KEYS */;
/*!40000 ALTER TABLE `fila_senha` ENABLE KEYS */;

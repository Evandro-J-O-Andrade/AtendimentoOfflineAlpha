# MD-ffa_historico_status-colunas — Colunas

## Tabela: `ffa_historico_status`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_ffa` | bigint | NOT NULL |
| `status_anterior` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `status_novo` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `data_mudanca` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_usuario_acao` | bigint | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `fk_hist_ffa` (`id_ffa`)
/*!40000 ALTER TABLE `ffa_historico_status` DISABLE KEYS */;
/*!40000 ALTER TABLE `ffa_historico_status` ENABLE KEYS */;

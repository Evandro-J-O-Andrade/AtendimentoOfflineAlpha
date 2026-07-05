# MD-kernel_runtime_heartbeat-colunas — Colunas

## Tabela: `kernel_runtime_heartbeat`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_heartbeat` | bigint | NOT NULL AUTO_INCREMENT |
| `uuid_runtime` | char(36) | NOT NULL |
| `estado_runtime` | varchar(80) | NOT NULL |
| `ultimo_ping` | datetime(6) | NOT NULL DEFAULT CURRENT_TIMESTAMP(6) |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_heartbeat`),
UNIQUE KEY `uk_heartbeat_runtime` (`uuid_runtime`),
KEY `idx_heartbeat_estado` (`estado_runtime`)
/*!40000 ALTER TABLE `kernel_runtime_heartbeat` DISABLE KEYS */;
/*!40000 ALTER TABLE `kernel_runtime_heartbeat` ENABLE KEYS */;

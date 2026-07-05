# MD-runtime_sync_queue-colunas — Colunas

## Tabela: `runtime_sync_queue`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_queue` | bigint | NOT NULL AUTO_INCREMENT |
| `uuid_evento` | char(36) | NOT NULL |
| `tentativa_sync` | int | DEFAULT '0' |
| `proximo_retry_em` | datetime(6) | DEFAULT NULL |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_queue`),
UNIQUE KEY `uk_sync_queue_evento` (`uuid_evento`)
/*!40000 ALTER TABLE `runtime_sync_queue` DISABLE KEYS */;
/*!40000 ALTER TABLE `runtime_sync_queue` ENABLE KEYS */;

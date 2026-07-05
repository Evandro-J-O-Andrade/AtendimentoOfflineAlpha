# MD-runtime_sync_log-colunas — Colunas

## Tabela: `runtime_sync_log`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_sync` | bigint | NOT NULL AUTO_INCREMENT |
| `id_unidade` | bigint | unsigned NOT NULL |
| `uuid_evento` | char(36) | NOT NULL |
| `tipo_evento` | varchar(60) | NOT NULL |
| `estado_payload` | json | DEFAULT NULL |
| `hash_payload` | char(64) | DEFAULT NULL |
| `sincronizado` | tinyint(1) | DEFAULT '0' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_sync`),
KEY `idx_sync_unidade` (`id_unidade`),
KEY `idx_sync_uuid` (`uuid_evento`),
KEY `idx_sync_status` (`sincronizado`),
KEY `fk_runtime_sync_log_entidade` (`id_entidade`),
CONSTRAINT `fk_runtime_sync_log_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`),
CONSTRAINT `fk_runtime_sync_log_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
/*!40000 ALTER TABLE `runtime_sync_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `runtime_sync_log` ENABLE KEYS */;

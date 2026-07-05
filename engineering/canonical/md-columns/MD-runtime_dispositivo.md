# MD-runtime_dispositivo-colunas — Colunas

## Tabela: `runtime_dispositivo`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_runtime_dispositivo` | bigint | NOT NULL AUTO_INCREMENT |
| `id_dispositivo` | bigint | NOT NULL |
| `uuid_runtime` | varchar(120) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL |
| `tipo_runtime` | varchar(40) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL |
| `versao_runtime` | varchar(40) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `ip_runtime` | varchar(45) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `status_runtime` | varchar(30) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'ONLINE' |
| `ultimo_heartbeat` | datetime(6) | DEFAULT NULL |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_runtime_dispositivo`),
UNIQUE KEY `uk_runtime_uuid` (`uuid_runtime`),
KEY `fk_runtime_dispositivo` (`id_dispositivo`),
CONSTRAINT `fk_runtime_dispositivo` FOREIGN KEY (`id_dispositivo`) REFERENCES `dispositivo` (`id_dispositivo`)
/*!40000 ALTER TABLE `runtime_dispositivo` DISABLE KEYS */;
/*!40000 ALTER TABLE `runtime_dispositivo` ENABLE KEYS */;

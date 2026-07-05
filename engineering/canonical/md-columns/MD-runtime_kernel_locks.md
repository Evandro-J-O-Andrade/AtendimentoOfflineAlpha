# MD-runtime_kernel_locks-colunas — Colunas

## Tabela: `runtime_kernel_locks`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `uuid_runtime` | char(36) | NOT NULL |
| `locked_by` | int | NOT NULL |
| `acquired_at` | datetime(6) | NOT NULL |
| `expires_at` | datetime(6) | NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `idx_runtime` (`uuid_runtime`,`expires_at`)
/*!40000 ALTER TABLE `runtime_kernel_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `runtime_kernel_locks` ENABLE KEYS */;

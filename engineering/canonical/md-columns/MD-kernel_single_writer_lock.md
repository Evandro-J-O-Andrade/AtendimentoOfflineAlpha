# MD-kernel_single_writer_lock-colunas — Colunas

## Tabela: `kernel_single_writer_lock`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_lock` | bigint | NOT NULL AUTO_INCREMENT |
| `uuid_runtime` | char(36) | NOT NULL |
| `bloqueado` | tinyint(1) | DEFAULT '1' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_lock`),
UNIQUE KEY `uk_kernel_runtime` (`uuid_runtime`)
/*!40000 ALTER TABLE `kernel_single_writer_lock` DISABLE KEYS */;
/*!40000 ALTER TABLE `kernel_single_writer_lock` ENABLE KEYS */;

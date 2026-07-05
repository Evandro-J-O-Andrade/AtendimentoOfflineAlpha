# MD-local_runtime-colunas — Colunas

## Tabela: `local_runtime`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_local_runtime` | bigint | NOT NULL AUTO_INCREMENT |
| `id_local` | bigint | NOT NULL |
| `dispositivo_tipo` | varchar(40) | DEFAULT NULL |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_local_runtime`),
KEY `idx_runtime_local` (`id_local`),
CONSTRAINT `fk_runtime_local` FOREIGN KEY (`id_local`) REFERENCES `local` (`id_local`)
/*!40000 ALTER TABLE `local_runtime` DISABLE KEYS */;
/*!40000 ALTER TABLE `local_runtime` ENABLE KEYS */;

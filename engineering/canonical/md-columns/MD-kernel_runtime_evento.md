# MD-kernel_runtime_evento-colunas — Colunas

## Tabela: `kernel_runtime_evento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_evento` | bigint | NOT NULL AUTO_INCREMENT |
| `uuid_runtime` | char(36) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL |
| `id_usuario` | bigint | DEFAULT NULL |
| `tipo_evento` | varchar(80) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL |
| `entidade_alvo` | varchar(80) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `id_referencia` | bigint | DEFAULT NULL |
| `payload` | json | DEFAULT NULL |
| `hash_evento` | char(64) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_evento`),
KEY `idx_runtime_evento_uuid` (`uuid_runtime`),
KEY `idx_runtime_evento_tipo` (`tipo_evento`),
KEY `idx_runtime_evento_referencia` (`entidade_alvo`,`id_referencia`),
KEY `fk_kernel_runtime_evento_entidade` (`id_entidade`),
CONSTRAINT `fk_kernel_runtime_evento_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `kernel_runtime_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `kernel_runtime_evento` ENABLE KEYS */;
